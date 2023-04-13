Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8516E1875
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 01:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDMXmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 19:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDMXmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 19:42:18 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2074.outbound.protection.outlook.com [40.107.102.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A0410CC
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 16:42:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yi2BJ1ioNl69AR6C77ByHVxVLDKX/V5J7OiTvm917OrbGUYlaOVecBfqnCp+EK04K0Udb0qoVKJrKm/SRcmxZeZpIRRgggDqeVbkLZqpX+4aG3RQZxElSuZcmAsphKhgAly+6NB+girW9V7BQrHzPpvQg3lS/0uBWOLXUMwNhT0w8wMXkZ/2fJcuIfCq+440YxpxvhWAAmM/BU9xUGNJKXrt7BCVZKnw50aQfr9vwGH/ZLyEbvm41NrhUELK8tT6QuDbRD9ZRGPA3eamEPjczozTsbtPLgTRtN111n8SxD6AULVr6ztk6y0yYhTDEs4m5v5YLPy65NEUzeK8SiD3CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPFqLuKdkrRHArWxkRO9rAbG2MX4dLmufJdGRWN2x0M=;
 b=caZFrdeQbGojnQ2AeGiA1O521gTMmYlCDdks73+TunI9VIzCwCRbnT4w6U8gBP1Dcs0w6v4/2PnhvcdmVsLe6Ognt+x9JCLrr4CmEIpDIxInwJCw/OKgvE5CVxQv78AjsdN9bN7T0y59DdKMwb0bAmbqaCm28WgImLaGUJur7UNNYqqX4HuiEftAXefYqAkN914IAov1cBd93tGhyjOWEwMSHrg7IRABg2cZerW7LpQGmKKxYLQDHF0f+OnIJwPpj9AYcxVLM6IdLTV3L5fW3//WxgQ+y5DfQ3RJwDzppdOxFls6BqV1Vi7ukuGH8AD7UlSDRV2V1MmYxXz94aMd2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IPFqLuKdkrRHArWxkRO9rAbG2MX4dLmufJdGRWN2x0M=;
 b=Jy7aKt8qWlXr7uF1rS/up5TCpRUBW29xrw/0hpTF0IOC82b0qJVJB6vqCEFXNIvvGJAVa7IbTriw0ElDM5c1MLUzGEnrMYHTWB1ffY2bh9NwHWOk4sXRtGpZWv99rkQoTdO7CegFPh5qfTboSpDRBOko0KwTPlIHG09RkCw9GLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 MW3PR12MB4586.namprd12.prod.outlook.com (2603:10b6:303:53::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Thu, 13 Apr 2023 23:42:11 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 23:42:11 +0000
Message-ID: <d6a65f08-4494-8d54-7799-a819f6f2e566@amd.com>
Date:   Thu, 13 Apr 2023 16:42:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the clients
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-14-shannon.nelson@amd.com>
 <20230409171143.GH182481@unreal>
 <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
 <20230413085501.GH17993@unreal> <20230413081410.2cbaf2a2@kernel.org>
 <20230413164434.GT17993@unreal> <20230413095509.7f15e22c@kernel.org>
 <20230413170704.GV17993@unreal> <20230413101015.0427a6c8@kernel.org>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230413101015.0427a6c8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:a03:255::19) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|MW3PR12MB4586:EE_
X-MS-Office365-Filtering-Correlation-Id: 52394aea-7169-4c6d-55f6-08db3c78b3d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHW5kT9hH1nMb1ezRR2+aRc3S5m57aoogS2jzNqzaBZlvbwPxYDKFyBTwU3yfVykBZWNlUKx6ENuR2pjt88vCY8NRHyqB33aFKWSxXvLqGvjdV3TnnpEY9l4Ueb4ohGqFI10wHiFsVG4Bs/f3AZRA5P9WP2dTymzHOA5p1U7MNd8Rncbexa8ALoQK/PSH16n9cnij0kaqhUltJhIW2LUwWzHOdNW5qj5Q0TAug1+Rf2w67hg8VibXtp0Nxy5A26ZDTDjY/lE6aF9LR/Qi4xxBY+5uoGnLAGRGnm3LF9fu8x4UGLeoHRCKYF3sbp7Xs891ib4XlXI7eyQIfTFn3QROuIJJ2H3uH1BhDDUywOOWRLCbDAVzz+eK7VoHtOgrFw0sBvF/RTQprlFjFZTiHGIbmlG5YTcL3tfTtcIKapTiEoEbMh81fpuR/dUxHWRy15ukzRHQidwTQZIOY11tm74h0pa6y2qHrw7gb+P59aatYVszJEM0apd9J33V/D4FA5WtwImcGtgP/iIq28oQIs2MRf5JKBDZNZhb0N9SHCxdgFVEC0HmfTAO0fdr5VlKka6nJoQslBTlRgbYchuq8MLa4/nsk1rZip81OEySanW6LWyLJD8TA5pLfmBh+GWTjTDhPLJeCnmARqcoezlphVau0kEefzUaJGIicCMsi2XTFyEDPuLpJLuYu1bWXVas6k3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199021)(31686004)(66899021)(36756003)(5660300002)(2906002)(38100700002)(86362001)(316002)(8936002)(4326008)(31696002)(8676002)(41300700001)(66946007)(66556008)(66476007)(83380400001)(44832011)(2616005)(186003)(6506007)(26005)(53546011)(110136005)(6512007)(478600001)(6486002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QW1BV25BKzFIUVNoMnp1N052cmdTczF0dnhQRDRZZlVCOUwyYTZBdElBcklK?=
 =?utf-8?B?czJLN3pUeXJUUFBXb01KZ2Q1UDN2QzhsOEtlaTliWExtNHA2RHJxbzBnV2Fx?=
 =?utf-8?B?NFF6WENFcyttMkhhVWdhSW16UVQ0ZmtZNWRVU2ZSUEg3aXoxWG51dWkwcm1x?=
 =?utf-8?B?WlRpYnpnZHNSTTdIbjRIZkRoL3h0SWJ4UTZiUk5CZ2pKYzRDV21DRFR0Zkx4?=
 =?utf-8?B?c0w5ZXFIL1dYSUs0M3ZpeG9YSy9hVFVqS3F0K25XWVVFQ2NrRk5RQTZZUnFa?=
 =?utf-8?B?TFBlYmZyMmlNWTNIeFNXY3hBclhneHNNd2FvS010YnBuVEVJV3VKSkZXQWlD?=
 =?utf-8?B?T3NQZ1JsZnpXckwwcnR4TzlSY3RaTGlCZyt1LzFZNUlLNmUzVE40ZlRpcnZp?=
 =?utf-8?B?VUhvOXZWMWdiSFlsNGptL3ZoakhRMmlVOXFjNkVzREJ3SlozVnJrT1ZraGZk?=
 =?utf-8?B?WUNTV1phVUF5aTNJTk1TaUdRNGViUEhVUm1OZnF6MS9GTUtPMjl6M0kyRkJa?=
 =?utf-8?B?cCtHbXJTckExQkhXd0VsYytHZE1aVDJjMWUzWUdhZTAvYzU4S1FyTUhyaHR3?=
 =?utf-8?B?eUdIenE4ZjRBUzZlMklsWks1SXAwaVliU1pFeG1hMUtSeGp3STNFRG1NcW5z?=
 =?utf-8?B?c0FNQUg2NzkvUWV2RGxJczlNWTJzdVFZTVkyNmgvb1NYNnl4dlZFc1JPVFV0?=
 =?utf-8?B?YkpjRFRNNk1xY0trblVPcS9GYnRPc2E5cGkzOE5MMFNDSG5vUUltWWpQTUU1?=
 =?utf-8?B?ditLR0o5TVlPQ3VwdHV0R2MwNnlDaHI3RndzQ3VUNEZXM1JJelNiRndBTXNk?=
 =?utf-8?B?U25vQmQ5ZWJrS1hsR1p3WHd1bGl3c2RIODl3N2htVm5nSzFiWVhUVnlFbTJr?=
 =?utf-8?B?eVNveS8xL3hXdllLZHlLY3BjWXVoR0dlOHo1aGdFV2d2TnR3SlNtUENKaWxm?=
 =?utf-8?B?c3NNUld4dlZBd1hEMU45d2RnNTdLekR1ZkxYZkgzUFg1em8zUDJtOHQrVEF0?=
 =?utf-8?B?cnhnaENHOFdvRFp0bXRsQlo1eWF6aVRwVUJPVWRXa3F0a1dIWUV2OGoybWtj?=
 =?utf-8?B?TitxWlNqSXVGWHpReWsyMC94MTRvRzQrU0RSR2NmUkFoamZwMGY3MEV4RXFU?=
 =?utf-8?B?K3VSUWtsSk5Sc0FuWElkYU9RNE5lR0VwVzg4b3FzVHppRVdWeDExSm9BL0Nn?=
 =?utf-8?B?dUYxd1g3ZWRWaTZtSEFTSERiZHNUQ0FTZm9nSlkyUEladHFmK2ZmLytpd2I2?=
 =?utf-8?B?VlQwTnNQWFZrZnF1bGpiKzgwQXV5ZnJKcitjUGFqU0swb0Rvb2UwcWs1VGJm?=
 =?utf-8?B?QTVkelErSzRHZFBqaEp5WFBHODduOHI0ZGlSdEIxbHpuWVp3cXF3bnRvYlA0?=
 =?utf-8?B?MCt3U1lVa3pZL1MxOUFyVHNrWmRGSXRGY0hxdHhtMjJsVlFWY2tXU2FRZFhO?=
 =?utf-8?B?NUV0T1BGRkVsM3hvMXV1bnpEUFovaDVXWGNyYVIyTUJEeHdzNEs3ZFROeCs2?=
 =?utf-8?B?eXVyZkFSSDlDSy9UNS9ROW45WXJ4N2lnTCtHZkxtcGVqWXVuZGl1bXN4b0FQ?=
 =?utf-8?B?T2YramJ5QUY3ZWNJUk1lSXk4bHZMbjJaejNydTZwODNaYmxiay9zYnh0RWg4?=
 =?utf-8?B?OURPejRMa21oSDdtbXZNQ0Y2T0xMbGJsQnFna1lRd1NiYXcwWXVsTGdHK2Jw?=
 =?utf-8?B?WnJOK05jQkl1K2FYMFFITGxieDFqVngrQTZ5c1BQSmJERWdITW56eGcyckxw?=
 =?utf-8?B?RlF0bEZaODZlTUw1TjE1RmxjbVdTcksvcGJuVVNMWGhzaHM2dzU5bGhmOExw?=
 =?utf-8?B?QU1mVmwyWVFuQWpjSVI1VERDOFZYMlVleFdkcW16TzRqZ2s2L013MkxXOXhx?=
 =?utf-8?B?aGNiTWdld1Z0M2grTDlFZVZYRnF6VDhubUVFcE1uc1VaYnVUSjNoSTVsTCs0?=
 =?utf-8?B?ZGVwL2wrYXNyc3hwaTE1YmtZdVExKzVsRU04VUdwdjF4MUVYd3RpeU1OeDhh?=
 =?utf-8?B?RzV2YlBOMzZXWU55OVRmekVDTFRzM012RG1IZkwxUnZ1Qy9CZWlhck94TDZK?=
 =?utf-8?B?cmZpeVd1bGpxYkFENWJFdWZVb09CaGMrT2VaMEY2UG5HVVVZUG1EYjVnZ2lV?=
 =?utf-8?Q?uPOgLsPdsGCEhhPHo1j9ocYbA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52394aea-7169-4c6d-55f6-08db3c78b3d7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 23:42:11.5755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +M29ZELZNGKD2zlmovMTB/HUdJW5wBCPp7EjNRmPnm1d80WFGFREY1vFFBw1J317HsIvGvdfpXfMxvHS86t/xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4586
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/23 10:10 AM, Jakub Kicinski wrote:
> 
> On Thu, 13 Apr 2023 20:07:04 +0300 Leon Romanovsky wrote:
>>> Hm, my memory may be incorrect and I didn't look at the code but
>>> I thought that knob came from the "hit-less upgrade" effort.
>>> And for "hit-less upgrade" not respawning the devices was the whole
>>> point.
>>>
>>> Which is not to disagree with you. What I'm trying to get at is that
>>> there are different types of reset which deserve different treatment.
>>
>> I don't disagree with you either, just have a feeling that proposed
>> behaviour is wrong.
> 
> Shannon, can you elaborate on what the impact of the reset is?
> What loss of state and/or configuration is possible?

The device has a couple different cases that might generate the RESET 
message:
  - crashed and recovered, no state saved
  - FW restarted, some or all state saved
There are some variations on this, but these are the two general cases.

We can see in the existing ionic driver there already is some handling 
of this where the driver sees the FW come back and is able to replay the 
Rx filters and Rx mode configurations.  If and when we are able to add 
an Eth client through pds_core it will want this message so that it can 
replay configuration in the same way.  This case will also want the Link 
Down event so that it can do the right thing with the netdev.

For the VFio/Migration support (pds_vfio) the RESET message is 
essentially a no-op if nothing is happening.  But if the system is in 
the middle of a migration it offers the ability to "cleanly" fail the 
migration and let the system get ready to try again.

For the vDPA case (pds_vdpa) we can trigger the config_cb callback to 
get the attention of the stack above us to suggest it look at current 
status and respond as needed, whether that is a Link Change or a Reset.

sln
