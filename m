Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893FB254C60
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgH0Rr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgH0Rr4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 13:47:56 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2E2E207CD;
        Thu, 27 Aug 2020 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598550476;
        bh=QImFks5kL2iW9bPDtsp5oEEcT9b2V3tJgw+yJs+9vDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QO5ca1kTtO4ZlpCRwpaVdI9S8F35pTwc0wU4wnfn+bI/v+18UaogVE3hkSz3i3ZU1
         DkhKYH/S1Y7iwi5NvIOQZ+1thhop2t7hO41qyfffoOTSQTbY0GUlsVL42+aiIKfzsZ
         +HAGwXUQ64GirDNTofFXwckavbSLXWkuRvUt7IC0=
Date:   Thu, 27 Aug 2020 10:47:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, michael.chan@broadcom.com,
        netdev@vger.kernel.org, kernel-team@fb.com,
        Rob Sherwood <rsher@fb.com>
Subject: Re: [PATCH net 1/2] net: disable netpoll on fresh napis
Message-ID: <20200827104753.29d836bb@kicinski-fedora-PC1C0HJN>
In-Reply-To: <7874b0df-8977-2468-0bd9-b6c47ccb068c@gmail.com>
References: <20200826194007.1962762-1-kuba@kernel.org>
        <20200826194007.1962762-2-kuba@kernel.org>
        <25872247-9776-2638-cf83-a51861ce5cd4@gmail.com>
        <20200827081003.289009f4@kicinski-fedora-PC1C0HJN>
        <7874b0df-8977-2468-0bd9-b6c47ccb068c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 08:43:22 -0700 Eric Dumazet wrote:
> On 8/27/20 8:10 AM, Jakub Kicinski wrote:
> > On Thu, 27 Aug 2020 00:25:31 -0700 Eric Dumazet wrote:  
> >> On 8/26/20 12:40 PM, Jakub Kicinski wrote:  
> >>> To ensure memory ordering is correct we need to use RCU accessors.  
> >>  
> >>> +	set_bit(NAPI_STATE_NPSVC, &napi->state);
> >>> +	list_add_rcu(&napi->dev_list, &dev->napi_list);  
> >>  
> >>>  
> >>> -	list_for_each_entry(napi, &dev->napi_list, dev_list) {
> >>> +	list_for_each_entry_rcu(napi, &dev->napi_list, dev_list) {
> >>>  		if (cmpxchg(&napi->poll_owner, -1, cpu) == -1) {
> >>>  			poll_one_napi(napi);
> >>>  			smp_store_release(&napi->poll_owner, -1);
> >>>     
> >>
> >> You added rcu in this patch (without anything in the changelog).  
> > 
> > I mentioned I need it for the barriers, in particular I wanted the
> > store release barrier in list_add. Not extremely clean :(  
> 
> Hmmm, we also have smp_mb__after_atomic()

Pairing with the cmpxchg() on the netpoll side? Can do, I wasn't 
sure if the list operations themselves need some special care 
(like READ_ONCE/WRITE_ONCE)..

> >> netpoll_poll_dev() uses rcu_dereference_bh(), suggesting you might
> >> need list_for_each_entry_rcu_bh()  
> > 
> > I thought the RCU flavors are mostly meaningless at this point,
> > list_for_each_entry_rcu() checks rcu_read_lock_any_held(). I can add
> > the definition of list_for_each_entry_rcu_bh() (since it doesn't exist)
> > or go back to non-RCU iteration (since the use is just documentation,
> > the code is identical). Or fix it some other way?
> >   
> 
> Oh, I really thought list_for_each_entry_rcu() was only checking standard rcu.
> 
> I might have been confused because we do have hlist_for_each_entry_rcu_bh() helper.
> 
> Anyway, when looking at the patch I was not at ease because we do not have proper
> rcu grace period when a napi is removed from dev->napi_list. A driver might
> free the napi struct right after calling netif_napi_del()

Ugh, you're right. I didn't look closely enough at netif_napi_del():

	if (napi_hash_del(napi))
		synchronize_net();
	list_del_init(&napi->dev_list);

Looks like I can reorder these.. and perhaps make all dev->napi_list
accesses RCU, for netpoll?
