Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD8658145B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 15:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238988AbiGZNnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 09:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbiGZNnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 09:43:15 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286D220BFF
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:43:14 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bp15so26244857ejb.6
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rETLCEKGDrNCj86dYYer8boYXthwCDEdpuAewUeQt5M=;
        b=IkZrMm5dC7VbEWrOmlFRmv6NEtYtD5RmCbfqWLAQJG+pvjYDaCac/5eFDLRbGuMCR2
         nuCWL/e5kjp02KPPNXkdOKplFkJ5vJJc1dv6aXe4xjikRUhwcE6l/M4+y1MA618uxpxz
         bPQ6l3CxPkcQaznC0uAZhvphIFUJi98dVySEkfOBcCvVqTjHpEffFsw3s2ykUsphNQfV
         qT6JRjy3tevb5sa9cE9YV4NBAjth/k9hK4CKhPk0GAECfBt9sXtpijRE23Jg55koCVzB
         uRzH6NOC2qYfCtEVrkimFJ0cgtfWmFZCl3Ff3ThJTh5jj6BE45/+7EIePxxtZjnyY906
         CPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rETLCEKGDrNCj86dYYer8boYXthwCDEdpuAewUeQt5M=;
        b=AFjpLXlcfkOr6AMslIUIz7tV1v2k24w4EagACt2dvcZzfmwBYlTcc2pHkRraSBJAF3
         d7eyz4sEO/0rZsDAsBdSOzgTVMqHIrTbkpm6LEs80T4ys4fUsku1IX6pdXyZjtwhvYjF
         Zw8WTknVSuOnxjotvr6Uw3YkkucgtNqHubYDwNSVOe0SDs1LVqfOLV6dHK1U2uTMpKdG
         bndGK3pvbG9UXV+hvTlW3mAKP42Tq4d+4PX3WuB9eCxeNKxEk1nwVda1j1uppo1JmlvQ
         XxtH2ZBAI0INrIQg9PjjJwlQNRTfOXvkkDwRijU1+BfhCI7Xd8t4p5RLI5BsRWdYW21y
         6YEA==
X-Gm-Message-State: AJIora9w2g8bBt3TWib8rnzauDcJ4Z8WKjCuXw4IEiCQmUYevhrUWupq
        pxb3nU+LiKjUkq2XHdhPMeA=
X-Google-Smtp-Source: AGRyM1tnDSnJaFw8H5WCsFs1VtIwnU9FDP45Z3AS9XJc303gUzFMNAnpC9lKwzYDdCLLJsxGKcWYHQ==
X-Received: by 2002:a17:907:60c6:b0:72f:4645:ead3 with SMTP id hv6-20020a17090760c600b0072f4645ead3mr13820654ejc.321.1658842992481;
        Tue, 26 Jul 2022 06:43:12 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906218a00b00705cdfec71esm6438098eju.7.2022.07.26.06.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 06:43:11 -0700 (PDT)
Date:   Tue, 26 Jul 2022 16:43:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [patch net-next RFC] net: dsa: move port_setup/teardown to be
 called outside devlink port registered area
Message-ID: <20220726134309.qiloewsgtkojf6yq@skbuf>
References: <20220726124105.495652-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726124105.495652-1-jiri@resnulli.us>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Tue, Jul 26, 2022 at 02:41:05PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Move port_setup() op to be called before devlink_port_register() and
> port_teardown() after devlink_port_unregister().
> 
> RFC note: I don't see why this would not work, but I have no way to
> test this does not break things. But I think it makes sense to move this
> alongside the rest of the devlink port code, the reinit() function
> also gets much nicer, as clearly the fact that
> port_setup()->devlink_port_region_create() was called in dsa_port_setup
> did not fit the flow.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---

devlink_port->devlink isn't set (it's set in devl_port_register), so
when devlink_port_region_create() calls devl_lock(devlink), it blasts
right through that NULL pointer:

[    4.966960] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000320
[    5.009201] [0000000000000320] user address but active_mm is swapper
[    5.015616] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[    5.024244] CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 5.19.0-rc7-07010-ga9b9500ffaac-dirty #3395
[    5.033281] Hardware name: CZ.NIC Turris Mox Board (DT)
[    5.038499] Workqueue: events_unbound deferred_probe_work_func
[    5.044342] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    5.051297] pc : __mutex_lock+0x5c/0x460
[    5.055220] lr : __mutex_lock+0x50/0x460
[    5.133818] Call trace:
[    5.136258]  __mutex_lock+0x5c/0x460
[    5.139831]  mutex_lock_nested+0x40/0x50
[    5.143750]  devlink_port_region_create+0x54/0x15c
[    5.148542]  dsa_devlink_port_region_create+0x64/0x90
[    5.153592]  mv88e6xxx_setup_devlink_regions_port+0x30/0x60
[    5.159165]  mv88e6xxx_port_setup+0x10/0x20
[    5.163345]  dsa_port_devlink_setup+0x60/0x150
[    5.167786]  dsa_register_switch+0x938/0x119c
[    5.172138]  mv88e6xxx_probe+0x714/0x770
[    5.176058]  mdio_probe+0x34/0x70
[    5.179370]  really_probe.part.0+0x9c/0x2ac
[    5.183550]  __driver_probe_device+0x98/0x144
[    5.187902]  driver_probe_device+0xac/0x14c
