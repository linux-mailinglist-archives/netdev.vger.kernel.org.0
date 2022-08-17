Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C125976CC
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbiHQTff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241506AbiHQTfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:35:20 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60352F10;
        Wed, 17 Aug 2022 12:34:47 -0700 (PDT)
Received: from zn.tnic (p200300ea971b98b0329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:98b0:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4CFEB1EC0230;
        Wed, 17 Aug 2022 21:34:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660764882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1Rh8+/Ir/HWVaSZXutajiwYFkwurpOA/MHY+NMaBjxs=;
        b=Jd1PX9kZRcNSw8+wGtMkcTz1uxwQoiFDMeJcOBbCsfgsS/ppmOJVaFWhACWZBRC8SWFuXf
        dDheftx78DZKMY27r4f2TuqDeOVN1yTvEzhMKxM+xZJ7a3wUIkdjs3yXleorPHPenOphKo
        aWCyAr6mU/8LtCODdObw+jqfRCppjys=
Date:   Wed, 17 Aug 2022 21:34:41 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
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
Subject: Re: [PATCH v2 10/13] EDAC/altera: Skip the panic notifier if kdump
 is loaded
Message-ID: <Yv1C0Y25u2IB7PCs@zn.tnic>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-11-gpiccoli@igalia.com>
 <Yv0mCY04heUXsGiC@zn.tnic>
 <46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 03:45:30PM -0300, Guilherme G. Piccoli wrote:
> But happens that in the refactor we are proposing [0], some notifiers
> should run before the kdump. We are basically putting some ordering in
> the way notifiers are executed, while documenting this properly and with
> the goal of not increasing the failure risk for kdump.

What is "the failure risk for kdump"?

Some of the notifiers which run before kdump might fail and thus prevent
the machine from kdumping?

> This patch is useful so we can bring the altera EDAC notifier to run
> earlier while not increasing the risk on kdump - this operation is a bit
> "delicate" to happen in the panic scenario. The origin of this patch was
> a discussion with Tony/Peter [1], guess we can call it a "compromise
> solution".

My question stands: if kdump is loaded and the s10_edac_dberr_handler()
does not read the the fatal errors and they don't get shown in dmesg
before the machine panics, how do you intend to show that information to
the user?

Because fatal errors are something you absolutely wanna show, at least,
in dmesg!

I don't think you can "read" the errors from vmcore - they need to be
read from the hw registers before the machine dies.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
