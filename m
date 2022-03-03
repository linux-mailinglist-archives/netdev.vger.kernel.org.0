Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1339D4CBDB7
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 13:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiCCM0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 07:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbiCCMZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 07:25:58 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE212179258;
        Thu,  3 Mar 2022 04:25:06 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id t19so827977plr.5;
        Thu, 03 Mar 2022 04:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=5klmtEuPK05A2bZEnhFnExu8KFOALZ0/el122sDEVgQ=;
        b=ZWxHGbWbbQVwMO3M+0bh+UF6Lgyjvb0hppo10T43cEgQsTMDdwGOI3irvZhVQLRX0+
         zQtYFkfx2q9G3wkdo4w9wnKGxLw69UPJNIaOamu3Cpn0DcksjajBB0RScDg+p9Vtvx57
         QYfFHq/gWIZ/a5KPlA9SxSqqFKkarUpd5NneuBwyFcPRKVMAih2BGbjFF0GEte3L4rrR
         hdGlJMmHhW5idLEC3Fvf74+hMDPO2Dc0lPLdujSsGmxXTjoBnFOKS4CIAW6fo2dTFcGf
         kO0ZcEyAAr0+mQcvXVcSTwhEEqNrAonomJODFkO2uh8ouQirFDjjk62RGJJHviszoazo
         vreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=5klmtEuPK05A2bZEnhFnExu8KFOALZ0/el122sDEVgQ=;
        b=Q2gqkB3AQkLrIjT1TFKVfxrW0xjcjG0qu/4b2w3kZ7PSxYk1c/HViQCHScu7sYByWT
         oeKDWFD2U6SLT4Pfc6LqpLvm6DHt9xn4e+JfAKrKgInVToIUh1tNFvJ6G/vQEDh0jDe5
         AT2zD3Cst1StCm4THe7IO2inJiT2NCdSt3LL0/G/7H+HKJ8In5mEy9eqDHiNPa2ws1Qr
         PN9VDeHLhSAdcfldvn7bJvmT56/RCwZzTNjSuruUGyVTFGnDD5ZKeP8HAiITd7VVgSDM
         IyCe6sJs+OKCsSKE2jT0rKNz3npxsvlOj3ZLa7gEW6lXDYKjF3JvoP742f03HdpBfFgV
         /3IA==
X-Gm-Message-State: AOAM533VKlgbESHsEwTaqkhyCh+Dcz4Ec3XvsmjxEqUI0wOT6Cq4jWAG
        zcyygv/c2iabimC2mrhX3/1gjIN1/4YG0jSFigP/iPBytnlAxAU=
X-Google-Smtp-Source: ABdhPJwaLUMlExda1aQnb1hgeI9rCTldFuSOnET20jKc2ckT7XjgFOFv74ioMh2f5cTpAAx9rkZuABWf1V7CPo7DxVk=
X-Received: by 2002:a17:902:8a91:b0:14f:969b:f6be with SMTP id
 p17-20020a1709028a9100b0014f969bf6bemr36109864plo.161.1646310305880; Thu, 03
 Mar 2022 04:25:05 -0800 (PST)
MIME-Version: 1.0
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Thu, 3 Mar 2022 20:24:53 +0800
Message-ID: <CAMhUBjkt1E4gQ5-sgAfPvKqNrfXBFUQ14zRP=MWPwfhZJu3QPA@mail.gmail.com>
Subject: [BUG] net: macb: Use-After-Free when removing the module
To:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing the macb_pci module, the driver will cause a UAF bug.

Commit d82d5303c4c5 ("net: macb: fix use after free on rmmod") moves
the platform_device_unregister() after clk_unregister(), but this
introduces another UAF bug.

The following log reveals it:

[   64.783836] BUG: KASAN: use-after-free in clk_prepare+0x32/0x50
[   64.794805]  kasan_report+0x45/0x60
[   64.795226]  clk_prepare+0x32/0x50
[   64.795641]  macb_runtime_resume+0xc4/0x2e0
[   64.796149]  __rpm_callback+0x3e8/0xa30
[   64.796621]  ? ktime_get_mono_fast_ns+0x97/0x1c0
[   64.797172]  ? pm_generic_runtime_suspend+0xb0/0xb0
[   64.797760]  rpm_resume+0xff5/0x1860
[   64.798194]  ? _raw_spin_lock_irqsave+0x7a/0x140
[   64.798751]  __pm_runtime_resume+0x105/0x160
[   64.799253]  device_release_driver_internal+0x13c/0x7c0
[   64.799874]  bus_remove_device+0x2d0/0x340

[   64.816165] Allocated by task 252:
[   64.817167]  ____kasan_kmalloc+0xb5/0xf0
[   64.817669]  __clk_register+0x98d/0x23b0
[   64.818149]  clk_hw_register+0xb2/0xd0
[   64.818610]  clk_register_fixed_rate+0x290/0x350
[   64.819861]  macb_probe+0x233/0x590 [macb_pci]
[   64.820411]  local_pci_probe+0x13f/0x210
[   64.820890]  pci_device_probe+0x34c/0x6d0
[   64.821368]  really_probe+0x24c/0x8d0
[   64.821814]  __driver_probe_device+0x1b3/0x280
[   64.822346]  driver_probe_device+0x50/0x370

[   64.828473] Freed by task 485:
[   64.829440]  kasan_set_track+0x3d/0x70
[   64.829901]  kasan_set_free_info+0x1f/0x40
[   64.830396]  ____kasan_slab_free+0x103/0x140
[   64.830914]  kfree+0xf2/0x270
[   64.831275]  clk_unregister+0x6df/0x8d0
[   64.831739]  macb_remove+0x89/0xc0 [macb_pci]
[   64.832252]  pci_device_remove+0x92/0x240
[   64.832741]  device_release_driver_internal+0x4e4/0x7c0
[   64.833365]  driver_detach+0x1e1/0x2b0
[   64.833817]  bus_remove_driver+0xf2/0x1d0
[   64.834294]  pci_unregister_driver+0x29/0x1a0

Regards,
Zheyu Ma
