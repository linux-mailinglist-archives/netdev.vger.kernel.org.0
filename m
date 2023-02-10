Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38C16929DF
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 23:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjBJWLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 17:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjBJWLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 17:11:41 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40456C7C3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 14:11:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjinMEtwIeBf3MvjuOiTqclMLj13vK7J45atYRzYlXUmh8h8L94U+j4XFWsMG1uc5O8+unpof4d8vmyqWI0cJCZSMnHzA+Qx7uhr8y7TVpvDBQk1iwjnLqJlJx/HLM0EPiXXdm6nVijL5PomO9L2h1chZxq3Ypo0+UKzgMvVbH+SO/iIdwY8k0Kn7TDQPFPQjd4WrtaH90NV+JqxMKehYBHjgWTxvnxdkV9/bxaruq+tNvbWrUHSvpst4xHjH4vIcl/r2BnOboIsQHa0MK58X8dL9Si+U/ub0RGdDIlwf+xmHnLUbGd2TamiNfKF82ASncsE6Acz9kc1MCzXB8L/Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4feP6go8uSlXeLX1/FvnaHq6KHlX0u2DlmlNxWzx6no=;
 b=ZITTxwnU0lYoAbvinam3/m7439Qk3vIfUkXlJXOJXKXW60JSMRIvTs3tLig2S8cCk6E/yecmPnsBOdOqmkZjMskvuv9dFItZTkbkdO2SjAA239UdrfNyLIWGs4tDy//np14auw6qlC8jLEOxpbgzudEu3VTaRtMTDbEBTQaUW3acIjG+hYqkhZ0WipoSX4N0wj8c85/NbPZvhu7kTpZGVH1vH8OOC7LiZ7K8EKlQqWY9RZs54knVXQHWupSRXw3EI/PyEXrGaJQkiaKA1HmuscbVtj4Dj+vz1iFPn1UlipAVeCyhjiY5NZIh+Jc5aLzidMF5IN5BVnZuDcRsEcynZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4feP6go8uSlXeLX1/FvnaHq6KHlX0u2DlmlNxWzx6no=;
 b=BYLs/5rYHz1zxcbsBxI/pzb+6BOIjjwCVKzY/BKG+lezhjalCQV8AWvxEHlhSGl+Hq06W2kLfCt2V2ZU/Ih+87vhmXoGoUQ9d1xx/94AuprHur0iEK+7D5E0EQDFaUEyciYdqJx3+XxlWPDAHqgfFLkTuw++tZlbrMDvIS0EqRo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.21; Fri, 10 Feb 2023 22:11:37 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::2ba2:7ffc:1e24:4bba]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::2ba2:7ffc:1e24:4bba%9]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 22:11:37 +0000
Message-ID: <8eddbde2-ad2c-9d4e-69b0-0c768b334faf@amd.com>
Date:   Fri, 10 Feb 2023 16:11:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [patch net-next v2 6/7] devlink: allow to call
 devl_param_driverinit_value_get() without holding instance lock
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, moshe@nvidia.com,
        simon.horman@corigine.com, idosch@nvidia.com
References: <20230210100131.3088240-1-jiri@resnulli.us>
 <20230210100131.3088240-7-jiri@resnulli.us>
