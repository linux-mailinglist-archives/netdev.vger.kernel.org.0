Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B000665CBF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbjAKNjW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Jan 2023 08:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239163AbjAKNjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:39:05 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C112C11A37
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:36:15 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-Lsz7GuKHNiiOG8OH87xeqA-1; Wed, 11 Jan 2023 08:36:10 -0500
X-MC-Unique: Lsz7GuKHNiiOG8OH87xeqA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED9B03814598;
        Wed, 11 Jan 2023 13:36:09 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A56AC140EBF4;
        Wed, 11 Jan 2023 13:36:08 +0000 (UTC)
Date:   Wed, 11 Jan 2023 14:34:42 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        atenart@kernel.org
Subject: Re: [PATCH net-next v8 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y7668voOCFqWXmdF@hog>
References: <20230111081112.21067-1-ehakim@nvidia.com>
 <20230111081112.21067-2-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230111081112.21067-2-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry to delay this again, there's something to fix in this version.
I hope you're not too frustrated by the review process.

2023-01-11, 10:11:11 +0200, ehakim@nvidia.com wrote:
> +static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
> +	struct nlattr **attrs = info->attrs;
> +	enum macsec_offload offload;
> +	struct macsec_dev *macsec;
> +	struct net_device *dev;
> +	int ret;

        int ret = 0;

Otherwise we can return with ret uninitialized when macsec->offload ==
offload.

(unfortunately the compiler warning is disabled in the kernel Makefile)

[...]
> @@ -3840,8 +3837,17 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
>  	if (ret)
>  		goto cleanup;
>  
> +	if (data[IFLA_MACSEC_OFFLOAD]) {
> +		offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
> +		if (macsec->offload != offload) {
> +			macsec_offload_state_change = true;
> +			ret = macsec_update_offload(dev, offload);
> +			if (ret)
> +				goto cleanup;
> +		}
> +	}

nit: there was a blank line here in the previous version, please bring it back.

>  	/* If h/w offloading is available, propagate to the device */
> -	if (macsec_is_offloaded(macsec)) {
> +	if (!macsec_offload_state_change && macsec_is_offloaded(macsec)) {
>  		const struct macsec_ops *ops;
>  		struct macsec_context ctx;

Thanks.

-- 
Sabrina

