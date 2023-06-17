Return-Path: <netdev+bounces-11676-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A9D28733EA6
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:26:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 653BE281912
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:26:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE7A46B1;
	Sat, 17 Jun 2023 06:26:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4844B111C
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761ECC433C8;
	Sat, 17 Jun 2023 06:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686983161;
	bh=rezx+M8908cDTpOHPzi+nyIHJCB2oKTpnAepFHfkj5o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LTabzfWdgptwDPUTFDIXj0nvCQveVgOBY8gKsgkSJcTUDVLxYf3ZZ6eN2R5t2N6E/
	 AFao9CPtQYQjF5cPPV49m4wGqHbOJUX05U0Y2WCAFC6EXpu/8UXKhniUpF73Egou9V
	 7E1UXW84hHr8ydcCupT2w8SMXUgFG8mT2BbtAppmUvtoQausKoMFwYW+TjI2NrxaV+
	 eOCvOhIaLSZlVJLmjlrjijReLrLwSPsv8QYwol5imNLAYKaFJ9YKurSzbuQobi5/+l
	 R5hyM2DbCXBup4UgLd/9tgrwObJvGsQPi/YOfN7YPriTHAJuZR82NvsP8po3h7TDYS
	 RL2qw4iG7CVdA==
Date: Fri, 16 Jun 2023 23:26:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Keith
 Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net/tls: handle MSG_EOR for tls_sw TX flow
Message-ID: <20230616232600.6a18f5e0@kernel.org>
In-Reply-To: <20230614062212.73288-2-hare@suse.de>
References: <20230614062212.73288-1-hare@suse.de>
	<20230614062212.73288-2-hare@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 08:22:09 +0200 Hannes Reinecke wrote:
> @@ -1287,7 +1290,7 @@ int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
>  	struct bio_vec bvec;
>  	struct msghdr msg = { .msg_flags = flags | MSG_SPLICE_PAGES, };
>  
> -	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
> +	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_EOR |
>  		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY |
>  		      MSG_NO_SHARED_FRAGS))
>  		return -EOPNOTSUPP;

you added it to sendpage_locked but not normal sendpage

