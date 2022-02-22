Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D664C01F4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 20:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235144AbiBVTXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 14:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiBVTXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 14:23:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0950514031
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 11:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9100D615F4
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 19:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35EAC340E8;
        Tue, 22 Feb 2022 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645557801;
        bh=YlwFW94DGwhiU90dh9hY5Z3NHM4JPWKKRkvp7821tAY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xp9ml0z3bLFUyN0nlyhXXzg3rJPHXCcSMK7qKhux18qUG/AJb20fLhZPA1VppxD2Y
         izxiWc+EiqD02f1xwlAixc7L1XQJaLM5XdOA7Tpij0Iyfnj0NtJlihtbAhsVVnHZQ4
         oMy0NEIgmslvJHFd3s9Ym26PGV5SJ1N9A3oOd4uIuF7OH0PJNSpJ6vtEtkUNG+O3Ne
         mFltUGhLyib6wxSaowkkD0R5iE43Lr2xzwuj2lCMR6rhvV2NwXShBobhduDdevQ3nE
         JK36A8JtYxR+1CNpE/k3dv+p/lYmRbQSDOKjvurHwYYgF74ASi+45EPop63tOKefMO
         NfME6tBHPYyEg==
Date:   Tue, 22 Feb 2022 11:23:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com,
        Somnath Kotur <somnath.kotur@broadcom.com>
Subject: Re: [PATCH net 1/7] bnxt_en: Fix active FEC reporting to ethtool
Message-ID: <20220222112320.1a12b91c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1645347953-27003-2-git-send-email-michael.chan@broadcom.com>
References: <1645347953-27003-1-git-send-email-michael.chan@broadcom.com>
        <1645347953-27003-2-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Feb 2022 04:05:47 -0500 Michael Chan wrote:
> From: Somnath Kotur <somnath.kotur@broadcom.com>
> 
> ethtool --show-fec <interface> does not show anything when the Active
> FEC setting in the chip is set to None.  Fix it to properly return
> ETHTOOL_FEC_OFF in that case.

Just to be clear - this means:
 - the chip supports FEC but None is selected? Or
 - the chip does not support FEC?

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index 003330e8cd58..e195f4a669d8 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -1969,6 +1969,9 @@ static int bnxt_get_fecparam(struct net_device *dev,
>  	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_RS272_IEEE_ACTIVE:
>  		fec->active_fec |= ETHTOOL_FEC_LLRS;
>  		break;
> +	case PORT_PHY_QCFG_RESP_ACTIVE_FEC_FEC_NONE_ACTIVE:
> +		fec->active_fec |= ETHTOOL_FEC_OFF;
> +		break;
>  	}
>  	return 0;
>  }

