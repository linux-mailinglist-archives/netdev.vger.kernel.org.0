Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB167484C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 01:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjATAuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 19:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjATAuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 19:50:50 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DE42719;
        Thu, 19 Jan 2023 16:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674175847; x=1705711847;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d2eVMIULP2Tu8OaOAJshwlt17MyOZ88L/ItAj6NURcE=;
  b=ZSUf0lDUnoAE7pIKMjwVXZAGKC+ngnBa3GmenDOt/nRWFdOTBPBaoMJr
   EGn/iQweU30ekEPRwT3QDGfxX4y6RhCST4U3Wjull38+JHVk82LVIYmQB
   IFTOj4irn30NexPnVEjHPsQLgOH6+kJr+OYrtqQScu6cnDgR7okIPRq4Z
   5zahz/xhs6VHS8aR3mG8/ETMF/hJ6cRQmOFKgYmRy3eZbAtnpuMfbpHW3
   16ExhzCbMpBcazMX8R9HcWxTApdC8ZWCndRiMsORSdYgxRnj5KBvyoJKN
   vgfIExXW73I5Mj+Kg4vXsPbDNRgcjSxydCETy340ld3pMLsSJtoyMTpPc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="327568716"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="327568716"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 16:50:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="905779547"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="905779547"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jan 2023 16:50:46 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 16:50:45 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 16:50:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 16:50:45 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 16:50:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIs0nHE81p0VZAkYz2KrguLZiF6wYc8enCwEa3mR9x0AZe8XINEToGqj5e2CiR1gUgV8tkT9jRNnFghqLSsCmZGhypEiG280WXhOb5BLjSdzPwZt2z3Fv+B7CMtU+XrXH686sUzBmyMVsbYTQhfQ09GOj23uYEQTg4AZyGa2vqHzPJKFvYxKlx5ssd5nY0OIfFYrtwDCEri5bSPHiPFXp8WJfUTa42AkUb1d1FLXMYOQihCwG0Fi+WoP6MLlNwsQRtj4I8HLF0YkCMUrrg1DKSwE1zfmucdV+VY1Sygn0gjjBlsxS0AuNczZTxJMv5s7j6RSEkCW0cMblbDUkwKGXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pn8h5L+qbbHvwh+V+Jqe1ZQMmDCaZiC/7CVCJeZXNaQ=;
 b=M9X9+FpVcaZiGTFmKouNesN9F3g+yIhSGQknywEcwpbVmySH1KViOZUmTdM5lm2p2YqD7XouoZf6MryhjKq6gzSofPO3CCvkFVBJYm8d7DHIEbO21pFg1rFKOIWnXqnUyBsngYjYIbeWBwo2QdOG5OH1h+WpKiRkuravNMGFtrKBx8ztkU0kM0Owpdkm5aYH7pILgcq7Ex7/Ypd3n8A8V2t9hGxdGZ91p/aVrXogc50pIjIS2xJzHqgr1VxBGs1YKe+QqaLAIEsJBlX6suBUxc5VzUewF0oxX0Z0qTvwld9fyHDEGzUupfVrgepLJxWS67R+1P7AQjXIfDjihwrCiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB6681.namprd11.prod.outlook.com (2603:10b6:510:1c4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 20 Jan
 2023 00:50:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 00:50:43 +0000
Message-ID: <e39be343-95fb-1aa0-f690-a32071a9101d@intel.com>
Date:   Thu, 19 Jan 2023 16:50:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v3 8/8] tools: ynl: add a completely generic
 client
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <robh@kernel.org>,
        <johannes@sipsolutions.net>, <stephen@networkplumber.org>,
        <ecree.xilinx@gmail.com>, <sdf@google.com>, <f.fainelli@gmail.com>,
        <fw@strlen.de>, <linux-doc@vger.kernel.org>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>
