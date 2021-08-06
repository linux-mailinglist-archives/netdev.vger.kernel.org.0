Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47063E2BF0
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 15:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhHFNvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 09:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhHFNvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 09:51:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFE1061158;
        Fri,  6 Aug 2021 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628257894;
        bh=k2Y9aipZPPlCNLObLR0DkEodjX0SsKq8KVYfy4+SmJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CSTD0cUbb7/rlh/ckG9AvuJUOVMY2C4ZT11OSwYwyDHS+2bR1DWwXJvOXaXFmE4MT
         /oeNPTshZlVHgw6vOVBXRtBwVEtUfz0AtH5NsSZppxwLEXQSJsb8p6WtPnq4JXyWtg
         24RMczCMIfGnM1abNyFPSFU3Xi9buuUDDhxBDqYA=
Date:   Fri, 6 Aug 2021 15:51:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        hannes@stressinduktion.org, davem@davemloft.net,
        akpm@linux-foundation.org, Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Minmin chen <chenmingmin@huawei.com>
Subject: Re: [PATCH v2] once: Fix panic when module unload
Message-ID: <YQ0+Yz+cWC0nh4uB@kroah.com>
References: <20210806082124.96607-1-wangkefeng.wang@huawei.com>
 <20210806064328.1b54a7f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806064328.1b54a7f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 06:43:28AM -0700, Jakub Kicinski wrote:
> On Fri, 6 Aug 2021 16:21:24 +0800 Kefeng Wang wrote:
> > DO_ONCE
> > DEFINE_STATIC_KEY_TRUE(___once_key);
> > __do_once_done
> >   once_disable_jump(once_key);
> >     INIT_WORK(&w->work, once_deferred);
> >     struct once_work *w;
> >     w->key = key;
> >     schedule_work(&w->work);                     module unload
> >                                                    //*the key is
> > destroy*
> > process_one_work
> >   once_deferred
> >     BUG_ON(!static_key_enabled(work->key));
> >        static_key_count((struct static_key *)x)    //*access key, crash*
> > 
> > When module uses DO_ONCE mechanism, it could crash due to the above
> > concurrency problem, we could reproduce it with link[1].
> > 
> > Fix it by add/put module refcount in the once work process.
> > 
> > [1] https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/
> 
> Seems reasonable. Greg does it look good to you?

Me?  I was not paying attention to this at all, sorry...

> I think we can take it thru networking since nobody cared to pick up v1.

Sure, I trust you :)
