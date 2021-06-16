Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7073A9241
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhFPG3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:29:31 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:31356 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhFPG3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:29:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623824844; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=tfQcGeVIJlbVK4n5GuCdAaFYDeWtfPMofUGELoT/fCA=;
 b=GIZMPifIRbDrq9WaJxRgrRlxVGWKATjFxrasyrSaud00mLidwKzU7H1+Aw6R6JTGApFezbsB
 QyRuw1fL4Yl6FzGP5aX3ZP8ixmQSpZN84tTHS6iXciZ9FPG2T2uz0FDhA7UDD+HI3qHhyNGx
 g5i6g/FYq/LunnIZsycxYL20hb4=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60c999b9ed59bf69ccbeff7d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 16 Jun 2021 06:27:05
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2B986C43460; Wed, 16 Jun 2021 06:27:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 635DFC433D3;
        Wed, 16 Jun 2021 06:27:04 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 16 Jun 2021 00:27:04 -0600
From:   subashab@codeaurora.org
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: qualcomm: rmnet: Allow partial updates
 of IFLA_FLAGS
In-Reply-To: <20210615232707.835258-1-bjorn.andersson@linaro.org>
References: <20210615232707.835258-1-bjorn.andersson@linaro.org>
Message-ID: <ad250914bbb332d408f0b42935d11149@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-15 17:27, Bjorn Andersson wrote:
> The idiomatic way to handle the changelink flags/mask pair seems to be
> allow partial updates of the driver's link flags. In contrast the rmnet
> driver masks the incoming flags and then use that as the new flags.
> 
> Change the rmnet driver to follow the common scheme, before the
> introduction of IFLA_RMNET_FLAGS handling in iproute2 et al.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> Changes since v1:
> - Also do the masking dance on newlink, per Subash request
> - Add "net-next" to subject prefix
> 
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> index 8d51b0cb545c..27b1663c476e 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> @@ -163,7 +163,8 @@ static int rmnet_newlink(struct net *src_net,
> struct net_device *dev,
>  		struct ifla_rmnet_flags *flags;
> 
>  		flags = nla_data(data[IFLA_RMNET_FLAGS]);
> -		data_format = flags->flags & flags->mask;
> +		data_format &= ~flags->mask;
> +		data_format |= flags->flags & flags->mask;
>  	}
> 
>  	netdev_dbg(dev, "data format [0x%08X]\n", data_format);
> @@ -336,7 +337,8 @@ static int rmnet_changelink(struct net_device
> *dev, struct nlattr *tb[],
> 
>  		old_data_format = port->data_format;
>  		flags = nla_data(data[IFLA_RMNET_FLAGS]);
> -		port->data_format = flags->flags & flags->mask;
> +		port->data_format &= ~flags->mask;
> +		port->data_format |= flags->flags & flags->mask;
> 
>  		if (rmnet_vnd_update_dev_mtu(port, real_dev)) {
>  			port->data_format = old_data_format;

Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