References: <20230119003613.111778-1-kuba@kernel.org>
 <20230119003613.111778-9-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230119003613.111778-9-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH8PR11MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: e992cd83-5068-4e18-3b58-08dafa805c12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: un89823gtq72uImTukE+AAgAS0f4IuQOZNfwgkdM/g5xWRBtpwLE7hYt75zcWO+fr42ehaT/jrWF28uafZ8sMxLDDX5cpHNxqnuGECtDe/vdFB+jrKllhcqMxRzN1EsPkFxUd9UvOTBhxB0OOKnIpiKCCm/NoC4tn8K2L8rfVegbbdLT+gv1zTk2K+mkUJuXBon15/BOop6cVMxQVhpZ4KAP1Q1jiVdlXeDnO6DsQ5VZGWEjjcGEg7Dkldf7GCdIzsXWgHz+GAXlh+GQp3GkwCaatpid6F78/Mdl3pjg2BtS+q0TBJbIig8F2xcPc6+E5m+GXT/r3cokssV/RU3zQJvLoM+3Vu8oG+P3+9jP1nAYYghgvX91ZRpDXQQbNSBX5roHIUn/wufGzEa4tnSnrpNGtMtGs2Zk9grnDn/1eS1zt3VSitJVLyrg2UoyRlMGGqtabGwWnAqDWYc4wdTwsFf+yVgY1b1NDNFciI8Q7o/ecFVEVwbQcrCzChAUGk+zT61o0yjjW2SEDdS21Cmlenipbcl+hFEWif8GYF1lesUXRkSoh8E8FvHlSXNiB4SnEyGrc6i+vRNS1qaOmnQijfts5r1ucoldATKVx+DLtp2DyNJDAU6q7aNTs+hcUIdcyRHddHsBDx9yPGziI5u229+IexrJyBsvQAddWcsAHzgAAdkmdn/txpjhDKrVLtQL6BXb0V6AB41imAuvz4O1KtkPaVkY1Uf8RcItx/09uo63cGCE21d3My1lQHUhYr+z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199015)(86362001)(31686004)(83380400001)(186003)(6512007)(6486002)(36756003)(478600001)(31696002)(38100700002)(2616005)(82960400001)(66946007)(6506007)(8936002)(26005)(2906002)(8676002)(66476007)(4326008)(53546011)(316002)(7416002)(5660300002)(41300700001)(66556008)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDl0U0V3MTFKVk1TckhyTjF0YWdDZGIvZkhWalMrUFpIZmdwdk91YlQ5MHJj?=
 =?utf-8?B?aUpuNWN0c2k0cFZKZnRRVWFXbjEzUEhYWFpHZHJhc2RzZEovMG5jYzFvc0Zv?=
 =?utf-8?B?TXkyeTIwNE13d1ErVGdaclJaQ0hNcGtNME8zeEcxRTNNWTBRdk9ONFFQT2Ev?=
 =?utf-8?B?ejJIelpsUlJFOGVJeVdpQzByR2hxNmRIUEg0MmRNckpNUTUxc0pnZUNlVnI0?=
 =?utf-8?B?TVhXd25VSGhLTmtxdDJnNTlhSmpiSjlRTzkwakdVdUc2TTdZcXpGSnJXcUVz?=
 =?utf-8?B?N1N3NTlqZEY1TUlOUFdSOGc4eFE3WFZNYlRNYkkydmR5eWNETk96Wit4ZWZx?=
 =?utf-8?B?c0RiYVJLbDdHWTJXWXh1SFRtaTRNMUtyc0NyckR4cTU2Ykd1M3pqMHc5YVVy?=
 =?utf-8?B?eXBVbURheUk5T0thR2FkOVM1RjZ4ZXlDaXVUM3l4c0pTRkFCRDFoMjJFUi9t?=
 =?utf-8?B?MklhMGxTbVFVUGFUWmFOZ2RLWXJQUXlGMjl2c05vbHBNRmp6S1l4MHUycTRo?=
 =?utf-8?B?NUNEL1FiWHB3RjFyakhBcmtDR3lwUU5PaDNuRitYSVpHaW1adElZbXgzN0N5?=
 =?utf-8?B?SWlpU1FrR3RCRE8wV1ZxZUNTeHRTRlBBWFltZUZ4Y2Q4dFVzYUVzaUF1Z2t4?=
 =?utf-8?B?MUpCYURVWlVKRlpad05ZRThZRG1Sbk8wVEdkT2pjTXU5eU4zMyt1emFjdVp1?=
 =?utf-8?B?R1Fjc0ZpTUR1eFAwbUxPWlZRd3hUUUMrV1NLVGtMQWl0dnBQOTNMSDZuT3JI?=
 =?utf-8?B?WkFoY1QzSXp4TytWTDVxWlBNVEJpdFE3UzR5dnlPdGdHYWVoa0dQNzI3WUZN?=
 =?utf-8?B?U3pXQzIxMzY1dldpVXlBdGFGSlRPZnhoNlBNdzltbXZZczRsYlA0YXMzK2dt?=
 =?utf-8?B?eEkrVjFaMUtKQlB0RjFHZCt3SUdLd0FpQW90QVVCUks5MVptckkyT1ovdVp3?=
 =?utf-8?B?ZnRKdlVxRlNKd0NZN0JaRVgxMlU2RmRraEM0QWp3YnRBa1U1YlRURUFTTU9R?=
 =?utf-8?B?bHoxMjBFN0FHSzl4V0dNVTRXR0tUVFZISVVZanlsK2Q0WUd1Y3gzaG5XVm0x?=
 =?utf-8?B?Z0FIdXkyUU8vd0pGT3pFZEh0WGFUODRRT3hnUTBDeHlVSUtFTmN5S0ttZWFJ?=
 =?utf-8?B?ZDd0V1RqbWJOeUJVa2FPbUxHZWcrM1o1ZnhQYzFuZ3NIYXQzTllzcmo2UWZ2?=
 =?utf-8?B?QW1mTlFjbDFkcjdYZXVURkhoUCtwdjV1QTBsL1B1Y0IwT3dWaFc1SW4xbFEy?=
 =?utf-8?B?eG4rYk1YalNqb1hrajRXdjlUUFFiOEoxMy9XcEl5L1E4b0pBS1REMVV1N1FU?=
 =?utf-8?B?Y0l2ZDhJUzJxSnVzVjV4cmEzck1mNjNFbkM5NkdOQzQxRCthdHRKOGlsOG1i?=
 =?utf-8?B?WlpQVUNYdTExWmpDRmJyQSsvczYyU0pvVFF1S0t5bG5XWHpSNzRXbnVEOTlE?=
 =?utf-8?B?aVY0Q3FheUsvVC8zazEvbjZTb2c5a3pqMXVINUdSWGdVa2FxNXg2b29qQk1n?=
 =?utf-8?B?bVYvRHlFNFpoemMwbThvcWlxRlU2T0hSVHpkbGt3SGJKUGtXQW5tbmJLWGtI?=
 =?utf-8?B?a2h3S2tQVnZMS1VySnA5NS9QSGZobnlSS053YjduVUdVRHJHd0N4ODVvZ0o2?=
 =?utf-8?B?SXhDcUZoYzRnTXg1UXVlUFA1Mm1QTHI3dVAxenBYMjdXVmp6YnB3bkJjKzVK?=
 =?utf-8?B?bXY0OE9ZMnJUY29TRmhNRXZ5NE5jVWZuWTFxSU1QY2VTR1pKS20yM0pxRHdy?=
 =?utf-8?B?clg0Q1RaZXRyT2ZmWG91M2JrSW00RW91dlZHR1BvZ0xEaFlXOTN0VGtXWVhp?=
 =?utf-8?B?U0M0eVFMZjZQckZEMzd5a09JMGg3U0JBMk5OSHdkbjlzK0hkdVNWVysvSzVV?=
 =?utf-8?B?WFU2QmV1Um9oL0pLcEpjdHdvakdVcnRheE4zbWNoR1RHdWpHRFkzbHJwK2tN?=
 =?utf-8?B?UnNtU09YelQ5ZTcraUhLOWI2bHRKK2JGSzZJaGQ2T2pwenVwOTA3VnZTMGFR?=
 =?utf-8?B?Qk9XRXdUZXVHN3djQTZzdDJYd3g2bWhOalBmRldydkZKZ2l1YjIvTHdJMlhW?=
 =?utf-8?B?ZE9FcFUzMkcwanRId01SNGhFeGt6dHc5cDNmdkRkRnJ6RitOM0Q3aVdaZ09P?=
 =?utf-8?B?U3Jtb0N2UmxMaHBrOThLVHNOOEJXVUxET3V4V3ByR0NtcmJQRFRuOFVON3R5?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e992cd83-5068-4e18-3b58-08dafa805c12
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 00:50:43.5365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OplxDg1M5wyKW2iwBhwdbBy1tl6BMRV8G7OjZgSU2uF+E2FV5PUFuyKrU40dm51r4LpL7mxS+T4PWhS1kvWyLKlcsbYj530wdWbHP120Ogo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6681
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



