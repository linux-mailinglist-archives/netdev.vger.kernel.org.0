Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BD040584C
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355698AbhIINxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:53:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238647AbhIINwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:52:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C66B460041;
        Thu,  9 Sep 2021 13:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631195463;
        bh=9nVW5b9CIZO8paiwj2IcNBcJlmc8azfXpVGaorx2PoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0CRAFxiZS4HATnPqHRQ5opfDmDlB+Dfo989YpBV2bc+BAk91QDpOyEA7mJViyEfFt
         uymiKP/rVMkYOAQesVKHWRqffJbnGMAtNYbvqo6pJLA/NkuAhbCGNBuAGj9+ThYXe7
         4mXgoU/5ftg5CrUHR7D3+mdcd1d8IffjeUw2qBKE=
Date:   Thu, 9 Sep 2021 15:51:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
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
Message-ID: <YToRRMhYfdnzFyMB@kroah.com>
References: <cover.1631112725.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1631112725.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 04:58:47PM +0200, Mauro Carvalho Chehab wrote:
> Hi Greg,
> 
> Sometime ago, I discussed with Jonathan Cameron about providing 
> a way check that the ABI documentation is incomplete.
> 
> While it would be doable to validate the ABI by searching __ATTR and 
> similar macros around the driver, this would probably be very complex
> and would take a while to parse.
> 
> So, I ended by implementing a new feature at scripts/get_abi.pl
> which does a check on the sysfs contents of a running system:
> it reads everything under /sys and reads the entire ABI from
> Documentation/ABI. It then warns for symbols that weren't found,
> optionally showing possible candidates that might be misdefined.
> 
> I opted to place it on 3 patches:
> 
> The first patch adds the basic logic. It runs really quicky (up to 2
> seconds), but it doesn't use sysfs softlinks.
> 
> Patch 2 adds support for also parsing softlinks. It slows the logic,
> with now takes ~40 seconds to run on my desktop (and ~23
> seconds on a HiKey970 ARM board). There are space there for
> performance improvements, by using a more sophisticated
> algorithm, at the expense of making the code harder to
> understand. I ended opting to use a simple implementation
> for now, as ~40 seconds sounds acceptable on my eyes.
> 
> Patch 3 adds an optional parameter to allow filtering the results
> using a regex given by the user.
> 
> One of the problems with the current ABI definitions is that several
> symbols define wildcards, on non-standard ways. The more commonly
> wildcards used there are:
> 
> 	<foo>
> 	{foo}
> 	[foo]
> 	X
> 	Y
> 	Z
> 	/.../
> 
> The script converts the above wildcards into (somewhat relaxed)
> regexes.
> 
> There's one place using  "(some description)". This one is harder to
> parse, as parenthesis are used by the parsing regexes. As this happens
> only on one file, patch 4 addresses such case.
> 
> Patch 5 to 9 fix some other ABI troubles I identified.
> 
> In long term, perhaps the better would be to just use regex on What:
> fields, as this would avoid extra heuristics at get_abi.pl, but this is
> OOT from this patch, and would mean a large number of changes.

This is cool stuff, thanks for doing this!

I'll look at it more once 5.15-rc1 is out, thanks.

greg k-h
