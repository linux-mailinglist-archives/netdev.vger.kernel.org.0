Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9C359752D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241106AbiHQRcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238004AbiHQRcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:32:04 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A7749B61;
        Wed, 17 Aug 2022 10:32:02 -0700 (PDT)
Received: from zn.tnic (p200300ea971b98b0329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:98b0:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2A7411EC04E4;
        Wed, 17 Aug 2022 19:31:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660757517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=dUKj+X8ljKS3x0J7PLstLS2kOGr7pWVjrGVNsA+POsw=;
        b=OCrRjecizgJkhIrUuxZqNNRqYD/0fFaYs2TDejeDXW/mmrrYLWtuimSo/AnlefpOtU+AMj
        bsL7N758/zQeINPpMpOiI/ASS6nWSKedONPjIH0T9YfOo5o9ytEmycBmsrGT973RrHO3j/
        FA4Bt5FgbzcF1qKWUonHjI/9nn6LXBk=
Date:   Wed, 17 Aug 2022 19:31:53 +0200
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
Message-ID: <Yv0mCY04heUXsGiC@zn.tnic>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-11-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220719195325.402745-11-gpiccoli@igalia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 04:53:23PM -0300, Guilherme G. Piccoli wrote:
> The altera_edac panic notifier performs some data collection with
> regards errors detected; such code relies in the regmap layer to
> perform reads/writes, so the code is abstracted and there is some
> risk level to execute that, since the panic path runs in atomic
> context, with interrupts/preemption and secondary CPUs disabled.
> 
> Users want the information collected in this panic notifier though,
> so in order to balance the risk/benefit, let's skip the altera panic
> notifier if kdump is loaded. While at it, remove a useless header
> and encompass a macro inside the sole ifdef block it is used.

How does the fact that kdump is loaded, obviate the need to print
information about the errors?

Are you suggesting that people who have the whole vmcore would be able
to piece together the error information?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
