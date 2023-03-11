Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35D46B6220
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 00:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjCKXjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 18:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjCKXjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 18:39:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D4AE048;
        Sat, 11 Mar 2023 15:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=IPxttaF0efk5Fm54pzICCIxRrnPQujbmO8MrMUftOtM=; b=YuJsW9/zRa8hZXyM21I5mH50Ub
        xBMeiQI3pzkHEWi287B62QvE7AXSbwDWbniplfymgC1LTJ3HBQ690LkxbBfuSltwc6lWJp+aSksaR
        Jlq6G9vM/D+4vMc2wJvoeaxWb/7Tsxp4sEhMDVzjZBCbCZBIhqjv2QRxTLQrzVhM+MzdVloQngRUZ
        zTJwshebpto3XfbUAI4jvncngl/OgVlypXKFlT7pupGjpSIf/OYIFR8+VwpQwx2KoAeQL4J3Q7RZi
        IxZRuEfFFm6rC4hF/YleaQXypNIDLBQYXuymWqmva7r/qsjM58Du6uFdWBFU1ZfGHoV2MQOLFGe5f
        CSzOk6ag==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb8oT-001UJq-51; Sat, 11 Mar 2023 23:39:45 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     chuck.lever@oracle.com, jlayton@kernel.org,
        trond.myklebust@hammerspace.com, anna@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, linux-nfs@vger.kernel.org
Cc:     ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
        j.granados@samsung.com, patches@lists.linux.dev,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v3 5/5] sunrpc: simplify one-level sysctl registration for debug_table
Date:   Sat, 11 Mar 2023 15:39:44 -0800
Message-Id: <20230311233944.354858-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230311233944.354858-1-mcgrof@kernel.org>
References: <20230311233944.354858-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to declare an extra tables to just create directory,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 net/sunrpc/sysctl.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index afdfcc5403af..93941ab12549 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -163,20 +163,11 @@ static struct ctl_table debug_table[] = {
 	{ }
 };
 
-static struct ctl_table sunrpc_table[] = {
-	{
-		.procname	= "sunrpc",
-		.mode		= 0555,
-		.child		= debug_table
-	},
-	{ }
-};
-
 void
 rpc_register_sysctl(void)
 {
 	if (!sunrpc_table_header)
-		sunrpc_table_header = register_sysctl_table(sunrpc_table);
+		sunrpc_table_header = register_sysctl("sunrpc", debug_table);
 }
 
 void
-- 
2.39.1

