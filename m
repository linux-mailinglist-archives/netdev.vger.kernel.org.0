Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27886624856
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiKJR1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiKJR1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:27:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABCD183B9
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7EF061CFE
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 17:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED67C433C1;
        Thu, 10 Nov 2022 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668101231;
        bh=TOHSzOmj+tRNf/jDXxNMT8NgEYXfYvdZWtugUGGxc3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eOCnkkhmX87a8SlGDwIu8Q+cS4WqtXaFUT1tOkWHFaecSGzpscRgyu/XsKIPXDb2z
         Z1YXnLf4WPIkR2m1fk1G5W1waY972s7qV4XAaoXJ8lfnbsKpVwYiU+Yk4EQYdi4rpJ
         sQgPsPbOwvOjgrhYA9OTeFxCJrIBRCA4xRmA2HaHYOz8i1Z8I8swRyTFGf3RTwb4Ht
         zSe2BhXe8p871R7cwUqu1iP6OjF3+XoQUOAkiDW7RnllpSx+HA+tLGbI+DiNUnTXZo
         XNXP7VAUAQ+/S1oR9v2InRmerhsNc2+pDG3jLPdXvbjpY83oJrwzNkiHwbNnDtb+ig
         tgfnY7LJsLVUw==
Date:   Thu, 10 Nov 2022 09:27:09 -0800
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
Message-ID: <20221110092709.06859da9@kernel.org>
In-Reply-To: <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
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
        <20221109182053.05ca08b8@kernel.org>
        <CAM0EoMm1Jx3mcGJK_XasTpVjm7uGHzVXhXN8=MAQUExJhuPFvw@mail.gmail.com>
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

On Thu, 10 Nov 2022 09:27:40 -0500 Jamal Hadi Salim wrote:
> > "Global", but they necessitate complicating the entire protocol
> > to use directly.
> >
> > Unless we want to create a separate netlink multicast channel for
> > just ext acks of a family. That's fine by me, I guess. I'm mostly
> > objecting to pretending notifications are multi-msg just to reuse
> > NLMSG_DONE, and forcing all notification listeners to deal with it.
> 
> TBH, I am struggling as well. NLMSG_DONE is really for multi-message
> (with kernel state) like dumps. Could we just extend nlmsg_notify()
> callers to take extack and pass it through and then have  nlmsg_notify()
> do the NLM_F_ACK_TLVS dance without MULTI flag? It would have to
> be backward compat and require user space changes which Hangbin's
> patch avoids but will be more general.

I think we'd need some sort of "internal / netlink level attributes"
to do that. We have only one attribute "space" inside any message,
defined by the family itself. So attribute type 1 for a TCA notification
is TCA_KIND, not NLMSGERR_ATTR_MSG.

We'd need changes to struct nlmsghdr to allow the nlmsghdr to have its
own set of attributes. Would be cool, but major surgery at this point.
I guess we could assume the families don't use high attr types, and say
that attr types > 0x400 are reserved for netlink. Put NLMSG_ATTRs there.
Seems risky, tho.

> > The more time we spend discussing this the more I'm inclined to say
> > "this is a typical tracing use case, just use the tracepoint" :(  
> 
> I understand your frustration but from an operational pov it is
> better to deal with one tool than two (Marcelo's point).

IDK, we can have a kernel hook into the trace point and generate 
the output over netlink, like we do with drop monitor and skb_free().
But I really doubt that its worth it. Also you can put a USDT into OvS
if you don't want to restart it. There are many options, not everything
is a nail :S

> The way i look at these uapi discussions is it is ok to discuss the
> color of the bike shed(within reason) because any decisions made here
> will have a long term effect.

To stretch the analogy - in my mind we have way too many one-off, 
odd looking bike sheds and not enough bikes (users) with netlink.

So anything that reads to me like "ooh, look at this neat trick 
I can do with netlink that I can totally hand parse in iproute2" 
rises the hair on my back :(
