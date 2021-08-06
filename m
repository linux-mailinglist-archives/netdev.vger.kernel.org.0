Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563903E2BC5
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 15:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344368AbhHFNnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 09:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244377AbhHFNnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 09:43:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 527BA61078;
        Fri,  6 Aug 2021 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628257409;
        bh=xB3Efw0KXOZkZsJCIwg4mugkxOXkw3lNVMttVabtPSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kGqpxt97w3mtx0+CKwBdCQ/SbUmUaTJDs7BbKjB6R6Y0XrjDTmUECv/YzfEntiPst
         xP10VhgKHno40Ix6Jkk41Q/z+yOKopmGf0SeiLl0IACwOjoZYd6F/XTXux4+GC4//p
         HUdfZ7g5JiBxqZkIkxV76Y71WSlv5ZOOoEjCsItlMYtZQgRjV1W2wIGWmrvE760a6Z
         uqh3eQ9+NkfZoEN/hzHtQVYDC7/yYMVGjylHEUFrvS0F/O/AZRaQldzcojwCS95Zk3
         aOko5fafiyQhvZnTwQ6pjRCNkyaLV3SSdaJyvc811BqE9LJVfjCALJ6re7Lyz1VTp8
         qYTI/3iJAXq4Q==
Date:   Fri, 6 Aug 2021 06:43:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        <gregkh@linuxfoundation.org>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <hannes@stressinduktion.org>, <davem@davemloft.net>,
        <akpm@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Minmin chen <chenmingmin@huawei.com>
Subject: Re: [PATCH v2] once: Fix panic when module unload
Message-ID: <20210806064328.1b54a7f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806082124.96607-1-wangkefeng.wang@huawei.com>
References: <20210806082124.96607-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Aug 2021 16:21:24 +0800 Kefeng Wang wrote:
> DO_ONCE
> DEFINE_STATIC_KEY_TRUE(___once_key);
> __do_once_done
>   once_disable_jump(once_key);
>     INIT_WORK(&w->work, once_deferred);
>     struct once_work *w;
>     w->key = key;
>     schedule_work(&w->work);                     module unload
>                                                    //*the key is
> destroy*
> process_one_work
>   once_deferred
>     BUG_ON(!static_key_enabled(work->key));
>        static_key_count((struct static_key *)x)    //*access key, crash*
> 
> When module uses DO_ONCE mechanism, it could crash due to the above
> concurrency problem, we could reproduce it with link[1].
> 
> Fix it by add/put module refcount in the once work process.
> 
> [1] https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/

Seems reasonable. Greg does it look good to you?

I think we can take it thru networking since nobody cared to pick up v1.
