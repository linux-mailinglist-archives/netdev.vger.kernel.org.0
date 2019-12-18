Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A61123E0A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 04:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfLRDmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 22:42:09 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:53477 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRDmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 22:42:08 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBI3g4LR000793;
        Tue, 17 Dec 2019 19:42:05 -0800
Date:   Wed, 18 Dec 2019 09:03:13 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix refcount init for TC-MQPRIO offload
Message-ID: <20191218033312.GA15752@chelsio.com>
References: <1576506242-12761-1-git-send-email-rahul.lakkireddy@chelsio.com>
 <20191217.140930.477589169001575109.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217.140930.477589169001575109.davem@davemloft.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, December 12/17/19, 2019 at 14:09:30 -0800, David Miller wrote:
> From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> Date: Mon, 16 Dec 2019 19:54:02 +0530
> 
> > @@ -205,7 +205,11 @@ static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
> >  			cxgb4_enable_rx(adap, &eorxq->rspq);
> >  	}
> >  
> > -	refcount_inc(&adap->tc_mqprio->refcnt);
> > +	if (!refcount_read(&adap->tc_mqprio->refcnt))
> > +		refcount_set(&adap->tc_mqprio->refcnt, 1);
> > +	else
> > +		refcount_inc(&adap->tc_mqprio->refcnt);
> > +
> 
> This is not correct.
> 
> You're bypassing the whole point of the refcount_t type which is to make sure
> that code that initializes a new object explicitly calls refcount_set() and
> that once the refcount goes to zero the object is freed or the refcount is
> initialized again using refcount_set() or similar.
> 
> I'm not applying this, it's just papering around the real problem.

Ok, I'll move refcount_set() closer to where the hardware queue
arrays, that it's tracking, have been allocated. Will send a v2.

Thanks,
Rahul
