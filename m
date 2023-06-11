Return-Path: <netdev+bounces-9943-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB5D72B35E
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 20:11:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCD171C209CA
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 18:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90A3101F9;
	Sun, 11 Jun 2023 18:11:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534FBDF5C
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 18:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B83C433D2;
	Sun, 11 Jun 2023 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686507089;
	bh=Nqt9oahMGy5SNYnq9LKGg8yS/n8n9IIPaEx/e2xrT5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pUox/9NsLK9xVRCK79QhjeGNpAqq858tDPc0b11HlHfvvCS2KWR//Rfkp6viNamNC
	 azZ0bfrpFremHM9VgjAw18vP2pMo54e0BPN3rgUwsyMcuk72J3Vyl0gKMmEljgxWrH
	 3GoLqQet0SyTMQtssq2QqsMQNdch6v1/4RGau1tajFbJINduxsT5BE/aTRxIG+knbE
	 +PcAgfsFuubdo8nV0/B5ISc5MAxIZuS9gBYrjmjRyswGhYTrl9fnikYbSAmfr58AwS
	 t0LIfRIAW0T4dX0ztNzCm/ed2F5TEZd85FKvlb3AXT6Dc+ob/tu/fHG4bLEhM9ejB1
	 FrZto54/+Qzxg==
Date: Sun, 11 Jun 2023 21:11:25 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Asmaa Mnebhi <asmaa@nvidia.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org, cai.huoqing@linux.dev,
	brgl@bgdev.pl, chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230611181125.GJ12152@unreal>
References: <20230607140335.1512-1-asmaa@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607140335.1512-1-asmaa@nvidia.com>

On Wed, Jun 07, 2023 at 10:03:35AM -0400, Asmaa Mnebhi wrote:
> There is a race condition happening during shutdown due to pending napi transactions.
> Since mlxbf_gige_poll is still running, it tries to access a NULL pointer and as a
> result causes a kernel panic.
> To fix this during shutdown, invoke mlxbf_gige_remove to disable and dequeue napi.
> 
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c    | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> index 694de9513b9f..609d038b034e 100644
> --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> @@ -475,6 +475,9 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
>  {
>  	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
>  
> +	if (!priv)
> +		return 0;
> +

How can this check be correct? You are removing mlxbf_gige driver, priv
should be always exist here.

>  	unregister_netdev(priv->netdev);
>  	phy_disconnect(priv->netdev->phydev);
>  	mlxbf_gige_mdio_remove(priv);
> @@ -485,10 +488,7 @@ static int mlxbf_gige_remove(struct platform_device *pdev)
>  
>  static void mlxbf_gige_shutdown(struct platform_device *pdev)
>  {
> -	struct mlxbf_gige *priv = platform_get_drvdata(pdev);
> -
> -	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> -	mlxbf_gige_clean_port(priv);
> +	mlxbf_gige_remove(pdev);
>  }
>  
>  static const struct acpi_device_id __maybe_unused mlxbf_gige_acpi_match[] = {
> -- 
> 2.30.1
> 
> 

