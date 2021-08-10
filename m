Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13FB53D6740
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 21:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhGZSYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 14:24:09 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:44737 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbhGZSYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 14:24:06 -0400
Received: from h7.dl5rb.org.uk (p57907709.dip0.t-ipconnect.de [87.144.119.9])
        (Authenticated sender: ralf@linux-mips.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D655D200007;
        Mon, 26 Jul 2021 19:04:33 +0000 (UTC)
Received: from h7.dl5rb.org.uk (localhost [127.0.0.1])
        by h7.dl5rb.org.uk (8.16.1/8.16.1) with ESMTPS id 16QJ4XGC836369
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Mon, 26 Jul 2021 21:04:33 +0200
Received: (from ralf@localhost)
        by h7.dl5rb.org.uk (8.16.1/8.16.1/Submit) id 16QJ4XBp836368;
        Mon, 26 Jul 2021 21:04:33 +0200
Message-Id: <2ab3e7655dac7a5493a388793dce45afae5781e8.1627295848.git.ralf@linux-mips.org>
In-Reply-To: <cover.1627295848.git.ralf@linux-mips.org>
References: <cover.1627295848.git.ralf@linux-mips.org>
From:   Ralf Baechle <ralf@linux-mips.org>
Date:   Wed, 18 Jan 2017 22:34:39 +0100
Subject: [PATCH 6/6] ROSE: Print decoded addresses rather than hex numbers.
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org
Lines:  31
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NETROM is a OSI layer 3 protocol sitting on top of AX.25.  It uses BCD-
encoded 10 digit telephone numbers as addresses.  Without this ip will
print a ROSE addresses like

  link/rose 12:34:56:78:90 brd 00:00:00:00:00

which is readable but ugly.  With this applied it ROSE addresses will be
printed as

  link/rose 1234567890 brd 0000000000

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 lib/ll_addr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/ll_addr.c b/lib/ll_addr.c
index 46e30c79..d6fd736b 100644
--- a/lib/ll_addr.c
+++ b/lib/ll_addr.c
@@ -43,6 +43,8 @@ const char *ll_addr_n2a(const unsigned char *addr, int alen, int type,
 		return ax25_ntop(AF_AX25, addr, buf, blen);
 	if (alen == 7 && type == ARPHRD_NETROM)
 		return netrom_ntop(AF_NETROM, addr, buf, blen);
+	if (alen == 5 && type == ARPHRD_ROSE)
+		return rose_ntop(AF_ROSE, addr, buf, blen);
 
 	snprintf(buf, blen, "%02x", addr[0]);
 	for (i = 1, l = 2; i < alen && l < blen; i++, l += 3)
-- 
2.31.1

