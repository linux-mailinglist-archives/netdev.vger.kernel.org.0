Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4A56341C2
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 17:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbiKVQnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 11:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiKVQnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 11:43:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DABC61B8C;
        Tue, 22 Nov 2022 08:43:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EAEE61796;
        Tue, 22 Nov 2022 16:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CD1C433D6;
        Tue, 22 Nov 2022 16:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669135392;
        bh=HhGB03f7yfLJTw6SIRqhGxERi9Gom4x4ToervBUNQF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ai29wCwrSrFMalECnQg3VZFE6JJ7w1PVvNsX/nUcTdZGvwJT9FgVXh0Qu1fP/KZjg
         gLL1mmmGyJUPfkwUZ8U8rfzyORb4k7cg2ocWkdlYVwXPJu4ByDHKX8FbqktGuqI0/r
         L84ihOeSNwOdUyo5JUrjvyIoAUgVxWDKIToY6zCM=
Date:   Tue, 22 Nov 2022 17:43:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     John Ogness <john.ogness@linutronix.de>
Cc:     Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
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
Message-ID: <Y3z8HOt0yOd1nceY@kroah.com>
References: <20221116162152.193147-1-john.ogness@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116162152.193147-1-john.ogness@linutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 05:27:12PM +0106, John Ogness wrote:
> This is v5 of a series to prepare for threaded/atomic
> printing. v4 is here [0]. This series focuses on reducing the
> scope of the BKL console_lock. It achieves this by switching to
> SRCU and a dedicated mutex for console list iteration and
> modification, respectively. The console_lock will no longer
> offer this protection.
> 
> Also, during the review of v2 it came to our attention that
> many console drivers are checking CON_ENABLED to see if they
> are registered. Because this flag can change without
> unregistering and because this flag does not represent an
> atomic point when an (un)registration process is complete,
> a new console_is_registered() function is introduced. This
> function uses the console_list_lock to synchronize with the
> (un)registration process to provide a reliable status.
> 
> All users of the console_lock for list iteration have been
> modified. For the call sites where the console_lock is still
> needed (for other reasons), comments are added to explain
> exactly why the console_lock is needed.
> 
> All users of CON_ENABLED for registration status have been
> modified to use console_is_registered(). Note that there are
> still users of CON_ENABLED, but this is for legitimate purposes
> about a registered console being able to print.
> 
> The base commit for this series is from Paul McKenney's RCU tree
> and provides an NMI-safe SRCU implementation [1]. Without the
> NMI-safe SRCU implementation, this series is not less safe than
> mainline. But we will need the NMI-safe SRCU implementation for
> atomic consoles anyway, so we might as well get it in
> now. Especially since it _does_ increase the reliability for
> mainline in the panic path.
> 
> Changes since v4:
> 
> printk:
> 
> - Introduce console_init_seq() to handle the now rather complex
>   procedure to find an appropriate start sequence number for a
>   new console upon registration.
> 
> - When registering a non-boot console and boot consoles are
>   registered, try to flush all the consoles to get the next @seq
>   value before falling back to use the @seq of the enabled boot
>   console that is furthest behind.
> 
> - For console_force_preferred_locked(), make the console the
>   head of the console list.
> 


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
