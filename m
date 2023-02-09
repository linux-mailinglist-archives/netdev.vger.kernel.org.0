Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC1969091F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBIMnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjBIMnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:43:22 -0500
Received: from out0-199.mail.aliyun.com (out0-199.mail.aliyun.com [140.205.0.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959125CBD3
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 04:43:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047206;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---.RGtO-Uy_1675946597;
Received: from localhost(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RGtO-Uy_1675946597)
          by smtp.aliyun-inc.com;
          Thu, 09 Feb 2023 20:43:18 +0800
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
To:     netdev@vger.kernel.org
Cc:     <willemdebruijn.kernel@gmail.com>, <mst@redhat.com>,
        <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>,
        "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
Subject: [PATCH 1/2] net/packet: add socketopt to set/get vnet_hdr_sz
Date:   Thu, 09 Feb 2023 20:43:14 +0800
Message-Id: <1675946595-103034-2-git-send-email-amy.saq@antgroup.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jianfeng Tan" <henry.tjf@antgroup.com>

Raw socket can be used as the backend for kernel vhost, like tap.
However, in current raw socket implementation, it use hardcoded virtio
net header length, which will cause error mac header parsing when some
virtio features that need virtio net header other than 10-byte are used.

By adding extra field vnet_hdr_sz in packet_sock to record virtio net
header size that current raw socket should use and supporting extra
sockopt PACKET_VNET_HDR_SZ to allow user level set specified vnet header
size to current socket, raw socket will know the exact virtio net header
size it should use instead of hardcoding to avoid incorrect header
parsing.

Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
---
 include/uapi/linux/if_packet.h |  1 +
 net/packet/af_packet.c         | 34 ++++++++++++++++++++++++++++++++++
 net/packet/internal.h          |  3 ++-
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_packet.h b/include/uapi/linux/if_packet.h
index 78c981d..9efc423 100644
--- a/include/uapi/linux/if_packet.h
+++ b/include/uapi/linux/if_packet.h
@@ -59,6 +59,7 @@ struct sockaddr_ll {
 #define PACKET_ROLLOVER_STATS		21
 #define PACKET_FANOUT_DATA		22
 #define PACKET_IGNORE_OUTGOING		23
+#define PACKET_VNET_HDR_SZ		24
 
 #define PACKET_FANOUT_HASH		0
 #define PACKET_FANOUT_LB		1
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8ffb19c..8389f18 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3936,11 +3936,42 @@ static void packet_flush_mclist(struct sock *sk)
 			ret = -EBUSY;
 		} else {
 			po->has_vnet_hdr = !!val;
+			/* set vnet_hdr_sz to default value */
+			if (po->has_vnet_hdr)
+				po->vnet_hdr_sz = sizeof(struct virtio_net_hdr);
+			else
+				po->vnet_hdr_sz = 0;
 			ret = 0;
 		}
 		release_sock(sk);
 		return ret;
 	}
+	case PACKET_VNET_HDR_SZ:
+	{
+		int val;
+
+		if (sock->type != SOCK_RAW)
+			return -EINVAL;
+		if (optlen < sizeof(val))
+			return -EINVAL;
+		if (copy_from_user(&val, optval, sizeof(val)))
+			return -EFAULT;
+
+		lock_sock(sk);
+		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
+			ret = -EBUSY;
+		} else {
+			if (val == sizeof(struct virtio_net_hdr) ||
+			    val == sizeof(struct virtio_net_hdr_mrg_rxbuf)) {
+				po->vnet_hdr_sz = val;
+				ret = 0;
+			} else {
+				ret = -EINVAL;
+			}
+		}
+		release_sock(sk);
+		return ret;
+	}
 	case PACKET_TIMESTAMP:
 	{
 		int val;
@@ -4070,6 +4101,9 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 	case PACKET_VNET_HDR:
 		val = po->has_vnet_hdr;
 		break;
+	case PACKET_VNET_HDR_SZ:
+		val = po->vnet_hdr_sz;
+		break;
 	case PACKET_VERSION:
 		val = po->tp_version;
 		break;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 48af35b..e27b47d 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -121,7 +121,8 @@ struct packet_sock {
 				origdev:1,
 				has_vnet_hdr:1,
 				tp_loss:1,
-				tp_tx_has_off:1;
+				tp_tx_has_off:1,
+				vnet_hdr_sz:8;	/* vnet header size should use */
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
-- 
1.8.3.1

