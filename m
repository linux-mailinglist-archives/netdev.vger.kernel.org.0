Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A9C24DEE1
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 19:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgHURtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 13:49:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:21552 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726803AbgHURtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 13:49:10 -0400
IronPort-SDR: umyPAOJhWWyfLxk4smoyrJyrcAsTtHEtkhMVymzOutAezmgBJNGoj5XYxNwFjURmgAK7dUjk+g
 VsyDOb+IcTFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="154868067"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="154868067"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:49:09 -0700
IronPort-SDR: 7klViRmDc9/Ba1ZQ3NWudYnLU55Lf/gLhioQ/hFlekQrTybP4P2g2ufySVB6OOYUSIVhVFRdeN
 F8f3sMouGjYw==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="293898954"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.38.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 10:49:08 -0700
Date:   Fri, 21 Aug 2020 10:49:07 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Alexander Lobakin" <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH net-next 07/11] qed: use devlink logic to report errors
Message-ID: <20200821104907.00004607@intel.com>
In-Reply-To: <20200727184310.462-8-irusskikh@marvell.com>
References: <20200727184310.462-1-irusskikh@marvell.com>
        <20200727184310.462-8-irusskikh@marvell.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Igor Russkikh wrote:

> Use devlink_health_report to push error indications.
> We implement this in qede via callback function to make it possible
> to reuse the same for other drivers sitting on top of qed in future.
> 
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_devlink.c | 17 +++++++++++++++++
>  drivers/net/ethernet/qlogic/qed/qed_devlink.h |  2 ++
>  drivers/net/ethernet/qlogic/qed/qed_main.c    |  1 +
>  drivers/net/ethernet/qlogic/qede/qede.h       |  1 +
>  drivers/net/ethernet/qlogic/qede/qede_main.c  |  5 ++++-
>  include/linux/qed/qed_if.h                    |  3 +++
>  6 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
> index 843a35f14cca..ffe776a4f99a 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
> @@ -14,6 +14,23 @@ enum qed_devlink_param_id {
>  	QED_DEVLINK_PARAM_ID_IWARP_CMT,
>  };
>  
> +struct qed_fw_fatal_ctx {
> +	enum qed_hw_err_type err_type;
> +};
> +
> +int qed_report_fatal_error(struct devlink *devlink, enum qed_hw_err_type err_type)
> +{
> +	struct qed_devlink *qdl = devlink_priv(devlink);
> +	struct qed_fw_fatal_ctx fw_fatal_ctx = {
> +		.err_type = err_type,
> +	};
> +
> +	devlink_health_report(qdl->fw_reporter,
> +			      "Fatal error reported", &fw_fatal_ctx);
> +
> +	return 0;
> +}
> +
>  static const struct devlink_health_reporter_ops qed_fw_fatal_reporter_ops = {
>  		.name = "fw_fatal",
>  };
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
> index c68ecf778826..ccc7d1d1bfd4 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_devlink.h
> +++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
> @@ -15,4 +15,6 @@ void qed_devlink_unregister(struct devlink *devlink);
>  void qed_fw_reporters_create(struct devlink *devlink);
>  void qed_fw_reporters_destroy(struct devlink *devlink);
>  
> +int qed_report_fatal_error(struct devlink *dl, enum qed_hw_err_type err_type);
> +
>  #endif
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
> index d1a559ccf516..a64d594f9294 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> @@ -3007,6 +3007,7 @@ const struct qed_common_ops qed_common_ops_pass = {
>  	.update_msglvl = &qed_init_dp,
>  	.devlink_register = qed_devlink_register,
>  	.devlink_unregister = qed_devlink_unregister,
> +	.report_fatal_error = qed_report_fatal_error,
>  	.dbg_all_data = &qed_dbg_all_data,
>  	.dbg_all_data_size = &qed_dbg_all_data_size,
>  	.chain_alloc = &qed_chain_alloc,
> diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
> index 1f0e7505a973..3efc5899f656 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede.h
> +++ b/drivers/net/ethernet/qlogic/qede/qede.h
> @@ -264,6 +264,7 @@ struct qede_dev {
>  
>  	struct bpf_prog			*xdp_prog;
>  
> +	enum qed_hw_err_type		last_err_type;
>  	unsigned long			err_flags;
>  #define QEDE_ERR_IS_HANDLED		31
>  #define QEDE_ERR_ATTN_CLR_EN		0
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
> index 7c2d948b2035..df437c3f1fc9 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> @@ -1181,7 +1181,6 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
>  		}
>  	} else {
>  		struct net_device *ndev = pci_get_drvdata(pdev);
> -

should have left this blank line (there should always be a blank line
after declarations.)


>  		edev = netdev_priv(ndev);
>  
>  		if (edev && edev->devlink) {

I think I mentioned this check in one of my other responses.

> @@ -2603,6 +2602,9 @@ static void qede_generic_hw_err_handler(struct qede_dev *edev)
>  		  "Generic sleepable HW error handling started - err_flags 0x%lx\n",
>  		  edev->err_flags);
>  
> +	if (edev->devlink)
> +		edev->ops->common->report_fatal_error(edev->devlink, edev->last_err_type);
> +
>  	/* Trigger a recovery process.
>  	 * This is placed in the sleep requiring section just to make
>  	 * sure it is the last one, and that all the other operations
> @@ -2663,6 +2665,7 @@ static void qede_schedule_hw_err_handler(void *dev,
>  		return;
>  	}
>  
> +	edev->last_err_type = err_type;
>  	qede_set_hw_err_flags(edev, err_type);
>  	qede_atomic_hw_err_handler(edev);
>  	set_bit(QEDE_SP_HW_ERR, &edev->sp_flags);
> diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
> index 30fe06fe06a0..1297726f2b25 100644
> --- a/include/linux/qed/qed_if.h
> +++ b/include/linux/qed/qed_if.h
> @@ -906,6 +906,9 @@ struct qed_common_ops {
>  
>  	int (*dbg_all_data_size) (struct qed_dev *cdev);
>  
> +	int		(*report_fatal_error)(struct devlink *devlink,

way too many extra spaces here, doesn't even match the line above,
Please just do
\tint (*foo)(arg, arg, ...)

> +					      enum qed_hw_err_type err_type);
> +
>  /**
>   * @brief can_link_change - can the instance change the link or not
>   *


