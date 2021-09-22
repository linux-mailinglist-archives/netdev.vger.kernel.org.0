Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70739414152
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 07:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhIVFpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 01:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232060AbhIVFpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 01:45:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08055611B0;
        Wed, 22 Sep 2021 05:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632289426;
        bh=ojvRt6zurBFy0u6EsU1sNQ7IDqOOcGLUqvhhkILPTvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f28Lh0IjwfWjV18sWT8u2kvREEk+ML1mlaDETKpfYdxmSpoaqJUt8wud68wCY8jee
         img24YuDvuq8Lq7IDrzMaPMSgdVKvgzWS/5OkT0vL5omoc2WLUFmCFp5JJOyOCdjdb
         tr9xvGwrmsFoc/kEfT0PepG14Jv/TwyEik4+4PlM=
Date:   Wed, 22 Sep 2021 07:43:42 +0200
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
Message-ID: <YUrCjhEYGXWU6M13@kroah.com>
References: <cover.1631957565.git.mchehab+huawei@kernel.org>
 <YUoN2m/OYHVLPrSl@kroah.com>
 <20210921201633.5e6128a0@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210921201633.5e6128a0@coco.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 08:16:33PM +0200, Mauro Carvalho Chehab wrote:
> Em Tue, 21 Sep 2021 18:52:42 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:
> 
> > On Sat, Sep 18, 2021 at 11:52:10AM +0200, Mauro Carvalho Chehab wrote:
> > > Hi Greg,
> > > 
> > > Add a new feature at get_abi.pl to optionally check for existing symbols
> > > under /sys that won't match a "What:" inside Documentation/ABI.
> > > 
> > > Such feature is very useful to detect missing documentation for ABI.
> > > 
> > > This series brings a major speedup, plus it fixes a few border cases when
> > > matching regexes that end with a ".*" or \d+.
> > > 
> > > patch 1 changes get_abi.pl logic to handle multiple What: lines, in
> > > order to make the script more robust;
> > > 
> > > patch 2 adds the basic logic. It runs really quicky (up to 2
> > > seconds), but it doesn't use sysfs softlinks.
> > > 
> > > Patch 3 adds support for parsing softlinks. It makes the script a
> > > lot slower, making it take a couple of minutes to process the entire
> > > sysfs files. It could be optimized in the future by using a graph,
> > > but, for now, let's keep it simple.
> > > 
> > > Patch 4 adds an optional parameter to allow filtering the results
> > > using a regex given by the user. When this parameter is used
> > > (which should be the normal usecase), it will only try to find softlinks
> > > if the sysfs node matches a regex.
> > > 
> > > Patch 5 improves the report by avoiding it to ignore What: that
> > > ends with a wildcard.
> > > 
> > > Patch 6 is a minor speedup.  On a Dell Precision 5820, after patch 6, 
> > > results are:
> > > 
> > > 	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefined| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined; wc -l undefined_symbols
> > > 
> > > 	real	2m35.563s
> > > 	user	2m34.346s
> > > 	sys	0m1.220s
> > > 	7595 undefined
> > > 	896 undefined_symbols
> > > 
> > > Patch 7 makes a *huge* speedup: it basically switches a linear O(n^3)
> > > search for links by a logic which handle symlinks using BFS. It
> > > also addresses a border case that was making 'msi-irqs/\d+' regex to
> > > be misparsed. 
> > > 
> > > After patch 7, it is 11 times faster:
> > > 
> > > 	$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefined| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined; wc -l undefined_symbols
> > > 
> > > 	real	0m14.137s
> > > 	user	0m12.795s
> > > 	sys	0m1.348s
> > > 	7030 undefined
> > > 	794 undefined_symbols
> > > 
> > > (the difference on the number of undefined symbols are due to the fix for
> > > it to properly handle 'msi-irqs/\d+' regex)
> > > 
> > > -
> > > 
> > > While this series is independent from Documentation/ABI changes, it
> > > works best when applied from this tree, which also contain ABI fixes
> > > and a couple of additions of frequent missed symbols on my machine:
> > > 
> > >     https://git.kernel.org/pub/scm/linux/kernel/git/mchehab/devel.git/log/?h=get_undefined_abi_v3  
> > 
> > I've taken all of these, but get_abi.pl seems to be stuck in an endless
> > loop or something.  I gave up and stopped it after 14 minutes.  It had
> > stopped printing out anything after finding all of the pci attributes
> > that are not documented :)
> 
> It is probably not an endless loop, just there are too many vars to
> check on your system, which could make it really slow.

Ah, yes, I ran it overnight and got the following:

$ time ./scripts/get_abi.pl undefined |sort >undefined && cat undefined| perl -ne 'print "$1\n" if (m#.*/(\S+) not found#)'|sort|uniq -c|sort -nr >undefined_symbols; wc -l undefined; wc -l undefined_symbols

real	29m39.503s
user	29m37.556s
sys	0m0.851s
26669 undefined
765 undefined_symbols

> The way the search algorithm works is that reduces the number of regex 
> expressions that will be checked for a given file entry at sysfs. It 
> does that by looking at the devnode name. For instance, when it checks for
> this file:
> 
> 	/sys/bus/pci/drivers/iosf_mbi_pci/bind
> 
> The logic will seek only the "What:" expressions that end with "bind".
> Currently, there are just two What expressions for it[1]:
> 
> 	What: /sys/bus/fsl\-mc/drivers/.*/bind
> 	What: /sys/bus/pci/drivers/.*/bind
> 
> It will then run an O(n²) algorithm to seek:
> 
> 		foreach my $a (@names) {
>                        foreach my $w (split /\xac/, $what) {
>                                if ($a =~ m#^$w$#) {
> 					exact = 1;
>                                         last;
>                                 }
> 			}
> 		}
> 
> Which runs quickly, when there are few regexs to seek. There are, 
> however, some What: expressions that end with a wildcard. Those are
> harder to process. Right now, they're all grouped together, which
> makes them slower. Most of the processing time are spent on those.
> 
> I'm working right now on some strategy to also speed up the search 
> for them. Once I get something better, I'll send a patch series.
> 
> --
> 
> [1] On a side note, there are currently some problems with the What:
>     definitions for bind/unbind, as:
> 
> 	- it doesn't match all PCI devices;
> 	- it doesn't match ACPI and other buses that also export
> 	  bind/unbind.
> 
> > 
> > Anything I can do to help debug this?
> >
> 
> There are two parameters that can help to identify the issue:
> 
> a) You can add a "--show-hints" parameter. This turns on some 
>    prints that may help to identify what the script is doing.
>    It is not really a debug option, but it helps to identify
>    when some regexes are failing.
> 
> b) You can limit the What expressions that will be parsed with:
> 	   --search-string <something>
> 
> You can combine both. For instance, if you want to make it
> a lot more verbose, you could run it as:
> 
> 	./scripts/get_abi.pl undefined --search-string /sys --show-hints

Let me run this and time stamp it to see where it is getting hung up on.
Give it another 30 minutes :)

thanks,

greg k-hj
