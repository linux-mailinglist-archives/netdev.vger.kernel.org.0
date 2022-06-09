Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A6754504A
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbiFIPLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiFIPK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:10:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5198E24BF8
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 08:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB37B61E73
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 15:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197ECC34114;
        Thu,  9 Jun 2022 15:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654787456;
        bh=0Ge820OGa4te98WIS0UG3zxikC3DjwfI23VV/ZGDhtA=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=bMm4ubweenRSG9QBa8FwPmuo88IcWvGmfgkD+yzqwVNPbzBmliR1hI6Y2NTGvFRJW
         it7BGqkI+6I3V83YVIYBaP+bYvMy3JTVUpvsyM3xyw36nZqaOL5sHj/reNaucQt0Ug
         ++VCsq37bRGyc0WuBB3RgKv6ggch7qsXkMTqOx/G9tyPrP4ZgKA0cgpwV7n6GwqrvX
         /PYsQ30+b2wiCIryDrug8HBU1pUWHEb9WNcTWp6BiBuk9inyyJI/anDstEW+LqTVIl
         tVqf/ZViX2Fu4SYZu/ZancCuCtoEP9h116sMYI3fyEAKIUPNN5wCMrb6Kv68aYnXzv
         pRPKS1T0+DUKg==
Message-ID: <05585cd3-95e9-1379-967a-7fa6e8d065f3@kernel.org>
Date:   Thu, 9 Jun 2022 09:10:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] vdpa: Add support for reading vdpa device statistics
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, jasowang@redhat.com,
        si-wei.liu@oracle.com, mst@redhat.com
References: <20220601121021.487664-1-elic@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220601121021.487664-1-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/22 6:10 AM, Eli Cohen wrote:
> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> index cc575a825a7c..7f52e703f1ad 100644
> --- a/vdpa/include/uapi/linux/vdpa.h
> +++ b/vdpa/include/uapi/linux/vdpa.h
> @@ -18,6 +18,7 @@ enum vdpa_command {
>  	VDPA_CMD_DEV_DEL,
>  	VDPA_CMD_DEV_GET,		/* can dump */
>  	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
> +	VDPA_CMD_DEV_STATS_GET,
>  };
>  
>  enum vdpa_attr {
> @@ -46,6 +47,11 @@ enum vdpa_attr {
>  	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>  	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
>  	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
> +
> +	VDPA_ATTR_DEV_QUEUE_INDEX,		/* u32 */
> +	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
> +	VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,	/* u64 */
> +
>  	/* new attributes must be added above here */
>  	VDPA_ATTR_MAX,
>  };


no reference to the kernel patch, so I have no idea if this uapi has
been committed to a kernel tree.

