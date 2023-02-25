Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A5C6A2C29
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 23:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjBYW5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 17:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBYW5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 17:57:46 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC8314E87
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 14:57:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UozptsZd3OP1jCZjoB4NXRjIoUEveYGNtlk0acpxh75Xo1u8G7P8kIFOhQx/KuZmb5gLsdIqGHSghIplkvsqiUC3iJNhtLwllLAZesU7Ivgc+L8tYB0AERJ8a6k5/TtcNi8rUVVSrsF0KLeA3EJlCTklZsU4HC9AULYyXtShQfUerqId6NsywnCQe3GVzD1Sab9X1r2lqMFeNyPL5xhmrk2ffpq0hjN7WJcJHH02Ht/KP9x6pLE+VYrM/Jzni7NCx+Ewf/qC2Mt9GYlMgtO1qrCPMHdK85ZuMDkRosayaSjwC5w6RKMJfSEIToHTqZNBIZBghnadjV1wFLJLm/3qyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSPAIX39jisWWyOpr9tyljGUJUzaSmlJD1BfKBAxnio=;
 b=Htjnf+mkg6QGASk6de+0WbUeHok5OGsgYWI95scWALwF+7FF2LV8cilIyRhY98l9Ok8tITldu2kcsf7FiZMw/jyfrBEQ1r4jOM5pVzVBbI1+2/JZH24+q7jX/CQe92R9T63ow/uiKs1svvh0Cld/z5JOx3vTkPzTquO/Kpc9dAUYqYQInYjokypWmzSEK2yvn/MNY7HnlGcoOhhuMvSL6AJY8Dp6xbamTMUbUlNwpGB6oVkXhoJISkDnYEpTmi5ji3hHnMIolQMvqam7MDFfpXWWoXEeKBIQx/Os9akQdPP7GMURStFO/vh2j1RjFMEy/SaPWlaWx9TOUUVlA/RYlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MSPAIX39jisWWyOpr9tyljGUJUzaSmlJD1BfKBAxnio=;
 b=zqnr4cUHqae5I706BpCV9pg5bpcymSql42WXgKY4c9JAee6X8DKQwd5XUgQdN3GpKXGXktq1NWW2XLJkX2vhkGg42CoMcFt4L+IOmIlPlbHNpiGrSD6zILgOwEzj0zUzl8uxPDKZhCBvs6YoIeW/DkAwDVlWHSVgeO2+zSiY/KQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM6PR12MB4073.namprd12.prod.outlook.com (2603:10b6:5:217::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.25; Sat, 25 Feb 2023 22:57:42 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6111.018; Sat, 25 Feb 2023
 22:57:42 +0000
Message-ID: <d25e13d9-f391-ccac-fb98-ee7c0978e97b@amd.com>
Date:   Sat, 25 Feb 2023 14:57:39 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v3 net-next 00/14] pds_core driver
Content-Language: en-US
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>
Cc:     drivers@pensando.io, brett.creeley@amd.com
References: <20230217225558.19837-1-shannon.nelson@amd.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230217225558.19837-1-shannon.nelson@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::33) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM6PR12MB4073:EE_
X-MS-Office365-Filtering-Correlation-Id: 73eddcc3-d791-4c65-70d7-08db1783b3aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+TdhX3/binZNzDZsQPcq79NavD7GISkoUKPmOqbIYq5CoHKu5ZkRKpEB9PeJgR0LTEwYLQTdZonprJ3GKx4p5sp1cSnstN/rwqL9BXrcLWgO7dxpRuwK4951DU2EhIJBbAgknrO2RN6lF9UFcIXdEtJGe02Z+/pPnZOpgr4ZqxJpNd9G0hXGOI7n0qvZmIe+Fi3ob5pKjcwvOCUmWYk71+lDtlIz4GU+4BSG6K/AbyWV8T6PnkoQyX56EdVVEQCEMrKByP2sdRWbD1PD1G92ojY7cbgyn6ZG6409TbjqHlYHU/AwAjZkRLLp9xWfvn26ZDuXJH+RN/nVVjJOPug58QZGAq6cPAJSMK2yWD+BTY4ru2tL2G0g/cEuIvbgqL/j7VyCbz/0Rabzekvg0Z3SQfIo2k1Ur4yzrRKiPZSanh9Wexf/avu1buVY05O8Q3yOo7naaN3dveeCS5P5cOGgXTbySHWU22YZpk3TNZ8aX9peVoszF/a12ejEQjkhIezM3aVuQ7O/FxVSmLl3kBo2X7/zBEVVcR8oWfItR/fRn7aLK+7A+xx+gKMUdA1BhizB56FqeHIsGcrOFsFJNkvCiMHwIGfx86i2aLGpxgTES/lpoY7yt3hU6bzDpc5+PuXmiDOo9JzCZz84TK+VcV8X7y94P4wJKxSPWJu/sful5TUCCc6fXQGbINkccjtdZ7/xpnnIg4xVKlSW7RvMBk0bzIXQzIU2k+i3fcTkhAMQvI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199018)(478600001)(316002)(6512007)(110136005)(83380400001)(2616005)(38100700002)(31696002)(86362001)(36756003)(6486002)(6506007)(53546011)(6666004)(26005)(186003)(2906002)(41300700001)(44832011)(31686004)(8936002)(5660300002)(66476007)(66556008)(8676002)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUZTMlhCZHlmcm04eGt0VHlpdzdlVDlNRXQyVlMyMUQ3WFY5REZqTnQyMXpq?=
 =?utf-8?B?UnpNMXhLYUViSEJEdGJhUUdVemRKWWQ5WHV2cmZ2Nk15SE5VMXFKUk1CNWpR?=
 =?utf-8?B?ei9WMVMvNzlQVCs5SXdSOGFDL0RHWXJYeHR5dUZxeEFia09pdmMvZHU2aDB4?=
 =?utf-8?B?UlhyRHRWMVY1V0FJYUh1RmdYSEtwTDUvNFdqZURHYjNjVHlYMEtGVC9SQ2hO?=
 =?utf-8?B?dVpEMmQ1OFJDMEU1b0ppUXBBV0swNlJpdURRVGlwMmhadU03akVOWnBWL3Q0?=
 =?utf-8?B?NVNRaVBPQ1ErNTVUVVVPeW11d3VxWUdKQnJ4ZDVkR21EU1BpdE00M2NrdmpS?=
 =?utf-8?B?aEphQjdZSThZdUJ2RmxUdjVCdVZkalBKWHFlQURUbFZJckFaVkdKcFFQRS95?=
 =?utf-8?B?MFg2c2E5VmZBdmR1TEFSOTloT0VvQ1gwSG9GQi9uRHR0R3NReGJydlRPSVBi?=
 =?utf-8?B?R3VIMjdzcHplVUFYeVQ2Um5yeS83RnlEMDhXb0Y4VVhnQlVZU0JYWEVmdmpz?=
 =?utf-8?B?Vm5hWllrOHlOam9YRmF2NnB6YjZDQ3krajhQbjFzeTdzUnZrMG9NZXBnZ0hm?=
 =?utf-8?B?Y2FXbGhob3ZrR2IyUnFYMkxnY3NtNzkybnl2akNYQW8xVlRteUhRQTB6S0No?=
 =?utf-8?B?dStXOEc5UVBaZFBzaktGR25hS2N3d2FxZUdKOS90eTQrOHlCbHBOdlBROWhr?=
 =?utf-8?B?WVZEZjVtMmlwZDVTTzFUSUtON1pSVGtZSHNPTEpTTVFoSkNidUEwSnVyWWNv?=
 =?utf-8?B?Si8xcVNjekhjakkwUU1ubHc3cUxsK1h2RW9DaUN3cW8ybEQ5MjRNZ2xOak5n?=
 =?utf-8?B?a1dPYkp2d0RqN3RSK1huSGdWR0F4TjlBQ2tUeUlzMkZSZC9FOUwwdGs4azVo?=
 =?utf-8?B?VGZFWXVZbC95UzF0cHRBRC9hZG0yNlpuOUgrZnhZMnpzWlNyakhMSkEzWWJL?=
 =?utf-8?B?ak83SE83Z2VPVE9rZVkraXMvYmtJVXRXWUcyY1VQd2NSeHdwNWJ1WVM1aks3?=
 =?utf-8?B?LzNucDY0b2I1SStsM1FPTVlWT0RrcWI1V1d6UHdFRURPdFlTa2RQT0VUSFVV?=
 =?utf-8?B?TVQ2Wko3M1dvTXJCU1R3RlhxMEZsdG5iSjdGTmQ2RDZhVmdQTEJwTzVVTFcw?=
 =?utf-8?B?SVJ4eTdEN0JuZVFvcFJJMjhUd3NmSFNPQnUxbWd2TlEzbVVDTUpxRGVudFYz?=
 =?utf-8?B?S3N6ejRrQmpOaG9nQjNIdnUzaXVvMnNjdkhDTHRTWDJTK25abktOOWtPaEh0?=
 =?utf-8?B?cVlOSkE0Zi9Ec00vTlY1a2EweUp3NytEUFJLWi9yakJDN2EzWkEzVVZHMWx1?=
 =?utf-8?B?YnFFY1k2NWxYakhrMHFpeDJFcUpUUVZKNlBHbTRiWGpRY2x1RklWMklSVm9Y?=
 =?utf-8?B?MkJsS3daUmJtTHUzd1JQYXBZTnhpdmd5WlRYbTd5dE1mSXlRZWRPc2JjM3M5?=
 =?utf-8?B?dFBvemZxV29hYWYwSGFkUU82RjkvSUVzc2VhUkVvbXROVUZUdm9LUlNxSllo?=
 =?utf-8?B?NWhLSmRPb2pBR1BBZlNEZTJ0SXBVbm1QVGVFRmo3dHBtSDZRRjhiQ3A3OXV2?=
 =?utf-8?B?aFYvVHpyWDhiT1paYmsrWlJnQjhCTXdiY3l2VVMwR1BwUUVTeGU2L2kzL1BO?=
 =?utf-8?B?ekRqUXBydnYvTGVHb21EZUdCWXc1STMya3E4U1NoWk9ORmFodG5RWU1RbUdq?=
 =?utf-8?B?NjhUYlJTZVVCc00wL1cwd1RJZzEzTFFYWUtVUzErcUdjWjNiY2x4UFBsYjZD?=
 =?utf-8?B?WEJrUWZqUFlXQmFQL0hhUE85MFk4eXVMZW9GbTAwRWNIYmJ1aXJRb2oxdWc0?=
 =?utf-8?B?dmJPY083Myt6YSs2WjNvS2xSckJDdXVVcmFFSE44c0R4dm5VM1l3TEdDUFZP?=
 =?utf-8?B?QjZxaGRTNVdNbXd5NFJ5dW93aTJ1UU5mT1ZIY3kzbjA2R1JCcVJkU204WCtW?=
 =?utf-8?B?blhTNmV5REFIemlKajJaWkNQU2liMFZxZWNLZUNISVpWZU1tZ3lBYWorYUo2?=
 =?utf-8?B?T09jTElpdjBuSCtnRWtCV1hjY0pMbkc0VmJKb2M4UjZVaEEvZWV6a29SMWIw?=
 =?utf-8?B?ZDJ3UHFJdHhGT0lwekYzbVJJUEQ2bFJlOFdmRE1BaUlDWUZyL3VwWkY5Q3Ez?=
 =?utf-8?Q?XmuVq8pPPtkoR6axwX3kMLotv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73eddcc3-d791-4c65-70d7-08db1783b3aa
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 22:57:42.7388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgvbGo0JCeRzKjyAu0IDLre8fShs+9HUy+yY65pb4MMsHIgAOl3hiLzv1CGJSlIKd/iKT0QEwz9d3pAhb4w5lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4073
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/17/23 2:55 PM, Shannon Nelson wrote:
> Summary:
> --------
> This patchset implements new driver for use with the AMD/Pensando
> Distributed Services Card (DSC), intended to provide core configuration
> services through the auxiliary_bus for VFio and vDPA feature specific
> drivers.


Thank you all for your responses and commentary on this initial review 
of our PDS drivers, we appreciate the constructive input.

Obviously, the organization of our driver parts, PCI vs auxiliary and PF 
vs VF, doesn’t match what most folks were expecting to see.  The primary 
issue seems to be that the modules responsible for the VF’s functions 
(e.g. the VFio or vDPA modules) are set up to be both PCI and auxiliary 
drivers, which doesn’t match other designs, and presents potential 
coordination/locking concerns.

The expectation seems to be that the one Core module should handle both 
the VF and PF PCI driver work and from there set up the needed auxiliary 
devices, and things like vDPA modules should just be auxiliary drivers 
on one end and supply their respective features on the other end. 
Meanwhile, because the nature of VFio is to be a PCI driver, pds_vfio 
needs to have its aux stuff removed and needs to access the pds_core 
adminq directly by getting a pointer to the PF’s data, as done in other 
similar drivers.

We think this reorganization of parts will resolve the complexity, 
bind/unbind, and most other points of discussion.

I expect to get a first pass at this re-org done over the next few days 
and have an RFC for viewing sometime in the next week.

Cheers,
sln

