Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC9E40DB6F
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240263AbhIPNju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:39:50 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:39035 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240091AbhIPNjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 09:39:49 -0400
Received: (Authenticated sender: ralf@linux-mips.org)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id CAA4240010;
        Thu, 16 Sep 2021 13:38:25 +0000 (UTC)
Date:   Thu, 16 Sep 2021 15:38:23 +0200
From:   Ralf Baechle <ralf@linux-mips.org>
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        Thomas Osterried <thomas@osterried.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
Subject: [PATCH v2] packet.7: Describe SOCK_PACKET netif name length issues
 and workarounds.
Message-ID: <YUNIz64en4QslhL6@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the issues with SOCK_PACKET possibly truncating network interface
names in results, solutions and possible workarounds.

While the issue is known for a long time it appears to have never been
properly documented is has started to bite software antiques including
the AX.25 userland badly since the introduction of Predictable Network
Interface Names.  So let's document it.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 man7/packet.7 | 39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

Changes in v2: Correct issues raised by Alejandro Colomar in review of v1.

diff --git a/man7/packet.7 b/man7/packet.7
index 706efbb54..fa022bee8 100644
--- a/man7/packet.7
+++ b/man7/packet.7
@@ -616,10 +616,10 @@ is the device name as a null-terminated string, for example, eth0.
 .PP
 This structure is obsolete and should not be used in new code.
 .SH BUGS
+.SS LLC header handling
 The IEEE 802.2/803.3 LLC handling could be considered as a bug.
 .PP
-Socket filters are not documented.
-.PP
+.SS MSG_TRUNC issues
 The
 .B MSG_TRUNC
 .BR recvmsg (2)
@@ -627,6 +627,38 @@ extension is an ugly hack and should be replaced by a control message.
 There is currently no way to get the original destination address of
 packets via
 .BR SOCK_DGRAM .
+.PP
+.SS spkt_device device name truncation
+The
+.I spkt_device
+field of
+.I sockaddr_pkt
+has a size of 14 bytes which is less than the constant
+.B IFNAMSIZ
+defined in
+.I <net/if.h>
+which is 16 bytes and describes the system limit for a network interface name.
+This means the names of network devices longer than 14 bytes will be truncated
+to fit into
+.IR spkt_device .
+All these lengths include the terminating null byte (\(aq\e0\(aq)).
+.PP
+Issues from this with old code typically show up with very long interface
+names used by the
+.B Predictable Network Interface Names
+feature enabled by default in many modern Linux distributions.
+.PP
+The preferred solution is to rewrite code to avoid
+.BR SOCK_PACKET .
+Possible user solutions are to disable
+.B Predictable Network Interface Names
+or to rename the interface to a name of at most 13 bytes, for example using
+the
+.BR ip (8)
+tool.
+.PP
+.SS Documentation issues
+Socket filters are not documented.
 .\" .SH CREDITS
 .\" This man page was written by Andi Kleen with help from Matthew Wilcox.
 .\" AF_PACKET in Linux 2.2 was implemented
@@ -637,7 +669,8 @@ packets via
 .BR capabilities (7),
 .BR ip (7),
 .BR raw (7),
-.BR socket (7)
+.BR socket (7),
+.BR ip (8),
 .PP
 RFC\ 894 for the standard IP Ethernet encapsulation.
 RFC\ 1700 for the IEEE 802.3 IP encapsulation.
