Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBA16239B8
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiKJCU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKJCU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:20:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690141FCE2
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:20:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD496B8205B
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA16AC433C1;
        Thu, 10 Nov 2022 02:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668046855;
        bh=xOWP9ob1Ldxovuam32nnMcSdd+aonfxVzeLpKycIodE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VoXn/1msxUtDX1IGyIS7JewpoIHCjA66yuRxPE7lBmIHkbaWjspgrKsL0P7f3aYsu
         HiQSggFZA7PwTSDAwXapj6Fx5dClPh+OrQq8yBRvTDmducTXSEv2GfDOW2l4ug0ogI
         XS+M7qomq5z6eNqfJ9n/guXNWynt24Xo8yNiW9X/wXoM/7aKnN7/jHYF4ar0yumHYk
         xuu9JmXeGo9cFMds2We3VAg4gKgVB4J4aM4EJg7Xk5RZbLGcYnTxozQHjB3xWPUYP9
         sZOkGl7Z1+FYSsB8bxvLSq8//3liTsjLgM/klunzM7WFGW6CbCWSnng8zaz60yqEIl
         L8xNXbDPYvoaA==
Date:   Wed, 9 Nov 2022 18:20:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <20221109182053.05ca08b8@kernel.org>
In-Reply-To: <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
        <YziJS3gQopAInPXw@pop-os.localdomain>
        <Yzillil1skRfQO+C@t14s.localdomain>
        <CAM0EoM=EwoXgLW=pxadYjL-OCWE8c-EUTcz57W=vkJmkJp6wZQ@mail.gmail.com>
        <Y1kEtovIpgclICO3@Laptop-X1>
        <CAM0EoMmFCoP=PF8cm_-ufcMP9NktRnpQ+mHmoz2VNN8i2koHbw@mail.gmail.com>
        <20221102163646.131a3910@kernel.org>
        <Y2odOlWlonu1juWZ@Laptop-X1>
        <20221108105544.65e728ad@kernel.org>
        <Y2uUsmVu6pKuHnBr@Laptop-X1>
        <CAM0EoMmx6i42WR=7=9B1rz=6gcOxorgyLDGseeEH7EYRPMgnzg@mail.gmail.com>
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

On Wed, 9 Nov 2022 20:52:37 -0500 Jamal Hadi Salim wrote:
> TCA_XXX are local whereas NLMSGERR_ATTR_MSG global to the
> netlink message. 

"Global", but they necessitate complicating the entire protocol 
to use directly.

Unless we want to create a separate netlink multicast channel for 
just ext acks of a family. That's fine by me, I guess. I'm mostly
objecting to pretending notifications are multi-msg just to reuse
NLMSG_DONE, and forcing all notification listeners to deal with it.

> Does this mean to replicate TCA_NTF_EXT_ACK
> for all objects when needed? (qdiscs, actions, etc).

The more time we spend discussing this the more I'm inclined to say
"this is a typical tracing use case, just use the tracepoint" :(
