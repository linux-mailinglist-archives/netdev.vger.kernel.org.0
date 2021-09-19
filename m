Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890B041175B
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbhITOpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:45:51 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:40559 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236888AbhITOpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:45:51 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id B3B0FCDE71;
        Mon, 20 Sep 2021 14:36:37 +0000 (UTC)
Received: from h7.dl5rb.org.uk (p5790756f.dip0.t-ipconnect.de [87.144.117.111])
        (Authenticated sender: ralf@linux-mips.org)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 13583FF804;
        Mon, 20 Sep 2021 14:36:14 +0000 (UTC)
Received: from h7.dl5rb.org.uk (localhost [127.0.0.1])
        by h7.dl5rb.org.uk (8.16.1/8.16.1) with ESMTPS id 18KEaDh61202539
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 16:36:13 +0200
Received: (from ralf@localhost)
        by h7.dl5rb.org.uk (8.16.1/8.16.1/Submit) id 18KEaDQ51202538;
        Mon, 20 Sep 2021 16:36:13 +0200
Message-Id: <140fac95627e5a66f9482b6ce550173cef61bab3.1632059758.git.ralf@linux-mips.org>
In-Reply-To: <cover.1632059758.git.ralf@linux-mips.org>
References: <cover.1632059758.git.ralf@linux-mips.org>
From:   Ralf Baechle <ralf@linux-mips.org>
Date:   Sun, 19 Sep 2021 15:30:26 +0200
Subject: [PATCH v2 4/6] NETROM: Print decoded addresses rather than hex
 numbers.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org
Lines:  32
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETROM is an OSI layer 3 protocol sitting on top of AX.25.  It also uses
AX.25 addresses.  Without this commit ip will print NETROM address like

  link/generic 98:92:9c:aa:b0:40:02 brd 00:00:00:00:00:00:00

while with this commit the decoded result

  link/generic LINUX-1 brd *

is much more eye friendly.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 lib/ll_addr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ll_addr.c b/lib/ll_addr.c
index 910e6daf..46e30c79 100644
--- a/lib/ll_addr.c
+++ b/lib/ll_addr.c
@@ -41,6 +41,8 @@ const char *ll_addr_n2a(const unsigned char *addr, int alen, int type,
 		return inet_ntop(AF_INET6, addr, buf, blen);
 	if (alen == 7 && type == ARPHRD_AX25)
 		return ax25_ntop(AF_AX25, addr, buf, blen);
+	if (alen == 7 && type == ARPHRD_NETROM)
+		return netrom_ntop(AF_NETROM, addr, buf, blen);
 
 	snprintf(buf, blen, "%02x", addr[0]);
 	for (i = 1, l = 2; i < alen && l < blen; i++, l += 3)
-- 
2.31.1


