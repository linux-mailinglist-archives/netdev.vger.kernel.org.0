Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6221514B04
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 15:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376404AbiD2Nuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 09:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352209AbiD2Nuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 09:50:50 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85220CB031;
        Fri, 29 Apr 2022 06:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C2OEpCl3NbPTnDM8xzX2S4IX9JfHaO7AlvKh6b2mc6o=; b=pqe8NQsff608mhiYOzk5PDnm3n
        SqpJEt2cMOf7fKd9x6EBmHDeHOX5PyCqZaiQd+rsoiJqYRJfq3hy0YC1K+f5G6E1EYGyBkHkky/4o
        A4sr1jLh/ZiZsTRb8VvM35RQhf4WjzvO8x5RrxtfBf8C8C5PVdUgz7Ik51+zFewe+U63oi8LhMtjA
        jsMfNQ3e75qfSDrR+BCOQg4pDZsV5C5nFo1cAeFeQ7vSqL72QRCGkkh8ptmyZp43zUawgc2bKvA+V
        5dpGhl6WFgQXUob6WnQm5VHnfuqrvgLJ/w/gTZOEZRu0JtLeyWnhBKRg4Xfo6FA1ZDb4qCsQBNlya
        WoHGALzQ==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nkQxe-0007JF-GW; Fri, 29 Apr 2022 15:47:06 +0200
Message-ID: <832eecc5-9569-1d95-6ab8-f029b660dfcb@igalia.com>
Date:   Fri, 29 Apr 2022 10:46:35 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 17/30] tracing: Improve panic/die notifiers
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
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
        paulmck@kernel.org, peterz@infradead.org, senozhatsky@chromium.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, vgoyal@redhat.com,
        vkuznets@redhat.com, will@kernel.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-18-gpiccoli@igalia.com>
 <b8771b37-01f5-f50b-dbb3-9db4ee26e67e@gmail.com>
 <20220429092351.10bca4dd@gandalf.local.home>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220429092351.10bca4dd@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2022 10:23, Steven Rostedt wrote:
> On Fri, 29 Apr 2022 12:22:44 +0300
> Sergei Shtylyov <sergei.shtylyov@gmail.com> wrote:
> 
>>> +	switch (ev) {
>>> +	case DIE_OOPS:
>>> +		do_dump = 1;
>>> +		break;
>>> +	case PANIC_NOTIFIER:
>>> +		do_dump = 1;
>>> +		break;  
>>
>>    Why not:
>>
>> 	case DIE_OOPS:
>> 	case PANIC_NOTIFIER:
>> 		do_dump = 1;
>> 		break;
> 
> Agreed.
> 
> Other than that.
> 
> Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> 
> -- Steve

Thanks Sergei and Steven, good idea! I thought about the switch change
you propose, but I confess I got a bit confused by the "fallthrough"
keyword - do I need to use it?

About the s/int/bool, for sure! Not sure why I didn't use bool at
first...heheh

Cheers,


Guilherme
