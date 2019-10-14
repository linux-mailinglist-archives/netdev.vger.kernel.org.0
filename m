Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 265B6D5DE8
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 10:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfJNIwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 04:52:38 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:39984 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729928AbfJNIwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 04:52:38 -0400
Received: by mail-pg1-f170.google.com with SMTP id e13so1494838pga.7;
        Mon, 14 Oct 2019 01:52:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=LQjLxs+ChwVtzwmuuW/knNpY/RZXS8FrKGj5FuN7jvQ=;
        b=f51tTPWe/gQpQC4M06glrU7S91Sgx+qYj3BUDMrQ+iENCwbLrsAutns5S4vdnrHFDO
         BaPFNBkQdeohjqlTWGXnbzeiwvzFix++RWz6x1/WKlB2+8mDzucAXaQUTW1u4L36HUdW
         JbgsthyI59pHu9eMB2tCw2xx8ggFxGzs6QgR7MMHQozO5L4t5yjXDXkgYlO3uS95RMP9
         1zbWh/iO8/Gy4f4OohgHBAk/Tupyz2YxsKmnFgip35GMiT8p473c+aJ3BAmPRn8tJTSI
         wWuqFmNf4ziIoYqaau5OBGw59Mq6yUE6vQwYxl2WkL/ZgpSmNYVMujcpnVk8lj1uyVCH
         dTqg==
X-Gm-Message-State: APjAAAXBc7+Ipq3xildBLAJCOZi54vhgHF7VcXxXLTKwNt/v4+LLX3ki
        H5QlJ2PYVu/sZA1jPoIDqzg=
X-Google-Smtp-Source: APXvYqwa12q0CPE+GNpbNjoSjz62Jb4XZaoMR0EnEbW6Gk820+iPtrynDZWJKS8Z4qZNmg5y5YkrCQ==
X-Received: by 2002:a63:5c57:: with SMTP id n23mr9662639pgm.132.1571043157520;
        Mon, 14 Oct 2019 01:52:37 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id x19sm20106793pgc.59.2019.10.14.01.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 01:52:36 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C032F4021A; Mon, 14 Oct 2019 08:52:35 +0000 (UTC)
Date:   Mon, 14 Oct 2019 08:52:35 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Matthias Maennich <maennich@google.com>,
        Jessica Yu <jeyu@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Module loading problem since 5.3
Message-ID: <20191014085235.GW16384@42.do-not-panic.com>
References: <8132cf72-0ae1-48ae-51fb-1a01cf00c693@gmail.com>
 <CAB=NE6XdVXMnq7pgmXxv4Qicu7=xrtQC-b2sXAfVxiAq68NMKg@mail.gmail.com>
 <875eecfb-618a-4989-3b9f-f8272b8d3746@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875eecfb-618a-4989-3b9f-f8272b8d3746@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 09:26:05PM +0200, Heiner Kallweit wrote:
> On 10.10.2019 19:15, Luis Chamberlain wrote:
> > 
> > 
> > On Thu, Oct 10, 2019, 6:50 PM Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> wrote:
> > 
> >        MODULE_SOFTDEP("pre: realtek")
> > 
> >     Are you aware of any current issues with module loading
> >     that could cause this problem?
> > 
> > 
> > Nope. But then again I was not aware of MODULE_SOFTDEP(). I'd encourage an extension to lib/kmod.c or something similar which stress tests this. One way that comes to mind to test this is to allow a new tests case which loads two drives which co depend on each other using this macro. That'll surely blow things up fast. That is, the current kmod tests uses request_module() or get_fs_type(), you'd want a new test case with this added using then two new dummy test drivers with the macro dependency.
> > 
> > If you want to resolve this using a more tested path, you could have request_module() be used as that is currently tested. Perhaps a test patch for that can rule out if it's the macro magic which is the issue.
> > 
> >   Luis
>
> Maybe issue is related to a bug in introduction of symbol namespaces, see here:
> https://lkml.org/lkml/2019/10/11/659

Can you have your user with issues either revert 8651ec01daed or apply the fixes
mentioned by Matthias to see if that was the issue?

Matthias what module did you run into which let you run into the issue
with depmod? I ask as I think it would be wise for us to add a test case
using lib/test_kmod.c and tools/testing/selftests/kmod/kmod.sh for the
regression you detected.

  Luis
