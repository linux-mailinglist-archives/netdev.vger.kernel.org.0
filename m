Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493CA42ADB5
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhJLUWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:22:55 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:50629 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhJLUWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 16:22:54 -0400
Received: from h7.dl5rb.org.uk (pd95470b6.dip0.t-ipconnect.de [217.84.112.182])
        (Authenticated sender: ralf@linux-mips.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 9466D200004;
        Tue, 12 Oct 2021 20:20:48 +0000 (UTC)
Received: from h7.dl5rb.org.uk (localhost [127.0.0.1])
        by h7.dl5rb.org.uk (8.16.1/8.16.1) with ESMTPS id 19CKKk3U217651
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 22:20:46 +0200
Received: (from ralf@localhost)
        by h7.dl5rb.org.uk (8.16.1/8.16.1/Submit) id 19CKKjxv217644;
        Tue, 12 Oct 2021 22:20:45 +0200
Message-Id: <2dea23e9208d008e74faddf92acf4ef557f97a85.1634069168.git.ralf@linux-mips.org>
From:   Ralf Baechle <ralf@linux-mips.org>
Date:   Tue, 12 Oct 2021 22:05:29 +0200
Subject: [PATCH v2 1/2] ax25: Fix use of copy_from_sockptr() in
 ax25_setsockopt()
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Thomas Osterried <thomas@osterried.de>,
        linux-hams@vger.kernel.org
Lines:  67
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The destination pointer passed to copy_from_sockptr() is an unsigned long *
but the source in userspace is an unsigned int.

This happens to work on 32 bit but breaks 64-bit where bytes 4..7 will not
be initialized.  By luck it may work on little endian but on big endian
where the userspace data is copied to the upper 32 bit of the destination
it's most likely going to break.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
---
 net/ax25/af_ax25.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 2631efc6e359..5e7ab76f7f9b 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -534,7 +534,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 	ax25_cb *ax25;
 	struct net_device *dev;
 	char devname[IFNAMSIZ];
-	unsigned long opt;
+	unsigned int opt;
 	int res = 0;
 
 	if (level != SOL_AX25)
@@ -566,7 +566,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T1:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -575,7 +575,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T2:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -591,7 +591,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_T3:
-		if (opt < 1 || opt > ULONG_MAX / HZ) {
+		if (opt < 1 || opt > UINT_MAX / HZ) {
 			res = -EINVAL;
 			break;
 		}
@@ -599,7 +599,7 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case AX25_IDLE:
-		if (opt > ULONG_MAX / (60 * HZ)) {
+		if (opt > UINT_MAX / (60 * HZ)) {
 			res = -EINVAL;
 			break;
 		}
-- 
2.31.1


