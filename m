Return-Path: <netdev+bounces-8584-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01DD3724A31
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5558280E4D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815001F177;
	Tue,  6 Jun 2023 17:29:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5F419915
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D52C433EF;
	Tue,  6 Jun 2023 17:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686072562;
	bh=GSRh14Aqah5xb9rO8ArWlHhVJE1kdARWsj6iqT8UNDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TKRaCiyzHfQfDkSg5YxMAIUdIkhmKw6vVw35E1NpVFMpfRG6MB8+eyGxuy3prFzpM
	 OchYQ96sfghOkoLlRv5gRvPnqkN9PT3IjQhxjkCNfm3GN1R6uzsG7Xficjf6mVqKM+
	 bziJcc1dPFrVYyTyw09gPTvmbdFgjjv0mSSDIaAxJvbK+39vnzq5vu6SjaPMsL1+YE
	 3HvY9339yvoHuPdkcAfOhOOcAx4elqYG37smMT6jOyqPFnuyb2GLjWVFvD77ZIzz1l
	 gpvZ4dYp08AGcBVVdR3tRa+Ho+QduEWt3Hv2GgpfvPGv08T9DbXvkicUGrCBzWrfEy
	 0HGJp2l76kCLg==
Date: Tue, 6 Jun 2023 10:29:21 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
 edumazet@google.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
 brgl@bgdev.pl, chenhao288@hisilicon.com, huangguangbin2@huawei.com, David
 Thompson  <davthompson@nvidia.com>
Subject: Re: [PATCH net-next v1 1/1] mlxbf_gige: Fix kernel panic at
 shutdown
Message-ID: <20230606102921.653a4fd2@kernel.org>
In-Reply-To: <9df69dcc0554a3818689e30b06601d33fe37457c.camel@redhat.com>
References: <20230602182443.25514-1-asmaa@nvidia.com>
	<9df69dcc0554a3818689e30b06601d33fe37457c.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 06 Jun 2023 12:47:09 +0200 Paolo Abeni wrote:
> >  static void mlxbf_gige_shutdown(struct platform_device *pdev)
> >  {
> > -	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
> > -
> > -	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> > -	mlxbf_gige_clean_port(priv);
> > +	mlxbf_gige_remove(pdev);
> >  }
> >  
> >  static const struct acpi_device_id __maybe_unused mlxbf_gige_acpi_match[] = {  
> 
> if the device goes through both shutdown() and remove(), the netdevice
> will go through unregister_netdevice() 2 times, which is wrong. Am I
> missing something relevant?

Good point, mlxbf_gige_remove() needs to check that the priv pointer
is not NULL.
-- 
pw-bot: cr

