Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE01699979
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBPQGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBPQGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:06:50 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A39C7EDC;
        Thu, 16 Feb 2023 08:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676563609; x=1708099609;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QvcqDeQfjFuO+eMOagtGHRdU9dzjW3ndfXT9kZ1Nutk=;
  b=Bbs5ZaPq1p0ui6Twci6Ttye8s0s3NWLvxl0w2m8MG0LAtdIdOMRv2SFf
   6nduOslD5AJ6+bg9Cb59+HUbc+A9AyHaCxLtBjQRiYkFGNgEAFaZ2bGTk
   zzCvGn0cshM7lrDd1/ENNttq4M9g0+NcBF1U0z6cI1BGPBFyrNU//S9Lj
   ftBrUPSjk9mrAZ8hBpDBHuD/n6EB9UgHUA13Q4lTLtoE8I8RIVsTo8HcX
   hgNxGvijGUMQR4stivCqkVHZAq6fmaoTEmcvBYN0TbzVct8Tnja1oXcnK
   N47NS0Ur+BVTQnqMBXIjR/e1w3nl3O3Edule/23OhOb/P0M3eHzSlPly5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="333935138"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="333935138"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 07:29:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="733907478"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="733907478"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2023 07:29:36 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:29:35 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 07:29:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 07:29:34 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 07:29:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nic1v+FxgXSXPm0z9caDGbML9AUvBMm5M7dU0uC0eSvqbXkI0QuhjXmYaVdv2djdlArmhj/1E+5/jvLE1Qg60qwT7QmmDhnNvpaort+ekDdmx1BB4RTgLuCGc+Hel5LMtnKCdTa24niPdmbADeQ635v+oBjlsSXPyKzuwmBBJz5vFz8Vi0vKODvr2ekqfR+bHwcd+lkwXPBatiXBqVvqVaT3aeCQDvK9wPKjOUptPpB1ZCj/IYbtGd6Ql57TKJj+vgD8oGCkgAgI475b7jwNz3/iWEyPvAijqHEgnZBAYmYi7+LIh7s6IDMhF3f6LhHTC5BTob31/+nX7IX7OI9T9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oDzadYBueyUckUZn0Zg2z6Igc5oPyUggSTVNMqyEAoA=;
 b=P35SbA2L715DiuwPBcpxU5ypKsFD33CEq9cTF1ACKdz31+4/AGHcOcGygq4LTzP94bENDrlEdlzbB6y7yX3cgYhYh4gigD+NDhOh55fu8BBfuWCQhoghDQ1Mce+GRLLr6Cxq/uyx5I0Z01gP4gOwdH0jcDv2jRaXImmNXt4rcCkxZy7gHjbZj9JY0RuSsw70UU70y93lwP9pKiQjFyLOR2XnLxdAdkTJlf5NVvzq6i9osegqAHmaxj5ALqztQiLPku/kMAPvsXVLDi4lEHLF0x95NEah5Avy+UedbGcL6t1j6rBQ1y25UHy1O/BIdRBffp+uit84UahNpZ4kLiBa7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ1PR11MB6179.namprd11.prod.outlook.com (2603:10b6:a03:45a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Thu, 16 Feb
 2023 15:29:32 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 15:29:32 +0000
Message-ID: <c7bcedf5-9768-780f-4438-9250faf711a0@intel.com>
Date:   Thu, 16 Feb 2023 16:28:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
Content-Language: en-US
To:     Wei Fang <wei.fang@nxp.com>
CC:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
 <DB9PR04MB81064277AB7231F5775920D788A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <fb2a599f-4a7e-1755-fbcd-56e57abe80be@intel.com>
 <DB9PR04MB8106414C19433AB6B13369BF88A09@DB9PR04MB8106.eurprd04.prod.outlook.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <DB9PR04MB8106414C19433AB6B13369BF88A09@DB9PR04MB8106.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ1PR11MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: a59e4b68-61c2-46aa-0d98-08db10329a04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PclqB4wIWspOlBc7g8GEtJk1slqConUAMH3rLF2Ttq6xaj3tObRV1NBAccT7VInUQev8KHTd8WgxceoW/gdveDhhkMs6xuTYtilZCk0jYDBTxKWC4hrk6MY+WpK6dbgtqpRo6A6tZAw9i7F8nB/dVO47owwdkqXcPy1HVUr/pvxmQEOM1i4BIX4SvQ64QbKY6LCM5FdiI1oJOVZeHCCutRjrgAHIBk+scODDL5sgZrgGEfITowKNelWEY9n6RdI3tfDriuzx3GVX0JH90Ow68Hi5aRGm3GY1aLuN3kW436DFzX/XMblRv07kVwb5uDeAri1v0oo2gfKA+SfKwbKTy1tktZ+8sOt23G2PJSSxUR0Oqt3S0IUHoepnVqXOzOvHjD9zGNffKs3Khnk2answqyvTKPRTsD+PZJ56s36GKf+ljfe8K8hNJYm72FcgraroUkwxortIDo79v4HcCVw4POmoJ5GKxBV8xcL5w0HUMr6EX92inszhqE6wrgYt5k2xTRPscZ0rGkkNhFr7WrY3GrB0nOEVr7vjsi8QTG4l0/t354MCnuChbGr+OGbYw5FN1DaoojauRc8eX+A/V5ias8i9qvwYwRbQAn9MutiWqFEEXYOzKVq3EYW+bAa0Fqg54bm0/ExJRfbHV8KWZrvCvEUBnAULd7XojRJjtFZUpxyvn5Cl6mVaY6dFHovZgLIN8soODBbh7CcmCFqcUREwPYdeH3crJBp/mXdvB3LAAqo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199018)(54906003)(316002)(83380400001)(31696002)(2906002)(6506007)(53546011)(7416002)(31686004)(186003)(26005)(6512007)(86362001)(66476007)(6666004)(4326008)(478600001)(82960400001)(38100700002)(66946007)(8936002)(6916009)(8676002)(5660300002)(66556008)(2616005)(36756003)(41300700001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T05HeXNGVk9xZnBuZjZUYjduaWVjdE1STncrcFFpTkVkT25ZSElMOFRtOCs0?=
 =?utf-8?B?U3ppSTFIWFQ3bmhRbW1NN0QxenVHRW5wbkpFUGxyazBObEJLVEFPMUdiVXFV?=
 =?utf-8?B?bmFhVEtlaHRHNFRXRkdvQkwyNGthMFoyckVObGZoc1JEMzRMazN5MHFTcmNz?=
 =?utf-8?B?VUJwTGdYUFd1dW12SWZsMENYZnlKY292YVZwZnpWV0NLeVFyTzl6YlJaRGF2?=
 =?utf-8?B?QnBRYmVlU0FBUkRycmNoVUxBNGhXUDhSUExFbHBjUWRFRW0rWlVFRktwZFFQ?=
 =?utf-8?B?bzljVEhENE5JTnZwSEVXRjlEaFM5aHFmRDdWRGlnVFlmdE5HN2FaQzlpVjE1?=
 =?utf-8?B?S1lWRmhjRXhhTDhsM1R3Mm95bk5rb1ZhV2dKdkVtV1RSeGdETnhzNzVFWkVl?=
 =?utf-8?B?YUdqdkpJKzNMclpxaS9scjBTY3ZTMXNUdEdlS0RFM3gzcUFxVGJpZEpQWTl4?=
 =?utf-8?B?VkUrTWducXFUeXc2NnFleTlQVDZOdE9mdVVFTnRweHArUWZLRyt4TEplUWcr?=
 =?utf-8?B?Sm9DUHNLL3NjdkhDM3VEdmJtcEhzNnFJQU0rS0tFcmtSa2x3RlhRVWtQQjlq?=
 =?utf-8?B?ck8yQVphTTEyTzh6VlAvYmM2SjlyaDRhK2FVWTZBdXNhdGh3SlE5VlpaaEJq?=
 =?utf-8?B?anc2V21aN1BITWw2bEh3YlVMTVV6WnI1ZG9tT215cUVreDBJaGRaaWdHSnlZ?=
 =?utf-8?B?WWhaVDZNRFV6NjlTbDlqZTA0SlZvdkRQdmdyOTRLZEc5ZVBEVWZUUTVON3kx?=
 =?utf-8?B?MFMvRHdSVmxnTmxtWmM2WUZqME5iZUU0OE9YQ2RPSlZkYTIrUzdMNGx5UVRW?=
 =?utf-8?B?Rk1nWVA2ZlJnOFlqNlk4MVJETHJZT3ZucnUyS3FQL1VKdC9NOXNGZjFnVkpE?=
 =?utf-8?B?SDZGRUdjUVNHUGUxeS85VVI5RkZ3N01sODBKdi9FY0FTUXJad2oyMmNHa2Za?=
 =?utf-8?B?WUxQd1FRTXYzS0hNVktWK3VQVit0NHRIL1pRV1RiVCtaSmxBdG43NzNaYjM3?=
 =?utf-8?B?Y3RDemRFb0JJczF5TW5RdW55ZmNnZGl3bjErT2xWNTRwaUVSUGpGLzFLYjZF?=
 =?utf-8?B?WHlJc2g2ajE4R1RzYXhJRS9Fd3hWODNCcG5WRGs1R3N6N05HTCtrcnZPNUtU?=
 =?utf-8?B?d2kzWEtVdG5YL3ZJT3JGQXUzQUY1Qk1LSDJhS3FMdEFoMEh3Q2tncEpFejVG?=
 =?utf-8?B?TG1xeUFJR0Z6UHpxRCs4dFAvNnhaUzEveFBHdE4zVlpFQi9GQkMwMHpYUlVT?=
 =?utf-8?B?Q0ZLUzAvYkNGd3pYN3hGa2Q0WmU4bWdCYm80ZWxoTlRCNmtGbGlwdTNlSFFs?=
 =?utf-8?B?SWJDUUROVExkb1R6ZzQraTJUKzZkaE82KzJhalEwZmd0bThkSHNKbGNUVWEv?=
 =?utf-8?B?NjlVa1dXY215WjVBSW9jWFJWN2VjQmZnRWNkMVVVUWN0dC9ha1pGbjhMRDZq?=
 =?utf-8?B?WEEyTTFsajQ0akVzdnYzdjhmbFVESjJQQXZjZWMyb1RKVVFhcVFHcVBWYlds?=
 =?utf-8?B?MS9odGF2NHhCbnNGOXlWejRQTkd4ZFRQQXpXREE2WlFHdXd3aEtUNjVweTRk?=
 =?utf-8?B?dW4yY1pUcEZ4eG5ETzdJL1JJdVY0ci9wUFE4QW83SU5zcUNzNXhtaytMNFFn?=
 =?utf-8?B?UjZLamtVZXg3Ynk3QlY0amlrT0VLL2U0Q2w1QkZucTJzRzJ5WVdyZ05qQlEw?=
 =?utf-8?B?STdSWHRKenhjL2RFSTBBN25GVjZTVjRKRlgzT2RZR3NYNDJicDlkNkFIaEU5?=
 =?utf-8?B?V3ZROG8rNTFFUnhEMTEwM1JTY0crYWhoSmFMMk4vaHNRd0ptTkZsQm02MmVa?=
 =?utf-8?B?UDBLSHdQNDRPTlhZMjdVVnF6TjYrSUFJZ3dHbGNaTTZ0QUl3S1BUd3d2UEFm?=
 =?utf-8?B?a1pHRnh5cnlCU3pWR2xtSUJzandVcmRjZHArZCtUUFlyUXNJMTlSaXBqbkNm?=
 =?utf-8?B?RU9SNFRycSt6MFFmbkdjSDIyZCtVWkhsRm5MZ0ZUWHpNTGhYL3ROQmZ1emha?=
 =?utf-8?B?M0FLTmRDVlUwMVg4Z2M3QksvVEsxWER1RklBMUcvOFBOK3NnM3dzaG13RWkw?=
 =?utf-8?B?bnY5dHVGaW5KSG5jTE94bDdRQklpekpGWUxIaVkxVjFVSHpUTW44R1ZJS0Ja?=
 =?utf-8?B?c255YzJ1NzE1VTRIWXdXUUZBUWd0M3V1clgxMGxVYzRvRWNrRTlWQzBtbUI0?=
 =?utf-8?Q?QbGie/pJ6H9MvWjXkLZvFrQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a59e4b68-61c2-46aa-0d98-08db10329a04
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 15:29:32.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EBGFXGiX6T3wui2B+hNlY6d7L0F1P4bDG5yBd/53YSY2MYcBkwF+J75yXELAt7WYrq3hzc4QcbPQE0DcehvKjYoANV+pQ8LBQiMFIR/qsLE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6179
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>
Date: Thu, 16 Feb 2023 13:03:37 +0000

> 
>> -----Original Message-----
>> From: Alexander Lobakin <alexandr.lobakin@intel.com>
>> Sent: 2023年2月15日 0:49
>> To: Wei Fang <wei.fang@nxp.com>
>> Cc: Shenwei Wang <shenwei.wang@nxp.com>; Clark Wang
>> <xiaoning.wang@nxp.com>; davem@davemloft.net; edumazet@google.com;
>> kuba@kernel.org; pabeni@redhat.com; simon.horman@corigine.com;
>> andrew@lunn.ch; netdev@vger.kernel.org; dl-linux-imx <linux-imx@nxp.com>;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
>>
>> From: Wei Fang <wei.fang@nxp.com>
>> Date: Tue, 14 Feb 2023 09:34:09 +0000

[...]

>>>>> +	int idleslope[FEC_ENET_MAX_TX_QS];
>>>>> +	int sendslope[FEC_ENET_MAX_TX_QS];
>>>>
>>>> Can they actually be negative? (probably I'll see it below)
>>>>
>>> idleslope and sendslope are used to save the parameters passed in from user
>> space.
>>> And the sendslope should always be negative.
>>
>> Parameters coming from userspace must be validated before saving them
>> anywhere.
>> Also, if sendslope is always negative as you say, then just negate it when you
>> read it from userspace and store as u32.
> Sorry, I still don't understand why u32 is necessary to store parameters from user
> space? In addition, people who understand 802.1Qav may be confused when they
> see that sendslope is a u32 type.

I didn't say you need to store any userspace param as unsigned, I only
say that there's no point in using signed types when the value range
belongs to only either positive or negative space.
I'm not insisting in this particular case, I guess you pick what should
look more intuitive here.

> 
>>
>>>
>>>>> +};
>>>>> +
>>>>>  /* The FEC buffer descriptors track the ring buffers.  The rx_bd_base and

[...]

>>>> Oh okay. Then rounddown_pow_of_two() is what you're looking for.
>>>>
>>>> 	power = rounddown_pow_of_two(idle_slope);
>>>>
>>>> Or even just use one variable, @idle_slope.
>>>>
>>> Thanks for the reminder, I think I should use roundup_pow_of_two().
>>
>> But your code does what rounddown_pow_of_two() does, not roundup.
>> Imagine that you have 0b1111, then your code will turn it into 0b1000, not
>> 0b10000. Or am I missing something?
>>
> 0b1111 is nearest to 0b10000, so it should be turned into 0x10000.

fls() + BIT() won't give you the *nearest* pow-2, have you checked what
your code does return? Check with 0xff and then 0x101 and you'll be
surprised, it doesn't work that way.

I'd highly suggest you introducing not only round_closest(), but also
round_closest_pow_of_two(), as your driver might not be the sole user of
such generic functionality.

> 
>>>
>>>>> +	idle_slope = DIV_ROUND_CLOSEST(idle_slope, power) * power;
>>>>> +
>>>>> +	return idle_slope;
>>>>
>>>> You can return DIV_ROUND_ ... right away, without assignning first.
>>>> Also, I'm thinking of that this might be a generic helper. We have
>>>> roundup() and rounddown(), this could be something like "round_closest()"?
[...]

Thanks,
Olek
