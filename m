Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0956688161
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbjBBPNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjBBPNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:13:05 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADB436095;
        Thu,  2 Feb 2023 07:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675350764; x=1706886764;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eI91IWvJ/L7pMs6iXI2iXoBP+JvX3xxdqyq/5u5yVZU=;
  b=QdPdTNlzqPyqJFAL4Gddx5lK9zvtuprYcN5LdBCEIgHqmmECBa43KWXD
   xzBAr1vMif6mqexohcVpDMEAfR4UKOZr6LWXSj2ItwDmUsY0NEvM/03w7
   yDByHN7hg9jzgI/4VgEALl4wsQmqbcS7p5qfftNssbxaXW6gZP7RStL01
   J9FuQANgog4LY6Jni+39Pf+RTc2lDPYbqDemZ5yGghyRfhmQIXf3BpES3
   wKRVuV8d4l9evkrDqgdYgky86CbNgvNWNW6zV9BE0/nULIQihYMiUTCNl
   wVOd4C5f41HQ4wnNpm+7RMZ0kcKFiJoVcmZYebOrJFzP5dLVM1kHCvwKG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="393049643"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="393049643"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 07:08:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="667313650"
X-IronPort-AV: E=Sophos;i="5.97,267,1669104000"; 
   d="scan'208";a="667313650"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 02 Feb 2023 07:08:23 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 07:08:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 07:08:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 07:08:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 07:08:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bkmyp4vB53NvEUu8qKEQUhUmnq/M22zmetjuWQkHBRoxoLeY7QOw2fCoCSqy91hR8nCzhkn0X1/K98rDgavtBCtYGHjGsLGnldJIF8MGywovW5DGqF+fnACqP4lebKVr1ZpvaBvSsXQ4PVqw+8rUMZPKLoIz4eSMxaRwVbHCv3avNaX/ykfxIN5wSY+dH/Sha2tIXAoBKPP50M7Mfax4jvziZzE4qcTKEkzSTLsuEBQs/5hfY6VWTX00sJPWJxzaamt1/cfnFXEuiKbQ/NcqRYv5Hxdsk7sxrPx7Z45bkUfiSylx80RIwrJnS1a2SG0ttyFSPyk2BJSXEzx7HIR4nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uD0IvbEifU7aGXRP8KZKzhyw6684gK3reaB9OMR4VZY=;
 b=jY7hoqLhcouzp2RjySc1+LFCk4CDZA+8T6ufsfgwyTCsyHVa6uBAxutkjTGSSjZlmH43ZwDT2CUt6xOH6ea4xH1H7nRVj4A+/k8LtmJBmcFOgODEocwbTyZN/Ym8SW+cdC43oLR5+9zjxZKcbzqO3lBS5Gm2bOD7V+4bd/NQfrx58P7u9PXci6KVFCf64qJMh4y5FMnSBhuI4nVdvwtQzd01B788itWqLH+NnhtPBZHbdqvy7ruhxZlDbsXmgQFDA3/EBKbiJ+SEbLkDwy6ZACRCItWrGqCMQ2sVb2tTwvqToI5a7DcAXJtnetn1beywfrYUIH8uIk5s58BZORWPMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS7PR11MB6223.namprd11.prod.outlook.com (2603:10b6:8:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 15:08:19 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 15:08:19 +0000
Message-ID: <8627b210-315d-45c1-5638-258a74ed8f7d@intel.com>
Date:   Thu, 2 Feb 2023 16:08:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v8 00/17] xdp: hints via kfuncs
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <brouer@redhat.com>, Martin KaFai Lau <martin.lau@linux.dev>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <haoluo@google.com>, <jolsa@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        "Magnus Karlsson" <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        <xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20230119221536.3349901-1-sdf@google.com>
 <901e1a7a-bb86-8d62-4bd7-512a1257d3b0@linux.dev>
 <CAKH8qBs=1NgpJBNwJg7dZQnSAAGpH4vJj0+=LNWuQamGFerfZw@mail.gmail.com>
 <5b757a2a-86a7-346c-4493-9ab903de19e4@intel.com> <87lelsp2yl.fsf@toke.dk>
 <da633a14-0d0e-0be3-6291-92313ab1550d@redhat.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <da633a14-0d0e-0be3-6291-92313ab1550d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:93::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS7PR11MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: 46171085-8f82-4720-fead-08db052f50f7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oJWE7irZgmY9id6H9e0dub6FTeAYqsXSCCkmq2euHqifDXz0zt0kRCbM9du51I2nfxezWqHWzkIpIFGebazaqAfc3OW58ou2xOUnnbdqQmW5bOR9ltkcY6pT10PqFk5g6sZ31N3FSjRd0bbCvrOSCxRcaWzZqOkkpcAEMnk1Nq52nL/aRtquHS+/gnCsYRhIw42XHSYoEPd1Gp18/iWQHpuKKWg0byGE65dhFVx2Bgz67yQRQMYgJazt1E87ONxmikLbTFEYwWZwZyic1CyQqZVpOVOuDPNqEIbAoOj1mZ2xZcwRODbvDwjTHLQvyYinB/bNhDW6Rc/W9M2KqcnhgOG3SS/ruQxCGuHcQ6eM8G7OShtUADJYBxa+Ypn3a2O6R9WhRge+g93KApRdD8hhtmOc5j918X3FMJIDPltXWSQ0iiP6RoNz4uCbJu01Xh99hnSiBp1U0g12VajQXqt2OWmsPPgfzrski2aIs5Frh9Iv3xyL+UdnwJFxv8wheS5DphJLnbePmXFwEN4uZfUVuZ7e2S1HPTup14pui9+KZAFL0ToSi9bGOXVOo/2X8teXEIkSSpInlruN+hTefNnwBvBjnTDM7UBkS6HbsNVDgFkaDYyBNULTWZuJQbahzHdCZ+cXUH7Unw6IeEa4G3QobG3jcqDy8QXUfi6JBLberchjuldgIc4CGF6mIhxVLVhOaHdUx3/XZjHidiQ3wWAQ1spRIS6FMYfOI8fX6MwvIS+FiMx1kR1OKXZA+OzRs6EhIbX/hYfdC1OLfWo3JRKheIDQEPs897a4mtSaOsHDrl96fNBEzsoFmG7g1+qaOjqg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199018)(36756003)(4326008)(6916009)(31696002)(7416002)(41300700001)(66946007)(66556008)(6512007)(5660300002)(6666004)(8676002)(26005)(107886003)(54906003)(53546011)(186003)(2616005)(66476007)(6506007)(966005)(6486002)(478600001)(316002)(83380400001)(38100700002)(2906002)(82960400001)(86362001)(66574015)(66899018)(8936002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjQ4cEtwRW5QRGJTMjdFQ0JEMFd1UmpydFI1aHlEQStndmRNRGFGUk1FNW5I?=
 =?utf-8?B?bjBrMEhvK1Znb084QTVUeCtwdCtKS3lLZUE4dWVHU2tjUmE0MldQWU4rVWp6?=
 =?utf-8?B?TU43RHZBeWRqNGRtaHFzMnJZeDRWajFBdmR2Uk51dkpsME5yUzZnQWNYNVlE?=
 =?utf-8?B?dzdBOGwxSnd5YXpVdGtQWVVtTW9zbFZoaDlaUFNhbmJYM2JjSnRLbWNKSEpT?=
 =?utf-8?B?Tjd6ZVR2U0d2NE4xcEQrM0grUUJVZzAxaWQ0Q1FmVStUSkZvcUdZTFVHcm5G?=
 =?utf-8?B?dk5rVGZyR3lLWk5mTzhBQTBTcnVUZFB2N3hhekRiNWk5c2ViZG9QRGdVM0hi?=
 =?utf-8?B?aFRMMDlnSTVsYkZOb1RqMWFNQ2t4dXlyRGxBSnEyT0hQRWJneWZ4ZWpUZ2xu?=
 =?utf-8?B?VDZJajduaXF1TXhIYVM2djArNHVYTDI0dFVQVVI5M0ovb2NvdFlyOWV4aXh3?=
 =?utf-8?B?a3NBeXpYNzBhRUtEcklEL2VWTEQ3Ylk1Um5vaDlFRm45Vmc3U3JybHZkbWFH?=
 =?utf-8?B?YW9CYWtUWitxYXpzL1g0TXhoNHhLWDMyeFczTXNWQ056V0I2UEJPY29oK2x3?=
 =?utf-8?B?M0orNVpuNmFoNVYwaUVxWVV4bXVhZlVzUi9wNUk2N25wUnlDTkJLa3ZlM1RH?=
 =?utf-8?B?MjQ5ZkJDRHliWlNFdHFIZkZNRE4xalROOGlhc2tnVUNKUFRuZW5LbGhyZTla?=
 =?utf-8?B?Rlc1LzhyeXVTZHdtQ2o4ek96amtsTlIxaitpRTRFQlpPNHg3S2hhRmxMNWxv?=
 =?utf-8?B?b3dFUzBOZEljRkNuYy91S0ZQMFlsMUpSWUpiTmoyMlo5dzRlOCtuS08ycVpT?=
 =?utf-8?B?MjYraUVGNVBFR2RLN0NuWkVDSGZqS2N0SjdvdjBFSVBwak15cC9DMjdsZndG?=
 =?utf-8?B?TW1KQWpMMHhZZnFIRTdwTU5RdkZBVTNhT0RDQ09QN3NOTEQzNlNqZFJ5ME5a?=
 =?utf-8?B?YmErSVdwOU5ob09XM2Y5WjF5ZmpEUGtZUHphTFNSL212cGV3MXk4V2hYOWRT?=
 =?utf-8?B?TzV6SVhoazhJTU5JZHRRZ29rOEJnaHlkM1hkcjIybDNDWEVDY082SXcyOUpt?=
 =?utf-8?B?bnl2MnBEU1ZWS0wvRGtNWjRrVlJ1RmwwcUdBd1NaNHJQd0xWTFExN0s3c1hJ?=
 =?utf-8?B?dWVjVXd1YkhXVXBYelMzTXhIdEZRQzlXVzJsOXZ2dXdpaVJPcGpuOFJGa245?=
 =?utf-8?B?VmticWFkZGNOZEdaVzR3azJZbEI3MjZ1UTIvbWFkckZxNUJ4d3BRV25IWU12?=
 =?utf-8?B?cWhwZmJuQW1yQzloNmdDRlM5akluUC9XRkFPaEUvcS9QeUxzcHVlTXhvY1ZR?=
 =?utf-8?B?MGl4dFhqUTQzYWlwL1l1QzIvcG9Ka2JndjRlelI1MnM4b1I2cG15Umk0RnAx?=
 =?utf-8?B?SmRiTWhnN2ZueC9RRWd4ZzE5dk5oRnBPUU83UEJMVEhhdTNHZXpGZGFnTitW?=
 =?utf-8?B?WTRzaEhRbHpHck9jTTVtaGo3R2pkVnRpaFAwUzF4Y3krUmJCNS9OajNzOFpV?=
 =?utf-8?B?aDBXaHZacFFzOWFvMUdVa1JPZUlPOGJhS05FdzNFN0orcDE5akNERjlUNkJ0?=
 =?utf-8?B?REhyRVdMeHNMeWVoQU84Mk42RlZ6ZVBGd0V5dWRrMVQ2SGQxOEp0bnJhS240?=
 =?utf-8?B?WUVjY2xMcEc4bjdBOUtET0FKRTVVZXBFWTY0eEFMUUVWZ0FZdGVGa21JL0Fl?=
 =?utf-8?B?b3FWQW9md1pZS0NkbFE3OGgrRVIzN2ltS2c5VlpBenRsV0QwbEYzcWhrV25k?=
 =?utf-8?B?VDRPVDVkTzlackhFb2VPTXYxdDM0V3piNUJWTzdjbDZmOUY0eHQyUy9GaVJS?=
 =?utf-8?B?ZGdUelB4WWxrTGhlY0dEd3U0NllOck9jQlJ3QlZCMVFGb2pFdGplWFRjbVFY?=
 =?utf-8?B?N25GZjNld21CdmFTMFljbGI4SkpZWTdNVngybCt2anRncUlpbGpDMDBlTnlJ?=
 =?utf-8?B?WElKYXB3S2JKSk4yYTZjWk1qNUh1WXk2QytxM3RrMUdtWWs3dysrb1I0dC8y?=
 =?utf-8?B?S2ZYVE1HUW83TkNkUDVNWHZpeXdEemo1NHlsVHpXL1VodUp4a1VHQlVFRDdN?=
 =?utf-8?B?MTdXaWtwMHYxQ3JRV0RtWWVUVHNzdlhsSlRHcG1Ga1NiMi9OVnlzNTFEMlNy?=
 =?utf-8?B?WEZWOHI1eDJiR3V2NzJhNmF4RG1lUXJQTzErNFNjUHZ3TGdLYVlBOHJzVU95?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46171085-8f82-4720-fead-08db052f50f7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 15:08:18.7775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p22aUSrVUBfFO+crhTWpyouDjkqDS3NHIH0D3Z8T+0dAH8W8pL1Rniq31Jsfd4mYzSyTUHo/3s33kK6GFNxrMVWVH+DFTjmy8Y7Xtn90Tf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6223
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Tue, 24 Jan 2023 13:23:49 +0100

> 
> On 24/01/2023 12.49, Toke Høiland-Jørgensen wrote:
>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
>>
>>> From: Stanislav Fomichev <sdf@google.com>
>>> Date: Mon, 23 Jan 2023 10:55:52 -0800
>>>
>>>> On Mon, Jan 23, 2023 at 10:53 AM Martin KaFai Lau
>>>> <martin.lau@linux.dev> wrote:
>>>>>
>>>>> On 1/19/23 2:15 PM, Stanislav Fomichev wrote:
>>>>>> Please see the first patch in the series for the overall
>>>>>> design and use-cases.
>>>>>>
>>>>>> See the following email from Toke for the per-packet metadata
>>>>>> overhead:
>>>>>> https://lore.kernel.org/bpf/20221206024554.3826186-1-sdf@google.com/T/#m49d48ea08d525ec88360c7d14c4d34fb0e45e798
>>>>>>
>>>>>> Recent changes:
>>>>>> - Keep new functions in en/xdp.c, do 'extern
>>>>>> mlx5_xdp_metadata_ops' (Tariq)
>>>>>>
>>>>>> - Remove mxbuf pointer and use xsk_buff_to_mxbuf (Tariq)
>>>>>>
>>>>>> - Clarify xdp_buff vs 'XDP frame' (Jesper)
>>>>>>
>>>>>> - Explicitly mention that AF_XDP RX descriptor lacks metadata size
>>>>>> (Jesper)
>>>>>>
>>>>>> - Drop libbpf_flags/xdp_flags from selftests and use ifindex instead
>>>>>>     of ifname (due to recent xsk.h refactoring)
>>>>>
>>>>> Applied with the minor changes in the selftests discussed in patch
>>>>> 11 and 17.
>>>>> Thanks!
>>>>
>>>> Awesome, thanks! I was gonna resend around Wed, but thank you for
>>>> taking care of that!
>>> Great stuff, congrats! :)
>>
>> Yeah! Thanks for carrying this forward, Stanislav! :)
> 
> +1000 -- great work everybody! :-)
> 
> To Alexander (Cc Jesse and Tony), do you think someone from Intel could
> look at extending drivers:
> 
>  drivers/net/ethernet/intel/igb/ - chip i210
>  drivers/net/ethernet/intel/igc/ - chip i225
>  drivers/net/ethernet/stmicro/stmmac - for CPU integrated LAN ports

Sorry, just noticed :s

I work with ice only, but seems like the responsible teams started some
work already. At least for i225. They may write some follow-ups soon.

> 
> We have a customer that have been eager to get hardware RX-timestamping
> for their AF_XDP use-case (PoC code[1] use software timestamping via
> bpf_ktime_get_ns() today).  Getting driver support will qualify this
> hardware as part of their HW solution.
> 
> --Jesper
> [1]
> https://github.com/xdp-project/bpf-examples/blob/master/AF_XDP-interaction/af_xdp_kern.c#L77
>

Thanks,
Olek
