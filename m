Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E725D9181
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405221AbfJPMue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:34 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35971 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbfJPMud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so14678695pfr.3;
        Wed, 16 Oct 2019 05:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=NPIT2U5/6btWPDGMCUn6hXFW9S2Y3aOyVhzx13LsLP0=;
        b=hgWqZ6ZdTJWTW3FDrsFYTc6sqELiSGqMUhyJxFlWgj+86fVCMDVUWb5EWD6NWpXOJV
         FPNi7xPMHvGr7fSoZtu3oZwTgEPZdQkMOoVjmJNcuya100sozTfX7bkrgRUTpMrTdXI/
         g58zyO718TrAyPaGhaw2Vs00eFN1Xb0jO8EB4uPf/THi65E3PXEVr2tyIZxD/TsDx+uZ
         /udpoRI9X8L+6Lhai0KksTiySgUX1KEQczCuqpqK6PDwql3zAWV/ioGxSEd4iPNSJHBi
         mwPDNpdpu1ItCJa4VqLIdkjnTbIFApbaGtojK4h4877t8e41ZfreABgzkdOcyQkJyYRS
         jDyg==
X-Gm-Message-State: APjAAAWQTrqaKtuibSupPwva409wSeC9W9Z3QjPFmgVZj6DKlYRZeaBi
        Ao/NkK4zyjVzTsxwPCEctVE=
X-Google-Smtp-Source: APXvYqxPMPJz6mDlLLv4WSB2u/Eidw1r9yqJUaT/f7h6H7FyPfUyI97o6YFEQXsI3/CprZalhPAdQA==
X-Received: by 2002:a62:283:: with SMTP id 125mr44864954pfc.137.1571230232803;
        Wed, 16 Oct 2019 05:50:32 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 20sm26061679pfp.153.2019.10.16.05.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 05:50:31 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 1C64440251; Wed, 16 Oct 2019 12:50:31 +0000 (UTC)
Date:   Wed, 16 Oct 2019 12:50:30 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Matthias Maennich <maennich@google.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Module loading problem since 5.3
Message-ID: <20191016125030.GH16384@42.do-not-panic.com>
References: <20191014085235.GW16384@42.do-not-panic.com>
 <20191014144440.GG35313@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191014144440.GG35313@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 03:44:40PM +0100, Matthias Maennich wrote:
> Hi Luis!
> 
> On Mon, Oct 14, 2019 at 08:52:35AM +0000, Luis Chamberlain wrote:
> > On Fri, Oct 11, 2019 at 09:26:05PM +0200, Heiner Kallweit wrote:
> > > On 10.10.2019 19:15, Luis Chamberlain wrote:
> > > >
> > > >
> > > > On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
> > > >
> > > >        MODULE_SOFTDEP("pre: realtek")
> > > >
> > > >     Are you aware of any current issues with module loading
> > > >     that could cause this problem?
> > > >
> > > >
> > > > Nope. But then again I was not aware of MODULE_SOFTDEP(). I'd encourage an extension to lib/kmod.c or something similar which stress tests this. One way that comes to mind to test this is to allow a new tests case which loads two drives which co depend on each other using this macro. That'll surely blow things up fast. That is, the current kmod tests uses request_module() or get_fs_type(), you'd want a new test case with this added using then two new dummy test drivers with the macro dependency.
> > > >
> > > > If you want to resolve this using a more tested path, you could have request_module() be used as that is currently tested. Perhaps a test patch for that can rule out if it's the macro magic which is the issue.
> > > >
> > > >   Luis
> > > 
> > > Maybe issue is related to a bug in introduction of symbol namespaces, see here:
> > > https://lkml.org/lkml/2019/10/11/659
> > 
> > Can you have your user with issues either revert 8651ec01daed or apply the fixes
> > mentioned by Matthias to see if that was the issue?
> > 
> > Matthias what module did you run into which let you run into the issue
> > with depmod? I ask as I think it would be wise for us to add a test case
> > using lib/test_kmod.c and tools/testing/selftests/kmod/kmod.sh for the
> > regression you detected.
> 
> The depmod warning can be reproduced when using a symbol that is built
> into vmlinux and used from a module. E.g. with CONFIG_USB_STORAGE=y and
> CONFIG_USB_UAS=m, the symbol `usb_stor_adjust_quirks` is built in with
> namespace USB_STORAGE and depmod stumbles upon this emitting the
> following warning (e.g. during make modules_install).
> 
>  depmod: WARNING: [...]/uas.ko needs unknown symbol usb_stor_adjust_quirks
> 
> As there is another (less intrusive) way of implementing the namespace
> feature, I posted a patch series [1] on last Thursday that should
> mitigate the issue as the ksymtab entries depmod eventually relies on
> are no longer carrying the namespace in their names.
> 
> Cheers,
> Matthias
> 
> [1] https://lore.kernel.org/lkml/20191010151443.7399-1-maennich@google.com/

Yes but kmalloc() is built-in, and used by *all* drivers compiled as
modules, so why was that an issue?

  Luis
