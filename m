Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C2951E534
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 09:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241283AbiEGH1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 03:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238791AbiEGH1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 03:27:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2A536177
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 00:23:31 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d17so9475082plg.0
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 00:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2aoziQR+OkvQ6CKS1VMuJEjlRMwhQeoEIM3T522zixs=;
        b=gxFGafBiSnLcFDFNS7rmnLKfO2j+jHxYmkoWBiWgv8umcNy1PMT+nvKZ0NGWrtaWmP
         E91yTFtYxG+z9lx/uzyirWeNHJCHrd0arQlsqcys4pYZT5l1HxvMb62HsAUCYOUDf6Cl
         cMW9FfAYinLN8A+K8bUSGm10Ng8O8ZySOAzg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2aoziQR+OkvQ6CKS1VMuJEjlRMwhQeoEIM3T522zixs=;
        b=Z4uwb6V6nphLGSfTCY9KfxcD4ZWm8ao41//zShxJJYT+A+OsvYnhOxjCea1rOhCBii
         /qh55UGP5jf30RkqKBV440i+vUUkk21MPLAr5YjnasXKW9JiNM54dlxq3UBZso15m3cI
         tvvMrnx9PZsZVqtIA6wKvI3p1Xc4KZTEPhqQ1jWNKUWNIFDL78MQ0Pkz+aNoXOm1zYiw
         s2ZuYxfLa/nsxRhSEDSRcc4JwcwuEjC3r2Ji8P/21SM5bP/k74SM9y70BqLwxp/PX4xJ
         JAf5+prQT9nJf3SrripxuZS1l15e8hntaK4hopDayQz6oSUGr0GZHjiBbUSPHTgYBoMC
         Fx8g==
X-Gm-Message-State: AOAM531+HG/qD9o93rgbCKFG1KNXWJJN579rUBIjpB4fWC9YJt6FY7oY
        9tA2YgK4Hrt6La5igHJx3WYqIQ==
X-Google-Smtp-Source: ABdhPJzONCfdNpt1xZcYV8Lopo6pM/wwD6POHAdm7ZdPIDnrX53aOPcE2QxY2wEMERuGuGno3rWOHA==
X-Received: by 2002:a17:90a:9901:b0:1cb:aa19:5eee with SMTP id b1-20020a17090a990100b001cbaa195eeemr8582987pjp.158.1651908210768;
        Sat, 07 May 2022 00:23:30 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id rj4-20020a17090b3e8400b001cd4989ff42sm4885912pjb.9.2022.05.07.00.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 00:23:30 -0700 (PDT)
Date:   Sat, 7 May 2022 00:23:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Message-ID: <202205070019.F1EA24550@keescook>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com>
 <20220506153414.72f26ee3@kernel.org>
 <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
 <20220506185405.527a79d4@kernel.org>
 <CANn89iKQtn0a-Etk-tBrwafbe6dkBz=d3=bkwd8j8_Ed+kiCPQ@mail.gmail.com>
 <20220506193734.408c2a0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506193734.408c2a0d@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 07:37:34PM -0700, Jakub Kicinski wrote:
> On Fri, 6 May 2022 19:10:48 -0700 Eric Dumazet wrote:
> > On Fri, May 6, 2022 at 6:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Without our patches drivers/net/ethernet/mellanox/mlx5/core/ builds
> > > cleanly. Gotta be the new W=1 filed overflow warnings, let's bother
> > > Kees.  
> > 
> > Note that inline_hdr.start is a 2 byte array.
> > 
> > Obviously mlx5 driver copies more than 2 bytes of inlined headers.
> > 
> > mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs)
> > is called already with attr->ihs > 2
> > 
> > So it should already complain ?
> 
> It's a static checker, I presume it ignores attr->ihs because 
> it can't prove its value is indeed > 2. Unpleasant :/

I think it's actually the reverse. GCC keeps getting better about tracking
potential variable value ranges. In this case it thinks ihs WILL be > 2.
And this is bumping up against the kernel's lack of "intentional overflow"
annotations in source (i.e. structure layouts). But we can't protect
against unintentional overflow unless we've been able to explicitly
describe to the compiler what is intended.

-- 
Kees Cook
