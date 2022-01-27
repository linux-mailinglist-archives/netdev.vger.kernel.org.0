Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBA249E7DC
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244008AbiA0Qnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244079AbiA0Qmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:42:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736ECC06174A;
        Thu, 27 Jan 2022 08:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EF31B80BD1;
        Thu, 27 Jan 2022 16:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F092DC340E8;
        Thu, 27 Jan 2022 16:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643301742;
        bh=TXAiXJs3qtaBb0dJ/MpNjqafjjmSK1BDR2g/RFuEQIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XFhQD3n4txrlQjiqmBQhuEcOlBor8yCCMKV7JbjF9RBP9BsBzY/yrBjWLuVXgwF5I
         PC9aZrrt2JgeCoJk15rAqamfKrGgxzraeDApR4+qEl+gHFdGDhXUr6mWUjooeT9ZSy
         5NhMFaOLqXncr4QQchYjjQ6WHFUWXYcBSTGTiIhOD3bHIh1w9tP/KMG6d+FbvCKnpS
         kPZ53DpAfdB3rYXobfVBsEoi93mJ6bsMeVoeqM7uFvUvqm9tIf65jTk4NfYHY0eGkV
         MoXzGicWMPpUY+7LV/uN/D97p+7YgHZtfAWrfXyIYXReBQMXX3Z9oSuU/hxpanlLsC
         A07KMwmdOydOg==
Date:   Thu, 27 Jan 2022 08:42:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>, menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        imagedong@tencent.com, alobakin@pm.me, pabeni@redhat.com,
        cong.wang@bytedance.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        mengensun@tencent.com
Subject: Re: [PATCH v2 net-next 1/8] net: socket: intrudoce
 SKB_DROP_REASON_SOCKET_FILTER
Message-ID: <20220127084220.05c86ef5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2512e358-f4d8-f85e-2a82-fbd5a97d1c2f@gmail.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
        <20220127091308.91401-2-imagedong@tencent.com>
        <2512e358-f4d8-f85e-2a82-fbd5a97d1c2f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 08:37:06 -0700 David Ahern wrote:
> On 1/27/22 2:13 AM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> > 
> > Introduce SKB_DROP_REASON_SOCKET_FILTER, which is used as the reason
> > of skb drop out of socket filter. Meanwhile, replace
> > SKB_DROP_REASON_TCP_FILTER with it.

> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index bf11e1fbd69b..8a636e678902 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -318,7 +318,7 @@ enum skb_drop_reason {
> >  	SKB_DROP_REASON_NO_SOCKET,
> >  	SKB_DROP_REASON_PKT_TOO_SMALL,
> >  	SKB_DROP_REASON_TCP_CSUM,
> > -	SKB_DROP_REASON_TCP_FILTER,
> > +	SKB_DROP_REASON_SOCKET_FILTER,
> >  	SKB_DROP_REASON_UDP_CSUM,
> >  	SKB_DROP_REASON_MAX,
> 
> This should go to net, not net-next.

Let me make an exception and apply this patch out of the series 
to avoid a conflict / week long wait for another merge.
