Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF7F63A9C5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbiK1Nlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiK1Nlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:41:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CFEB49C;
        Mon, 28 Nov 2022 05:41:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6530361178;
        Mon, 28 Nov 2022 13:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F13C433D6;
        Mon, 28 Nov 2022 13:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669642900;
        bh=c9KYmmV9Jd7E1V1b9Z2sFp2dehpiB3Gp3kkqi97DJjw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pq2koBUPfrVFR5bI4zQUHJja9jhYBHuJ8E33Ed1D0ngr92jT+Bn+6TAJ4EIY2U78K
         KYFfQmjNQtzjXo+Sfl3dfVjWJq/UmptNWxAVfa73FuFn5sBoutzgtIxDfSHpt2tefB
         xF6wZhuI+N0GRsLBk5dz5iqElLk4+u97LrkiDstg1FAyxrbFR5RsLj2LWvmA5pIgID
         Wagn5RsiRRjHMu1Eh2MmmdK9Ozg2Y9XuPaqvw/l4LHOuAmNtn6Uj1i2uv98kPXKOFG
         v8V/nI7/dbuuKYVMUHgcWayHMtwuHHiJgVt/F5+OC65ZgMyWMIQpp86/TGoIeHWQgG
         O5mzVgBtsOJKQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "kernel\@pengutronix.de" <kernel@pengutronix.de>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Bernie Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        neo_jou <neo_jou@realtek.com>
Subject: Re: [PATCH v3 07/11] rtw88: Add common USB chip support
References: <20221122145226.4065843-1-s.hauer@pengutronix.de>
        <20221122145226.4065843-8-s.hauer@pengutronix.de>
        <1f7aa964766c4f65b836f7e1d716a1e3@realtek.com>
        <20221128103000.GC29728@pengutronix.de>
Date:   Mon, 28 Nov 2022 15:41:32 +0200
In-Reply-To: <20221128103000.GC29728@pengutronix.de> (Sascha Hauer's message
        of "Mon, 28 Nov 2022 11:30:00 +0100")
Message-ID: <87k03f5h83.fsf@kernel.org>
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

Sascha Hauer <s.hauer@pengutronix.de> writes:

>> > +static void rtw_usb_write_port_tx_complete(struct urb *urb)
>> > +{
>> > +	struct rtw_usb_txcb *txcb = urb->context;
>> > +	struct rtw_dev *rtwdev = txcb->rtwdev;
>> > +	struct ieee80211_hw *hw = rtwdev->hw;
>> > +
>> > +	while (true) {
>> 
>> Is it possible to have a hard limit to prevent unexpected infinite loop?
>
> Yes, that would be possible, but do you think it's necessary?

It's a common advice to have a limit for loops in kernel.

> Each *txcb is used only once, It's allocated in rtw_usb_tx_agg_skb() and
> &txcb->tx_ack_queue is filled with a limited number of skbs there. These
> skbs is then iterated over in rtw_usb_write_port_tx_complete(), so I don't
> see a way how we could end up in an infinite loop here.

Everyone always say that their code is bugfree ;) More seriously though,
even if it would be bugfree now someone else can add buggy code later.
So much better to have a limit for the loop.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
