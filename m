Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17758BBAF
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 17:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235066AbiHGPtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 11:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiHGPtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 11:49:08 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076FB95AB;
        Sun,  7 Aug 2022 08:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a5evKL0dxZts3vCV7sxGwPKkDHYfYVKHor4w3PAWq2c=; b=UgGUADWMWMdDX5W8sGGx3nbKJG
        AyM7ZqrY3yIDLwhLgALxOOJOECEOo5OQS5ih+S5YxzxuCBHGQDtjqOYnfuVd1QY/S0lbrTrxNFHpY
        Bro6Oe1QYCxHOwwuzSAMX9Ztw5K7CMBYUdkIG4k00taEVXehekd48/vX2B4Tt3rHc5cAKZ2ZdZyIq
        B0LQrO9dG7ieDm45SHEcp8eQHM3Q1AUmE1kS6N6hBmg2Dp3Fd5IgZJvoAIKWK9M8w/IR4wZ/aAAbo
        voQpoRP6X3DitgWapEOWxQp3OQv+ZQuNJbfakbxcntbmu5bBXwSsbnb9bgbIrl6WxIGEm7EI/J0Kt
        EqMN83vA==;
Received: from [187.56.70.103] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oKiWT-001239-V7; Sun, 07 Aug 2022 17:49:02 +0200
Message-ID: <612c2d54-59db-9d2c-cea3-2ffcfcaffec9@igalia.com>
Date:   Sun, 7 Aug 2022 12:48:36 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 10/13] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
To:     kexec@lists.infradead.org, Tony Luck <tony.luck@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>, linux-edac@vger.kernel.org
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
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
        will@kernel.org, pmladek@suse.com
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-11-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220719195325.402745-11-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/07/2022 16:53, Guilherme G. Piccoli wrote:
> The altera_edac panic notifier performs some data collection with
> regards errors detected; such code relies in the regmap layer to
> perform reads/writes, so the code is abstracted and there is some
> risk level to execute that, since the panic path runs in atomic
> context, with interrupts/preemption and secondary CPUs disabled.
> 
> Users want the information collected in this panic notifier though,
> so in order to balance the risk/benefit, let's skip the altera panic
> notifier if kdump is loaded. While at it, remove a useless header
> and encompass a macro inside the sole ifdef block it is used.
> 
> Cc: Dinh Nguyen <dinguyen@kernel.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V2:
> - new patch, based on the discussion in [0].
> [0] https://lore.kernel.org/lkml/62a63fc2-346f-f375-043a-fa21385279df@igalia.com/
> 
>  drivers/edac/altera_edac.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> [...]

Hey Tony / Dinh, do you think this patch is good, based on the
discussion we had [0] last iteration?

Thanks in advance,


Guilherme


[0]
https://lore.kernel.org/lkml/599b72f6-76a4-8e6d-5432-56fb1ffd7e0b@igalia.com/
