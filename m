Return-Path: <netdev+bounces-7829-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 919DD721C2B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A7BF281118
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E7E380;
	Mon,  5 Jun 2023 02:52:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCCF198;
	Mon,  5 Jun 2023 02:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC71FC433EF;
	Mon,  5 Jun 2023 02:52:46 +0000 (UTC)
Date: Sun, 4 Jun 2023 22:52:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kent.overstreet@linux.dev" <kent.overstreet@linux.dev>, Thomas Gleixner
 <tglx@linutronix.de>, "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "deller@gmx.de" <deller@gmx.de>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>,
 "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "hca@linux.ibm.com" <hca@linux.ibm.com>, "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-riscv@lists.infradead.org"
 <linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
 <linux-s390@vger.kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "mpe@ellerman.id.au"
 <mpe@ellerman.id.au>, "x86@kernel.org" <x86@kernel.org>,
 "tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>, "rppt@kernel.org"
 <rppt@kernel.org>, "linux-trace-kernel@vger.kernel.org"
 <linux-trace-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org"
 <linux-parisc@vger.kernel.org>, "christophe.leroy@csgroup.eu"
 <christophe.leroy@csgroup.eu>, Will Deacon <will@kernel.org>,
 "dinguyen@kernel.org" <dinguyen@kernel.org>, "naveen.n.rao@linux.ibm.com"
 <naveen.n.rao@linux.ibm.com>, "sparclinux@vger.kernel.org"
 <sparclinux@vger.kernel.org>, "linux-modules@vger.kernel.org"
 <linux-modules@vger.kernel.org>, "bpf@vger.kernel.org"
 <bpf@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "song@kernel.org"
 <song@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
Message-ID: <20230604225244.65be9103@rorschach.local.home>
In-Reply-To: <50D768D7-15BF-43B8-A5FD-220B25595336@gmail.com>
References: <20230601101257.530867-1-rppt@kernel.org>
	<20230601101257.530867-13-rppt@kernel.org>
	<0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
	<ZHjcr26YskTm+0EF@moria.home.lan>
	<a51c041b61e2916d2b91c990349aabc6cb9836aa.camel@intel.com>
	<ZHjljJfQjhVV/jNS@moria.home.lan>
	<68b8160454518387c53508717ba5ed5545ff0283.camel@intel.com>
	<50D768D7-15BF-43B8-A5FD-220B25595336@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Jun 2023 16:54:36 -0700
Nadav Amit <nadav.amit@gmail.com> wrote:

> > The way text_poke() is used here, it is creating a new writable alias
> > and flushing it for *each* write to the module (like for each write of
> > an individual relocation, etc). I was just thinking it might warrant
> > some batching or something.  

Batching does exist, which is what the text_poke_queue() thing does.

-- Steve


