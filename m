Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DF450C7D0
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 08:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbiDWGiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 02:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiDWGiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 02:38:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E691738EB;
        Fri, 22 Apr 2022 23:35:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D784B801BB;
        Sat, 23 Apr 2022 06:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD79C385A0;
        Sat, 23 Apr 2022 06:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650695720;
        bh=uj117Fj0AoiisjMt1kk2aSrqooXMqVlr2Vxsn5y3Q+g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eH/LKVoNGyp2Ix5Znj3F6z74ZX9Ey3qSMlPdX4tw0zeFqJ2zTXbzACJNdnxKfI3+M
         B20pItwMgjzz0uKaMQm8k6WD+F6X3cbG6aR5vlbhmGSVT02mT5svKwDKWMxWUpHmpI
         xOz2r3dn+M+b/6YHmAynf+otgkUluHD+IOZt+7syYAd1wBLBhxsFOlKP1M5JqIadny
         +2qbySaFlEt5m2UZhgNALM1x0EPbgEEqW2kL49bMWt8Mqcssbhtz+LLzzoNbQxbDlq
         iE+rYwAQNsCgSLVc0Ig2KbJ8q3QPPDsJ+QIV6n6glgX6wbCt6ZlthMru/ljizcPDtx
         DUMTvZL7/YmpQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     "Greenman\, Gregory" <gregory.greenman@intel.com>,
        "linux\@roeck-us.net" <linux@roeck-us.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rostedt\@goodmis.org" <rostedt@goodmis.org>,
        "Berg\, Johannes" <johannes.berg@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "Coelho\, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH] iwlwifi: iwl-dbg: Use del_timer_sync() before freeing
References: <20220411154210.1870008-1-linux@roeck-us.net>
        <afd746404a74657a288a9272bf0c419c027dbd06.camel@intel.com>
        <CA+icZUVEfKcGi7ME3hoyinz2VQxLKhCXgwDA2K3AB7MEK-bveQ@mail.gmail.com>
Date:   Sat, 23 Apr 2022 09:35:16 +0300
In-Reply-To: <CA+icZUVEfKcGi7ME3hoyinz2VQxLKhCXgwDA2K3AB7MEK-bveQ@mail.gmail.com>
        (Sedat Dilek's message of "Wed, 13 Apr 2022 17:06:26 +0200")
Message-ID: <87fsm4mhnf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sedat Dilek <sedat.dilek@gmail.com> writes:

> On Wed, Apr 13, 2022 at 11:56 AM Greenman, Gregory
> <gregory.greenman@intel.com> wrote:
>>
>>
>> On Mon, 2022-04-11 at 08:42 -0700, Guenter Roeck wrote:
>> > In Chrome OS, a large number of crashes is observed due to corrupted
>> > timer
>> > lists. Steven Rostedt pointed out that this usually happens when a
>> > timer
>> > is freed while still active, and that the problem is often triggered
>> > by code calling del_timer() instead of del_timer_sync() just before
>> > freeing.
>> >
>> > Steven also identified the iwlwifi driver as one of the possible
>> > culprits
>> > since it does exactly that.
>> >
>> > Reported-by: Steven Rostedt <rostedt@goodmis.org>
>> > Cc: Steven Rostedt <rostedt@goodmis.org>
>> > Cc: Johannes Berg <johannes.berg@intel.com>
>> > Cc: Gregory Greenman <gregory.greenman@intel.com>
>> > Fixes: 60e8abd9d3e91 ("iwlwifi: dbg_ini: add periodic trigger new API
>> > support")
>> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> > ---
>> > v1 (from RFC):
>> >     Removed Shahar S Matityahu from Cc: and added Gregory Greenman.
>> >     No functional change.
>> >
>> > I thought about the need to add a mutex to protect the timer list,
>> > but
>> > I convinced myself that it is not necessary because the code adding
>> > the timer list and the code removing it should never be never
>> > executed
>> > in parallel.
>> >
>> >  drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
>> > b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
>> > index 866a33f49915..3237d4b528b5 100644
>> > --- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
>> > +++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
>> > @@ -371,7 +371,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans
>> > *trans)
>> >         struct iwl_dbg_tlv_timer_node *node, *tmp;
>> >
>> >         list_for_each_entry_safe(node, tmp, timer_list, list) {
>> > -               del_timer(&node->timer);
>> > +               del_timer_sync(&node->timer);
>> >                 list_del(&node->list);
>> >                 kfree(node);
>> >         }
>>
>> Hi Kalle,
>>
>> Can you please pick it up to wireless-drivers for the next rc?
>> It is an important fix.
>> Luca has already assigned it to you in patchwork.
>>
>> Thanks!
>>
>> Acked-by: Gregory Greenman <gregory.greenman@intel.com>
>
> I have tested this on top of Linux v5.17.3-rc1.
>
> Feel free to add my...
>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # Linux v5.17.3-rc1 and
> Debian LLVM-14

Please keep the Tested-by in one line, otherwise patchwork cannot parse
it correctly. I fixed this manually during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
