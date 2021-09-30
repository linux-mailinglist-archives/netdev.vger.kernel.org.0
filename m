Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617F341DC41
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349600AbhI3OaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348126AbhI3OaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 10:30:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCF7C61A07;
        Thu, 30 Sep 2021 14:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633012117;
        bh=umB/IVXAMP4SWIOcWbkXsDo21chQw2rLTLyMHL+/xcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nfSGJEaqNLA3Cf2lbmeDqnt1BqDLRYXC6b28ySFJ+2uJOHRRU7O4dm9tLcsiG9wRi
         F0Z1BpFCk1+Yw5ct/ImfDW+Xw8YFzU85vrBbLIe7nkMqDNlGnlH1owMFIzgqStpEIF
         N+Yq1wKo/AtsXONVtFYsfLWpKd2YWuXQRFNt4WW2lsgIuxWeJwcHfaERalmLmofSpa
         vNs2uNqPoP2VK5jSk1qwn78HZO8Z+ufk8TshHrPWkWWxFI05Do1KiRwxNw4bWozAsm
         vaYxcfxPXD9zI7+hHB1K2/yCRnOaMKX0K6flrdiliX6HhoE01dLh2fEyzXAlRvZA4s
         W7R9YWhtLyfSA==
Date:   Thu, 30 Sep 2021 07:28:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, lukas@wunner.de, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVWBpsC4kvMuMQsc@salvia>
References: <20210928095538.114207-1-pablo@netfilter.org>
        <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
        <YVVk/C6mb8O3QMPJ@salvia>
        <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
        <YVWBpsC4kvMuMQsc@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 11:21:42 +0200 Pablo Neira Ayuso wrote:
> On Thu, Sep 30, 2021 at 09:33:23AM +0200, Daniel Borkmann wrote:
> > On 9/30/21 9:19 AM, Pablo Neira Ayuso wrote:  
> > > Why do you need you need a sysctl knob when my proposal is already
> > > addressing your needs?  
> > 
> > Well, it's not addressing anything ... you even mention it yourself "arguably,
> > distributors might decide to compile nf_tables_netdev built-in".  
> 
> I said distributors traditionally select the option that we signal to
> them, which is to enable this as module. We can document this in
> Kconfig. I think distributors should select whatever is better for
> their needs.
> 
> Anyway, I'll tell you why module blacklisting is bad: It is a hammer,
> it is a band aid to a problem. Blacklisting is just making things
> worst because it makes some people believe that something is
> unfixable. Yes, it took me a while to figure out.
> 
> We already entered the let's bloat the skbuff for many years already,
> this is stuffing one more bit into the skbuff just because maybe users
> might break an existing setup when they load new rules to the new
> netfilter egress hook.

The lifetime of this information is constrained, can't it be a percpu
flag, like xmit_more?

> Probably the sysctl for this new egress hook is the way to go as you
> suggest.

Knobs is making users pay, let's do our best to avoid that.
