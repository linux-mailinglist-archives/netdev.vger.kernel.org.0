Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3426583339
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbiG0TML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234671AbiG0TLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:11:55 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5F765D5D;
        Wed, 27 Jul 2022 11:55:23 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 26RIsnCF027831
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Jul 2022 20:54:51 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Anton Makarov <anton.makarov11235@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v5 2/4] seg6: add support for SRv6 H.L2Encaps.Red behavior
Date:   Wed, 27 Jul 2022 20:54:06 +0200
Message-Id: <20220727185408.7077-3-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220727185408.7077-1-andrea.mayer@uniroma2.it>
References: <20220727185408.7077-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SRv6 H.L2Encaps.Red behavior described in [1] is an optimization of
the SRv6 H.L2Encaps behavior [2].

H.L2Encaps.Red reduces the length of the SRH by excluding the first
segment (SID) in the SRH of the pushed IPv6 header. The first SID is
only placed in the IPv6 Destination Address field of the pushed IPv6
header.
When the SRv6 Policy only contains one SID the SRH is omitted, unless
there is an HMAC TLV to be carried.

[1] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.4
[2] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.3

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
---
 include/uapi/linux/seg6_iptunnel.h |  1 +
 net/ipv6/seg6_iptunnel.c           | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index 538152a7b2c3..a9fa777f16de 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -36,6 +36,7 @@ enum {
 	SEG6_IPTUN_MODE_ENCAP,
 	SEG6_IPTUN_MODE_L2ENCAP,
 	SEG6_IPTUN_MODE_ENCAP_RED,
+	SEG6_IPTUN_MODE_L2ENCAP_RED,
 };
 
 #endif
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 454bd8a838e6..34db881204d2 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -40,6 +40,7 @@ static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
 		head = sizeof(struct ipv6hdr);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
 		return 0;
 	}
 
@@ -413,6 +414,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb->protocol = htons(ETH_P_IPV6);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
 		if (!skb_mac_header_was_set(skb))
 			return -EINVAL;
 
@@ -422,7 +424,13 @@ static int seg6_do_srh(struct sk_buff *skb)
 		skb_mac_header_rebuild(skb);
 		skb_push(skb, skb->mac_len);
 
-		err = seg6_do_srh_encap(skb, tinfo->srh, IPPROTO_ETHERNET);
+		if (tinfo->mode == SEG6_IPTUN_MODE_L2ENCAP)
+			err = seg6_do_srh_encap(skb, tinfo->srh,
+						IPPROTO_ETHERNET);
+		else
+			err = seg6_do_srh_encap_red(skb, tinfo->srh,
+						    IPPROTO_ETHERNET);
+
 		if (err)
 			return err;
 
@@ -643,6 +651,8 @@ static int seg6_build_state(struct net *net, struct nlattr *nla,
 		break;
 	case SEG6_IPTUN_MODE_ENCAP_RED:
 		break;
+	case SEG6_IPTUN_MODE_L2ENCAP_RED:
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.20.1

