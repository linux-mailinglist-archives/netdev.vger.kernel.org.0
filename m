Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB295108EB7
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfKYNWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 08:22:06 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:37734 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbfKYNWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 08:22:06 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1BD88700068;
        Mon, 25 Nov 2019 13:22:03 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 25 Nov
 2019 13:21:53 +0000
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
To:     Alexander Lobakin <alobakin@dlink.ru>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Johannes Berg <johannes@sipsolutions.net>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        David Miller <davem@davemloft.net>, <jiri@mellanox.com>,
        <edumazet@google.com>, <idosch@mellanox.com>, <petrm@mellanox.com>,
        <sd@queasysnail.net>, <f.fainelli@gmail.com>,
        <jaswinder.singh@linaro.org>, <ilias.apalodimas@linaro.org>,
        <linux-kernel@vger.kernel.org>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
 <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
 <746f768684f266e5a5db1faf8314cd77@dlink.ru>
 <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
 <3147bff57d58fce651fe2d3ca53983be@dlink.ru>
 <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
 <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
 <d535d5142e42b8c550f0220200e3779d@dlink.ru>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e437dc2d-aff3-2893-8d80-6abae4fcb84a@solarflare.com>
Date:   Mon, 25 Nov 2019 13:21:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <d535d5142e42b8c550f0220200e3779d@dlink.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25064.003
X-TM-AS-Result: No-5.287000-8.000000-10
X-TMASE-MatchedRID: O/y65JfDwwv4ECMHJTM/ufZvT2zYoYOwC/ExpXrHizxQKAQSutQYXKTG
        zvndj/1xPEoGb8keCDpTvVffeIwvQ1Bbc4CjRSHyPaBTJyy84wXr4zRSn2nRLl7OLL/a8shj5Yn
        xWopAGWjWsfhGDQA5PSxOtaOcroMgwG9P01lFxWXnzlXMYw4XMAGLeSok4rrZC24oEZ6SpSk6XE
        E7Yhw4Fp5wSB09cXN2QCZtfbHlpu54jp5HPmPu0F/duMvqpsu6zuXIl1Bx0YydgRgbr8pwokojB
        pGsa9cji/EsGInbj2bR4t5pWXMyjuL59MzH0po2K2yzo9Rrj9wPoYC35RuihKPUI7hfQSp5eCBc
        UCG1aJiUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.287000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25064.003
X-MDID: 1574688125-yGbiBUDO3EwM
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2019 12:02, Alexander Lobakin wrote:
> I'm not very familiar with iwlwifi, but as a work around manual
> napi_gro_flush() you can also manually flush napi->rx_list to
> prevent packets from stalling:
>
> diff -Naur a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c    2019-11-25 14:55:03.610355230 +0300
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c    2019-11-25 14:57:29.399556868 +0300
> @@ -1526,8 +1526,16 @@
>      if (unlikely(emergency && count))
>          iwl_pcie_rxq_alloc_rbs(trans, GFP_ATOMIC, rxq);
>
> -    if (rxq->napi.poll)
> +    if (rxq->napi.poll) {
> +        if (rxq->napi.rx_count) {
> +            netif_receive_skb_list(&rxq->napi.rx_list);
> +
> +            INIT_LIST_HEAD(&rxq->napi.rx_list);
> +            rxq->napi.rx_count = 0;
> +        }
> +
>          napi_gro_flush(&rxq->napi, false);
> +    }
>
>      iwl_pcie_rxq_restock(trans, rxq);
>  }
... or we could export gro_normal_list(), instead of open-coding it
 in the driver?

-Ed
