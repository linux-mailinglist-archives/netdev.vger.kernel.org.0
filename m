Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFBB66A71E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjAMXcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjAMXcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:32:00 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50F97C38A
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:31:58 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 7so16001502pga.1
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ny9h+ZZepDf26lrHiNUGn+AoV4tgXMAa0PRKzqUkiBc=;
        b=MPeWSD1n344rPLFBDiZ5R4AV4z0YgYhwEsVCsl4ewSRde/+n5Y5xABOYq2hS6XzKRI
         qKGRSsQaYJWGZOLK4lPfFifrRUxuEzuXWh2YjFUzFOWb2N1+ItlfLKdDA5xP62crLWNV
         Fm8oZm0DLBSmTgWqUKNDU34UuI310e+lgpYRt9mxeF+r2ieWpg4KL+BLXqTH5hNIq9nl
         2en8dIbbAH/pMcVNg811gT6T2JNiX9PTJh/BV5EgGuhtIMNSldHDnSUKVwAiimYh9W3A
         1zFHOtCFwpGAGH7lt7UmoTIbybEwO87utqi2ghp2jb641etgN39iSFK3fOVJl+a40jbK
         C8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ny9h+ZZepDf26lrHiNUGn+AoV4tgXMAa0PRKzqUkiBc=;
        b=UwIQaCU5d7MkH5OryXMk5nAQw9UVbnyaqHJnovcWRbi4f/SJwzN0Bfaf0KzBDwr+aC
         /3HaeWnycHmFNxQIiB2cC7Cmb9LXczFkm9WjScoQ7Mv1cuwD4bASusF9ZzcvnMDEMGWs
         SGnE8niQJiwJ8sQRjBg96VKLD9LBNGy1SRDIHmzs5aLXW6eG6Tg/Fc9qf/mTQuRzMsj6
         sAJ5GZYAnqZTueyzKYEWciDcKfEZhxwG2seXz8I744n3miwzG0iO31+s6/YXEeMkj+DA
         7LNGMGhTIF/U4/GpO2C2jQkp9p9nYN+/qxfewtcMOF8ehjZoNwlD+i0QbgBKSXWJqNGG
         mNsQ==
X-Gm-Message-State: AFqh2koM5cpe+ZaBEzca5rQdga9If8lHmOur5d+v9IRh2UA+lOMjV1qt
        CnDLqfBpNUpFLaE6iHQ9Fqf/xgUJ1gg=
X-Google-Smtp-Source: AMrXdXtDy3+yNkzFBQsJeFlFRcOKADurPnt89BIaeqpCprUGauCAl762AdjvpsqcXL3+DXh4QbWicg==
X-Received: by 2002:aa7:8a41:0:b0:585:fc75:c544 with SMTP id n1-20020aa78a41000000b00585fc75c544mr12855793pfa.15.1673652717685;
        Fri, 13 Jan 2023 15:31:57 -0800 (PST)
Received: from localhost.localdomain (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r4-20020aa79624000000b0056bd1bf4243sm14253244pfg.53.2023.01.13.15.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 15:31:57 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool 2/3] netlink: Fix maybe uninitialized 'meters' variable
Date:   Fri, 13 Jan 2023 15:31:47 -0800
Message-Id: <20230113233148.235543-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113233148.235543-1-f.fainelli@gmail.com>
References: <20230113233148.235543-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC12 warns that 'meters' may be uninitialized, initialize it
accordingly.

Fixes: 9561db9b76f4 ("Add cable test TDR support")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 netlink/parser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/parser.c b/netlink/parser.c
index f982f229a040..6f863610a490 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -237,7 +237,7 @@ int nl_parse_direct_m2cm(struct nl_context *nlctx, uint16_t type,
 			 struct nl_msg_buff *msgbuff, void *dest)
 {
 	const char *arg = *nlctx->argp;
-	float meters;
+	float meters = 0.0;
 	uint32_t cm;
 	int ret;
 
-- 
2.34.1

