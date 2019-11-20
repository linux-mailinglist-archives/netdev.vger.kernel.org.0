Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5ED104557
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbfKTUtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:49:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59944 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfKTUtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:49:09 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DE96514C2C722;
        Wed, 20 Nov 2019 12:49:08 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:49:08 -0800 (PST)
Message-Id: <20191120.124908.1547227295496302499.davem@davemloft.net>
To:     pmalani@chromium.org
Cc:     hayeswang@realtek.com, grundler@chromium.org,
        netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH net] r8152: Re-order napi_disable in rtl8152_close
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120194020.8796-1-pmalani@chromium.org>
References: <20191120194020.8796-1-pmalani@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:49:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>
Date: Wed, 20 Nov 2019 11:40:21 -0800

> Both rtl_work_func_t() and rtl8152_close() call napi_disable().
> Since the two calls aren't protected by a lock, if the close
> function starts executing before the work function, we can get into a
> situation where the napi_disable() function is called twice in
> succession (first by rtl8152_close(), then by set_carrier()).
> 
> In such a situation, the second call would loop indefinitely, since
> rtl8152_close() doesn't call napi_enable() to clear the NAPI_STATE_SCHED
> bit.
> 
> The rtl8152_close() function in turn issues a
> cancel_delayed_work_sync(), and so it would wait indefinitely for the
> rtl_work_func_t() to complete. Since rtl8152_close() is called by a
> process holding rtnl_lock() which is requested by other processes, this
> eventually leads to a system deadlock and crash.
> 
> Re-order the napi_disable() call to occur after the work function
> disabling and urb cancellation calls are issued.
> 
> Change-Id: I6ef0b703fc214998a037a68f722f784e1d07815e
> Reported-by: http://crbug.com/1017928
> Signed-off-by: Prashant Malani <pmalani@chromium.org>

Applied and queued up for -stable, thanks.
