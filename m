Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CA151DFD9
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392128AbiEFT7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352249AbiEFT7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:59:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A42822513;
        Fri,  6 May 2022 12:55:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEA60B8391F;
        Fri,  6 May 2022 19:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C3EC385A9;
        Fri,  6 May 2022 19:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651866950;
        bh=jPWMkhNDg1jgxuf/cGrrwZeIG8Xum75XRX0vdwl85Pk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KFtIN1cEYxg0RqlRhAQsG2I07UR2qvyV872zroC18WXPk5OZSmo9Ar6+efzgNgIp4
         iZ0/0Wz49/+XO/ijmPXDoJ+yHPM1GiqCa5sS+NLLBfp0DqaU0w9zXRzn+oitWfnAPI
         7o4UsC1MbzM8GmdaPFGi3DMMHTuahWjJ4CJR70w8YZtwaF57SRBVz7cIywML/ntYXc
         qUtM3K84g82PiiLZE74ZLwj2pWw+mP4JSqXOkxYNvXm75QEN8WmFjUZcjl233qYbQL
         Oe0bIX+200DdUxQW3TfnFuL5OjAaQkL6DSfpVpUzc1kcCyn/FcCap1jD4hLUvB56M0
         I72FGDVBfYbug==
Date:   Fri, 6 May 2022 12:55:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ioana.ciornei@nxp.com>, <davem@davemloft.net>,
        <robert-ionut.alexa@nxp.com>
Subject: Re: [PATCH v2] net: dpaa2-mac: add missing of_node_put() in
 dpaa2_mac_get_node()
Message-ID: <20220506125548.7ccdba25@kernel.org>
In-Reply-To: <20220505021833.3864434-1-yangyingliang@huawei.com>
References: <20220505021833.3864434-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 May 2022 10:18:33 +0800 Yang Yingliang wrote:
> Add missing of_node_put() in error path in dpaa2_mac_get_node().
> 
> Fixes: 5b1e38c0792c ("dpaa2-mac: bail if the dpmacs fwnode is not found")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index c48811d3bcd5..fab2ce6bee9f 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -108,8 +108,10 @@ static struct fwnode_handle *dpaa2_mac_get_node(struct device *dev,
>  		return ERR_PTR(-EPROBE_DEFER);
>  	}
>  
> -	if (!parent)
> +	if (!parent) {
> +		of_node_put(dpmacs);

I don't see how !parent && dpmacs can ever be true.

>  		return NULL;
> +	}
>  
>  	fwnode_for_each_child_node(parent, child) {
>  		err = -EINVAL;

