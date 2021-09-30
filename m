Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F4341E225
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 21:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345906AbhI3TTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 15:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345434AbhI3TTm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 15:19:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF6C619F8;
        Thu, 30 Sep 2021 19:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633029479;
        bh=XtIJvXsruNGVf58rTbKNKsu6/VR3FXPQSA4IE3yR++M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c4jwZSNKhXJBgiK2kwsxuQN2574x0xOlUJm0tzSXmCW2CKdjaOO3x9ikJEUsBOQjV
         K6N5M7MJDx4PJrgZgQ1fsxHdGFhlyrt7WuahHqAJDDcZgbBeoJScwIQZbLN+PIs3GD
         cbzvAsfvv3FQGKeFvfdxcTSLewAxVkWKBoeDfyUYU5GZbM11MlvCmfVY2A57n3WJ9z
         D2iSUTU/cawuozZ9EvJOp0i8hff+QcA1Bov1RwxX52evQ5gcoT5VV4W+9t+r24oC/g
         I4rjC6nb2yXBGSLyw8OEy6OYqe5W2AjIyBY57lq4VPiE+ySnqhZvhoptIypFnCKmGA
         EcYt1JqCp/xpQ==
Date:   Thu, 30 Sep 2021 12:17:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, lukas@wunner.de, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <20210930121758.43e1893d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVX7WATmhsJUATSB@salvia>
References: <20210928095538.114207-1-pablo@netfilter.org>
        <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
        <YVVk/C6mb8O3QMPJ@salvia>
        <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
        <YVWBpsC4kvMuMQsc@salvia>
        <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVXUIUMk0m3L+My+@salvia>
        <20210930090652.4f91be57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVX7WATmhsJUATSB@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 20:00:56 +0200 Pablo Neira Ayuso wrote:
> On Thu, Sep 30, 2021 at 09:06:52AM -0700, Jakub Kicinski wrote:
> > On Thu, 30 Sep 2021 17:13:37 +0200 Pablo Neira Ayuso wrote:  
> > > It's just one single bit in this case after all.  
> > 
> > ??  
> 
> There are "escape" points such ifb from ingress, where the packets gets
> enqueued and then percpu might not help, it might be fragile to use
> percpu in this case.

You still have to scrub the skb mark at the correct points, otherwise
the ignoring egress may propagate beyond the "paired hook". I don't see
much difference in fragility TBH.

Speaking of ifb, doesn't it have an egress hook? And ingress on the way
out? IMHO the "ignore egress" mark should not survive going thru ifb.

Anyway, that's just my preference. Whatever you, Daniel and Lukas
decide together in the end is fine by me.
