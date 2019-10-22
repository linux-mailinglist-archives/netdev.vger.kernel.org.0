Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 047EEE004D
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbfJVJHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:07:40 -0400
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:38322 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731234AbfJVJHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 05:07:40 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 119F2182CF666;
        Tue, 22 Oct 2019 09:07:38 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3870:3871:3872:4321:4605:5007:6742:7808:8603:8660:10004:10400:10450:10455:11026:11232:11233:11473:11658:11914:12043:12114:12295:12297:12438:12740:12760:12895:13148:13230:13439:14096:14097:14180:14181:14659:14721:19904:19999:21060:21080:21627:21740:30012:30029:30054:30060:30070:30090:30091,0,RBL:47.151.135.224:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: veil63_252ba08252f48
X-Filterd-Recvd-Size: 4166
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Tue, 22 Oct 2019 09:07:35 +0000 (UTC)
Message-ID: <a32b6a6b5f48ff0c4685bd417a8fb66229d95033.camel@perches.com>
Subject: Re: [PATCH 1/7] debugfs: Add debugfs_create_xul() for hexadecimal
 unsigned long
From:   Joe Perches <joe@perches.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Date:   Tue, 22 Oct 2019 02:07:34 -0700
In-Reply-To: <CAMuHMdU4OhsK6Jvy406ZCM+OeGcfVB0b7ccsne9KdMZFLf=JqQ@mail.gmail.com>
References: <20191021143742.14487-1-geert+renesas@glider.be>
         <20191021143742.14487-2-geert+renesas@glider.be>
         <0f91839d858fcb03435ebc85e61ee4e75371ff37.camel@perches.com>
         <CAMuHMdU4OhsK6Jvy406ZCM+OeGcfVB0b7ccsne9KdMZFLf=JqQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-22 at 10:03 +0200, Geert Uytterhoeven wrote:
> Hi Joe,

Hey again Geert.

> On Mon, Oct 21, 2019 at 5:37 PM Joe Perches <joe@perches.com> wrote:
> > On Mon, 2019-10-21 at 16:37 +0200, Geert Uytterhoeven wrote:
> > > The existing debugfs_create_ulong() function supports objects of
> > > type "unsigned long", which are 32-bit or 64-bit depending on the
> > > platform, in decimal form.  To format objects in hexadecimal, various
> > > debugfs_create_x*() functions exist, but all of them take fixed-size
> > > types.
> > > 
> > > Add a debugfs helper for "unsigned long" objects in hexadecimal format.
> > > This avoids the need for users to open-code the same, or introduce
> > > bugs when casting the value pointer to "u32 *" or "u64 *" to call
> > > debugfs_create_x{32,64}().
> > []
> > > diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> > []
> > > @@ -356,4 +356,14 @@ static inline ssize_t debugfs_write_file_bool(struct file *file,
> > > 
> > >  #endif
> > > 
> > > +static inline void debugfs_create_xul(const char *name, umode_t mode,
> > > +                                   struct dentry *parent,
> > > +                                   unsigned long *value)
> > > +{
> > > +     if (sizeof(*value) == sizeof(u32))
> > > +             debugfs_create_x32(name, mode, parent, (u32 *)value);
> > > +     else
> > > +             debugfs_create_x64(name, mode, parent, (u64 *)value);
> > 
> > trivia: the casts are unnecessary.
> 
> They are necessary, in both calls (so using #ifdef as suggested below
> won't help):

Silly thinko, (I somehow thought the compiler would
eliminate the code after the branch not taken, but
of course it has to compile it first...  oops)
though the #ifdef should work.

> > This might be more sensible using #ifdef
> > 
> > static inline void debugfs_create_xul(const char *name, umode_t mode,
> >                                       struct dentry *parent,
> >                                       unsigned long *value)
> > {
> > #if BITS_PER_LONG == 64
> >         debugfs_create_x64(name, mode, parent, value);
> > #else
> >         debugfs_create_x32(name, mode, parent, value);
> > #endif
> > }
> 
> ... at the expense of the compiler checking only one branch.
> 
> Just like "if (IS_ENABLED(CONFIG_<foo>)" (when possible) is preferred
> over "#ifdef CONFIG_<foo>" because of compile-coverage, I think using
> "if" here is better than using "#if".

True if all compilers will always eliminate the unused branch.


