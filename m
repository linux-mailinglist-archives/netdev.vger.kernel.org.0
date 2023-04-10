Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF76DCB78
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDJTSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjDJTSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:18:21 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2065.outbound.protection.outlook.com [40.107.95.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979BF171C
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 12:18:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzBV4baVmzCI/4+brwPQge7phgMA2O6Oew1gQjm9YIQY/N/P+ZQklLOta7pauQdIAK0nAgk97wae8tCJeZz8gBQSQGlDvWmMD/jBNWblNmaVUMfmJh/2nESrXnzQA+W5+DTcFUmRIRsXsn+jnOxu9/qqRmLR9ivwjcnoEqb+7EojkoxzqnfXr+n9Q69WUBjkQWIYLEwiT+YCSHouMnEUXo4xP/Wjoxcr3hkLHYY4hgh6ehfftjpHMzMn5OPacmVDMUqAEpD8fEPZckneR+n7XjlEs5HmF7hilXILc+o5nOY+OC/eIg/kNvXgdBOvjEBkzGe11Nb1Qa/7r1fIUcknhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/dwIdsN5Iy01mupH6P76HVKLen+mOiI+Cq05LWA+Tg=;
 b=MK1VFHNe5qLj0QzoTKSukGa9+I3jhNwZiJIehPn+zZmGUYuczxCsR9P0BWIzdUqr444crU+2541peAUogu1cFn5GBJau4hWE3HUgb7kIiAbIgqAGns+8ENFN/PnKXvqH0VOvHMOewahStfGKOy03TJhCiVeAK2KRc4MFH2AmWX7zby5vboC8c5TDuYZtj49PvCF9CUuHwiKAynaaopDYXoXJwWPeKDzaZ1V0Nmuh1d9IoL5dRD22FrYnzBpvXW35blXjGEdxi/0f6+QbEi6yUwnLuQAtV7mv90ri5tEQ9pxXnUG1cm6fYzHAxPdM+fQervGczp4SXE+Pzcr6+qXMZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/dwIdsN5Iy01mupH6P76HVKLen+mOiI+Cq05LWA+Tg=;
 b=RYWkJshXboXu3Vi7Wa5zu//KXpzXjJxeCAKDKaExXXxi8STQv+kLQj81wLu7+BPpsLKU09F9s4Rdsu6uv2MDhhO6JQKEOQZZkp6GW6CrFy0jlTgxfEJ5NaSHE+Odl46UtXH5G/wtfek7jchgxNH3dQXS/yX6EtjVccycrLlDehw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA1PR12MB6258.namprd12.prod.outlook.com (2603:10b6:208:3e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 19:18:17 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 19:18:17 +0000
Message-ID: <c41dc420-e434-9944-584e-7ac9f915cd4a@amd.com>
Date:   Mon, 10 Apr 2023 12:18:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 04/14] pds_core: add devlink health facilities
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-5-shannon.nelson@amd.com>
 <20230409115414.GC182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409115414.GC182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::30) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA1PR12MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: a6185b86-fa04-4b11-d865-08db39f856e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: naov/C3X6+agxrCWo98t76ruobCDxO+Sc77VNRyLcK8BN1oO5TdVi3l84eI1mh1Ce31if5FfQNgjhaoDkp0pyTH2eXVYHC15PtpvEqNHiyNTRgWyDQWgQTWiX9Pv7T6pFHwPjk1pPHHXf9um9SMSlUwFuAVPuA8v2O988ePVRlfweZ6qZdx5s5LfH+qTt4fp1ipTJWRChfXgqK0OHzYkYg1aYnvSOO2AqvUg/m4kTUCsX/8Wr8Au2Wbyvi6Y/EbZDKENBIKJBZqrKXFfYvUu1iz4YPyPiZe/HAkIdRqIRX6n2IJZH2nRHalB8Ys13w5DN+zok09fIhTX8ix+QsdNipcL/mTkB3c9RL7j9HPAi4zm1LwouVd/HpeWh8X+MhRO70HebmYNEG3S6yNpgcO9+SrQgXVCJjOp8dzBD+8k2+BP/hS4B3H5sW7cP7IpIkSuAk9+4HbOYmTAe2b1nbSaPL+lvhgMfyWZctZQapbCTDZJm/rL7SuMUvZpz5oTq1g7j5km9+eozoYHGnqcHUbDS2vxST0D+duPZ5Shbmup9enJd/IzJbVgUjAQfcJn5NIkhHOy8OihNI+ZQKS397gXjELkEjipKwjYGRKeM3jcPqQPFa1V5iI/aLEwV1ZVeeMv+oqCTAWDq9Ux8XurZL1hfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199021)(478600001)(6666004)(53546011)(316002)(26005)(6506007)(6512007)(186003)(6486002)(2906002)(44832011)(66946007)(66556008)(8936002)(4326008)(41300700001)(6916009)(8676002)(5660300002)(66476007)(38100700002)(86362001)(31696002)(36756003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlRzbUMxaUcrcUh3MDJoeWx0R1k2b2ZpL3NvQkJ2RjNXTnk3SUpud1BFWENz?=
 =?utf-8?B?Y2tuc3RFZ0haQTJmT1Vza2liUE9udURIMFlhWGRFQUc3Z3VxVFdBMTNmSEd6?=
 =?utf-8?B?ejQ2akczYnBXNU1ORTlhc2pRcTlEUGsvTXZsOUlYV1ZweWxYZllxMHVFTHBt?=
 =?utf-8?B?RGI3Z0hWVjc2SXVHSDYzN0s1S0xsVUxLWHM5ZlcxcjhjQVNOUjcxdGMxY3Jz?=
 =?utf-8?B?aGRuNkZ6elYxZlFHOG1DbE5YRDRKaVpVU0JGL2Jxai9nN1dDRytydnFibmdZ?=
 =?utf-8?B?Uml4K3dsOUdiWVMvMmJlcWtkNWQvS04xQ0h3MGFFcmxaU3JIdGlIOTFvNm9J?=
 =?utf-8?B?dUlKWDVGb0czMCtvdGl6WGlHR05MRElTT3F2OHpDdmFmS0dMaUVNZXNyUWVx?=
 =?utf-8?B?U2FMck1iMms1K25lWnFtT0ZMYUhzVW1VWGNzNFNrNDZEd29MMmRZUFFEa3hv?=
 =?utf-8?B?QkJ2NC9iM3MzWjdvdkQ1NGhraTdodVBkOUI1dlpkalJkMWRLODFOczNKNDc4?=
 =?utf-8?B?VWRoYmRtdVNScnpFaHIvWjdXQzNJS2ZWSEJ6WFlPWUtUaTcyc1FCNld2MEQz?=
 =?utf-8?B?RzloY1dYY3JPbTRQaUt5bnBNa2lBQTlHcHJpbkNXZndVaDg1ZGZDOUs2cnd5?=
 =?utf-8?B?NTNJY3FVcWdjQ2RrcHNzbHR4NytxdnB3V2hET2xydC8wNUdKS3IvNTB0MUt1?=
 =?utf-8?B?b2VueXh1bmwrOUVmcUE4QURYN3o0N2tmVExKdVFLcDljbzdmMmR2L3MzeFA5?=
 =?utf-8?B?dkZzSXpBL3NBTENUYmh3YlBXVXNNOC9ocVFNc0w0S1QyeG1oY201Qm9VRlVj?=
 =?utf-8?B?Zys0Wjk1ak1heWh0N3VQZC9WQTN4cWpOV1dSUlFCR01pNFR4MEo1RGg1b1hj?=
 =?utf-8?B?QkdrbDRKa2lrbnFMbndxaS9KRzhrNFFIK3FIMkhpSEIrOXNCM3BuLzZ0Uk9r?=
 =?utf-8?B?TWVGRHRXaHZXR1ZXdS9TbldYUHFDKzFZdUVwUnlrOGxrQ2JFb1BIRkhiWkFq?=
 =?utf-8?B?N1E2OWRmR1I3bVNIQU5pQmVkbjlWOUt6b05hVWJ1aE5iMUowc1ZpcHRTNEg4?=
 =?utf-8?B?K095MmdjL1JpWHJZSFRSZExGZ0tIZ084TFlNbFFSU29seTVSMXEzOXN0Sm1T?=
 =?utf-8?B?U0FRQVRSUmc1bFdNbzFpOFd2OTNhVUxiRFVkanpMTkxZM05yUWRIWnljRjF3?=
 =?utf-8?B?U1pmOXBncmV1amcvb2lYMUlaazJGcm9NUm1nSEhIcWFZUlFxby9VZWdCKzFH?=
 =?utf-8?B?TnRZU0RvWjRaZDJ1WW1TRE9HSVNwQzJsUDZLbjlWVFY0MVplQXNYdU8weEd1?=
 =?utf-8?B?ZnpFNGFOSGxXeWlsN2JRdUZtZGNZTmFUZkhEcURQRytNTFNWVmlEaTliUGY2?=
 =?utf-8?B?dEtaVVpJTjh6Vk0yYkdvN0s4T213UllTRm5xT01OZ3lmb1I4SSthN2lveUhN?=
 =?utf-8?B?K1gyTndqWkZ5elNFdEFnQzQyMk9FcElxSDFFcnpDQlZoUTRLUm1EUEN1c0Vk?=
 =?utf-8?B?MExJc05jaitKc0huUndsVVZEMTZOMHhYSWl6U3RldDRXUTZpWTZ1OTJCVFNy?=
 =?utf-8?B?NzcrWDJvQW85a3BLZGZVV01FYzBEeDRZbk5pNXk4QVFGMXovc1VxSTFGcElM?=
 =?utf-8?B?MTF1amI2aHd5MkE3bnNUNzlrKzFKWERzWFpwWVVEdm5XU0xqOUVrYXJnREVh?=
 =?utf-8?B?TFZWM2Nwd3E5K2t6eUdNYXdTZUZtamlyZk85Qjc5SVFoL1F0bTVJNmdURDVS?=
 =?utf-8?B?eS8vb1VVZjdhV0U2aTVyblVlTlJqbGx3ckhlKzZ3Z3hmZVRTQWt5U3hzNHVP?=
 =?utf-8?B?NmJld1h1SkNoNldKM2dNTHJaNnBRMU1rbDdNSXpVdVl2bzgvMlpWYThnaWtI?=
 =?utf-8?B?SDdzbjgwWTIzL0ZlWndzdUo1TkdPUjZvbWhQWGJUZmlORzBLMlJQTUdtQkc3?=
 =?utf-8?B?NzJHVzlqcWZINElWbFo1bXNmL2t0VE55blFCUmFFR3E5YVB4dmlxZlVQT1N2?=
 =?utf-8?B?NGkyNGtraTZnS0NBc1Qxb2x1UEUyUnVxTHdCY0hCNndSVzJVa3FBOEFRSTd4?=
 =?utf-8?B?dFI1bjdzOUQ0dkVXbTFwZG9Wa2ZJeGdoWUJMMFBOL05TN0RSNjQ0cVFSLyts?=
 =?utf-8?Q?peezi3YJjWEz6aSkOwRJQIRsY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6185b86-fa04-4b11-d865-08db39f856e1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 19:18:17.7178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ph6uYQm12ydW/xTAySqlJkiIUps7v6IqudPYWVoS9bKOUGfzQcAG55Ea9cJ1za+rT8PxulDzc4LE1WpAGlWK3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6258
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 4:54 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:33PM -0700, Shannon Nelson wrote:
>> Add devlink health reporting on top of our fw watchdog.
>>
>> Example:
>>    # devlink health show pci/0000:2b:00.0 reporter fw
>>    pci/0000:2b:00.0:
>>      reporter fw
>>        state healthy error 0 recover 0
>>    # devlink health diagnose pci/0000:2b:00.0 reporter fw
>>     Status: healthy State: 1 Generation: 0 Recoveries: 0
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   .../device_drivers/ethernet/amd/pds_core.rst  | 12 ++++++
>>   drivers/net/ethernet/amd/pds_core/Makefile    |  1 +
>>   drivers/net/ethernet/amd/pds_core/core.c      |  6 +++
>>   drivers/net/ethernet/amd/pds_core/core.h      |  6 +++
>>   drivers/net/ethernet/amd/pds_core/devlink.c   | 37 +++++++++++++++++++
>>   drivers/net/ethernet/amd/pds_core/main.c      | 22 +++++++++++
>>   6 files changed, 84 insertions(+)
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c
> 
> <...>
> 
>> +int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
>> +                           struct devlink_fmsg *fmsg,
>> +                           struct netlink_ext_ack *extack)
>> +{
>> +     struct pdsc *pdsc = devlink_health_reporter_priv(reporter);
>> +     int err = 0;
>> +
>> +     if (test_bit(PDSC_S_FW_DEAD, &pdsc->state))
> 
> How is this check protected from race with your health workqueue added
> in previous patch?
> 
>> +             err = devlink_fmsg_string_pair_put(fmsg, "Status", "dead");
>> +     else if (!pdsc_is_fw_good(pdsc))
> 
> Same question.

Yes, it would be good to wrap these in the config_lock.


> 
>> +             err = devlink_fmsg_string_pair_put(fmsg, "Status", "unhealthy");
>> +     else
>> +             err = devlink_fmsg_string_pair_put(fmsg, "Status", "healthy");
>> +     if (err)
>> +             return err;
> 
> Thanks
