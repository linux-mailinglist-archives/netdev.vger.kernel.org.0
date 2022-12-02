Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105F564024C
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbiLBIgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbiLBIfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:35:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAB7CE1A;
        Fri,  2 Dec 2022 00:34:26 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NNmND0lS9zqT1Z;
        Fri,  2 Dec 2022 16:30:20 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 16:34:24 +0800
Subject: Re: [EXT] Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak
 in otx2_probe()
To:     Geethasowjanya Akula <gakula@marvell.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "sunil.kovvuri@gmail.com" <sunil.kovvuri@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
CC:     Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1669253985.git.william.xuanziyang@huawei.com>
 <e024450cf08f469fb1e0153b78a04a54829dfddb.1669253985.git.william.xuanziyang@huawei.com>
 <Y4DHHUUbGl5wWGQ+@boxer> <f4bb4aa5-08cc-4a4d-76cf-46bda5c6de59@huawei.com>
 <538c8b9a-7d6c-69f8-9e14-45436446127e@huawei.com>
 <DM6PR18MB26020F45167434B409A32AA7CD179@DM6PR18MB2602.namprd18.prod.outlook.com>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <97439096-aeab-f24a-1767-b535cf29b49a@huawei.com>
Date:   Fri, 2 Dec 2022 16:34:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR18MB26020F45167434B409A32AA7CD179@DM6PR18MB2602.namprd18.prod.outlook.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> ________________________________________
> From: Ziyang Xuan (William) <william.xuanziyang@huawei.com>
> Sent: Friday, December 2, 2022 7:14 AM
> To: Maciej Fijalkowski; sunil.kovvuri@gmail.com; Sunil Kovvuri Goutham
> Cc: Geethasowjanya Akula; Subbaraya Sundeep Bhatta; Hariprasad Kelam; davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; Naveen Mamindlapalli; Rakesh Babu Saladi; linux-kernel@vger.kernel.org
> Subject: [EXT] Re: [PATCH net 1/2] octeontx2-pf: Fix possible memory leak in otx2_probe()
> 
> External Email
> 
> ----------------------------------------------------------------------
>>>> On Thu, Nov 24, 2022 at 09:56:43AM +0800, Ziyang Xuan wrote:
>>>>> In otx2_probe(), there are several possible memory leak bugs
>>>>> in exception paths as follows:
>>>>> 1. Do not release pf->otx2_wq when excute otx2_init_tc() failed.
>>>>> 2. Do not shutdown tc when excute otx2_register_dl() failed.
>>>>> 3. Do not unregister devlink when initialize SR-IOV failed.
>>>>>
>>>>> Fixes: 1d4d9e42c240 ("octeontx2-pf: Add tc flower hardware offload on ingress traffic")
>>>>> Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
>>>>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
>>>>> ---
>>>>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 ++++-
>>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>>>>> index 303930499a4c..8d7f2c3b0cfd 100644
>>>>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>>>>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
>>>>> @@ -2900,7 +2900,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>>
>>>>>     err = otx2_register_dl(pf);
>>>>>     if (err)
>>>>> -           goto err_mcam_flow_del;
>>>>> +           goto err_register_dl;
>>>>>
>>>>>     /* Initialize SR-IOV resources */
>>>>>     err = otx2_sriov_vfcfg_init(pf);
>>>>> @@ -2919,8 +2919,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>>>     return 0;
>>>>
>>>> If otx2_dcbnl_set_ops() fails at the end then shouldn't we also call
>>>> otx2_sriov_vfcfg_cleanup() ?
>>>
>>> I think it does not need. This is the probe process. PF and VF are all not ready to work,
>>> so pf->vf_configs[i].link_event_work does not scheduled. And pf->vf_configs memory resource will
>>> be freed by devm subsystem if probe failed. There are not memory leak and other problems.
>>>
>> Hello Sunil Goutham, Maciej Fijalkowski,
> 
>> What do you think about my analysis? Look forward to your >reply.
> otx2_sriov_vfcfg_cleanup() is not required. Since PF probe is failed, link event won't get triggered.
> 
Hello Geetha,

If there is not any other question, can you add "Reviewed-by" for my patchset?

Thank you!

> Thanks,
> Geetha.
>> Thank you!
> 
>>> @Sunil Goutham, Please help to confirm.
>>>
>>> Thanks.
>>>
>>>>
>>>>>
>>>>>  err_pf_sriov_init:
>>>>> +   otx2_unregister_dl(pf);
>>>>> +err_register_dl:
>>>>>     otx2_shutdown_tc(pf);
>>>>>  err_mcam_flow_del:
>>>>> +   destroy_workqueue(pf->otx2_wq);
>>>>>     otx2_mcam_flow_del(pf);
>>>>>  err_unreg_netdev:
>>>>>     unregister_netdev(netdev);
>>>>> --
>>>>> 2.25.1
>>>>>
>>>> .
>>>>
>>> .
>>>
> .
> 
