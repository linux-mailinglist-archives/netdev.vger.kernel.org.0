Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDE86010AD
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiJQOCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJQOCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:02:03 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBB21B7AB;
        Mon, 17 Oct 2022 07:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:
        Cc:To:From:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ccNFH8oqnQs0DDOD5l2+8QhyjoRsBFYdAqg8ytBphUI=; b=oE8vLPxK9isTmTE8r4fCiWVZlM
        TSNd9Ttokv0OcU3WpogrEnpqMIWo+btpSQYm68i5MqeSBOMeZ7f2gncGNjZ0dDeAMMZ28t74kFs1u
        Lq5hpJIPPTUyIrSMVtIjdRbEyw/8fYk3tk3ER+LXa3TdMdN3C9+CkioZGRdlG2g6y4SGAi1fqeM8n
        RIy3TKQNMSvTdf2SqdIJiGP0NHPGnZRm6HGEP6QUMwkXhHHu7P+hKyzOlHtoa074vR1nG6aF6zMYV
        9090sDEKredFKyak5RKp67fKgmkBez06Tbvnnz7dhNsszQvdw5sfkzkqlkeQKYVpW/CjJRlWMBncz
        Dp4bVR5g==;
Received: from [179.113.159.85] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1okQg7-000Nwb-57; Mon, 17 Oct 2022 16:01:15 +0200
Message-ID: <8e30b99e-70ed-7d5a-ea1f-3b0fadb644bc@igalia.com>
Date:   Mon, 17 Oct 2022 11:00:46 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 01/11] ARM: Disable FIQs (but not IRQs) on CPUs
 shutdown paths
Content-Language: en-US
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     Russell King <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        Mark Rutland <mark.rutland@arm.com>, arnd@arndb.de,
        Catalin Marinas <catalin.marinas@arm.com>
Cc:     kexec@lists.infradead.org, pmladek@suse.com, bhe@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        bp@alien8.de, corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        xuqiang36@huawei.com
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-2-gpiccoli@igalia.com>
 <a25cb242-7c85-867c-8a61-f3119458dcdb@igalia.com>
In-Reply-To: <a25cb242-7c85-867c-8a61-f3119458dcdb@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2022 10:58, Guilherme G. Piccoli wrote:
> On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
>> Currently the regular CPU shutdown path for ARM disables IRQs/FIQs
>> in the secondary CPUs - smp_send_stop() calls ipi_cpu_stop(), which
>> is responsible for that. IRQs are architecturally masked when we
>> take an interrupt, but FIQs are high priority than IRQs, hence they
>> aren't masked. With that said, it makes sense to disable FIQs here,
>> but there's no need for (re-)disabling IRQs.
>>
>> More than that: there is an alternative path for disabling CPUs,
>> in the form of function crash_smp_send_stop(), which is used for
>> kexec/panic path. This function relies on a SMP call that also
>> triggers a busy-wait loop [at machine_crash_nonpanic_core()], but
>> without disabling FIQs. This might lead to odd scenarios, like
>> early interrupts in the boot of kexec'd kernel or even interrupts
>> in secondary "disabled" CPUs while the main one still works in the
>> panic path and assumes all secondary CPUs are (really!) off.
>>
>> So, let's disable FIQs in both paths and *not* disable IRQs a second
>> time, since they are already masked in both paths by the architecture.
>> This way, we keep both CPU quiesce paths consistent and safe.
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Michael Kelley <mikelley@microsoft.com>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>>

Monthly ping - let me know if there's something I should improve in
order this fix is considered!
Thanks,


Guilherme
