Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733112E7A58
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgL3Pag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:30:36 -0500
Received: from foss.arm.com ([217.140.110.172]:40584 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgL3Pag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:30:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DBC8101E;
        Wed, 30 Dec 2020 07:29:50 -0800 (PST)
Received: from e107158-lin (unknown [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8F323F719;
        Wed, 30 Dec 2020 07:29:48 -0800 (PST)
Date:   Wed, 30 Dec 2020 15:29:46 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
Message-ID: <20201230152946.gththmiujgj7qkj4@e107158-lin>
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin>
 <20201229173401.GH450923@krava>
 <20201229232835.cbyfmja3bu3lx7we@e107158-lin>
 <20201230090333.GA577428@krava>
 <20201230132759.GB577428@krava>
 <20201230132852.GC577428@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201230132852.GC577428@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/20 14:28, Jiri Olsa wrote:
> On Wed, Dec 30, 2020 at 02:28:02PM +0100, Jiri Olsa wrote:
> > On Wed, Dec 30, 2020 at 10:03:37AM +0100, Jiri Olsa wrote:
> > > On Tue, Dec 29, 2020 at 11:28:35PM +0000, Qais Yousef wrote:
> > > > Hi Jiri
> > > > 
> > > > On 12/29/20 18:34, Jiri Olsa wrote:
> > > > > On Tue, Dec 29, 2020 at 03:13:52PM +0000, Qais Yousef wrote:
> > > > > > Hi
> > > > > > 
> > > > > > When I enable CONFIG_DEBUG_INFO_BTF I get the following error in the BTFIDS
> > > > > > stage
> > > > > > 
> > > > > > 	FAILED unresolved symbol udp6_sock
> > > > > > 
> > > > > > I cross compile for arm64. My .config is attached.
> > > > > > 
> > > > > > I managed to reproduce the problem on v5.9 and v5.10. Plus 5.11-rc1.
> > > > > > 
> > > > > > Have you seen this before? I couldn't find a specific report about this
> > > > > > problem.
> > > > > > 
> > > > > > Let me know if you need more info.
> > > > > 
> > > > > hi,
> > > > > this looks like symptom of the gcc DWARF bug we were
> > > > > dealing with recently:
> > > > > 
> > > > >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97060
> > > > >   https://lore.kernel.org/lkml/CAE1WUT75gu9G62Q9uAALGN6vLX=o7vZ9uhqtVWnbUV81DgmFPw@mail.gmail.com/#r
> > > > > 
> > > > > what pahole/gcc version are you using?
> > > > 
> > > > I'm on gcc 9.3.0
> > > > 
> > > > 	aarch64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
> > > > 
> > > > I was on pahole v1.17. I moved to v1.19 but I still see the same problem.
> > > 
> > > I can reproduce with your .config, but make 'defconfig' works,
> > > so I guess it's some config option issue, I'll check later today

My .config was a defconfig + CONFIG_DEBUG_INFO_BTF + convert all modules to
built-in.

> > 
> > so your .config has
> >   CONFIG_CRYPTO_DEV_BCM_SPU=y

Ah, how random. I removed this config and indeed it does work then, thanks!

> > 
> > and that defines 'struct device_private' which
> > clashes with the same struct defined in drivers/base/base.h
> > 
> > so several networking structs will be doubled, like net_device:
> > 
> > 	$ bpftool btf dump file ../vmlinux.config | grep net_device\' | grep STRUCT
> > 	[2731] STRUCT 'net_device' size=2240 vlen=133
> > 	[113981] STRUCT 'net_device' size=2240 vlen=133
> > 
> > each is using different 'struct device_private' when it's unwinded
> > 
> > and that will confuse BTFIDS logic, becase we have multiple structs
> > with the same name, and we can't be sure which one to pick

We can't tell which object/subsystem the struct come from?

Or maybe we can introduce some annotation to help BTFIDS to pick the right one?

> > 
> > perhaps we should check on this in pahole and warn earlier with
> > better error message.. I'll check, but I'm not sure if pahole can
> > survive another hastab ;-)
> > 
> > Andrii, any ideas on this? ;-)
> > 
> > easy fix is the patch below that renames the bcm's structs,
> > it makes the kernel to compile.. but of course the new name
> > is probably wrong and we should push this through that code
> > authors
> 
> also another quick fix is to switch it to module

This works too.

Thanks for your speedy response.

Cheers

--
Qais Yousef
