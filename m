Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61A66BC322
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjCPBKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjCPBKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0C723320
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m13-20020a25800d000000b00b3dfeba6814so197344ybk.11
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ENrOSfUYzSj3918NRCLINtJukA07XSxVtWncxFz17Pk=;
        b=Lh48q8HoU+f6h8cyCbEYXX/dct3wfJhPRuXA4bRFNMi9er+B1glFmns5F9aUbW4Os5
         QoH612X8R1GanllLWYAuSmVU9ArUhyBM4IcKTX56LXVD837jIpNP+/D0g0HUUdPb6vfl
         wWTZV55JedGy0C2fasO3ByOqbl8i5U82f26xCFO2taa1DBYJdQLsePXYnEXBGlCEMqoa
         U3QJMXlUM6ckqbAeMiO37hTpUmxoo8rM4qp1HvOETdpaI5YreHTdpVfiFvDClhCAOydK
         qvLOTVKq0LWfXGfOXWz4fxPpYQxrXWPaXFORk4ClkLPGKU1znRb+zVPdmKC2XLocIuL+
         hsEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENrOSfUYzSj3918NRCLINtJukA07XSxVtWncxFz17Pk=;
        b=w39cBMff5+kQfq/8n2rSXB3RqnBqw0Za/ER5heOo+l5krYMNlyHsLyCNcyCeX3cjPA
         en+uFomHsFIHX7NhirX/x6mzzyeJMeNarNcMlaf6DWh8lKRYXD9NPdB2o6zK7e8oHRz5
         aUJSt4shD9HaNuiUCBZIXs2D6thMZuw9talYBOOzHD/5STyF8BM/XoFSR2VuOXUfEH6d
         xdkbBDcfLT6az5HEqshVkj/S/hszhg4847Cer1Xn9CUJzWmZ7aDriHgQxZaWXmr7IpS3
         /7bhPCq3hWHxiDobiQK2BdzuecXU6Fkn6TRQA9N1Mv/izZsYlmQP7q2taPZDBVSFTVsV
         imDQ==
X-Gm-Message-State: AO0yUKVwArEdLGUZR3Mc5KgJD3N4VdgAZX4SnMboJjSm5lYPuGdu+P3b
        iq3hFLsXZ7lsQh7MGo7soT7FXqGBHZbn9A==
X-Google-Smtp-Source: AK7set8iHFP4tHLf2oS3zWi0ooq6E6fdtuIx1/TtejAJvlvECWP5hjLuaDMP5RQuoFvP17xHSmFdlTQsxHjmtg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:68d:b0:521:daa4:d687 with SMTP
 id bp13-20020a05690c068d00b00521daa4d687mr1425291ywb.0.1678929030383; Wed, 15
 Mar 2023 18:10:30 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:11 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-7-edumazet@google.com>
Subject: [PATCH net-next 6/9] net/packet: convert po->tp_loss to an atomic flag
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tp_loss can be read locklessly.

Convert it to an atomic flag to avoid races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 6 +++---
 net/packet/diag.c      | 2 +-
 net/packet/internal.h  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 7800dc622ff37d059e43c96d2d7f293905b3d5af..119063c8a1c590b715fa570354f561bfa7df5301 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2843,7 +2843,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 		if (unlikely(tp_len < 0)) {
 tpacket_error:
-			if (po->tp_loss) {
+			if (packet_sock_flag(po, PACKET_SOCK_TP_LOSS)) {
 				__packet_set_status(po, ph,
 						TP_STATUS_AVAILABLE);
 				packet_increment_head(&po->tx_ring);
@@ -3886,7 +3886,7 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
 			ret = -EBUSY;
 		} else {
-			po->tp_loss = !!val;
+			packet_sock_flag_set(po, PACKET_SOCK_TP_LOSS, val);
 			ret = 0;
 		}
 		release_sock(sk);
@@ -4095,7 +4095,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
 		val = po->tp_reserve;
 		break;
 	case PACKET_LOSS:
-		val = po->tp_loss;
+		val = packet_sock_flag(po, PACKET_SOCK_TP_LOSS);
 		break;
 	case PACKET_TIMESTAMP:
 		val = READ_ONCE(po->tp_tstamp);
diff --git a/net/packet/diag.c b/net/packet/diag.c
index 0abca32e2f878b419814709afb8d1d5b282d0597..8bb4ce6a8e6171fef43988fe83b0adc8100fe866 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -29,7 +29,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 		pinfo.pdi_flags |= PDI_ORIGDEV;
 	if (po->has_vnet_hdr)
 		pinfo.pdi_flags |= PDI_VNETHDR;
-	if (po->tp_loss)
+	if (packet_sock_flag(po, PACKET_SOCK_TP_LOSS))
 		pinfo.pdi_flags |= PDI_LOSS;
 
 	return nla_put(nlskb, PACKET_DIAG_INFO, sizeof(pinfo), &pinfo);
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 0d16a581e27132988942bcc71da223f7c30ac00c..9d406a92ede8e917089943b39a0fe97b064599f3 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -118,8 +118,7 @@ struct packet_sock {
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
 	unsigned int		running;	/* bind_lock must be held */
-	unsigned int		has_vnet_hdr:1, /* writer must hold sock lock */
-				tp_loss:1;
+	unsigned int		has_vnet_hdr:1; /* writer must hold sock lock */
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
@@ -146,6 +145,7 @@ enum packet_sock_flags {
 	PACKET_SOCK_ORIGDEV,
 	PACKET_SOCK_AUXDATA,
 	PACKET_SOCK_TX_HAS_OFF,
+	PACKET_SOCK_TP_LOSS,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.40.0.rc2.332.ga46443480c-goog

