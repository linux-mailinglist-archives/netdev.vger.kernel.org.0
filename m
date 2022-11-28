Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E82063A592
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 11:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiK1KB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 05:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiK1KBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 05:01:49 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA39419C0E
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 02:01:48 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id fy37so24360511ejc.11
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 02:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TaED7/FMW6uanzO8nsY4BAuYh6b0JVfOwYuTy9BD+Jo=;
        b=sct4EBsgFPPMuQhWgg/vq1mP5wbpt9XC9CEQ2+NjOGO9wcl2Rgi9H0IkyuG+eWW0Gt
         fXaDgfZ8lNorIz7aQlEX0fT5KU0ibzshcwIMWCoK30+PvfwUsol7mi03V2zoSpTAeWp+
         ypo9sNhjfBIUm5X5d7/eHnoQBjeIBnFIQjbgq6DZW8wg/3ngjuFWD7q6FRowWo3gPa6X
         kjLBxTBh8Xdhbf/cVqbGcDyNm0XpRM6o0NlshYZf9hlyvj63fsRydoeDv0UvNnVbisyk
         n6uvFwtfD2MeJtdozd+8Av1p9aK1nuG07A+VaReBVSoNvxpRDkZYsyfNPyCyjtmuMI8H
         q/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TaED7/FMW6uanzO8nsY4BAuYh6b0JVfOwYuTy9BD+Jo=;
        b=05m8cYgvi/d4eEl5ukhyFMQR8y7q266P+67ngK8ibTRg5eYb8cmaVwkMr/MQnQXnM5
         QjQ45zqBvI6Bd/VkE3L46Yi2YqS1Qj18dZeo4dvUyeuUsYIlQrGnlUI1shRiid2ctVaQ
         FCM2vsk1EJat/IOZ95tFv+ZYryfdGC72+dUcjYzewBoFqRB/1B7JsM5N2N/D8gD5cmPW
         0p5SrgnBYeZX9JqzVcZSEU/hObYAcEYxYjcwNEbIYWCOc/7DuIFJMfDkfc7TFFtRf/zk
         6RUPUEYBWw1kIfUXo+ueHrb2gnlETaInVQXf/Zw1NSwpxKBHBj6WrZcq1AL6NYhR1sU8
         BFHw==
X-Gm-Message-State: ANoB5pnK5duzdw6iMPv3aZ17rIAO8qmfSzjo9PP8AzarMOI2acCF2hFF
        ADC5DGG9nukjv5cFc0546SRO7A==
X-Google-Smtp-Source: AA0mqf4xdJZioOaMrj3qufkVWna2XlN15/l/ej/2qxrtFbNn7EjGM8K/CC4HYzlZ6GYXh96LjrMBmA==
X-Received: by 2002:a17:906:7244:b0:7ae:2964:72dc with SMTP id n4-20020a170906724400b007ae296472dcmr17850110ejk.111.1669629707408;
        Mon, 28 Nov 2022 02:01:47 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b12-20020aa7c6cc000000b0046ab2bd784csm4116645eds.64.2022.11.28.02.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 02:01:46 -0800 (PST)
Date:   Mon, 28 Nov 2022 11:01:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4SHCVw80UyB5irX@nanopsycho>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122121048.776643-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 22, 2022 at 01:10:48PM CET, yangyingliang@huawei.com wrote:

[...]


>
>Fixes: a62fdbbe9403 ("netdevsim: implement ndo_get_devlink_port")
>Reported-by: Zhengchao Shao <shaozhengchao@huawei.com>
>Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>---
> net/core/devlink.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 89baa7c0938b..6453ac0558fb 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -250,6 +250,9 @@ void devlink_put(struct devlink *devlink)
> 
> struct devlink *__must_check devlink_try_get(struct devlink *devlink)
> {
>+	 if (!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED))

        ^
You have an extra space here. Checkpatch would warn you.


>+		return NULL;
>+
> 	if (refcount_inc_not_zero(&devlink->refcount))
> 		return devlink;
> 	return NULL;
>-- 
>2.25.1
>
