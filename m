Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B889D2AC455
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730388AbgKIS6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:58:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:60424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729243AbgKIS6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 13:58:53 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B02C206D8;
        Mon,  9 Nov 2020 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604948332;
        bh=EpVhJLFLH6bXtmtdD/v/NJNtWBqIbSFh6B9y661X0EQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=x+reF972DWX8NVErBIPP0B8TMr5AGnzh2tTABowtwlLKhdMMOJcXfv6FynjHT3Qzk
         EXpjkjDmZUzC3hSfVhHfVhLEdjjhS4khnZxildI9DlyYezb19McLbl9xSZkKULb72Z
         FJKdKZATE2mIAUFPNSlUJ54fF9o7gICl6XvTd9Rw=
Date:   Mon, 9 Nov 2020 10:58:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
Message-ID: <20201109105851.41417807@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <8c7a1bab-3c7b-e3bf-3572-afdf2abd2505@chelsio.com>
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
        <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
        <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <043b91f8-60e0-b890-7ce2-557299ee745d@chelsio.com>
        <20201105104658.4f96cc90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a9d6ec03-1638-6282-470a-3a6b09b96652@chelsio.com>
        <20201106122831.5fccebe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8c7a1bab-3c7b-e3bf-3572-afdf2abd2505@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 00:21:13 +0530 Vinay Kumar Yadav wrote:
> On 11/7/2020 1:58 AM, Jakub Kicinski wrote:
> > On Sat, 7 Nov 2020 02:02:42 +0530 Vinay Kumar Yadav wrote:  
> >> On 11/6/2020 12:16 AM, Jakub Kicinski wrote:  
> >>> On Thu, 5 Nov 2020 23:55:15 +0530 Vinay Kumar Yadav wrote:  
> >>>>>>> We should prevent from the socket getting into LISTEN state in the
> >>>>>>> first place. Can we make a copy of proto_ops (like tls_sw_proto_ops)
> >>>>>>> and set listen to sock_no_listen?  
> >>>>>>
> >>>>>> Once tls-toe (TLS_HW_RECORD) is configured on a socket, listen() call
> >>>>>> from user on same socket will create hash at two places.  
> >>>>>
> >>>>> What I'm saying is - disallow listen calls on sockets with tls-toe
> >>>>> installed on them. Is that not possible?
> >>>>>        
> >>>> You mean socket with tls-toe installed shouldn't be listening at other
> >>>> than adapter? basically avoid ctx->sk_proto->hash(sk) call.  
> >>>
> >>> No, replace the listen callback, like I said. Why are you talking about
> >>> hash???
> >>> As per my understanding we can't avoid socket listen.  
> >> Not sure how replacing listen callback solve the issue,
> >> can you please elaborate ?  
> > 
> > TLS sockets are not supposed to get into listen state. IIUC the problem
> > is that the user is able to set TLS TOE on a socket which then starts
> > to listen and the state gets cloned improperly.
> 
> TLS-TOE can go to listen mode, removing listen is not an option and
> TLS-TOE support only server mode so if we remove listen then we will not 
> have TLS-TOE support which we don't want.

Oh, so it's completely incompatible with kernel tls. How about we
remove the support completely then? Clearly it's not an offload of
kernel tls if it supports completely different mode of operation.
