Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E76629148
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 05:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiKOEvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 23:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiKOEvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 23:51:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14D913DFA
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 20:51:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A41061472
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6556DC433C1;
        Tue, 15 Nov 2022 04:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668487904;
        bh=oWJpXNyQAiBIMH7veJPS2ys+fa1wm+GthNW6KkdWpd8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ae30XZJeBbRMkK1fAAAjMWnC/NdXjlbmH9oYJ3TCTAW0LEBvHzqU8/4453WhZ+YpK
         1wDDqi9UT6a1OyvCgIId0B0Qw9Mr2xblzu7vk/vxWKdTiGWNQgYhLAsTbMqBgIhp3t
         Qi0+MYy4B0bg770cF/AANO3OUzEyGc7fWuxEarAJJtQJGONDH5FKchJhWcMpjw8Mvi
         tJqjPtwITo6vbdDNRaCOCKjVAR5OhF8Q0AevH6EW3E1y+Abx1D3/dQxQ5SHvQ9CywY
         aDwTyXoL9b/L9JG+oOwWlR0SsZdkwUWMKpGcPoJPN6H75cSYGTYrTLtjetLSwQqFM2
         FIyUGvZ6+xj0g==
Date:   Mon, 14 Nov 2022 20:51:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <20221114205143.717fd03f@kernel.org>
In-Reply-To: <Y3MCaaHoMeG7crg5@Laptop-X1>
References: <Y1kEtovIpgclICO3@Laptop-X1>
        <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
        <20221102163646.131a3910@kernel.org>
        <Y2odOlWlonu1juWZ@Laptop-X1>
        <20221108105544.65e728ad@kernel.org>
        <Y2uUsmVu6pKuHnBr@Laptop-X1>
        <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
        <20221109182053.05ca08b8@kernel.org>
        <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
        <20221110092709.06859da9@kernel.org>
        <Y3MCaaHoMeG7crg5@Laptop-X1>
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

On Tue, 15 Nov 2022 11:07:21 +0800 Hangbin Liu wrote:
> > IDK, we can have a kernel hook into the trace point and generate 
> > the output over netlink, like we do with drop monitor and skb_free().
> > But I really doubt that its worth it. Also you can put a USDT into OvS
> > if you don't want to restart it. There are many options, not everything
> > is a nail :S  
> 
> I have finished a patch with TCA_NTF_WARN_MSG to carry the string message.
> But looks our discussion goes to a way that this feature is not valuable?
> 
> So maybe I should stop on here?

It's a bit of a catch 22 - I don't mind the TCA_NTF_WARN_MSG itself 
but I would prefer for the extack via notification to spread to other
notifications.

If you have the code ready - post it, let's see how folks feel after
sleeping on it.
