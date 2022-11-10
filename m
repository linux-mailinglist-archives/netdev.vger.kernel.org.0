Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157EE6241C8
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiKJLzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiKJLzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:55:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EA05D6B8
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668081264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBXYRpLp9moONU6VGCquLi5t9Eh718cfLlFyFi9l3CA=;
        b=fU++dqiGxk0+fGeh39DUReTWHKfRpkZk9ZQz2AvrQbDF8QPya5mGagiPp4bXYdl8Svfyyt
        LFs3zUk+A06uQHLQyU2wi2pfTa5mfDpAY5FEi6krHqC8mkSrqo+0bIyACksKPrF2botfJt
        XoxyowJndlDhRmocCuTfdF5KZprLcxs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-id2sgLhqNg62RbCdyABSfQ-1; Thu, 10 Nov 2022 06:54:17 -0500
X-MC-Unique: id2sgLhqNg62RbCdyABSfQ-1
Received: by mail-qv1-f72.google.com with SMTP id l6-20020ad44446000000b004bb60364075so1282200qvt.13
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:54:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DBXYRpLp9moONU6VGCquLi5t9Eh718cfLlFyFi9l3CA=;
        b=aDA1ZHMZNIRM1DR+b7PkL7n71nUjyy73O72UWhrtNhlPTz7YgQjTB4MFXcEAdJIY4Z
         FBir3eWv9MolAv9z5Uy3TwlcZtInza5T2r9LL3nsLOL2ZyiE41u/sdbyhOnoE7u5WkZh
         2EwPikPq9wMjg+xKAOzXM+aEZjcLOdGCR7HVc3R7hzEmUycchBPEwAU326upS8UgK6aE
         pP+4puoaBzxMLlGL5Ci1uMAVifCDixsaUi0xuSHjQH6pRl3vZualnh3+3kIvM/244gGA
         31U9a3uyu1uHWaTQoVZ9jMUntoj1wyEwsBkIPPR3fgwHVieZvhUu3mvqZBCUAT62AQij
         TBxw==
X-Gm-Message-State: ACrzQf1tTX07aQI7MwRs0b94wvgmI2eeYWQeeMac7R/mdcpP55RfU51E
        M5B+IzivrzPanroPoDHPA9P01TYLjkOGcgls8ivseCZkz/9Cov0DWQ9DHg0UCrYh6jiaTaRt2mr
        kBM6OHGq0wFf67wth
X-Received: by 2002:ac8:4b5c:0:b0:3a5:3819:4f6c with SMTP id e28-20020ac84b5c000000b003a538194f6cmr38476107qts.115.1668081257434;
        Thu, 10 Nov 2022 03:54:17 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5nK2/+RlTh1FXxmhK8+LIPkQeubcCUEzrXAdqnVRAT4J5njdAZps09YmsvbfRUfDGECJVtPQ==
X-Received: by 2002:ac8:4b5c:0:b0:3a5:3819:4f6c with SMTP id e28-20020ac84b5c000000b003a538194f6cmr38476094qts.115.1668081257203;
        Thu, 10 Nov 2022 03:54:17 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id o16-20020a05620a2a1000b006ce3f1af120sm13196566qkp.44.2022.11.10.03.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 03:54:16 -0800 (PST)
Message-ID: <4349bc93a5f2130a95305287141fde369245f921.camel@redhat.com>
Subject: Re: [PATCH v2 RESEND 1/1] net: fec: add xdp and page pool statistics
From:   Paolo Abeni <pabeni@redhat.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev
Date:   Thu, 10 Nov 2022 12:54:13 +0100
In-Reply-To: <20221109023147.242904-1-shenwei.wang@nxp.com>
References: <20221109023147.242904-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-11-08 at 20:31 -0600, Shenwei Wang wrote:
> @@ -2685,9 +2738,16 @@ static void fec_enet_get_strings(struct net_device *netdev,
>  	int i;
>  	switch (stringset) {
>  	case ETH_SS_STATS:
> -		for (i = 0; i < ARRAY_SIZE(fec_stats); i++)
> -			memcpy(data + i * ETH_GSTRING_LEN,
> -				fec_stats[i].name, ETH_GSTRING_LEN);
> +		for (i = 0; i < ARRAY_SIZE(fec_stats); i++) {
> +			memcpy(data, fec_stats[i].name, ETH_GSTRING_LEN);
> +			data += ETH_GSTRING_LEN;
> +		}
> +		for (i = 0; i < ARRAY_SIZE(fec_xdp_stat_strs); i++) {
> +			memcpy(data, fec_xdp_stat_strs[i], ETH_GSTRING_LEN);
> +			data += ETH_GSTRING_LEN;

The above triggers a warning:

In function ‘fortify_memcpy_chk’,
    inlined from ‘fec_enet_get_strings’ at ../drivers/net/ethernet/freescale/fec_main.c:2788:4:
../include/linux/fortify-string.h:413:25: warning: call to ‘__read_overflow2_field’ declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
  413 |                         __read_overflow2_field(q_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I think you can address it changing fec_xdp_stat_strs definition to:

static const char fec_xdp_stat_strs[XDP_STATS_TOTAL][ETH_GSTRING_LEN] = { // ...

Cheers,

Paolo

