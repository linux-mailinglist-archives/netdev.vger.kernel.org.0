Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6435A5F1A1D
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiJAGC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJAGCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:02:08 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE333237C4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:04 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lc7so12966570ejb.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=h+iNDFFBmRSTs83x5DP2zCPfIEFpaEyEDolI5fG6fJM=;
        b=xR9avB3vE4DRoGTHSfZTI20Y7ssCa9pu3u5mGIESR+cTxiXiLYm+8pMiJZ9kJba+Y7
         HIYTzwLcCQ0XGXsxr3ojUrXCy7dW1hKIRCuCpSHVkGO7VZvHwMO1yChZxh2yZ2a8H009
         qJb3GL7/s1LGM44vf3Fs0ZNLUuN/+rkqJABWxKkpZnj7kq1BB/xwoH/AVwz/aNSDiB02
         kPldpGY0rt6v4vsGAtmdGeHXdlQv7dNxthS3rFfo436WOxCsBm4gWDfLvKe7ysa/fHh3
         NO17hmkNc3kAiNAWmLGbGR5nphuyW6zOH3Lcehatj9x8t8IO7zRXBC3SMSRD9/apnaot
         A1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=h+iNDFFBmRSTs83x5DP2zCPfIEFpaEyEDolI5fG6fJM=;
        b=iOBGxrg/tOlQk/BomNYGDlnv8eqUsL4SM5sGwAe5q2nD1SMiFs8oHNRWdRppnKHVuo
         6ulJFt0MZ53gEkBS6bS3j5Z+/SCAamjdQKC5LCgVKYl+tATvZxzNvMdW6EVTJZ1s1s8N
         HEfekukPsR9fN1QnaXWx6Oo7rp2IPCnstnunWe5nrzH9KMYi14UTPciAIg6u+QNAcb7a
         tiCB5/S4BA8KTkfGeHQ2ketXEJsIZzABS8SH5cPvzocKFRoqRS2IE6lKEZaOrzQoqy1A
         /sK5j7T1NP2sPmq0+hvHYDVQEeDJSiRAJS4jdK91F10Of8jvM+4TrQYgqZbh05Qcjcex
         Tzww==
X-Gm-Message-State: ACrzQf0ysEb8BOv4rOwPvBHt7zlLFZi4AE6P/KLBvmoeRrJweB5tF5sD
        HU7q909hK1lgFUq8n2ZQZPwYN3YpldybcMUi
X-Google-Smtp-Source: AMsMyM4E1C6A/dTRyOqgz5s+gZErh5Y5530+mWoQK66CgqHVMVQixdGyypQeZNOynIotd4JLDo0Ybw==
X-Received: by 2002:a17:907:7625:b0:779:e6f7:a669 with SMTP id jy5-20020a170907762500b00779e6f7a669mr8724083ejc.472.1664604124065;
        Fri, 30 Sep 2022 23:02:04 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d12-20020a056402144c00b00457618d3409sm2865216edx.68.2022.09.30.23.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:02:03 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 10/13] net: devlink: add not cleared type warning to port unregister
Date:   Sat,  1 Oct 2022 08:01:42 +0200
Message-Id: <20221001060145.3199964-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
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

By the time port unregister is called. There should be no type set. Make
sure that the driver cleared it before and warn in case it didn't. This
enforces symmetricity with type set and port register.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2f565976979f..cac0c7852159 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9977,6 +9977,7 @@ EXPORT_SYMBOL_GPL(devlink_port_register);
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
 	lockdep_assert_held(&devlink_port->devlink->lock);
+	WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
-- 
2.37.1

