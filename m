Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B555BBE48
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 16:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiIROMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 10:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIROMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 10:12:51 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB88C20BE7;
        Sun, 18 Sep 2022 07:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vgMvcabAponECpj7LkBelpsJYBmHvShrlJGOD0sG9pE=; b=TTCkZr67oCPEg4W6TAiKui93RE
        zGjwqVg2v7U28Zq7BmtnJIFeyKD3RT6oaLMZytqo0SmjtEi4xnnUZqEBIbo/sn14Qf049AyKT6vg+
        qUbhrl6Ky7sFlpcv9Vb6f5aUY6b6Bx1pNiCwBOZ8OP0fTxR/8WA7ez8BWfoMquFKgo8U+n+Yf9GPd
        Ma9bQpq2RIHh0j96uScSPjHqUWY76MvQPZs/tqV0JGBh+7TxIEM4PTR3LajWg0nZipmu/MTHquGn4
        HYm5FoWXA1hIeNeFC4M3jrSlTjfoWBmKP+f1HGX54rU4kAEWX4QGbCqjXseT9yyCLWET4dvJcyPXF
        oWj2nxOQ==;
Received: from 201-27-35-168.dsl.telesp.net.br ([201.27.35.168] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oZv2N-0081tk-VV; Sun, 18 Sep 2022 16:12:48 +0200
Message-ID: <89f8fb2d-3f39-4591-190c-f134c4c173a6@igalia.com>
Date:   Sun, 18 Sep 2022 11:12:15 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH V3 09/11] video/hyperv_fb: Avoid taking busy spinlock on
 panic path
Content-Language: en-US
To:     linux-hyperv@vger.kernel.org, mikelley@microsoft.com
Cc:     kexec@lists.infradead.org, pmladek@suse.com, bhe@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        hidehiro.kawai.ez@hitachi.com, jgross@suse.com,
        john.ogness@linutronix.de, keescook@chromium.org, luto@kernel.org,
        mhiramat@kernel.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, xuqiang36@huawei.com,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-10-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-10-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> The Hyper-V framebuffer code registers a panic notifier in order
> to try updating its fbdev if the kernel crashed. The notifier
> callback is straightforward, but it calls the vmbus_sendpacket()
> routine eventually, and such function takes a spinlock for the
> ring buffer operations.
> 
> Panic path runs in atomic context, with local interrupts and
> preemption disabled, and all secondary CPUs shutdown. That said,
> taking a spinlock might cause a lockup if a secondary CPU was
> disabled with such lock taken. Fix it here by checking if the
> ring buffer spinlock is busy on Hyper-V framebuffer panic notifier;
> if so, bail-out avoiding the potential lockup scenario.
> 
> Cc: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Michael Kelley <mikelley@microsoft.com>
> Cc: Stephen Hemminger <sthemmin@microsoft.com>
> Cc: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Tested-by: Fabio A M Martins <fabiomirmar@gmail.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V3:
> - simplified the code based on Michael's suggestion - thanks!
> 
> V2:
> - new patch, based on the discussion in [0].
> [0] https://lore.kernel.org/lkml/2787b476-6366-1c83-db80-0393da417497@igalia.com/
> 
> 
>  drivers/hv/ring_buffer.c        | 13 +++++++++++++
>  drivers/video/fbdev/hyperv_fb.c |  8 +++++++-
>  include/linux/hyperv.h          |  2 ++
>  3 files changed, 22 insertions(+), 1 deletion(-)
> [...]

Hi Michael, apologies for the ping.
Any reviews/comments on this one are greatly appreciated!

Cheers,


Guilherme
