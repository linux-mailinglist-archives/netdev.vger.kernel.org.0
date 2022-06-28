Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099AA55D244
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344212AbiF1LuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbiF1LuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:50:06 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B202BB5A
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 04:50:05 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25SBnu3Z012357
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jun 2022 13:49:56 +0200
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Anton Makarov <antonmakarov11235@gmail.com>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: [iproute2-next v1] seg6: add support for SRv6 Headend Reduced Encapsulation
Date:   Tue, 28 Jun 2022 13:49:49 +0200
Message-Id: <20220628114949.5199-1-paolo.lungaroni@uniroma2.it>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the support for the reduced version of the H.Encaps and
H.L2Encaps behaviors as defined in RFC 8986 [1].

H.Encaps.Red and H.L2Encaps.Red SRv6 behaviors are an optimization of the
H.Encaps and H.L2Encaps aiming to reduce the length of the SID List carried
in the pushed SRH. Specifically, the reduced version of the behaviors
removes the first SID contained in the SID List (i.e. SRv6 Policy) by
storing it into the IPv6 Destination Address. When SRv6 Policy is made of
only one SID, the reduced version of the behaviors omits the SRH at all and
pushes that SID directly into the IPv6 DA.

Some examples:
ip -6 route add 2001:db8::1 encap seg6 mode encap.red segs fcf0:1::e,fcf0:2::d6 dev eth0
ip -6 route add 2001:db8::2 encap seg6 mode l2encap.red segs fcf0:1::d2 dev eth0

Standard Output:
ip -6 route show 2001:db8::1
2001:db8::1  encap seg6 mode encap.red segs 2 [ fcf0:1::e fcf0:2::d6 ] dev eth0 metric 1024 pref medium

JSON Output:
ip -6 -j -p route show 2001:db8::1
[ {
        "dst": "2001:db8::1",
        "encap": "seg6",
        "mode": "encap.red",
        "segs": [ "fcf0:1::e","fcf0:2::d6" ],
        "dev": "eth0",
        "metric": 1024,
        "flags": [ ],
        "pref": "medium"
    } ]

[1] - https://datatracker.ietf.org/doc/html/rfc8986

Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
---
 include/uapi/linux/seg6_iptunnel.h | 2 ++
 ip/iproute_lwtunnel.c              | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index ee6d1dd5..f2e47aad 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -35,6 +35,8 @@ enum {
 	SEG6_IPTUN_MODE_INLINE,
 	SEG6_IPTUN_MODE_ENCAP,
 	SEG6_IPTUN_MODE_L2ENCAP,
+	SEG6_IPTUN_MODE_ENCAP_RED,
+	SEG6_IPTUN_MODE_L2ENCAP_RED,
 };
 
 #endif
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index f4192229..8ffca4f9 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -135,6 +135,8 @@ static const char *seg6_mode_types[] = {
 	[SEG6_IPTUN_MODE_INLINE]	= "inline",
 	[SEG6_IPTUN_MODE_ENCAP]		= "encap",
 	[SEG6_IPTUN_MODE_L2ENCAP]	= "l2encap",
+	[SEG6_IPTUN_MODE_ENCAP_RED]	= "encap.red",
+	[SEG6_IPTUN_MODE_L2ENCAP_RED]	= "l2encap.red",
 };
 
 static const char *format_seg6mode_type(int mode)
-- 
2.20.1

