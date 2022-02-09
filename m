Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897DA4AF532
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbiBIP0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235504AbiBIP0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:26:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A04C0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 07:26:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5958BB821F3
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 15:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEC4C340E7;
        Wed,  9 Feb 2022 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644420408;
        bh=jlNGIpCcY+CLLN+HqKzlw+dOISI6eXCCTrH/z4xjl/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qPE2ThwnShVF94yuW4UwxG3R15sl8WE/uc+sCZLaz5osfvD30xfjSv2GznEzKlIQg
         VufSGUdlwfWTPBlY64oYtctnPVWLoY9mOpwKpssmHTpYqQCpMAocapWlGDk16X/ZJb
         EKY6oj65YlYCclSkgHesxkUAq3cUe/OORR2v07yYvBn7oVa2nuIIrqH1qA4TDiQ/40
         J1LZmjwMn/9nl6oFraWTD6Uns5ao48JrWxHBJCM8eLT95yNJWB1ZCJRMvgrykSEYp3
         Eu42jYZac8r3Eh2Qzf4c5l+Wb8/v75V9zfDPAb/fS7tE9kEvFkOM9vaOIuNZGAkGTp
         lN/VaEA0A5THg==
Date:   Wed, 9 Feb 2022 07:26:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
Message-ID: <20220209072645.126734ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMDZJNUbpK_Fn6eFoSHFg7Mei5aMoop01MmgoKuf+XDr_LXaqA@mail.gmail.com>
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
        <20220126143206.23023-3-xiangxia.m.yue@gmail.com>
        <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
        <a2ecd27f-f5b5-0de4-19df-9c30671f4a9f@mojatatu.com>
        <CAMDZJNUHmrYBbnXrXmiSDF2dOMMCviAM+P_pEqsu=puxWeGuvA@mail.gmail.com>
        <CAMDZJNUbpK_Fn6eFoSHFg7Mei5aMoop01MmgoKuf+XDr_LXaqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Feb 2022 22:17:24 +0800 Tonghao Zhang wrote:
> > > This doesnt work in some environments. Example:
> > >
> > > 1) Some data centres (telco large and medium sized enteprises that
> > > i have personally encountered) dont allow for anything that requires
> > > compilation to be introduced (including ebpf).
> > > They depend on upstream - if something is already in the kernel and
> > > requires a script it becomes an operational issue which is a simpler
> > > process.
> > > This is unlike large organizations who have staff of developers
> > > dedicated to coding stuff. Most of the folks i am talking about
> > > have zero developers in house. But even if they did have a few,
> > > introducing code into the kernel that has to be vetted by a
> > > multitude of internal organizations tends to be a very
> > > long process.  
> > Yes, really agree with that.  
> Hi Jakub, do you have an opinion?

I think the patches are perfectly acceptable, nothing changed.
