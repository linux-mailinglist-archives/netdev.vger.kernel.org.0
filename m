Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D212F1D429E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 03:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgEOBBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 21:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726170AbgEOBBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 21:01:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4FCC061A0C;
        Thu, 14 May 2020 18:01:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CA3CD14DD553C;
        Thu, 14 May 2020 18:01:32 -0700 (PDT)
Date:   Thu, 14 May 2020 18:01:32 -0700 (PDT)
Message-Id: <20200514.180132.1153550322947224128.davem@davemloft.net>
To:     frextrite@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        kaber@trash.net, sfr@canb.auug.org.au, cai@lca.pw,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        joel@joelfernandes.org, madhuparnabhowmik10@gmail.com,
        paulmck@kernel.org,
        syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2 2/2] ipmr: Add lockdep expression to
 ipmr_for_each_table macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514180102.26425-2-frextrite@gmail.com>
References: <20200514180102.26425-1-frextrite@gmail.com>
        <20200514180102.26425-2-frextrite@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 18:01:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amol Grover <frextrite@gmail.com>
Date: Thu, 14 May 2020 23:31:03 +0530

> During the initialization process, ipmr_new_table() is called
> to create new tables which in turn calls ipmr_get_table() which
> traverses net->ipv4.mr_tables without holding the writer lock.
> However, this is safe to do so as no tables exist at this time.
> Hence add a suitable lockdep expression to silence the following
> false-positive warning:
> 
> =============================
> WARNING: suspicious RCU usage
> 5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
> -----------------------------
> net/ipv4/ipmr.c:136 RCU-list traversed in non-reader section!!
> 
> ipmr_get_table+0x130/0x160 net/ipv4/ipmr.c:136
> ipmr_new_table net/ipv4/ipmr.c:403 [inline]
> ipmr_rules_init net/ipv4/ipmr.c:248 [inline]
> ipmr_net_init+0x133/0x430 net/ipv4/ipmr.c:3089
> 
> Fixes: f0ad0860d01e ("ipv4: ipmr: support multiple tables")
> Reported-by: syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Amol Grover <frextrite@gmail.com>

Applied.
