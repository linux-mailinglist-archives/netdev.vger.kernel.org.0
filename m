Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491813952D1
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 22:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhE3UPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 16:15:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhE3UPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 16:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B350260FE4;
        Sun, 30 May 2021 20:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622405609;
        bh=icbgyz4TenkJCmatsfuMN9K/YQJVis8q0fJhUq9JN5s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kZEGK7uP/Q6BPeYQisDTqmKM0rCCpFl19ro1D9yWnRS7wQWiw11Y2FXndFP14Gytz
         r28YhuKQHA+zZLst/zXMzDqZ84a+1wl/2/3/u3L9V2m/0kGNSQuQcO5mAMWM2qvqmP
         Dt9mBbHvGVwEuGOwunmWysXD5kbZB8WK4F2vlQSmHfe+KkhPU+efN1n4W4wjmlUfmQ
         995FCEcf3u2vMNhKo4AStbPfv5i9vS34cYxV29pEqffivH9IxyZgzGwjFTSGq0EKiq
         +y7JyROwscGQ/6d6DdkB1bDk8MgYZlO5//cmDWT9at+VSliDO9UpQz9Juwvr4wvicV
         SgKZFGsV3Patg==
Date:   Sun, 30 May 2021 13:13:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Subject: Re: [PATCH net-next v4 3/5] ipv6: ioam: IOAM Generic Netlink API
Message-ID: <20210530131328.55941d22@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <152739558.34126899.1622373504535.JavaMail.zimbra@uliege.be>
References: <20210527151652.16074-1-justin.iurman@uliege.be>
        <20210527151652.16074-4-justin.iurman@uliege.be>
        <20210529140601.1ab9d40e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <152739558.34126899.1622373504535.JavaMail.zimbra@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 May 2021 13:18:24 +0200 (CEST) Justin Iurman wrote:
> >> +	sc = ns->schema;
> >> +	err = rhashtable_remove_fast(&nsdata->namespaces, &ns->head,
> >> +				     rht_ns_params);
> >> +	if (err)
> >> +		goto out_unlock;
> >> +
> >> +	if (sc)
> >> +		sc->ns = NULL;  
> > 
> > the sc <> ns pointers should be annotated with __rcu, and appropriate
> > accessors used. At the very least the need READ/WRITE_ONCE().  
> 
> I thought that, in this specific case, the mutex would be enough.

For writing, but not for preventing data races between writer and
reader.

> Note that rcu is used everywhere else for both of them (see patch
> #2). Could you explain your reasoning? 

We need to make sure the compiler doesn't play tricks. LWN explains
this in detail (worth reading in its own right):

https://lwn.net/Articles/793253/
https://lwn.net/Articles/799218/

Looking at the code again, I think it's even worse, I see:

ioam6_fill_trace_data()
	if (ns->schema)
		sclen += ns->schema->len / 4;

__ioam6_fill_trace_data()
	if (!ns->schema) {
		*(__be32 *)data = cpu_to_be32(IOAM6_EMPTY_u24);
	} else {
		*(__be32 *)data = ns->schema->hdr;
		data += sizeof(__be32);

		memcpy(data, ns->schema->data, ns->schema->len);

Value of schema can change in between. So it may had been NULL when we
checked for the length calculation, and non-NULL when we were writing
data. ns->schema should be dereferenced once, and result passed around.

> So I guess your comment also applies to other functions here
> (add/del, etc), where either ns or sc is accessed, right?

Correct.
