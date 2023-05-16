Return-Path: <netdev+bounces-2981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2612F704D67
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:07:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9D371C20DE1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D4824EBD;
	Tue, 16 May 2023 12:07:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A75824EA6
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:07:29 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5C63A87;
	Tue, 16 May 2023 05:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=nFSjVGlQ0NaiRcQejVvCxxu5us/QrO5JhwIcwtv8Br8=; b=AHguV97S1IjUyMBo14THbXFyfE
	FaD9/bZSH59kp+oTFIRX8k4AETTYAcaxXVqPS2DNtlRsChUFZN3OOWxTKNFXpx0wkgyXH3rWTOcop
	NOef6ehjBdUhbZuLVIYxfhW3NoeOpFbru+KduR310kwFqmBszNKGWUaOSNTbW619lq2I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pytSY-00D0qm-0v; Tue, 16 May 2023 14:07:18 +0200
Date: Tue, 16 May 2023 14:07:18 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: FUJITA Tomonori <tomo@exabit.dev>
Cc: rust-for-linux@vger.kernel.org, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org, fujita.tomonori@gmail.com
Subject: Re: [PATCH 2/2] rust: add socket support
Message-ID: <01b36031-944b-4bf3-b089-f90bb421457c@lunn.ch>
References: <20230515043353.2324288-1-tomo@exabit.dev>
 <010101881db03866-754b644c-682c-44be-8d8e-8376d34c77b3-000000@us-west-2.amazonses.com>
 <f22b24f8-f599-4eec-9535-bcca71138057@lunn.ch>
 <010101882315a489-908f5965-2e67-497f-97f8-5c91bc928673-000000@us-west-2.amazonses.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010101882315a489-908f5965-2e67-497f-97f8-5c91bc928673-000000@us-west-2.amazonses.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 05:43:21AM +0000, FUJITA Tomonori wrote:
> On Mon, 15 May 2023 16:14:56 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Mon, May 15, 2023 at 04:34:28AM +0000, FUJITA Tomonori wrote:
> >> From: FUJITA Tomonori <fujita.tomonori@gmail.com>
> >> 
> >> minimum abstraction for networking.
> > 
> >> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> >> ---
> >>  rust/bindings/bindings_helper.h |   3 +
> >>  rust/kernel/lib.rs              |   2 +
> >>  rust/kernel/net.rs              | 174 ++++++++++++++++++++++++++++++++
> > 
> > The full networking API is huge. So trying to put it all into net.rs
> > is unlikely to work in the long run. Maybe it would be better to name
> > this file based on the tiny little bit of the network API you are
> > writing an abstraction for?
> 
> Yeah, in the long run. I tried the simplest but if the maintainers
> prefer that approach as the first step, I'll update the patch. how
> about rust/net/socket.rs ?

That is better. But probably Eric or one of the other core maintainers
should comment. I also put kern into the name to try to make it clear
that this is not the BSD Socket kAPI, but the kernel internal API for
sockets. I don't know how important this distinction is.

	 Andrew

