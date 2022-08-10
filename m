Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE33A58EC5C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbiHJMyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiHJMyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:54:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A096483F3D;
        Wed, 10 Aug 2022 05:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5330DB81C67;
        Wed, 10 Aug 2022 12:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F2DC433D6;
        Wed, 10 Aug 2022 12:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660136077;
        bh=uPLuF+DDW04LT9gSOZbFu31bMHZHY7AuwxnDEymETPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UNkY0zZ/dvbVjljh7EO1ErSs2YeEMilfLO5c7AcIqM6C1wcyaDC45s2CAW4+v+5bm
         aSZTtEljP0xweM/nDWXYsXgAGq/7xNaMyvKwesvewAHqmg1qJ58a7fWwmZ2C2n+tlo
         KD8eRKVStYwt20VObVfv4seCARLA42wybbg5rK9E=
Date:   Wed, 10 Aug 2022 14:54:34 +0200
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
Message-ID: <YvOqimNnybaCDDBm@kroah.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-4-gpiccoli@igalia.com>
 <CAE=gft71vH+P3iAFXC0bLu0M2x2V4uJGWc82Xa+246ECuUdT-w@mail.gmail.com>
 <019ae735-3d69-cb4e-c003-b83cc8cd76f8@igalia.com>
 <YvErMyM8FNjeDeiW@kroah.com>
 <55a074a0-ca3a-8afc-4336-e40cff757394@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55a074a0-ca3a-8afc-4336-e40cff757394@igalia.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 12:37:46PM -0300, Guilherme G. Piccoli wrote:
> Let me clarify / ask something: this series, for example, is composed as
> a bunch of patches "centered" around the same idea, panic notifiers
> improvements/fixes. But its patches belong to completely different
> subsystems, like EFI/misc, architectures (alpha, parisc, arm), core
> kernel code, etc.
> 
> What is the best way of getting this merged?
> (a) Re-send individual patches with the respective Review/ACK tags to
> the proper subsystem, or;

Yes.

> (b) Wait until the whole series is ACKed/Reviewed, and a single
> maintainer (like you or Andrew, for example) would pick the whole series
> and apply at once, even if it spans across multiple parts of the kernel?

No, only do this after a kernel release cycle happens and there are
straggler patches that did not get picked up by the relevant subsystem
maintainers.

thanks,

greg k-h
