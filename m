Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CE53D7190
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 10:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbhG0IxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 04:53:10 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:46287 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbhG0IxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 04:53:09 -0400
Received: (Authenticated sender: ralf@linux-mips.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 5C64F20014;
        Tue, 27 Jul 2021 08:53:07 +0000 (UTC)
Date:   Tue, 27 Jul 2021 10:53:05 +0200
From:   Ralf Baechle <ralf@linux-mips.org>
To:     linux-man@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Alejandro Colomar <alx.manpages@gmail.com>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        Thomas Osterried <thomas@osterried.de>
Subject: [PATCH] packet.7: Describe SOCK_PACKET netif name length issues and
 workarounds.
Message-ID: <YP/Jcc4AFIcvgXls@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the issues with SOCK_PACKET possibly truncating network interface
names in results, solutions and possible workarounds.

While the issue is know for a long time it appears to have never been
documented properly and is has started to bite software antiques badly since
the introduction of Predictable Network Interface Names.  So let's document
it.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 man7/packet.7 | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/man7/packet.7 b/man7/packet.7
index 706efbb54..7697bbdeb 100644
--- a/man7/packet.7
+++ b/man7/packet.7
@@ -627,6 +627,34 @@ extension is an ugly hack and should be replaced by a control message.
 There is currently no way to get the original destination address of
 packets via
 .BR SOCK_DGRAM .
+.PP
+The
+.I spkt_device
+field of
+.I sockaddr_pkt
+has a size of 14 bytes which is less than the constant
+.B IFNAMSIZ
+defined in
+.I <net/if.h>
+which is 16 bytes and describes the system limit for a network interface
+name.  This means the names of network devices longer than 14 bytes will be
+truncated to fit into
+.I spkt_device .
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
+.BR IP (8)
+tool.
 .\" .SH CREDITS
 .\" This man page was written by Andi Kleen with help from Matthew Wilcox.
 .\" AF_PACKET in Linux 2.2 was implemented
@@ -637,7 +665,8 @@ packets via
 .BR capabilities (7),
 .BR ip (7),
 .BR raw (7),
-.BR socket (7)
+.BR socket (7),
+.BR ip (8),
 .PP
 RFC\ 894 for the standard IP Ethernet encapsulation.
 RFC\ 1700 for the IEEE 802.3 IP encapsulation.
