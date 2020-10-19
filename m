Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396492926BC
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgJSLwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:52:24 -0400
Received: from mail.prodrive-technologies.com ([212.61.153.67]:56398 "EHLO
        mail.prodrive-technologies.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbgJSLwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:52:24 -0400
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2020 07:52:23 EDT
Received: from mail.prodrive-technologies.com (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 7F37032EAF_F8D7BB8B;
        Mon, 19 Oct 2020 11:42:48 +0000 (GMT)
Received: from mail.prodrive-technologies.com (exc05.bk.prodrive.nl [10.1.1.214])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.prodrive-technologies.com", Issuer "GlobalSign RSA OV SSL CA 2018" (verified OK))
        by mail.prodrive-technologies.com (Sophos Email Appliance) with ESMTPS id E5BB330504_F8D7BB7F;
        Mon, 19 Oct 2020 11:42:47 +0000 (GMT)
Received: from EXC03.bk.prodrive.nl (10.1.1.212) by EXC05.bk.prodrive.nl
 (10.1.1.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Mon, 19
 Oct 2020 13:42:47 +0200
Received: from lnxdevrm01.prodrive.nl (10.1.2.33) by EXC03.bk.prodrive.nl
 (10.1.1.212) with Microsoft SMTP Server id 15.1.2106.2 via Frontend
 Transport; Mon, 19 Oct 2020 13:42:47 +0200
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
CC:     <martijn.de.gouw@prodrive-technologies.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "Chuck Lever" <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, NeilBrown <neilb@suse.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Roberto Bergantinos Corpas" <rbergant@redhat.com>,
        "open list:NFS, SUNRPC, AND LOCKD CLIENTS" 
        <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] SUNRPC: fix copying of multiple pages in gss_read_proxy_verf()
Date:   Mon, 19 Oct 2020 13:42:27 +0200
Message-ID: <20201019114229.52973-1-martijn.de.gouw@prodrive-technologies.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-SASI-RCODE: 200
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the passed token is longer than 4032 bytes, the remaining part
of the token must be copied from the rqstp->rq_arg.pages. But the
copy must make sure it happens in a consecutive way.

Signed-off-by: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 258b04372f85..bd4678db9d76 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1147,9 +1147,9 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 			       struct gssp_in_token *in_token)
 {
 	struct kvec *argv = &rqstp->rq_arg.head[0];
-	unsigned int page_base, length;
-	int pages, i, res;
-	size_t inlen;
+	unsigned int length, pgto_offs, pgfrom_offs;
+	int pages, i, res, pgto, pgfrom;
+	size_t inlen, to_offs, from_offs;
 
 	res = gss_read_common_verf(gc, argv, authp, in_handle);
 	if (res)
@@ -1177,17 +1177,24 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 	memcpy(page_address(in_token->pages[0]), argv->iov_base, length);
 	inlen -= length;
 
-	i = 1;
-	page_base = rqstp->rq_arg.page_base;
+	to_offs = length;
+	from_offs = rqstp->rq_arg.page_base;
 	while (inlen) {
-		length = min_t(unsigned int, inlen, PAGE_SIZE);
-		memcpy(page_address(in_token->pages[i]),
-		       page_address(rqstp->rq_arg.pages[i]) + page_base,
+		pgto = to_offs >> PAGE_SHIFT;
+		pgfrom = from_offs >> PAGE_SHIFT;
+		pgto_offs = to_offs & ~PAGE_MASK;
+		pgfrom_offs = from_offs & ~PAGE_MASK;
+
+		length = min_t(unsigned int, inlen,
+			 min_t(unsigned int, PAGE_SIZE - pgto_offs,
+			       PAGE_SIZE - pgfrom_offs));
+		memcpy(page_address(in_token->pages[pgto]) + pgto_offs,
+		       page_address(rqstp->rq_arg.pages[pgfrom]) + pgfrom_offs,
 		       length);
 
+		to_offs += length;
+		from_offs += length;
 		inlen -= length;
-		page_base = 0;
-		i++;
 	}
 	return 0;
 }
-- 
2.20.1

