Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 469B6628224
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 15:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbiKNOPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 09:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKNOPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 09:15:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB5C2529A
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 06:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668435333; x=1699971333;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lz5QexcZR7yb/2bESAmF5qRLJcz/sjAk91e7262IrT0=;
  b=itVr5jKt6x/z1vocJr/f+RTNPv0oMK09PV4NFw7pKZNc69jFN9sQq2LJ
   IsVd6Je4GFvg0J0odnb2/+VekyFe0riFH12qd3jcp9Hzz+tToMZhJHlqb
   uozrgsvnqXYNXaeHVIKx/yFQEje7rH++m7JQT357tE+furlcEd1SxWIh7
   0Dlfs75IqY3eftBBDhOiJNug28uGNE8s7vq8a0bC060FYAoq7sYtw2Pz5
   pcP8CL/GUI8cN/4D+zpWrxftB36OUr70U3of0xzzvsP5fzzaaekYx5B3t
   xLrVveedrTC/pyHYGQUX1rXA6TdsBxjPGcXHRQWuCbMh5bZA8jq1sd2pb
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="188894838"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2022 07:15:32 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 14 Nov 2022 07:15:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 14 Nov 2022 07:15:30 -0700
Date:   Mon, 14 Nov 2022 15:20:17 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <rmk+kernel@armlinux.org.uk>,
        <casper.casan@gmail.com>, <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] net: lan966x: Fix potential null-ptr-deref in
 lan966x_stats_init()
Message-ID: <20221114142017.bqaeabujh4rlxl5c@soft-dev3-1>
References: <20221114133853.5384-1-shangxiaojing@huawei.com>
 <20221114133853.5384-2-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221114133853.5384-2-shangxiaojing@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/14/2022 21:38, Shang XiaoJing wrote:
> [Some people who received this message don't often get email from shangxiaojing@huawei.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> lan966x_stats_init() calls create_singlethread_workqueue() and not
> checked the ret value, which may return NULL. And a null-ptr-deref may
> happen:
> 
> lan966x_stats_init()
>     create_singlethread_workqueue() # failed, lan966x->stats_queue is NULL
>     queue_delayed_work()
>         queue_delayed_work_on()
>             __queue_delayed_work()  # warning here, but continue
>                 __queue_work()      # access wq->flags, null-ptr-deref
> 
> Check the ret value and return -ENOMEM if it is NULL.

It looks good to me.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Fixes: 12c2d0a5b8e2 ("net: lan966x: add ethtool configuration and statistics")
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
> index e58a27fd8b50..0fb0efc224be 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
> @@ -708,6 +708,9 @@ int lan966x_stats_init(struct lan966x *lan966x)
>         snprintf(queue_name, sizeof(queue_name), "%s-stats",
>                  dev_name(lan966x->dev));
>         lan966x->stats_queue = create_singlethread_workqueue(queue_name);
> +       if (!lan966x->stats_queue)
> +               return -ENOMEM;
> +
>         INIT_DELAYED_WORK(&lan966x->stats_work, lan966x_check_stats_work);
>         queue_delayed_work(lan966x->stats_queue, &lan966x->stats_work,
>                            LAN966X_STATS_CHECK_DELAY);
> --
> 2.17.1
> 

-- 
/Horatiu
