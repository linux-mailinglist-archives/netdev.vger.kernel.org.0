Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9372247D3
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgGRBjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGRBjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:39:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA5EC0619D2;
        Fri, 17 Jul 2020 18:39:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 005E011E45910;
        Fri, 17 Jul 2020 18:39:13 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:39:13 -0700 (PDT)
Message-Id: <20200717.183913.1150846066923869608.davem@davemloft.net>
To:     wanghai38@huawei.com
Cc:     vishal@chelsio.com, kuba@kernel.org, jeff@garzik.org,
        divy@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: cxgb3: add missed destroy_workqueue in cxgb3
 probe failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717062117.8941-1-wanghai38@huawei.com>
References: <20200717062117.8941-1-wanghai38@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:39:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>
Date: Fri, 17 Jul 2020 14:21:17 +0800

> The driver forgets to call destroy_workqueue when cxgb3 probe fails.
> Add the missed calls to fix it.
> 
> Fixes: 4d22de3e6cc4 ("Add support for the latest 1G/10G Chelsio adapter, T3.")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

You have to handle the case that the probing of one or more devices
fails yet one or more others succeed.

And you can't know in advance how this will play out.

This is why the workqueue is unconditionally created, and only destroyed
on module remove.
