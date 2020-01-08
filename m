Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D48134ED8
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgAHV1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:27:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48180 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgAHV1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:27:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B01561584F8A2;
        Wed,  8 Jan 2020 13:27:01 -0800 (PST)
Date:   Wed, 08 Jan 2020 13:27:01 -0800 (PST)
Message-Id: <20200108.132701.1531822898576247637.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     ktkhai@virtuozzo.com, axboe@kernel.dk, willemb@google.com,
        deepa.kernel@gmail.com, johannes.berg@intel.com,
        viro@zeniv.linux.org.uk, pctammela@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] socket: fix unused-function warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107213609.520236-1-arnd@arndb.de>
References: <20200107213609.520236-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 13:27:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue,  7 Jan 2020 22:35:59 +0100

> When procfs is disabled, the fdinfo code causes a harmless
> warning:
> 
> net/socket.c:1000:13: error: 'sock_show_fdinfo' defined but not used [-Werror=unused-function]
>  static void sock_show_fdinfo(struct seq_file *m, struct file *f)
> 
> Change the preprocessor conditional to a compiler conditional
> to avoid the warning and let the compiler throw away the
> function itself.
> 
> Fixes: b4653342b151 ("net: Allow to show socket-specific information in /proc/[pid]/fdinfo/[fd]")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This isn't the prettiest thing I've ever seen.

I really think it's nicer to just explicitly put ifdef's around the
forward declaration and the implementation of sock_show_fdinfo().

Alternatively, move the implementation up to the location of the
forward declaration and then you just need one new ifdef guard.
