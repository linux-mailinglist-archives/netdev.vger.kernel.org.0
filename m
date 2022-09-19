Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361C15BCAFE
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiISLpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiISLpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:45:33 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052822B1B0;
        Mon, 19 Sep 2022 04:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GxfdWPuLABxwYJIT88xFUUCj5wo8pfXkTG/17KzqeUg=; b=CtjlHykkP4NGTdywejLjeGM9bN
        0/1oQYfhqVBTzgBzg3M9Huv0Wg9HWAbOh0JGVQIyFudQEr5SUL55eMORwJuW3U5+r7lypVcKD5eNr
        dhYwm//WEP6Z0dZrLR6ioUw3qdnkSsCQlbDfoAei07RrqLFWg+7MBqaPf+Kd7H7GDwAxvkjGcXfBM
        WbO7g4MuCb9ObY/ejkeF3hiEC6dZFTXKFAkoPRDDGuv4wNL0rtRd6TdWv5lWp8xFIbT7iMDUTrWPM
        6F9Pa9N/PZhbvUCXOIbg81gNMMmpYs7mXvpus1OGlMBXlw9rVX2vFFZVfkK2oKDEibanippweAPRg
        Dc8X0ygQ==;
Received: from 201-27-35-168.dsl.telesp.net.br ([201.27.35.168] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oaFCl-009ial-Py; Mon, 19 Sep 2022 13:44:51 +0200
Message-ID: <11701672-998b-4292-6885-8ac26e16478e@igalia.com>
Date:   Mon, 19 Sep 2022 08:44:21 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH V3 04/11] um: Improve panic notifiers consistency and
 ordering
Content-Language: en-US
To:     Richard Weinberger <richard@nod.at>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-um <linux-um@lists.infradead.org>,
        kexec@lists.infradead.org, bhe@redhat.com,
        Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        x86 <x86@kernel.org>, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro j jimenez <alejandro.j.jimenez@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, bp <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>,
        d hatayama <d.hatayama@jp.fujitsu.com>,
        dave hansen <dave.hansen@linux.intel.com>, dyoung@redhat.com,
        feng tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mikelley@microsoft.com,
        hidehiro kawai ez <hidehiro.kawai.ez@hitachi.com>,
        jgross@suse.com, John Ogness <john.ogness@linutronix.de>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>, mhiramat@kernel.org,
        mingo <mingo@redhat.com>, paulmck@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, senozhatsky@chromium.org,
        stern@rowland.harvard.edu, tglx <tglx@linutronix.de>,
        vgoyal@redhat.com, vkuznets@redhat.com, will@kernel.org,
        xuqiang36@huawei.com,
        anton ivanov <anton.ivanov@cambridgegreys.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-5-gpiccoli@igalia.com>
 <1f464f3d-6668-9e05-bcb7-1b419b5373e1@igalia.com>
 <2087154222.237106.1663535981252.JavaMail.zimbra@nod.at>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <2087154222.237106.1663535981252.JavaMail.zimbra@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2022 18:19, Richard Weinberger wrote:
> ----- Ursprüngliche Mail -----
>> Von: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
>> On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
>>> Currently the panic notifiers from user mode linux don't follow
>>> the convention for most of the other notifiers present in the
>>> kernel (indentation, priority setting, numeric return).
>>> More important, the priorities could be improved, since it's a
>>> special case (userspace), hence we could run the notifiers earlier;
>>> user mode linux shouldn't care much with other panic notifiers but
>>> the ordering among the mconsole and arch notifier is important,
>>> given that the arch one effectively triggers a core dump.
>>>
>>> Fix that by running the mconsole notifier as the first panic
>>> notifier, followed by the architecture one (that coredumps).
>>>
>>> Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>>> Cc: Johannes Berg <johannes@sipsolutions.net>
>>> Cc: Richard Weinberger <richard@nod.at>
>>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>>>
>>> V3:
>>> - No changes.
>>> [...]
>>
>> Hi Johannes, sorry for the ping. Do you think you could pick this one?
>> Or if you prefer, I can resend it alone (not in the series) - let me
>> know your preference.
> 
> This patch is on my TODO list.
> Just had no chance to test it.
> 
> Thanks,
> //richard

Thanks a lot Richard!
