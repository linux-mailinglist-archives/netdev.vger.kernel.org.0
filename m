Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77C752D69B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbiESO7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbiESO6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:58:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB45D6819;
        Thu, 19 May 2022 07:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B31561A0A;
        Thu, 19 May 2022 14:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AFF1C385AA;
        Thu, 19 May 2022 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652972331;
        bh=1JQxQTlxaZfO+tcIR3YEL38bUDaUxamRUvfS6PQ/nSo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kGlGl6s/QiWP392yedpgzZjzPzba4SABKrtwz2wQTX/mc8Om88/7ZnXsBeTkN3ugi
         x5phwovTpaGoDsD7dwNOCJAOl0fdxh3/x7aGVU4tmY6r6gZnqoRe+yUlsIOhC4XrZ6
         wYTnoAyd0isAO48/2pi9dZdpEtDpix+N/R7Kh/OS6mhy1O12fmPFwY5LvPAkauMyig
         1cB9wo4jp0zl5VefTUAYeXTMry8/RgVcOL7HI/geX9Y8Xo/nQeDzoMsyf//BI6fWHr
         +8L9jH8ZXeywCT1T9jRqIArQkhEM3SlbEcP1D5I8LDXIBmXaoImmeix74N3UoIfOhD
         JLbldzxT8387Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: wireless: marvell: mwifiex: fix sleep in atomic context bugs
References: <20220519135345.109936-1-duoming@zju.edu.cn>
Date:   Thu, 19 May 2022 17:58:47 +0300
In-Reply-To: <20220519135345.109936-1-duoming@zju.edu.cn> (Duoming Zhou's
        message of "Thu, 19 May 2022 21:53:45 +0800")
Message-ID: <87zgjd1sd4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
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

mwifiex patches go to wireless-next, not net tree.

> ---
> Changes in v2:
>   - Fix compile problem.

So you don't even compile test your patches? That's bad and in that case
I'll just directly drop this. We expect that the patches are properly
tested.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
