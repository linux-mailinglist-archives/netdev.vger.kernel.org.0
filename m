Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382AD4137E1
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhIUQyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhIUQyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 12:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A4F861166;
        Tue, 21 Sep 2021 16:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632243164;
        bh=B5TaZlSoiexuf9JW+GmbDksGW7N2p8txxfttQp+ewy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mYIFUnjrhRTELU5t43Xmf8hspCMjsPiLg27aU+C1iYWgeRF7977b8u4ZF3WR4g3i0
         N6A+q9t7a5vR8dY7qxnAGk374Lafpf/HPOqBZQpvsyMlZ9YiGEocn917fRJeJnzBhj
         IquKGrfKWTCavP/HN16EiS6PsGhbfnC50MSIPhGs=
Date:   Tue, 21 Sep 2021 18:52:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
Subject: Re: [PATCH v3 0/7] get_abi.pl: Check for missing symbols at the ABI
 specs
Message-ID: <YUoN2m/OYHVLPrSl@kroah.com>
References: <cover.1631957565.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1631957565.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 18, 2021 at 11:52:10AM +0200, Mauro Carvalho Chehab wrote:
> Hi Greg,
> 
> Add a new feature at get_abi.pl to optionally check for existing symbols
> under /sys that won't match a "What:" inside Documentation/ABI.
> 
> Such feature is very useful to detect missing documentation for ABI.
> 
> This series brings a major speedup, plus it fixes a few border cases when
> matching regexes that end with a ".*" or \d+.
> 
> patch 1 changes get_abi.pl logic to handle multiple What: lines, in
> order to make the script more robust;
> 
> patch 2 adds the basic logic. It runs really quicky (up to 2
> seconds), but it doesn't use sysfs softlinks.
> 
> Patch 3 adds support for parsing softlinks. It makes the script a
> lot slower, making it take a couple of minutes to process the entire
> sysfs files. It could be optimized in the future by using a graph,
> but, for now, let's keep it simple.
> 
> Patch 4 adds an optional parameter to allow filtering the results
> using a regex given by the user. When this parameter is used
> (which should be the normal usecase), it will only try to find softlinks
> if the sysfs node matches a regex.
> 
> Patch 5 improves the report by avoiding it to ignore What: that
> ends with a wildcard.
> 
> Patch 6 is a minor speedup.  On a Dell Precision 5820, after patch 6, 
> results are:
> 
> 	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefined| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined; wc -l undefined_symbols
> 
> 	real	2m35.563s
> 	user	2m34.346s
> 	sys	0m1.220s
> 	7595 undefined
> 	896 undefined_symbols
> 
> Patch 7 makes a *huge* speedup: it basically switches a linear O(n^3)
> search for links by a logic which handle symlinks using BFS. It
> also addresses a border case that was making 'msi-irqs/\d+' regex to
> be misparsed. 
> 
> After patch 7, it is 11 times faster:
> 
> 	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefined| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined; wc -l undefined_symbols
> 
> 	real	0m14.137s
> 	user	0m12.795s
> 	sys	0m1.348s
> 	7030 undefined
> 	794 undefined_symbols
> 
> (the difference on the number of undefined symbols are due to the fix for
> it to properly handle 'msi-irqs/\d+' regex)
> 
> -
> 
> While this series is independent from Documentation/ABI changes, it
> works best when applied from this tree, which also contain ABI fixes
> and a couple of additions of frequent missed symbols on my machine:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git/log/?h=get_undefined_abi_v3

I've taken all of these, but get_abi.pl seems to be stuck in an endless
loop or something.  I gave up and stopped it after 14 minutes.  It had
stopped printing out anything after finding all of the pci attributes
that are not documented :)

Anything I can do to help debug this?

thanks,

greg k-h
