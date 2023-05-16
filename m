Return-Path: <netdev+bounces-3100-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BC070573F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C1C02812DD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1F329116;
	Tue, 16 May 2023 19:36:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9F329113
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32594C4339B;
	Tue, 16 May 2023 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684265796;
	bh=OuFy3VqAIPXlxy9jiJj4Z1KMk1POVJhyIATNgEp9BiY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ebHfqCqajGW45iUzhEIDqRVSUeW5Q4Q+UyIGOYq+ywBIr6+8dJeOLg2jiHElX6GeA
	 PTpD98AJAVJOLZQVEXLScQaV1HN6Lbm0MDqnYpShsiSPHN080dyrVNKMHk6EfIeepP
	 gVRcpLNg0+ypamQdvttVkz6izNE95kr8fZAOzpOF5mWYwiFrad5gICIRMEEjcesbqT
	 2SPT7intum6X8cxdXNHuYRzDOEUB6d332yxbRvREDcAPyUHid+ZG+PTqA2pYYqzOQC
	 GRIaWGdZOyjKXjHYKryVT45Xm5X01vMrvtoOu6o7qDHhxPGr7lI5+RsZzi0A4zBCnB
	 IuY99sY2QJy9Q==
Date: Tue, 16 May 2023 12:36:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com,
 virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
 eperezma@redhat.com, xuanzhuo@linux.alibaba.com, david.marchand@redhat.com,
 netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next V2 1/2] virtio-net: convert rx mode setting to
 use workqueue
Message-ID: <20230516123635.58a20bb0@kernel.org>
In-Reply-To: <CACGkMEvCHQLFbtB2fbF27oCd5fNSjUtUOS0q-Lx7=MeYR8KzRA@mail.gmail.com>
References: <20230413121525-mutt-send-email-mst@kernel.org>
	<CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
	<20230414031947-mutt-send-email-mst@kernel.org>
	<CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
	<20230510012951-mutt-send-email-mst@kernel.org>
	<CACGkMEszPydzw_MOUOVJKBBW_8iYn66i_9OFvLDoZMH34hMx=w@mail.gmail.com>
	<20230515004422-mutt-send-email-mst@kernel.org>
	<CACGkMEv+Q2UoBarNOzKSrc3O=Wb2_73O2j9cZXFdAiLBm1qY-Q@mail.gmail.com>
	<20230515061455-mutt-send-email-mst@kernel.org>
	<CACGkMEt8QkK1PnTrRUjDbyJheBurdibr4--Es8P0Y9NZM659pQ@mail.gmail.com>
	<20230516000829-mutt-send-email-mst@kernel.org>
	<CACGkMEvCHQLFbtB2fbF27oCd5fNSjUtUOS0q-Lx7=MeYR8KzRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 12:17:50 +0800 Jason Wang wrote:
> > It's not reliable for other drivers but has been reliable for virtio.
> > I worry some software relied on this.  
> 
> It's probably fine since some device like vhost doesn't support this
> at all and we manage to survive for several years.
> 
> > You are making good points though ... could we get some
> > maintainer's feedback on this?  
> 
> That would be helpful. Jakub, any input on this?

AFAIU the question is whether .ndo_set_rx_mode needs to be reliable 
and instantaneous?  I haven't heard any complaints for it not being
immediate, and most 10G+ NICs do the config via a workqueue.

I even have an "intern task" to implement a workqueue in the core,
for this to save the boilerplate code in the drivers.

