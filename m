Return-Path: <netdev+bounces-12182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4603473694C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 69D921C20C07
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF7E101FD;
	Tue, 20 Jun 2023 10:29:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6936614262
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:29:13 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04707101
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687256952; x=1718792952;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=if0mSsicrZUSInEZjizhLWnu0nag0cDX6ODxSDUbe9Y=;
  b=A2VGl44tos6DU0tHxsVTmcNgKZb8i7CLD2KI3C6o63LAC+ELMnL5CYZv
   3SMjdubEi2ZqNELp+iF9Z0SJ1Ji94/wXFB8Cf1++477etd1qniDyxUKLP
   eo6hAclOSIujevP0wxHscgG8IWYFlHQbQTS/NjkMNMYLMdrhmfconqM7w
   Mx8SAaj/3DiwqJjqe1QCwtJ+sW0r3OahA3wlwqItvHZQSgxuMDFfRuK3q
   H0NGIX+YYBrfD7Dxb8gaolsIL8QkgKSKjIctmJVdYemFJOoQtZ8h7mUUL
   SHwxlRsHuC9nILXBljux0k0FAczhT7jtbLWFuwKdMv4hTbSO7LXYLasRE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="389044109"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="389044109"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 03:29:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="743743316"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="743743316"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 20 Jun 2023 03:29:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 03:29:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 03:29:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 03:29:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 03:29:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7IvYQvrCDU0pPmIfJ/7GTchNC2QzPuEOm0bzHEU7zXUw+7e54wcybzAboTNZ3pqGkIXsGagh6iYulbsbGmcBP4PKfTYDG18PnFIWL1EDNUD4hbxiiqEjjMzQBSOH3tVInDWw6VBTIdgWEOgBw2lM7a1fIB3Impchgsoz7WfwIlxWcHeeIZmryAz/HJk104SWUcukDn5RFU5xNd6tldTeOGTjbjT3Fk3gFWZ3GkWO1y85SWM2ADuzb6OZpHhjuhQQ23UTqCqQzIBIvsJKtHdW5EuA71IAAYzqnxICZ81O9XeyL3AmjtpvC6qBxWU60MbiAkyociiB0ThswKZLZPYPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8zW68poc7NX657FdjC9cp28F/JktpFu2cP+20fBkZLU=;
 b=IbcE61/pDV9RSePdvUTaZTsffA2feW7zU4N5GRB37mcddPH15Sik1/TGV14VUenayu1hOp809Op47DUlCmaBibJrdpaQutl28/vVI1m2Vde2wrZ9gN92y8cvLCS//DpPzVxudYJ+DllXNrDEIDBiD4inqPdeM36kFp7ukHYqzZr6ZsKlLUCbLgOxyFDu9oVJN6cd9Wq+ZwlJvZlmPsDGR/cj24H5eJoySAiUGZTc8HzRxgSR6IYe5xN0RbJ+JDzmj5XSAO1lf4ROr8R+xyXni/Ui7VWtDZxTJMBDjYE5sU447w/O673GSgi7se0bUJdQgay74/yEy1c/g+HxklipWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by IA1PR11MB7824.namprd11.prod.outlook.com (2603:10b6:208:3f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 10:29:08 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 10:29:08 +0000
Message-ID: <18b2b4a1-60b8-164f-ea31-5744950e138d@intel.com>
Date: Tue, 20 Jun 2023 12:29:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net-next v2 1/3] net: add check for current MAC address in
 dev_set_mac_address
To: Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>
CC: <intel-wired-lan@lists.osuosl.org>, <przemyslaw.kitszel@intel.com>,
	<michal.swiatkowski@linux.intel.com>, <pmenzel@molgen.mpg.de>,
	<kuba@kernel.org>, <maciej.fijalkowski@intel.com>,
	<anthony.l.nguyen@intel.com>, <simon.horman@corigine.com>,
	<aleksander.lobakin@intel.com>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
 <20230613122420.855486-2-piotrx.gardocki@intel.com>
 <c29c346a-9465-c3cc-1045-272c4eb26c65@nvidia.com>
