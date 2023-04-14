Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD41B6E2A3A
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 20:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDNSon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 14:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjDNSon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 14:44:43 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A758A74;
        Fri, 14 Apr 2023 11:44:40 -0700 (PDT)
Received: (Authenticated sender: schoen@loyalty.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 5955E20002;
        Fri, 14 Apr 2023 18:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=loyalty.org; s=gm1;
        t=1681497878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=M9WuceGIl0kFJ/Y3VNNDGUEMqL1G49eJadzVZotDG9U=;
        b=iOaOZeMR75XH4f8kVKLvD9WqEq9INBtOtjwhpFkGydF4o0odegI7JST0vZw2l6jCFs2J07
        DNPQyb448uH1kMPFpU4ChEH4+wfZsBk5P5GeF/tBdl/0i/w5tJk+w+MnAJIiLbcrCnTr26
        z2hz2no9V+1Ipq64zb6kfMLHtfsDwwXhahtbMGtXBZHYdqnzLCo8/acg/aus1EQK8Bu5xF
        PSy4eh7pUHFc9Wtj6LuF0Yk2ozBp5SfHCc3Ro+rPHqqePCxQBa4yEKz2Xn9VsYQ+Bbr/DP
        fKE2DZJmu2hCQAwp6DjHQ5AohWG4/GQW+WNSArYR8ykuAmqtzZBytyjZN+k0Mw==
Date:   Fri, 14 Apr 2023 11:44:33 -0700
From:   Seth David Schoen <schoen@loyalty.org>
To:     Alejandro Colomar <alx.manpages@gmail.com>
Cc:     linux-man@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v5] ip.7: Add "special and reserved addresses" section
Message-ID: <20230414184433.GA2557040@demorgan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Break out the discussion of special and reserved IPv4 addresses into
a subsection, formatted as a pair of definition lists, and briefly
describing three cases in which Linux no longer treats addresses
specially, where other systems do or did.

Also add a specific example to the NOTES paragraph that discourages
the use of IP broadcasting, so people can more easily understand
what they are supposed to do instead.
---
 man7/ip.7 | 83 +++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 75 insertions(+), 8 deletions(-)

diff --git a/man7/ip.7 b/man7/ip.7
index 6c50d0281..6f1ee4dbe 100644
--- a/man7/ip.7
+++ b/man7/ip.7
@@ -237,19 +237,82 @@ In particular, this means that you need to call
 on the number that is assigned to a port.
 All address/port manipulation
 functions in the standard library work in network byte order.
-.PP
+.SS Special and reserved addresses
 There are several special addresses:
-.B INADDR_LOOPBACK
-(127.0.0.1)
+.TP
+.BR INADDR_LOOPBACK " (127.0.0.1)"
 always refers to the local host via the loopback device;
+.TP
+.BR INADDR_ANY " (0.0.0.0)"
+means any address for socket binding;
+.TP
+.BR INADDR_BROADCAST " (255.255.255.255)"
+has the same effect on
+.BR bind (2)
+as
 .B INADDR_ANY
-(0.0.0.0)
-means any address for binding;
+for historical reasons.
+A packet addressed to
 .B INADDR_BROADCAST
-(255.255.255.255)
-means any host and has the same effect on bind as
+through a socket which has
+.B SO_BROADCAST
+set will be broadcast to all hosts on the local network segment,
+as long as the link is broadcast-capable.
+
+.TP
+Highest-numbered address
+.TQ
+Lowest-numbered address
+On any locally-attached non-point-to-point IP subnet
+with a link type that supports broadcasts,
+the highest-numbered address
+(e.g., the .255 address on a subnet with netmask 255.255.255.0)
+is designated as a broadcast address.
+It cannot usefully be assigned to an individual interface,
+and can only be addressed with a socket on which the
+.B SO_BROADCAST
+option has been set.
+Internet standards have historically
+also reserved the lowest-numbered address
+(e.g., the .0 address on a subnet with netmask 255.255.255.0)
+for broadcast, though they call it "obsolete" for this purpose.
+(Some sources also refer to this as the "network address.")
+Since Linux 5.14,
+.\" commit 58fee5fc83658aaacf60246aeab738946a9ba516
+it is treated as an ordinary unicast address
+and can be assigned to an interface.
+
+.PP
+Internet standards have traditionally also reserved various addresses
+for particular uses, though Linux no longer treats
+some of these specially.
+
+.TP
+[0.0.0.1, 0.255.255.255]
+.TQ
+[240.0.0.0, 255.255.255.254]
+Addresses in these ranges (0/8 and 240/4) are reserved globally.
+Since Linux 5.3
+.\" commit 96125bf9985a75db00496dd2bc9249b777d2b19b
+and Linux 2.6.25,
+.\" commit 1e637c74b0f84eaca02b914c0b8c6f67276e9697
+respectively,
+the 0/8 and 240/4 addresses, other than
 .B INADDR_ANY
-for historical reasons.
+and
+.BR INADDR_BROADCAST ,
+are treated as ordinary unicast addresses.
+Systems that follow the traditional behaviors may not
+interoperate with these historically reserved addresses.
+.TP
+[127.0.0.1, 127.255.255.254]
+Addresses in this range (127/8) are treated as loopback addresses
+akin to the standardized local loopback address
+.B INADDR_LOOPBACK
+(127.0.0.1);
+.TP
+[224.0.0.0, 239.255.255.255]
+Addresses in this range (224/4) are dedicated to multicast use.
 .SS Socket options
 IP supports some protocol-specific socket options that can be set with
 .BR setsockopt (2)
@@ -1343,6 +1406,10 @@ with careless broadcasts.
 For new application protocols
 it is better to use a multicast group instead of broadcasting.
 Broadcasting is discouraged.
+See RFC 6762 for an example of a protocol (mDNS)
+using the more modern multicast approach
+to communicating with an open-ended
+group of hosts on the local network.
 .PP
 Some other BSD sockets implementations provide
 .B IP_RCVDSTADDR
-- 
2.25.1
