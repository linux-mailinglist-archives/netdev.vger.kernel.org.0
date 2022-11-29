Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10B363B8C8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbiK2DgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235306AbiK2Df7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:35:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA4322B2F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 19:35:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4885FB81118
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3250CC433C1;
        Tue, 29 Nov 2022 03:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669692956;
        bh=3wPDDNFXl+a1vsVUbq79M+HNGcQaQBXbwaqS0gGwodE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uh3Li80sJKCzZlYwnXqWkCmemnA99C7URkzZoH7o7QPhKCHPSrq3XrGRMwB/o5t/W
         sxeZSXwpCWJNFvtCQ+OuBCJDrbxo6cGYTmEtAAJn+C+sYCM0VCxuDJ41gefilHEIzg
         HXhHPmGcvX708rkGkVfysI0fVKY0E5q1jQmkrknIMZ/DDF6X4P8xOPs6x7kse3NpgV
         7iJ+I2v4BeK7mzgwK89NQQVtOIRyFaQrBl15bHOWjjB6nsvGz2YvKRqIjCml1/6HPf
         n8xs5+MfQ36MHEOha8nDNxg9CnPxA03ZvnoazfMJGLtDOS7ZNnec5VulZXY6wSkJD0
         3NHNllxO2Dnng==
Date:   Mon, 28 Nov 2022 19:35:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [net 13/15] net/mlx5e: MACsec, remove replay window size
 limitation in offload path
Message-ID: <20221128193553.0e694508@kernel.org>
In-Reply-To: <4bc41493-f837-6536-5f10-7359cf082756@intel.com>
References: <20221124081040.171790-1-saeed@kernel.org>
        <20221124081040.171790-14-saeed@kernel.org>
        <4bc41493-f837-6536-5f10-7359cf082756@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 15:42:19 -0800 Jacob Keller wrote:
> > index c19581f1f733..72f8be65fa90 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> > @@ -229,22 +229,6 @@ static int macsec_set_replay_protection(struct mlx5_macsec_obj_attrs *attrs, voi
> >   	if (!attrs->replay_protect)
> >   		return 0;
> >   
> > -	switch (attrs->replay_window) {
> > -	case 256:
> > -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_256BIT;
> > -		break;
> > -	case 128:
> > -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_128BIT;
> > -		break;
> > -	case 64:
> > -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_64BIT;
> > -		break;
> > -	case 32:
> > -		window_sz = MLX5_MACSEC_ASO_REPLAY_WIN_32BIT;
> > -		break;
> > -	default:
> > -		return -EINVAL;
> > -	}  
> 
> What sets window_sz now? Looking at the current code wouldn't this leave 
> window_sz uninitialized and this undefined behavior of MLX5_SET? Either 
> you should just forward in attrs->replay_window and remove window_sz 
> local or drop the MLX5_SET call for setting window size?

Damn it, this is a clang warning, I need to rescind the PR :/
