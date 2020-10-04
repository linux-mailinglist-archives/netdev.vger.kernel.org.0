Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D923282DCF
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgJDVsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbgJDVsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:48:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A16C0613CE;
        Sun,  4 Oct 2020 14:48:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90DD212780A38;
        Sun,  4 Oct 2020 14:31:36 -0700 (PDT)
Date:   Sun, 04 Oct 2020 14:48:23 -0700 (PDT)
Message-Id: <20201004.144823.620544782441330271.davem@davemloft.net>
To:     anant.thazhemadam@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com,
        jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: team: fix memory leak in __team_options_register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201004205536.4734-1-anant.thazhemadam@gmail.com>
References: <20201004205536.4734-1-anant.thazhemadam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:31:36 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Mon,  5 Oct 2020 02:25:36 +0530

> The variable "i" isn't initialized back correctly after the first loop
> under the label inst_rollback gets executed.
> 
> The value of "i" is assigned to be option_count - 1, and the ensuing 
> loop (under alloc_rollback) begins by initializing i--. 
> Thus, the value of i when the loop begins execution will now become 
> i = option_count - 2.
> 
> Thus, when kfree(dst_opts[i]) is called in the second loop in this 
> order, (i.e., inst_rollback followed by alloc_rollback), 
> dst_optsp[option_count - 2] is the first element freed, and 
> dst_opts[option_count - 1] does not get freed, and thus, a memory 
> leak is caused.
> 
> This memory leak can be fixed, by assigning i = option_count (instead of
> option_count - 1).
> 
> Fixes: 80f7c6683fe0 ("team: add support for per-port options")
> Reported-by: syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com
> Tested-by: syzbot+69b804437cfec30deac3@syzkaller.appspotmail.com
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>

Applied and queued up for -stable, thank you.
