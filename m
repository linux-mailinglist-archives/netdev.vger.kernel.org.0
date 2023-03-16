Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80FF46BC4B3
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCPD1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCPD0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:26:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB739943A6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:25:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=de2dJXe4/EB0nmIwzrUQVnNdjbhI8wMyZyyKtRbT+AFu+CB7yKBjmkxdBVt+ODQrdZcBi6uxGvoUKIhcG9N+R/Qd4E2DjoolEQz1YuLA+UGZ3maQSQ5rtcdTt0tWTDGhe+dwlIxqEapnVWpTf1xx6gAlCVxOQVV16Z3NH5IYNBXUsXZZND2jLhuXk6Bl0RgGt2Wp02WQeEfYa8eOW+ksSSChf0A0nhC9wbPpj6nMNkEH8zKG5LLRX2+tl30h3eFsnkrcpbiNqD1P1vWrd5sdBJBun9lLiR9wwcDspK2lvTSFbHiAN7gA3NFefPl47ZnwOFr8na4NT2x5SmtwY0yBwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXogLrzZktRtOL7rFEcGaZvZNs6Uxuy0g/5ORL84dIE=;
 b=SY4wnwJfX31YMBN9RzucnZo874ef7jEjMrOH7A5j9sTguVpDUiGZ8BKMZSGKE49/Sbe5zcGa9Xh8TTowmulbwCl9ZW/Oa0fjdZ9XJ8mfyoIsPHOiQvyKpmtvOBaLWKk6Fr03D490S/cQPE8lSvc3NdGObbSAD1Aie8NoOy6wvX1MmGj7uHYvxmkZpsRfk8sVJZ99u6ZyJTtXT57MY+GXCePQYJxZLZCcUTD/zbUIe/C/kngvz6oE9YyIPpGCbNQNjlzId6KZ9S9D+GmI67K5R5eMBM9NohCsC/dSnVGiL8v/vSAstqC81szihPwOb9EeLwSsrmWynGQK+tdR8Q0XCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXogLrzZktRtOL7rFEcGaZvZNs6Uxuy0g/5ORL84dIE=;
 b=5OfTfp+5nHfNwgsIwHkGuy55zM0lInUIYouHZFT47vt6qAnpjJx57ZVhSXc9l4AKpqTOe+HRctPDvkHywx/e0vYm6BjcHcLDRBoUa8g2N6tyKcMxDE29b7nDp3ObA/IfL8/a5CvXWxKThqjRBcfM6Ns/xFcpnPMFV0op2Vz98C0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Thu, 16 Mar 2023 03:25:28 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%8]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 03:25:28 +0000
