Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA6669700B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjBNVtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbjBNVts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:49:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615C229E3F
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:49:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC890CE22BF
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 21:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD046C433D2;
        Tue, 14 Feb 2023 21:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676411384;
        bh=2+zh1hBbcD04DtuCHDxl5Q70Hx8Q8gOyxrLzinCUPE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AEHB0QE5uvgIxoZbEXF11X8OSBab7ngKIr8/u0uUaj/+Tci+wMqs2q3EEhzB6B3NV
         0zzzh5URE93p3GLIiPhY32Q7qOcpTjP0hpl9+HHEepQ+93ynJLba+N5YGXyT9rN5Uk
         bfaHF7ZJB6KCqGOkgTHv2R8LNQHkU7sY7n/ca8Ut/cszoEdElxHRpD5tgMKnTcHbTa
         Zv67ssuCIjgcnGMidqrT/uzLmlAMoh09KPV60LMuWtybbMSvzPA545mMxSdjCEjhEH
         YujebxwLi4X084V+9Bbmf/IHO4Ume+Cwft9ItVlRCEQMNoNWqPqDc49kNBXCHJig46
         DCHeYh6sY/0hQ==
Date:   Tue, 14 Feb 2023 13:49:42 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Message-ID: <Y+wB9hcZVUuaYj5H@x130>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
 <23c46b99-1fbf-0155-b2d0-2ea3d1fe9d17@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <23c46b99-1fbf-0155-b2d0-2ea3d1fe9d17@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 Feb 18:07, Alexander Lobakin wrote:
>From: Saeed Mahameed <saeed@kernel.org>
>Date: Fri, 10 Feb 2023 14:18:07 -0800
>

[...]

> +static int mlx5_devlink_esw_multiport_set(struct devlink *devlink, u32 id,
>> +					  struct devlink_param_gset_ctx *ctx)
>> +{
>> +	struct mlx5_core_dev *dev = devlink_priv(devlink);
>> +	int err = 0;
>> +
>> +	if (!MLX5_ESWITCH_MANAGER(dev))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (ctx->val.vbool)
>> +		err = mlx5_lag_mpesw_enable(dev);
>> +	else
>> +		mlx5_lag_mpesw_disable(dev);
>> +
>> +	return err;
>
>How about
>
>	if (ctx->val.vbool)
>		return mlx5_lag_mpesw_enable(dev);
>	else
>		mlx5_lag_mpesw_disable(dev);
>
>	return 0;
>
>?

Makes sense, will do the change.

Thanks.

