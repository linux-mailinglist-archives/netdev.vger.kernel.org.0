Return-Path: <netdev+bounces-11823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CD37349F0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 04:12:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3131280FA0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 02:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20D3B139C;
	Mon, 19 Jun 2023 02:12:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131971C3C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:12:19 +0000 (UTC)
Received: from out-33.mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CAA1B8
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 19:12:18 -0700 (PDT)
Date: Sun, 18 Jun 2023 22:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1687140734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r76UCXNSYK7hKAPox1fty7/njlbL/lomotiDbXrHJ0c=;
	b=TBWCnt8zcFJ5nKRG4NITLMc0ih7Ljc1nAilqoS2S6VpJEHCfC/iKrXm4DqvCBteAIE0x7N
	KKt8TEEvrj/SIu68Wj5oBDWU01USU5SRaXmsywsmSDitWFep2jlqsfvvNpzkBQyjcAlBQy
	vbP17KRUSXvKHyjAh6Si2ussqbVjvZw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nadav Amit <nadav.amit@gmail.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Russell King <linux@armlinux.org.uk>, Song Liu <song@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-modules@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 06/12] mm/execmem: introduce execmem_data_alloc()
Message-ID: <20230619021205.vfbolcklckdpbm4k@moria.home.lan>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-7-rppt@kernel.org>
 <87jzw0qu3s.ffs@tglx>
 <20230618231431.4aj3k5ujye22sqai@moria.home.lan>
 <87h6r4qo1d.ffs@tglx>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6r4qo1d.ffs@tglx>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 02:43:58AM +0200, Thomas Gleixner wrote:
> Kent!

Hi Thomas :)

> No. I am not.

Ok.

> Whether that's an internal function or not does not make any difference
> at all.

Well, at the risk of this discussion going completely off the rails, I
have to disagree with you there. External interfaces and high level
semantics are more important to get right from the outset, internal
implementation details can be cleaned up later, within reason.

And the discussion on this patchset has been more focused on those
external interfaces, which seems like the right approach to me.

> > ... I made the same mistake reviewing Song's patchset...
> 
> Songs series had rough edges, but was way more data structure driven
> and palatable than this hackery.

I liked that aspect of Song's patchset too, and I'm actually inclined to
agree with you that this patchset might get a bit cleaner with more of
that, but really, this semes like just quibbling over calling convention
for an internal helper function.