From:   Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <20230210100131.3088240-7-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:610:5a::35) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|SA0PR12MB4429:EE_
X-MS-Office365-Filtering-Correlation-Id: 58dbf485-2ffc-41e3-5e4f-08db0bb3c73b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EIK79cxoNeZQxff1HCnqWtoQl3E6AclxfNrs0bXmOSssis3ldU/B8dCTEQ4a1pufrY0lNk1wc/hwEsFykB1bCo/IxHUCAY7fvVChSDLZRDjRySRkPwEaO+P12d/fi2C8XMgyink2rj7LNGy+DHdt68gmXZAheHjaKUQK6EGBzw9uqjy79ruwN4VfDO9ZqjaidkJ/bQMKmgycieqoBrboV/bWl4Ep4590VSgGGDLVeJ4DIBsTzTO0yzDDBVCM8xTEV687xsg2EqsJN1oan7cw8mHYuQ04SDy36rs1ISJ+8uvGefIEtiHB7GmdOM69jHWW9Xq/bbFrD4WTVAPXFqRU9weNqONJ9LBIqjwk5IA5U3giWkn7Si+F6Lh9pJAW1FcZls3mwTm6iN9pqXWqoCiwuw/DjFlx9o9aKWayCGf4T0pN+WnZI1Ir+hgPyFe+qfiMq2PuJwscOVaKQDUT5kIqVIQtrRrA3NLz5k7ijmL+5TfIbR/OXCzkyyO2B37msVEy9Eki3t2KGSvD9yiaue35JyCFfkOjVerEhx9RngN0i9JhayKalPD414T8ZeV8sL1mGQkR48/reIRwDd+o1At5fyKDb7vhv4WEg/2Y+mlF8PVvB8IES70Ov74FZkR+B9pePMSQZN6nWW+pSPvAHbmWRHv+uTkvjE5MnJEpb9X4t/MftzvmLV+hy0UY7psd+sue51PyuXTs6AOuQ6GLZZ8pZn+OGDAI58KVarrDO8/2xlECeGzoK4nwldWas1FjEGiktRO+JZxZ41WL4wEhQmAXEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199018)(83380400001)(66476007)(66556008)(66946007)(316002)(7416002)(5660300002)(8936002)(41300700001)(8676002)(6666004)(4326008)(478600001)(6506007)(6512007)(186003)(53546011)(2616005)(6486002)(966005)(36916002)(31696002)(36756003)(38100700002)(86362001)(2906002)(31686004)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDZPNmF2SkhwdG5wYXlwTWVDM25TU3dESklHMHVsbnRRTTdpZ0t2S3VGbGpw?=
 =?utf-8?B?My90ZU14czBTYjlHd1pRM2p5MjhXMGxBTmJ3U25QZ0lpQUFVVmlUSUNtK1Vy?=
 =?utf-8?B?MzBGYkxEbHZ1WGtGbkU1cVVpanpzWml1RGJ2REs5MDRCK3NuMjNqZkVrMkdM?=
 =?utf-8?B?N2tjNm55Vk9IRWptbDVUS1J5Mnl3RDh2VnFObmJiMXJDcnN0WXgwU1RKWXky?=
 =?utf-8?B?RWdnM1AwTHM0ZFRqdzhZVHdTc0F5NTRQQnB5bWIvUjYwaUFxN3FwbjEzUVl6?=
 =?utf-8?B?QUpJWGtoYkdvUlRIVU0vdGRoZnVTaFBuNkkxTENRNlBSbGR2Wm5JWDlFUTM0?=
 =?utf-8?B?K2pHNVk0RUw1ZU9iYUo0MWNNL2xraXh5Qkg4YTZwL1BmMmVWNE5mZ2FOb2kz?=
 =?utf-8?B?bFBySXhLM0pBRmJPVFpEcEQ3VzBQT0N3NmpQc201Wk5rSElMbENBSEl3TkpV?=
 =?utf-8?B?SEV6aTRyUHRKcHFVeElFc1ZubzFWU3ZYcmg1Z1QyRXJXbUFObWNEOUpiZFIr?=
 =?utf-8?B?cHZoREJNSVZwam9qNnRoQnBTbkd1Mnd4c1dZUllZMldtUGN0Q2NXNkpsZTZY?=
 =?utf-8?B?NkVpbUlRN01QNEJDYStnZTM3VmNaS1h4ZUNSNEN3Ym92TnRHQVJ6UEFBMldu?=
 =?utf-8?B?bmF3bjIzWW1tRDJ2bmo0NmJlbUJ0Q2t3VGFOTUFnNTZDallmU095OHRyVnBW?=
 =?utf-8?B?aWVUa29lbFo3dDBReTU4ZTdtUm94d2xNaWxvd1N5UXBlSk14WUdOMk9sWHFE?=
 =?utf-8?B?ZE1Hd3ZJN0ZvVWF1ZkI1dkhSdTBjeTN4ay94Yklua0N4bjErQjRtOWxMV2JS?=
 =?utf-8?B?QmlNME1CK3V0cDdyN2FCM09lVkszNWg2NVhYUCtZZ2VmWkVXVHdVeUJuSCtI?=
 =?utf-8?B?dnJZQklNRWpXemR6TDVhdGFwYTFTQ3lMVHJJWmhCU3hMVHU2L1h2bTBCZWNV?=
 =?utf-8?B?bHQxeUR3SDRkUDZVdC9XMXl0OTg5aDNLTXhVUjlmTnRCSThrK3JBblF2ZEhN?=
 =?utf-8?B?Y1ZzeHF0ZCtJbDFaaDB3dkhCS1FvMFp4Z0w0M002WWltQjFVZGpDNlhMb2Rv?=
 =?utf-8?B?YmNuc1N5ZGVmR0h0a0Myd3hiZGFMb25DVWllSGpQQVhSdkdIRWZ3NkU5SkF6?=
 =?utf-8?B?djBud1BUTEVKZUFKelpYUnFJK3VISDR3WmNPWnkxbVhKZXhmalZqUno3MDVR?=
 =?utf-8?B?ZUk4Um15andiQStzOXJWMnBpM28zRkFPVnZlYWhuOHFvWTd6OURkZ3FJTHEv?=
 =?utf-8?B?RlJ4NlBBOFk5eDZBSWQ0ZGFNYW43ZG5HT3hNNnJJS09YdnVPUkhFTXphZGZS?=
 =?utf-8?B?eEcveFFTWEF3MU1FelFYSkwrRW9yTEtxZUZYTEdNdHRNWG50WW9oSU5ZQXBZ?=
 =?utf-8?B?dHcxNkd5M0loRnBuTDZrb3QyUWdQTVpQc2xxSDRnT2U2b3ZEVUNuWUJFem5D?=
 =?utf-8?B?TmtIZmZvbHBVWEpQYmJ1NitoSytWYVNHMnFXK2pzTHJDdkQ3MkR5TEZ1Y1Ux?=
 =?utf-8?B?MlNlZXZHR1RQMXNidW9KVS91SkVJekgrZ05zcWFOWnI1Z1NyekdSNDVtaWRt?=
 =?utf-8?B?eVdkdTF3cW1tQ0didEo3bTY0N0hxazNuYVpKVmRuUk5MUmVGUHVmeDVCdTFO?=
 =?utf-8?B?ZDZ3SE1JejdRTVZEVGdjNUVXZUMzSkN4bWRKYXVVVWs1bUJ3QUpva0ZrWjNo?=
 =?utf-8?B?amwwYkpiNkRqVStIOC83MmZaTlJYaExid3JCeVNVZkJML3A1amc2cUhTVnRW?=
 =?utf-8?B?dmdERXBHOVhOTWcwUC8rMGxJUzhNNHNMeU5FQTd5SXdDT2pON3ZKcGo1ZE1V?=
 =?utf-8?B?OFhRNTJ1U3VvaFVKdHZFcFRtREcrVCtVcmxjTzUxaHNmVmM0d2djL3R2bU9T?=
 =?utf-8?B?dlJlKzMxZDZQSG5LRkl6aCtDamRVOHgyd1lnekZZaFJVRmJsTU9LK2c0T3Bz?=
 =?utf-8?B?SHVUZlh6dDJUaTlDVDBpTmhqejVya1grNjMvMEk0WldsQnpEVEkwN3hYYXFI?=
 =?utf-8?B?OC95V2xhTkVRUWJXTXEyU2htdmV1Ym52YU1UaEtkbWxobjhLRWp6OGVIQnhX?=
 =?utf-8?B?VUltNHJKTkluZ0lBdGRlRzI5My9QbnA0OXBwMHlKMkpRYm5rbUVqVGFPNXVm?=
 =?utf-8?B?VnNoalR3MWhRZ2xhV0hCOW15MHE5eXBlbnJ3amxlRW5YZjIwVlJaL0dKbjFz?=
 =?utf-8?Q?7VabDFyJ1evNtWOeTsFdWoGedBwGQFbIeMZU6QqmRYbG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58dbf485-2ffc-41e3-5e4f-08db0bb3c73b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 22:11:37.4240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M8ABJ3iNCuR/1fgBMf1TYYG9jmO4OQxam8qijhIW7ShyJJc8a/WjJtIMwjo4X0iZehGCQL/b96b7cQMK4mzJvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/23 4:01 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> If the driver maintains following basic sane behavior, the