Message-ID: <9038fb95-f711-235c-8656-1c81e2a18c64@amd.com>
Date:   Wed, 15 Mar 2023 20:25:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v2 virtio 5/7] pds_vdpa: add support for vdpa and
 vdpamgmt interfaces
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-6-shannon.nelson@amd.com>
 <CACGkMEvFiNKNwGTtCsj12ywjn_DXUhRhpyJhUV5TNwu8VytrBQ@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEvFiNKNwGTtCsj12ywjn_DXUhRhpyJhUV5TNwu8VytrBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0046.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::23) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 2412ba63-1251-4b0a-0c73-08db25ce16c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKNkZyVUS8OHGJbBcWfd+9ogNqJ3iF0/flwkIKV69K3LH5f1GAS3JzxTJoebWCEiVuCcuzbltz3hpqu41NMb5H/gmOnq4GSOq5WJeS2W4oJ2Vhkj+9Y/hWG6sJBGwIYnTl2UamzVE1B0rbLH41H3GOy3fIGplV1jp2sWgIzTL3shrDQDrig204BBbCpgciXuIfz47Idtqv6smNOjzunJskMS6k16thxwWVGWXKGFxEaTHPQ6YBDEpcpA34GBKGmmLrDqGGc/foKKAMJQlJUfAUU5PG2H1+mFuGnkXbSO6wqzCj4ySMLvtuaKXBALIzfDCbEnX6U0bkUEkt1dpKettF8u2IVWFG5rZfRlJ2McX+3PFmWo36kfVYClFqA/nIi79M+e6HhecwSIq+GjZDV0cIfKbn8zVCvsQKtHkCxpSmEBecAVvDC9vrLHPgHO13itE4n0TZd+iRAqzd80MATAVS7dgQpzfTU3I9RM/oyUL83Egjz19PKjwI9hT73Rhh8wbXr/DLpK17CDnJikpYmKvcGvzDeO4s4j0Y8MNttQP1IMSFBc+A4VQR6vGe+orTcoRQctnuIvw30PAbSG7cJvGhNeVL/Z5KdzlGaDMFHnRNgkFUBt36Mv5gzFIAKXtcNQxWyTdoQaZTFYnR+Bsxp1IXG0JMwpvZzsr5Z1Q2DoSXLMk+KCPjekdFhc9s7VSnb55eFHraUIH4XuwrYwmzwEr4hQtVHN63Lwi05rMJCrsyg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(2616005)(26005)(478600001)(6486002)(53546011)(36756003)(186003)(6512007)(6666004)(316002)(6506007)(30864003)(38100700002)(5660300002)(86362001)(41300700001)(31696002)(8936002)(31686004)(44832011)(83380400001)(66899018)(2906002)(66476007)(66946007)(66556008)(4326008)(6916009)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cG0yN0U2MnB6aFdXMUdWeFJQc1RiVE1rS1NNS3FPcC9lZFVnSmE4MmRwY3Ay?=
 =?utf-8?B?cWFDdm1GZm5TUFBqeTRBeHFSRmpTWHE3RjF0akhvUWQ2OHRwM3NZdlFtK1BX?=
 =?utf-8?B?aHcrVysyVGFDcnN6WlVWck83bVhYRWc5UElxamhJcTNCSEtoTnhhMFlaTzNl?=
 =?utf-8?B?dVJZYXloc2ZKbVJyQ2NQRDBJK3BBZHFPS1ZFRFhpcStRMjc1a3hUcFNId1VG?=
 =?utf-8?B?ZjA2VHZkdytEZVdrek8rSnhCR28rRjBBM0hRbDY2UmdxTzd3ZE93cE90VTh4?=
 =?utf-8?B?dmtSZEJlR00yZUFUSTdzd0g4QU5HZTlTdUtTL0JkbGw3ZVFmdFdwQUtKVk1G?=
 =?utf-8?B?SDhwMy9Sb1BpNTVsNVA4Zm9lK0hGemhnRlBXdUk0QjBBb3d6NENMNEFZTi9t?=
 =?utf-8?B?VkJwS3NwQzNwcXNwVHBmWlZZM1JnMU44Z0tyMkE1L1VtWUgzZWo3ZXhnd1p1?=
 =?utf-8?B?NDJ0MHoyTHJ4bWhSTXBGOHQrZ2VzZlFVWndsdHoxUXB4V1ZLWDNXWXJuU1VC?=
 =?utf-8?B?RHZZaVp3aC8xdHRTUUhLb0NheWFtZkxXOExoc09CMGtuWXQyVnhNeFZLb1hq?=
 =?utf-8?B?SXBJSEpSa21OcHFQcExnNU8rNEhpQ3J6RFlZaDJIQjc1VUR2VDBtUml5RG5I?=
 =?utf-8?B?ejZaTGdwcDgxdjZkbCtLSmMxdVRCRDZKbnlmWmlFV3phaCthV1FSTFpQVXU5?=
 =?utf-8?B?UCtsTktFa0pMVU1WSG1xTENoYXJCYndyTHptQ0xlL21lRmlaTDNhTzVFVW1C?=
 =?utf-8?B?b1hWZzZlVWRlNEgrbWk4RGQxZXIrWjdkZ00yOWJGSWRZNFdNMjE5YjlyNld0?=
 =?utf-8?B?UVZwdXY1MzIreGpvU3hPdUV2ZzJjSTFVNjJROUM2d0lSS3BDZEVxUXBSRkR3?=
 =?utf-8?B?cHlLM1dtckNoN1dpcmFaSE9GRVhGUytUeXNWaVdRd05tcEZkQUJPSTBGYnQv?=
 =?utf-8?B?cFRNekV3M1FaSTN1MUVFcFMvZytXbUFxUnhHK2N4NFRQTHJkZFQ5cXJNUEdw?=
 =?utf-8?B?NVJQMHc0VFBwSGx2cEJld3hRT1pmNHhSSk93SUxpUTdzWTBTT05nNVVhRGdp?=
 =?utf-8?B?RUpvSnkzWkgzUno3L3Y3dnJBcTg2dnV4YllGc0ZxL3JPR0RYeWJKcnV6UnBO?=
 =?utf-8?B?enJvbTc1bmZWQ3BVdjVFQjQxQzQzTzJPQkZDTllIOEJMNjJPUTJ0RnFGTDYz?=
 =?utf-8?B?dGR3MzMwYldDWmJ5YmUzNG8reUxXcmpUKytUdXB6S25iZ0FJVVhOa2lValFp?=
 =?utf-8?B?TFlaTlRxSGhiVmlsdldQUXJFSHRwaUdPOVRJcDNwYkJBdEptUXcvamp2KzR0?=
 =?utf-8?B?VEFKMFNxSFF3R09zakkrR2NycmJSa1VxMEFybjYzRUpndlBmSGVDaHowaUI1?=
 =?utf-8?B?d3JNQkFsOW90VWt3T1VERVNQMm92Y1RzaUFQWHFpUVlQMWRYNjJBSjVIazJa?=
 =?utf-8?B?L29YdXBwV20rb0wwcjFDQ2dBV0lxM29tcUk0RzBKSTlXR3BxTFdCOWdjL2tV?=
 =?utf-8?B?WVFLU0daUjhwWHFudnR2NGJST2ErSXdBd0I5c3NDK2pzMkpHR1VFMWN5NFpx?=
 =?utf-8?B?MU1NUnlyMjh1NURaeGxwc2Z6eUhycGdhb0REb1hjR3dlYzBRTndJYmc4MnpP?=
 =?utf-8?B?ZDdaTmlJeFdDSXMzVXpFVFBDUVFqZ3VaOFhwWkJXSU8vLzNydFFjaTNyNlBu?=
 =?utf-8?B?djBWL0xLTXJhTGNOcWJqY1QyS2tyalBnb0lhb2p6QnJlNmN3Z2xYdUVZZWRK?=
 =?utf-8?B?djh3Qzk0WXZaVUE5VE5VekJ5eW1MS1NZbzVDVDcyRkVYMW9KdnFNZm4wSmM0?=
 =?utf-8?B?VXZVaVpwdkRSYlZOSlZZUmVLZjh5RFZEd05hcm9LVTRtbXFsMktnM2wwLzJY?=
 =?utf-8?B?Rkp6d2VPcUZWTUI5L21RRXVjSUk1OHE5dThzdU0yZFpiWnRDaGJ5WE5kTGZB?=
 =?utf-8?B?N0RRUXpDbWc5MWttZE56THY0NlJnbmFpdklTUzQ4TUFGeEgxcmgwRUlTaXh6?=
 =?utf-8?B?Y1JHVjkxK2dwL3FWdDZQRVUrMzFQbWdkV2RoNnJDSWsrS0REdkNYdUdla1Mx?=
 =?utf-8?B?RWczQ09BYm5QNWF2OENla1VTMlRzcm1FTUcwVXg2K29WM2hIUGV0S21qbVcx?=
 =?utf-8?Q?ggm/TwR04i7Apgz6XyxRS4Bql?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2412ba63-1251-4b0a-0c73-08db25ce16c1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 03:25:27.9547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fDazDjabLcQYpxYdAxU264Lkre6UU4Y82/Wv/Et9iR/n6THoPPCAVcdmfQn+brH5Vwe7XuXVh7vO1LUszFZYDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 12:05 AM, Jason Wang wrote:
