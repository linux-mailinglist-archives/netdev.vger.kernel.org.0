Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124406BC4B0
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCPD1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCPD0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:26:40 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792AEA90A7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:25:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0BnK5erMAHiTOo35Cuilo/LuiWTH9FQoKoXkFCSbvtIUQv3LAHt0kF0qKFMW5NHUaY9B4BKxXB8oLpiY7tjwVk/G++i2Gt+btoiPYElkLuSbyQbcGSLYRGEiS902hV49kvpfmGghbNcsVFt/Dek0ifrodS0NhiJS1zf60AADuGy3hphatZ9wWYeksZH4xlDu6nt+0n0yHxwc77lZOnXtfeRSnfkpNw+hKfy187zTHfdpxemyYWYIKyArpNyGitstYvDtFvV7p3TQmAXBpRKbO6dDW7M1j3SlglP9/RlKuzoV9CXDyahlRDFRPIHLpdVWBja46dUIb2q3cj3km3iGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zBn/36TSvS/XC+u79olWbHCED3YVns09tcw6HBSX5o=;
 b=QJrBG4fIDP2l1FCu9gmr8EfGZt6ir9a20O2csknDtskPJ40+ePOto5NBJt70lbZDQ+c4eQYyy8YTOf/3Bw9E5CQU0sB/e8pNCRxpnLc1Y6xtzDx7OMbATiYGV2NyN4wRV7/SGu9HrOJOZvH5ZZAp8mC3ElxNdDppQLSuZH1rY2desz3u7R2Dxy+K2CtqyebIdxGycnzu8C44ESbSSh2OPHSGu0EdSASKi1MiW6bLqWmGhDrHmacUPa48ol+AUd25eMRDP3L+2Q5JG8XyRoWo5jPSQ1Y9nMYaALFi2Em1V/NWly0k2fPyHNk690FU6pFfmcRzdMX2Nc4Tw39IEVt1HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zBn/36TSvS/XC+u79olWbHCED3YVns09tcw6HBSX5o=;
 b=RxkVmqkHn06wbPXGP5Kj99vO25MXE6stUjEAg4qy/44wGRBUYqMWMOLwYGyN+FmfaHO0ZozCtN2lxViEPzO/dJJXEhHViw0RlTarAlh5zYRca85HSNH3Ey+YdjfwBuErxVPiyhh/U8gyKmLfgY/8cwTINuOVJs2e3wV12q55IIg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CY8PR12MB8215.namprd12.prod.outlook.com (2603:10b6:930:77::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Thu, 16 Mar 2023 03:25:08 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%8]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 03:25:08 +0000