> devl_param_driverinit_value_get() function could be called without
> holding instance lock:
> 
> 1) Driver ensures a call to devl_param_driverinit_value_get() cannot
>     race with registering/unregistering the parameter with
>     the same parameter ID.
> 2) Driver ensures a call to devl_param_driverinit_value_get() cannot
>     race with devl_param_driverinit_value_set() call with
>     the same parameter ID.
> 3) Driver ensures a call to devl_param_driverinit_value_get() cannot
>     race with reload operation.
> 
> By the nature of params usage, these requirements should be
> trivially achievable. If the driver for some off reason
> is not able to comply, it has to take the devlink->lock while
> calling devl_param_driverinit_value_get().
> 
> Remove the lock assertion and add comment describing
> the locking requirements.
> 
> This fixes a splat in mlx5 driver introduced by the commit
> referenced in the "Fixes" tag.
> 
> Lore: https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/
> Reported-by: Kim Phillips <kim.phillips@amd.com>
> Fixes: 075935f0ae0f ("devlink: protect devlink param list by instance lock")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> ---

Please add my:

Tested-by: Kim Phillips <kim.phillips@amd.com>

to this patch, if not the entire series.

Thanks!

Kim

p.s. Sorry about my testing snafu on v1 of this series - it wasn't
clear to me what fixes were where...
