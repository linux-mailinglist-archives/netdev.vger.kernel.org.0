Return-Path: <netdev+bounces-4812-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9007C70E73D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 23:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 593761C20A1C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 21:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA4ABA46;
	Tue, 23 May 2023 21:20:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70591BA31
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 21:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A04C433D2;
	Tue, 23 May 2023 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684876806;
	bh=RwgvLVvGpfdn+LqMVfNjQcMQ/w99h/FO0nnWp6+j5K8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jl9h1dPcrqWvK/3DeTeoJWRrAkfQv/GUN/cW/6DIE+55v0TZyy25M6sYKnI7gDuBd
	 GXFBZtpxIr70VUWupOaXLBHMb2E2JByDR+v0BTYaMPOu2yN6GqjsFyuraVrsmNyUu6
	 DeN9bLQAzB0iu1oaHqXGnxWfKmprxlh8A3y37O0gMHUVzDZAK4Piu9UUqWQtITqty3
	 rMCgihCl1NqmdFN4pT9rL6K0lCbvoNdZMHyPeFsMKraPnv15hdAkX/ZNEWysJXAOsN
	 mM5NcIl2TLVataqmHRAcBOZN/k9P1hyF1N0rwtT1W1tGoc4J+5wdlhntiWcK5GjT/3
	 qKVp61JNcNSCw==
Date: Tue, 23 May 2023 14:20:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Louis Peens <louis.peens@corigine.com>, David Miller
 <davem@davemloft.net>, Simon Horman <simon.horman@corigine.com>,
 netdev@vger.kernel.org, oss-drivers@corigine.com, Willem de Bruijn
 <willemb@google.com>
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
Message-ID: <20230523142005.3c5cc655@kernel.org>
In-Reply-To: <beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
References: <20230522141335.22536-1-louis.peens@corigine.com>
	<beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 May 2023 12:49:06 +0200 Paolo Abeni wrote:
> > Previously, since the introduction of the driver, RSS hashing
> > was only performed on the source and destination IP addresses
> > of UDP packets thereby limiting UDP traffic to a single queue
> > for multiple connections on the same IP address. The transport
> > layer is now included in RSS hashing for UDP traffic, which
> > was not previously the case. The reason behind the previous
> > limitation is unclear - either a historic limitation of the
> > NFP device, or an oversight.  
> 
> FTR including the transport header in RSS hash for UDP will damage
> fragmented traffic, but whoever is relaying on fragments nowadays
> should have already at least a dedicated setup.

Yup, that's the exact reason it was disabled by default, FWIW.

The Microsoft spec is not crystal clear on how to handles this:
https://learn.microsoft.com/en-us/windows-hardware/drivers/network/rss-hashing-types#ndis_hash_ipv4
There is a note saying:

  If a NIC receives a packet that has both IP and TCP headers,
  NDIS_HASH_TCP_IPV4 should not always be used. In the case of a
  fragmented IP packet, NDIS_HASH_IPV4 must be used. This includes
  the first fragment which contains both IP and TCP headers.

While NDIS_HASH_UDP_IPV4 makes no such distinction and talks only about
"presence" of the header.

Maybe we should document that device is expected not to use the UDP
header if MF is set?

