Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2C10DF44
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 21:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfK3U1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 15:27:44 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44872 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3U1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 15:27:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3:a597:786a:2aef:1599])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4960A14511F6C;
        Sat, 30 Nov 2019 12:27:43 -0800 (PST)
Date:   Sat, 30 Nov 2019 12:27:42 -0800 (PST)
Message-Id: <20191130.122742.343376576614064539.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net,stable 1/1] net: fec: match the dev_id between
 probe and remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1575009408-30362-1-git-send-email-fugang.duan@nxp.com>
References: <1575009408-30362-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 12:27:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>
Date: Fri, 29 Nov 2019 06:40:28 +0000

> Test device bind/unbind on i.MX8QM platform:
> echo 5b040000.ethernet > /sys/bus/platform/drivers/fec/unbind
> echo 5b040000.ethernet > /sys/bus/platform/drivers/fec/bind
> 
> error log:
> pps pps0: new PPS source ptp0 /sys/bus/platform/drivers/fec/bind
> fec: probe of 5b040000.ethernet failed with error -2
> 
> It should decrease the dev_id when device is unbinded. So let
> the fec_dev_id as global variable and let the count match in
> .probe() and .remvoe().
> 
> Reported-by: shivani.patel <shivani.patel@volansystech.com>
> Signed-off-by: Fugang Duan <fugang.duan@nxp.com>

This is not correct.

Nothing says that there is a direct correlation between the devices
added and the ones removed, nor the order in which these operations
occur relative to eachother.

This dev_id allocation is buggy because you aren't using a proper
ID allocation scheme such as IDR.

I'm not applying this patch, it is incorrect and makes things
worse rather than better.
