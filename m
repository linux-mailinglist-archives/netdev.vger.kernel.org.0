Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202866C6568
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjCWKmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjCWKl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:41:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DB23BC72;
        Thu, 23 Mar 2023 03:39:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA6D6B8206F;
        Thu, 23 Mar 2023 10:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12AFC433EF;
        Thu, 23 Mar 2023 10:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679567944;
        bh=Hia61pLbuUoI5LRjq1+nG/PnCT/SHMq+QsnWE3WPoMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dw9j5FgIHYK47PycP9ezQt0DOUaPG9RuoP63/PDtccK2TIdKNFUxulKT5hjdepsF3
         QYj/sVZ0SDAdhgPzhLLtpSScTZWUr/IoegdBHUimFdbexKArpRtnc5bDxr2MNAlOVL
         pIybU5VU7jfd9/bj3t3widP3qvlhXHxepEXLyecfRIv1CWJehGoLrhZ8F/2ckH/Jtj
         xX67aK/jCMtUHKkCoWO9YDQzGL03lXIXOS6gb6WZ3+VGus6Pr+UJ22XIjWrixod/2X
         gUFoSh+DWm15J6TCj+P9VdSFrEYQ/npSEibxDUktQyqCb6B+32YNkfv7d6e6dK68LD
         7qfJGUvt3UZbg==
Date:   Thu, 23 Mar 2023 12:39:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        aayarekar@marvell.com, sedara@marvell.com, sburla@marvell.com,
        linux-doc@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4 6/8] octeon_ep: support asynchronous
 notifications
Message-ID: <20230323103900.GC36557@unreal>
References: <20230322091958.13103-1-vburru@marvell.com>
 <20230322091958.13103-7-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322091958.13103-7-vburru@marvell.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 02:19:55AM -0700, Veerasenareddy Burru wrote:
> Add asynchronous notification support to the control mailbox.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> ---
> v3 -> v4:
>  * 0005-xxx.patch in v3 is 0006-xxx.patch in v4.
>  * addressed review comments
>    https://lore.kernel.org/all/Y+0J94sowllCe5Gs@boxer/
>    - fixed rct violation.
>    - process_mbox_notify() now returns void.
> 
> v2 -> v3:
>  * no change
> 
> v1 -> v2:
>  * no change
> 
>  .../marvell/octeon_ep/octep_ctrl_net.c        | 29 +++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> index cef4bc3b1ec0..465eef2824e3 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> @@ -271,6 +271,33 @@ static void process_mbox_resp(struct octep_device *oct,
>  	}
>  }
>  
> +static int process_mbox_notify(struct octep_device *oct,
> +			       struct octep_ctrl_mbox_msg *msg)
> +{
> +	struct net_device *netdev = oct->netdev;
> +	struct octep_ctrl_net_f2h_req *req;
> +
> +	req = (struct octep_ctrl_net_f2h_req *)msg->sg_list[0].msg;
> +	switch (req->hdr.s.cmd) {
> +	case OCTEP_CTRL_NET_F2H_CMD_LINK_STATUS:
> +		if (netif_running(netdev)) {
> +			if (req->link.state) {
> +				dev_info(&oct->pdev->dev, "netif_carrier_on\n");
> +				netif_carrier_on(netdev);
> +			} else {
> +				dev_info(&oct->pdev->dev, "netif_carrier_off\n");
> +				netif_carrier_off(netdev);
> +			}

Shouldn't netdev changes be protected by some lock?
Is is safe to get event from FW and process it as is?

Thanks
