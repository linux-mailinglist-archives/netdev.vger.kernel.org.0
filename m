Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896741DEEBD
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbgEVR6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730702AbgEVR6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 13:58:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05FD1206D5;
        Fri, 22 May 2020 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590170313;
        bh=hp6GmfozQXg3Tc4iKp5Jwbhk9bGSRYic2c9nSK3AyBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=scId0zhxmlJStQleZdrT09xZYSTQejm9lYh2sY3BxW15GUhqGYP911OH3eJksGkRS
         0//AY8MR+XM8cS8dVpnaPOaefb2WgZFA90NSkggN+5T9t+mNLedFlDV9WvX3cg7jWT
         4dDNS+N/FBfeRZs0BuzRupG8HqDBNGheEh79QiEM=
Date:   Fri, 22 May 2020 10:58:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>
Subject: Re: [PATCH v2 net-next 01/12] net: atlantic: changes for multi-TC
 support
Message-ID: <20200522105831.4ab00ca5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200522081948.167-2-irusskikh@marvell.com>
References: <20200522081948.167-1-irusskikh@marvell.com>
        <20200522081948.167-2-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 11:19:37 +0300 Igor Russkikh wrote:
> From: Dmitry Bezrukov <dbezrukov@marvell.com>
> 
> This patch contains the following changes:
> * access cfg via aq_nic_get_cfg() in aq_nic_start() and aq_nic_map_skb();
> * call aq_nic_get_dev() just once in aq_nic_map_skb();
> * move ring allocation/deallocation out of aq_vec_alloc()/aq_vec_free();
> * add the missing aq_nic_deinit() in atl_resume_common();
> * rename 'tcs' field to 'tcs_max' in aq_hw_caps_s to differentiate it from
>   the 'tcs' field in aq_nic_cfg_s, which is used for the current number of
>   TCs;
> * update _TC_MAX defines to the actual number of supported TCs;
> * move tx_tc_mode register defines slightly higher (just to keep the order
>   of definitions);
> * separate variables for TX/RX buff_size in hw_atl*_hw_qos_set();
> * use AQ_HW_*_TC instead of hardcoded magic numbers;
> * actually use the 'ret' value in aq_mdo_add_secy();

Whenever you do an enumeration like this - it's a strong indication that
those should all be separate patches. Please keep that in mind going
forward.

> Signed-off-by: Dmitry Bezrukov <dbezrukov@marvell.com>
> Co-developed-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
> index 91870ceaf3fe..4a6dfac857ca 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
> @@ -478,7 +478,7 @@ static int aq_mdo_add_secy(struct macsec_context *ctx)
>  
>  	set_bit(txsc_idx, &cfg->txsc_idx_busy);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static int aq_mdo_upd_secy(struct macsec_context *ctx)

This should have been a separate fix for sure.
