Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDEF687742
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 09:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbjBBIZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 03:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjBBIZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 03:25:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CD57EDA;
        Thu,  2 Feb 2023 00:25:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 655E3CE28A7;
        Thu,  2 Feb 2023 08:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16152C433D2;
        Thu,  2 Feb 2023 08:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675326321;
        bh=tWMBNqHdTBWKvlhJurXo0FhnokQnQjkhjzX7RHBFQXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ramUz4EvWEIigPPzuPEzH9FkHZd9F5Cj2xtEZanHDF218uR8vBMYbeofAjdtqNhoR
         DxSVqIUzx6f4DzZC+ZtAUt1W7vByGFS9e8cJekbbocBFrIzK5B2NJkBy3ClLJCUMCV
         AZY6dj6jzqSbvDEKWV6+02UIlPUs6vyoHTlbdUHA6QNzoHwp0VNuwWhccoiRQbL+HP
         jEW+aY1Gnxls08S0sX+x31kyhW7Smw+fQUK7DwhofLvD8WTr48cfvak2/qLdj1tbhl
         MKJPRIeVGZU3OeuiLXyz5NkMdrbqJSTL9iYs44cCNpZQfvZrjjy4H160MYIVxIhc5C
         x0y4cqD6s/h0Q==
Date:   Thu, 2 Feb 2023 10:25:17 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net,v2] net: mana: Fix accessing freed irq affinity_hint
Message-ID: <Y9tzbZDZmVoFV2bx@unreal>
References: <1675288013-2481-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675288013-2481-1-git-send-email-haiyangz@microsoft.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 01:46:53PM -0800, Haiyang Zhang wrote:
> After calling irq_set_affinity_and_hint(), the cpumask pointer is
> saved in desc->affinity_hint, and will be used later when reading
> /proc/irq/<num>/affinity_hint. So the cpumask variable needs to be
> persistent. Otherwise, we are accessing freed memory when reading
> the affinity_hint file.
> 
> Also, need to clear affinity_hint before free_irq(), otherwise there
> is a one-time warning and stack trace during module unloading:
> 
>  [  243.948687] WARNING: CPU: 10 PID: 1589 at kernel/irq/manage.c:1913 free_irq+0x318/0x360
>  ...
>  [  243.948753] Call Trace:
>  [  243.948754]  <TASK>
>  [  243.948760]  mana_gd_remove_irqs+0x78/0xc0 [mana]
>  [  243.948767]  mana_gd_remove+0x3e/0x80 [mana]
>  [  243.948773]  pci_device_remove+0x3d/0xb0
>  [  243.948778]  device_remove+0x46/0x70
>  [  243.948782]  device_release_driver_internal+0x1fe/0x280
>  [  243.948785]  driver_detach+0x4e/0xa0
>  [  243.948787]  bus_remove_driver+0x70/0xf0
>  [  243.948789]  driver_unregister+0x35/0x60
>  [  243.948792]  pci_unregister_driver+0x44/0x90
>  [  243.948794]  mana_driver_exit+0x14/0x3fe [mana]
>  [  243.948800]  __do_sys_delete_module.constprop.0+0x185/0x2f0
> 
> To fix the bug, use the persistent mask, cpumask_of(cpu#), and set
> affinity_hint to NULL before freeing the IRQ, as required by free_irq().
> 
> Cc: stable@vger.kernel.org
> Fixes: 71fa6887eeca ("net: mana: Assign interrupts to CPUs based on NUMA nodes")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 35 ++++++-------------
>  1 file changed, 10 insertions(+), 25 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
