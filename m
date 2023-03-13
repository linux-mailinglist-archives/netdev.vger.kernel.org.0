Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB56B7D26
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjCMQN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCMQNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:13:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939B52057D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:13:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3jhbWFQaE6UV70yuOOmtdvQmNV0y6Ee76xmBl+Jd9DODi0+6ohXolw2R1gCO4ZIRkIOhLYXqtCxJXKB/AQrPOFnYiqfUJilKnmZUOGT+zFGrEwfcjRCCs206MCYnYf3i3b1eHR7PnwuFlJxqGyEMDHqUopx2rZ4kLheU1t3MX9eyciIz4eERVK7tx2bNEJJTA6TRJT/gbsXtcDqcXfQZSQ2i7gDikuTywf6D0foyfxTKIfDnH6HXHJ2rR2Y53PLDkS9ODTBOrh/maYxBAQqXs82oZJvzrJXR46RcJ5AXcZya+EjazhJ/oSobXqzUW7VnKwG04g2yasJKvbl1zfEUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Wj/7K3LDRrOwczr8GxsaY7uVqs3gQiJ71gz8wY4wxI=;
 b=CnPoeCDGriDrGH480DZs0GAJ6xiLTM1kUAwxgidXM/7800chMfj8c2hSKdr7O2kDNIgr8jFaZ7wfFALZtQXi5ZJ4bCl9UbtLfT0MJk6KTH8W4hnvMkgvvlftMBHGYbUgh3BL3aovGeVcWuGjByYRd/Vu4a1YiDmRxPx+26jtgdd2k1yYmOJvlDsRLl14YgpsoS8aKfPQidN/lBZjviWw/3qEEpLS582f4u/r+BTG7tMp+8WfIDeOKfncwn4A3HAzlqHxse6eCJCbMpwByXhfAjZJFj+NKQW+AtjqeS/I/BogbQgTwieWWSgz4fBEyWtwIx0mhtgKYUtzkbtKcd3YwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Wj/7K3LDRrOwczr8GxsaY7uVqs3gQiJ71gz8wY4wxI=;
 b=b+QERDpnI+bP+L619dQYTWfTziT8/FUFZuGdPpCww+za6EMKRGBQZLlos4sAlGuY8bNEDkWI5mC/5P9VERdbA9YSBcP9FtglzzC+z94W9dbq2BqF6zNBppvVopyOMWhRalSiWOm4Yipjsia1BjSNdqBsqXxv8WqPRb+Hk23FxnE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 16:13:15 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%8]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:13:15 +0000
