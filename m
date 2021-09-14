Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1720240B089
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 16:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhINOZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 10:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233437AbhINOZf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 10:25:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BED0E60EFF;
        Tue, 14 Sep 2021 14:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631629457;
        bh=ICIH7KIpkdBO4VMxLxo32ZU28uu9Bch7RY2U4rQOErk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cVol9SmVMg6mvsb7u/IvVv1Eh8NERn0k4VZmSJLfCXcd8frhf5Hh0yloOI/eI1deZ
         d56kT7BPfvDTXa472KGsuv90IhCbBCXir70dW0jD+CbHp6RVzy0UeMlfxVLqkw3Ema
         L03jD+s1sQEbIamAH03/HTLVn0lJH7V2Gordt8u5n5J8tZ4tJay3DNvQG3D7Nzn3Wl
         yhi8WdiCV2BbooWkqcv7WWkTR/s4yY4x8yxVgX06bETX23HfEHy0A6v3lFCzldUhqt
         7MIjq1p+fiXrThFfedfJkIl4Oz5X+dE6HXQIyoWs0Zlj57ake0ZDMHQaZUksph1kfJ
         nbe+bI1tFbGUA==
Date:   Tue, 14 Sep 2021 16:24:12 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Tony Luck <tony.luck@intel.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/9] get_abi.pl: Check for missing symbols at the ABI
 specs
Message-ID: <20210914162412.0b642091@coco.lan>
In-Reply-To: <YToRRMhYfdnzFyMB@kroah.com>
References: <cover.1631112725.git.mchehab+huawei@kernel.org>
        <YToRRMhYfdnzFyMB@kroah.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, 9 Sep 2021 15:51:00 +0200
Greg KH <gregkh@linuxfoundation.org> escreveu:

> On Wed, Sep 08, 2021 at 04:58:47PM +0200, Mauro Carvalho Chehab wrote:
> > Hi Greg,
> > 
> > Sometime ago, I discussed with Jonathan Cameron about providing 
> > a way check that the ABI documentation is incomplete.
> > 
> > While it would be doable to validate the ABI by searching __ATTR and 
> > similar macros around the driver, this would probably be very complex
> > and would take a while to parse.
> > 
> > So, I ended by implementing a new feature at scripts/get_abi.pl
> > which does a check on the sysfs contents of a running system:
> > it reads everything under /sys and reads the entire ABI from
> > Documentation/ABI. It then warns for symbols that weren't found,
> > optionally showing possible candidates that might be misdefined.
> > 
> > I opted to place it on 3 patches:
> > 
> > The first patch adds the basic logic. It runs really quicky (up to 2
> > seconds), but it doesn't use sysfs softlinks.
> > 
> > Patch 2 adds support for also parsing softlinks. It slows the logic,
> > with now takes ~40 seconds to run on my desktop (and ~23
> > seconds on a HiKey970 ARM board). There are space there for
> > performance improvements, by using a more sophisticated
> > algorithm, at the expense of making the code harder to
> > understand. I ended opting to use a simple implementation
> > for now, as ~40 seconds sounds acceptable on my eyes.
> > 
> > Patch 3 adds an optional parameter to allow filtering the results
> > using a regex given by the user.
> > 
> > One of the problems with the current ABI definitions is that several
> > symbols define wildcards, on non-standard ways. The more commonly
> > wildcards used there are:
> > 
> > 	<foo>
> > 	{foo}
> > 	[foo]
> > 	X
> > 	Y
> > 	Z
> > 	/.../
> > 
> > The script converts the above wildcards into (somewhat relaxed)
> > regexes.
> > 
> > There's one place using  "(some description)". This one is harder to
> > parse, as parenthesis are used by the parsing regexes. As this happens
> > only on one file, patch 4 addresses such case.
> > 
> > Patch 5 to 9 fix some other ABI troubles I identified.
> > 
> > In long term, perhaps the better would be to just use regex on What:
> > fields, as this would avoid extra heuristics at get_abi.pl, but this is
> > OOT from this patch, and would mean a large number of changes.  
> 
> This is cool stuff, thanks for doing this!
> 
> I'll look at it more once 5.15-rc1 is out, thanks.

FYI, there's a new version at:

	https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git/log/?h=get_undefined

In order for get_abi.pl to convert What: into regex, changes are needed on
existing ABI files. One alternative would be to convert everything into
regex, but that would probably mean that most ABI files would require work.

In order to avoid a huge number of patches/changes, I opted to touch only
the ones that aren't following the de-facto wildcard standards already 
found on most of the ABI files. So, I added support at get_abi.pl to
consider those patterns as wildcards:

	/.../
	*
	<foo>
	X
	Y
	Z
	[0-9] (and variants)

The files that use something else meaning a wildcard need changes, in order
to avoid ambiguity when the script decides if a character is either a 
wildcard or not. 

One of the issues there is with "N". several files use it as a wildcard, 
but USB sysfs parameters have several ABI nodes with an uppercase "N"
letter (like bNumInterfaces and such). So, this one had to be converted
too (and represents the vast majority of patches).

Anyway, as the number of such patches is high, I'll submit the work 
on three separate series:

	- What: changes needed for regex conversion;
	- get_abi.pl updates;
	- Some additions for missing symbols found on my
	  desktop.

Thanks,
Mauro
