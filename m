Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64225B0CAD
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731277AbfILKSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:18:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731273AbfILKSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:18:36 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6DFA120477AC;
        Thu, 12 Sep 2019 03:18:34 -0700 (PDT)
Date:   Thu, 12 Sep 2019 12:18:33 +0200 (CEST)
Message-Id: <20190912.121833.160552401560653311.davem@davemloft.net>
To:     yangyingliang@huawei.com
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        eric.dumazet@gmail.com, xiyou.wangcong@gmail.com,
        weiyongjun1@huawei.com
Subject: Re: [PATCH v4] tun: fix use-after-free when register netdev failed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568113017-79840-1-git-send-email-yangyingliang@huawei.com>
References: <1568113017-79840-1-git-send-email-yangyingliang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 03:18:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>
Date: Tue, 10 Sep 2019 18:56:57 +0800

> I got a UAF repport in tun driver when doing fuzzy test:
 ...
> tun_chr_read_iter() accessed the memory which freed by free_netdev()
> called by tun_set_iff():
> 
>         CPUA                                           CPUB
>   tun_set_iff()
>     alloc_netdev_mqs()
>     tun_attach()
>                                                   tun_chr_read_iter()
>                                                     tun_get()
>                                                     tun_do_read()
>                                                       tun_ring_recv()
>     register_netdevice() <-- inject error
>     goto err_detach
>     tun_detach_all() <-- set RCV_SHUTDOWN
>     free_netdev() <-- called from
>                      err_free_dev path
>       netdev_freemem() <-- free the memory
>                         without check refcount
>       (In this path, the refcount cannot prevent
>        freeing the memory of dev, and the memory
>        will be used by dev_put() called by
>        tun_chr_read_iter() on CPUB.)
>                                                      (Break from tun_ring_recv(),
>                                                      because RCV_SHUTDOWN is set)
>                                                    tun_put()
>                                                      dev_put() <-- use the memory
>                                                                    freed by netdev_freemem()
> 
> Put the publishing of tfile->tun after register_netdevice(),
> so tun_get() won't get the tun pointer that freed by
> err_detach path if register_netdevice() failed.
> 
> Fixes: eb0fb363f920 ("tuntap: attach queue 0 before registering netdevice")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Applied, thanks.
