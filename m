Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BF43E43ED
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhHIK22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233720AbhHIK21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 06:28:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21AE76108C;
        Mon,  9 Aug 2021 10:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628504886;
        bh=1Rr9G2WTvyN2154ArfnkrxNB++dNyHRWTlM42K7U3LA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c5csrOUUWBbIRXzbnhuusFcKO2ZeeMaQD8XIm2H8GWZBQ7BSxySLPLGqYwCZA024M
         apCWfvT5lSqwva4SO63w3ic1sydrdWQvtLxpHaZcWhYso2Wu/+XypiVbNth9xyieXg
         VdKbIwBeYelyv9/VMO0E0544HrzE7W/M80n4CqhHisqxMME40Io/EioTBiydXFdQxk
         J9zk2taAZoFk6xJivLRSzdFHYLafqRUg+X7VWiRO8ZgeYaUD30DAQiJngpsVvd8xsj
         JgAjZ95phOJE0B9Gbtim7NqfFU2Q+W1o8qcSJ6VhggVLY+IYwhUAXEx1br8UBeLD6c
         75ci93sNK/ybA==
Date:   Mon, 9 Aug 2021 13:28:02 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     yajun.deng@linux.dev, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sock: add the case if sk is NULL
Message-ID: <YREDMtIJ2Mz/ELy7@unreal>
References: <20210806061136.54e6926e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210806063815.21541-1-yajun.deng@linux.dev>
 <489e6f1ce9f8de6fd8765d82e1e47827@linux.dev>
 <79e7c9a8-526c-ae9c-8273-d1d4d6170b69@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79e7c9a8-526c-ae9c-8273-d1d4d6170b69@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 11:34:31AM +0200, Eric Dumazet wrote:
> 
> 
> On 8/9/21 8:12 AM, yajun.deng@linux.dev wrote:
> > August 6, 2021 9:11 PM, "Jakub Kicinski" <kuba@kernel.org> wrote:
> > 
> >> On Fri, 6 Aug 2021 14:38:15 +0800 Yajun Deng wrote:
> >>
> >>> Add the case if sk is NULL in sock_{put, hold},
> >>> The caller is free to use it.
> >>>
> >>> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> >>
> >> The obvious complaint about this patch (and your previous netdev patch)
> >> is that you're spraying branches everywhere in the code. Sure, it may
> > 
> > Sorry for that, I'll be more normative in later submission.
> >> be okay for free(), given how expensive of an operation that is but
> >> is having refcounting functions accept NULL really the best practice?
> >>
> >> Can you give us examples in the kernel where that's the case?
> > 
> > 0   include/net/neighbour.h         neigh_clone()
> > 1   include/linux/cgroup.h          get_cgroup_ns() and put_cgroup_ns()  (This is very similar to my submission)
> > 2   include/linux/ipc_namespace.h   get_ipc_ns()
> > 3   include/linux/posix_acl.h       posix_acl_dup()
> > 4   include/linux/pid.h             get_pid()
> > 5   include/linux/user_namespace.h  get_user_ns()
> > 
> 
> These helpers might be called with NULL pointers by design.
> 
> sock_put() and sock_hold() are never called with NULL.
> 
> Same for put_page() and hundreds of other functions.
> 
> By factorizing a conditional in the function, hoping to remove one in few callers,
> we add more conditional branches (and increase code size)

You can add into your list that such "if NULL" checks add false
impression that NULL can be there and it is valid.

Thanks

> 
