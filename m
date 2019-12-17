Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B7B123928
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfLQWJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:09:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43578 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfLQWJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:09:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B8956146F6EEF;
        Tue, 17 Dec 2019 14:09:30 -0800 (PST)
Date:   Tue, 17 Dec 2019 14:09:30 -0800 (PST)
Message-Id: <20191217.140930.477589169001575109.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix refcount init for TC-MQPRIO offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576506242-12761-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1576506242-12761-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 14:09:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Mon, 16 Dec 2019 19:54:02 +0530

> @@ -205,7 +205,11 @@ static int cxgb4_mqprio_alloc_hw_resources(struct net_device *dev)
>  			cxgb4_enable_rx(adap, &eorxq->rspq);
>  	}
>  
> -	refcount_inc(&adap->tc_mqprio->refcnt);
> +	if (!refcount_read(&adap->tc_mqprio->refcnt))
> +		refcount_set(&adap->tc_mqprio->refcnt, 1);
> +	else
> +		refcount_inc(&adap->tc_mqprio->refcnt);
> +

This is not correct.

You're bypassing the whole point of the refcount_t type which is to make sure
that code that initializes a new object explicitly calls refcount_set() and
that once the refcount goes to zero the object is freed or the refcount is
initialized again using refcount_set() or similar.

I'm not applying this, it's just papering around the real problem.
