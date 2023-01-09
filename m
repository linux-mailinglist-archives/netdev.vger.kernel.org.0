Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAC96629B0
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbjAIPSP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Jan 2023 10:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237329AbjAIPRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:17:30 -0500
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8944321B6
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 07:16:17 -0800 (PST)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-oNm0V0wROCuACmskUztVfA-1; Mon, 09 Jan 2023 10:15:59 -0500
X-MC-Unique: oNm0V0wROCuACmskUztVfA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58549857A85;
        Mon,  9 Jan 2023 15:15:56 +0000 (UTC)
Received: from hog (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AF2B2026D2A;
        Mon,  9 Jan 2023 15:15:54 +0000 (UTC)
Date:   Mon, 9 Jan 2023 16:14:32 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     ehakim@nvidia.com, atenart@kernel.org
Cc:     netdev@vger.kernel.org, raeds@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v7 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <Y7wvWOZYL1t7duV/@hog>
References: <20230109085557.10633-1-ehakim@nvidia.com>
 <20230109085557.10633-2-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230109085557.10633-2-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-01-09, 10:55:56 +0200, ehakim@nvidia.com wrote:
> @@ -3840,6 +3835,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
>  	if (ret)
>  		goto cleanup;
>  
> +	if (data[IFLA_MACSEC_OFFLOAD]) {
> +		ret = macsec_update_offload(dev, nla_get_u8(data[IFLA_MACSEC_OFFLOAD]));
> +		if (ret)
> +			goto cleanup;
> +	}
> +
>  	/* If h/w offloading is available, propagate to the device */
>  	if (macsec_is_offloaded(macsec)) {
>  		const struct macsec_ops *ops;

There's a missing rollback of the offloading status in the (probably
quite unlikely) case that mdo_upd_secy fails, no? We can't fail
macsec_get_ops because macsec_update_offload would have failed
already, but I guess the driver could fail in mdo_upd_secy, and then
"goto cleanup" doesn't restore the offloading state.  Sorry I didn't
notice this earlier.

In case the IFLA_MACSEC_OFFLOAD attribute is provided and we're
enabling offload, we also end up calling the driver's mdo_add_secy,
and then immediately afterwards mdo_upd_secy, which probably doesn't
make much sense.

Maybe we could turn that into:

    if (data[IFLA_MACSEC_OFFLOAD]) {
        ... macsec_update_offload
    } else if (macsec_is_offloaded(macsec)) {
        /* If h/w offloading is available, propagate to the device */
        ... mdo_upd_secy
    }

Antoine, does that look reasonable to you?

-- 
Sabrina

