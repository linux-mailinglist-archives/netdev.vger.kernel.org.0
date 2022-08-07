Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4BE58BBA1
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 17:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbiHGPk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 11:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiHGPkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 11:40:55 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB70C2B6;
        Sun,  7 Aug 2022 08:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EeHU4GZXVj90knDikrlAT10biCMpyNXIYZ492gpol+s=; b=jTZwpdmqF3XqT8+jXcqJ6GDFfR
        PxnNT9XP3iA6r1cpYT4naEjxoD1tQX74wR8OAHAzp4CWvIkUUkXUzYyPpkKOsRZgMPMZuj+5p9GP5
        Uw+94dj89kf/Asj9KY/mmNEWmmuztrKLfjkVD+LCYmsivYiVInFYT5MGBGMuBVpvYugBCTdchUYEQ
        ImktElUtqotBACvuRTFHL+/dDdRHwC/8jiRfWah9yozq3liIWlUuEtoQZJ/VY7HdyfEnnTxbzO83/
        LCdttDLGKkVuGz+YQ5BtaCwEcn0V66rebK0UlFyTqj14kGGsiwbRWjWNC8o/7n2KQbG/yLybOl0Fs
        uxYlg8sw==;
Received: from [187.56.70.103] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oKiOP-0011og-UI; Sun, 07 Aug 2022 17:40:42 +0200
Message-ID: <5bbc4296-4858-d01c-0c76-09d942377ddf@igalia.com>
Date:   Sun, 7 Aug 2022 12:40:17 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 06/13] um: Improve panic notifiers consistency and
 ordering
Content-Language: en-US
To:     kexec@lists.infradead.org, linux-um@lists.infradead.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     pmladek@suse.com, bhe@redhat.com, akpm@linux-foundation.org,
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
        will@kernel.org, Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-7-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220719195325.402745-7-gpiccoli@igalia.com>
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
> Currently the panic notifiers from user mode linux don't follow
> the convention for most of the other notifiers present in the
> kernel (indentation, priority setting, numeric return).
> More important, the priorities could be improved, since it's a
> special case (userspace), hence we could run the notifiers earlier;
> user mode linux shouldn't care much with other panic notifiers but
> the ordering among the mconsole and arch notifier is important,
> given that the arch one effectively triggers a core dump.
> 
> Fix that by running the mconsole notifier as the first panic
> notifier, followed by the architecture one (that coredumps).
> 
> Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Richard Weinberger <richard@nod.at>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V2:
> - Kept the notifier header to avoid implicit usage - thanks
> Johannes for the suggestion!
> 
>  arch/um/drivers/mconsole_kern.c | 7 +++----
>  arch/um/kernel/um_arch.c        | 8 ++++----
>  2 files changed, 7 insertions(+), 8 deletions(-)
> [...]

Hi Johannes, do you feel this one is good now, after your last review?
Thanks in advance,


Guilherme