Message-ID: <37fd08f6-0608-c6a3-28f0-63d05eaf0a40@amd.com>
Date:   Mon, 13 Mar 2023 09:13:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v2 virtio 1/7] pds_vdpa: Add new vDPA driver for
 AMD/Pensando DSC
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-2-shannon.nelson@amd.com>
 <ZA3cYPoWQCjYoB3g@corigine.com> <ZA3jKuMlr/kBQNml@corigine.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZA3jKuMlr/kBQNml@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:217::30) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c12b544-3a74-44dc-2f44-08db23ddd98c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4cBq6QojRhQ23auD/6qEtREpwhuTLMCDWVtqXvGNu961yqtQxh63N6eF4qsAAAM9bbR7YVG+FUtHzmy/dkm3iUaW+fWqfLPcuuQhVdAoB/7OzqjsGcJPDDesMx1oRuApmI/bbjmzboV+/gnJZSh/DfFm03bLa8IKIzvnbFXLT0mTf4/GjrjIv1vdiB8s60zRzXlXTyEspjFbxPc6m3Gd2xaEcctp7LnhfU4oTns+VZ7EjbyUO7Ljqi+ddZViyhiOo4GPSos+YiAnsbkBLdT6Lwv9AXj8yyFR7Icvb0P+rjMMzSv+0jiGaMvorc7e/ohj2b4bygug6flpFOmR7pUq/z87V/NKhKaOe3Pw4vZvJIn8KTsjXeBzb0IREXwj3NkErUvCtcrLHr1/xI+1L6znhHzenyjDuODySl+0vm6bu0e7jJ3O3hK0L2r6EaruzbDZjJm1RJI9Mq0idjUXu2rZutsC+CP3Zti2idTMhc8ZXq0FELOhPhJ5fYuBfxJ60wymUdmOdPlrc829CGYoeFKg+uhovkfLYTNI/32crWYu/E+AL8dlwWFhBqO8kQlqlsujNWmSSXaO4svTKFZXe0uEB1fDdnGqds7/9cwk9VS2iZeO/djWGfxWSgoinIBBWBafAsgYl5244+7RSeHzf14wejZJO7DwmXqtFRiqVx7EJ3BzPTcAA3Hf9z9jrl9tWS6/SE63zrdJghNBFyFxp9m3XGi4YKZtPEC4+fCoa2QppM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199018)(31686004)(8936002)(6916009)(478600001)(41300700001)(4326008)(66556008)(66946007)(66476007)(8676002)(36756003)(86362001)(31696002)(38100700002)(6506007)(26005)(53546011)(6486002)(6666004)(186003)(5660300002)(44832011)(2906002)(316002)(6512007)(83380400001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkFEODBJSElpZ1B0V0JRSmZnUzVRaXpQaTZ4YWFQdURYTDltSHFieHpRL0Zj?=
 =?utf-8?B?R2lXaVhHQllSVzIyU2FXLzNSd2hIc3NTWDJDanM2aExER2FkaVY1WGZaUXNH?=
 =?utf-8?B?alZtK1lrUy9OM1drUm1JNHM5dHhJeTJNd3kwQkVHU21ndXpQQXV3M2J6Nllt?=
 =?utf-8?B?aEVIUnlkOTRFVXErVnQ1cHREVnl1SURuSUkzcFVETWNiRFF3bngzb25ERy9B?=
 =?utf-8?B?d2pRMVppSnd2RE5SYW5UWm5uS0FsYU1nZmFPeU1wMVZ3ZDNqUW1YWVZTS0Rx?=
 =?utf-8?B?MWNNZGZYSkFkZCt3eHZUV2xUNDUvQkQ1aVdPenJoT3IrWG5jYUpkdzErR2Fo?=
 =?utf-8?B?Mm9majV5MStkc0RYenN6M3hpQ1daQXhwbzFCVXh0ZlRGSHdWaVQ5YmRJZXNw?=
 =?utf-8?B?NHA3aHJjN1lPblJGN1FZV3V5d0ozN1dXdEJIUXlUNEY2ZzFQdkdIQnJ3Z2tO?=
 =?utf-8?B?OTA0RWs1L2EyTmIxbUxuY05KTmdTZ2o0cjU0eGd3QURLaHJPdjFPaDZOOEpX?=
 =?utf-8?B?cDJZMVFER1VqcjMxYU5YZC92U2dmQk9jSmM2djdPZ2p0cEtWcEZuUll3OExm?=
 =?utf-8?B?a0ZDbWhneitjUXJvcEF4YjRkYW02SSs3eE9CMmh1VlNpTVBvWVFCMmdIdENU?=
 =?utf-8?B?Lytpa3FIT2xtOUdFTTNrd0dTdmNCYkpiai9sV1pVbFhML2gvbHNWZERWWUZ3?=
 =?utf-8?B?VFIvaWRlZlNYcnVsNHVyNHZaVENkNTQ1TzBRNnc4RlVtelhmYVdTdjhWSVFo?=
 =?utf-8?B?dnJtd1NnMERSdDB3UHpOdmtZZllrYkR6Tm9KVE42Ynp6TkVMczFuVWZqWXhl?=
 =?utf-8?B?clhqaVVpREZGcit6U2FSelFRUGtiSzZaY1FPS2NETnVrRHBJN1dpVU5DV05X?=
 =?utf-8?B?MjAvVjY1NmRRcDRNWDdTOVRFQkF6VFhFV0I3NThrbmk5cnBxTzkwRFYrWFEx?=
 =?utf-8?B?QXZDankwR2trcjRpU3ZIaVlTM01Cem5ZamNSSWxJbkZBWFhVOVdDMjBwYnFM?=
 =?utf-8?B?Tlh5dTRHRm1GZXNTVDNhWFRzd3NtcWpHaDVNNnJVOUQxZWpqMDA1aDlSTDZP?=
 =?utf-8?B?MGpMVXI3aFlqcXdOUG9LRnlIVklJUjcraGlLcFlCV0VVSGRxblhhb0hLVGxl?=
 =?utf-8?B?UjNZT0FMMEg2QWFaRUNjZy82RkM5M1hmUjRjOXMvV2daTmdCOTdiVytQcDU4?=
 =?utf-8?B?YTNWYzNOaFRNdXhUUkJTckw2b21ST1l2aTdSbFZIVHI3STRiYWJzVnJyL3h6?=
 =?utf-8?B?SlY1Q0NkVlVvUDd2SkZXSGk3VkpycTFuSlduUDV5QXNUK09CdlM0TWVLYjJ1?=
 =?utf-8?B?aDZDOG0rdmZaMnJTNXJJUTZ3ZGtkVDh2N3ZsdFAyZVEwNVA1di85MjRxMWVH?=
 =?utf-8?B?UTFNS1RiOHJsTzFURXdQSWNJSzVUV3FIZ3dmK1VhOVRXVFJSU2xSbXZNNVBl?=
 =?utf-8?B?WkdJenpHK0lIclJEejE3TVdZZ1hPSkRQRCtkeExVZi9WSG94cUFZWitvWFpr?=
 =?utf-8?B?ZHg2ejFrRTlhdDNnWXZ5VEJwbmxxNXpJS0xiWWkzM20reFRiaHdoQkh1NjVE?=
 =?utf-8?B?SEl1UlB3OExsd1pDSUhFQjE4T3doK2c4cy96aVU5d0lubjdST1Y3blBwWTFN?=
 =?utf-8?B?dXhiN2pnblU5UThKc0xwZlpRdmF6T2gzZWY0WE4xS1F1cmhpRTYrMk8xano1?=
 =?utf-8?B?TFhTY2pJN0VmRkJPZ1JHY1dqZ0hoMVNkRGxwZVU4RnpxUlJpd1l1emxCYVE2?=
 =?utf-8?B?TXJuZFVNRnhOdmg2WTFZdjZYeGwwQ2RzdEczYzZUdDNxcnhwbVpwZmd4cHNB?=
 =?utf-8?B?OGdsT05NTjQzOHN5c1FGU2ZOUUhnTjhEZ0dRNWJRajYrQ25OWi9JZnlYLzVH?=
 =?utf-8?B?Q0NsT25ORFFqVk9hVGgxSW9sQjUzRm0zUmZGTEhVMncrTER4V3NobXFQRzQ5?=
 =?utf-8?B?MS9VTGNDMWJZZGJqZWRkeWNlSUJSYzJpYnJIRUxzazh1b0JVdVpDZE5OR2NJ?=
 =?utf-8?B?SXpncGY0R01zL052UExtdzNXazEzNEZVZlhQOXo5U0ZvWk02NnNZOXk5OWg2?=
 =?utf-8?B?RFBVbjdQQ3Yxb0g3eVdSa2VOajRvaHpTdWFjRFRUc2FPK1JPWXpQUkliQXJY?=
 =?utf-8?Q?yGKOGcvGEaewzRsdAeRCNZ4Q6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c12b544-3a74-44dc-2f44-08db23ddd98c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:13:14.9519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Brvc+LHNIFxMQgKFEoX1cDVefg/m5eTAr6d+UcK2AF3j1cZW+mQ3mofS/bxStiOeJmxlSGON7z6OeWVuwsS6lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/23 7:35 AM, Simon Horman wrote:
> On Sun, Mar 12, 2023 at 03:06:39PM +0100, Simon Horman wrote:
>> On Wed, Mar 08, 2023 at 05:30:40PM -0800, Shannon Nelson wrote:
>>> This is the initial auxiliary driver framework for a new vDPA
>>> device driver, an auxiliary_bus client of the pds_core driver.
>>> The pds_core driver supplies the PCI services for the VF device
>>> and for accessing the adminq in the PF device.
>>>
>>> This patch adds the very basics of registering for the auxiliary
>>> device, setting up debugfs entries, and registering with devlink.
>>>
>>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>>
>> ...
>>
>>> diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
>>> new file mode 100644
>>> index 000000000000..a9cd2f450ae1
>>> --- /dev/null
>>> +++ b/drivers/vdpa/pds/Makefile
>>> @@ -0,0 +1,8 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only
>>> +# Copyright(c) 2023 Advanced Micro Devices, Inc
>>> +
>>> +obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
>>> +
>>> +pds_vdpa-y := aux_drv.o
>>> +
>>> +pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
>>> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
>>> new file mode 100644
>>> index 000000000000..b3f36170253c
>>> --- /dev/null
>>> +++ b/drivers/vdpa/pds/aux_drv.c
>>> @@ -0,0 +1,99 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>>> +
>>> +#include <linux/auxiliary_bus.h>
>>> +
>>> +#include <linux/pds/pds_core.h>
>>
>> Perhaps I'm missing something obvious, but
>> pds_core.h doesn't exist (yet).
> 
> The obvious thing that I was missing is that it is added by
> 
> * [PATCH RFC v4 net-next 00/13] pds_core driver

Sorry about that - I can try to make that dependency more obvious in the 
next round.

sln
