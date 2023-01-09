Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63BA6628F9
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 15:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjAIOuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 09:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbjAIOto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 09:49:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024A4564DA
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 06:46:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E06426117C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 14:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB993C433EF;
        Mon,  9 Jan 2023 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673275607;
        bh=EmOVkzlU7ALZ3DZIFhrkztKi0+T3ULZN6/ycwPPekvA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LZlRvXJ1BgE5tJnz4FwiUi0YqhHCruKA+nv2wy+mVUS06ybb8mgbkj4KduI6Y9LSO
         omsYpoHsI0I+RKCB1Kc4NVmFhquJ3vWNuCeea27jLktnxK1B0fpX/7/z3jmUPywwkl
         F5B4w7EvSuTsLOzrfUafgRoKcOozyO4HkFnAXb91S5b2wOjVnsKJ0xf7QevlB9a274
         fZkQknZouls7JLu02dr+lYS5tXX5zGgCG2PGlBmElVxIWPPiM3TTr4Oj+j77qd+ohH
         iMTcuu9Btw5axgrQ+9FT7nKqVVl0gJukUHNjkcyf1RU6OmOwjslIUR4CYwko33B2KP
         iX6ZastHNS4dg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: Re: [PATCH v2 net-next 5/5] net: ethernet: mtk_wed: add reset/reset_complete callbacks
References: <cover.1672840858.git.lorenzo@kernel.org>
        <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
        <Y7WKcdWap3SrLAp3@unreal> <Y7WURTK70778grfD@lore-desk>
        <Y7aW3k4xZVfDb6oh@unreal> <Y7a5XeLjTj1MNCDz@lore-desk>
        <20230105214832.7a73d6ed@kernel.org>
Date:   Mon, 09 Jan 2023 16:46:39 +0200
In-Reply-To: <20230105214832.7a73d6ed@kernel.org> (Jakub Kicinski's message of
        "Thu, 5 Jan 2023 21:48:32 -0800")
Message-ID: <87y1qbhik0.fsf@kernel.org>
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

(now back from vacation)

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 5 Jan 2023 12:49:49 +0100 Lorenzo Bianconi wrote:
>> > > These callbacks are implemented in the mt76 driver. I have not added these
>> > > patches to the series since mt76 patches usually go through Felix/Kalle's
>> > > trees (anyway I am fine to add them to the series if they can go into net-next
>> > > directly).  
>> > 
>> > Usually patches that use specific functionality are submitted together
>> > with API changes.  
>> 
>> I would say it is better mt76 patches go through Felix/Kalle's tree in order to avoid
>> conflicts.
>> 
>> @Felix, Kalle: any opinions?
>
> FWIW as long as the implementation is in net-next before the merge
> window I'm fine either way. But it would be good to see the
> implementation, a co-posted RFC maybe?

FWIW I agree with Lorenzo, it would be good to get mt76 patches via
Felix's tree. Otherwise the conflicts might be annoying to fix.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
