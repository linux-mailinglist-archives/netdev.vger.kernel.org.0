Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713A36A1013
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 20:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjBWTGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 14:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjBWTGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 14:06:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100EF52DE4;
        Thu, 23 Feb 2023 11:06:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A97616DE;
        Thu, 23 Feb 2023 19:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BBDC433D2;
        Thu, 23 Feb 2023 19:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677179164;
        bh=XppVl+0anAeipNeoaerXbgrBjpojEcKUhkLAUcnE1uE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oRT8O74pTNHQpp23rqc9KuvLMNsX1iIT7PCSAdC88ZyuIMYn3GUMaWVhGWbVl6283
         Ny3vPGC5st/yninLEDXSKQ+cq9/KwkyCb03e3p8qnLeGkevdAWc327BrvxVi+ecGDU
         hdR4bX/koQCxiYpBfyMBk+Y1jyNEWVKLgr0ZTKjtFFzsMfTTdrUxlhx4YXwUtn6M/J
         eblZqx0j/HXbn/PtTVO+byYmaTndjuGAP7Iizv4Q9jW1lLFVTALHK2V8HwVkvOFpS1
         0Tr29M4EL6faUmknHO6KMJknGhwKiJukPd6v+2ronylL4x6znIKnaiEZ81upAE6mo3
         x5mO2ukHt2eYQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, ast@kernel.org
Subject: Re: [PULL] Networking for v6.3
References: <20230221233808.1565509-1-kuba@kernel.org>
        <CAHk-=wjTMgB0=PQt8synf1MRTfetVXAWWLOibnMKvv1ETn_1uw@mail.gmail.com>
Date:   Thu, 23 Feb 2023 21:06:00 +0200
In-Reply-To: <CAHk-=wjTMgB0=PQt8synf1MRTfetVXAWWLOibnMKvv1ETn_1uw@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 23 Feb 2023 09:21:38 -0800")
Message-ID: <87pma02odj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, Feb 21, 2023 at 3:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
> --
>> Networking changes for 6.3.
>
> Hmm. I just noticed another issue on my laptop: I get an absolute *flood* of
>
>   warning: 'ThreadPoolForeg' uses wireless extensions that are
> deprecated for modern drivers: use nl80211
>
> introduced in commit dc09766c755c ("wifi: wireless: warn on most
> wireless extension usage").
>
> This is on my xps13 with Atheros QCA6174 wireless ("Killer 1435
> Wireless-AC", PCI ID 168c:003e, subsystem 1a56:143a).
>
> And yes, it uses 'pr_warn_ratelimited()', but the ratelimiting is a
> joke. That means that I "only" get five warnings a second, and then it
> pauses for a minute or two until it does it again.
>
> So that warning needs to go away - it flushed the whole kernel printk
> buffer in no time.

Ouch, sorry about that. The ratelimiting is really a joke here. We'll
send a patch tomorrow.

So that we can file a bug report about use of Wireless Extensions, what
process is ThreadPoolForeg? I did a quick search and it seems to be
Chromium related, but is it really from Chromium? The warning was
applied over a month ago, I'm surprised nobody else has reported
anything. I would expect that there are more Chromium users :)

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
