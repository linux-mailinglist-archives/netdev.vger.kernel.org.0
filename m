Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB4A63D1DE
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbiK3Jab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiK3Jaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C31D37231;
        Wed, 30 Nov 2022 01:30:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30C54B81A9A;
        Wed, 30 Nov 2022 09:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03893C433C1;
        Wed, 30 Nov 2022 09:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669800625;
        bh=wVvPST3dPXmOrpfixuCqf554y8PUSwdgNopLiRwzssA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=urUMrBqoXpE62yUfKJgP9C5Q3GcKgx4Nri3iMz79ZWB9bVA8HR5tNpp2UEpFtEYck
         WqJF7JyO5x7G0fCbVc63eH7dcpS6g4lAc42OhMNxPGe92hqUB25fi89x+lMBo4eS8/
         35xlFb5sCeWlYjbJ0Lw9BtrYBMu68kBEzM+Cs5sqZOllI+xXJilYd2n67RwSufGH3N
         C6/L3PocmzuOYzMB6gUIA66x2T2ROFe5QotrRCr6cK+OcciyJx5RzbDHYw9otf6nUs
         QSM320LkFEEVFiDEuSkpD5HIU1nqCk6Voc1/Ztyl/RvzGTdqP8oumjPbJbCC48ckIs
         TYxaxFg/CAp+A==
Date:   Wed, 30 Nov 2022 11:30:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lironh@marvell.com, aayarekar@marvell.com, sedara@marvell.com,
        sburla@marvell.com, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 2/9] octeon_ep: poll for control messages
Message-ID: <Y4cirWdJipOxmNaT@unreal>
References: <20221129130933.25231-1-vburru@marvell.com>
 <20221129130933.25231-3-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129130933.25231-3-vburru@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 05:09:25AM -0800, Veerasenareddy Burru wrote:
> Poll for control messages until interrupts are enabled.
> All the interrupts are enabled in ndo_open().

So what are you saying if I have your device and didn't enable network
device, you will poll forever?

> Add ability to listen for notifications from firmware before ndo_open().
> Once interrupts are enabled, this polling is disabled and all the
> messages are processed by bottom half of interrupt handler.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> ---
> v1 -> v2:
>  * removed device status oct->status, as it is not required with the
>    modified implementation in 0001-xxxx.patch
> 
>  .../marvell/octeon_ep/octep_cn9k_pf.c         | 49 +++++++++----------
>  .../ethernet/marvell/octeon_ep/octep_main.c   | 35 +++++++++++++
>  .../ethernet/marvell/octeon_ep/octep_main.h   | 11 ++++-
>  .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  4 ++
>  4 files changed, 71 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> index 6ad88d0fe43f..ace2dfd1e918 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
> @@ -352,27 +352,36 @@ static void octep_setup_mbox_regs_cn93_pf(struct octep_device *oct, int q_no)
>  	mbox->mbox_read_reg = oct->mmio[0].hw_addr + CN93_SDP_R_MBOX_VF_PF_DATA(q_no);
>  }
>  
> -/* Mailbox Interrupt handler */
> -static void cn93_handle_pf_mbox_intr(struct octep_device *oct)
> +/* Process non-ioq interrupts required to keep pf interface running.
> + * OEI_RINT is needed for control mailbox
> + */
> +static int octep_poll_non_ioq_interrupts_cn93_pf(struct octep_device *oct)
>  {
> -	u64 mbox_int_val = 0ULL, val = 0ULL, qno = 0ULL;
> +	u64 reg0;
> +	int handled = 0;

Reversed Christmas tree.

Thanks
