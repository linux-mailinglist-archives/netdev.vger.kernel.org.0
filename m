Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CCF4B54DD
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 16:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355894AbiBNPfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 10:35:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242533AbiBNPfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 10:35:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55CF4AE3C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 07:35:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 401E561256
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6CAC340E9;
        Mon, 14 Feb 2022 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644852909;
        bh=C7nsMb/st/CQ+4Gun+RH0e0xj0MgCYJDkfvwPHiwMJ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nNEZknY3+00ohNV4bW7y9jJ4JxIl+pmqe7LYdLQqiNBYMmuKE7WjsI8Bj5RVkMsCq
         Lj4+iDuVv8V7se1Qm7vtOwG56EQ/lxxfL7kt0L8JWPklA9Tf2Nv+p8pD0EJ8sF1fqP
         30slaRhIYgA4NW8gPZYOq8LW88gyafWqu/Cn+HY862Oc/1WizfF8xKYg8ihJ/C5+X+
         h1PPuP7aK8pWtz9nC2LuxF8RnFh/+pirg52VPbf+V0NCLuy66I4zDpCnhe3RR5BAW9
         I5d6Bkg5C4IMGNeLaprSwIAHbhN6QZfp8UYyzlnmZS3o0kJioYwF5KiUxfDgVG5K7L
         f9/V8ghsvcPow==
Date:   Mon, 14 Feb 2022 07:35:07 -0800
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
Message-ID: <20220214073507.4087ce73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMDZJNW0tcue5kt-GgontVTo-yBEEBPD98xnhtOu2XjCy9WR9g@mail.gmail.com>
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
        <20220126143206.23023-3-xiangxia.m.yue@gmail.com>
        <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
        <a2ecd27f-f5b5-0de4-19df-9c30671f4a9f@mojatatu.com>
        <CAMDZJNUHmrYBbnXrXmiSDF2dOMMCviAM+P_pEqsu=puxWeGuvA@mail.gmail.com>
        <CAMDZJNUbpK_Fn6eFoSHFg7Mei5aMoop01MmgoKuf+XDr_LXaqA@mail.gmail.com>
        <20220209072645.126734ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMDZJNW0tcue5kt-GgontVTo-yBEEBPD98xnhtOu2XjCy9WR9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Feb 2022 19:16:11 +0800 Tonghao Zhang wrote:
> > > Hi Jakub, do you have an opinion?  
> >
> > I think the patches are perfectly acceptable, nothing changed.  
> Hi Jakub
> Will we apply this patchset ? We waited for  Cong to answer Jamal's
> comment for a long time.

You'd need to repost, the code is 3 weeks old by now.
