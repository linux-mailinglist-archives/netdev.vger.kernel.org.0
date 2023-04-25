Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9336B6EE101
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 13:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbjDYLTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 07:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbjDYLTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 07:19:16 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8279B1707;
        Tue, 25 Apr 2023 04:19:14 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Q5KD93cVDz17XFB;
        Tue, 25 Apr 2023 19:15:21 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 25 Apr
 2023 19:19:12 +0800
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
 <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
 <ZEU+vospFdm08IeE@localhost.localdomain>
 <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
 <ZEZJHCRsBVQwd9ie@localhost.localdomain>
 <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com> <ZEZ/xXcOv9Co5Vif@boxer>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <99890c72-eb61-e032-944a-6671d6494c23@huawei.com>
Date:   Tue, 25 Apr 2023 19:19:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <ZEZ/xXcOv9Co5Vif@boxer>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/24 21:10, Maciej Fijalkowski wrote:
>>> There was a discussion in the past to reduce XDP_PACKET_HEADROOM to 192B but
>>> this is not merged yet and it is not related to this series. We can address
>>> your comments in a follow-up patch when XDP_PACKET_HEADROOM series is merged.
> 
> Intel drivers still work just fine at 192 headroom and split the page but
> it makes it problematic for BIG TCP where MAX_SKB_FRAGS from shinfo needs

I am not sure why we are not enabling skb_shinfo(skb)->frag_list to support
BIG TCP instead of increasing MAX_SKB_FRAGS, perhaps there was some disscution
about this in the past I am not aware of?

> to be increased. So it's the tailroom that becomes the bottleneck, not the
> headroom. I believe at some point we will convert our drivers to page_pool
> with full 4k page dedicated for a single frame.

Can we use header splitting to ensure there is enough tailroom for
napi_build_skb() or xdp_frame with shinfo?

