Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C5D51FFEF
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 16:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbiEIO3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 10:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237151AbiEIO3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 10:29:39 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ADB15700;
        Mon,  9 May 2022 07:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P7ItdBTC+KXB0aqEwbSMXisX2R2Wb9V+tpF+BUJ3fMQ=; b=afqWOj15+1L7ZOehgz4TDp3T9b
        MarVdwm0LTk8+i9B4YSy7xFp7vHwG1/w4WbfDff1U5lUjMxS0vk2DRuV0fJ7wbVLLeaMw89VjYM5x
        WVJwpPzVyva0X5NmUi/i4nuSyMS2YeO8WasLcgi1Y8xImc6fOPpwaaWR9ocIpTn6nZEFaqdopezXx
        OHjXA1hjw9QuPDRbTOoKOwl5vTqszrquVcmDp1xGYYzEdEOTzOi8SiNmSxJjEIE9o/SJMrBbQG4MO
        b+UdR8rUhoog9dM2StftHOG35g7VaJwxTPUyd5VBoTJ128N6lfMi0IgW+WU1FzuWQA7pga9h2J0Nf
        78MmVTaA==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1no4KQ-000BPa-6C; Mon, 09 May 2022 16:25:38 +0200
Message-ID: <260dccd8-a4f6-882c-8767-5bc27576df14@igalia.com>
Date:   Mon, 9 May 2022 11:25:06 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 24/30] panic: Refactor the panic path
Content-Language: en-US
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, bhe@redhat.com,
        akpm@linux-foundation.org, bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        kexec@lists.infradead.org, linux-edac@vger.kernel.org,
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
        will@kernel.org, pmladek@suse.com
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
 <4fe85e9c-4e96-e9d5-9fd8-f062bafcda4f@infradead.org>
 <7518924e-5bb4-e6e9-0e3e-3f5cb03bf946@igalia.com>
In-Reply-To: <7518924e-5bb4-e6e9-0e3e-3f5cb03bf946@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2022 13:04, Guilherme G. Piccoli wrote:
> On 27/04/2022 21:28, Randy Dunlap wrote:
>>
>>
>> On 4/27/22 15:49, Guilherme G. Piccoli wrote:
>>> +	crash_kexec_post_notifiers
>>> +			This was DEPRECATED - users should always prefer the
>>
>> 			This is DEPRECATED - users should always prefer the
>>
>>> +			parameter "panic_notifiers_level" - check its entry
>>> +			in this documentation for details on how it works.
>>> +			Setting this parameter is exactly the same as setting
>>> +			"panic_notifiers_level=4".
>>
> 
> Thanks Randy, for your suggestion - but I confess I couldn't understand
> it properly. It's related to spaces/tabs, right? What you suggest me to
> change in this formatting? Just by looking the email I can't parse.
> 
> Cheers,
> 
> 
> Guilherme

Complete lack of attention from me, apologies!
The suggestions was s/was/is - already fixed for V2, thanks Randy.
