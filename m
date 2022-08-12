Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82E15915D7
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 21:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbiHLTRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 15:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiHLTRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 15:17:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7960B088F;
        Fri, 12 Aug 2022 12:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56048617A7;
        Fri, 12 Aug 2022 19:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D1CC433C1;
        Fri, 12 Aug 2022 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660331840;
        bh=0jIwtskoACNMrG6LuvpBTh7ehg3jcPRIFzQUMEx2Tvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J6harPh0u6YqAcKdxSSwA1rKEt/X9Rw2eI1fDeOrc77QRRhVlxaymEXe6AKQ4Cohj
         7sCzTX5nXljiLltDoTte/I4TQajUP4cX6D6KBhOKcnFy0Uu9EhELXb7lq+HC0ysTY9
         xex0dW5ZeXJwo1vC/T2jRIrYUFe0DZB0k/xW1H3tbRjhoVhNbkrj+sZt5OpMzp83Qi
         4Y03lzAu09uQuiMh3r1qJgyAm5D/iDBdqfzevnm9vegEDVyfgOxwAFwreyAmVFx1+s
         7ZLVNrH6bqrZxCoG6J3mga6nxnNHw3e5Sl3gQ9T+ob/YFn1y3IsC+9ttIJECIQXrHx
         mY2pNuR3cir7A==
Date:   Fri, 12 Aug 2022 12:17:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neal Cardwell <ncardwell@google.com>, stable@kernel.org
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net 1/3] netfilter: nf_conntrack_tcp: re-init for syn
 packets only
Message-ID: <20220812121719.0aff4cba@kernel.org>
In-Reply-To: <CADVnQykD5NRcjmrbP9bgNaVuhpOaSiC1dxCOF03bL5nTo2HP7g@mail.gmail.com>
References: <20220428142109.38726-2-pablo@netfilter.org>
        <165116521266.24173.17359123747982099697.git-patchwork-notify@kernel.org>
        <CADVnQykD5NRcjmrbP9bgNaVuhpOaSiC1dxCOF03bL5nTo2HP7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 09:34:14 -0400 Neal Cardwell wrote:
> This first commit is an important bug fix for a serious bug that causes
> TCP connection hangs for users of TCP fast open and nf_conntrack:
> 
>   c7aab4f17021b netfilter: nf_conntrack_tcp: re-init for syn packets only
> 
> We are continuing to get reports about the bug that this commit fixes.
> 
> It seems this fix was only backported to v5.17 stable release, and not further,
> due to a cherry-pick conflict, because this fix implicitly depends on a
> slightly earlier v5.17 fix in the same spot:
> 
>   82b72cb94666 netfilter: conntrack: re-init state for retransmitted syn-ack
> 
> I manually verified that the fix c7aab4f17021b can be cleanly cherry-picked
> into the oldest (v4.9.325) and newest (v5.15.60) longterm release kernels as
> long as we first cherry-pick that related fix that it implicitly depends on:
> 
> 82b72cb94666b3dbd7152bb9f441b068af7a921b
> netfilter: conntrack: re-init state for retransmitted syn-ack
> 
> c7aab4f17021b636a0ee75bcf28e06fb7c94ab48
> netfilter: nf_conntrack_tcp: re-init for syn packets only
> 
> So would it be possible to backport both of those fixes with the following
> cherry-picks, to all LTS stable releases?
> 
> git cherry-pick 82b72cb94666b3dbd7152bb9f441b068af7a921b
> git cherry-pick c7aab4f17021b636a0ee75bcf28e06fb7c94ab48

Thanks a lot Neal! FWIW we have recently changed our process and no
longer handle stable submissions ourselves, so in the future feel free
to talk directly to stable@ (and add CC: stable@ tags to patches).

I'm adding stable@, let's see if Greg & team can pick things up based
on your instructions :)
