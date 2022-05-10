Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918765214F8
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbiEJMS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241592AbiEJMSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:18:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE1B244F2E;
        Tue, 10 May 2022 05:14:20 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6756A21B7F;
        Tue, 10 May 2022 12:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652184859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z0qCXGbgchboCgbitrJZObbFnXC/YqP7fhEXmnIw2vY=;
        b=OcxDFXmKKoVdDJUxSKREkD35h3cfh7L/UHzdGP/cbflejeipwrciY4AbOjnQu6DKNCs7aq
        Tea2QFXBj209QcyaHp7BuefH2IIusivsxr3vlgfi6p9lZaMFpVOppWn8lIP/+rweBZrcrm
        +Lwt8IUC7jK6VwI0ouYkElgPt01wPwE=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 552522C141;
        Tue, 10 May 2022 12:14:16 +0000 (UTC)
Date:   Tue, 10 May 2022 14:14:16 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Shile Zhang <shile.zhang@linux.alibaba.com>,
        Wang ShaoBo <bobo.shaobowang@huawei.com>,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: Re: [PATCH 05/30] misc/pvpanic: Convert regular spinlock into
 trylock on panic path
Message-ID: <YnpXGOXicwdy1E6n@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-6-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427224924.592546-6-gpiccoli@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2022-04-27 19:48:59, Guilherme G. Piccoli wrote:
> The pvpanic driver relies on panic notifiers to execute a callback
> on panic event. Such function is executed in atomic context - the
> panic function disables local IRQs, preemption and all other CPUs
> that aren't running the panic code.
> 
> With that said, it's dangerous to use regular spinlocks in such path,
> as introduced by commit b3c0f8774668 ("misc/pvpanic: probe multiple instances").
> This patch fixes that by replacing regular spinlocks with the trylock
> safer approach.

It seems that the lock is used just to manipulating a list. A super
safe solution would be to use the rcu API: rcu_add_rcu() and
list_del_rcu() under rcu_read_lock(). The spin lock will not be
needed and the list will always be valid.

The advantage would be that it will always call members that
were successfully added earlier. That said, I am not familiar
with pvpanic and am not sure if it is worth it.

> It also fixes an old comment (about a long gone framebuffer code) and
> the notifier priority - we should execute hypervisor notifiers early,
> deferring this way the panic action to the hypervisor, as expected by
> the users that are setting up pvpanic.

This should be done in a separate patch. It changes the behavior.
Also there might be a discussion whether it really should be
the maximal priority.

Best Regards,
Petr
