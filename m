Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358E165CBC8
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 03:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjADCK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 21:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbjADCKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 21:10:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF97296
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 18:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LheupaLTI95KAl8SfbPEo3c1FDkjYUNBgxXgAbRBVcM=; b=ONvENoEmA9UkKvPxbpsmGEfvRx
        466t2XgPrNx2B+amA20/xoTc3L+ZKQ53+3OShMaF7riq2S1gBnBXIRvzIMZNOwJnCZ6+jPojxw0oy
        ipZHVr4bUqt1462L/4Jd8gIiOsA7OJZdv2AkOOrjAWAAykxFakcyQPI4p1qhqXJ6OL/4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCtEj-00160z-GD; Wed, 04 Jan 2023 03:10:37 +0100
Date:   Wed, 4 Jan 2023 03:10:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hao Lan <lanhao@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, shenjian15@huawei.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: hns3: support wake on lan
 configuration and query
Message-ID: <Y7TgHS8oGbE656v0@lunn.ch>
References: <20230104013405.65433-1-lanhao@huawei.com>
 <20230104013405.65433-2-lanhao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104013405.65433-2-lanhao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +enum HCLGE_WOL_MODE {
> +	HCLGE_WOL_PHY		= BIT(0),
> +	HCLGE_WOL_UNICAST	= BIT(1),
> +	HCLGE_WOL_MULTICAST	= BIT(2),
> +	HCLGE_WOL_BROADCAST	= BIT(3),
> +	HCLGE_WOL_ARP		= BIT(4),
> +	HCLGE_WOL_MAGIC		= BIT(5),
> +	HCLGE_WOL_MAGICSECURED	= BIT(6),
> +	HCLGE_WOL_FILTER	= BIT(7),
> +	HCLGE_WOL_DISABLE	= 0,
> +};

These are the exact same values as WAKE_PHY, WAKE_CAST etc. Since they
are ABI, they will never change. So you may as well throw these away
and just use the Linux values.

>  struct hclge_hw;
>  int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num);
>  enum hclge_comm_cmd_status hclge_cmd_mdio_write(struct hclge_hw *hw,
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> index 4e54f91f7a6c..88cb5c05bc43 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> @@ -11500,6 +11500,201 @@ static void hclge_uninit_rxd_adv_layout(struct hclge_dev *hdev)
>  		hclge_write_dev(&hdev->hw, HCLGE_RXD_ADV_LAYOUT_EN_REG, 0);
>  }
>  
> +static __u32 hclge_wol_mode_to_ethtool(u32 mode)
> +{
> +	__u32 ret = 0;
> +
> +	if (mode & HCLGE_WOL_PHY)
> +		ret |= WAKE_PHY;
> +
> +	if (mode & HCLGE_WOL_UNICAST)
> +		ret |= WAKE_UCAST;
> +
> +	if (mode & HCLGE_WOL_MULTICAST)
> +		ret |= WAKE_MCAST;
> +
> +	if (mode & HCLGE_WOL_BROADCAST)
> +		ret |= WAKE_BCAST;
> +
> +	if (mode & HCLGE_WOL_ARP)
> +		ret |= WAKE_ARP;
> +
> +	if (mode & HCLGE_WOL_MAGIC)
> +		ret |= WAKE_MAGIC;
> +
> +	if (mode & HCLGE_WOL_MAGICSECURED)
> +		ret |= WAKE_MAGICSECURE;
> +
> +	if (mode & HCLGE_WOL_FILTER)
> +		ret |= WAKE_FILTER;

Once you throw away HCLGE_WOL_*, this function becomes much simpler.

> +
> +	return ret;
> +}
> +
> +static u32 hclge_wol_mode_from_ethtool(__u32 mode)
> +{
> +	u32 ret = HCLGE_WOL_DISABLE;
> +
> +	if (mode & WAKE_PHY)
> +		ret |= HCLGE_WOL_PHY;
> +
> +	if (mode & WAKE_UCAST)
> +		ret |= HCLGE_WOL_UNICAST;

This one two.

> @@ -12075,6 +12275,8 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
>  
>  	hclge_init_rxd_adv_layout(hdev);
>  
> +	(void)hclge_update_wol(hdev);

Please avoid casts like this. If there is an error, you should not
ignore it. If it cannot fail, make it a void function.	

       Andrew