On 1/18/2023 4:36 PM, Jakub Kicinski wrote:
> Add a CLI sample which can take in arbitrary request
> in JSON format, convert it to Netlink and do the inverse
> for output.
> 
> It's meant as a development tool primarily and perhaps
> for selftests which need to tickle netlink in a special way.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  tools/net/ynl/samples/cli.py |  47 +++
>  tools/net/ynl/samples/ynl.py | 534 +++++++++++++++++++++++++++++++++++
>  2 files changed, 581 insertions(+)
>  create mode 100755 tools/net/ynl/samples/cli.py
>  create mode 100644 tools/net/ynl/samples/ynl.py
> 
> diff --git a/tools/net/ynl/samples/cli.py b/tools/net/ynl/samples/cli.py
> new file mode 100755
> index 000000000000..b27159c70710
> --- /dev/null
> +++ b/tools/net/ynl/samples/cli.py
> @@ -0,0 +1,47 @@
> +#!/usr/bin/env python
> +# SPDX-License-Identifier: BSD-3-Clause
> +
> +import argparse
> +import json
> +import pprint
> +import time
> +
> +from ynl import YnlFamily
> +
> +
> +def main():
> +    parser = argparse.ArgumentParser(description='YNL CLI sample')
> +    parser.add_argument('--spec', dest='spec', type=str, required=True)
> +    parser.add_argument('--schema', dest='schema', type=str)
> +    parser.add_argument('--json', dest='json_text', type=str)
> +    parser.add_argument('--do', dest='do', type=str)
> +    parser.add_argument('--dump', dest='dump', type=str)
> +    parser.add_argument('--sleep', dest='sleep', type=int)
> +    parser.add_argument('--subscribe', dest='ntf', type=str)
> +    args = parser.parse_args()
> +
> +    attrs = {}
> +    if args.json_text:
> +        attrs = json.loads(args.json_text)
> +
> +    ynl = YnlFamily(args.spec, args.schema)
> +
> +    if args.ntf:
> +        ynl.ntf_subscribe(args.ntf)
> +
> +    if args.sleep:
> +        time.sleep(args.sleep)
> +
> +    if args.do or args.dump:
> +        method = getattr(ynl, args.do if args.do else args.dump)
> +
> +        reply = method(attrs, dump=bool(args.dump))
> +        pprint.PrettyPrinter().pprint(reply)
> +
> +    if args.ntf:
> +        ynl.check_ntf()
> +        pprint.PrettyPrinter().pprint(ynl.async_msg_queue)
> +
> +
> +if __name__ == "__main__":
> +    main()
> diff --git a/tools/net/ynl/samples/ynl.py b/tools/net/ynl/samples/ynl.py
> new file mode 100644
> index 000000000000..b71523d71d46
> --- /dev/null
> +++ b/tools/net/ynl/samples/ynl.py
> @@ -0,0 +1,534 @@
> +# SPDX-License-Identifier: BSD-3-Clause
> +
> +import functools
> +import jsonschema
> +import os
> +import random
> +import socket
> +import struct
> +import yaml
> +
> +#
> +# Generic Netlink code which should really be in some library, but I can't quickly find one.
> +#
> +

There is pyroute2, but it might be overkill, and I recall it seeming to
do some things a bit inconsistently.
