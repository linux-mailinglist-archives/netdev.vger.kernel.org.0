Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BC81253BB
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfLRUpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:45:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56256 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfLRUpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 15:45:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 734FC152E499D;
        Wed, 18 Dec 2019 12:45:11 -0800 (PST)
Date:   Wed, 18 Dec 2019 12:45:10 -0800 (PST)
Message-Id: <20191218.124510.1971632024371398726.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next v3 07/11] tcp: Prevent coalesce/collapse when
 skb has MPTCP extensions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5fc0d4bd-5172-298d-6bbb-00f75c7c0dc9@gmail.com>
References: <20191217203807.12579-1-mathew.j.martineau@linux.intel.com>
        <20191217203807.12579-8-mathew.j.martineau@linux.intel.com>
        <5fc0d4bd-5172-298d-6bbb-00f75c7c0dc9@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Dec 2019 12:45:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 18 Dec 2019 11:50:24 -0800

> On 12/17/19 12:38 PM, Mat Martineau wrote:
>> The MPTCP extension data needs to be preserved as it passes through the
>> TCP stack. Make sure that these skbs are not appended to others during
>> coalesce or collapse, so the data remains associated with the payload of
>> the given skb.
> 
> This seems a very pessimistic change to me.
> 
> Are you planing later to refine this limitation ?
> 
> Surely if a sender sends TSO packet, we allow all the segments
> being aggregated at receive side either by GRO or TCP coalescing.

This turns off absolutely crucial functional elements of our TCP
stack, and will avoid all of the machinery that avoids wastage in TCP
packets sitting in the various queues.  skb->truesize management, etc.

I will not apply these patches with such a non-trivial regression in
place for MPTCP streams, sorry.
