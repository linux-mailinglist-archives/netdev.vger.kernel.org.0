Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BE06392FD
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 02:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiKZBFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 20:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKZBFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 20:05:38 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C7C209AC;
        Fri, 25 Nov 2022 17:05:33 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NJtmL2JZmzHwCt;
        Sat, 26 Nov 2022 09:04:18 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 09:04:56 +0800
Subject: Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak in
 otx2_probe()
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        <sunil.kovvuri@gmail.com>, <sgoutham@marvell.com>
CC:     <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <naveenm@marvell.com>, <rsaladi2@marvell.com>,
        <linux-kernel@vger.kernel.org>
References: <cover.1669253985.git.william.xuanziyang@huawei.com>
 <e024450cf08f469fb1e0153b78a04a54829dfddb.1669253985.git.william.xuanziyang@huawei.com>
 <Y4DHHUUbGl5wWGQ+@boxer>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <f4bb4aa5-08cc-4a4d-76cf-46bda5c6de59@huawei.com>
Date:   Sat, 26 Nov 2022 09:04:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <Y4DHHUUbGl5wWGQ+@boxer>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Nov 24, 2022 at 09:56:43AM +0800, Ziyang Xuan wrote:
>> In otx2_probe(), there are several possible memory leak bugs
>> in exception paths as follows:
>> 1. Do not release pf->otx2_wq when excute otx2_init_tc() failed.
>> 2. Do not shutdown tc when excute otx2_register_dl() failed.
>> 3. Do not unregister devlink when initialize SR-IOV failed.
>>
>> Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on ingress traffic")
>> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>> index 303930499a4c..8d7f2c3b0cfd 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>> @@ -2900,7 +2900,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>  
>>  	err = otx2_register_dl(pf);
>>  	if (err)
>> -		goto err_mcam_flow_del;
>> +		goto err_register_dl;
>>  
>>  	/* Initialize SR-IOV resources */
>>  	err = otx2_sriov_vfcfg_init(pf);
>> @@ -2919,8 +2919,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>  	return 0;
> 
> If otx2_dcbnl_set_ops() fails at the end then shouldn't we also call
> otx2_sriov_vfcfg_cleanup() ?

I think it does not need. This is the probe process. PF and VF are all not ready to work,
so pf->vf_configs[i].link_event_work does not scheduled. And pf->vf_configs memory resource will
be freed by devm subsystem if probe failed. There are not memory leak and other problems.

@Sunil Goutham, Please help to confirm.

Thanks.

> 
>>  
>>  err_pf_sriov_init:
>> +	otx2_unregister_dl(pf);
>> +err_register_dl:
>>  	otx2_shutdown_tc(pf);
>>  err_mcam_flow_del:
>> +	destroy_workqueue(pf->otx2_wq);
>>  	otx2_mcam_flow_del(pf);
>>  err_unreg_netdev:
>>  	unregister_netdev(netdev);
>> -- 
>> 2.25.1
>>
> .
> 