Message-ID: <ad9ab1f3-43ff-a73d-0a62-50565aa5196f@amd.com>
Date:   Wed, 15 Mar 2023 20:25:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v2 virtio 2/7] pds_vdpa: get vdpa management info
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-3-shannon.nelson@amd.com>
 <CACGkMEumJLysw4Grd19fVF-LuUb+r201XWMaeCkT=kDqN41ZTg@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEumJLysw4Grd19fVF-LuUb+r201XWMaeCkT=kDqN41ZTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CY8PR12MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: dedc056b-68cb-44e0-dbd7-08db25ce0b33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6EDB0LX4Tx4AhT45GJTCIXxzx5vLRQMt4Xgm+ip/gs6f5v9hBEiurjBEVOKAHOPeqObbAkvfW4HEsP/LFV85uCO1BKZ+3QbPZaqXxLWxt8F1FTFmxtls52J5OHF2QCFiRgubJhH12qndIeSyCccfm8Vx2O+XiYrpuG4pfwk+vqasdTWAEjyhva+fwL2hWFJep8uwXoSwxVD8iCIHsejhurigG0C4pew2ThUvtBvFA1lFz/1aBCBJMKwUWTnubbANChgbAoY44Lb7dv0skBrWchPXuzPl3TpwsUnUit2gdHD1WsSSQ3GzLyBnOb05Rl/Khuw4Votfnx9aR7KdAaIr7TxTjaIVZDPeUhjlZEQp5Bmeflgb+0CRZUBdlbEFzgglLuT0kLPaFjzauox/VKft8kJQiUaocWM/JR63KTmP1mSYfTqVfM1BGu27zhcwD0bdiKKtOzW/VHirgwhsLj8DqXqtRX7gezHhPc2OyXuDGD6gX0s6EfDyUK+AEUpEa66oGW6HVQKYUSak+KzP93EgbCT4tVd8fY81yvgT8C5zCh+1b/mjX28DDOHMDy4FmTXUpVqp5zI/dFyiFvFSXr1l0zFuzDvqZxfdOv054NVhv2oYAVBMNsERDO/FVCbePQsI80x4IKswLCOcjbGfaujBnqLjFfMxoTJQukKLVYVg0wFuDgQGYTGdg3Nb1kA7NKiRiMwtQEAsU39zODBJJFZfM358EL4h0BRg9HGydyB3opk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199018)(2616005)(26005)(478600001)(6486002)(53546011)(36756003)(186003)(6512007)(6666004)(316002)(6506007)(38100700002)(5660300002)(86362001)(41300700001)(31696002)(8936002)(31686004)(44832011)(83380400001)(2906002)(66476007)(66946007)(66556008)(4326008)(6916009)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDNqZTlyUmVVRzNhS0R5RUdadDhPVmdkdWVQUU53Z2tySDhZbkNya3lVOXZV?=
 =?utf-8?B?V1VKVXRjd21QSlRHQ2hZeEZkTnlweE9PRWZNbGRDT0ErSjBGcFo0ODBRT3Aw?=
 =?utf-8?B?RXMzVWxNMXVMakdld053K1ZzMXBtMmJEQjdQWmgzdEZyMFFLdGpsQlA2dXlv?=
 =?utf-8?B?Qkl3ZDhkdDNxZmdVVG5vU0pXc2dwS3l3UHFvQ2Jnd0xKazg3djRWeUR6YTZx?=
 =?utf-8?B?WURveEtCUGhzZ3BSQTRaVFE5WWtOMkdzdmhvT1NGR3d6ZERCdGJ6cTByTzhl?=
 =?utf-8?B?eis3L3FqeUFKbTN0MHJTYnZiNnZCQlJ0Vk16WW1MR0RFUW9ORE9pR0lxQWdL?=
 =?utf-8?B?NVdxYlNpWlpDVng2amNNc3ZjWElTNUZZNGw1RmExck9sZ1lXUVZ1SVE4TzJj?=
 =?utf-8?B?OXdYZnN4c214bXE0bHNNa1JjeVNDbXZnVU9CUFN6b2tLbndqbVE1bk05cWJx?=
 =?utf-8?B?bG41YkxBRlVWdDBFWEhEMUlkUWorTlFXYllaREVqK1BrbkpPcWlpZGdRYUor?=
 =?utf-8?B?R0Myc0dwNXB0MjlwSU1HUE5rYmtyREFINXAwTjlQLzVBUmxaVXhVMi9xd1lE?=
 =?utf-8?B?Uk54YmpadDc1N0lOSVdTVXJTYXJIa0dPNkdTcGY1WGMrSzRuRWttMnFLUlVR?=
 =?utf-8?B?YzNwZkNYTVliNklVUy80a2xkMjFwM3duMEF3Q1NPd3g3bG9kQ1JmUjh4M2Vs?=
 =?utf-8?B?TXVKaUlrNHU2MFFLV0dnd0g2NXZYQnZZdVhheDJPYVFpenFHK3VNRDE0MFc2?=
 =?utf-8?B?Mm5KVGJEemExRklvZlh3RWVxcGV6THdEY2RDOWEwQkNJa1N5SzFWcWVYa0Fo?=
 =?utf-8?B?TW5VQnlYY2M4Nzlwano0SmFHV05SVTFzbkRycTZubk04eGRqbFBjYWdRSnIx?=
 =?utf-8?B?c1N2dHpUODBjYXQ4b3NoUTQ5SnpQbDE1NWpqZW8wMW1HUkh1a2p3OEs0V2RD?=
 =?utf-8?B?MkdxY0l4VGFhSDU1Rit1ZlY5NGliUmFsSXYrZ2pqYWpwVXBNWmt5U0RUVk1M?=
 =?utf-8?B?ZmVNaXFqd0NuT1B0TjkzKzI4NVNKWk5PajdOZC9KdlAxN0RTSzlIWnJVaTRw?=
 =?utf-8?B?SDZYSDY4RXFhQ3pRQkRrRWs3QWpPTUdPenBGaExCb3NqRVIxS2Z3cVArMXE2?=
 =?utf-8?B?SU1aNHBsYkQ4cVFmeW5yN29nSitzdlV6Q081ZTdtSDl3MHNCZzBFNUcwbk5h?=
 =?utf-8?B?Sll1cEFNbXVRWnV3MytqdjF4Z0ZLUHJBYUttQnRpZFVIWll4amtrWmdnREZM?=
 =?utf-8?B?RmpmVWpLbjVzYXBlanRLcVl3UFBwL2hPT2cvQ3JlWVovNmlCdHJkMzB1eGhw?=
 =?utf-8?B?YUNLczNoK2ZIa3RJbCtsbmpuV3FZblhSMUNMMVp3MzBVdUhaTXB0NmhWL1c5?=
 =?utf-8?B?bUpaZUhUTnBpWUZtelV4clNlRmFqdDFiQ2Erc2VNNmxiVjNuODBkTnRaVGp0?=
 =?utf-8?B?WmRaM0JydHBvd09qajhZWlJJVHMxWko1UmZOS3hTQmREdHpLdWdiRFNhUVpM?=
 =?utf-8?B?QXVZZlJMRFdnZEUyTEU3TmRZNXZONVdnejhKUURmVHdKMGpXaXg0NU1kcGov?=
 =?utf-8?B?VU5WdERwdzNRRTdaVE0vRnZFZERzMWo1YjBYSnFQYVR0cTBxSlNYQitaUGVZ?=
 =?utf-8?B?U0ZrenQ1b3NXR3ROU0N4RTIzVC92T244RjFZbGV2Nm16ZUdrVGhhc1JwVW5s?=
 =?utf-8?B?TFhGM1dNcjZiV0xrcHU5aFNOb04rNm1NYUJTRUE4WTJSRmFqblVMQXEyQnRJ?=
 =?utf-8?B?ci82UHVFSWxoUzV4K2ZmcU9Mem92T05VRkJuU0hjcnU0dUNkSVY4ZzdKQUl2?=
 =?utf-8?B?RVBzOHV6bFlsazVyU1k3RFBDcHVOdkc4MFFhT21ObzdwNy8rN0FSOTYxS01B?=
 =?utf-8?B?bCsxT1pzMU5KZEsvUXdSSTh6R3FRek1GdUJ2SERTUFJsQUJFME9tU2JnalJP?=
 =?utf-8?B?dkI2dHcrZW1zQXE2cTM0Q1cvelRQWDZBQVdMRjZWSnhXc1J4RklyOXRNeGdv?=
 =?utf-8?B?Q2N1a2RkdXIyRUl4YU5lUHNGUW0ySStWbEJqK0UxaC9kTE8wS3dibUR1a1hj?=
 =?utf-8?B?WHg3bDJiRkM5dTN6a2puTkRWUmgxbWEzQ0RzenlXYXQvN3FYbDBtaVcwZGR6?=
 =?utf-8?Q?/eS64Ak8yiJnmugS0fMWndCLH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedc056b-68cb-44e0-dbd7-08db25ce0b33
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 03:25:08.5901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHflFIKSPR3lCfRaE4dnKTVgSHwaCr7dhFovJMkDguqROMdlVaRW8qloK3qHm/kT+KAlj9IQ9gw0WILVOn3jbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8215
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 12:05 AM, Jason Wang wrote:
> On Thu, Mar 9, 2023 at 9:31 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> Find the vDPA management information from the DSC in order to
>> advertise it to the vdpa subsystem.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/vdpa/pds/Makefile    |   3 +-
>>   drivers/vdpa/pds/aux_drv.c   |  13 ++++
>>   drivers/vdpa/pds/aux_drv.h   |   7 +++
>>   drivers/vdpa/pds/debugfs.c   |   3 +
>>   drivers/vdpa/pds/vdpa_dev.c  | 113 +++++++++++++++++++++++++++++++++++
>>   drivers/vdpa/pds/vdpa_dev.h  |  15 +++++
>>   include/linux/pds/pds_vdpa.h |  92 ++++++++++++++++++++++++++++
>>   7 files changed, 245 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/vdpa/pds/vdpa_dev.c
>>   create mode 100644 drivers/vdpa/pds/vdpa_dev.h
>>
>> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
>> index a9cd2f450ae1..13b50394ec64 100644
>> --- a/drivers/vdpa/pds/Makefile
>> +++ b/drivers/vdpa/pds/Makefile
>> @@ -3,6 +3,7 @@
>>
>>   obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
>>
>> -pds_vdpa-y := aux_drv.o
>> +pds_vdpa-y := aux_drv.o \
>> +             vdpa_dev.o
>>
>>   pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
>> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
>> index b3f36170253c..63e40ae68211 100644
>> --- a/drivers/vdpa/pds/aux_drv.c
>> +++ b/drivers/vdpa/pds/aux_drv.c
>> @@ -2,6 +2,8 @@
>>   /* Copyright(c) 2023 Advanced Micro Devices, Inc */
>>
>>   #include <linux/auxiliary_bus.h>
>> +#include <linux/pci.h>
>> +#include <linux/vdpa.h>
>>
>>   #include <linux/pds/pds_core.h>
>>   #include <linux/pds/pds_auxbus.h>
>> @@ -9,6 +11,7 @@
>>
>>   #include "aux_drv.h"
>>   #include "debugfs.h"
>> +#include "vdpa_dev.h"
>>
>>   static const struct auxiliary_device_id pds_vdpa_id_table[] = {
>>          { .name = PDS_VDPA_DEV_NAME, },
>> @@ -30,6 +33,7 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
>>                  return -ENOMEM;
>>
>>          vdpa_aux->padev = padev;
>> +       vdpa_aux->vf_id = pci_iov_vf_id(padev->vf->pdev);
>>          auxiliary_set_drvdata(aux_dev, vdpa_aux);
>>
>>          /* Register our PDS client with the pds_core */
>> @@ -40,8 +44,15 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
>>                  goto err_free_mem;
>>          }
>>
>> +       /* Get device ident info and set up the vdpa_mgmt_dev */
>> +       err = pds_vdpa_get_mgmt_info(vdpa_aux);
>> +       if (err)
>> +               goto err_aux_unreg;
>> +
>>          return 0;
>>
>> +err_aux_unreg:
>> +       padev->ops->unregister_client(padev);
>>   err_free_mem:
>>          kfree(vdpa_aux);
>>          auxiliary_set_drvdata(aux_dev, NULL);
>> @@ -54,6 +65,8 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
>>          struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
>>          struct device *dev = &aux_dev->dev;
>>
>> +       pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
>> +
>>          vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
>>
>>          kfree(vdpa_aux);
>> diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
>> index 14e465944dfd..94ba7abcaa43 100644
>> --- a/drivers/vdpa/pds/aux_drv.h
>> +++ b/drivers/vdpa/pds/aux_drv.h
>> @@ -10,6 +10,13 @@
>>   struct pds_vdpa_aux {
>>          struct pds_auxiliary_dev *padev;
>>
>> +       struct vdpa_mgmt_dev vdpa_mdev;
>> +
>> +       struct pds_vdpa_ident ident;
>> +
>> +       int vf_id;
>>          struct dentry *dentry;
>> +
>> +       int nintrs;
>>   };
>>   #endif /* _AUX_DRV_H_ */
>> diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
>> index 3c163dc7b66f..7b7e90fd6578 100644
>> --- a/drivers/vdpa/pds/debugfs.c
>> +++ b/drivers/vdpa/pds/debugfs.c
>> @@ -1,7 +1,10 @@
>>   // SPDX-License-Identifier: GPL-2.0-only
>>   /* Copyright(c) 2023 Advanced Micro Devices, Inc */
>>
>> +#include <linux/vdpa.h>
>> +
>>   #include <linux/pds/pds_core.h>
>> +#include <linux/pds/pds_vdpa.h>
>>   #include <linux/pds/pds_auxbus.h>
>>
>>   #include "aux_drv.h"
>> diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
>> new file mode 100644
>> index 000000000000..bd840688503c
>> --- /dev/null
>> +++ b/drivers/vdpa/pds/vdpa_dev.c
>> @@ -0,0 +1,113 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#include <linux/pci.h>
>> +#include <linux/vdpa.h>
>> +#include <uapi/linux/vdpa.h>
>> +
>> +#include <linux/pds/pds_core.h>
>> +#include <linux/pds/pds_adminq.h>
>> +#include <linux/pds/pds_auxbus.h>
>> +#include <linux/pds/pds_vdpa.h>
>> +
>> +#include "vdpa_dev.h"
>> +#include "aux_drv.h"
>> +
>> +static struct virtio_device_id pds_vdpa_id_table[] = {
>> +       {VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
>> +       {0},
>> +};
>> +
>> +static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>> +                           const struct vdpa_dev_set_config *add_config)
>> +{
>> +       return -EOPNOTSUPP;
>> +}
>> +
>> +static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
>> +                            struct vdpa_device *vdpa_dev)
>> +{
>> +}
>> +
>> +static const struct vdpa_mgmtdev_ops pds_vdpa_mgmt_dev_ops = {
>> +       .dev_add = pds_vdpa_dev_add,
>> +       .dev_del = pds_vdpa_dev_del
>> +};
>> +
>> +int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux)
>> +{
>> +       struct pds_vdpa_ident_cmd ident_cmd = {
>> +               .opcode = PDS_VDPA_CMD_IDENT,
>> +               .vf_id = cpu_to_le16(vdpa_aux->vf_id),
>> +       };
>> +       struct pds_vdpa_comp ident_comp = {0};
>> +       struct vdpa_mgmt_dev *mgmt;
>> +       struct device *pf_dev;
>> +       struct pci_dev *pdev;
>> +       dma_addr_t ident_pa;
>> +       struct device *dev;
>> +       u16 max_vqs;
>> +       int err;
>> +
>> +       dev = &vdpa_aux->padev->aux_dev.dev;
>> +       pdev = vdpa_aux->padev->vf->pdev;
>> +       mgmt = &vdpa_aux->vdpa_mdev;
>> +
>> +       /* Get resource info through the PF's adminq.  It is a block of info,
>> +        * so we need to map some memory for PF to make available to the
>> +        * firmware for writing the data.
>> +        */
> 
> It looks to me pds_vdpa_ident is not very large:
> 
> struct pds_vdpa_ident {
>          __le64 hw_features;
>          __le16 max_vqs;
>          __le16 max_qlen;
>          __le16 min_qlen;
> };
> 
> Any reason it is not packed into some type of the comp structure of adminq?

Unfortunately, the completion structs are limited to 16 bytes, with 4 up 
front and 1 at the end already spoken for.  I suppose we could shrink 
max_vqs to a single byte and squeeze this into the comp, but then we'd 
have no ability to add to it if needed.  I'd rather leave it as it is 
for now.

sln

> 
> Others look good.
> 
> Thanks
> 
