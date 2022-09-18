Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCE35BBE45
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 16:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIROLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 10:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiIROLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 10:11:32 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D217A9D;
        Sun, 18 Sep 2022 07:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bwmvJwxPeNYhJEAaFgEWNBX/KyHgDekYx6WCRbaGWM0=; b=KZIkD3cmZfcEiXmABlPjjaLiDb
        bJNCdA+1Q7QBMN9nFMUF1H65lNIZlsbpgHyFW5q4VwWHXYhYbxMez0r/7aGSVr9Mkja8EO8MWEeQj
        lrjejbImGizBzW+8AgwyGLN4sifu6bi7V+tm3s55Fxmk2AK/+8MIuSfEy9CqMADv36A3TsLYZen9N
        KDoIEGQoTK5GSQTRFs8z9adomivJAtykmQZbdkrSrCI3Wd5/XkK4ejy4ayTqK2ESRa9XWRhsuVkoj
        okKLPL03XBWw1PbW0w+MsrxIcrcH/Fbb839uUfQTMb4OfciqtWsH6enCr3/CvRYrUbfVntwIzJFeZ
        OauP3Qdg==;
Received: from 201-27-35-168.dsl.telesp.net.br ([201.27.35.168] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oZv0s-0081ni-U0; Sun, 18 Sep 2022 16:11:15 +0200
Message-ID: <742d2a7e-efee-e212-178e-ba642ec94e2a@igalia.com>
Date:   Sun, 18 Sep 2022 11:10:47 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH V3 08/11] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
To:     bhe@redhat.com, kexec@lists.infradead.org,
        Dinh Nguyen <dinguyen@kernel.org>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        bp@alien8.de
Cc:     pmladek@suse.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, xuqiang36@huawei.com
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-9-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-9-gpiccoli@igalia.com>
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
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Acked-by: Dinh Nguyen <dinguyen@kernel.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V3:
> - added the ack tag from Dinh - thanks!
> - had a good discussion with Boris about that in V2 [0],
> hopefully we can continue and reach a consensus in this V3.
> [0] https://lore.kernel.org/lkml/46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com/
> 
> V2:
> - new patch, based on the discussion in [1].
> [1] https://lore.kernel.org/lkml/62a63fc2-346f-f375-043a-fa21385279df@igalia.com/
> 
> [...]

Hi Dinh, Tony, Boris - sorry for the ping.

Appreciate reviews on this one - Dinh already ACKed the patch but Boris
raised some points in the past version [0], so any opinions or
discussions are welcome!

Thanks,


Guilherme


[0]
https://lore.kernel.org/lkml/46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com/
