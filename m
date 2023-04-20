Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709AC6E974B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjDTOgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbjDTOgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:36:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112E040EF;
        Thu, 20 Apr 2023 07:36:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1960617C4;
        Thu, 20 Apr 2023 14:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FC7C433D2;
        Thu, 20 Apr 2023 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682001381;
        bh=CiPDXZ/3Ibo+b4cOGX7CAnSBNa4vesz4gA9rJfwtNJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SqLfS3bEgPPg/oItrzysDOaivBXR/CmHP8N6K/BAYMHYjVAb2po9WtA+GuneI/OnQ
         65w16wfhnNGEjJ+utePwRCfEEvHwPfS03ECUjyPhs890Rx7SbrNP/HP/j16nkjK2iS
         CbB6hOpYlPxaII7vHl1UA6nud8xDuUtiZWoea0L6FmMhdJwH8cYJMgf1ZC3/IwK7Xn
         mDZeGqQzoCSq2INHZBO4JsMW+QnVLFdAKhLK+aHtvKg+Xu46CnCK5za8UsTeoAKPh0
         kZJyjhs+kKYPyD9GmbkLz4pXmXoLsynfLj2YOTDBgb3Kvv+R7HiapmrGwVsJAbEDZy
         3O+lDja0Wzb7Q==
Date:   Thu, 20 Apr 2023 07:36:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net] ethernet: ixgb: fix use after free bugs caused by
 circular dependency problem
Message-ID: <20230420073619.6001cb27@kernel.org>
In-Reply-To: <20230420140157.22416-1-duoming@zju.edu.cn>
References: <20230420140157.22416-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 22:01:57 +0800 Duoming Zhou wrote:
> The watchdog_timer can schedule tx_timeout_task and tx_timeout_task
> can also arm watchdog_timer. The process is shown below:
> 
> ----------- timer schedules work ------------
> ixgb_watchdog() //timer handler
>   schedule_work(&adapter->tx_timeout_task)
> 
> ----------- work arms timer ------------
> ixgb_tx_timeout_task() //workqueue callback function
>   ixgb_up()
>     mod_timer(&adapter->watchdog_timer,...)
> 
> When ixgb device is detaching, the timer and workqueue
> could still be rearmed. The process is shown below:
> 
>   (cleanup routine)           |  (timer and workqueue routine)
> ixgb_remove()                 |
>                               | ixgb_tx_timeout_task() //workqueue
>                               |   ixgb_up()
>                               |     mod_timer()
>   cancel_work_sync()          |
>   free_netdev(netdev) //FREE  | ixgb_watchdog() //timer
>                               |   netif_carrier_ok(netdev) //USE
> 
> This patch adds timer_shutdown_sync() in ixgb_remove(), which
> could prevent rearming of the timer from the workqueue.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>

The driver has been removed. No point.
