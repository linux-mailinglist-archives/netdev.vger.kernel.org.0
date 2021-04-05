Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2830A3547A7
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 22:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhDEUks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 16:40:48 -0400
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:19192
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235289AbhDEUkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 16:40:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYOs6IGqflxW3uQigDcAjwP7B8vcadYzvv2JnqkGzZ+bJYnMIBmy7DGGhmV5M9LnxpBzk0Q2y/lbYUt9rwNQSW7yYWluDNwBP9UlF0Nwh7CYi/dD+opOcTOZ1H6e+PfAxHIKbgX8yGF0FT62OSZgMd/uQrXiG+w1wy5bzbdvHHHMoe04M3i5SEchRVEQnM4F6GU5tqDLp/HflcOVmAynYzE5ghJQxGz6WU240Kmy/bS5MFibiOnC+p520X1ivciR2ruUygUpoWpfTsuHXv15V9P7Ho68mof4SF8IkDKchSzPqTd0tyAURo3UZ9ItJXFqXzJ+LhAty8d+2ZuD9MzDkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwggBMfJRdb6PvoedbOJgy5q2y0CmtkKVqX55sP0WGE=;
 b=bV1aT6klXfToCGVFiab1lVJ+SoDMehS8s6QUY7p0EflZt/DxcZOIfTGGEe7yYCUiJ3X/vSDBUPmVYioJlCCN04MMEppOUPF5CWpyM2E2s6CZyq3VgxMEcFglP92C+GQHo6JYXPSMBeeatS9vvsC01kMfBPqEqswhr4kDlwPFecGg279rYujGOQMAPabSPwnw7eJyC3u62qZxGqP+qzpCPaad01f2uaK5ZH7Cv1cyL7ugQgonZ8GkO8RXvmwoDSG7RFgTpgQb2UVyug7GJ095fApLRLH0lvrHAS+e8ZO0XbOjtuRfAt3t59Rsh5niLY1LDkYLYc2GHMvZ+i0m5Kin5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwggBMfJRdb6PvoedbOJgy5q2y0CmtkKVqX55sP0WGE=;
 b=2a3A57uM5lP2T8mmDBo3782LTdLEaPgTYcMuYdAsbpK4OHxmO3ntJLsLEsle7PoHhPF2Ps2dwf7SktTAr4iluTqMpSfPhBzwnZ9j+faoHJki+7TSCOL6ka6E3om2CgEZDhL765LtVvj5GxFEpHlGT5F7oD18nNTDlP1L/520DSc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=vmware.com;
