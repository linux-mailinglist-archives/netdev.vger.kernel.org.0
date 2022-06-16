Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA6C54E90D
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348870AbiFPSFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiFPSE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:04:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98F434474F
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 11:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655402697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G6qIXsUCyopbC2JihpugZkpTUeENMruuQYnAu1hjkJ0=;
        b=fVnawfKCAsrHdYK7bwQue8o3cXnYxObZbqf3cEhPbp/Psrea33oRYM8Abpv94BmECZQQZw
        h3wLErrEFQoOR+IFvRhG2XII4HkUrjD95YWXtInd9DjqJCRjPzIgLbmqTozvVgacIqCHz4
        VLS3Gx7bpKyTWvymh1hIlOU8GZ/36bs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-nr38nuaTM62qXag7krDgTg-1; Thu, 16 Jun 2022 14:04:56 -0400
X-MC-Unique: nr38nuaTM62qXag7krDgTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEFAC1815CF7;
        Thu, 16 Jun 2022 18:04:55 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F04DF2026D2D;
        Thu, 16 Jun 2022 18:04:54 +0000 (UTC)
Date:   Thu, 16 Jun 2022 20:04:54 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Daniel Juarez <djuarezg@cern.ch>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool v2] sff-8079/8472: Fix missing sff-8472 output
 in netlink path
Message-ID: <20220616200454.35c29f6f@p1.luc.cera.cz>
In-Reply-To: <20220616175947.3887961-1-ivecera@redhat.com>
References: <20220616175947.3887961-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 19:59:47 +0200
Ivan Vecera <ivecera@redhat.com> wrote:

> Commit 5b64c66f58d ("ethtool: Add netlink handler for
> getmodule (-m)") provided a netlink variant for getmodule
> but also introduced a regression as netlink output is different
> from ioctl output that provides information from A2h page
> via sff8472_show_all().
> 
> To fix this the netlink path should check a presence of A2h page
> by value of bit 6 in byte 92 of page A0h and if it is set then
> get A2h page and call sff8472_show_all().
> 
> Fixes: 5b64c66f58d ("ethtool: Add netlink handler for getmodule (-m)")
> Tested-by: Daniel Juarez <djuarezg@cern.ch>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Co-authored-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  sfpid.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 46 insertions(+), 8 deletions(-)
> 
> diff --git a/sfpid.c b/sfpid.c
> index 621d1e86c278..1bc45c183770 100644
> --- a/sfpid.c
> +++ b/sfpid.c
> @@ -13,8 +13,9 @@
>  #include "sff-common.h"
>  #include "netlink/extapi.h"
>  
> -#define SFF8079_PAGE_SIZE	0x80
> -#define SFF8079_I2C_ADDRESS_LOW	0x50
> +#define SFF8079_PAGE_SIZE		0x80
> +#define SFF8079_I2C_ADDRESS_LOW		0x50
> +#define SFF8079_I2C_ADDRESS_HIGH	0x51
>  
>  static void sff8079_show_identifier(const __u8 *id)
>  {
> @@ -450,18 +451,55 @@ void sff8079_show_all_ioctl(const __u8 *id)
>  	sff8079_show_all_common(id);
>  }
>  
> -int sff8079_show_all_nl(struct cmd_context *ctx)
> +static int sff8079_get_eeprom_page(struct cmd_context *ctx, u8 i2c_address,
> +				   __u8 *buf)
>  {
>  	struct ethtool_module_eeprom request = {
>  		.length = SFF8079_PAGE_SIZE,
> -		.i2c_address = SFF8079_I2C_ADDRESS_LOW,
> +		.i2c_address = i2c_address,
>  	};
>  	int ret;
>  
>  	ret = nl_get_eeprom_page(ctx, &request);
> -	if (ret < 0)
> -		return ret;
> -	sff8079_show_all_common(request.data);
> +	if (!ret)
> +		memcpy(buf, request.data, SFF8079_PAGE_SIZE);
> +
> +	return ret;
> +}
> +
> +int sff8079_show_all_nl(struct cmd_context *ctx)
> +{
> +	u8 *buf;
> +	int ret;
> +
> +	/* The SFF-8472 parser expects a single buffer that contains the
> +	 * concatenation of the first 256 bytes from addresses A0h and A2h,
> +	 * respectively.
> +	 */
> +	buf = calloc(1, ETH_MODULE_SFF_8472_LEN);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	/* Read A0h page */
> +	ret = sff8079_get_eeprom_page(ctx, SFF8079_I2C_ADDRESS_LOW, buf);
> +	if (ret)
> +		goto out;
> +
> +	sff8079_show_all_common(buf);
> +
> +	/* Finish if A2h page is not present */
> +	if (!(buf[92] & (1 << 6)))
> +		goto out;
> +
> +	/* Read A2h page */
> +	ret = sff8079_get_eeprom_page(ctx, SFF8079_I2C_ADDRESS_HIGH,
> +				      buf + ETH_MODULE_SFF_8079_LEN);
> +	if (ret)
> +		goto out;
> +
> +	sff8472_show_all(buf);
> +out:
> +	free(buf);
>  
> -	return 0;
> +	return ret;
>  }

Too fast fingers :-( missing leading '2'.

Nacked-by: Ivan Vecera <ivecera@redhat.com>

