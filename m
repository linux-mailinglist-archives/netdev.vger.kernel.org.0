Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80D3FA222
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 02:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhH1AXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 20:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232682AbhH1AXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 20:23:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8761B61004;
        Sat, 28 Aug 2021 00:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630110183;
        bh=Gnsgkl78d1FFWzv5rA4d1GyvZ7QCpM6IPnBs8VN/4FQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sk4xHNdifTz0vAGxAnDcJnOdzncEGhi6+GwW63JwRD/Wq2McedvBjxcpk8I5z0LL8
         dapijynnSFb0m/EVWxExY/ZIOHuqeDoDn5FAtGhfkjBTGostjy9tP3ACbKx7J6jBX8
         7fljDqVBxmkDTWsSgmV+kH8npwd/MB3iXtcjKb8dKYcmoHqe+z/P4aH/LoOXfLDcMo
         l/stSq4Pz9rmkqTMCxZi9VYZKz4QUoRw9v3kNY3325Z6c9LTqdLsOplN2BttLCCykQ
         h7WDmNT/I1E6pRjC10RPEO+AGrmrM592AgPGxNSuu1386JOB8vNiaXpKtLkuaABLyo
         VJFsFAED68nUw==
Date:   Fri, 27 Aug 2021 17:23:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <irusskikh@marvell.com>
Subject: Re: [PATCH net 1/1] atlantic: Fix driver resume flow.
Message-ID: <20210827172302.0d6c6b6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210827115225.6964-1-skalluru@marvell.com>
References: <20210827115225.6964-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 04:52:25 -0700 Sudarsana Reddy Kalluru wrote:
> Driver crashes when restoring from the Hibernate. In the resume flow,
> driver need to clean up the older nic/vec objects and re-initialize them.
> 
> Fixes: 8aaa112a57c1d ("net: atlantic: refactoring pm logic")
> Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> ---
>  drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
> index 59253846e885..f26d03735619 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
> @@ -417,6 +417,9 @@ static int atl_resume_common(struct device *dev, bool deep)
>  	pci_restore_state(pdev);
>  
>  	if (deep) {
> +		/* Reinitialize Nic/Vecs objects */
> +		aq_nic_deinit(nic, !nic->aq_hw->aq_nic_cfg->wol);

Why does the deinit() happen on resume, not suspend?

>  		ret = aq_nic_init(nic);
>  		if (ret)
>  			goto err_exit;

