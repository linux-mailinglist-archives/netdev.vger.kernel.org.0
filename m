Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CA0645DD3
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLGPrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiLGPq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:46:58 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59D327CD8
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:46:57 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-0aD-SJymO32BngtIO0bklA-1; Wed, 07 Dec 2022 10:46:39 -0500
X-MC-Unique: 0aD-SJymO32BngtIO0bklA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D760858F13;
        Wed,  7 Dec 2022 15:46:39 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 424B3141510A;
        Wed,  7 Dec 2022 15:46:37 +0000 (UTC)
Date:   Wed, 7 Dec 2022 16:45:34 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com
Cc:     linux-kernel@vger.kernel.org, raeds@nvidia.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, atenart@kernel.org,
        jiri@resnulli.us
Subject: Re: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y5C1Hifsg3/lJJ8N@hog>
References: <20221207101017.533-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221207101017.533-1-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-12-07, 12:10:16 +0200, ehakim@nvidia.com wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Add support for changing Macsec offload selection through the
> netlink layer by implementing the relevant changes in
> macsec_change link.

nit: macsec_changelink

[...]
> +static int macsec_update_offload(struct macsec_dev *macsec, enum macsec_offload offload)
> +{
> +	enum macsec_offload prev_offload;
> +	const struct macsec_ops *ops;
> +	struct macsec_context ctx;
> +	int ret = 0;
> +
> +	prev_offload = macsec->offload;
> +
> +	/* Check if the device already has rules configured: we do not support
> +	 * rules migration.
> +	 */
> +	if (macsec_is_configured(macsec))
> +		return -EBUSY;
> +
> +	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
> +			       macsec, &ctx);
> +	if (!ops)
> +		return -EOPNOTSUPP;
> +
> +	macsec->offload = offload;
> +
> +	ctx.secy = &macsec->secy;
> +	ret = (offload == MACSEC_OFFLOAD_OFF) ? macsec_offload(ops->mdo_del_secy, &ctx) :
> +		      macsec_offload(ops->mdo_add_secy, &ctx);

I think aligning the two macsec_offload(...) calls would make this a
bit easier to read:

	ret = offload == MACSEC_OFFLOAD_OFF ? macsec_offload(ops->mdo_del_secy, &ctx)
					    : macsec_offload(ops->mdo_add_secy, &ctx);

(and remove the unnecessary ())

> +
> +	if (ret)
> +		macsec->offload = prev_offload;
> +
> +	return ret;
> +}
> +

[...]
> +static int macsec_changelink_upd_offload(struct net_device *dev, struct nlattr *data[])
> +{
> +	enum macsec_offload offload;
> +	struct macsec_dev *macsec;
> +
> +	macsec = macsec_priv(dev);
> +	offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);

All those checks are also present in macsec_upd_offload, why not move
them into macsec_update_offload as well? (and then you don't really
need macsec_changelink_upd_offload anymore)

> +	if (macsec->offload == offload)
> +		return 0;
> +
> +	/* Check if the offloading mode is supported by the underlying layers */
> +	if (offload != MACSEC_OFFLOAD_OFF &&
> +	    !macsec_check_offload(offload, macsec))
> +		return -EOPNOTSUPP;
> +
> +	/* Check if the net device is busy. */
> +	if (netif_running(dev))
> +		return -EBUSY;
> +
> +	return macsec_update_offload(macsec, offload);
> +}
> +

-- 
Sabrina