> On Thu, Mar 9, 2023 at 9:31 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> This is the vDPA device support, where we advertise that we can
>> support the virtio queues and deal with the configuration work
>> through the pds_core's adminq.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vdpa/pds/aux_drv.c  |  15 +
>>   drivers/vdpa/pds/aux_drv.h  |   1 +
>>   drivers/vdpa/pds/debugfs.c  | 172 ++++++++++++
>>   drivers/vdpa/pds/debugfs.h  |   8 +
>>   drivers/vdpa/pds/vdpa_dev.c | 545 +++++++++++++++++++++++++++++++++++-
>>   5 files changed, 740 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
>> index 28158d0d98a5..d706f06f7400 100644
>> --- a/drivers/vdpa/pds/aux_drv.c
>> +++ b/drivers/vdpa/pds/aux_drv.c
>> @@ -60,8 +60,21 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
>>                  goto err_free_mgmt_info;
>>          }
>>
>> +       /* Let vdpa know that we can provide devices */
>> +       err = vdpa_mgmtdev_register(&vdpa_aux->vdpa_mdev);
>> +       if (err) {
>> +               dev_err(dev, "%s: Failed to initialize vdpa_mgmt interface: %pe\n",
>> +                       __func__, ERR_PTR(err));
>> +               goto err_free_virtio;
>> +       }
>> +
>> +       pds_vdpa_debugfs_add_pcidev(vdpa_aux);
>> +       pds_vdpa_debugfs_add_ident(vdpa_aux);
>> +
>>          return 0;
>>
>> +err_free_virtio:
>> +       pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
>>   err_free_mgmt_info:
>>          pci_free_irq_vectors(padev->vf->pdev);
>>   err_aux_unreg:
>> @@ -78,11 +91,13 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
>>          struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
>>          struct device *dev = &aux_dev->dev;
>>
>> +       vdpa_mgmtdev_unregister(&vdpa_aux->vdpa_mdev);
>>          pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
>>          pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
>>
>>          vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
>>
>> +       pds_vdpa_debugfs_del_vdpadev(vdpa_aux);
>>          kfree(vdpa_aux);
>>          auxiliary_set_drvdata(aux_dev, NULL);
>>
>> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
>> index 87ac3c01c476..1ab1ce64da7c 100644
>> --- a/drivers/vdpa/pds/aux_drv.h
>> +++ b/drivers/vdpa/pds/aux_drv.h
>> @@ -11,6 +11,7 @@ struct pds_vdpa_aux {
>>          struct pds_auxiliary_dev *padev;
>>
>>          struct vdpa_mgmt_dev vdpa_mdev;
>> +       struct pds_vdpa_device *pdsv;
>>
>>          struct pds_vdpa_ident ident;
>>
>> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
>> index aa5e9677fe74..b3ee4f42f3b6 100644
>> --- a/drivers/vdpa/pds/debugfs.c
>> +++ b/drivers/vdpa/pds/debugfs.c
>> @@ -9,6 +9,7 @@
>>   #include <linux/pds/pds_auxbus.h>
>>
>>   #include "aux_drv.h"
>> +#include "vdpa_dev.h"
>>   #include "debugfs.h"
>>
>>   #ifdef CONFIG_DEBUG_FS
>> @@ -26,4 +27,175 @@ void pds_vdpa_debugfs_destroy(void)
>>          dbfs_dir = NULL;
>>   }
>>
>> +#define PRINT_SBIT_NAME(__seq, __f, __name)                     \
>> +       do {                                                    \
>> +               if ((__f) & (__name))                               \
>> +                       seq_printf(__seq, " %s", &#__name[16]); \
>> +       } while (0)
>> +
>> +static void print_status_bits(struct seq_file *seq, u16 status)
>> +{
>> +       seq_puts(seq, "status:");
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_DRIVER_OK);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FEATURES_OK);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_NEEDS_RESET);
>> +       PRINT_SBIT_NAME(seq, status, VIRTIO_CONFIG_S_FAILED);
>> +       seq_puts(seq, "\n");
>> +}
>> +
>> +#define PRINT_FBIT_NAME(__seq, __f, __name)                \
>> +       do {                                               \
>> +               if ((__f) & BIT_ULL(__name))                 \
>> +                       seq_printf(__seq, " %s", #__name); \
>> +       } while (0)
>> +
>> +static void print_feature_bits(struct seq_file *seq, u64 features)
>> +{
>> +       seq_puts(seq, "features:");
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CSUM);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_CSUM);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MTU);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MAC);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO4);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_TSO6);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ECN);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_UFO);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO4);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_TSO6);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_ECN);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HOST_UFO);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MRG_RXBUF);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STATUS);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VQ);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_VLAN);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_RX_EXTRA);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_GUEST_ANNOUNCE);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_MQ);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_CTRL_MAC_ADDR);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_HASH_REPORT);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSS);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_RSC_EXT);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_STANDBY);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_NET_F_SPEED_DUPLEX);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_NOTIFY_ON_EMPTY);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ANY_LAYOUT);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_VERSION_1);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ACCESS_PLATFORM);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_RING_PACKED);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_ORDER_PLATFORM);
>> +       PRINT_FBIT_NAME(seq, features, VIRTIO_F_SR_IOV);
>> +       seq_puts(seq, "\n");
> 
> Should we print the features that are not understood here?

