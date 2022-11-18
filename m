Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D9762F881
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242094AbiKRO4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242023AbiKROzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:55:55 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDB390397;
        Fri, 18 Nov 2022 06:55:31 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A1D8221FB8;
        Fri, 18 Nov 2022 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1668783329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RcWbup5BnnjHzEPpsHQeQ/9zmfC/ktCQBWDNShm4WAU=;
        b=EDb4yO6yUhovxR1R/uuiYft78ukr2h+oU+IjaIre1crSLD6FqDa7tOBl7T9GdFyjImWzLl
        fuZVE7BJe7raqlKMXUK6GnRr1NqEKply8FF3aod58x9Whn9xAOWMtUkNgxO/GnqpzSdULK
        TFzAN6y09Rae96AY+OVlAOuIn3VhXg8=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 093D42C141;
        Fri, 18 Nov 2022 14:55:28 +0000 (UTC)
Date:   Fri, 18 Nov 2022 15:55:27 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-um@lists.infradead.org, Aaron Tomlin <atomlin@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Ard Biesheuvel <ardb@kernel.org>,
        linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-usb@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Helge Deller <deller@gmx.de>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Tom Rix <trix@redhat.com>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH printk v5 00/40] reduce console_lock scope
Message-ID: <Y3ec3/fpdAQacAOW@alley>
References: <20221116162152.193147-1-john.ogness@linutronix.de>
 <Y3drEOkD1fuZcvV2@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3drEOkD1fuZcvV2@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 2022-11-18 12:22:58, Petr Mladek wrote:
> On Wed 2022-11-16 17:27:12, John Ogness wrote:
> > This is v5 of a series to prepare for threaded/atomic
> > printing. v4 is here [0]. This series focuses on reducing the
> > scope of the BKL console_lock. It achieves this by switching to
> > SRCU and a dedicated mutex for console list iteration and
> > modification, respectively. The console_lock will no longer
> > offer this protection.
> 
> The patchset looks ready for linux-next from my POV.
> 
> I am going to push it there right now to get as much testing
> as possible before the merge window.

JFYI, the patchset is committed in printk/linux.git,
branch rework/console-list-lock.

I'll eventually merge it into rework/kthreads. But I wanted to have
it separated until it gets some more testing in linux-next and
eventually some more review.

Best Regards,
Petr
