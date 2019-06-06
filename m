Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA80B37A86
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbfFFRHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728459AbfFFRHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 13:07:42 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D4EC6EB97;
        Thu,  6 Jun 2019 17:07:37 +0000 (UTC)
Received: from laptop.jcline.org (ovpn-124-165.rdu2.redhat.com [10.10.124.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 804D316917;
        Thu,  6 Jun 2019 17:07:36 +0000 (UTC)
Received: from laptop.jcline.org (localhost [IPv6:::1])
        by laptop.jcline.org (Postfix) with ESMTPS id 9304D7045B19;
        Thu,  6 Jun 2019 13:07:30 -0400 (EDT)
Date:   Thu, 6 Jun 2019 13:07:29 -0400
From:   Jeremy Cline <jcline@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, ian.kumlien@gmail.com,
        alan.maguire@oracle.com, dsahern@gmail.com
Subject: Re: [PATCH net] neighbor: Reset gc_entries counter if new entry is
 released before insert
Message-ID: <20190606170729.GA15882@laptop.jcline.org>
References: <20190502010834.25519-1-dsahern@kernel.org>
 <20190504.004100.415091334346243894.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504.004100.415091334346243894.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 06 Jun 2019 17:07:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sat, May 04, 2019 at 12:41:00AM -0400, David Miller wrote:
> From: David Ahern <dsahern@kernel.org>
> Date: Wed,  1 May 2019 18:08:34 -0700
> 
> > From: David Ahern <dsahern@gmail.com>
> > 
> > Ian and Alan both reported seeing overflows after upgrades to 5.x kernels:
> >   neighbour: arp_cache: neighbor table overflow!
> > 
> > Alan's mpls script helped get to the bottom of this bug. When a new entry
> > is created the gc_entries counter is bumped in neigh_alloc to check if a
> > new one is allowed to be created. ___neigh_create then searches for an
> > existing entry before inserting the just allocated one. If an entry
> > already exists, the new one is dropped in favor of the existing one. In
> > this case the cleanup path needs to drop the gc_entries counter. There
> > is no memory leak, only a counter leak.
> > 
> > Fixes: 58956317c8d ("neighbor: Improve garbage collection")
> > Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
> > Reported-by: Alan Maguire <alan.maguire@oracle.com>
> > Signed-off-by: David Ahern <dsahern@gmail.com>
> 
> Applied and queued up for -stable.

Did this get lost in the shuffle? I see it in mainline, but I don't see
it in stable. Folks are encountering it with recent 5.1 kernels in
Fedora: https://bugzilla.redhat.com/show_bug.cgi?id=1708717.

Thanks,
Jeremy
