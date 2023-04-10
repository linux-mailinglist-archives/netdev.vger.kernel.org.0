Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8DB6DCBFD
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 22:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbjDJUCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 16:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjDJUCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 16:02:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9F01FC2
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 13:02:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFewIZWlv+cFh9313g5cqCu0OBsLfJRYhamnTvXlzwcoq+HdeU8vBGyxSNQrnrsY7w9N+tMtOT8enRkRjtVWaq4PW62oCatNoKTNZ6+zgO7aNXOpvlwB5nB9Ot71B2MwVFEZ32h/OATGyu3oAfC4eVGQdERtUSRJ3mSQsgmaVFR0pVfRfLZrPnQmhn4Bhxcv0agP8ULoX4BQoBgU9m8N1oV9eYaHGeM8cgWaERj4x0/WTbnrN18PaBK99VtiQRQuaZ8zlQeGESbmRPoeURJ7t2l72RqD2Ws7RvrxH5pHNa56C2Qb4SzcNvIbX3N/lGQT9NcWU6a4+xD16tTmN23Xfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mEPes5cGkULpLatm3CI7wIvQfefR/eTpHfpvZbfBW9o=;
 b=dQvOYojYspxbLRVK3rSEPLKDqkPOz/x9m4qwDl2IE6d81GEHdPQ9LKBRttE9iC2FCebR8sF0oyASraXDRp3GIcXYFutrN0W3p/l94Me93BOWBTy1iJLTyki81KPAq4gOiF0QOXGtqrOgEv0HX2qhKQ3RMT/OJKhWLjNxz6Gihb1FK+n+TYratF3kP69Ym0O5+oRvVjrDCQv4Yn9HMK66TXgccCNUm38HE+I/ufEXiSE1WlahK+Wq1xAhHrMZNORrp6CkLqXzrUtOj8/Qp1873yqIbTlfgTklyaZ2wq15iHQhp9o9cg+1NSz37KnIIV/lRN82mRaf5RULNOlKtkD9wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEPes5cGkULpLatm3CI7wIvQfefR/eTpHfpvZbfBW9o=;
 b=FKoyem04ZAiVvZjOn+zVeeuqUvHVYrZ6SNKcHdaa7Nyq/+EgyFR8FZf9JPGB/smFOvCIyGyKoak1zsC8sFrR3B9O4tltjzKj5YZpYP+IKU8H7xGSVctfmoDb3gpjSnEWYhJ/nkLV3/qrC84STpFmlf874AiEHd86TCbCyEXYGyk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MN2PR12MB4064.namprd12.prod.outlook.com (2603:10b6:208:1d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 10 Apr
 2023 20:02:12 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 20:02:12 +0000
Message-ID: <b075b886-84c6-61d3-c181-7e1ae4152ef6@amd.com>
Date:   Mon, 10 Apr 2023 13:02:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 10/14] pds_core: add auxiliary_bus devices
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-11-shannon.nelson@amd.com>
 <20230409122316.GF182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409122316.GF182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:a03:74::40) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MN2PR12MB4064:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f850323-8024-49f0-5d7d-08db39fe7985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPRGQ8PV/SsCGE6KQ/27fz94fZ/6dEXsCqR3Sijh+KDx3OeBYzo/ahMxgfReTtoTmJuQEoLXeTCCINVQk78a0nSBuCuXQemX/a0EVFbVzB0iq6kF5GxxH14XyXiKo3XC1lY6cvgSsHgHNK/0MFEv+3zDwM98bxeICByuoI6GgR8zAUlNOA2L+GeFVPUmtitSuqnCL7T0Pc8r4AoX978SYdQXZeOzIpayQy1AT6NDcubrrLG0fj/Rj6ITINVD27N2w0IGF9Vsm2h3nWeBvoeEsrtriVD7jRYRvc+dEd8GMrzzoHLPOa6Kda2PWb0XbdBQJqnLzkb2axDja12+eKcJn8wVs0NuBIALUaEAZts1qoIrpuPsZPVL6P+hpR0suFZOy9HVU4G+AVKa42s6qW6cR4md0hp3x1/XGQOz/paw+ROFhAIxGUldKXp1Vb7BWMUloo/rOr8sTZdcEQxWGJ/x/8f4VeoEN+P+JfUhS7jtbf6vl4PBYFl10+cDkDC5v99IrkjzBAIcQs/tKRkA9JVC8D0U4ku96PYu0Fn/ov//mUFy5UhaJMX20AeuLF69jp1p5ILo3VZZMzAV1NCgurDAXoJjFo+i/JtJHKXYp8SShOXTpRDtOhz6ZwjF12w4mgK8YidyzN9jT5uzzxHXL5BFItXKKjIHbNpLnmwPip5y+l3NQWSKOo44l5rA7hD8TiGx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(38100700002)(44832011)(5660300002)(2616005)(4326008)(26005)(83380400001)(316002)(31696002)(86362001)(53546011)(186003)(36756003)(6486002)(6506007)(6512007)(478600001)(66556008)(66946007)(8676002)(66476007)(6916009)(8936002)(41300700001)(31686004)(2906002)(66899021)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjZyUEVTWGdtZ0ZlTkJNYTN2M0Zib1ZZUHZURkRScTNkZFR1MWk0TEFzaS9t?=
 =?utf-8?B?TXBLWkRjSlRNaXJ0TlJON0N4bWltWXh6MWVIYUlzaE8vb29RKzVrb0tTQUZh?=
 =?utf-8?B?ejNXUm9VNEpOSnd5VittcEFwSzhPcHJieXluQXNEY0l0T3BjUVNHRTNHWGl0?=
 =?utf-8?B?dFZxN0Frd3AwbEtyU1gxK2lRcFJnRTJxUGJjcjJ0M05mMUJOWVRnamVuUVpY?=
 =?utf-8?B?RUZqL1d4enFLRC9wb3ZQbWp6aTdZZmJxYXk3bi9zNGh3UHRreDVYbWkzYlcw?=
 =?utf-8?B?Y1kyVTZSMHZqTHBrN2t1a1ZPcXExbXAycDRoTHUvR3RBSXpNTG9iTzRoVzZY?=
 =?utf-8?B?K3lPNWp1eCtiY2ZwaHcxVFN2bnVDRFlqcForZFV1QStwcW53bzNkNjhKV2Zl?=
 =?utf-8?B?VVI5V0dIVnlaVmxUWFd4cVhadVZ4My9qdExrakFZRlcwalYwaHlscXdNcnRx?=
 =?utf-8?B?VXI0QnBwZGhIZXF5bndGbC9jZmsrOWdmeHh4bjBHOHBGM1c5aTR3cXpXcU1F?=
 =?utf-8?B?UUM4QWNVVzRZSWw2QVd6Y0lGMUxCSHJpd09ONmQvTW9UT1dIeCtwVHdsQitM?=
 =?utf-8?B?WU5wKzVaS3pacCtBWTA3MFowM25DTGxpRWFnTnpmOGFRS0J6UWk4cGVLeWQr?=
 =?utf-8?B?TlFqNzhNYi8reER4OXpyQTI2Z0xRVnlxZjIzbmYxVFBxakM5OTA4K0R6ZE1Z?=
 =?utf-8?B?ZFRUZjdSaWxmZDRvM2N3UEVIeFppZFhQWVQ2Wk1ra0hYbnlTcVRMengrckh4?=
 =?utf-8?B?bFBOczQ5M3crM0pNbEpzazc4Q1ZNRDZ3UnFDOHo5NEtaVXJEU3ZLV1R1bjlD?=
 =?utf-8?B?WURYU3RlZkh0NFNYUGg5Q0xxL21OaC9sQWJqMDRVSDMxMldCOEtZMUE2eGpz?=
 =?utf-8?B?WW9IV1dzM3F4TlhqMHpIVFFPdjN0QTdqa1BsQU5LbTNId0JCOVE5MERTd1lC?=
 =?utf-8?B?ZzE4akJINWEvOHo5dkQybDlBWU9LYkxlUGtqNGFUU0pnd2JPVGxRY2ovYkhK?=
 =?utf-8?B?UWwzWVZCZDFmOVVydlRGdW1ZdlltenI5RUVsdUFyQ3pqRm5MS3RDU2FaNEpD?=
 =?utf-8?B?MWlEQlZNNFhwWkYvREt2RHVqNXFqUVFtbkZ6TmxjYzNlc3VlRTFQY21reEY3?=
 =?utf-8?B?aUpWSDkzNTEzdlI5Y3k1S3NTK092NXB3MG5hNkdMamphdCtWSFVTMFFzOEZz?=
 =?utf-8?B?ZytkeUx0YmlnZS9nVWsxbzlIMFNIKy8rU2k4aitVb2hTcUgwNExqUU5HbVdR?=
 =?utf-8?B?NDM3UWNjcTFia0RtQzEzV0F0MnJWcjNvWGMxdkN5ejhMUVlmUmk4WnNMak1U?=
 =?utf-8?B?U2d5Nm1sRzJ0Q0d2QThmMG1CeXhhZUh3cDdCbFhCK0NJTG92M3lZRFBFdXpY?=
 =?utf-8?B?NGVla1N3YkxnVk0rMVJlRmJZWFNVNDNTYndhSlNBenBWazd3bjQ5dnJCSGZG?=
 =?utf-8?B?Z0g1RmdnaUJOU3hPclVhMEVXR3RDYUNGWUF4am9oVVo5MHNoNmpWOVo4bE1D?=
 =?utf-8?B?aW1GRDFSaXF5MHdXSTNibE5wQ3loYXhxMngvRm0vSmZLdHJSNmE5MEdrTHRr?=
 =?utf-8?B?R1pqemVtWG9jM2x2bUZFaFJJWkJMWW91TkwzazlQMnkvb241V3U1UHVyVTha?=
 =?utf-8?B?di9JZ2lXYWQ0TFZuQUk4Nnp0cElzWlJvSTlXbDU0VzVPTTQxV3haa1Y4NkRV?=
 =?utf-8?B?bFUzazZVTUdITzlMQXl2RUViaGtaZDdjaG96aC9FVjV5S0hNbXdxRFB1VkZC?=
 =?utf-8?B?UUZ1WEFoQVpHT3JvandRQWdVVzZlRlNlT1pvL2NmNkl5Uzc5cGFsR3FhUlNC?=
 =?utf-8?B?dmNpS2w1bGNubkU2Z2xMTFhRUUxvZmpSd2pXZ1E1aHZxSGFPYmhtbndHTmNK?=
 =?utf-8?B?eUhoUVE0am96NDJ0TWVCa0VLMVA1dHFqYXkzSC9wdnpYb0FYNDhoeFI0bk1m?=
 =?utf-8?B?RW01Q1gxeFNxTjNUZ21BTUdMRGFFNFFnTXE5bDFqZlArRDBjWi9NODM2UmE0?=
 =?utf-8?B?bTIybEozYi8yRTlnQ0k4WkdvWWpTaHhQT3EzTGpGd2ZtMkdsemwzWDU1aGND?=
 =?utf-8?B?NkpSeElzTExDVFNxQ3ZpMW8xWktNRDhyeDRRa0ppdk02OGxLbGUySCtYMkxl?=
 =?utf-8?Q?qjEc7wk4LlGIjmbUEpGH6xQAc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f850323-8024-49f0-5d7d-08db39fe7985
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 20:02:12.8169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alLCM5LPyWDZkXAVgjJl6Smk75x8fkbHyu0m6SFVy76TR9Nc9xjqXX2yBK6cn00BxacrxdZEspT4V31PjN8k7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4064
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 5:23 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:39PM -0700, Shannon Nelson wrote:
>> An auxiliary_bus device is created for each vDPA type VF at VF
>> probe and destroyed at VF remove.  The aux device name comes
>> from the driver name + VIF type + the unique id assigned at PCI
>> probe.  The VFs are always removed on PF remove, so there should
>> be no issues with VFs trying to access missing PF structures.
>>
>> The auxiliary_device names will look like "pds_core.vDPA.nn"
>> where 'nn' is the VF's uid.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/net/ethernet/amd/pds_core/Makefile |   1 +
>>   drivers/net/ethernet/amd/pds_core/auxbus.c | 112 +++++++++++++++++++++
>>   drivers/net/ethernet/amd/pds_core/core.h   |   6 ++
>>   drivers/net/ethernet/amd/pds_core/main.c   |  36 ++++++-
>>   include/linux/pds/pds_auxbus.h             |  16 +++
>>   include/linux/pds/pds_common.h             |   1 +
>>   6 files changed, 170 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
>>   create mode 100644 include/linux/pds/pds_auxbus.h
>>
>> diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
>> index 6d1d6c58a1fa..0abc33ce826c 100644
>> --- a/drivers/net/ethernet/amd/pds_core/Makefile
>> +++ b/drivers/net/ethernet/amd/pds_core/Makefile
>> @@ -5,6 +5,7 @@ obj-$(CONFIG_PDS_CORE) := pds_core.o
>>
>>   pds_core-y := main.o \
>>              devlink.o \
>> +           auxbus.o \
>>              dev.o \
>>              adminq.o \
>>              core.o \
>> diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
>> new file mode 100644
>> index 000000000000..6757a5174eb7
>> --- /dev/null
>> +++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
>> @@ -0,0 +1,112 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#include <linux/pci.h>
>> +
>> +#include "core.h"
>> +#include <linux/pds/pds_auxbus.h>
>> +
>> +static void pdsc_auxbus_dev_release(struct device *dev)
>> +{
>> +     struct pds_auxiliary_dev *padev =
>> +             container_of(dev, struct pds_auxiliary_dev, aux_dev.dev);
>> +
>> +     kfree(padev);
>> +}
>> +
>> +static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
>> +                                                       struct pdsc *pf,
>> +                                                       char *name)
>> +{
>> +     struct auxiliary_device *aux_dev;
>> +     struct pds_auxiliary_dev *padev;
>> +     int err;
>> +
>> +     padev = kzalloc(sizeof(*padev), GFP_KERNEL);
>> +     if (!padev)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     padev->vf_pdev = vf->pdev;
>> +     padev->pf_pdev = pf->pdev;
> 
> Why do you need to store pointer to PF device in your VF devices?
> pci_physfn() will return it from vf_pdev for you.

will fix

> 
>> +
>> +     aux_dev = &padev->aux_dev;
>> +     aux_dev->name = name;
>> +     aux_dev->id = vf->uid;
>> +     aux_dev->dev.parent = vf->dev;
>> +     aux_dev->dev.release = pdsc_auxbus_dev_release;
>> +
>> +     err = auxiliary_device_init(aux_dev);
>> +     if (err < 0) {
>> +             dev_warn(vf->dev, "auxiliary_device_init of %s failed: %pe\n",
>> +                      name, ERR_PTR(err));
>> +             goto err_out;
>> +     }
>> +
>> +     err = auxiliary_device_add(aux_dev);
>> +     if (err) {
>> +             dev_warn(vf->dev, "auxiliary_device_add of %s failed: %pe\n",
>> +                      name, ERR_PTR(err));
>> +             goto err_out_uninit;
>> +     }
>> +
>> +     return padev;
>> +
>> +err_out_uninit:
>> +     auxiliary_device_uninit(aux_dev);
>> +err_out:
>> +     kfree(padev);
>> +     return ERR_PTR(err);
>> +}
>> +
>> +int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf)
>> +{
>> +     struct pds_auxiliary_dev *padev;
>> +     int err = 0;
>> +
>> +     mutex_lock(&pf->config_lock);
>> +
>> +     padev = pf->vfs[vf->vf_id].padev;
>> +     if (padev) {
>> +             auxiliary_device_delete(&padev->aux_dev);
>> +             auxiliary_device_uninit(&padev->aux_dev);
>> +     }
>> +     pf->vfs[vf->vf_id].padev = NULL;
>> +
>> +     mutex_unlock(&pf->config_lock);
>> +     return err;
>> +}
>> +
>> +int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
>> +{
>> +     struct pds_auxiliary_dev *padev;
>> +     enum pds_core_vif_types vt;
>> +     int err = 0;
>> +
>> +     mutex_lock(&pf->config_lock);
>> +
>> +     for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
>> +             u16 vt_support;
>> +
>> +             /* Verify that the type is supported and enabled */
>> +             vt_support = !!le16_to_cpu(pf->dev_ident.vif_types[vt]);
>> +             if (!(vt_support &&
>> +                   pf->viftype_status[vt].supported &&
>> +                   pf->viftype_status[vt].enabled))
>> +                     continue;
>> +
>> +             padev = pdsc_auxbus_dev_register(vf, pf,
>> +                                              pf->viftype_status[vt].name);
>> +             if (IS_ERR(padev)) {
>> +                     err = PTR_ERR(padev);
>> +                     goto out_unlock;
>> +             }
>> +             pf->vfs[vf->vf_id].padev = padev;
>> +
>> +             /* We only support a single type per VF, so jump out here */
>> +             break;
> 
> You need to decide, or you implement loop correctly (without break and
> proper unfolding) or you don't implement loop yet at all.

Sure - we can simplify specifically for the single case we have for now 
and add the loop later when new features are added.

> 
> And can we please find another name for functions and parameters which
> don't include VF in it as it is not correct anymore.
> 
> In ideal world, it will be great to have same probe flow for PF and VF
> while everything is controlled through FW and auxbus. For PF, you won't
> advertise any aux devices, but the flow will continue to be the same.

Since we currently only have VFs and not more finely grained 
sub-functions, these seem to still make sense and help define the 
context of the operations.  I can find places where we can reduce the 
use of 'VF'.  Would you prefer PF and SF to PF and VF where the 
difference is important?


> 
> Thanks
> 
>> +     }
>> +
>> +out_unlock:
>> +     mutex_unlock(&pf->config_lock);
>> +     return err;
>> +}
>> diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
>> index 5be2b986c4d9..16b20bd705e4 100644
>> --- a/drivers/net/ethernet/amd/pds_core/core.h
>> +++ b/drivers/net/ethernet/amd/pds_core/core.h
>> @@ -30,8 +30,11 @@ struct pdsc_dev_bar {
>>        int res_index;
>>   };
>>
>> +struct pdsc;
>> +
>>   struct pdsc_vf {
>>        struct pds_auxiliary_dev *padev;
>> +     struct pdsc *vf;
>>        u16     index;
>>        __le16  vif_types[PDS_DEV_TYPE_MAX];
>>   };
>> @@ -300,6 +303,9 @@ int pdsc_start(struct pdsc *pdsc);
>>   void pdsc_stop(struct pdsc *pdsc);
>>   void pdsc_health_thread(struct work_struct *work);
>>
>> +int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
>> +int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
>> +
>>   void pdsc_process_adminq(struct pdsc_qcq *qcq);
>>   void pdsc_work_thread(struct work_struct *work);
>>   irqreturn_t pdsc_adminq_isr(int irq, void *data);
>> diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
>> index 5bda66d2a0df..16a2d8a048a3 100644
>> --- a/drivers/net/ethernet/amd/pds_core/main.c
>> +++ b/drivers/net/ethernet/amd/pds_core/main.c
>> @@ -180,6 +180,12 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
>>   static int pdsc_init_vf(struct pdsc *vf)
>>   {
>>        struct devlink *dl;
>> +     struct pdsc *pf;
>> +     int err;
>> +
>> +     pf = pdsc_get_pf_struct(vf->pdev);
>> +     if (IS_ERR_OR_NULL(pf))
>> +             return PTR_ERR(pf) ?: -1;
>>
>>        vf->vf_id = pci_iov_vf_id(vf->pdev);
>>
>> @@ -188,7 +194,15 @@ static int pdsc_init_vf(struct pdsc *vf)
>>        devl_register(dl);
>>        devl_unlock(dl);
>>
>> -     return 0;
>> +     pf->vfs[vf->vf_id].vf = vf;
>> +     err = pdsc_auxbus_dev_add_vf(vf, pf);
>> +     if (err) {
>> +             devl_lock(dl);
>> +             devl_unregister(dl);
>> +             devl_unlock(dl);
>> +     }
>> +
>> +     return err;
>>   }
>>
>>   static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
>> @@ -379,7 +393,19 @@ static void pdsc_remove(struct pci_dev *pdev)
>>        }
>>        devl_unlock(dl);
>>
>> -     if (!pdev->is_virtfn) {
>> +     if (pdev->is_virtfn) {
>> +             struct pdsc *pf;
>> +
>> +             pf = pdsc_get_pf_struct(pdsc->pdev);
>> +             if (!IS_ERR(pf)) {
>> +                     pdsc_auxbus_dev_del_vf(pdsc, pf);
>> +                     pf->vfs[pdsc->vf_id].vf = NULL;
>> +             }
>> +     } else {
>> +             /* Remove the VFs and their aux_bus connections before other
>> +              * cleanup so that the clients can use the AdminQ to cleanly
>> +              * shut themselves down.
>> +              */
>>                pdsc_sriov_configure(pdev, 0);
>>
>>                del_timer_sync(&pdsc->wdtimer);
>> @@ -419,6 +445,12 @@ static struct pci_driver pdsc_driver = {
>>        .sriov_configure = pdsc_sriov_configure,
>>   };
>>
>> +void *pdsc_get_pf_struct(struct pci_dev *vf_pdev)
>> +{
>> +     return pci_iov_get_pf_drvdata(vf_pdev, &pdsc_driver);
>> +}
>> +EXPORT_SYMBOL_GPL(pdsc_get_pf_struct);
>> +
>>   static int __init pdsc_init_module(void)
>>   {
>>        pdsc_debugfs_create();
>> diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
>> new file mode 100644
>> index 000000000000..aa0192af4a29
>> --- /dev/null
>> +++ b/include/linux/pds/pds_auxbus.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
>> +#ifndef _PDSC_AUXBUS_H_
>> +#define _PDSC_AUXBUS_H_
>> +
>> +#include <linux/auxiliary_bus.h>
>> +
>> +struct pds_auxiliary_dev {
>> +     struct auxiliary_device aux_dev;
>> +     struct pci_dev *vf_pdev;
>> +     struct pci_dev *pf_pdev;
>> +     u16 client_id;
>> +     void *priv;
>> +};
>> +#endif /* _PDSC_AUXBUS_H_ */
>> diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
>> index 350295091d9d..898f3c7b14b7 100644
>> --- a/include/linux/pds/pds_common.h
>> +++ b/include/linux/pds/pds_common.h
>> @@ -91,4 +91,5 @@ enum pds_core_logical_qtype {
>>        PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
>>   };
>>
>> +void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
>>   #endif /* _PDS_COMMON_H_ */
>> --
>> 2.17.1
>>
