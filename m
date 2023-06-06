Return-Path: <netdev+bounces-8396-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00320723E88
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59BF01C20E1C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8A52A6E7;
	Tue,  6 Jun 2023 09:56:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6A9294DC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:56:54 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D68E79
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686045412; x=1717581412;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xEynJz9AB3jf5azRasYeZne2KYih1icg4WDIz7g/rHk=;
  b=IYZ7wXEAX58mvb1WX4KIG+6atrcbn64KzMvePl17+Qmm8+v7gEqcgIkh
   FGTSVtPFXvQ79PhyPz/riSded/7+/RCFNVAv6+5zsqkdfbqvCQVgexZgk
   zsA7pETsfH1QXda4TQAMiP9VuGwcEzRfHTtvIcwZaLCpX1rdVddtiKhff
   N/PDI3+YnSmGV9Jy7lJTZzUTqN8Czld+yR/bbbE/sYjgomCZ7Wgv+JuQY
   LSaHDl/AluNHPwIGCtVnyIcSxbLN6yQEkM1WQmirFsQanP20vVtXImYO0
   VSuBWl/eY60OkWzjEEK+EvlxLJM/zdG0TRaaH1TsXXs/9oZWG7vAXanY8
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="219047637"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 02:56:51 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 02:56:50 -0700
Received: from DEN-LT-70577 (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 02:56:49 -0700
Date: Tue, 6 Jun 2023 09:56:48 +0000
From: Daniel Machon <daniel.machon@microchip.com>
To: Dave Ertman <david.m.ertman@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 04/10] ice: implement lag netdev event handler
Message-ID: <20230606095648.xy5d7mdzqyhqwqdg@DEN-LT-70577>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
 <20230605182258.557933-5-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230605182258.557933-5-david.m.ertman@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> The event handler for LAG will create a work item to place on the ordered
