Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEDA223043
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 03:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgGQBTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 21:19:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbgGQBS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 21:18:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E1A2076D;
        Fri, 17 Jul 2020 01:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594948739;
        bh=NonWiGdMXBcYO7bWSPT/d0+vLEuL6p0OznyGZ4JRNg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wLNSbKJuXu2gU44Wip5RB1t3arpafQeXwPErwULlOi53l4EKzKsjmcyHpxpxWlvtf
         godzagC2Xsf1gJmcMJnKm833izrEo/4f4EV0loz6FPIr55Szw9JKA32EdunA4UhEg5
         LSMIJI1UgY/ry/F3+Rz4ERu0RfeN3cgTLjK9CGRs=
Date:   Thu, 16 Jul 2020 18:18:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@marvell.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 10/13] qed: add support for new port modes
Message-ID: <20200716181853.502dd619@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716115446.994-11-alobakin@marvell.com>
References: <20200716115446.994-1-alobakin@marvell.com>
        <20200716115446.994-11-alobakin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 14:54:43 +0300 Alexander Lobakin wrote:
> These ports ship on new boards revisions and are supported by newer
> firmware versions.
> 
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

What is the driver actually doing with them, tho?

Looks like you translate some firmware specific field to a driver
specific field, but I can't figure out what part of the code cares
about hw_info.port_mode

> diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
> index 6a1d12da7910..63fcbd5a295a 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed.h
> +++ b/drivers/net/ethernet/qlogic/qed/qed.h
> @@ -257,6 +257,11 @@ enum QED_PORT_MODE {
>  	QED_PORT_MODE_DE_1X25G,
>  	QED_PORT_MODE_DE_4X25G,
>  	QED_PORT_MODE_DE_2X10G,
> +	QED_PORT_MODE_DE_2X50G_R1,
> +	QED_PORT_MODE_DE_4X50G_R1,
> +	QED_PORT_MODE_DE_1X100G_R2,
> +	QED_PORT_MODE_DE_2X100G_R2,
> +	QED_PORT_MODE_DE_1X100G_R4,
>  };
>  
>  enum qed_dev_cap {
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> index d929556247a5..4bad836d0f74 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -4026,6 +4026,21 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
>  	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G:
>  		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X25G;
>  		break;
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1:
> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X50G_R1;
> +		break;
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1:
> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X50G_R1;
> +		break;
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2:
> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X100G_R2;
> +		break;
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2:
> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_2X100G_R2;
> +		break;
> +	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4:
> +		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_1X100G_R4;
> +		break;
>  	default:
>  		DP_NOTICE(p_hwfn, "Unknown port mode in 0x%08x\n", core_cfg);
>  		break;
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
> index a4a845579fd2..debc55923251 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
> +++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
> @@ -13015,6 +13015,11 @@ struct nvm_cfg1_glob {
>  #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_1X25G			0xd
>  #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G			0xe
>  #define NVM_CFG1_GLOB_NETWORK_PORT_MODE_2X10G			0xf
> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1		0x11
> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1		0x12
> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2		0x13
> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2		0x14
> +#define NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4		0x15
>  
>  	u32							e_lane_cfg1;
>  	u32							e_lane_cfg2;

