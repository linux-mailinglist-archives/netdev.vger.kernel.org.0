Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BCD417C4E
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 22:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346884AbhIXUXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 16:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345900AbhIXUXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 16:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD55160F6D;
        Fri, 24 Sep 2021 20:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632514897;
        bh=CUremWg/9TEyCO0K/SxTcGCipsBm/dBOxK445ROMYNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g82i6hbXUs6UOpydVRxG7O8Auwf5pNaZ1sMiDYrwWrLzjpQWCjZU8oqHVDYtJLHHI
         dLl4nBy6ZXRdN7vL4e8ecpJftZWXLr2sWY78DNHzmArONvc6uKUwRRttt9sBXIM2u+
         KQ3/0wEndzpXSFdP//rKckbGqwcj0SYYpt+uAluMrKCh2BJGwg+tybjMX6EMYQD2Rl
         3EzHICXZbzPSe0hyWYTKedg30jVRt7fB+ebMB1DwdfpDgVJX0qHrecanZHMJcA09bq
         uTfwiSAEXiyASV9V0W/cbbjivf9j/bafyvFgn8ilYJ9i0NerYpW9uvZjVKJJaRvJ+Y
         a5KS4TvOM/42Q==
Date:   Fri, 24 Sep 2021 13:21:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, weiwan@google.com,
        xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net-next] net: make napi_disable() symmetric with enable
Message-ID: <20210924132136.6f867a57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <03648349-c74e-cafb-1dce-8cf7fab44089@gmail.com>
References: <20210924040251.901171-1-kuba@kernel.org>
        <03648349-c74e-cafb-1dce-8cf7fab44089@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 07:30:30 -0700 Eric Dumazet wrote:
> >  void napi_disable(struct napi_struct *n)
> >  {
> > +	unsigned long val, new;
> > +
> >  	might_sleep();
> >  	set_bit(NAPI_STATE_DISABLE, &n->state);
> >  
> > -	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
> > -		msleep(1);
> > -	while (test_and_set_bit(NAPI_STATE_NPSVC, &n->state))
> > -		msleep(1);
> > +	do {
> > +		val = READ_ONCE(n->state);
> > +		if (val & (NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC)) {
> > +			msleep(1);  
> 
> Patch seems good to me.
> 
> We also could replace this pessimistic msleep(1) with more opportunistic usleep_range(20, 200)

Will do, thanks!
