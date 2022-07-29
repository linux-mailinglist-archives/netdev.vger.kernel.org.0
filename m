Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31354584C6D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiG2HKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiG2HKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:10:48 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3971C5245D
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:47 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id mf4so6999024ejc.3
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 00:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M/P6G4J+EAeQ43x1m5lkSqZuhflBwHYNiVn8totPCxQ=;
        b=SifL4kVtWK7vJ7zr5Ti/4cFjbBj2yx9ZwMtL5VMU/TLrDrH/46ZnO/xqppvPRnwW3u
         zxb4R1bEbYgD9KLvv/jAbuQjgmn/Nrg1L7IqFVAkOnQ+/tNnCSmY7+8PN1+Y+77sfcxf
         Nfj1jx2S6sLpNVHtKM6+WsplPvmB8N91ZmdM1G+me7JNhkct7tx55vq+lOD+buTOhjp3
         J/KV3aIiQD31v/r+qgebcPZEMzpgOpODZwiG34BuqDjskGqP2DHwVXfPpNqvGF11g76p
         7GZCCy//fwkOXOFZfXdM5C9Q9I01mlqbstVKxyNOWDehyCz+Q5GLBci1Ks7JzlBLJGit
         V7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M/P6G4J+EAeQ43x1m5lkSqZuhflBwHYNiVn8totPCxQ=;
        b=0+osDtnOvv+qa1uu+R2yGFLDWQBUFIS180hhuTAo3CyCmwJ/EnN8bMBOSbj8RiEyl4
         DiVOYRuQEXmwfpA7QnKhZt7ZRlV2gnA0N6Xkve9fwa8tg/lLSqShq82IHhMyowJJpfwr
         ElETbExN4KX/0Jv1DaLq0z2Xyx6UEKqeEIN7JZRngCnprQxiSl/LVrn/08P2A0sWIONh
         zxoibVxvXOst2T78xGEesS2awe4fBegWtNho9Ur7ZYITN2LuVlNqpbz7pcqqXMsT6iAO
         GKZwp/tdQM5mw5Qme9VnxXnU84Tf1XDXf+u4v4To6+JiFc3HXM08Xisa8E5LmUDyft1V
         WcCg==
X-Gm-Message-State: AJIora9bjFT0NQmoDcjxVJ05qVzDcxkXmYxsp3S8KUsE/WKTr8gmE4QO
        hZwUsAt57AJ3wTaLdJUZ84nk18v7fnGfDCuZ
X-Google-Smtp-Source: AGRyM1uQBWKOXySMyZ2zCZ8sdq+XS3EE1wG8zTcM9l4ZifVG1A2FtEFKlEfnWE3g7PghNJ+0ozCa8w==
X-Received: by 2002:a17:907:1c24:b0:72b:838f:cada with SMTP id nc36-20020a1709071c2400b0072b838fcadamr1866809ejc.125.1659078645647;
        Fri, 29 Jul 2022 00:10:45 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k15-20020a17090632cf00b00730165d7f41sm1334818ejk.13.2022.07.29.00.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 00:10:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: [patch net-next 4/4] net: devlink: enable parallel ops on netlink interface
Date:   Fri, 29 Jul 2022 09:10:38 +0200
Message-Id: <20220729071038.983101-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220729071038.983101-1-jiri@resnulli.us>
References: <20220729071038.983101-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As the devlink_mutex was removed and all devlink instances are protected
individually by devlink->lock mutex, allow the netlink ops to run
in parallel and therefore allow user to execute commands on multiple
devlink instances simultaneously.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 06cd7c1a1f0a..889e7e3d3e8a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9505,6 +9505,7 @@ static struct genl_family devlink_nl_family __ro_after_init = {
 	.maxattr	= DEVLINK_ATTR_MAX,
 	.policy = devlink_nl_policy,
 	.netnsok	= true,
+	.parallel_ops	= true,
 	.pre_doit	= devlink_nl_pre_doit,
 	.post_doit	= devlink_nl_post_doit,
 	.module		= THIS_MODULE,
-- 
2.35.3

