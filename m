Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A1F5BBE37
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 16:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiIROBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 10:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiIROBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 10:01:22 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E82E23BDA;
        Sun, 18 Sep 2022 07:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FD364ic7hwXbBNt0PyaEumKr+hXe/YHVGpj8xZwTcQc=; b=LlJa5ekJMCr4ru1VcgID5m7osa
        sLReM65mKivTkd/sK2WTXhur5XEJw1doYWDdqyLwUwo9WilGxBB5RPqM/K9n1LmBw//7tRDRDYHNL
        zBZL5uY3ffn3ONsHRNzqHIdmAudHZ3JULNK/FZzyEjmdWgSMxmej9U9tOy+kTr0D/SNLspstDV9uE
        7duwV8HQMtQv/TRS2hckPyWHujWlXVG3pgS90S7tcx39nUs9ztQL/9eeB2XhyUk4MygBAJAPeMa1+
        4IvXfsOdBUP4e73JwGJoGCQ7Yyn2xI+u8FSLn1a2kZnqfZO3GvPJatuV5CKnUsiACriLunll6O4i/
        2x0W5XsA==;
Received: from 201-27-35-168.dsl.telesp.net.br ([201.27.35.168] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oZur6-0080lc-Gi; Sun, 18 Sep 2022 16:01:08 +0200
Message-ID: <1f464f3d-6668-9e05-bcb7-1b419b5373e1@igalia.com>
Date:   Sun, 18 Sep 2022 11:00:36 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH V3 04/11] um: Improve panic notifiers consistency and
 ordering
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-um@lists.infradead.org
Cc:     kexec@lists.infradead.org, bhe@redhat.com, pmladek@suse.com,
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
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, xuqiang36@huawei.com,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-5-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-5-gpiccoli@igalia.com>
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
> V3:
> - No changes.
> [...]

Hi Johannes, sorry for the ping. Do you think you could pick this one?
Or if you prefer, I can resend it alone (not in the series) - let me
know your preference.

Thanks,


Guilherme
