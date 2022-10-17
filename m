Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FC86010B3
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 16:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJQODW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 10:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJQODU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 10:03:20 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA8B12A81;
        Mon, 17 Oct 2022 07:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eElHYxMrmADQuWqD+WDhUZYBtoITxSmUO7MpBXGRkmQ=; b=aqI6CYf/xVNFFzyIlxNvV5AwVY
        M0E3vFyGECKDU83j+JHwZUaQdzRuy+pkdvMC/YJwGGZ3BBefMeqjtTdB9J3/AIdxtCiKRHtxF5Qam
        sgsn3SFqoak/XnT+alKs6GRUVjIdSutfRoVcUOmAp5Oht4grSgwZNF6m8/wgDKweX7cFySVSB0kqX
        hpt0MVh1JsMWahY8Db3dZ6Y7dm8204C1FwZhk76XIF3TUqiWMAs5A5iyo0G/YOi8DJBrA/Vi6GL/m
        CH9tt8cLMM8TrL0iwVMOwiY71A19GZlaTRdM7MWBmb3cg2FaiLF4Pd6ZypZYHoXY1VYddscC/IgCK
        tOlWbeNA==;
Received: from [179.113.159.85] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1okQhy-000OIq-Co; Mon, 17 Oct 2022 16:03:10 +0200
Message-ID: <437dcc56-cdd3-9fee-3a06-d5ba3187eeb6@igalia.com>
Date:   Mon, 17 Oct 2022 11:02:45 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 06/11] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     rostedt@goodmis.org
Cc:     kexec@lists.infradead.org, pmladek@suse.com, bhe@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
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
        vkuznets@redhat.com, will@kernel.org, xuqiang36@huawei.com,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-7-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-7-gpiccoli@igalia.com>
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

On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> Currently the tracing dump_on_oops feature is implemented through
> separate notifiers, one for die/oops and the other for panic;
> given they have the same functionality, let's unify them.
> 
> Also improve the function comment and change the priority of the
> notifier to make it execute earlier, avoiding showing useless trace
> data (like the callback names for the other notifiers); finally,
> we also removed an unnecessary header inclusion.
> 
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V3:
> - Removed goto usage, as per Steven suggestion (thanks!).
> 
> V2:
> - Different approach; instead of using IDs to distinguish die and
> panic events, rely on address comparison like other notifiers do
> and as per Petr's suggestion;
> 
> - Removed ACK from Steven since the code changed.
> 

Hi Steven, apologies for the re-ping. Is there anything else to do in
this one, or do you think it's good enough?

Thanks,


Guilherme
