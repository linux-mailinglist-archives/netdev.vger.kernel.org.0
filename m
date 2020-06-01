Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421E81EAC7C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbgFAShV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbgFAShQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:37:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4B2C0085C2
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 11:37:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 545D011D53F8B;
        Mon,  1 Jun 2020 11:37:15 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:37:14 -0700 (PDT)
Message-Id: <20200601.113714.711382126517958012.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     jhs@mojatatu.com, Po.Liu@nxp.com, netdev@vger.kernel.org,
        ivecera@redhat.com
Subject: Re: [PATCH net-next] net/sched: fix a couple of splats in the
 error path of tfc_gate_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c0284a5f2d361658f90a9cada05426051e3c490d.1590703192.git.dcaratti@redhat.com>
References: <c0284a5f2d361658f90a9cada05426051e3c490d.1590703192.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:37:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Fri, 29 May 2020 00:05:32 +0200

> trying to configure TC 'act_gate' rules with invalid control actions, the
> following splat can be observed:
> 
>  general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
>  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>  CPU: 1 PID: 2143 Comm: tc Not tainted 5.7.0-rc6+ #168
>  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
>  RIP: 0010:hrtimer_active+0x56/0x290
>  [...]
>   Call Trace:
>   hrtimer_try_to_cancel+0x6d/0x330
 ...
> this is caused by hrtimer_cancel(), running before hrtimer_init(). Fix it
> ensuring to call hrtimer_cancel() only if clockid is valid, and the timer
> has been initialized. After fixing this splat, the same error path causes
> another problem:
> 
>  general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
>  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>  CPU: 1 PID: 980 Comm: tc Not tainted 5.7.0-rc6+ #168
>  Hardware name: Red Hat KVM, BIOS 1.11.1-4.module+el8.1.0+4066+0f1aadab 04/01/2014
>  RIP: 0010:release_entry_list+0x4a/0x240 [act_gate]
>  [...]
>  Call Trace:
>   tcf_action_cleanup+0x58/0x170
  ...
> the problem is similar: tcf_action_cleanup() was trying to release a list
> without initializing it first. Ensure that INIT_LIST_HEAD() is called for
> every newly created 'act_gate' action, same as what was done to 'act_ife'
> with commit 44c23d71599f ("net/sched: act_ife: initalize ife->metalist
> earlier").
> 
> Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")
> CC: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, thanks.
