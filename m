Return-Path: <netdev+bounces-10973-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E11D8730E0B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 729FA281667
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0DF644;
	Thu, 15 Jun 2023 04:23:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB63625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCC2C433C8;
	Thu, 15 Jun 2023 04:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686802980;
	bh=5N8o/o183j5+lfPlQ9NzHLSv4tXsodrtqqQYeYdS7gE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PTLVkEDsiteFJLDXoFGOgt+0xzq7y8tzKRTOmXVRjARB8agqVlRCu/pvfnV2qmz5T
	 7hb9CpjBWpKBzpJXfXCuU0GJRlte2Q+t23mJWB47FORChvCGRTaeHoBFqeODWY4MA8
	 d5OpZIh7nApaCk2eUHsnokS1reIcw4+Z9VlV/2osFI9Bh0t7EiV4/vWfiFl2V5O8ZW
	 PbLUbqeYXmqcg6oRp2y4RhSrJGXaOSr1swt9PjTCAmuraOT53Wfu539PCwLBQsf5rX
	 rQQMGigKfhCdZ9nwsy7KpJXfNyXXiQJqWBWxXdXXAfzPjOLCSStDdqQ3WjIqPqs1cE
	 hmoZf3L4sC7kg==
Date: Wed, 14 Jun 2023 21:22:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, pantelis.antoniou@gmail.com,
 linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next] eth: fs_enet: fix print format for resource
 size
Message-ID: <20230614212259.1e19900c@kernel.org>
In-Reply-To: <4ebd2741-1788-dc05-2d04-448f3fea17ab@infradead.org>
References: <20230615035231.2184880-1-kuba@kernel.org>
	<4ebd2741-1788-dc05-2d04-448f3fea17ab@infradead.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 21:02:33 -0700 Randy Dunlap wrote:
> On 6/14/23 20:52, Jakub Kicinski wrote:
> > Randy forwarded report from Stephen that on PowerPC:  
> 
> Stephen forwarded report from Randy?
> 
> netdev & pantelis were cc-ed...

Ah, I misread, you were reporting to Stephen the status for the latest
linux-next!

https://lore.kernel.org/all/8f9f8d38-d9c7-9f1b-feb0-103d76902d14@infradead.org/

Seems obvious in hindsight, sorry. I'll reword when applying.

> > drivers/net/ethernet/freescale/fs_enet/mii-fec.c: In function 'fs_enet_mdio_probe':
> > drivers/net/ethernet/freescale/fs_enet/mii-fec.c:130:50: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Wformat=]
> >   130 |         snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", res.start);
> >       |                                                 ~^   ~~~~~~~~~
> >       |                                                  |      |
> >       |                                                  |      resource_size_t {aka long long unsigned int}
> >       |                                                  unsigned int
> >       |                                                 %llx
> > 
> > Use the right print format.
> > 
> > Untested, I can't repro this warning myself. With or without
> > the patch mpc512x_defconfig builds just fine.
> > 
> > Link: https://lore.kernel.org/all/8f9f8d38-d9c7-9f1b-feb0-103d76902d14@infradead.org/
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > CC: Randy Dunlap <rdunlap@infradead.org>
> > CC: pantelis.antoniou@gmail.com
> > CC: linuxppc-dev@lists.ozlabs.org  
> 
> I'm using gcc-12.2.0.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Tested-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thank you! GCC 11.1 here, FWIW.

