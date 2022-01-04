Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C85C4849B7
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 22:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbiADVMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 16:12:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60400 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232036AbiADVMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 16:12:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F036461474
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 21:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231C9C36AEB;
        Tue,  4 Jan 2022 21:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641330732;
        bh=kO0J5mZ6Qy7COYnVsjDnW3XBxI2SGucgTGCK2Liqqdk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ql8D4ataFOvMmvbFE8Z61lKCiRmUVYJICxAFMn2By3WHVQcj5/az1OQluZsiUUJbh
         d3PdD/9Mqzz5DtJYg6nbHBCZb7QrfkeOfuSR4zE/l+r4fkVc/GJRALII9YGshXPtjF
         QuqBdDVGJi51hM+5Lacn4OXFp2e4aaFjR8DYyg9F+AyLoRYHJORHP68P0DpHuf0noh
         LSb5Q6UnfPtySobD26mh83VV/4r4GNMldDopVFBN6pYKu6r1Kw/iTeXHxxvux/OkqN
         utsm3x2Pf5J6kWw46zetjaZCmOQjqJfDUnFAZOpEonelg/uk73iAROBkbZY9tIjlZ8
         198SZeC+SEa8Q==
Date:   Tue, 4 Jan 2022 13:12:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        dsahern@gmail.com, idosch@idosch.org, nicolas.dichtel@6wind.com,
        nikolay@nvidia.com
Subject: Re: [PATCH net-next v6] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20220104131210.0a2afea8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220104204033.rq4467r3kaaowczj@kgollan-pc>
References: <20220104081053.33416-1-lschlesinger@drivenets.com>
        <66d3e40c-4889-9eed-e5af-8aed296498e5@gmail.com>
        <20220104204033.rq4467r3kaaowczj@kgollan-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jan 2022 22:40:43 +0200 Lahav Schlesinger wrote:
> > This is going to be very expensive on hosts with 1 million netdev.
> >
> > You should remove this dev->bulk_delete and instead use a list.
> >
> > You already use @list_kill, you only need a second list and possibly
> > reuse dev->unreg_list
> >
> > If you do not feel confortable about reusing dev->unreg_list, add a new
> > anchor (like dev->bulk_kill_list)  
> 
> I tried using dev->unreg_list but it doesn't work e.g. for veth pairs
> where ->dellink() of a veth automatically adds the peer. Therefore if
> @ifindices contains both peers then the first ->dellink() will remove
> the next device from @list_kill. This caused a page fault when
> @list_kill was further iterated on.
> 
> I opted to add a flag to struct net_device as David suggested in order
> to avoid increasing sizeof(struct net_device), but perhaps it's not that
> big of an issue.
> If it's fine then I'll update it.

With the dev->bulk_delete flag and raw array instead of attributes you
can go back to the version of the code which stores dev pointers in a
temp kmalloc'd array, right?
