Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D62A346EF2
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhCXBkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:40:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60928 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhCXBiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:38:14 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E2BF762BEA;
        Wed, 24 Mar 2021 02:38:04 +0100 (CET)
Date:   Wed, 24 Mar 2021 02:38:10 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
Message-ID: <20210324013810.GA5861@salvia>
References: <20210303125953.11911-1-ozsh@nvidia.com>
 <20210303161147.GA17082@salvia>
 <YFjdb7DveNOolSTr@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFjdb7DveNOolSTr@horizon.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcelo,

On Mon, Mar 22, 2021 at 03:09:51PM -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Mar 03, 2021 at 05:11:47PM +0100, Pablo Neira Ayuso wrote:
[...]
> > Or probably make the cookie unique is sufficient? The cookie refers to
> > the memory address but memory can be recycled very quickly. If the
> > cookie helps to catch the reorder scenario, then the conntrack id
> > could be used instead of the memory address as cookie.
> 
> Something like this, if I got the idea right, would be even better. If
> the entry actually expired before it had a chance of being offloaded,
> there is no point in offloading it to then just remove it.

It would be interesting to explore this idea you describe. Maybe a
flag can be set on stale objects, or simply remove the stale object
from the offload queue. So I guess it should be possible to recover
control on the list of pending requests as a batch that is passed
through one single queue_work call.
