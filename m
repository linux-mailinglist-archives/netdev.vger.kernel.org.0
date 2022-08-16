Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E42059638E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237373AbiHPUNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237217AbiHPUNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:13:38 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9729551A20;
        Tue, 16 Aug 2022 13:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cIS73AGgJyieKU1tG/xZQvCqq8exnfGqB4TcWuZRJMk=; b=FkEUF2DP0ATjqek0UTg5E6KGpT
        SfZHe9fW2AONVfJAs/8IfzSTsTd9mdeX2lP+zLryIK+TSwQT+1+SxpL5mIvnqGUU7sIH02Ajg7mVy
        cq1l1k1lYSy/25TQp7wwpcyxMc/YnIrMfrkKANHUcMLPcvZWHteIFmJXOTqw+Xz+452175GKpCp65
        /o2iXSY0BqlMZDZ7rp14XcPmzP2uND+NNI5OzXGp5sTt1G5pHbYuWtYW1u5NTx0LKMb3euFHrYekU
        8GMjSivYRkcl6vjcbMV/VqJ5/blLDgs51BUCiyMhb+/tIiagsNphS1KpAJiMWO+NA6QVVx5/mrtdN
        nWdCvytQ==;
Received: from [179.232.144.59] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oO2vr-00AHjX-Kj; Tue, 16 Aug 2022 22:12:59 +0200
Message-ID: <7181a47b-001c-0588-4102-1cfd8bead0ac@igalia.com>
Date:   Tue, 16 Aug 2022 17:12:33 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 08/13] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
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
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Sergei Shtylyov <sergei.shtylyov@gmail.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-9-gpiccoli@igalia.com>
 <20220816101445.184ebb7c@gandalf.local.home>
 <YvuwUAGi6PvY5kmR@rowland.harvard.edu>
 <20220816115249.66cf8f15@gandalf.local.home>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220816115249.66cf8f15@gandalf.local.home>
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

On 16/08/2022 12:52, Steven Rostedt wrote:
> On Tue, 16 Aug 2022 10:57:20 -0400
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
>>> static int trace_die_panic_handler(struct notifier_block *self,
>>> 				unsigned long ev, void *unused)
>>> {
>>> 	if (!ftrace_dump_on_oops)
>>> 		return NOTIFY_DONE;
>>>
>>> 	/* The die notifier requires DIE_OOPS to trigger */
>>> 	if (self == &trace_die_notifier && ev != DIE_OOPS)
>>> 		return NOTIFY_DONE;
>>>
>>> 	ftrace_dump(ftrace_dump_on_oops);
>>>
>>> 	return NOTIFY_DONE;
>>> }  
>>
>> Or better yet:
>>
>> 	if (ftrace_dump_on_oops) {
>>
>> 		/* The die notifier requires DIE_OOPS to trigger */
>> 		if (self != &trace_die_notifier || ev == DIE_OOPS)
>> 			ftrace_dump(ftrace_dump_on_oops);
>> 	}
>> 	return NOTIFY_DONE;
>>
> 
> That may be more consolidated but less easy to read and follow. This is far
> from a fast path.
> 
> As I maintain this bike-shed, I prefer the one I suggested ;-)
> 
> -- Steve

Perfect Steve and Alan, appreciate your suggestions!
I'll submit V3 using your change Steve - honestly, I'm not sure why in
the heck I put a goto there, yours is basically the same code, modulo
the goto heheh

A braino from me, for sure!
Cheers,


Guilherme
