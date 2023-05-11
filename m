Return-Path: <netdev+bounces-1981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B0D6FFD62
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F18922819C9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69E318C12;
	Thu, 11 May 2023 23:35:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6BCAD50
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7BAC4339B;
	Thu, 11 May 2023 23:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683848149;
	bh=0ZrlLYHFPnlwVIV60vewIGc5WisGlHI2vcaFj4dtHs8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LYz5CimzrWTqSejec/ko7q6D35BBfj+zEk6JcskvfsFS+5w90S24OcgqrTmehvWSl
	 gNV0R2ASLGsk4XOUvDf7n7U5AiYZYCVImL2qHR8I6oqsXxqPYyD8kh5+mEuJNkYYV1
	 kW/l+kZguk6vozAeikXOlycVwGaaxxE3L45NjpLAB3LDtyFmKEUWlFO6j3dSPFRHC3
	 1N77B0UmAsSTASgbVBPAE1kiaOcybTch3lpbKkmQczg/UFvg6LjU71KkW0XcZXAvav
	 fks7O9SWqKk9d1I4kBUl8Rlk0ch9kJOBUZspURt8jawn7d0eKLHCN1AIkGKeRDsoj4
	 XOm8PpBm7HmnQ==
Date: Thu, 11 May 2023 16:35:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>,
 netdev@vger.kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
 vadim.fedorenko@linux.dev, richardcochran@gmail.com,
 gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com,
 krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
 linux@armlinux.org.uk
Subject: Re: [PATCH net-next RFC v4 4/5] net: Let the active time stamping
 layer be selectable.
Message-ID: <20230511163547.120f76b8@kernel.org>
In-Reply-To: <20230511231803.oylnku5iiibgnx3z@skbuf>
References: <20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230406173308.401924-5-kory.maincent@bootlin.com>
	<20230429175807.wf3zhjbpa4swupzc@skbuf>
	<20230502130525.02ade4a8@kmaincent-XPS-13-7390>
	<20230511134807.v4u3ofn6jvgphqco@skbuf>
	<20230511083620.15203ebe@kernel.org>
	<20230511155640.3nqanqpczz5xwxae@skbuf>
	<20230511092539.5bbc7c6a@kernel.org>
	<20230511205435.pu6dwhkdnpcdu3v2@skbuf>
	<20230511160845.730688af@kernel.org>
	<20230511231803.oylnku5iiibgnx3z@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 May 2023 02:18:03 +0300 Vladimir Oltean wrote:
> > Why can't we treat ndo_hwtstamp_set() == -EOPNOTSUPP as a signal 
> > to call the PHY? ndo_hwtstamp_set() does not exist, we can give
> > it whatever semantics we want.  
> 
> Hmm, because if we do that, bridged DSA switch ports without hardware
> timestamping support and without logic to trap PTP to the CPU will just
> spew those PTP frames with PHY hardware timestamps everywhere, instead
> of just telling the user hey, the configuration isn't supported?

I see, so there is a legit reason to abort. 

We could use one of the high error codes, then, to signal 
the "I didn't care, please carry on to the PHY" condition?
-ENOTSUPP?

I guess we can add a separate "please configure traps for PTP/NTP" 
NDO, if you prefer. Mostly an implementation detail.