Received: from BY5PR05MB7155.namprd05.prod.outlook.com (2603:10b6:a03:1bf::24)
 by SJ0PR05MB7341.namprd05.prod.outlook.com (2603:10b6:a03:278::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8; Mon, 5 Apr
 2021 20:40:32 +0000
Received: from BY5PR05MB7155.namprd05.prod.outlook.com
 ([fe80::8c33:8eab:566:f63a]) by BY5PR05MB7155.namprd05.prod.outlook.com
 ([fe80::8c33:8eab:566:f63a%5]) with mapi id 15.20.4020.016; Mon, 5 Apr 2021
 20:40:32 +0000
Subject: Re: [PATCH rdma-next 02/10] RDMA/core: Enable Relaxed Ordering in
 __ib_alloc_pd()
To:     Tom Talpey <tom@talpey.com>, Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405052404.213889-3-leon@kernel.org>
 <befc60f3-d28a-5420-b381-0f408bd7cca9@talpey.com>
From:   Adit Ranadive <aditr@vmware.com>
Message-ID: <7246a8dc-d484-e022-0270-23e29eaea390@vmware.com>
Date:   Mon, 5 Apr 2021 13:40:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <befc60f3-d28a-5420-b381-0f408bd7cca9@talpey.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [71.204.167.113]
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To BY5PR05MB7155.namprd05.prod.outlook.com
 (2603:10b6:a03:1bf::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from aditr-a02.vmware.com (71.204.167.113) by BY3PR04CA0017.namprd04.prod.outlook.com (2603:10b6:a03:217::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Mon, 5 Apr 2021 20:40:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e5738e-3a05-479b-44d9-08d8f8730e0b
X-MS-TrafficTypeDiagnostic: SJ0PR05MB7341:
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR05MB73411B3BEEA01D7DA54264BEC5779@SJ0PR05MB7341.namprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:580;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vynTHLHZfa7GV83Z2iZ1hUCJuEz/L/0v7ppej4i30yCDay1NYNSfwDfTIFwp04YM16OnsRSe4TGswGYifQHvPxQaDiiyuALW/IjvMA7Ho25vYcrp3LX2zJtG8mHur8L3M7nUBK7NZEB99nYeMYkT7y+nbu3fOzRO2YG8LUc+Q48wrqUnlhiGO03ieYfTngcVDUAsYMTihHhz/Xr9AHp9EV6SJ23lFjWVxf1++fKXOIXsqUxdFqC8CJWbOvKgAtN229m7LP5nd87ThpqxU4Uepqfnf8lEmvXpOwG9YO1ulIhYOM491o+AOar6oDe5n2LEiKZ8ZaI0F08qRAjMW2llHNRTmT5Q7LmdJnnJWIuTJ5s+dkwwl4KLeH8BrJfG7cQpvie5C1NTnnERkWktbdX5r5V+waDqTPfxd4KOaI0XQLW1Q+WYo3lYHcoJ/dmk0+PDZJiZo8AFrvUYowmvtMq/IWGBtKKjQ/vAyXsUY2iNleW5afev3MpCHMZ2vJ/wJupxgvp3XCpnBMMX2JW0WQPjxRvVFfOj6StbCdyTfOcIjK/ge8zFcCwvtw8Dphz0AaS5GkDXqeCcPNElqCrc9exyzmCsFE2kz0+AoTrilFXid1oN4VPF4fORzMCpYE/4byLlBHQ3JIKeageG0ImvClMpPXSU0SjkTBPibiDlBzCwZSyNjW23VhUdrMDwqXJazgTbMhUM23JgXDjUBDuXqgUF1LPPnSc61IbSGxQSChnc9E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR05MB7155.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(478600001)(6486002)(83380400001)(7696005)(36756003)(2616005)(31686004)(8936002)(186003)(66556008)(66476007)(66946007)(4326008)(16526019)(8676002)(86362001)(53546011)(110136005)(31696002)(54906003)(956004)(7406005)(7366002)(7416002)(5660300002)(26005)(316002)(2906002)(38100700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RWxmdmo5RFZ0dEtVOFJWb3Y5TDQ3cUJmMTRveDlzNVhvTGVzQ0hHNldqTTAx?=
 =?utf-8?B?NTBwRVdvZHAxZUpkRUkwUXFhczVIWFUxaDV1YWtJSnViaG1FMWZBdUZQb2My?=
 =?utf-8?B?bDRYdThJNXp1anJOTCs5Z2VuL3p3eEtqV0JGZjZKYmthdzNPWFNLQkNuU0ZJ?=
 =?utf-8?B?TVpzYTJVdDRuVnlVcW1iRXVaOVh4bmtZWWdpcVVWSUNZdkdBM1dvaFRQUUtx?=
 =?utf-8?B?SmtSbFpWTXFQekpQWHUrY1FjUk5WSmpSU1l0Mm95aVYyZWFXK0tqZmtWU0Q4?=
 =?utf-8?B?QXJxZHRrVmNuV3FWdGNjWmQvenFSMytOczJoT1B1Qmg5UEwvSjREMWhXczk5?=
 =?utf-8?B?YlJlVWRXYnRRNHh5aXBVKzc1WUZCQXF5TWpqVHNpOHRCMVEzWmc0VmJvWjNF?=
 =?utf-8?B?Q0l6bXNaaktjWkw1RHhKS2RCVXJSK2lFWnJMNlhlUmtlN2lTcHhHMWIvTnRE?=
 =?utf-8?B?alZ1aEVHeC9kVXY1eXltRUFpVTl4bHdHazFlZ0tnYTI0cnJrOTkvL3UvbUd6?=
 =?utf-8?B?bUs2VHdRaEJ4ckRHL253MTNGUC84YmxWV0U2eklnMkdhVDJ0SWtkdmVjQ2s5?=
 =?utf-8?B?ck1NL1hWT1o3SHMyS2U1OUhZdHV1cGtPZnlxMU9uaUFDNFdPS2xrMmZUdG1T?=
 =?utf-8?B?Q0lrbUxOU1RCakJiQWZNRWtPcG4rMTd1cXVaWmJrRXp6bGJrV2JwNTVGbytV?=
 =?utf-8?B?RE9lSG1XUXcyYWRFQjhNNk1idHVuWTluTGJiU0ZmdlBMaFF2V1VMZGNoQWtr?=
 =?utf-8?B?R0M4ZkVnZ2s4MjQ4OHl6ckJIZ3Y2Wm54cEdiR3dTdThDKys4SG81Tjl6ZGV2?=
 =?utf-8?B?YTBMSXdKVnhPS2h1UWZ5Y0dxOW9xcG0rYk5jNkZsTHBsWUR2Mlc0OTBEQ3Ux?=
 =?utf-8?B?S3VrRUJpMjIrbkxvWnZ0MmNLMWV1K3VSSmFTaW0ydnlBb1NPTk43STI1YmlY?=
 =?utf-8?B?TnFEQ3lrUCtZOTY2UTh2b29IVU9temNlYmdMcCsrbDhlZ2cybUFuM3BpM09t?=
 =?utf-8?B?Y3RxVTNrMnlLQUNGTWM5aXNGMklUU2hRbEQyR3Qxd21CUHc4US9XVGxwU2pH?=
 =?utf-8?B?VE4xQmRsdUt3SUw5SVVwbUpKVGd3RnJZb0lkZ0NZOG9EL0hwTlhRWWxQSGsr?=
 =?utf-8?B?NTZXWVM4WXgyL0prRmVQYStvOHRwZ2srWDFELzZ5UGpCOHBaQnU4ZGszTGN1?=
 =?utf-8?B?a25EK0ZWVzYycEtNUFBpTnFHMGxqLzZraGNWRk13N0xoOUdTKzN4OVhIVW0v?=
 =?utf-8?B?QnZNMlZlYTRFR3pVRVZUM3hmdkExMS90dEZZd3grR0RJODE3UVhuRC9TbFl3?=
 =?utf-8?B?NUxHalk3SjVzM2o0VVZVMUdzSzlMNVFWYlpGYkk3dTV2Y0VBTFV5N2NxODNH?=
 =?utf-8?B?ZTFPRXNaQkxLWEJvSWRwZGFYcHB0TWlvS0RUaXBvQmg4ZG1yWit0alRMY09r?=
 =?utf-8?B?N3I4dnBycTZqZG5EUXhNazVnMEZKYmNSVUUwV0RYTlh1OTVldEJJTUQycDhi?=
 =?utf-8?B?VVFpNnU4VHAzcGc1TnBJL3R5bXVGOHJLdE5LOGNnRktLYXVRUmZXNUMrUTYr?=
 =?utf-8?B?ZlFKWVNGNER4QnE4R3VhdCtjNnp5UFZwNkQ0OStMcFp6NmQ5dEJBeEYwdDJt?=
 =?utf-8?B?VTZOTkFrdHNmTG5Zckd5VEV3MlNqU3lCcDdSa3M4dFdoSnZvVFFtMEg4UUpV?=
 =?utf-8?B?M2J6dklsUER3aHNQc2pSK1JON25WZjZyZUo5Qmt4YmxnL25neGFna0RMN1pJ?=
 =?utf-8?Q?f3yNfrpTtmHT80tb3Gd11K/3NJGciDGrN4bMcsV?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e5738e-3a05-479b-44d9-08d8f8730e0b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR05MB7155.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 20:40:32.2157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAt9q7HxE8cbKfbH6TY/pIyZrAUq64tbkPnedCjIjPNuUXbYaeVmzb28O7EDFZmACBPBO07x39zb8Vk18SU4ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR05MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/21 11:01 AM, Tom Talpey wrote:
> On 4/5/2021 1:23 AM, Leon Romanovsky wrote:
>> From: Avihai Horon <avihaih@nvidia.com>
>>
>> Enable Relaxed Ordering in __ib_alloc_pd() allocation of the
>> local_dma_lkey.
>>
>> This will take effect only for devices that don't pre-allocate the lkey
>> but allocate it per PD allocation.
>>
>> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
>> Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>> ---
>>   drivers/infiniband/core/verbs.c              | 3 ++-
>>   drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c | 1 +
>>   2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>> index a1782f8a6ca0..9b719f7d6fd5 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -287,7 +287,8 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
>>       if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
>>           pd->local_dma_lkey = device->local_dma_lkey;
>>       else
>> -        mr_access_flags |= IB_ACCESS_LOCAL_WRITE;
>> +        mr_access_flags |=
>> +            IB_ACCESS_LOCAL_WRITE | IB_ACCESS_RELAXED_ORDERING;
>
> So, do local_dma_lkey's get relaxed ordering unconditionally?
>
>>       if (flags & IB_PD_UNSAFE_GLOBAL_RKEY) {
>>           pr_warn("%s: enabling unsafe global rkey\n", caller);
>> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
>> index b3fa783698a0..d74827694f92 100644
>> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
>> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
>> @@ -66,6 +66,7 @@ struct ib_mr *pvrdma_get_dma_mr(struct ib_pd *pd, int acc)
>>       int ret;
>>         /* Support only LOCAL_WRITE flag for DMA MRs */
>> +    acc &= ~IB_ACCESS_RELAXED_ORDERING;
>>       if (acc & ~IB_ACCESS_LOCAL_WRITE) {
>>           dev_warn(&dev->pdev->dev,
>>                "unsupported dma mr access flags %#x\n", acc);
>
> Why does the pvrdma driver require relaxed ordering to be off?

PVRDMA doesn't support any other flags other than LOCAL_WRITE for
DMA MRs so the MR creation will fail if any new unconditionally added
flag isn't cleared.