Probably not a bad idea, if we keep this around.  I might end up just 
yanking it out.

> 
>> +}
>> +
>> +void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux)
>> +{
>> +       vdpa_aux->dentry = debugfs_create_dir(pci_name(vdpa_aux->padev->vf->pdev), dbfs_dir);
>> +}
>> +
>> +static int identity_show(struct seq_file *seq, void *v)
>> +{
>> +       struct pds_vdpa_aux *vdpa_aux = seq->private;
>> +       struct vdpa_mgmt_dev *mgmt;
>> +
>> +       seq_printf(seq, "aux_dev:            %s\n",
>> +                  dev_name(&vdpa_aux->padev->aux_dev.dev));
>> +
>> +       mgmt = &vdpa_aux->vdpa_mdev;
>> +       seq_printf(seq, "max_vqs:            %d\n", mgmt->max_supported_vqs);
>> +       seq_printf(seq, "config_attr_mask:   %#llx\n", mgmt->config_attr_mask);
>> +       seq_printf(seq, "supported_features: %#llx\n", mgmt->supported_features);
>> +       print_feature_bits(seq, mgmt->supported_features);
>> +
>> +       return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(identity);
>> +
>> +void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux)
>> +{
>> +       debugfs_create_file("identity", 0400, vdpa_aux->dentry,
>> +                           vdpa_aux, &identity_fops);
>> +}
>> +
>> +static int config_show(struct seq_file *seq, void *v)
>> +{
>> +       struct pds_vdpa_device *pdsv = seq->private;
>> +       struct virtio_net_config vc;
>> +
>> +       memcpy_fromio(&vc, pdsv->vdpa_aux->vd_mdev.device,
>> +                     sizeof(struct virtio_net_config));
>> +
>> +       seq_printf(seq, "mac:                  %pM\n", vc.mac);
>> +       seq_printf(seq, "max_virtqueue_pairs:  %d\n",
>> +                  __virtio16_to_cpu(true, vc.max_virtqueue_pairs));
>> +       seq_printf(seq, "mtu:                  %d\n", __virtio16_to_cpu(true, vc.mtu));
>> +       seq_printf(seq, "speed:                %d\n", le32_to_cpu(vc.speed));
>> +       seq_printf(seq, "duplex:               %d\n", vc.duplex);
>> +       seq_printf(seq, "rss_max_key_size:     %d\n", vc.rss_max_key_size);
>> +       seq_printf(seq, "rss_max_indirection_table_length: %d\n",
>> +                  le16_to_cpu(vc.rss_max_indirection_table_length));
>> +       seq_printf(seq, "supported_hash_types: %#x\n",
>> +                  le32_to_cpu(vc.supported_hash_types));
>> +       seq_printf(seq, "vn_status:            %#x\n",
>> +                  __virtio16_to_cpu(true, vc.status));
>> +       print_status_bits(seq, __virtio16_to_cpu(true, vc.status));
>> +
>> +       seq_printf(seq, "req_features:         %#llx\n", pdsv->req_features);
>> +       print_feature_bits(seq, pdsv->req_features);
>> +       seq_printf(seq, "actual_features:      %#llx\n", pdsv->actual_features);
>> +       print_feature_bits(seq, pdsv->actual_features);
>> +       seq_printf(seq, "vdpa_index:           %d\n", pdsv->vdpa_index);
>> +       seq_printf(seq, "num_vqs:              %d\n", pdsv->num_vqs);
>> +
>> +       return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(config);
>> +
>> +static int vq_show(struct seq_file *seq, void *v)
>> +{
>> +       struct pds_vdpa_vq_info *vq = seq->private;
>> +
>> +       seq_printf(seq, "ready:      %d\n", vq->ready);
>> +       seq_printf(seq, "desc_addr:  %#llx\n", vq->desc_addr);
>> +       seq_printf(seq, "avail_addr: %#llx\n", vq->avail_addr);
>> +       seq_printf(seq, "used_addr:  %#llx\n", vq->used_addr);
>> +       seq_printf(seq, "q_len:      %d\n", vq->q_len);
>> +       seq_printf(seq, "qid:        %d\n", vq->qid);
>> +
>> +       seq_printf(seq, "doorbell:   %#llx\n", vq->doorbell);
>> +       seq_printf(seq, "avail_idx:  %d\n", vq->avail_idx);
>> +       seq_printf(seq, "used_idx:   %d\n", vq->used_idx);
>> +       seq_printf(seq, "irq:        %d\n", vq->irq);
>> +       seq_printf(seq, "irq-name:   %s\n", vq->irq_name);
>> +
>> +       seq_printf(seq, "hw_qtype:   %d\n", vq->hw_qtype);
>> +       seq_printf(seq, "hw_qindex:  %d\n", vq->hw_qindex);
>> +
>> +       return 0;
>> +}
>> +DEFINE_SHOW_ATTRIBUTE(vq);
>> +
>> +void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux)
>> +{
>> +       int i;
>> +
>> +       debugfs_create_file("config", 0400, vdpa_aux->dentry, vdpa_aux->pdsv, &config_fops);
>> +
>> +       for (i = 0; i < vdpa_aux->pdsv->num_vqs; i++) {
>> +               char name[8];
>> +
>> +               snprintf(name, sizeof(name), "vq%02d", i);
>> +               debugfs_create_file(name, 0400, vdpa_aux->dentry,
>> +                                   &vdpa_aux->pdsv->vqs[i], &vq_fops);
>> +       }
>> +}
>> +
>> +void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux)
>> +{
>> +       debugfs_remove_recursive(vdpa_aux->dentry);
>> +       vdpa_aux->dentry = NULL;
>> +}
>>   #endif /* CONFIG_DEBUG_FS */
>> diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
>> index fff078a869e5..23e8345add0d 100644
>> --- a/drivers/vdpa/pds/debugfs.h
>> +++ b/drivers/vdpa/pds/debugfs.h
>> @@ -10,9 +10,17 @@
>>
>>   void pds_vdpa_debugfs_create(void);
>>   void pds_vdpa_debugfs_destroy(void);
>> +void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux);
>> +void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux);
>> +void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux);
>> +void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux);
>>   #else
>>   static inline void pds_vdpa_debugfs_create(void) { }
>>   static inline void pds_vdpa_debugfs_destroy(void) { }
>> +static inline void pds_vdpa_debugfs_add_pcidev(struct pds_vdpa_aux *vdpa_aux) { }
>> +static inline void pds_vdpa_debugfs_add_ident(struct pds_vdpa_aux *vdpa_aux) { }
>> +static inline void pds_vdpa_debugfs_add_vdpadev(struct pds_vdpa_aux *vdpa_aux) { }
>> +static inline void pds_vdpa_debugfs_del_vdpadev(struct pds_vdpa_aux *vdpa_aux) { }
>>   #endif
>>
>>   #endif /* _PDS_VDPA_DEBUGFS_H_ */
>> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
>> index 15d623297203..2e0a5078d379 100644
>> --- a/drivers/vdpa/pds/vdpa_dev.c
>> +++ b/drivers/vdpa/pds/vdpa_dev.c
>> @@ -5,6 +5,7 @@
>>   #include <linux/vdpa.h>
>>   #include <uapi/linux/vdpa.h>
>>   #include <linux/virtio_pci_modern.h>
>> +#include <uapi/linux/virtio_pci.h>
>>
>>   #include <linux/pds/pds_core.h>
>>   #include <linux/pds/pds_adminq.h>
>> @@ -13,7 +14,426 @@
>>
>>   #include "vdpa_dev.h"
>>   #include "aux_drv.h"
>> +#include "cmds.h"
>> +#include "debugfs.h"
>>
>> +static struct pds_vdpa_device *vdpa_to_pdsv(struct vdpa_device *vdpa_dev)
>> +{
>> +       return container_of(vdpa_dev, struct pds_vdpa_device, vdpa_dev);
>> +}
>> +
>> +static int pds_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
>> +                                  u64 desc_addr, u64 driver_addr, u64 device_addr)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       pdsv->vqs[qid].desc_addr = desc_addr;
>> +       pdsv->vqs[qid].avail_addr = driver_addr;
>> +       pdsv->vqs[qid].used_addr = device_addr;
>> +
>> +       return 0;
>> +}
>> +
>> +static void pds_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid, u32 num)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       pdsv->vqs[qid].q_len = num;
>> +}
>> +
>> +static void pds_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       iowrite16(qid, pdsv->vqs[qid].notify);
>> +}
>> +
>> +static void pds_vdpa_set_vq_cb(struct vdpa_device *vdpa_dev, u16 qid,
>> +                              struct vdpa_callback *cb)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       pdsv->vqs[qid].event_cb = *cb;
>> +}
>> +
>> +static irqreturn_t pds_vdpa_isr(int irq, void *data)
>> +{
>> +       struct pds_vdpa_vq_info *vq;
>> +
>> +       vq = data;
>> +       if (vq->event_cb.callback)
>> +               vq->event_cb.callback(vq->event_cb.private);
>> +
>> +       return IRQ_HANDLED;
>> +}
>> +
>> +static void pds_vdpa_release_irq(struct pds_vdpa_device *pdsv, int qid)
>> +{
>> +       if (pdsv->vqs[qid].irq == VIRTIO_MSI_NO_VECTOR)
>> +               return;
>> +
>> +       free_irq(pdsv->vqs[qid].irq, &pdsv->vqs[qid]);
>> +       pdsv->vqs[qid].irq = VIRTIO_MSI_NO_VECTOR;
>> +}
>> +
>> +static void pds_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev, u16 qid, bool ready)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pci_dev *pdev = pdsv->vdpa_aux->padev->vf->pdev;
>> +       struct device *dev = &pdsv->vdpa_dev.dev;
>> +       int irq;
>> +       int err;
>> +
>> +       dev_dbg(dev, "%s: qid %d ready %d => %d\n",
>> +               __func__, qid, pdsv->vqs[qid].ready, ready);
>> +       if (ready == pdsv->vqs[qid].ready)
>> +               return;
>> +
>> +       if (ready) {
>> +               irq = pci_irq_vector(pdev, qid);
>> +               snprintf(pdsv->vqs[qid].irq_name, sizeof(pdsv->vqs[qid].irq_name),
>> +                        "vdpa-%s-%d", dev_name(dev), qid);
>> +
>> +               err = request_irq(irq, pds_vdpa_isr, 0,
>> +                                 pdsv->vqs[qid].irq_name, &pdsv->vqs[qid]);
>> +               if (err) {
>> +                       dev_err(dev, "%s: no irq for qid %d: %pe\n",
>> +                               __func__, qid, ERR_PTR(err));
>> +                       return;
>> +               }
>> +               pdsv->vqs[qid].irq = irq;
>> +
>> +               /* Pass vq setup info to DSC */
>> +               err = pds_vdpa_cmd_init_vq(pdsv, qid, &pdsv->vqs[qid]);
>> +               if (err) {
>> +                       pds_vdpa_release_irq(pdsv, qid);
>> +                       ready = false;
>> +               }
>> +       } else {
>> +               err = pds_vdpa_cmd_reset_vq(pdsv, qid);
>> +               if (err)
>> +                       dev_err(dev, "%s: reset_vq failed qid %d: %pe\n",
>> +                               __func__, qid, ERR_PTR(err));
>> +               pds_vdpa_release_irq(pdsv, qid);
>> +       }
>> +
>> +       pdsv->vqs[qid].ready = ready;
>> +}
>> +
>> +static bool pds_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +
>> +       return pdsv->vqs[qid].ready;
>> +}
>> +
>> +static int pds_vdpa_set_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
>> +                                const struct vdpa_vq_state *state)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_vq_set_state_cmd cmd = {
>> +               .opcode = PDS_VDPA_CMD_VQ_SET_STATE,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +               .qid = cpu_to_le16(qid),
>> +       };
>> +       struct pds_vdpa_comp comp = {0};
>> +       int err;
>> +
>> +       dev_dbg(dev, "%s: qid %d avail %#x\n",
>> +               __func__, qid, state->packed.last_avail_idx);
>> +
>> +       if (pdsv->actual_features & VIRTIO_F_RING_PACKED) {
>> +               cmd.avail = cpu_to_le16(state->packed.last_avail_idx |
>> +                                       (state->packed.last_avail_counter << 15));
>> +               cmd.used = cpu_to_le16(state->packed.last_used_idx |
>> +                                      (state->packed.last_used_counter << 15));
>> +       } else {
>> +               cmd.avail = cpu_to_le16(state->split.avail_index);
>> +               /* state->split does not provide a used_index:
>> +                * the vq will be set to "empty" here, and the vq will read
>> +                * the current used index the next time the vq is kicked.
>> +                */
>> +               cmd.used = cpu_to_le16(state->split.avail_index);
>> +       }
>> +
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&cmd,
>> +                                    sizeof(cmd),
>> +                                    (union pds_core_adminq_comp *)&comp,
>> +                                    0);
> 
> I had one question for adminq command. I think we should use PF
> instead of VF but in __pdsc_adminq_post() I saw:
> 
>          q_info->dest = comp;
>          memcpy(q_info->desc, cmd, sizeof(*cmd));
> 
> So cmd should be fine since it is copied to the q_info->desc which is
> already mapped. But q_info->dest look suspicious, where did it mapped?

