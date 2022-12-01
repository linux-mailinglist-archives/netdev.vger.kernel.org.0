Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C9063F5A4
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLAQsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiLAQqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:37 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7CAB0A33
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:23 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n20so5661685ejh.0
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MauUMcXifWo52D9Tli+Mq2HbMeQEEDuA+gE8MIm7tiY=;
        b=cPVvBsugnhKRe+K8Q6PKRx3OsaUVy/RawUbOOh7GRTlj5LJUTnfQthA6+qBALeAvR9
         PPzp4ERyppG2c/GEPycwBxJ2q7fiymIFTIO5HpE8bqezvnFeKqguc9A9EjyKEyeOc7B+
         GOZXIKIYkU5sKSdFkaPbUW1bW1mHgu07V3xXMdKLpmh0cjRf6PObrh6NsngkeMjUJp4H
         xjWKwC0ToZ+G9KafKdN0RxoImenZTEtfrguVJJ55sEp5iPLhFHKPR5rc2gLQjGiTArr7
         i3lGXPS0yjXQ2rTb9dWdMj6mFtMRcRZoQeaPZiGUuSADGfqavZAe+53vCiOj6Uoi6IOF
         SU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MauUMcXifWo52D9Tli+Mq2HbMeQEEDuA+gE8MIm7tiY=;
        b=7xt2TPUtETw7saxjkCa845zuuxjkDsCroTpqbYpX/agg2m2Gm55Y7kZGI6c6noElf0
         N25EtxABU0y9oL/PNFrxqKul/GQohM6IsiTsVr8cOKXAr3R8lLMlLibe4oZBo/8D2qod
         HHFz5hRHX/2iQnCqFWhVuAjHbAt71snf1kE9LCzzEFuhAMgXqX+qIZkheOURfhezyu9s
         yGSPYBYl8c4ylAtZ7lQDCalr5b9+oH7IM6Ep2jG3eFIrGDmygaN9EEiXsVIIqiCkKAQL
         uMDVOvTfivbKrlUSVIXaKnVXJ5LopB9OGf1pY+kETWBsRe4eDQ+C/P+1Rrz+Q62Jsb5o
         470A==
X-Gm-Message-State: ANoB5plbDAL+aguztTnKBb7E+g+H1iI805EZqgzRohV1BXNGmoK0Yjj4
        2bInHaj9vMXUbDctt1biBrJArtQrn9xaoy2O
X-Google-Smtp-Source: AA0mqf6LI/mRTr56+auXYK/7ws/AoqDZtEtci8Zomm+K9nLUu3llgEkaLWRjjfhgXW4oje9EKRwZRA==
X-Received: by 2002:a17:906:c249:b0:7ad:9f03:fd44 with SMTP id bl9-20020a170906c24900b007ad9f03fd44mr41749120ejb.73.1669913182161;
        Thu, 01 Dec 2022 08:46:22 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id q26-20020a170906389a00b007bdc2de90e6sm1971702ejd.42.2022.12.01.08.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:46:21 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yangyingliang@huawei.com, leon@kernel.org
Subject: [patch net-next RFC 7/7] devlink: assert if devl_port_register/unregister() is called on unregistered devlink instance
Date:   Thu,  1 Dec 2022 17:46:08 +0100
Message-Id: <20221201164608.209537-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221201164608.209537-1-jiri@resnulli.us>
References: <20221201164608.209537-1-jiri@resnulli.us>
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

Now when all drivers do call devl_port_register/unregister() withing the
time frame during which the devlink is registered, put and assertion to
the functions to check that and avoid going back.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index fca3ebee97b0..c46dd7753368 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10088,6 +10088,7 @@ int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
 {
+	ASSERT_DEVLINK_REGISTERED(devlink);
 	devl_assert_locked(devlink);
 
 	if (devlink_port_index_exists(devlink, port_index))
@@ -10145,6 +10146,7 @@ EXPORT_SYMBOL_GPL(devlink_port_register);
  */
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
+	ASSERT_DEVLINK_REGISTERED(devlink_port->devlink);
 	lockdep_assert_held(&devlink_port->devlink->lock);
 	WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
 
-- 
2.37.3

