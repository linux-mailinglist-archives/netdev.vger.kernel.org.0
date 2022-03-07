Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CD34CFF45
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242604AbiCGM5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbiCGM5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:57:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93C889322;
        Mon,  7 Mar 2022 04:56:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7652C61197;
        Mon,  7 Mar 2022 12:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F9AC340F3;
        Mon,  7 Mar 2022 12:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646657806;
        bh=reG5RZ7HrJK4JyufvZOAHy2tfOD1OaIgA9NSsvUAytA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M0xI2PvzdGyROJ9hMldBHjymGdSnU0N4D7niEQptgodJ7Vt+aBdirgRZ6hVlRdXFM
         JG+Y4k6HeToe7vHFyWbVnqyDlWXLpvBGaBvKpNT33PjLLZk60Di8pmYQA8PuVBrd1V
         P5iJjAGuVL9JdaZVt+N9SKYipzsowNfT4juNDGu+vvhmYuNVyWbZetgxMhKYh/6Iop
         YIUhy3jBi9IK6nUBcV+l/pnMZwrARqRnY3Ghj5RRw1Ih+MWltK8IzvtgT8TMGUY+CC
         Cw42u/hCXJ3jMFGTgAoPP3ggZrREarDbpsD/55KqE/TN6E/VVJ42Gm3E20iDvtpnxI
         n+QVEKZn/ZVgg==
Date:   Mon, 7 Mar 2022 14:56:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [PATCH v3 1/7] octeon_ep: Add driver framework and device
 initialization
Message-ID: <YiYBC/AE0ltKNS9J@unreal>
References: <20220307092646.17156-1-vburru@marvell.com>
 <20220307092646.17156-2-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307092646.17156-2-vburru@marvell.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 01:26:40AM -0800, Veerasenareddy Burru wrote:
> Add driver framework and device setup and initialization for Octeon
> PCI Endpoint NIC.
> 
> Add implementation to load module, initilaize, register network device,
> cleanup and unload module.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> Signed-off-by: Satananda Burla <sburla@marvell.com>
> ---
> V2 -> V3:
>   - fix the Title overline & underline mismatch in octeon_ep.rst,
>     reported by kernel test robot:
>     Reported-by: kernel test robot <lkp@intel.com>
> 
> V1 -> V2:
>   - split the patch into smaller patches.
>   - fix build errors observed with clang and "make W=1 C=1".
> 
>  .../device_drivers/ethernet/index.rst         |   1 +
>  .../ethernet/marvell/octeon_ep.rst            |  35 ++
>  MAINTAINERS                                   |   7 +
>  drivers/net/ethernet/marvell/Kconfig          |   1 +
>  drivers/net/ethernet/marvell/Makefile         |   1 +
>  .../net/ethernet/marvell/octeon_ep/Kconfig    |  20 +
>  .../net/ethernet/marvell/octeon_ep/Makefile   |   9 +
>  .../marvell/octeon_ep/octep_cn9k_pf.c         | 241 +++++++++
>  .../ethernet/marvell/octeon_ep/octep_config.h | 204 +++++++
>  .../marvell/octeon_ep/octep_ctrl_mbox.c       |  84 +++
>  .../marvell/octeon_ep/octep_ctrl_mbox.h       | 170 ++++++
>  .../marvell/octeon_ep/octep_ctrl_net.c        |  42 ++
>  .../marvell/octeon_ep/octep_ctrl_net.h        | 299 ++++++++++
>  .../ethernet/marvell/octeon_ep/octep_main.c   | 512 ++++++++++++++++++
>  .../ethernet/marvell/octeon_ep/octep_main.h   | 379 +++++++++++++
>  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    | 367 +++++++++++++
>  .../net/ethernet/marvell/octeon_ep/octep_rx.c |  42 ++
>  .../net/ethernet/marvell/octeon_ep/octep_rx.h | 199 +++++++
>  .../net/ethernet/marvell/octeon_ep/octep_tx.c |  43 ++
>  .../net/ethernet/marvell/octeon_ep/octep_tx.h | 284 ++++++++++
>  20 files changed, 2940 insertions(+)
>  create mode 100644 Documentation/networking/device_drivers/ethernet/marvell/octeon_ep.rst
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Kconfig
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/Makefile
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_config.h
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.h
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.h
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.c
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_main.h
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_rx.h
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.c
>  create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_tx.h

<...>

> +MODULE_AUTHOR("Veerasenareddy Burru <vburru@marvell.com>");
> +MODULE_DESCRIPTION(OCTEP_DRV_STRING);
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(OCTEP_DRV_VERSION_STR);

Please don't add driver versions to new drivers.

Thanks
