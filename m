Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406A71B16A1
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgDTUEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgDTUEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 16:04:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD28DC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 13:04:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 37D8B12805C00;
        Mon, 20 Apr 2020 13:04:44 -0700 (PDT)
Date:   Mon, 20 Apr 2020 13:04:43 -0700 (PDT)
Message-Id: <20200420.130443.282630623281796701.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, jiri@resnulli.us, netdev@vger.kernel.org
Subject: Re: [PATCH net v3] team: fix hang in team_mode_get()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420150133.2586-1-ap420073@gmail.com>
References: <20200420150133.2586-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 13:04:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Mon, 20 Apr 2020 15:01:33 +0000

> When team mode is changed or set, the team_mode_get() is called to check
> whether the mode module is inserted or not. If the mode module is not
> inserted, it calls the request_module().
> In the request_module(), it creates a child process, which is
> the "modprobe" process and waits for the done of the child process.
> At this point, the following locks were used.
> down_read(&cb_lock()); by genl_rcv()
>     genl_lock(); by genl_rcv_msc()
>         rtnl_lock(); by team_nl_cmd_options_set()
>             mutex_lock(&team->lock); by team_nl_team_get()
> 
> Concurrently, the team module could be removed by rmmod or "modprobe -r"
> The __exit function of team module is team_module_exit(), which calls
> team_nl_fini() and it tries to acquire following locks.
> down_write(&cb_lock);
>     genl_lock();
> Because of the genl_lock() and cb_lock, this process can't be finished
> earlier than request_module() routine.
> 
> The problem secenario.
> CPU0                                     CPU1
> team_mode_get
>     request_module()
>                                          modprobe -r team_mode_roundrobin
>                                                      team <--(B)
>         modprobe team <--(A)
>             team_mode_roundrobin
> 
> By request_module(), the "modprobe team_mode_roundrobin" command
> will be executed. At this point, the modprobe process will decide
> that the team module should be inserted before team_mode_roundrobin.
> Because the team module is being removed.
> 
> By the module infrastructure, the same module insert/remove operations
> can't be executed concurrently.
> So, (A) waits for (B) but (B) also waits for (A) because of locks.
> So that the hang occurs at this point.
> 
> Test commands:
>     while :
>     do
>         teamd -d &
> 	killall teamd &
> 	modprobe -rv team_mode_roundrobin &
>     done
> 
> The approach of this patch is to hold the reference count of the team
> module if the team module is compiled as a module. If the reference count
> of the team module is not zero while request_module() is being called,
> the team module will not be removed at that moment.
> So that the above scenario could not occur.
> 
> Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied and queued up for -stable, thanks.
