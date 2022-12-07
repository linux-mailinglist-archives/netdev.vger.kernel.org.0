Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B14C64655C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLGXqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiLGXqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:46:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7A88B39B
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:46:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD50161D07
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 23:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130C4C433D6;
        Wed,  7 Dec 2022 23:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670456806;
        bh=FekGS3S+cYmtDCc8I4pb2eSmiZiwu/y0PyIWprL9TcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AmYXz10kZDaV8s6inYYDd3Udu/cFZijljTEpZO82P+aiXp2oEjcVMMxf8qGnHDboK
         5Ehui/TWJOoVTogVeHHCdx733J58PwisNIT1hsKlyS7jw+WVoS+QyLMv0lZkaL5vlG
         mVQvnxEeKi3UvlROI5fTl8COgP+44LOGuVnOWPBKJ3rvOdrVF+IdsFs6N20TEZCLRY
         RsfW2s7AiPwZ34sP843/ueqPDcaZiFl6v8e8DjXf76kukYM1JuY1DEfOY3CUCXO6R1
         WOueIyGtQbEXCNuw9cVTs6ngWL6f5yMI1VYOJ2ypKmgtDffwzBQAujJHYhMmPh+JZv
         k9W3vYeWQCjWA==
Date:   Wed, 7 Dec 2022 15:46:44 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com, leon@kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next v2 10/15] ice: disable Tx timestamps while link
 is down
Message-ID: <Y5El5C8EFQhU+Ukd@x130>
References: <20221207210937.1099650-1-anthony.l.nguyen@intel.com>
 <20221207210937.1099650-11-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207210937.1099650-11-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Dec 13:09, Tony Nguyen wrote:
>From: Jacob Keller <jacob.e.keller@intel.com>
>
>Introduce a new link_down field for the Tx tracker which indicates whether
>the link is down for a given port.
>
>Use this bit to prevent any Tx timestamp requests from starting while link
Can tx timestamp requests be generated in a context other than the xmit ndo
? how ?

why not just use the same sync mechanisms we have for tx queues, 
carrier_down etc ..? 

Anyway I'm just curious.. 

>is down. This ensures that we do not try to start new timestamp requests
>until after link has been restored.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_ptp.c | 11 ++++++++++-
> drivers/net/ethernet/intel/ice/ice_ptp.h |  2 ++
> 2 files changed, 12 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
>index 481492d84e0e..dffcd50bac3f 100644
>--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
>+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
>@@ -613,7 +613,7 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
> {
> 	lockdep_assert_held(&tx->lock);
>
>-	return tx->init && !tx->calibrating;
>+	return tx->init && !tx->calibrating && !tx->link_down;
> }
>
> /**
>@@ -806,6 +806,8 @@ ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
> 	}
>
> 	tx->init = 1;
>+	tx->link_down = 0;
>+	tx->calibrating = 0;
>
> 	spin_lock_init(&tx->lock);
>
>@@ -1396,6 +1398,13 @@ void ice_ptp_link_change(struct ice_pf *pf, u8 port, bool linkup)
> 	/* Update cached link status for this port immediately */
> 	ptp_port->link_up = linkup;
>
>+	/* Set the link status of the Tx tracker. While link is down, all Tx
>+	 * timestamp requests will be ignored.
>+	 */
>+	spin_lock(&ptp_port->tx.lock);
>+	ptp_port->tx.link_down = !linkup;
>+	spin_unlock(&ptp_port->tx.lock);
>+
> 	/* E810 devices do not need to reconfigure the PHY */
> 	if (ice_is_e810(&pf->hw))
> 		return;
>diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
>index 0bfafaaab6c7..75dcab8e1124 100644
>--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
>+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
>@@ -119,6 +119,7 @@ struct ice_tx_tstamp {
>  * @init: if true, the tracker is initialized;
>  * @calibrating: if true, the PHY is calibrating the Tx offset. During this
>  *               window, timestamps are temporarily disabled.
>+ * @link_down: if true, the link is down and timestamp requests are disabled
>  * @verify_cached: if true, verify new timestamp differs from last read value
>  */
> struct ice_ptp_tx {
>@@ -130,6 +131,7 @@ struct ice_ptp_tx {
> 	u8 len;
> 	u8 init : 1;
> 	u8 calibrating : 1;
>+	u8 link_down : 1;
> 	u8 verify_cached : 1;
> };
>
>-- 
>2.35.1
>
