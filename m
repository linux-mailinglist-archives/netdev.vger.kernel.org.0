Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F6C27116F
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 01:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgISXxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 19:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgISXxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 19:53:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810EAC061755
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 16:53:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02B041216DC77;
        Sat, 19 Sep 2020 16:36:16 -0700 (PDT)
Date:   Sat, 19 Sep 2020 16:53:03 -0700 (PDT)
Message-Id: <20200919.165303.1645453579503095627.davem@davemloft.net>
To:     awogbemila@google.com
Cc:     netdev@vger.kernel.org, csully@google.com, yangchun@google.com
Subject: Re: [PATCH 2/3] gve: Add support for raw addressing to the rx path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918180720.2080407-3-awogbemila@google.com>
References: <20200918180720.2080407-1-awogbemila@google.com>
        <20200918180720.2080407-3-awogbemila@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 19 Sep 2020 16:36:17 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>
Date: Fri, 18 Sep 2020 11:07:19 -0700

> @@ -514,11 +516,11 @@ int gve_adminq_describe_device(struct gve_priv *priv)
>  	mac = descriptor->mac;
>  	dev_info(&priv->pdev->dev, "MAC addr: %pM\n", mac);
>  	priv->tx_pages_per_qpl = be16_to_cpu(descriptor->tx_pages_per_qpl);
> -	priv->rx_pages_per_qpl = be16_to_cpu(descriptor->rx_pages_per_qpl);
> -	if (priv->rx_pages_per_qpl < priv->rx_desc_cnt) {
> -		dev_err(&priv->pdev->dev, "rx_pages_per_qpl cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
> -			  priv->rx_pages_per_qpl);
> -		priv->rx_desc_cnt = priv->rx_pages_per_qpl;
> +	priv->rx_data_slot_cnt = be16_to_cpu(descriptor->rx_pages_per_qpl);
> +	if (priv->rx_data_slot_cnt < priv->rx_desc_cnt) {
> +		dev_err(&priv->pdev->dev, "rx_data_slot_cnt cannot be smaller than rx_desc_cnt, setting rx_desc_cnt down to %d.\n",
> +			priv->rx_data_slot_cnt);
> +		priv->rx_desc_cnt = priv->rx_data_slot_cnt;

I find it funny that the indentation of the second line of the dev_err()
call here is broken in patch #1 and then fixed back up here in patch #2

Please eliminate this unnecessary noise, thank you.
