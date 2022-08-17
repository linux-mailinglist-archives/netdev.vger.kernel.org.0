Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073BF597968
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 00:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241855AbiHQWBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 18:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiHQWBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 18:01:05 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9999F3B963;
        Wed, 17 Aug 2022 15:01:04 -0700 (PDT)
Received: from zn.tnic (p200300ea971b98b0329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971b:98b0:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F29291EC059D;
        Thu, 18 Aug 2022 00:00:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1660773659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nNsL/+Bz+9jQP2JY5PHReXF2fQeFbrG3QS9oS4053lY=;
        b=EcytJ926HTqKY6iSYbZ9VBuyvlaElspGvROa+w6sC6qpg+gnuk202m0ev0QQX3VcwPLvhz
        3Kh0yX5o0h3cnAPNrzvrJxUx85twc3K6ijGAFSHHorOfWLAGu5lBjGvRP5JOpjp547FvaI
        WU+KSM6AbjGnX8o7CObtOrsWcTR5bi4=
Date:   Thu, 18 Aug 2022 00:00:58 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     pmladek@suse.com, Dinh Nguyen <dinguyen@kernel.org>,
        Tony Luck <tony.luck@intel.com>, akpm@linux-foundation.org,
        bhe@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
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
        will@kernel.org, linux-edac@vger.kernel.org
Subject: Re: [PATCH v2 10/13] EDAC/altera: Skip the panic notifier if kdump
 is loaded
Message-ID: <Yv1lGpisQVFpUOGP@zn.tnic>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-11-gpiccoli@igalia.com>
 <Yv0mCY04heUXsGiC@zn.tnic>
 <46137c67-25b4-6657-33b7-cffdc7afc0d7@igalia.com>
 <Yv1C0Y25u2IB7PCs@zn.tnic>
 <7f016d7f-a546-a45d-c65c-bc35269b4faa@igalia.com>
 <Yv1XVRmTXHLhOkER@zn.tnic>
 <c0250075-ec87-189f-52c5-e0520325a015@igalia.com>
 <Yv1hn2ayPoyKBAj8@zn.tnic>
 <1ee275b3-97e8-4c2b-be88-d50898d17e23@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1ee275b3-97e8-4c2b-be88-d50898d17e23@igalia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 06:56:11PM -0300, Guilherme G. Piccoli wrote:
> But do you agree that currently, in case of a kdump, that information
> *is not collected*, with our without my patch?

If for some reason that panic notifier does not get run before kdump,
then that's a bug and that driver should not use a panic notifier to log
hw errors in the first place.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
