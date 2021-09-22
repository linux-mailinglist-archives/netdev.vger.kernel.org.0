Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E554143F4
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbhIVIpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:45:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233349AbhIVIpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 04:45:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BCE46128E;
        Wed, 22 Sep 2021 08:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632300225;
        bh=wIX4Nyvh3NhY3C+0A3fE0uyB9IBDeFSOm7OFmITz9tI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CM4M2XN10RksxBCCApODxtQ2IPRq2c/vxmCmZV3YOE/940DtSnIcLvyKBKPrf6h5S
         WMGmmNVyRc3N743l6mHHMjdXZ1q5CFPbtTdR8a6nilWKjCj8QELFY3fFO8E7VDd/A4
         hmThC2566Pbe7I0An0kwPdtYEjjw1ehdvW0+WyWY=
Date:   Wed, 22 Sep 2021 10:43:42 +0200
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
Message-ID: <YUrsvgf3JXUPQ2Vo@kroah.com>
References: <cover.1631957565.git.mchehab+huawei@kernel.org>
 <YUoN2m/OYHVLPrSl@kroah.com>
 <20210921201633.5e6128a0@coco.lan>
 <YUrCjhEYGXWU6M13@kroah.com>
 <YUrLqdCQyGaCc1XJ@kroah.com>
 <20210922093609.34d7bbca@coco.lan>
 <YUrlFjotiFTYKXOV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUrlFjotiFTYKXOV@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 10:11:02AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Sep 22, 2021 at 09:36:09AM +0200, Mauro Carvalho Chehab wrote:
> > It sounds it took quite a while handling iommu cap, which sounds weird, as
> > it should be looking just 3 What expressions:
> > 
> > 	[07:43:06] What: /sys/class/iommu/.*/amd\-iommu/cap
> > 	[07:43:06] What: /sys/class/iommu/.*/intel\-iommu/cap
> > 	[07:43:06] What: /sys/devices/pci.*.*.*.*\:.*.*/0000\:.*.*\:.*.*..*/dma/dma.*chan.*/quickdata/cap
> > 
> > Maybe there was a memory starvation while running the script, causing
> > swaps. Still, it is weird that it would happen there, as the hashes
> > and arrays used at the script are all allocated before it starts the
> > search logic. Here, the allocation part takes ~2 seconds.
> 
> No memory starvation here, this thing is a beast:
> 	$ free -h
> 	               total        used        free      shared  buff/cache   available
> 	Mem:           251Gi        36Gi        13Gi       402Mi       202Gi       212Gi
> 	Swap:          4.0Gi       182Mi       3.8Gi
> 
> 	$ nproc
> 	64
> 
> 
> > At least on my Dell Precision 5820 (12 cpu threads), the amount of memory it
> > uses is not huge:
> > 
> >     $ /usr/bin/time -v ./scripts/get_abi.pl undefined >/dev/null
> > 	Command being timed: "./scripts/get_abi.pl undefined"
> > 	User time (seconds): 12.68
> > 	System time (seconds): 1.29
> > 	Percent of CPU this job got: 99%
> > 	Elapsed (wall clock) time (h:mm:ss or m:ss): 0:13.98
> > 	Average shared text size (kbytes): 0
> > 	Average unshared data size (kbytes): 0
> > 	Average stack size (kbytes): 0
> > 	Average total size (kbytes): 0
> > 	Maximum resident set size (kbytes): 212608
> > 	Average resident set size (kbytes): 0
> > 	Major (requiring I/O) page faults: 0
> > 	Minor (reclaiming a frame) page faults: 52003
> > 	Voluntary context switches: 1
> > 	Involuntary context switches: 56
> > 	Swaps: 0
> > 	File system inputs: 0
> > 	File system outputs: 0
> > 	Socket messages sent: 0
> > 	Socket messages received: 0
> > 	Signals delivered: 0
> > 	Page size (bytes): 4096
> > 	Exit status: 0
> > 
> > Unfortunately, I don't have any amd-based machine here, but I'll
> > try to run it later on a big arm server and see how it behaves.
> 
> I'll run that and get back to you in 30 minutes :)

$ /usr/bin/time -v ./scripts/get_abi.pl undefined > /dev/null
	Command being timed: "./scripts/get_abi.pl undefined"
	User time (seconds): 1756.94
	System time (seconds): 0.76
	Percent of CPU this job got: 99%
	Elapsed (wall clock) time (h:mm:ss or m:ss): 29:18.94
	Average shared text size (kbytes): 0
	Average unshared data size (kbytes): 0
	Average stack size (kbytes): 0
	Average total size (kbytes): 0
	Maximum resident set size (kbytes): 228116
	Average resident set size (kbytes): 0
	Major (requiring I/O) page faults: 0
	Minor (reclaiming a frame) page faults: 55862
	Voluntary context switches: 1
	Involuntary context switches: 17205
	Swaps: 0
	File system inputs: 0
	File system outputs: 0
	Socket messages sent: 0
	Socket messages received: 0
	Signals delivered: 0
	Page size (bytes): 4096
	Exit status: 0

