Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C7858BBA7
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 17:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbiHGPqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 11:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiHGPqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 11:46:39 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBC095AC;
        Sun,  7 Aug 2022 08:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QTm0Fa5NeO4gV5vsXv44jv3ky+1FUP2v92+IAnY2Isk=; b=ZfGufmrMNpOaMMyfdbmknIovK0
        9A5ObDAO9/kVZt1QjWBzJY3Q5sGqgh8UyJfw7KQdIsFchs3Si5FjA7eQcSCo71vIV8fzSTuBpos5/
        NOCpj/xDga4jklJZ6Lgzz8epXtBC4P6bQfRPlPAYAdU9Cp2CuyIFnlkGYjAz3KmloqV65NScgB0Ju
        TjetD1WQmN1+2iD4Khd9Ije00UbMDoRdQWt3mnIgZQgPooY75UmIiVZipdhv4IfTIojgTwiRpCSKh
        cBpFqFREyvjGzwNZhn7R2QUuxnXXbqIjxRNXOqh19IC1a7TrE/r+H/TTqGAX6SO61pBm/FROU7Fg3
        B21CCzSw==;
Received: from [187.56.70.103] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oKiU1-0011yy-S9; Sun, 07 Aug 2022 17:46:29 +0200
Message-ID: <ff7a314e-c9f9-bb28-7a33-0a884188c530@igalia.com>
Date:   Sun, 7 Aug 2022 12:46:03 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 08/13] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     kexec@lists.infradead.org, rostedt@goodmis.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     pmladek@suse.com, bhe@redhat.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
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
        vkuznets@redhat.com, will@kernel.org, akpm@linux-foundation.org
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-9-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220719195325.402745-9-gpiccoli@igalia.com>
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
> Currently the tracing dump_on_oops feature is implemented
> through separate notifiers, one for die/oops and the other
> for panic - given they have the same functionality, let's
> unify them.
> 
> Also improve the function comment and change the priority of
> the notifier to make it execute earlier, avoiding showing useless
> trace data (like the callback names for the other notifiers);
> finally, we also removed an unnecessary header inclusion.
> 
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V2:
> - Different approach; instead of using IDs to distinguish die and
> panic events, rely on address comparison like other notifiers do
> and as per Petr's suggestion;
> 
> - Removed ACK from Steven since the code changed.
> 
>  kernel/trace/trace.c | 55 ++++++++++++++++++++++----------------------
>  1 file changed, 27 insertions(+), 28 deletions(-)
> [...]

Hi Sergei / Steve, do you think this version is good now, after your
last round of reviews?

Thanks,


Guilherme
