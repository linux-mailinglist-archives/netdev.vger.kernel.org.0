Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051EE674A5B
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 04:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjATDqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 22:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjATDqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 22:46:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABD7A2951
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 19:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D7961DE1
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73ACC433F0;
        Fri, 20 Jan 2023 03:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674186393;
        bh=+P96645N2McSKBydTPAISCtmeAHWXNMdGFUFfDwJoNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MqBX8D1xNtNrFEZjnlZ1Hch4X7FyvxMczFiimT/NFhMmQRG7k+AJ9fvpxdOeDMdc4
         Dejr1mbyd6lz3Bn4ZFCwrYfPza56j1cW1qw1za7MqG4AHa4aMcgilUlgJlmwnyB2G2
         vlJwCNjQ6QwJJ9foZH7GmGHSPYKU+M2IsjpCUcH/Y0eFnqrAOm9jncD/PBBgk/zvbZ
         2HlLfCo5/dfiXpDBQVLdGbwZdZfSArtEyQv1uLYP2Zn/2AIrOOTQAhTBRH5p4bd7EJ
         Mf3KkRKHJXro0EDySUDFz7C/ai2Nr+Vxy8DUj8rzgJWfKqPv3YhsNuOsLblPk+wPS1
         j27LYHH8Lj9jA==
Date:   Thu, 19 Jan 2023 19:46:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <20230119194631.1b9fef95@kernel.org>
In-Reply-To: <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
References: <20230118183602.124323-1-saeed@kernel.org>
        <20230118183602.124323-4-saeed@kernel.org>
        <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
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

On Wed, 18 Jan 2023 13:33:56 -0800 Jacob Keller wrote:
> > The adjtime function supports using hardware to set the clock offset when
> > the delta was supported by the hardware. When the delta is not supported by
> > the hardware, the driver handles adjusting the clock. The newly-introduced
> > adjphase function is similar to the adjtime function, except it guarantees
> > that a provided clock offset will be used directly by the hardware to
> > adjust the PTP clock. When the range is not acceptable by the hardware, an
> > error is returned.
> 
> Makes sense. Once you've verified that the delta is within the accepted
> range you can just re-use the existing adjtime function.

Seems like we should add a "max_time_adj" to struct ptp_clock_info
and let the core call adjphase if the offset is small enough to fit.
Instead of having all drivers redirect the calls internally.
