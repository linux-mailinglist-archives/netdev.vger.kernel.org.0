Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641CA60118F
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiJQOvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiJQOvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:51:09 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A717646;
        Mon, 17 Oct 2022 07:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I1MpaAbkW7CW2LdnpSm0D4JwlK8M3EbCbskCUKD/uAY=; b=lohghzi2k0QqQVyjLNq0bc4o0m
        NCkzwMUbdxqzik4IN3M5keVtRoVgtf4l71zXCgDSrVBM4F2u3lQgc+F7uRv6WX+r/KApspKI/djd9
        vzAKtI/wKHAzep6erHIGdDFNlK+Bdksge0TFtzLv/ItpRPr4wgRnK7Hd+Crid3cxHPgjE3xfRUqd/
        dTbw4SPq4CzcR1JtpQaqTS4ZDk3QFObYTfxmeDW67n3vcQ+MQAHk8x5j1sm7HXZLlkVQcHxlTj5LE
        UxngAIIEJ2vb46NbAl34RIxdrSeaSNn+m5MN9fi+eZ5tN6W0Nds5MwnQoshNvMC09KOqi3Jwosgwx
        CVk4xj5w==;
Received: from [179.113.159.85] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1okRRo-000QS8-Tl; Mon, 17 Oct 2022 16:50:32 +0200
Message-ID: <aea7dad7-987d-43ad-3abc-815ede97a127@igalia.com>
Date:   Mon, 17 Oct 2022 11:50:05 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 01/11] ARM: Disable FIQs (but not IRQs) on CPUs
 shutdown paths
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc:     Marc Zyngier <maz@kernel.org>, will@kernel.org,
        Mark Rutland <mark.rutland@arm.com>, arnd@arndb.de,
        Catalin Marinas <catalin.marinas@arm.com>,
        kexec@lists.infradead.org, pmladek@suse.com, bhe@redhat.com,
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
 <8e30b99e-70ed-7d5a-ea1f-3b0fadb644bc@igalia.com>
 <Y01j/3qKUvj346AH@shell.armlinux.org.uk>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Y01j/3qKUvj346AH@shell.armlinux.org.uk>
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

On 17/10/2022 11:17, Russell King (Oracle) wrote:
> [...]
>> Monthly ping - let me know if there's something I should improve in
>> order this fix is considered!
> 
> Patches don't get applied unless they end up in the patch system.
> Thanks.
> 

Thanks Russell! Can you show me some documentation on how should I send
the patches to this patch system? My understanding based in the
MAINTAINERS file is that we should send the arm32 patches to you + arm ML.

Cheers,


Guilherme
