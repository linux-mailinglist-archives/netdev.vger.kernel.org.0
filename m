Return-Path: <netdev+bounces-8190-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CF9B723096
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3B2528101E
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9EF24EAF;
	Mon,  5 Jun 2023 20:01:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D70DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 20:01:18 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DBCFD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=RWqAgFDkRUrG8WCL//cvPEXkOMA9rPgRzUcII0DDsKI=; b=m0sZbjCwwOmbT1lQbKPC3y7olh
	j7japn7BK/5JfY4z5AX9cr2Ddr1y4qtmcpn9TddSaavcWyn5dVC9b5jhMs8yH4dUaQu2Tb4PXpvD2
	R/nBtolzMEnG/cI02QaArwMmayvEJlzBziF6X6hlPrv3YnDONSrI7RkH2Iimsa/Dqrdc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q6GNt-00Ew83-5G; Mon, 05 Jun 2023 22:00:57 +0200
Date: Mon, 5 Jun 2023 22:00:57 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Fernando Eckhardt Valle (FIPT)" <fevalle@ipt.br>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
	"anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] igc: enable Mac Address Passthrough in Lenovo
 Thunderbolt 4 Docks
Message-ID: <91983414-8df7-4cc0-9465-328d47024bcc@lunn.ch>
References: <20230605185407.5072-1-fevalle@ipt.br>
 <09c32c5a-73b4-456f-97f9-685820f3ba25@lunn.ch>
 <CPVP152MB50534DFBCF085A15E2FD37AAD84DA@CPVP152MB5053.LAMP152.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CPVP152MB50534DFBCF085A15E2FD37AAD84DA@CPVP152MB5053.LAMP152.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 07:47:43PM +0000, Fernando Eckhardt Valle (FIPT) wrote:
> 
>     Module parameters are very much frowned upon. Please try to find
>     another solution.
> 
>     What does the copy of the MAC address? Can it signal when it is done,
>     and when there is nothing to do?
> 
> 
> When the mac address passthrough feature is enabled in the computer's BIOS, it
> is necessary to copy the computer's mac address to the Ethernet device of the
> dock station. This way, the dock station's mac address will be the same as the
> computer's, and that's what should happen. However, this process is not given
> enough time to occur, hence the msleep(600), with this small delay, the dock is
> able to copy the computer's mac address.
> 
> The parameters are precisely meant to avoid having to use msleep() every time
> the module is loaded.

MAC address passthrought seems in general to be a big collection of
vendor hacks which in general are broken in most corner cases, and
even in the middle cases. What really needs to happen is that the
vendors get together and standardize on one solution, and make sure
they involved the kernel developers in the design.

O.K, so why is the kernel involved? It sounds like userspace should be
solving this. It is easy for userspace to get a notification when the
dock pops into existence. It can then walk the tree of devices and
find that the IGC is in a dock, its the first dock, not the 42nd dock
in a long chain. User space also has access to the BIOS version so it
knows the BIOS will at some point execute this proprietary extension
and copy the MAC address to one of the docks, maybe even the correct
one in the chain of 42. It can wait 1 seconds, and then down/up the
interface?

	Andrew

