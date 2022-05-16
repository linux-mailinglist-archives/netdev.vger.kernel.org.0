Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70AB5289EF
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 18:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245753AbiEPQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 12:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234205AbiEPQMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 12:12:06 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB6C3878D;
        Mon, 16 May 2022 09:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OZBRCsaeLLQD9CguIhK5Gsbv+Do9lNI4dRKnX3DnTVs=; b=cTAo65jHTM3B0ITLRt2mTe+qMi
        Mgnedog4ec+puSbe0nyROSa19Q4JMc3jLrINzY75lEJgN4ZnZLbXRnbU9VgE7MZjNWhyf408I+eF0
        UZsTZ4wldMCBZxElXn52I0DKJCfHcNJLOcsxnTRMPLlShL9EHMOqzRahK2vVGGFXB6RnGo8XEEJPO
        gpyhtwCxU0EgZFBR09A8u7wGxD5xH5ep8p3kCFTe8PlGSgTOkVsHijQweIsXqaGaP95QgkavUlo4N
        GY9l6sOGeJeiAc+wGG54Szh2/VK5I4c73G47OXj82SsENDkfCXLscQrlJiBmPFlo290c84ZDH/amA
        F9S82K0A==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nqdK8-006sYA-BV; Mon, 16 May 2022 18:11:56 +0200
Message-ID: <41bede24-2bc4-a85b-9ba0-0f2562f8d0ca@igalia.com>
Date:   Mon, 16 May 2022 13:11:25 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 25/30] panic, printk: Add console flush parameter and
 convert panic_print to a notifier
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>
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
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-26-gpiccoli@igalia.com> <YoJmKYLzPZqCDDim@alley>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YoJmKYLzPZqCDDim@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/05/2022 11:56, Petr Mladek wrote:
> [...]
> I really like both changes. Just please split it them into two
> patchset. I mean one patch for the new "panic_console_replay"
> parameter and 2nd that moves "printk_info" into the notifier.
> 

OK sure, will do that in V2.
Thanks,


Guilherme
