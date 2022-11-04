Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DE9618E36
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 03:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiKDCXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 22:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKDCXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 22:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E48AD;
        Thu,  3 Nov 2022 19:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B29B80B03;
        Fri,  4 Nov 2022 02:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC252C433D6;
        Fri,  4 Nov 2022 02:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667528590;
        bh=sERIijRv5mOrbGOW9mvfJzqTJ1+FOZaz8mhSLFBBd2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Muj7FGnRW/uE4Y+G0y4jisxp6d22RyfEzb72tuLQb/iU8GYSSDYv/ibtFqF0gSwlG
         J7hGBVPU/4/CJohlewT4uWrkFaHXrfFWeNwrUsNrdk27u8s/L2DLdRPHmw99lu4ZI6
         gDx1GwK5Kjev0MOrV1kLCiriEEspKiGYxP+57oH2MmlRuIrjLWvlt73RkGYVHgIa8X
         wMjLxbC/pLONZDNkux4MiQUxmedf/iBYvHLjeuDOtHIHLWUkv9qmDY4PLXlEQcWg5Q
         V4EsjmNL6zWmG4n5cdddhbck7TqOUoAPSnyHkKb15FWBq/BaGwXLpTvdPhxx6xW9Pw
         u19p0Sq4y8vuA==
Date:   Thu, 3 Nov 2022 19:23:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     18801353760@163.com, davem@davemloft.net, edumazet@google.com,
        jhs@mojatatu.com, jiri@resnulli.us, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] net: sched: fix memory leak in tcindex_set_parms
Message-ID: <20221103192308.581a9124@kernel.org>
In-Reply-To: <20221103160659.22581-1-yin31149@gmail.com>
References: <20221102202604.0d316982@kernel.org>
        <20221103160659.22581-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Nov 2022 00:07:00 +0800 Hawkins Jiawei wrote:
> > Can't you localize all the changes to this if block?
> >
> > Maybe add a function called tcindex_filter_result_reinit()
> > which will act more appropriately?  
> 
> I think we shouldn't put the tcf_exts_destroy(&old_e)
> into this if block, or other RCU readers may derefer the
> freed memory (Please correct me If I am wrong).
> 
> So I put the tcf_exts_destroy(&old_e) near the tcindex 
> destroy work, after the RCU updateing.

I'm not sure what this code is trying to do, to be honest.
Your concern that there may be a concurrent reader is valid,
but then again tcindex_filter_result_init() just wipes the
entire structure with a memset() so concurrent readers are
already likely broken?

Maybe tcindex_filter_result_init() dates back to times when
exts were a list (see commit 22dc13c837c) and calling 
tcf_exts_init() wasn't that different than cleaning it up?
In other words this code is trying to destroy old_r, not
reinitialize it?

> >  
> > >               err = tcindex_filter_result_init(old_r, cp, net);
