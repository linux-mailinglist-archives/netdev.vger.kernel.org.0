Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA66458CB43
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 17:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243666AbiHHP0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 11:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243061AbiHHP0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 11:26:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E672914005;
        Mon,  8 Aug 2022 08:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CBE8B80E26;
        Mon,  8 Aug 2022 15:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E23C433D6;
        Mon,  8 Aug 2022 15:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659972406;
        bh=QVa4BfBV7lo527XdkUKxpdBKV3SSO4B9ggVsxDseAa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DB4SmNrxCqdztrrLn4+ufvycDeBeLRrfL0+xLwT4ASz/nm5dHRteRaEbBRNIa3kQM
         4dj1wxE+Ic9ZqgyLgZEGS72UCULcniMnRaVa+vMdUqQOz1O42TqhrCzEEDiokhgFQb
         +ktK7QnRL5Kci/32aGkLmp+ApYcrBtlehxhq98u8=
Date:   Mon, 8 Aug 2022 17:26:43 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Evan Green <evgreen@chromium.org>, linux-efi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
        Petr Mladek <pmladek@suse.com>, kexec@lists.infradead.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, mikelley@microsoft.com,
        hidehiro.kawai.ez@hitachi.com, jgross@suse.com,
        john.ogness@linutronix.de, Kees Cook <keescook@chromium.org>,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>, vgoyal@redhat.com,
        vkuznets@redhat.com, Will Deacon <will@kernel.org>,
        David Gow <davidgow@google.com>,
        Julius Werner <jwerner@chromium.org>
Subject: Re: [PATCH v2 03/13] firmware: google: Test spinlock on panic path
 to avoid lockups
Message-ID: <YvErMyM8FNjeDeiW@kroah.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-4-gpiccoli@igalia.com>
 <CAE=gft71vH+P3iAFXC0bLu0M2x2V4uJGWc82Xa+246ECuUdT-w@mail.gmail.com>
 <019ae735-3d69-cb4e-c003-b83cc8cd76f8@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <019ae735-3d69-cb4e-c003-b83cc8cd76f8@igalia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 12:14:30PM -0300, Guilherme G. Piccoli wrote:
> On 08/08/2022 02:07, Evan Green wrote:
> > On Tue, Jul 19, 2022 at 12:55 PM Guilherme G. Piccoli
> > <gpiccoli@igalia.com> wrote:
> >>
> >> Currently the gsmi driver registers a panic notifier as well as
> >> reboot and die notifiers. The callbacks registered are called in
> >> atomic and very limited context - for instance, panic disables
> >> preemption and local IRQs, also all secondary CPUs (not executing
> >> the panic path) are shutdown.
> >>
> >> With that said, taking a spinlock in this scenario is a dangerous
> >> invitation for lockup scenarios. So, fix that by checking if the
> >> spinlock is free to acquire in the panic notifier callback - if not,
> >> bail-out and avoid a potential hang.
> >>
> >> Fixes: 74c5b31c6618 ("driver: Google EFI SMI")
> >> Cc: Ard Biesheuvel <ardb@kernel.org>
> >> Cc: David Gow <davidgow@google.com>
> >> Cc: Evan Green <evgreen@chromium.org>
> >> Cc: Julius Werner <jwerner@chromium.org>
> >> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> > 
> > Reviewed-by: Evan Green <evgreen@chromium.org>
> 
> Thanks a bunch Evan!
> 
> Ard / Greg, do you think you could get this patch through your -next (or
> -fixes) trees? Not sure which tree is the most common for picking GSMI
> stuff.

Picking out an individual patch from a series with as many responses and
threads like this one is quite difficult.

Just resend this as a stand-alone patch if you want it applied
stand-alone as our tools want to apply a whole patch series at once.

> I'm trying to get these fixes merged individually in their trees to not
> stall the whole series and increase the burden of re-submitting.

The burden is on the submitter, not the maintainer as we have more
submitters than reviewers/maintainers.

thanks,

greg k-h