Content-Language: en-US
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <c29c346a-9465-c3cc-1045-272c4eb26c65@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0187.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::17) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|IA1PR11MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ee4387b-508f-4498-fe16-08db71792dbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ftE7wDEr6EzN3W3J9vsr5kY0F9CskkCv51VF0DiM0pFBkHYDkcbtv0b6AJwxKWdJ0soZcD//Q/woO06dow1bNYB3G1bmp066MG+HWzy16ywCugfqLlmRgMaM/FNTkYrA3lwuxHb9xmh35WEk/AL9n9ywHtYvZrxjoNHw+DCfTtmB7Avv5aI+IQJzDYH7H8aIv0JFeGs9rff4LWNIZDSndQpPypY+2hoOp+weK/BrckMZv1nUdB2eHL9xJxMvj398rsJqVDycCzLGMqkHW34MgDcJR18QTZC1dkIzHWUbWrC58Wu8H85uCBMNzRmMyGAxFHZAT8hq+0ugPFBe9HtaD0pDC3TeYVvA1y2eyHqrDrxWd/ys86mtCbCf6jUJpBCXSjbsRRh8D7fkcwP+sSyV9ueNRcFaZTQDH6aSP5Sv4ThiQoyGIddgpZy0zIVONW3zkHBL3JSv8p0x45L6722g/mV5oPm1QYq1wckQ32LMGiuMcaaruJrgoyM3kD2N0FdZduLOApuIwXFTsd38MRy7IPBj20996x275kkwX3e2W4PzzTsVyxskVKF+Qz1OXtG/2A9GRTorAu7yOUTfTrmHWXWp8gAMzpIZE4TeMkuP84WZ+ZQAqHHu2hEe0Qw29k50LR/A2+rmoQcp9MSbEfxntw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199021)(2906002)(82960400001)(478600001)(6666004)(6486002)(38100700002)(316002)(83380400001)(31686004)(31696002)(2616005)(5660300002)(41300700001)(66946007)(66476007)(66556008)(53546011)(6506007)(6512007)(36756003)(26005)(86362001)(8676002)(8936002)(4326008)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2ZxSGhUNjhkUENYRWZuZFBwQlpJL3hXU09YMnRGQWtFUllyNUpNMDRGNHIx?=
 =?utf-8?B?SUs2dlQyeDRFU2djbnV4ODBKTWljd1JxOVc4T1UrdDRDN1hWWnlTemY2V25z?=
 =?utf-8?B?UTh1bEdDN0tjQW0vMmcxZTdBNFpnWFFsOVpwQXVDTndrdnZGNUxLYjk3aGhZ?=
 =?utf-8?B?WFpNcnhuUHl0Uk5oVlpOSzB2aDdpTkFIME51eHJnZ2l1alFHL3AwWTVBaWpu?=
 =?utf-8?B?dVN3ckFMNmsyQzNEZVRHMkZaZGdYYlNtaVU3Q09SaVc4REhTNnd3WmRVbVM1?=
 =?utf-8?B?QUNkTnVKaUxCRXdKbmxGNzA4VHFyWEh1M2N6M2pVT0ZFMVlOdDlyZTlBeHdy?=
 =?utf-8?B?aFZqQ1lpVzdTNHpaSlUwWlJ5ZzVjdGRnejBrNU9qZjJUMTNIay83QUppQVlt?=
 =?utf-8?B?WFJNa3gwK1NJdk01OU9MOHgwWUVjYzl6cFEyb0lsZUo5RDk0QVQrV0hhUHpE?=
 =?utf-8?B?SE0vdkhaNytTdU9EMzRLdGFWazkzM3hrR3JNcGo5RHZsUHVIQjlUSGpNbFg2?=
 =?utf-8?B?SWpnR293YTFxNEdqd0JHN1djT3B6YnptRkxJcmZWN0sva1FaQkdyU2tsN3hX?=
 =?utf-8?B?eVcxOVVzRFM2dlk5KzBTcmltYkRUZGcxWkE0cENDRkRCV1laVGNhTC9NRjRw?=
 =?utf-8?B?U3pwVlVUbzdlRlplYlNqRnYzVmE3MEw4bS9uMjN1TWVZck9DQ25iS3crWFZ1?=
 =?utf-8?B?N1RBd3dQK2lDaVlzVEdvVXRTRFVPTWdkT2s5RUVVZHNZd0VYc3lkUmp3QXJE?=
 =?utf-8?B?QVFvckV6OFVDOFFuVHAzVGVDd2I0RkdsL2hHd0FGTGsweEhXekNrV0VjR0pS?=
 =?utf-8?B?UmFMSTRicUhuWkdHSkwzakdDNzhvSllldFk2L3NxaDJYTHBZQkt2VDlLcmNG?=
 =?utf-8?B?R3VIMVd1YXhaZ0UxTWRUVzJUWllmZnpzVzZHbzNRZEJXRGVBOWo0dHRSTWFa?=
 =?utf-8?B?VkpzOVRKc2dqM0Q3bDZlbzZ5bVFXU3EvYXl3d3BWakZNUlYwblVxYmJQbDZC?=
 =?utf-8?B?dGFLWkx6TDlObCtQWkdzRUV2NTVmdkJ6NkVOTVVWVEhIVWYvZUN0L3gvemFL?=
 =?utf-8?B?R1hSWmZ4Rk5yNE10c1BsTVdSMC81enUzbVpodVBQelhwMHVObyswTWdSWGNU?=
 =?utf-8?B?OERvWUFrMk9UM3h6K3ZuakI1cTBkc0VNTzlTbFRXYVJaUkk5b2JYOEZyb0Ew?=
 =?utf-8?B?ZEFjL3RrcVRDRzhwWWlMOXc0RGRhR3JJRjBuV3JLb0lpWEZLS2JEMHRDV0Nr?=
 =?utf-8?B?V1l1Smdyem96ME5EUDdRQ1dQVjRCZnRTZ2k0cDBOMmJxRHJqZ1NrYTVPUWly?=
 =?utf-8?B?WEEweHFjL3MrVjdlSkM5TEFxaW9EUHBkL05NMEhaU29PUUZZMkVIY2NvcTRI?=
 =?utf-8?B?U05vMUdxMHFBdXI0MnJncXdPdnBLelNzSW1WOWpwMjVCdndEWHlGM29ETlRK?=
 =?utf-8?B?R1ozNzFuTFJRV2JrYXhsc09zRW5HM25sUUx2V29wdmVyQTRGS1dRSTR6a1c0?=
 =?utf-8?B?anZrQlZxWkpYanBPcjk2MzRxVTgyYTdHOVh6QjlMck0yK2t1YWFlUFljSkQv?=
 =?utf-8?B?VzVsTFhzSXBLZHU0MEVJK1RNWU15d3pwQ2ljclpFVjdENS9MUzQrRm4rZUZp?=
 =?utf-8?B?U0RzYjlxT3FUNmFhL0RWaERkQUZtay9NQ1Q4WXN0ZkdJMWI5K2lHSjl3a1Jz?=
 =?utf-8?B?cEs4RjkyakwzUzZQTG1EVC93NkdJT1NyQnVmcFVtWmRidmJweHErUngxL3VP?=
 =?utf-8?B?ZGpSUTA0QWJ6NDc4OXhtbVk2NkhVaG5BWm5ZdFBXUzQ0a1FBMkwyQ3o0Z2xm?=
 =?utf-8?B?SU51WCthU3dZZ0QwZEplMFVRa1B0TjZPYTR1UDgvU0RGTXlHNWRFRTJHYUFL?=
 =?utf-8?B?NFlwWGhCRjVoYS9mWXpqRzFWY3lyRHZZK2FaU3NUVXZJVHd3SE1jTW1DMVVj?=
 =?utf-8?B?VmIzemE4cFpTZ053OExLTDBLaDVrVytzaDgzd1dFVHUwc05hWHFDWGFLZHRm?=
 =?utf-8?B?N0x1ZXFEaGN3Z29Sb1pvL0xuM3YwUHJ1WFdhOC9qdjJTbThpTHlHM1MwNzVn?=
 =?utf-8?B?Mk80bk8yUi9xZm5FL2sxUFpxdlFEMjRsU1NFU2lSQXl6ankrSWc3SFNVRUVK?=
 =?utf-8?B?a0dnczd3VFlQRGp3b1YvYXlTOFI2b2N3N0pUMUdwaWJFNW9kL1M2cVNtU3J2?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee4387b-508f-4498-fe16-08db71792dbf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 10:29:07.8318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tb/eD/7V2wPyfOxzcLlR9RuIE8WcaQtL5NAzxk+C09dD9Ud6GyS4QZWSFOZyRHUp652xt09k0q05vqCZpJw/nZVk0APnWe5GIAcw6F3TEvQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7824
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 20.06.2023 09:16, Gal Pressman wrote:
> On 13/06/2023 15:24, Piotr Gardocki wrote:
>> In some cases it is possible for kernel to come with request
>> to change primary MAC address to the address that is already
>> set on the given interface.
>>
>> This patch adds proper check to return fast from the function
>> in these cases.
>>
>> An example of such case is adding an interface to bonding
>> channel in balance-alb mode:
>> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
>> ip link set bond0 up
>> ifenslave bond0 <eth>
>>
>> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> 
> Hello Piotr,
> 
> I believe this patch has an (unintended?) side effect.
> The early return in dev_set_mac_address() makes it so
> 'dev->addr_assign_type' doesn't get assigned with NET_ADDR_SET, I don't
> think this is the correct behavior.

Hi Gal,

I checked it, you're right. When the addr_assign_type is PERM or RANDOM
and user or some driver sets the same MAC address the type doesn't change
to NET_ADDR_SET. In my testing I didn't notice issues with that, but I'm
sure there are cases I didn't cover. Did you discover any useful cases
that broke after this patch or did you just notice it in code?

The less invasive solution might be to skip only call to ndo_set_mac_address
if the address doesn't change, but call everything else - I suppose the
notifying mechanism would be required if we change addr_assign_type, right?

The patch set was already in v3 and it's applied to netdev next queue.
I'll let maintainers decide how to proceed with it now. I can take care of it,
but need to know whether to submit new patch or send v4.
@Jakub Kicinski, could you please take a look at request and give us some guidance?

