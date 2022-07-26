Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38888581BB4
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiGZViL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGZViK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:38:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2382225C5D;
        Tue, 26 Jul 2022 14:38:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4701616CF;
        Tue, 26 Jul 2022 21:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B398AC433D6;
        Tue, 26 Jul 2022 21:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658871489;
        bh=+xtfIv1kGqmxgTW+LGAtofVUOs/7JbrkD2Pk28Al1TM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r6kY9JDjzOyosI3o0sg8sEyAkQV08kN5h4gXCvFQzHujBx0Zf9/7FlQUz96ppc8Dc
         /k8eAKm7lKFWxUbo7TpnDGr/HPGyZJKQlkUrRjdXfZpzif6B6OAaVKIP0PeG0NVsn7
         tO4hPVP5oeV/Ia68cp/xI98ZNLmQN0RWuTrcArbR9vB1ZgzinUTLJcJgBsHVsrsDme
         IRS2kRIOrFuX50juAR69tz3y3OVSgHaBf4f7LqnT1zxtHfuw4EKutuwgmqKuo9SlR2
         7gq100k9pA75QE/f09Ij8TCNy2/bmZp3qrsiL5sdbDxg7knxxTlVoh5Mllj4b0q7PC
         LwsLxp4ZiaGNw==
Date:   Tue, 26 Jul 2022 14:38:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Johannes Berg <johannes@sipsolutions.net>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mac80211: do not abuse fq.lock in
 ieee80211_do_stop()
Message-ID: <20220726143807.68f46fb3@kernel.org>
In-Reply-To: <df9efa23-e729-d1d0-b66f-248d7ae67c60@candelatech.com>
References: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
        <165814567948.32602.9899358496438464723.kvalo@kernel.org>
        <9487e319-7ab4-995a-ddfd-67c4c701680c@I-love.SAKURA.ne.jp>
        <87o7xcq6qt.fsf@kernel.org>
        <df9efa23-e729-d1d0-b66f-248d7ae67c60@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 08:05:12 -0700 Ben Greear wrote:
> >> Since this patch fixes a regression introduced in 5.19-rc7, can this patch go to 5.19-final ?
> >>
> >> syzbot is failing to test linux.git for 12 days due to this regression.
> >> syzbot will fail to bisect new bugs found in the upcoming merge window
> >> if unable to test v5.19 due to this regression.  
> > 
> > I took this to wireless-next as I didn't think there's enough time to
> > get this to v5.19 (and I only heard Linus' -rc8 plans after the fact).
> > So this will be in v5.20-rc1 and I recommend pushing this to a v5.19
> > stable release.  
> 
> Would it be worth reverting the patch that broke things until the first stable 5.19.x
> tree then?  Seems lame to ship an official kernel with a known bug like this.

I cherry-picked the fix across the trees after talking to Kalle and
DaveM. Let's see how that goes...