> workqueue to be processed.
> 
> Add in defines for training packets and new recipes to be used by the
> switching block of the HW for LAG packet steering.
> 
> Update the ice_lag struct to reflect the new processing methodology.
> 
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lag.c      | 125 ++++++++++++++++--
>  drivers/net/ethernet/intel/ice/ice_lag.h      |  31 ++++-
>  drivers/net/ethernet/intel/ice/ice_virtchnl.c |   2 +
>  3 files changed, 144 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
> index 73bfc5cd8b37..529abfb904d0 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lag.c
> +++ b/drivers/net/ethernet/intel/ice/ice_lag.c
> @@ -56,11 +56,10 @@ static void ice_lag_set_backup(struct ice_lag *lag)
>   */
>  static void ice_display_lag_info(struct ice_lag *lag)
>  {
> -       const char *name, *peer, *upper, *role, *bonded, *primary;
> +       const char *name, *upper, *role, *bonded, *primary;
>         struct device *dev = &lag->pf->pdev->dev;
> 
>         name = lag->netdev ? netdev_name(lag->netdev) : "unset";
> -       peer = lag->peer_netdev ? netdev_name(lag->peer_netdev) : "unset";
>         upper = lag->upper_netdev ? netdev_name(lag->upper_netdev) : "unset";
>         primary = lag->primary ? "TRUE" : "FALSE";
>         bonded = lag->bonded ? "BONDED" : "UNBONDED";
> @@ -82,8 +81,8 @@ static void ice_display_lag_info(struct ice_lag *lag)
>                 role = "ERROR";
>         }
> 
> -       dev_dbg(dev, "%s %s, peer:%s, upper:%s, role:%s, primary:%s\n", name,
> -               bonded, peer, upper, role, primary);
> +       dev_dbg(dev, "%s %s, upper:%s, role:%s, primary:%s\n", name, bonded,
> +               upper, role, primary);
>  }
> 
>  /**
> @@ -198,7 +197,6 @@ ice_lag_unlink(struct ice_lag *lag,
>                 lag->upper_netdev = NULL;
>         }
> 
> -       lag->peer_netdev = NULL;
>         ice_set_rdma_cap(pf);
>         lag->bonded = false;
>         lag->role = ICE_LAG_NONE;
> @@ -288,6 +286,60 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
>         ice_display_lag_info(lag);
>  }
> 
> +/**
> + * ice_lag_process_event - process a task assigned to the lag_wq
> + * @work: pointer to work_struct
> + */
> +static void ice_lag_process_event(struct work_struct *work)
> +{
> +       struct netdev_notifier_changeupper_info *info;
> +       struct ice_lag_work *lag_work;
> +       struct net_device *netdev;
> +       struct list_head *tmp, *n;
> +       struct ice_pf *pf;
> +
> +       lag_work = container_of(work, struct ice_lag_work, lag_task);
> +       pf = lag_work->lag->pf;
> +
> +       mutex_lock(&pf->lag_mutex);
> +       lag_work->lag->netdev_head = &lag_work->netdev_list.node;
> +
> +       switch (lag_work->event) {
> +       case NETDEV_CHANGEUPPER:
> +               info = &lag_work->info.changeupper_info;
> +               if (ice_is_feature_supported(pf, ICE_F_SRIOV_LAG))
> +                       ice_lag_changeupper_event(lag_work->lag, info);
> +               break;
> +       case NETDEV_BONDING_INFO:
> +               ice_lag_info_event(lag_work->lag, &lag_work->info.bonding_info);
> +               break;
> +       case NETDEV_UNREGISTER:
> +               if (ice_is_feature_supported(pf, ICE_F_SRIOV_LAG)) {
> +                       netdev = lag_work->info.bonding_info.info.dev;
> +                       if ((netdev == lag_work->lag->netdev ||
> +                            lag_work->lag->primary) && lag_work->lag->bonded)
> +                               ice_lag_unregister(lag_work->lag, netdev);
> +               }
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       /* cleanup resources allocated for this work item */
> +       list_for_each_safe(tmp, n, &lag_work->netdev_list.node) {
> +               struct ice_lag_netdev_list *entry;
> +
> +               entry = list_entry(tmp, struct ice_lag_netdev_list, node);
> +               list_del(&entry->node);
> +               kfree(entry);
> +       }
> +       lag_work->lag->netdev_head = NULL;
> +
> +       mutex_unlock(&pf->lag_mutex);
> +
> +       kfree(work);
> +}
> +
>  /**
>   * ice_lag_event_handler - handle LAG events from netdev
>   * @notif_blk: notifier block registered by this netdev
> @@ -299,31 +351,79 @@ ice_lag_event_handler(struct notifier_block *notif_blk, unsigned long event,
>                       void *ptr)
>  {
>         struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
> +       struct net_device *upper_netdev;
> +       struct ice_lag_work *lag_work;
>         struct ice_lag *lag;
> 
> -       lag = container_of(notif_blk, struct ice_lag, notif_block);
> +       if (!netif_is_ice(netdev))
> +               return NOTIFY_DONE;
> +
> +       if (event != NETDEV_CHANGEUPPER && event != NETDEV_BONDING_INFO &&
> +           event != NETDEV_UNREGISTER)
> +               return NOTIFY_DONE;
> 
> +       if (!(netdev->priv_flags & IFF_BONDING))
> +               return NOTIFY_DONE;
> +
> +       lag = container_of(notif_blk, struct ice_lag, notif_block);
>         if (!lag->netdev)
>                 return NOTIFY_DONE;
> 
> -       /* Check that the netdev is in the working namespace */
>         if (!net_eq(dev_net(netdev), &init_net))
>                 return NOTIFY_DONE;
> 
> +       /* This memory will be freed at the end of ice_lag_process_event */
> +       lag_work = kzalloc(sizeof(*lag_work), GFP_KERNEL);
> +       if (!lag_work)
> +               return -ENOMEM;
> +
> +       lag_work->event_netdev = netdev;
> +       lag_work->lag = lag;
> +       lag_work->event = event;
> +       if (event == NETDEV_CHANGEUPPER) {
> +               struct netdev_notifier_changeupper_info *info;
> +
> +               info = ptr;
> +               upper_netdev = info->upper_dev;
> +       } else {
> +               upper_netdev = netdev_master_upper_dev_get(netdev);
> +       }
> +
> +       INIT_LIST_HEAD(&lag_work->netdev_list.node);
> +       if (upper_netdev) {
> +               struct ice_lag_netdev_list *nd_list;
> +               struct net_device *tmp_nd;
> +
> +               rcu_read_lock();
> +               for_each_netdev_in_bond_rcu(upper_netdev, tmp_nd) {
> +                       nd_list = kzalloc(sizeof(*nd_list), GFP_KERNEL);
> +                       if (!nd_list)
> +                               break;

Further up, -ENOMEM is returned in case kzalloc fails. Here the error is
silently ignored - is this correct? :)

> +
> +                       nd_list->netdev = tmp_nd;
> +                       list_add(&nd_list->node, &lag_work->netdev_list.node);
> +               }
> +               rcu_read_unlock();
> +       }
> +
>         switch (event) {
>         case NETDEV_CHANGEUPPER:
> -               ice_lag_changeupper_event(lag, ptr);
> +               lag_work->info.changeupper_info =
> +                       *((struct netdev_notifier_changeupper_info *)ptr);
>                 break;
>         case NETDEV_BONDING_INFO:
> -               ice_lag_info_event(lag, ptr);
> -               break;
> -       case NETDEV_UNREGISTER:
> -               ice_lag_unregister(lag, netdev);
> +               lag_work->info.bonding_info =
> +                       *((struct netdev_notifier_bonding_info *)ptr);
>                 break;
>         default:
> +               lag_work->info.notifier_info =
> +                       *((struct netdev_notifier_info *)ptr);
>                 break;
>         }
> 
> +       INIT_WORK(&lag_work->lag_task, ice_lag_process_event);
> +       queue_work(ice_lag_wq, &lag_work->lag_task);
> +
>         return NOTIFY_DONE;
>  }
> 
> @@ -398,7 +498,6 @@ int ice_init_lag(struct ice_pf *pf)
>         lag->netdev = vsi->netdev;
>         lag->role = ICE_LAG_NONE;
>         lag->bonded = false;
> -       lag->peer_netdev = NULL;
>         lag->upper_netdev = NULL;
>         lag->notif_block.notifier_call = NULL;
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_lag.h b/drivers/net/ethernet/intel/ice/ice_lag.h
> index 2c373676c42f..df4af5184a75 100644
> --- a/drivers/net/ethernet/intel/ice/ice_lag.h
> +++ b/drivers/net/ethernet/intel/ice/ice_lag.h
> @@ -14,20 +14,49 @@ enum ice_lag_role {
>         ICE_LAG_UNSET
>  };
> 
> +#define ICE_LAG_INVALID_PORT 0xFF
> +
>  struct ice_pf;
> +struct ice_vf;
> +
> +struct ice_lag_netdev_list {
> +       struct list_head node;
> +       struct net_device *netdev;
> +};
> 
>  /* LAG info struct */
>  struct ice_lag {
>         struct ice_pf *pf; /* backlink to PF struct */
>         struct net_device *netdev; /* this PF's netdev */
> -       struct net_device *peer_netdev;
>         struct net_device *upper_netdev; /* upper bonding netdev */
> +       struct list_head *netdev_head;
>         struct notifier_block notif_block;
> +       s32 bond_mode;
> +       u16 bond_swid; /* swid for primary interface */
> +       u8 active_port; /* lport value for the current active port */
>         u8 bonded:1; /* currently bonded */
>         u8 primary:1; /* this is primary */
> +       u16 pf_recipe;
> +       u16 pf_rule_id;
> +       u16 cp_rule_idx;
>         u8 role;
>  };
> 
> +/* LAG workqueue struct */
> +struct ice_lag_work {
> +       struct work_struct lag_task;
> +       struct ice_lag_netdev_list netdev_list;
> +       struct ice_lag *lag;
> +       unsigned long event;
> +       struct net_device *event_netdev;
> +       union {
> +               struct netdev_notifier_changeupper_info changeupper_info;
> +               struct netdev_notifier_bonding_info bonding_info;
> +               struct netdev_notifier_info notifier_info;
> +       } info;
> +};
> +
> +void ice_lag_move_new_vf_nodes(struct ice_vf *vf);
>  int ice_init_lag(struct ice_pf *pf);
>  void ice_deinit_lag(struct ice_pf *pf);
>  #endif /* _ICE_LAG_H_ */
> diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> index efbc2968a7bf..625da88e7965 100644
> --- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> +++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
> @@ -1724,6 +1724,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
>                                 vf->vf_id, i);
>         }
> 
> +       ice_lag_move_new_vf_nodes(vf);
> +
>         /* send the response to the VF */
>         return ice_vc_send_msg_to_vf(vf, VIRTCHNL_OP_CONFIG_VSI_QUEUES,
>                                      VIRTCHNL_STATUS_ERR_PARAM, NULL, 0);
> --
> 2.40.1
> 
> 

