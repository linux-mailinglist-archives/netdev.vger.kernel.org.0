Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42B7521CE1
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 16:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345078AbiEJOwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 10:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345246AbiEJOvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 10:51:10 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9574D2631E2;
        Tue, 10 May 2022 07:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vlPcmXA97Qhtkz3pBw6LdXf1X8P0UYvVzj4VthO5jgc=; b=e9qBavzt7iSXqotIL+kEfOWSDC
        iVRppT3Hb/vZk3YrAi/b/1Sks4coJ4CDDP+7PsBf/3PYaPFt1gdo8rsOdKqYQ7smquEWj28eStWqL
        CRF+oqCbuJG6ZM1a8GSMIH+b891MTAxbko/s3bV28TSILNPx0vJS6lKq9Hi1OrpvIOMJ2yAsDH+AE
        5UZLLIZnAX0XkUOFElR9JGQkkK04aCtF/juYrAyo+JJs0W0WZech05pCgMVZEF/gDbG3lXHdR+nlg
        gc7p3pNqQj2cprKtyF3OhhaP7dxC5PNGfWWqohU3giKekM5UQ60wlcwHLGqdoJfnT4tcYUBBcGgto
        etn8qzNQ==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1noQa0-000AUZ-9j; Tue, 10 May 2022 16:11:12 +0200
Message-ID: <58837e3d-0e2a-42ac-f198-9fe7be7aa823@igalia.com>
Date:   Tue, 10 May 2022 11:10:40 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 08/30] powerpc/setup: Refactor/untangle panic notifiers
Content-Language: en-US
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Hari Bathini <hbathini@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        pmladek@suse.com, kexec@lists.infradead.org, bhe@redhat.com,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
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
        will@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, akpm@linux-foundation.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-9-gpiccoli@igalia.com>
 <3c34d8e2-6f84-933f-a4ed-338cd300d6b0@linux.ibm.com>
 <f9c3de3c-1709-a1aa-2ece-c9fbfd5e6d6a@igalia.com>
 <87fslh8pe3.fsf@mpe.ellerman.id.au>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <87fslh8pe3.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2022 10:53, Michael Ellerman wrote:
> "Guilherme G. Piccoli" <gpiccoli@igalia.com> writes:
>> On 05/05/2022 15:55, Hari Bathini wrote:
>>> [...] 
>>> The change looks good. I have tested it on an LPAR (ppc64).
>>>
>>> Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
>>>
>>
>> Hi Michael. do you think it's possible to add this one to powerpc/next
>> (or something like that), or do you prefer a V2 with his tag?
> 
> Ah sorry, I assumed it was going in as part of the whole series. I guess
> I misread the cover letter.
> 
> So you want me to take this patch on its own via the powerpc tree?
> 
> cheers

Hi Michael, thanks for the prompt response!

You didn't misread, that was the plan heh
But some maintainers start to take patches and merge in their trees, and
in the end, it seems to make sense - almost half of this series are
fixes or clean-ups, that are not really necessary to get merged altogether.

So, if you can take this one, I'd appreciate - it'll make V2 a bit
smaller =)

Cheers,


Guilherme
