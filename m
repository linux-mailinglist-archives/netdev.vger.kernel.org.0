Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6596852D06A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 12:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbiESK1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 06:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiESK1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 06:27:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5D6A7E10;
        Thu, 19 May 2022 03:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F13861A2A;
        Thu, 19 May 2022 10:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F1AC385AA;
        Thu, 19 May 2022 10:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652956032;
        bh=zZn8lhF17xR3SguiEoCZ4AuQDVWpkYaG3umQFppop0o=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PQNyRfAnTpDMMXoFgeopUIj8zO3ymPXg+MHaFzMqTf4expv/QcR6NTCznGP1adlaW
         4oU9hyOm8KYYrhcBGBo+jhPKLIOMRAapCq4XBmSN+E2FIyc5I89Y/9Pmw60pRyMQqS
         FX05pYD53C2sSk4poB2SA1Ba72NLzEqJXag6rB2gHcXrCyjBeqHUupNi3ZO9zqHkKg
         mDAA9jv+4SyiFHXIci/95X2kl06AYPRqPkMgM8b9rRG1Jk0Vxqh9/5RPM4ViPedWxe
         BLXx3iqAMwABGe+Mvq9LE9nQUf/00bDbqFQuaYCJaLzwSq0aUoLK58Pbf/NSioZQnm
         LHfeeRD6Epqyg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: wireless: marvell: mwifiex: fix sleep in atomic context bugs
In-Reply-To: <20220519101656.44513-1-duoming@zju.edu.cn> (Duoming Zhou's
        message of "Thu, 19 May 2022 18:16:56 +0800")
References: <20220519101656.44513-1-duoming@zju.edu.cn>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Thu, 19 May 2022 13:27:07 +0300
Message-ID: <87fsl53jic.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Duoming Zhou <duoming@zju.edu.cn> writes:

> There are sleep in atomic context bugs when uploading device dump
> data on usb interface. The root cause is that the operations that
> may sleep are called in fw_dump_timer_fn which is a timer handler.
> The call tree shows the execution paths that could lead to bugs:
>
>    (Interrupt context)
> fw_dump_timer_fn
>   mwifiex_upload_device_dump
>     dev_coredumpv(..., GFP_KERNEL)
>       dev_coredumpm()
>         kzalloc(sizeof(*devcd), gfp); //may sleep
>         dev_set_name
>           kobject_set_name_vargs
>             kvasprintf_const(GFP_KERNEL, ...); //may sleep
>             kstrdup(s, GFP_KERNEL); //may sleep
>
> This patch moves the operations that may sleep into a work item.
> The work item will run in another kernel thread which is in
> process context to execute the bottom half of the interrupt.
> So it could prevent atomic context from sleeping.
>
> Fixes: f5ecd02a8b20 ("mwifiex: device dump support for usb interface")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>

Have you tested this on real hardware? Or is this just a theoretical
fix?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
