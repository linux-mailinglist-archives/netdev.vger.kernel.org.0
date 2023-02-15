Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDCE697E08
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjBOOJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjBOOJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:09:51 -0500
X-Greylist: delayed 971 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Feb 2023 06:09:48 PST
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A47B45C
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 06:09:48 -0800 (PST)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 31FDrOOX003824
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Feb 2023 14:53:24 +0100
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Subject: [iproute2-next] seg6: man: ip-link.8: add SRv6 End PSP flavor description
Date:   Wed, 15 Feb 2023 14:53:18 +0100
Message-Id: <20230215135318.8899-1-paolo.lungaroni@uniroma2.it>
X-Mailer: git-send-email 2.20.1
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

This patch extends the manpage by providing a brief description of the PSP
flavor for the SRv6 End behavior as defined in RFC 8986 [1].

The code/logic required to handle the "flavors" framework has already been
merged into iproute2 by commit:
    04a6b456bf74 ("seg6: add support for flavors in SRv6 End* behaviors").

Some examples:
ip -6 route add 2001:db8::1 encap seg6local action End flavors psp dev eth0

Standard Output:
ip -6 route show 2001:db8::1
2001:db8::1  encap seg6local action End flavors psp dev eth0 metric 1024 pref medium

JSON Output:
ip -6 -j -p route show 2001:db8::1
[ {
	"dst": "2001:db8::1",
	"encap": "seg6local",
	"action": "End",
	"flavors": [ "psp" ],
	"dev": "eth0",
	"metric": 1024,
	"flags": [ ],
	"pref": "medium"
} ]

[1] - https://datatracker.ietf.org/doc/html/rfc8986

Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
---
 man/man8/ip-route.8.in | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/man/man8/ip-route.8.in b/man/man8/ip-route.8.in
index 194dc780..c2b00833 100644
--- a/man/man8/ip-route.8.in
+++ b/man/man8/ip-route.8.in
@@ -963,7 +963,12 @@ subset of the existing behaviors.
 .in -2
 
 .B psp
-- Penultimate Segment Pop of the SRH (not yet supported in kernel)
+- The Penultimate Segment Pop (PSP) copies the last SID from the SID List
+(carried by the outermost SRH) into the IPv6 Destination Address (DA) and
+removes (i.e. pops) the SRH from the IPv6 header.
+The PSP operation takes place only at a penultimate SR Segment Endpoint node
+(e.g., the Segment Left must be one) and does not happen at non-penultimate
+endpoint nodes.
 
 .B usp
 - Ultimate Segment Pop of the SRH (not yet supported in kernel)
@@ -1359,6 +1364,11 @@ ip -6 route add 2001:db8:1::/64 encap seg6local action End.DT46 vrftable 100 dev
 Adds an IPv6 route with SRv6 decapsulation and forward with lookup in VRF table.
 .RE
 .PP
+ip -6 route add 2001:db8:1::/64 encap seg6local action End flavors psp dev eth0
+.RS 4
+Adds an IPv6 route with SRv6 End behavior with psp flavor enabled.
+.RE
+.PP
 ip -6 route add 2001:db8:1::/64 encap seg6local action End flavors next-csid dev eth0
 .RS 4
 Adds an IPv6 route with SRv6 End behavior with next-csid flavor enabled.
-- 
2.20.1

