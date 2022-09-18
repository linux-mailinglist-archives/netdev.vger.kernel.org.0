Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BD55BC005
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 23:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIRVTu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 18 Sep 2022 17:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIRVTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 17:19:48 -0400
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBC7B4B6;
        Sun, 18 Sep 2022 14:19:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 934C363BBD2F;
        Sun, 18 Sep 2022 23:19:42 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id EXk4oDd9C-bW; Sun, 18 Sep 2022 23:19:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id D20DA63BBD3E;
        Sun, 18 Sep 2022 23:19:41 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id We51_Q0FVBCB; Sun, 18 Sep 2022 23:19:41 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 6825363BBD27;
        Sun, 18 Sep 2022 23:19:41 +0200 (CEST)
Date:   Sun, 18 Sep 2022 23:19:41 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
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
Message-ID: <2087154222.237106.1663535981252.JavaMail.zimbra@nod.at>
In-Reply-To: <1f464f3d-6668-9e05-bcb7-1b419b5373e1@igalia.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com> <20220819221731.480795-5-gpiccoli@igalia.com> <1f464f3d-6668-9e05-bcb7-1b419b5373e1@igalia.com>
Subject: Re: [PATCH V3 04/11] um: Improve panic notifiers consistency and
 ordering
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: Improve panic notifiers consistency and ordering
Thread-Index: fyz9HeboRp6BamGnnqGD9WoCxA8ipw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
> On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
>> Currently the panic notifiers from user mode linux don't follow
>> the convention for most of the other notifiers present in the
>> kernel (indentation, priority setting, numeric return).
>> More important, the priorities could be improved, since it's a
>> special case (userspace), hence we could run the notifiers earlier;
>> user mode linux shouldn't care much with other panic notifiers but
>> the ordering among the mconsole and arch notifier is important,
>> given that the arch one effectively triggers a core dump.
>> 
>> Fix that by running the mconsole notifier as the first panic
>> notifier, followed by the architecture one (that coredumps).
>> 
>> Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
>> Cc: Johannes Berg <johannes@sipsolutions.net>
>> Cc: Richard Weinberger <richard@nod.at>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
>> 
>> V3:
>> - No changes.
>> [...]
> 
> Hi Johannes, sorry for the ping. Do you think you could pick this one?
> Or if you prefer, I can resend it alone (not in the series) - let me
> know your preference.

This patch is on my TODO list.
Just had no chance to test it.

Thanks,
//richard
