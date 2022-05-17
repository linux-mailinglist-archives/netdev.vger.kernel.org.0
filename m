Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72B52A6D4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350141AbiEQPeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347265AbiEQPec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:34:32 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41F24161A;
        Tue, 17 May 2022 08:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H3qrTQv7Tt4PXBVt8796c6Ly9chEP2DhR9UJaIWJhqo=; b=Kd/s+xrChiBK9NaSmFnFXM3RYc
        UbvPwTdgYlS5Qa0rscW/rbtbKNYmUFJYz6cuBPp5A2fzucoID0yV96EUGF05FAOiWz8RXWusO+AHA
        8G50ebt3m708xrBW8WQ3edVZ8TFa1h54Wb9WFcR4fr7CEuRFULxnhNWBP/+YYHyvucLESFjbnRE2j
        n9qbZb3QL+2yKsrt97dJ6Amu5IZoY/oVzVzN5MU2xEsTlE/L+2AbQmiktH83j3MJhKZ0jI46IVrKr
        LNwCY2ghNt9ogJWj8KzB1ejgALFJxydhnjupRBVywOgqfhSwQwo7FdrzyqWruEBFvoxYw8EKWcKt2
        QJUgWtTw==;
Received: from 200-161-159-120.dsl.telesp.net.br ([200.161.159.120] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nqzDK-008cDX-EE; Tue, 17 May 2022 17:34:22 +0200
Message-ID: <31f96f73-46b5-aa6f-a5db-5052c6f3fc92@igalia.com>
Date:   Tue, 17 May 2022 12:33:52 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 17/30] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>, rostedt@goodmis.org
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, senozhatsky@chromium.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, vgoyal@redhat.com,
        vkuznets@redhat.com, will@kernel.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-18-gpiccoli@igalia.com>
 <20220511114541.GC26047@pathway.suse.cz>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220511114541.GC26047@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/05/2022 08:45, Petr Mladek wrote:
> [...]
> DIE_OOPS and PANIC_NOTIFIER are from different enum.
> It feels like comparing apples with oranges here.
> 
> IMHO, the proper way to unify the two notifiers is
> a check of the @self parameter. Something like:
> 
> static int trace_die_panic_handler(struct notifier_block *self,
> 				unsigned long ev, void *unused)
> {
> 	if (self == trace_die_notifier && val != DIE_OOPS)
> 		goto out;
> 
> 	ftrace_dump(ftrace_dump_on_oops);
> out:
> 	return NOTIFY_DONE;
> }
> 
> Best Regards,
> Petr

OK Petr, thanks - will implement your suggestion in V2 (CC Steven)

Cheers!
