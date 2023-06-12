Return-Path: <netdev+bounces-10098-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E34A372C392
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB1A1281106
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E1D1951F;
	Mon, 12 Jun 2023 11:59:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A281800C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 11:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B8FC433EF;
	Mon, 12 Jun 2023 11:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686571170;
	bh=atLifTP2lK9VuBIheql7H5v4d+OXte16V4t0sCxgkbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qp1fvjYgbGSuo6dyAUxe2WtKwKmNNeYCFPlQcYI0qeV+Oxns1lNkM/1VRPYyfWftO
	 FEIWIuboEAA8jZtUgGp5OVAGGxr7fQWao4sDpigS4WNKk6pvmXtwthMb/OBviMSKzb
	 s7Pj024yjikssT1UFZ6QWHeJWzxnjNVqjDiOi7oVyiQy9G0DVbenaWjXqtKLuYNLdE
	 /bd14x+GziZQRxJwuEuxweL+w8dOBUPTH+7WU4nNiNba99VZMZOdOqVAgSKGWnhVQz
	 9Ua/NouiX+yNS8MIAM1dZwYIUxi7/d4sPJYl3YW6dEwfUrO1COkzu09cnbvZKJvEX1
	 75EPvITf9jSPA==
Date: Mon, 12 Jun 2023 14:59:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230612115925.GR12152@unreal>
References: <20230607140335.1512-1-asmaa@nvidia.com>
 <20230611181125.GJ12152@unreal>
 <ZIcC2Y+HHHR+7QYq@boxer>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIcC2Y+HHHR+7QYq@boxer>

On Mon, Jun 12, 2023 at 01:34:49PM +0200, Maciej Fijalkowski wrote:
> On Sun, Jun 11, 2023 at 09:11:25PM +0300, Leon Romanovsky wrote:
> > On Wed, Jun 07, 2023 at 10:03:35AM -0400, Asmaa Mnebhi wrote:
> > > There is a race condition happening during shutdown due to pending napi transactions.
> > > Since mlxbf_gige_poll is still running, it tries to access a NULL pointer and as a
> > > result causes a kernel panic.
> > > To fix this during shutdown, invoke mlxbf_gige_remove to disable and dequeue napi.
> > > 
> > > Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> > > Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> > > ---
> > >  .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c    | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> > > index 694de9513b9f..609d038b034e 100644
> > > --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> > > +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> > > @@ -475,6 +475,9 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
> > >  {
> > >  	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
> > >  
> > > +	if (!priv)
> > > +		return 0;
> > > +
> > 
> > How can this check be correct? You are removing mlxbf_gige driver, priv
> > should be always exist here.
> 
> Asmaa please include v1->v2 diff next time.
> 
> Leon, look at v1 discussion:
> https://lore.kernel.org/netdev/CH2PR12MB3895172507E1D42BBD5D4AB9D753A@CH2PR12MB3895.namprd12.prod.outlook.com/

Thanks for the link.

As far as I can tell, the calls to .shutdown() and .remove() are
mutually exclusive. It is impossible to go twice and reach scenario
which Paolo mentioned - double call to unregister_netdevice().

Thanks

> 
> > 
> > >  	unregister_netdev(priv->netdev);
> > >  	phy_disconnect(priv->netdev->phydev);
> > >  	mlxbf_gige_mdio_remove(priv);
> > > @@ -485,10 +488,7 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
> > >  
> > >  static void mlxbf_gige_shutdown(struct platform_device *pdev)
> > >  {
> > > -	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
> > > -
> > > -	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> > > -	mlxbf_gige_clean_port(priv);
> > > +	mlxbf_gige_remove(pdev);
> > >  }
> > >  
> > >  static const struct acpi_device_id __maybe_unused mlxbf_gige_acpi_match[] = {
> > > -- 
> > > 2.30.1
> > > 
> > > 
> > 

