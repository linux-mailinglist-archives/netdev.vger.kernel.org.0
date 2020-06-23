Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829E620480B
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbgFWDnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgFWDnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:43:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2280DC061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 20:43:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3798120F93F8;
        Mon, 22 Jun 2020 20:43:30 -0700 (PDT)
Date:   Mon, 22 Jun 2020 20:43:30 -0700 (PDT)
Message-Id: <20200622.204330.1741202160832757898.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] hsr: avoid to create proc file after unregister
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200621134625.10522-1-ap420073@gmail.com>
References: <20200621134625.10522-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 20:43:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sun, 21 Jun 2020 13:46:25 +0000

> When an interface is being deleted, "/proc/net/dev_snmp6/<interface name>"
> is deleted.
> The function for this is addrconf_ifdown() in the addrconf_notify() and
> it is called by notification, which is NETDEV_UNREGISTER.
> But, if NETDEV_CHANGEMTU is triggered after NETDEV_UNREGISTER,
> this proc file will be created again.
> This recreated proc file will be deleted by netdev_wati_allrefs().
> Before netdev_wait_allrefs() is called, creating a new HSR interface
> routine can be executed and It tries to create a proc file but it will
> find an un-deleted proc file.
> At this point, it warns about it.
> 
> To avoid this situation, it can use ->dellink() instead of
> ->ndo_uninit() to release resources because ->dellink() is called
> before NETDEV_UNREGISTER.
> So, a proc file will not be recreated.
> 
> Test commands
 ...
> Splat looks like:
 ...
> Reported-by: syzbot+1d51c8b74efa4c44adeb@syzkaller.appspotmail.com
> Fixes: e0a4b99773d3 ("hsr: use upper/lower device infrastructure")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thank you.