The queue descriptors get allocated and mapped as a large single block 
in pdsc_qcq_alloc() with a call to dma_alloc_coherent(), then 
pdsc_q_map() sets up the q_info[].dest pointers.


> 
> Thanks
> 
> 
>> +       if (err)
>> +               dev_err(dev, "Failed to set vq state qid %u, status %d: %pe\n",
>> +                       qid, comp.status, ERR_PTR(err));
>> +
>> +       return err;
>> +}
>> +
>> +static int pds_vdpa_get_vq_state(struct vdpa_device *vdpa_dev, u16 qid,
>> +                                struct vdpa_vq_state *state)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
>> +       struct device *dev = &padev->aux_dev.dev;
>> +       struct pds_vdpa_vq_get_state_cmd cmd = {
>> +               .opcode = PDS_VDPA_CMD_VQ_GET_STATE,
>> +               .vdpa_index = pdsv->vdpa_index,
>> +               .vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
>> +               .qid = cpu_to_le16(qid),
>> +       };
>> +       struct pds_vdpa_vq_get_state_comp comp = {0};
>> +       int err;
>> +
>> +       dev_dbg(dev, "%s: qid %d\n", __func__, qid);
>> +
>> +       err = padev->ops->adminq_cmd(padev,
>> +                                    (union pds_core_adminq_cmd *)&cmd,
>> +                                    sizeof(cmd),
>> +                                    (union pds_core_adminq_comp *)&comp,
>> +                                    0);
>> +       if (err) {
>> +               dev_err(dev, "Failed to get vq state qid %u, status %d: %pe\n",
>> +                       qid, comp.status, ERR_PTR(err));
>> +               return err;
>> +       }
>> +
>> +       if (pdsv->actual_features & VIRTIO_F_RING_PACKED) {
>> +               state->packed.last_avail_idx = le16_to_cpu(comp.avail) & 0x7fff;
>> +               state->packed.last_avail_counter = le16_to_cpu(comp.avail) >> 15;
>> +       } else {
>> +               state->split.avail_index = le16_to_cpu(comp.avail);
>> +               /* state->split does not provide a used_index. */
>> +       }
>> +
>> +       return err;
>> +}
>> +
>> +static struct vdpa_notification_area
>> +pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
>> +{
>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>> +       struct virtio_pci_modern_device *vd_mdev;
>> +       struct vdpa_notification_area area;
>> +
>> +       area.addr = pdsv->vqs[qid].notify_pa;
>> +
>> +       vd_mdev = &pdsv->vdpa_aux->vd_mdev;
>> +       if (!vd_mdev->notify_offset_multiplier)
>> +               area.size = PAGE_SIZE;
> 
> Note that PAGE_SIZE varies among archs, I doubt we should use a fixed size here.

Yeah, good thought, I'll fix that up.

> 
> Others look good.
> 
> Thanks
> 
