Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E70468165B
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbjA3Q1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbjA3Q1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:27:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E98943901;
        Mon, 30 Jan 2023 08:27:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C579611D6;
        Mon, 30 Jan 2023 16:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2805C433D2;
        Mon, 30 Jan 2023 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675096066;
        bh=MpRxwOorlRNqi9cT3F3n0BN25b601lq2po+QEY2VOdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GJzy+jQBBZrIO4R3XUtjRzTPckHuk4fxqmTyS8OWyquU3If0q3g2ab7EP9LAaVsS6
         PidWsqxtQojYwETN3TDNeUWHkxv/FmygE2fTkQ0ki/CgcyCQeB0qhCNdWmK3Tc9k84
         oZgxFCaZ+2uFhrk7INNmUO433PNsMBz0P++62MLU=
Date:   Mon, 30 Jan 2023 17:27:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?utf-8?B?0JbQsNC90LTQsNGA0L7QstC40Ycg0J3QuNC60LjRgtCwINCY0LPQvtGA0LU=?=
         =?utf-8?B?0LLQuNGH?= <n.zhandarovich@fintech.ru>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH 5.10 1/1] mt76: fix mt7615_init_tx_queues() return value
Message-ID: <Y9fv/7g4EduQmllt@kroah.com>
References: <20230130123655.86339-1-n.zhandarovich@fintech.ru>
 <20230130123655.86339-2-n.zhandarovich@fintech.ru>
 <Y9fAkt/5BRist//g@kroah.com>
 <b945bd5f3d414ac5bc589d65cf439f7b@fintech.ru>
 <Y9fIFirNHNP06e1L@kroah.com>
 <e17c785dbacf4605a726cc939bee6533@fintech.ru>
 <Y9fNs5QWbrJh+yH6@kroah.com>
 <bbd1ce753d8144ee9d4d9da7f3033c68@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bbd1ce753d8144ee9d4d9da7f3033c68@fintech.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 04:13:11PM +0000, Жандарович Никита Игоревич wrote:
> > > > What is the "fault"?
> > >
> > > In 5.10.y "mt7615_init_tx_queues() returns 0 regardless of how final
> > > mt7615_init_tx_queue() performs. If mt7615_init_tx_queue() fails (due
> > > to memory issues, for instance), parent function will still
> > > erroneously return 0."
> > 
> > And how can memory issues actually be triggered in a real system?  Is this a
> > fake problem or something you can validate and verify works properly?
> > 
> > Don't worry about fake issues for stable backports please.
> > 
> > thanks,
> > 
> > greg k-h
> 
> mt7615_init_tx_queue() calls devm_kzalloc() (which can throw -ENOMEM) and mt76_queue_alloc() (which can also fail). It's hard for me to gauge how probable these failures can be. But I feel like at the very least it's a logical sanity check. 

Again, how can those allocations really fail?  Or the queue allocation?
Can you test this?  If not, it's not a real failure that you need to
backport.  Otherwise all of the little tiny "fix up this potential
failure path" patches would need to be backported, and that's just crazy
if they can not be hit in normal operation.

And please line-wrap your emails :(

thanks,

greg k-h
