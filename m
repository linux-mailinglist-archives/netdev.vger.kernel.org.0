Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE7FB2D5C9
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 08:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE2G6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 02:58:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58342 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfE2G6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 02:58:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A459A1476F2D6;
        Tue, 28 May 2019 23:58:09 -0700 (PDT)
Date:   Tue, 28 May 2019 23:58:06 -0700 (PDT)
Message-Id: <20190528.235806.323127882998745493.davem@davemloft.net>
To:     linyunsheng@huawei.com
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
References: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 May 2019 23:58:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Mon, 27 May 2019 09:47:54 +0800

> When user has configured a large number of virtual netdev, such
> as 4K vlans, the carrier on/off operation of the real netdev
> will also cause it's virtual netdev's link state to be processed
> in linkwatch. Currently, the processing is done in a work queue,
> which may cause worker starvation problem for other work queue.
> 
> This patch releases the cpu when link watch worker has processed
> a fixed number of netdev' link watch event, and schedule the
> work queue again when there is still link watch event remaining.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Why not rtnl_unlock(); yield(); rtnl_lock(); every "100" events
processed?

That seems better than adding all of this overhead to reschedule the
workqueue every 100 items.
