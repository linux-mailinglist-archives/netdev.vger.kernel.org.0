Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18FF64D7DD7
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236816AbiCNIxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiCNIxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:53:45 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27AF1A803
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 01:52:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3957520581;
        Mon, 14 Mar 2022 09:52:33 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q3O5Cn4c_DER; Mon, 14 Mar 2022 09:52:32 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A849F20504;
        Mon, 14 Mar 2022 09:52:32 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A296A80004A;
        Mon, 14 Mar 2022 09:52:32 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 14 Mar 2022 09:52:32 +0100
Received: from moon.secunet.de (172.18.149.2) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Mon, 14 Mar
 2022 09:52:32 +0100
Date:   Mon, 14 Mar 2022 09:52:26 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     David Ahern <dsahern@gmail.com>, Matt Ellison <matt@arroyo.io>,
        <netdev@vger.kernel.org>, Eyal Birger <eyal.birger@gmail.com>,
        "Steffen Klassert" <steffen.klassert@secunet.com>,
        Antony Antony <antony.antony@secunet.com>
Subject: [PATCH iproute2-next] link_xfrm: if_id must be non zero
Message-ID: <3510490c98d5d9245c172648806af31a2be97aad.1647247604.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kernel upstream commit
8dce43919566 ("xfrm: interface with if_id 0 should return error")
if_id must be non zero.

Fix the usage and return error for if_id 0.

Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 ip/link_xfrm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/ip/link_xfrm.c b/ip/link_xfrm.c
index 7dbfb13f..f6c961e6 100644
--- a/ip/link_xfrm.c
+++ b/ip/link_xfrm.c
@@ -19,7 +19,7 @@ static void xfrm_print_help(struct link_util *lu, int argc, char **argv,
 	fprintf(f,
 		"Usage: ... %-4s dev [ PHYS_DEV ] [ if_id IF-ID ]\n"
 		"\n"
-		"Where: IF-ID := { 0x0..0xffffffff }\n",
+		"Where: IF-ID := { 0x1..0xffffffff }\n",
 		lu->id);
 }

@@ -39,6 +39,8 @@ static int xfrm_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			if (get_u32(&if_id, *argv, 0))
 				invarg("if_id value is invalid", *argv);
+			else if (!if_id)
+				invarg("if_id value is invalid", *argv);
 			else
 				addattr32(n, 1024, IFLA_XFRM_IF_ID, if_id);
 		} else {
@@ -48,6 +50,9 @@ static int xfrm_parse_opt(struct link_util *lu, int argc, char **argv,
 		argc--; argv++;
 	}

+	if (!if_id)
+		missarg("IF_ID");
+
 	if (link)
 		addattr32(n, 1024, IFLA_XFRM_LINK, link);

--
2.30.2

