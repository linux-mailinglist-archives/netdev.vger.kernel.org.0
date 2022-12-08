Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E43A646FF0
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiLHMod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:44:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiLHMob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:44:31 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8D5654FC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:44:29 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id n20so3637792ejh.0
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 04:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9FMn7DnGnd415t5/zVDmH2WGI3qdVGllQ1F13Id+kms=;
        b=N3PHHZKPMtRhWJcHG8ahux3NqOFKVCuPnVzu2/fmx3FtPiEihDyOV2Y4Yd6xvLpMGZ
         ontPwuYzhiovO8JV8jCTikJPiWeo5rd3mDLWKAlxINJiRB//6topVeuby05CAmQD8tHG
         nGBuNnWvCHfgFi5HedNixPLAYF78I2nflHwaoYRtu31dTH+aMC+xf+GqCl4bnejPeIDf
         hwi7AS3zKINCcDtds71AxLI9lCUj6bP53iY4TKmsiu8meW/RIyq/KzFFbYeJJcgpKZkC
         glXnzknwV5OVNrp+v/9ITKdbxgUJjojRp8ehOJtCCbLS6X41DFn+hpKqosBkyB51Wn8B
         M6VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9FMn7DnGnd415t5/zVDmH2WGI3qdVGllQ1F13Id+kms=;
        b=Et+iNrHbmTqHGFuYNAiKqx9tMnDVqikedsg+8ADY01eEYIE+JQVDDXhzk6lzQzsQqi
         TORn4ipst+ZJVQb21Bt2t5dPQ1Ytchp4xteuPcIYM/+oGYocRJTZBoLex639yeyaFr/f
         RBwFtwoDPikwBCLibntE55t2C9mM6hPgSz+0SaglLOrsuby5xNjYc5Bkb6B0GmP9pF4T
         /GSOKZT5dT7tMUmY4UZx/iaYlGn26MUqD1QxMqnlGlp1ihFwYYo7/lAmR1VXrn/5j7Vk
         UxG/TYq69jd+zKqJrNNdcetTmcDi/IrYEoOGI7q7uPCPl9InVpeuM9roEyqRg+KEQCIc
         /qCg==
X-Gm-Message-State: ANoB5pkn7khZt4EEaPoFtWZ6Uz4QgGZb1a14WIzuASUDeZr4yM1Qv2Sr
        BcXRUUjwaJaVA3oYRyJUDsSGiw==
X-Google-Smtp-Source: AA0mqf75MCQ2MFPLMcwLvxGwTeg18btnHyLD07tdOwSbJT4aEqDf7vWslSG38U0SIdDbwZtqUYieBQ==
X-Received: by 2002:a17:906:30d3:b0:78d:f454:ba10 with SMTP id b19-20020a17090630d300b0078df454ba10mr1719627ejb.15.1670503468502;
        Thu, 08 Dec 2022 04:44:28 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n11-20020a170906118b00b007be696512ecsm9544772eja.187.2022.12.08.04.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 04:44:27 -0800 (PST)
Date:   Thu, 8 Dec 2022 13:44:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     kevin.curtis@farsite.co.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: farsync: Fix kmemleak when rmmods farsync
Message-ID: <Y5HcKlwQuzhpzZs9@nanopsycho>
References: <20221208120540.3758720-1-lizetao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208120540.3758720-1-lizetao1@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 08, 2022 at 01:05:40PM CET, lizetao1@huawei.com wrote:
>There are two memory leaks reported by kmemleak:
>
>  unreferenced object 0xffff888114b20200 (size 128):
>    comm "modprobe", pid 4846, jiffies 4295146524 (age 401.345s)
>    hex dump (first 32 bytes):
>      e0 62 57 09 81 88 ff ff e0 62 57 09 81 88 ff ff  .bW......bW.....
>      01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
>      [<ffffffff83d35c78>] __hw_addr_add_ex+0x198/0x6c0
>      [<ffffffff83d3989d>] dev_addr_init+0x13d/0x230
>      [<ffffffff83d1063d>] alloc_netdev_mqs+0x10d/0xe50
>      [<ffffffff82b4a06e>] alloc_hdlcdev+0x2e/0x80
>      [<ffffffffa016a741>] fst_add_one+0x601/0x10e0 [farsync]
>      ...
>
>  unreferenced object 0xffff88810b85b000 (size 1024):
>    comm "modprobe", pid 4846, jiffies 4295146523 (age 401.346s)
>    hex dump (first 32 bytes):
>      00 00 b0 02 00 c9 ff ff 00 70 0a 00 00 c9 ff ff  .........p......
>      00 00 00 f2 00 00 00 f3 0a 00 00 00 02 00 00 00  ................
>    backtrace:
>      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
>      [<ffffffffa016a294>] fst_add_one+0x154/0x10e0 [farsync]
>      [<ffffffff82060e83>] local_pci_probe+0xd3/0x170
>      ...
>
>The root cause is traced to the netdev and fst_card_info are not freed
>when removes one fst in fst_remove_one(), which may trigger oom if
>repeated insmod and rmmod module.
>
>Fix it by adding free_netdev() and kfree() in fst_remove_one(), just as
>the operations on the error handling path in fst_add_one().
>
>Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>Signed-off-by: Li Zetao <lizetao1@huawei.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

On top, may be worth ordering the cleanup in fst_remove_one() to be
aligned with the order in fst_add_one() error path.
