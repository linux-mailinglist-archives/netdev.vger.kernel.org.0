Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C043423E2A7
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 21:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHFT5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 15:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbgHFT5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 15:57:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21AE52173E;
        Thu,  6 Aug 2020 19:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596743830;
        bh=XrYVZ3oqFm3D2f9WTdPjLr5x/qcgqkiOD1BzVfZIgT4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MNJslydKZ9YNIhU1w6SL5+DqIj2cQDuWHcclyQfcJZPfeCx19ROm0ISmLnMO0jRRa
         Mj9BEW5d03ObOODRqzNqmE89sOMNctPywm97Ds+9rv0zEEIkC0/6+vQK3R+XB3OytQ
         V3/XgW5gOUYHY2nP8mqrHeiwAJJv8i/y0UL4mjLY=
Date:   Thu, 6 Aug 2020 12:57:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org,
        Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH v2] net: add support for threaded NAPI polling
Message-ID: <20200806125708.6492ebfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <2ce6de8b-f520-3f09-746a-caf2ecab428a@gmail.com>
References: <20200806095558.82780-1-nbd@nbd.name>
        <20200806115511.6774e922@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2ce6de8b-f520-3f09-746a-caf2ecab428a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Aug 2020 12:25:08 -0700 Eric Dumazet wrote:
> On 8/6/20 11:55 AM, Jakub Kicinski wrote:
> > I'm still trying to wrap my head around this.
> > 
> > Am I understanding correctly that you have one IRQ and multiple NAPI
> > instances?
> > 
> > Are we not going to end up with pretty terrible cache locality here if
> > the scheduler starts to throw rx and tx completions around to random
> > CPUs?
> > 
> > I understand that implementing separate kthreads would be more LoC, but
> > we do have ksoftirqs already... maybe we should make the NAPI ->
> > ksoftirq mapping more flexible, and improve the logic which decides to
> > load ksoftirq rather than make $current() pay?
> > 
> > Sorry for being slow.
> 
> Issue with ksoftirqd is that
> - it is bound to a cpu

Do you envision the scheduler balancing or work stealing being
advantageous in some configurations?

I was guessing that for compute workloads having ksoftirq bound will
actually make things more predictable/stable.

For pure routers (where we expect multiple cores to reach 100% just
doing packet forwarding) as long as there is an API to re-balance NAPIs
to cores - a simple specialized user space daemon would probably do a
better job as it can consult packet drop metrics etc.

Obviously I have no data to back up these claims..

> - Its nice value is 0, meaning that user threads can sometime compete too much with it.

True, I thought we could assume user level tuning.

> - It handles all kinds of softirqs, so messing with it might hurt some other layer.

Right, I have no data on how much this hurts in practice.

> Note that the patch is using a dedicate work queue. It is going to be not practical
> in case you need to handle two different NIC, and want separate pools for each of them.
> 
> Ideally, having one kthread per queue would be nice, but then there is more plumbing
> work to let these kthreads being visible in a convenient way (/sys/class/net/ethX/queues/..../kthread)

Is context switching cost negligible?

ksoftirq-like thread replicates all the NAPI budget-level mixing we
already do today.
