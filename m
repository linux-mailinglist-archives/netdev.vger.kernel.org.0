Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D6D59780A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241919AbiHQUaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241546AbiHQUaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:30:11 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B158CA98D3;
        Wed, 17 Aug 2022 13:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gmQnAmGV0yJc75So19A4rCEM0sxOrtpi2lPtl/yZEKg=; b=JbxSHZNkdEfXBjQmNN5rGI/OwF
        aDS9BIivkV6Mz0U7oNRPgqlNWDVZdLBMvEK4or9u9F8CpZ5/lmyGvOdyHUqzk4Kh84BZ1Ai2cRMRD
        vRNg+I2f2MTS9wNKgf2+L1eylZSYzBG8FVmKwjEVZr3Abn8CZwSze+D2Mc3LB6zWfML8DYXrq/ZGT
        1/olIIKBFpL2TAcYS/ecLPQiAHkbNzplNDHKUFna7C8OmeLHDWlIf+QXwfuHY4TWlgfiCPbeUINau
        SS3JJRVVPRad1gggN43ntHtkqkkToLbF5W+SUlu4GnmHAFHo3SXxacXlIAjO3QLNNZ2MpkOMtU/L6
        RAAUvXTA==;
Received: from [179.232.144.59] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oOPfe-00AvIf-BO; Wed, 17 Aug 2022 22:29:46 +0200
Message-ID: <7f016d7f-a546-a45d-c65c-bc35269b4faa@igalia.com>
Date:   Wed, 17 Aug 2022 17:28:34 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 10/13] EDAC/altera: Skip the panic notifier if kdump is
 loaded
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
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
        will@kernel.org, linux-edac@vger.kernel.org,
        Dinh Nguyen <dinguyen@kernel.org>,
        Tony Luck <tony.luck@intel.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-11-gpiccoli@igalia.com> <Yv0mCY04heUXsGiC@zn.tnic>
 <46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com> <Yv1C0Y25u2IB7PCs@zn.tnic>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Yv1C0Y25u2IB7PCs@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2022 16:34, Borislav Petkov wrote:
> [...]
> 
> What is "the failure risk for kdump"?
> 
> Some of the notifiers which run before kdump might fail and thus prevent
> the machine from kdumping?
>

Exactly; some notifiers could break the machine and prevent a successful
kdump. The EDAC one is consider medium risk, due to invasive operations
(register readings on panic situation).


> [...] 
> My question stands: if kdump is loaded and the s10_edac_dberr_handler()
> does not read the the fatal errors and they don't get shown in dmesg
> before the machine panics, how do you intend to show that information to
> the user?
> 
> Because fatal errors are something you absolutely wanna show, at least,
> in dmesg!
> 
> I don't think you can "read" the errors from vmcore - they need to be
> read from the hw registers before the machine dies.
> 

My understanding is the same as yours, i.e., this is not possible to
collect from vmcore, it requires register reading. But again: if you
kdump your machine today, you won't collect this information, patch
changed nothing in that regard.

The one thing it changes is that you'd skip the altera register dump if
kdump is set AND you managed to also set "crash_kexec_post_notifiers".

In case you / Dinh / Tony disagrees with the patch, it's fine and we can
discard it, but then this notifier couldn't run early in the refactor we
are doing, it'd postponed to run later. This are is full of trade-offs,
we just need to choose what compromise solution is preferred by the
majority of developers =)

Cheers,


Guilherme
