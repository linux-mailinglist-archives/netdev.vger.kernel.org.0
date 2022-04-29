Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E9514DF5
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377801AbiD2Osv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377802AbiD2Osr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:48:47 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B1C7DA8E;
        Fri, 29 Apr 2022 07:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cEz0jvzYMJy/+PnSroZ/Hi6xu9Xg7ihjZ6KqkMsyEVA=; b=TtjJWVYR2YAsPylCOEsPMfdeP3
        uewJTDxZvNwqz8faFaLHrMu4SGCc7XKgfqXs0N9Eqi4GqpadVMfaDxlWZzVPKQLi8ni/s2ddxpu3K
        tP6hsTWVLR98QNCsrf0212qd1xvVl1Ei20QGO6x8V4HGcJkkz3V8HTUpxBZ8YdMeJOhwfqc/a8/uJ
        6uvHWRRLoq8CaJRaw2R8nKQ6rT+OEKWXBb4ItDaXeeq0xIrWs1dLGM6n+SsKoTqhKb432TBldb0L4
        ADdMsHTu5tPPflo8jyg6MaAv6SnfkenTNCGCscDeHdEnB08Cvtm9IbN9EZtdJb4wh68LkWeJPFXS4
        x01q8OQw==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nkRru-0009vz-Hw; Fri, 29 Apr 2022 16:45:14 +0200
Message-ID: <b81cf509-60d5-a733-0b06-374d9c146559@igalia.com>
Date:   Fri, 29 Apr 2022 11:44:43 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 17/30] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
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
 <b8771b37-01f5-f50b-dbb3-9db4ee26e67e@gmail.com>
 <20220429092351.10bca4dd@gandalf.local.home>
 <832eecc5-9569-1d95-6ab8-f029b660dfcb@igalia.com>
 <20220429095654.26d00b79@gandalf.local.home>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220429095654.26d00b79@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2022 10:56, Steven Rostedt wrote:
> [...]
> No. The fallthrough keyword is only needed when there's code between case
> labels. As it is very common to list multiple cases for the same code path.
> That is:
> 
> 	case DIE_OOPS:
>  	case PANIC_NOTIFIER:
>  		do_dump = 1;
>  		break;
> 
> Does not need a fall through label, as there's no code between the DIE_OOPS
> and the PANIC_NOTIFIER. But if you had:
> 
> 	case DIE_OOPS:
> 		x = true;
>  	case PANIC_NOTIFIER:
>  		do_dump = 1;
>  		break;
> 
> Then you do.
> 
> -- Steve

Thanks a bunch for the clarification, changed that for V2 =)
