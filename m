Return-Path: <netdev+bounces-10451-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F92172E8E6
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DE051C20357
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6492DBC5;
	Tue, 13 Jun 2023 16:59:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9862233E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAE3C433D9;
	Tue, 13 Jun 2023 16:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686675583;
	bh=p3Yw2rUkTRlAoK9T2Y4CWC+o8mRVbMG5a82yEDfn6ws=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V4WAWBtcpTQSXU4tllFckqEED8+Wk6VZ2zAfiHK83vvuJj9+yqpTJb37Q95aHqzXT
	 rwLL9pZnf4gp8sMa44dw0c2StOGlyvFQa8jY0d8+r0uB/hr4Csps3xdDbEZ3CZczlr
	 PoHOYvsPZxewFVA7Gv39rPEda9uyZI7bJRMg22iH7iqFVcyCXLbq08Bp644RIq+/+A
	 dHrlOKl2KbBAxsK/j+18pPVzeo8vgW13QBPFRnAGYX2MrufFQwOT53Q4IIPwq72sqR
	 1v8GNinZ+LC+P9+mLF5apDLZ44CNo9mzLgig7J5LjqF+56mBiIQnBkl5SsICkBKtx7
	 fXA5rDs6fNKcw==
Date: Tue, 13 Jun 2023 09:59:42 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, Keith
 Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] net/tls: handle MSG_EOR for tls_device TX flow
Message-ID: <20230613095942.2b3063cb@kernel.org>
In-Reply-To: <acdb1a68-3180-0099-8520-24feb9a71efa@suse.de>
References: <20230612143833.70805-1-hare@suse.de>
	<20230612143833.70805-3-hare@suse.de>
	<f560c8fa-d6a1-7bd2-3fd7-728f90207322@grimberg.me>
	<acdb1a68-3180-0099-8520-24feb9a71efa@suse.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Jun 2023 10:11:01 +0200 Hannes Reinecke wrote:
> >> +=C2=A0=C2=A0=C2=A0 if ((msg->msg_flags & MSG_MORE) &&
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (msg->msg_flags & MSG_EOR))
> >> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EOPNOTSUPP; =20
> >=20
> > EINVAL is more appropriate I think...
> >  =20
> Guess what, that's what I did initially.
> But then when returning EINVAL we would arguably introduce a regression
> (as suddenly we'll be returning a different error code as previously).
> So with this patch we're backwards compatible.
>=20
> But that's really a quesion for Jakub: what's more appropriate here?
> Return a new error code (which describes the situation better) or stick
> with the original one (and retain compability)?

EINVAL sounds better, EOPNOTSUPP means not implemented yet, once the
thing is implemented it's natural that we'll start returning more
precise error codes.

BTW you need to respin on top of net-next, David's multi-page sendpage
has rejigged this code quite a bit.

