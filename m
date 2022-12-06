Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B22E644103
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbiLFKLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbiLFKKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:10:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2232B180;
        Tue,  6 Dec 2022 02:05:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F158C615DC;
        Tue,  6 Dec 2022 10:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF534C43155;
        Tue,  6 Dec 2022 10:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670321124;
        bh=zAR2ZwReyK2Gtgq5zewd/xcIBPQR360V27DsMylLTWE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m0RFQtBQvOB7bHFIdbOupUQ1a0qAppDjTDha9Ss908R8wCUUHByP/xnxp4RpM9cIH
         18fvsN2zQiZPDR2L0dZw5w46ulr2toDALvc74oZGZ1WaL2BBkxal7QCfFbKklZE3Iq
         qJ/o86mS01d3gY5EYxy6HArht/7oAC+L7zIk2PoqOp97pDi0ROvzdQY2RI+BY9Bs5X
         JT8uYNoEY3Ni96NTfVvI2CLiK+VWFOcwLJaYjhxTDBcomFiu96zlVjQoPq+wqlTHu6
         D+hsEL/j5jN1clqeihoK7osAqqB05qZxu0s2BaXTkZ85atO3iR8FwOmH84JZ6G6DEP
         Uy6XirS7d4/aw==
Date:   Tue, 6 Dec 2022 12:05:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 net-next 0/6] net: ethernet: ti: am65-cpsw: Fix set
 channel operation
Message-ID: <Y48T4OduISrVD4HR@unreal>
References: <20221206094419.19478-1-rogerq@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206094419.19478-1-rogerq@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 11:44:13AM +0200, Roger Quadros wrote:
> Hi,
> 
> This contains a critical bug fix for the recently merged suspend/resume
> support [1] that broke set channel operation. (ethtool -L eth0 tx <n>)
> 
> As there were 2 dependent patches on top of the offending commit [1]
> first revert them and then apply them back after the correct fix.

Why did you chose revert and reapply almost same patch instead of simply
fixing what is missing?

Thanks

> 
> [1] fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")
> 
> cheers,
> -roger
> 
> Changelog:
> 
> v5:
> - Change reset failure error code from -EBUSY to -ETIMEDOUT
> 
> v4:
> - move am65_cpsw_nuss_ndev_add_tx_napi() earlier to avoid declaration.
> - print error and error out if soft RESET failed in
>   am65_cpsw_nuss_ndo_slave_open()
> - move struct 'am65_cpsw_host *host' where 'common' is defined.
> 
> v3:
> - revert offending commit before applying the updated patch.
> - drop optimization patch to be sent separately.
> 
> v2:
> - Fix build warning
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c:562:13: warning: variable 'tmo' set but not used [-Wunused-but-set-variable]
> 
> Roger Quadros (6):
>   Revert "net: ethernet: ti: am65-cpsw: Fix hardware switch mode on
>     suspend/resume"
>   Revert "net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after
>     suspend/resume"
>   Revert "net: ethernet: ti: am65-cpsw: Add suspend/resume support"
>   net: ethernet: ti: am65-cpsw: Add suspend/resume support
>   net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after
>     suspend/resume
>   net: ethernet: ti: am65-cpsw: Fix hardware switch mode on
>     suspend/resume
> 
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 197 ++++++++++++-----------
>  1 file changed, 105 insertions(+), 92 deletions(-)
> 
> -- 
> 2.17.1
> 
