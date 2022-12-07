Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8496460F8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 19:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLGSZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 13:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLGSZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 13:25:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90075442ED;
        Wed,  7 Dec 2022 10:25:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2570861B89;
        Wed,  7 Dec 2022 18:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB86C433D6;
        Wed,  7 Dec 2022 18:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670437546;
        bh=pVyiC7U7r8UYxc6T4j5HNqYUT0HvvdCZ4k71/3ALx4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UIOfnwtjpYW1kYBTkfi9kZ8PIv+YubUOBq1xjiOFhhiuiXTH73pifqE1WamIFmRdZ
         lbAs8HDCWhmfda1Q0q1KwTrtnQ2POmWcT7POnRHUAwnLzQfDk7FEn/egDdYysx1ygL
         rTYXpAB3MRgA+PGOk03tkqfhhhxUXfgkzP7S/LEfQAVpb5h9DqFHoxhNt9FzMyGOEO
         Kqcl2DW498ayiZQWnRTLf6HBLWmIzhiwNnaYsVlD2nWXEAgWG5ypdPY5pCahgjOhZH
         QCMcc0OQwgjbZ3fwkW+ciNWFfiLz1DuCe8qItx5VhnJrk0l5IKvu4bUtYA86b12BK8
         +y8Srr8BipGiQ==
Date:   Wed, 7 Dec 2022 10:25:44 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Bartosz Staszewski <bartoszx.staszewski@intel.com>,
        netdev@vger.kernel.org, bjorn@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
Subject: Re: [PATCH net v2 1/1] i40e: Fix the inability to attach XDP program
 on downed interface
Message-ID: <Y5DaqDKuC4y4icGe@x130>
References: <20221207180842.1096243-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221207180842.1096243-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Dec 10:08, Tony Nguyen wrote:
>From: Bartosz Staszewski <bartoszx.staszewski@intel.com>
>
>Whenever trying to load XDP prog on downed interface, function i40e_xdp
>was passing vsi->rx_buf_len field to i40e_xdp_setup() which was equal 0.
>i40e_open() calls i40e_vsi_configure_rx() which configures that field,
>but that only happens when interface is up. When it is down, i40e_open()
>is not being called, thus vsi->rx_buf_len is not set.
>
>Solution for this is calculate buffer length in newly created
>function - i40e_calculate_vsi_rx_buf_len() that return actual buffer
>length. Buffer length is being calculated based on the same rules
>applied previously in i40e_vsi_configure_rx() function.
>
>Fixes: 613142b0bb88 ("i40e: Log error for oversized MTU on device")
>Fixes: 0c8493d90b6b ("i40e: add XDP support for pass and drop actions")
>Signed-off-by: Bartosz Staszewski <bartoszx.staszewski@intel.com>
>Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
>Tested-by: Shwetha Nagaraju <Shwetha.nagaraju@intel.com>
>Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
>v2:
>- Change title and rework commit message
>- Dropped, previous, patch 1
>
>v1: https://lore.kernel.org/netdev/20221115000324.3040207-1-anthony.l.nguyen@intel.com/
>
> drivers/net/ethernet/intel/i40e/i40e_main.c | 42 +++++++++++++++------
> 1 file changed, 30 insertions(+), 12 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
>index 6416322d7c18..b8a8098110eb 100644
>--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>@@ -3693,6 +3693,30 @@ static int i40e_vsi_configure_tx(struct i40e_vsi *vsi)
> 	return err;
> }
>
>+/**
>+ * i40e_calculate_vsi_rx_buf_len - Calculates buffer length
>+ *
>+ * @vsi: VSI to calculate rx_buf_len from
>+ */
>+static u16 i40e_calculate_vsi_rx_buf_len(struct i40e_vsi *vsi)
>+{
>+	u16 ret;
>+
>+	if (!vsi->netdev || (vsi->back->flags & I40E_FLAG_LEGACY_RX)) {
>+		ret = I40E_RXBUFFER_2048;
>+#if (PAGE_SIZE < 8192)
>+	} else if (!I40E_2K_TOO_SMALL_WITH_PADDING &&
>+		   (vsi->netdev->mtu <= ETH_DATA_LEN)) {
>+		ret = I40E_RXBUFFER_1536 - NET_IP_ALIGN;
>+#endif
>+	} else {
>+		ret = (PAGE_SIZE < 8192) ? I40E_RXBUFFER_3072 :
>+					   I40E_RXBUFFER_2048;
>+	}
>+
>+	return ret;
>+}

nit: linux coding style states:
"Do not unnecessarily use braces where a single statement will do"

I think this applies here.

Also you could simplify this function to do early returns and drop the u16
ret variable and all the else statements.

if (condition 1)
     return val1;

if (condition 2)
     return val2;

return val3;


Other than that LGTM.

