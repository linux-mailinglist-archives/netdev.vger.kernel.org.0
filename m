Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A252A60C110
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 03:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiJYBbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 21:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiJYBbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 21:31:31 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559831A801;
        Mon, 24 Oct 2022 18:08:37 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MxDMq39y7zHvGX;
        Tue, 25 Oct 2022 09:08:23 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 09:08:35 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 25 Oct
 2022 09:08:34 +0800
Subject: Re: [Patch v9 03/12] net: mana: Handle vport sharing between devices
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <1666396889-31288-1-git-send-email-longli@linuxonhyperv.com>
 <1666396889-31288-4-git-send-email-longli@linuxonhyperv.com>
 <05607c38-7c9f-49df-c6b2-17e35f2ecbbd@huawei.com>
 <PH7PR21MB32633AC8730AFB4E6C247BABCE2E9@PH7PR21MB3263.namprd21.prod.outlook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <38cedbd0-b719-eab5-71bd-2677462096c5@huawei.com>
Date:   Tue, 25 Oct 2022 09:08:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <PH7PR21MB32633AC8730AFB4E6C247BABCE2E9@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/25 2:45, Long Li wrote:
>>> +int mana_cfg_vport(struct mana_port_context *apc, u32
>> protection_dom_id,
>>> +		   u32 doorbell_pg_id)
>>>  {
>>>  	struct mana_config_vport_resp resp = {};
>>>  	struct mana_config_vport_req req = {};
>>>  	int err;
>>>
>>> +	/* This function is used to program the Ethernet port in the hardware
>>> +	 * table. It can be called from the Ethernet driver or the RDMA driver.
>>> +	 *
>>> +	 * For Ethernet usage, the hardware supports only one active user on
>> a
>>> +	 * physical port. The driver checks on the port usage before
>> programming
>>> +	 * the hardware when creating the RAW QP (RDMA driver) or
>> exposing the
>>> +	 * device to kernel NET layer (Ethernet driver).
>>> +	 *
>>> +	 * Because the RDMA driver doesn't know in advance which QP type
>> the
>>> +	 * user will create, it exposes the device with all its ports. The user
>>> +	 * may not be able to create RAW QP on a port if this port is already
>>> +	 * in used by the Ethernet driver from the kernel.
>>> +	 *
>>> +	 * This physical port limitation only applies to the RAW QP. For RC QP,
>>> +	 * the hardware doesn't have this limitation. The user can create RC
>>> +	 * QPs on a physical port up to the hardware limits independent of
>> the
>>> +	 * Ethernet usage on the same port.
>>> +	 */
>>> +	mutex_lock(&apc->vport_mutex);
>>> +	if (apc->vport_use_count > 0) {
>>> +		mutex_unlock(&apc->vport_mutex);
>>> +		return -EBUSY;
>>> +	}
>>> +	apc->vport_use_count++;
>>> +	mutex_unlock(&apc->vport_mutex);
>>> +
>>>  	mana_gd_init_req_hdr(&req.hdr, MANA_CONFIG_VPORT_TX,
>>>  			     sizeof(req), sizeof(resp));
>>>  	req.vport = apc->port_handle;
>>> @@ -679,9 +714,16 @@ static int mana_cfg_vport(struct
>>> mana_port_context *apc, u32 protection_dom_id,
>>>
>>>  	apc->tx_shortform_allowed = resp.short_form_allowed;
>>>  	apc->tx_vp_offset = resp.tx_vport_offset;
>>> +
>>> +	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
>>> +		    apc->port_handle, protection_dom_id, doorbell_pg_id);
>>>  out:
>>> +	if (err)
>>> +		mana_uncfg_vport(apc);
>>
>> There seems to be a similar race between error handling here and the "apc-
>>> vport_use_count > 0" checking above as pointed out in v7.
> 
> Thanks for looking into this.
> 
> This is different to the locking bug in mana_ib_cfg_vport(). The vport sharing
> between Ethernet and RDMA is exclusive, not shared. If another driver tries
> to take the vport while it is being configured, it will fail immediately. It is by

Suppose the following steps:
1. Ethernet driver take the lock first and do a "apc->vport_use_count++", and
   release the lock;
2. RDMA driver take the lock, do "apc->vport_use_count > 0" checking and return
   -EBUSY;
3. mana_send_request() or mana_verify_resp_hdr() return error to Ethernet driver.

It seems that vport is left unused when above happens, if that is what you wanted?


> design to prevent possible deadlock.

I am not sure I understand the deadlock here.

> 
