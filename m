Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0CF41DEED
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350510AbhI3Q0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:26:30 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:33379 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350163AbhI3Q0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 12:26:25 -0400
Received: (Authenticated sender: ralf@linux-mips.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id A9A16240005;
        Thu, 30 Sep 2021 16:24:37 +0000 (UTC)
Date:   Thu, 30 Sep 2021 18:24:35 +0200
From:   Ralf Baechle <ralf@linux-mips.org>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Thomas Osterried <thomas@osterried.de>,
        linux-hams@vger.kernel.org
Subject: [PATCH] ax25: Fix use of copy_from_sockptr() in ax25_setsockopt()
Message-ID: <YVXkwzKZhPoD0Ods@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The destination pointer passed to copy_from_sockptr() is an unsigned long *
but the source in userspace is an unsigned int * resulting in an integer
of the wrong size being copied from userspace.

This happens to work on 32 bit but breaks 64-bit where bytes 4..7 will not
be initialized.  By luck it may work on little endian but on big endian
where the userspace data is copied to the upper 32 bit of the destination
it's most likely going to break.

A simple test case to demonstrate this setsockopt() issue is:

[...]
        int sk = socket(AF_AX25, SOCK_SEQPACKET, 0);
        int n1 = 42;
        int res = setsockopt(sk, SOL_AX25, AX25_T1, &n1, sizeof(n1));
        printf("res = %d\n", res);
[...]

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: stable@vger.kernel.org # 5.9
Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
---
 net/ax25/af_ax25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 2631efc6e359..9f2e4b76394a 100644
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
