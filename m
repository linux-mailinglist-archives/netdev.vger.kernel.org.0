Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8246B6DC0CF
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 19:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDIRLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 13:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjDIRLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 13:11:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECDB30E1
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:11:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54EC360AFD
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 17:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F6EC433D2;
        Sun,  9 Apr 2023 17:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681060307;
        bh=ainltJ21yJAmAdCR/L+gXRmCPWPf4Nxycck6QaXIpKQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lGWWLd8P9cqXJPX6qIe8onCCAngn2yJD755+qdq0ZAcCtOB5Pxz9YE4bxaQM3uqhf
         OUsCA2qlCYCrARmlws0D0jVfVVZ0qbFGhQyIqYNu+r5AGdjfIA+Sw9rwCq4aHVCob1
         g1hD+NNC7H/Cvz0OWPKQXbo3b9ArLHLmcBiam8YXo+6c9H/en5LE+DG6SwKW6nZdX9
         ph+iqNLLZWBY9a3mjqndqNK4GuHp1nRmLIh/ks9ya2rpbypJNxUDIyQfxFazC30exp
         YOM8TAMEqS62jCLrPS25qT3RABpiSUBuT40RFtEkpCWOp6MRu5kRwSWJTZL1P/Urgn
         BVV7FJ/UM3MVw==
Date:   Sun, 9 Apr 2023 20:11:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the clients
Message-ID: <20230409171143.GH182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-14-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-14-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:42PM -0700, Shannon Nelson wrote:
> When the Core device gets an event from the device, or notices
> the device FW to be up or down, it needs to send those events
> on to the clients that have an event handler.  Add the code to
> pass along the events to the clients.
> 
> The entry points pdsc_register_notify() and pdsc_unregister_notify()
> are EXPORTed for other drivers that want to listen for these events.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
>  drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
>  drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
>  include/linux/pds/pds_common.h             |  2 ++
>  4 files changed, 39 insertions(+)
> 
> diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
> index 25c7dd0d37e5..bb18ac1aabab 100644
> --- a/drivers/net/ethernet/amd/pds_core/adminq.c
> +++ b/drivers/net/ethernet/amd/pds_core/adminq.c
> @@ -27,11 +27,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
>  		case PDS_EVENT_LINK_CHANGE:
>  			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
>  				 ecode, eid);
> +			pdsc_notify(PDS_EVENT_LINK_CHANGE, comp);

Aren't you "resending" standard netdev event?
It will be better to send only custom, specific to pds_core events,
while leaving general ones to netdev.

>  			break;
>  
>  		case PDS_EVENT_RESET:
>  			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
>  				 ecode, eid);
> +			pdsc_notify(PDS_EVENT_RESET, comp);

We can argue if clients should get this event. Once reset is detected,
the pds_core should close devices by deleting aux drivers.

Thanks

>  			break;
>  
>  		case PDS_EVENT_XCVR:
> diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
> index ec088d490d34..b2790be0fc46 100644
> --- a/drivers/net/ethernet/amd/pds_core/core.c
> +++ b/drivers/net/ethernet/amd/pds_core/core.c
> @@ -6,6 +6,25 @@
>  
>  #include "core.h"
>  
> +static BLOCKING_NOTIFIER_HEAD(pds_notify_chain);
> +
> +int pdsc_register_notify(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&pds_notify_chain, nb);
> +}
> +EXPORT_SYMBOL_GPL(pdsc_register_notify);
> +
> +void pdsc_unregister_notify(struct notifier_block *nb)
> +{
> +	blocking_notifier_chain_unregister(&pds_notify_chain, nb);
> +}
> +EXPORT_SYMBOL_GPL(pdsc_unregister_notify);
> +
> +void pdsc_notify(unsigned long event, void *data)
> +{
> +	blocking_notifier_call_chain(&pds_notify_chain, event, data);
> +}
> +
>  void pdsc_intr_free(struct pdsc *pdsc, int index)
>  {
>  	struct pdsc_intr_info *intr_info;
> @@ -513,12 +532,19 @@ void pdsc_stop(struct pdsc *pdsc)
>  
>  static void pdsc_fw_down(struct pdsc *pdsc)
>  {
> +	union pds_core_notifyq_comp reset_event = {
> +		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
> +		.reset.state = 0,
> +	};
> +
>  	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
>  		dev_err(pdsc->dev, "%s: already happening\n", __func__);
>  		return;
>  	}
>  
> +	/* Notify clients of fw_down */
>  	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
> +	pdsc_notify(PDS_EVENT_RESET, &reset_event);
>  
>  	pdsc_mask_interrupts(pdsc);
>  	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
> @@ -526,6 +552,10 @@ static void pdsc_fw_down(struct pdsc *pdsc)
>  
>  static void pdsc_fw_up(struct pdsc *pdsc)
>  {
> +	union pds_core_notifyq_comp reset_event = {
> +		.reset.ecode = cpu_to_le16(PDS_EVENT_RESET),
> +		.reset.state = 1,
> +	};
>  	int err;
>  
>  	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
> @@ -541,9 +571,11 @@ static void pdsc_fw_up(struct pdsc *pdsc)
>  	if (err)
>  		goto err_out;
>  
> +	/* Notify clients of fw_up */
>  	pdsc->fw_recoveries++;
>  	devlink_health_reporter_state_update(pdsc->fw_reporter,
>  					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
> +	pdsc_notify(PDS_EVENT_RESET, &reset_event);
>  
>  	return;
>  
> diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
> index aab4986007b9..2215e4915e6a 100644
> --- a/drivers/net/ethernet/amd/pds_core/core.h
> +++ b/drivers/net/ethernet/amd/pds_core/core.h
> @@ -310,6 +310,9 @@ int pdsc_start(struct pdsc *pdsc);
>  void pdsc_stop(struct pdsc *pdsc);
>  void pdsc_health_thread(struct work_struct *work);
>  
> +int pdsc_register_notify(struct notifier_block *nb);
> +void pdsc_unregister_notify(struct notifier_block *nb);
> +void pdsc_notify(unsigned long event, void *data);
>  int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
>  int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
>  
> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
> index 898f3c7b14b7..17708a142349 100644
> --- a/include/linux/pds/pds_common.h
> +++ b/include/linux/pds/pds_common.h
> @@ -91,5 +91,7 @@ enum pds_core_logical_qtype {
>  	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
>  };
>  
> +int pdsc_register_notify(struct notifier_block *nb);
> +void pdsc_unregister_notify(struct notifier_block *nb);
>  void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
>  #endif /* _PDS_COMMON_H_ */
> -- 
> 2.17.1
> 
