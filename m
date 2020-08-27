Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A6B2548A2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgH0PKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 11:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgH0PKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 11:10:05 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E373C22B40;
        Thu, 27 Aug 2020 15:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598541005;
        bh=8ivePe96dqpUr5wV1RUMJKtJljdYsYT4qDcLw69YnrM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=otgFaDfgw82soAyvvp04dagDx8xLncxrZPIDh00gJMGm83HcN4f9d4+091JF8NR8S
         TdG7zFIumB0OKRfEX2a8xbBEbR1nHXvNWVrhW742GPUGMv0mVLNQc6ndLyJpTG7Swg
         Bs0GfDkoJVu88g1UP+o4NFoIy99fidqDPaFlW2kI=
Date:   Thu, 27 Aug 2020 08:10:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, michael.chan@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Rob Sherwood <rsher@fb.com>
Subject: Re: [PATCH net 1/2] net: disable netpoll on fresh napis
Message-ID: <20200827081003.289009f4@kicinski-fedora-PC1C0HJN>
In-Reply-To: <25872247-9776-2638-cf83-a51861ce5cd4@gmail.com>
References: <20200826194007.1962762-1-kuba@kernel.org>
        <20200826194007.1962762-2-kuba@kernel.org>
        <25872247-9776-2638-cf83-a51861ce5cd4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 00:25:31 -0700 Eric Dumazet wrote:
> On 8/26/20 12:40 PM, Jakub Kicinski wrote:
> > To ensure memory ordering is correct we need to use RCU accessors.
>
> > +	set_bit(NAPI_STATE_NPSVC, &napi->state);
> > +	list_add_rcu(&napi->dev_list, &dev->napi_list);
> 
> >  
> > -	list_for_each_entry(napi, &dev->napi_list, dev_list) {
> > +	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
> >  		if (cmpxchg(&napi->poll_owner, -1, cpu) == -1) {
> >  			poll_one_napi(napi);
> >  			smp_store_release(&napi->poll_owner, -1);
> >   
> 
> You added rcu in this patch (without anything in the changelog).

I mentioned I need it for the barriers, in particular I wanted the
store release barrier in list_add. Not extremely clean :(

> netpoll_poll_dev() uses rcu_dereference_bh(), suggesting you might
> need list_for_each_entry_rcu_bh()

I thought the RCU flavors are mostly meaningless at this point,
list_for_each_entry_rcu() checks rcu_read_lock_any_held(). I can add
the definition of list_for_each_entry_rcu_bh() (since it doesn't exist)
or go back to non-RCU iteration (since the use is just documentation,
the code is identical). Or fix it some other way?
