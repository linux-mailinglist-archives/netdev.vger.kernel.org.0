Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53E9B80377
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 02:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391992AbfHCA1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 20:27:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389781AbfHCA1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 20:27:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C2161264EC7E;
        Fri,  2 Aug 2019 17:27:29 -0700 (PDT)
Date:   Fri, 02 Aug 2019 17:27:29 -0700 (PDT)
Message-Id: <20190802.172729.1656276508211556851.davem@davemloft.net>
To:     decui@microsoft.com
Cc:     sunilmut@microsoft.com, netdev@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        mikelley@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, vkuznets@redhat.com,
        marcelo.cerri@canonical.com
Subject: Re: [PATCH v2 net] hv_sock: Fix hang when a connection is closed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <PU1P153MB01696DDD3A3F601370701DD2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <PU1P153MB01696DDD3A3F601370701DD2BFDF0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 02 Aug 2019 17:27:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>
Date: Wed, 31 Jul 2019 01:25:45 +0000

> 
> There is a race condition for an established connection that is being closed
> by the guest: the refcnt is 4 at the end of hvs_release() (Note: here the
> 'remove_sock' is false):
> 
> 1 for the initial value;
> 1 for the sk being in the bound list;
> 1 for the sk being in the connected list;
> 1 for the delayed close_work.
> 
> After hvs_release() finishes, __vsock_release() -> sock_put(sk) *may*
> decrease the refcnt to 3.
> 
> Concurrently, hvs_close_connection() runs in another thread:
>   calls vsock_remove_sock() to decrease the refcnt by 2;
>   call sock_put() to decrease the refcnt to 0, and free the sk;
>   next, the "release_sock(sk)" may hang due to use-after-free.
> 
> In the above, after hvs_release() finishes, if hvs_close_connection() runs
> faster than "__vsock_release() -> sock_put(sk)", then there is not any issue,
> because at the beginning of hvs_close_connection(), the refcnt is still 4.
> 
> The issue can be resolved if an extra reference is taken when the
> connection is established.
> 
> Fixes: a9eeb998c28d ("hv_sock: Add support for delayed close")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>

Applied and queued up for -stable.

Do not ever CC: stable for networking patches, we submit to -stable manually.

Thank you.
