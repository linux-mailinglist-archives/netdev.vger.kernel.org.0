Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18EC3E0AC3
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbfJVRfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfJVRfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 13:35:32 -0400
Received: from localhost (mobile-166-172-186-56.mycingular.net [166.172.186.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B094320700;
        Tue, 22 Oct 2019 17:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571765730;
        bh=Jld/hYcxZXmjGFVuWBdEY4QI+QyPIanxZKbLtqBLGBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KjIZP5hfgFgUn1+Ljz18nxHSEXDVd7I1a8ueHM1nX8sqKYwTPALZAdaZeymD9A5Xk
         AhqKSe2drZC6ffhxX2VDu2wyGx51R4WPVjG0f6K8p+Z2h7rwP81FZEar+clOopjyBk
         JWILQvQH0HfCGebHAWRAKurHRkWaeIRbs5Klfa/c=
Date:   Tue, 22 Oct 2019 13:35:27 -0400
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Joe Perches <joe@perches.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] debugfs: Add debugfs_create_xul() for hexadecimal
 unsigned long
Message-ID: <20191022173527.GD230934@kroah.com>
References: <20191021143742.14487-1-geert+renesas@glider.be>
 <20191021143742.14487-2-geert+renesas@glider.be>
 <0f91839d858fcb03435ebc85e61ee4e75371ff37.camel@perches.com>
 <CAMuHMdU4OhsK6Jvy406ZCM+OeGcfVB0b7ccsne9KdMZFLf=JqQ@mail.gmail.com>
 <a32b6a6b5f48ff0c4685bd417a8fb66229d95033.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a32b6a6b5f48ff0c4685bd417a8fb66229d95033.camel@perches.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 02:07:34AM -0700, Joe Perches wrote:
> On Tue, 2019-10-22 at 10:03 +0200, Geert Uytterhoeven wrote:
> > Hi Joe,
> 
> Hey again Geert.
> 
> > On Mon, Oct 21, 2019 at 5:37 PM Joe Perches <joe@perches.com> wrote:
> > > On Mon, 2019-10-21 at 16:37 +0200, Geert Uytterhoeven wrote:
> > > > The existing debugfs_create_ulong() function supports objects of
> > > > type "unsigned long", which are 32-bit or 64-bit depending on the
> > > > platform, in decimal form.  To format objects in hexadecimal, various
> > > > debugfs_create_x*() functions exist, but all of them take fixed-size
> > > > types.
> > > > 
> > > > Add a debugfs helper for "unsigned long" objects in hexadecimal format.
> > > > This avoids the need for users to open-code the same, or introduce
> > > > bugs when casting the value pointer to "u32 *" or "u64 *" to call
> > > > debugfs_create_x{32,64}().
> > > []
> > > > diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> > > []
> > > > @@ -356,4 +356,14 @@ static inline ssize_t debugfs_write_file_bool(struct file *file,
> > > > 
> > > >  #endif
> > > > 
> > > > +static inline void debugfs_create_xul(const char *name, umode_t mode,
> > > > +                                   struct dentry *parent,
> > > > +                                   unsigned long *value)
> > > > +{
> > > > +     if (sizeof(*value) == sizeof(u32))
> > > > +             debugfs_create_x32(name, mode, parent, (u32 *)value);
> > > > +     else
> > > > +             debugfs_create_x64(name, mode, parent, (u64 *)value);
> > > 
> > > trivia: the casts are unnecessary.
> > 
> > They are necessary, in both calls (so using #ifdef as suggested below
> > won't help):
> 
> Silly thinko, (I somehow thought the compiler would
> eliminate the code after the branch not taken, but
> of course it has to compile it first...  oops)
> though the #ifdef should work.
> 
> > > This might be more sensible using #ifdef
> > > 
> > > static inline void debugfs_create_xul(const char *name, umode_t mode,
> > >                                       struct dentry *parent,
> > >                                       unsigned long *value)
> > > {
> > > #if BITS_PER_LONG == 64
> > >         debugfs_create_x64(name, mode, parent, value);
> > > #else
> > >         debugfs_create_x32(name, mode, parent, value);
> > > #endif
> > > }
> > 
> > ... at the expense of the compiler checking only one branch.
> > 
> > Just like "if (IS_ENABLED(CONFIG_<foo>)" (when possible) is preferred
> > over "#ifdef CONFIG_<foo>" because of compile-coverage, I think using
> > "if" here is better than using "#if".
> 
> True if all compilers will always eliminate the unused branch.

Good ones will, we don't care about bad ones :)
