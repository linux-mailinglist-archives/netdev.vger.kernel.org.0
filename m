Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77725302E4
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 14:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbiEVMG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 08:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiEVMGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 08:06:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379D833A15;
        Sun, 22 May 2022 05:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB66CB80ABE;
        Sun, 22 May 2022 12:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD86C385AA;
        Sun, 22 May 2022 12:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653221210;
        bh=Bv4fPAC02UiEzOpCW/6I2VdtMA0+IkET8ctddcaHySw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=s7mxyYOGYPOEYXDnU5scfo/z7dUPNJnM0qoSoDeJGbwXGuhILMm4gjujLc6uy6CFh
         1ROnra4bCAyeOMVYlCKijZmR9JF3uBFyO39NF+CkGoeO+fSiVuQXvAcOjwhReaIsvi
         Wn846qegZsELrlhVg71ccCfaBsq8LOxRuL++x0HuzwX3EA+CsfNtXFFeDFQu3nm1m8
         HAJRCMcfFq4WPMSvrCtJkLsKfr99ICpOrbm016rls+RsXmVGZfoNbMi8Fmw4y5ILhO
         NMbPmjEKEEcDlSzMgsaMtiPmWLydjC6+DA+6gThNSGUrKeD0rkVnPnHCK7KyPNf04l
         8lPVEqQL5+nfg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, toke@toke.dk,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH net-next 2/8] wifi: ath9k: silence array-bounds warning on GCC 12
In-Reply-To: <20220521105347.39cac555@kernel.org> (Jakub Kicinski's message of
        "Sat, 21 May 2022 10:53:47 -0700")
References: <20220520194320.2356236-1-kuba@kernel.org>
        <20220520194320.2356236-3-kuba@kernel.org> <87h75j1iej.fsf@kernel.org>
        <20220521105347.39cac555@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Sun, 22 May 2022 15:06:43 +0300
Message-ID: <87bkvp22lo.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Sat, 21 May 2022 09:58:28 +0300 Kalle Valo wrote:
>> > +# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
>> > +ifndef KBUILD_EXTRA_WARN
>> > +CFLAGS_mac.o += -Wno-array-bounds
>> > +endif  
>> 
>> There are now four wireless drivers which need this hack. Wouldn't it be
>> easier to add -Wno-array-bounds for GCC 12 globally instead of adding
>> the same hack to multiple drivers?
>
> I mean.. it's definitely a hack, I'm surprised more people aren't
> complaining. Kees was against disabling it everywhere, AFAIU:
>
> https://lore.kernel.org/all/202204201117.F44DCF9@keescook/

Wasn't Kees objecting of disabling array-bounds for all GCC versions?
That I understand, but I'm merely suggesting to disable the warning only
on GCC 12 until the compiler is fixed or the drivers are fixed.

> WiFi is a bit unfortunate but we only have 3 cases in the rest of
> networking so it's not _terribly_ common.
>
> IDK, I'd love to not see all the warnings every time someone touches
> netdevice.h :( I made a note to remove the workaround once GCC 12 gets
> its act together, that's the best I could come up with.

Ok, fair enough. I'm just worried these will be left lingering for a
long time and do more harm than good :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
