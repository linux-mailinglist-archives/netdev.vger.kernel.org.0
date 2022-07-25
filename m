Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 216B4580419
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbiGYShS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 14:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbiGYShM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 14:37:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFA11FCC4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7F8AB810AD
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 18:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50549C341C8;
        Mon, 25 Jul 2022 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658774222;
        bh=tiNTwsmkhKu1/D02rHQTbphfv9gcLtwBQlyFwmTHkFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UGBKoK8qftHdeWNqyWK2P5ZxSyZCx7BYqGFBLSdjGo1pM10d+/OPrYC9HJ2c+Zkrr
         y3KIpbfQb62ROkc7Lm0LLDRPMX6ycFN+hGtCdlTcP3uOZwQXL2vMVR/rnwxkKSpV7c
         7qmMM/yUZXmd/0OTdQ9lynWDi0Kis0ko8SVS6geX2d/QLZZ7sczQcQM5XoX0+94ibw
         CN6bMfG51Y/CNQYOu9xOH9RQOTuqelxuPaRm0mT7+kmpkhFmUnlehIMCTfWtrOxD5Q
         hoW/+XhNHxG6tPXZ8U9Tq4psCh6abKTOzTXA9DpEC/R6hly4dROMzOyzaesOrmPeR9
         64pgDuxsTYp0Q==
Date:   Mon, 25 Jul 2022 11:37:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net] net/tls: Remove the context from the list in
 tls_device_down
Message-ID: <20220725113701.18774af6@kernel.org>
In-Reply-To: <f085d0f65adc41f255a1a9b1bae7b0767ff3c15a.camel@nvidia.com>
References: <20220721091127.3209661-1-maximmi@nvidia.com>
        <20220722150435.371a4fd9@kernel.org>
        <f085d0f65adc41f255a1a9b1bae7b0767ff3c15a.camel@nvidia.com>
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

On Mon, 25 Jul 2022 14:35:08 +0000 Maxim Mikityanskiy wrote:
> On Fri, 2022-07-22 at 15:04 -0700, Jakub Kicinski wrote:
> > On Thu, 21 Jul 2022 12:11:27 +0300 Maxim Mikityanskiy wrote:  
> > > tls_device_down takes a reference on all contexts it's going to move to
> > > the degraded state (software fallback). If sk_destruct runs afterwards,
> > > it can reduce the reference counter back to 1 and return early without
> > > destroying the context. Then tls_device_down will release the reference
> > > it took and call tls_device_free_ctx. However, the context will still
> > > stay in tls_device_down_list forever. The list will contain an item,
> > > memory for which is released, making a memory corruption possible.
> > > 
> > > Fix the above bug by properly removing the context from all lists before
> > > any call to tls_device_free_ctx.  
> > 
> > SGTM. The tls_device_down_list has no use, tho, is the plan to remove
> > it later as a cleanup or your upcoming patches make use of it?  
> 
> I don't plan to remove it. Right, we never iterate over it, so instead
> of moving the context to tls_device_down_list, we can remove it from
> list, as long as we check to not remove it second time on destruction.
> 
> However, this way we don't gain anything, but lose a debugging
> opportunity: for example, when list debugging is enabled, double
> list_del will be detected.

I see. I haven't actually checked if list_del_init() would do as well
here.

> So, it doesn't make sense to me to remove this list, but if you still
> want to do it, Tariq has a patch for this.

Fine either way, thanks for the explanation.
