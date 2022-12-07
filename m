Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5AA9645116
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLGBYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLGBYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:24:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664B63E09D
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 17:24:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A638CCE1AC2
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56499C433C1;
        Wed,  7 Dec 2022 01:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670376267;
        bh=FPdfUOVq71widnt/rP5bz8etf16EdqYElslpYiElRrE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gDTQhVdcwUpsUQNRZRp0lDiK1wnybP7LNLHIt0JBjkhSc0w10Tvd6mfIu7+wCNRg7
         RE9UFt0EcEZl+mntSxxB7p93dX0EeMUzbIkiKNmNOTa99ZMROwAYdvBzVQQWYsSsdH
         wVWVvL7/SYqEUCFb2tcnnZZ525qbQ5pmfyqyu4DYKCwOPXihPw2S5cUGFwWd/qFZzR
         6sVSYEFCzN2aH31KZvrG78kd7PtmCYhiPes+kIb/GCzkpea8vWOtIvYeYe7euEhHqy
         y6hSOOBPyqqlWnhQGJdyeROCg/ljvJdA8J7eJD0YVTCXfVXYTAKuCpWBN9HioAF1XK
         74glwHapxtWiw==
Date:   Tue, 6 Dec 2022 17:24:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: fix possible deadlock
 if mtk_wed_wo_init fails
Message-ID: <20221206172426.7e7cf3bf@kernel.org>
In-Reply-To: <Y4/VvGi2d0/0RrRW@lore-desk>
References: <a87f05e60ea1a94b571c9c87b69cc5b0e94943f2.1669999089.git.lorenzo@kernel.org>
        <Y4ybbkn+nXkGsqWe@unreal>
        <Y4y4If8XXu+wErIj@lore-desk>
        <Y42d2us5Pv1UqhEj@unreal>
        <Y420B4/IpwFHJAck@lore-desk>
        <20221205174441.30741550@kernel.org>
        <Y4/VvGi2d0/0RrRW@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Dec 2022 00:52:28 +0100 Lorenzo Bianconi wrote:
> > FWIW, that does seem slightly better to me as well.
> > Also - aren't you really fixing multiple issues here 
> > (even if on the same error path)? The locking, 
> > the null-checking and the change in mtk_wed_wo_reset()?  
> 
> wo NULL pointer issue was not hit before for the deadlock one (so I fixed them
> in the same patch).
> Do you prefer to split them in two patches? (wo null pointer fix first).

Yes, I think they are different issues even if once "covers" the other.
I think it'd make the review / judgment easier.

> I have posted v2 addressing Leon's comments but I need to post a v3 to add
> missing WARN_ON.

