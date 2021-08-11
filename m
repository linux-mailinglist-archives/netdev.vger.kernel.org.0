Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA63B3E8E50
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 12:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhHKKQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 06:16:13 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:47330 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237101AbhHKKOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 06:14:52 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id A55E2200C98D;
        Wed, 11 Aug 2021 12:14:17 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be A55E2200C98D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1628676857;
        bh=/vwVjeJ7Nbzk+kPlmGa0EApxaoJPEWw5l6SIabB6CGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=kGi14PuU1DvuzxGYe4SlszBSubO7oA2cD+q32PBLIup9JhUNe5TF/Alg6HAfqhtdk
         SHXPAdTdHA3K5qxNaGpBOoSa2sTpGjZsIA82agICu0mUrQMODm7o4uBpJ1LLBJDfrL
         dor1B5WubtCuRROO1NmH5zkYh3Ju5MD+FNhDw7HGtk89G2K+hx6so5ikfQobxpXIS4
         9LatHEbunZfDjkjTy+pSE2jXr0ig/Pfcyn0knnDdg6NHsLA2ICF+MtXGLwONclMXx1
         BxpMLLKEPefEsmw8tV4A+mx7PbwdZHWHLxS7SAnnfouf9c9fDJlrcG9qTrcp/aJ93e
         PbnetdSQxO/2A==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        justin.iurman@uliege.be
Subject: [PATCH iproute2-next] ipioam6: use print_nl instead of print_null
Date:   Wed, 11 Aug 2021 12:13:56 +0200
Message-Id: <20210811101356.13958-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch addresses Stephen's comment:

"""
> +        print_null(PRINT_ANY, "", "\n", NULL);

Use print_nl() since it handles the case of oneline output.
Plus in JSON the newline is meaningless.
"""

It also removes two useless print_null's.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 ip/ipioam6.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/ip/ipioam6.c b/ip/ipioam6.c
index 253d0b66..b63d7d5c 100644
--- a/ip/ipioam6.c
+++ b/ip/ipioam6.c
@@ -62,19 +62,15 @@ static void print_namespace(struct rtattr *attrs[])
 		print_uint(PRINT_ANY, "schema", " [schema %u]",
 			   rta_getattr_u32(attrs[IOAM6_ATTR_SC_ID]));
 
-	if (!attrs[IOAM6_ATTR_NS_DATA])
-		print_null(PRINT_ANY, "data", "", NULL);
-	else
+	if (attrs[IOAM6_ATTR_NS_DATA])
 		print_hex(PRINT_ANY, "data", ", data %#010x",
 			  rta_getattr_u32(attrs[IOAM6_ATTR_NS_DATA]));
 
-	if (!attrs[IOAM6_ATTR_NS_DATA_WIDE])
-		print_null(PRINT_ANY, "wide", "", NULL);
-	else
+	if (attrs[IOAM6_ATTR_NS_DATA_WIDE])
 		print_0xhex(PRINT_ANY, "wide", ", wide %#018lx",
 			    rta_getattr_u64(attrs[IOAM6_ATTR_NS_DATA_WIDE]));
 
-	print_null(PRINT_ANY, "", "\n", NULL);
+	print_nl();
 }
 
 static void print_schema(struct rtattr *attrs[])
@@ -97,7 +93,7 @@ static void print_schema(struct rtattr *attrs[])
 		print_hhu(PRINT_ANY, "", " %02x", data[i]);
 		i++;
 	}
-	print_null(PRINT_ANY, "", "\n", NULL);
+	print_nl();
 }
 
 static int process_msg(struct nlmsghdr *n, void *arg)
-- 
2.25.1

