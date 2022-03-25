Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5DB4E6CDB
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 04:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356434AbiCYDdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 23:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239983AbiCYDdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 23:33:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E73ADD78
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 20:32:10 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KPndz6DRhzCrb2;
        Fri, 25 Mar 2022 11:29:59 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 25 Mar
 2022 11:32:08 +0800
Subject: Re: [RFCv5 PATCH net-next 04/20] net: replace multiple feature bits
 with netdev features array
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
 <20220324154932.17557-5-shenjian15@huawei.com>
 <20220324182235.05dd0f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <3bae8002-1e16-b7c2-f7a2-3c13c14b7aed@huawei.com>
Date:   Fri, 25 Mar 2022 11:32:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20220324182235.05dd0f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2022/3/25 9:22, Jakub Kicinski Ð´µÀ:
> On Thu, 24 Mar 2022 23:49:16 +0800 Jian Shen wrote:
>> There are many netdev_features bits group used in drivers, replace them
>> with netdev features array.
> Maybe we can avoid the ARRAY_SIZE calls by doing something like:
>
> struct netdev_feature_set {
> 	unsigned int cnt;
> 	unsigned short feature_bits[];
> };
>
> #define DECLARE_NETDEV_FEATURE_SET(name, features...)    \
>          static unsigned short __ ## name ## _s [] = {features}; \
>          struct netdev_feature_set name = {               \
>                  .cnt = ARRAY_SIZE(__ ## name ## _s),     \
>                  .feature_bits = {features},              \
>          }
>
> Then:
>
> DECLARE_NETDEV_FEATURE_SET(siena_offload_features,
> 			   NETIF_F_IP_CSUM_BIT,
> 			   NETIF_F_IPV6_CSUM_BIT,
> 			   NETIF_F_RXHASH_BIT,
> 			   NETIF_F_NTUPLE_BIT);
>
> etc.?
> .
>
Thanks, it looks good to me.

