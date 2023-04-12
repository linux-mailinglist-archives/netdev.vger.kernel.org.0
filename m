Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038366E0263
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjDLXQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDLXQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:16:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB688E;
        Wed, 12 Apr 2023 16:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681341383; x=1712877383;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hOSptsDpQUD5mhUCW8WM7lOJabykK7zsL2br19w7/Gs=;
  b=YTRQ222K/qWV/AJmb9AlHmVyrHqKNZoGuUr8jObI+tXFa5u5IojG//nt
   3Pt3ffk/M3mwYZ3Zmj6zvQaGirzpUvsHUb3udlQvoz53F+Sol3/f2KmWV
   2dc97jMElKATjM6Xmo25GIxWJQLdkvO/u04WuLDUj5jtDFd1nAL3+9nBc
   vftwAwEa6I+aMCNVwk9VT4YRh1NTq2Sa4FdYPYRCIz2KE1/AExLnp107d
   ++m+3AsDTFMUlNk6/MY8v95vM/uge/kvKn5jiwc5DY8H3v4oZUnOqOJ8Z
   nceAeadnMTGcEj4z/FBkLH8RvIScQiUu/VfiZOWbRho/hh7GmazAirCZN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="344043290"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="344043290"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 16:16:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="721765427"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="721765427"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2023 16:16:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:16:22 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:16:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 16:16:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 16:16:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBQXJ+DTeV+98mmEmBIFvWBKH8DB6D+/jvP9N92hQLN3xBmp/vj7GeY9JjODMj75Y6ku7UPKn8lMpryWgPV20RFv0pfjyOHIqOwkodWFBi+PrI5Jsnb/VHgHsGjr+fQp5kY5/6jEsyr0ha7IjJkMxxgyhSQAr1154OnzodU8B/SqaZnPL8yAs2UJNLlOXn+8aH7O31hu0OMDzPkd3RqkYM1PIKRYTI2jrdniGFLPS7ioX50mcW9cJwxdAJ3L1j+cGxTy/mWupauy22zeN9M2xMoSntFMY0Qlm2XZfNbPZTHhuZ2TlN3qDsBpQrVVr2fq+7OCtXydZRQBl12tunH0fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lamxFQQ6yD4IJrGiBkVHPF+zM4SezZK2qQQcS3PsCcU=;
 b=jEHc36qw1+kGYZrineHgKmGt7vf00G5atFgzAzOdRIUlxD7ax+Ywy1Oc0jxKH4q2bwzWCXMqU8MCFDY3DCbspSFeFarboI3+blvZitNfNFMqvaQeVRnZElvTINSyEoMEwNThrUQF5lpbC4FnCknU+RSSUFfvRk53W2pe2S1X8sj++QgeP7N30zmOWRhtFYa3uhr4z28rX7rWN0GZvdHl97SZJlstAJSQKp+ZhP3RJxXe+UL3PVnwH5NXk8HoJ/jrLU+PYOp0xGiIBu8oPczOrwA30Eex2SOHpynXOxbB+6x4+qGPsbkk2UOxbNAVB9jnV8y4NAhYqS1t0scjL25ROg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6064.namprd11.prod.outlook.com (2603:10b6:8:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 23:16:11 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 23:16:11 +0000
Message-ID: <ce194914-f4be-5aee-90f1-7a652c7fa8b0@intel.com>
Date:   Wed, 12 Apr 2023 16:16:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next Patch v7 6/6] docs: octeontx2: Add Documentation for
 QOS
Content-Language: en-US
To:     Hariprasad Kelam <hkelam@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
References: <20230410072910.5632-1-hkelam@marvell.com>
 <20230410072910.5632-7-hkelam@marvell.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230410072910.5632-7-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:a03:60::49) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6064:EE_
X-MS-Office365-Filtering-Correlation-Id: 88f4bd24-d213-4083-dd25-08db3babe76c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CGiUsuPVs6marZP8gBU0FkTIZ99kzLcAU7miInuNjg4Y+O2dvu/I7ijXBuEW4agDEONeOjHNntu8vUgmjhPQK3dmjKPwOAZFnzmceMxWfNcFHzYpJ9yG5V+r6pLPSvy0yGYYIQmjScLtfQYHEOCwI9GVbIDRs3uTTc2qNM+HiP4AEVd0L27jag2qturHJe2WIecXUxNbRYoJp5uFX3ze3KyTguR6QzYM4TXJ5qSKPL+Plfh/JVYPfFIOBSS2PKMuTpArmWA4Ppjq2Dd7C/6/5vLG66BGSoXFfvcwnUt3lLjbeywHJAodHiRI5MIJSTN+GjxC1M/lHQSMGgcuOi6w4QJ2h8Yy+hMQTfMRPMPogFFnAHQ6H6eEuLFYMCKa7CWfTgZ8UZ81H4HwgZYE4ZXxw7hwWabSqz0bTIhbURRzmWnYvihNyQTucXFTHkvpnY7AmEjWJ25IVns/tTZQVwznbBy8e0/q22vgSNXZaWVDOrJnmy9NIyYULIQ1HkYXZr6OIteCLfI8DtWtx8sEl6MSU5ArG1eHZflp7FxJD24nZaFVrgCddnKqnIZELiUAEgf/29/4zHiP7G8Rf+ZkMbIlTe305YhL+XlRgw2O6jC0ZelNY2KKj+iJhJ4fNu1F2bmxbXQcdpeES7q2c8rTHN2MA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199021)(26005)(31686004)(66556008)(66476007)(53546011)(6506007)(36756003)(6512007)(31696002)(2906002)(83380400001)(6486002)(2616005)(186003)(66946007)(4326008)(7416002)(86362001)(5660300002)(8676002)(8936002)(38100700002)(478600001)(41300700001)(316002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2EwQ3FNUnc2eU95amlsT0U2bnU5WjJpVVVRc29rTFlwak9pUWZhMjhzYkhh?=
 =?utf-8?B?MkplVFhiRDVIMFlpcGxSaHpzbVZucm9XYlM2eHFoQkZhZUpUM3FHaTRzcU1Y?=
 =?utf-8?B?T3NTcElOTUQ1c3Y4cnNMV29Kc1lKcE5nbUFybE5reG5qM3pLQ1FxZG0wbFpS?=
 =?utf-8?B?NEI5VmNBTlQrajRsdlBRSldNUnlTUC9VSUZQbVp1RnRFK1lHYlJ1ZjFkWEFY?=
 =?utf-8?B?L21ES3FUTUp4eFB3aExoa055ZnAwd3haOHp0eWZhUVV0Sm1tQzRoMjF1QXc5?=
 =?utf-8?B?MlNCMlRYRzRHeW43YjVPdWo0ck5NTFUrM0VnNDNjSVFIRkxSRkgrQ2hSSXVa?=
 =?utf-8?B?YmkyTUd1a2djM1pWeW9TMHJYSjRIb1NGbUpTSTZ4MXpKa2FBNndEUWU3dTNj?=
 =?utf-8?B?SjFFRzNkNzJkMVI4dzQvUXJnUG50MnZjSkhPN3lyQnNpU2pHYVpJdTI3bVYw?=
 =?utf-8?B?ZVVNWFBhNVFPRUJ0OEl2WW84YUNSanVUTzIyRTc2VitPbS9LKzFGOThhNytJ?=
 =?utf-8?B?emVRZnVrM043bmxMUUhrYVhTekN1WjR1RHBmalp2MzJ2RTFYa2hRcjRrNWtI?=
 =?utf-8?B?bmNoUzgzdHhZaXJmNmlZcmg1T0NnN2NZSWRiSXVLSndjelhWN2tmL2ppMGZl?=
 =?utf-8?B?bWJPWGQ5RGIvZjJ1TjY5L0VaNHZyeS9kMkVYUjFvVjMrUVJmb2FNRTFiN0NL?=
 =?utf-8?B?Z2R6cExrMVMwQndJbUgrWWpKQllNWFdZaDJhQVJFK2hhT0ExQmQ1OExqRTRZ?=
 =?utf-8?B?TktWdGRrQVBWdjBKbHVmMzdZRGw1MnI2V1RuS3RXTHhNTGorWkhxTW1BbHlP?=
 =?utf-8?B?clJ0alJCY2E0MldtNURUWmZERGlZZmEzWVkzL1dhUjJoTk4rRzhDejUyb1BX?=
 =?utf-8?B?citidWhvOFY4RWppRUQvZkt1OXk4aFZabGxvNVN2T2gxREJSR0tndlRKd2Jv?=
 =?utf-8?B?LzBYTkN6MEZVRVlnZWJBVzRyZ3lxMkIvcWFEN0p6WU9VTGUwNDVaRTZQRUwz?=
 =?utf-8?B?VjFWS0RqcFdvUllkWlN6Uk8rTWw2bUtmRlNTTG56THE2RG9hN055SjZHa21s?=
 =?utf-8?B?U05COGtKNDJNVEo2OG5TcHVuS3FTcDlmWkhwbE4wcm9ld2tRUXBhc01nekhM?=
 =?utf-8?B?QVFjOGJDS2hzYk5nSUc1c2lOT21KS3czNndUYys5U2xTNkZXdVZMY1ZwdEVS?=
 =?utf-8?B?KzVvRWhCUWZtaFFFVllxcnRXLytzaGc1ekNqT0RtWUZsZGV0dnBXanBuUnhz?=
 =?utf-8?B?cEVWTFNpRDlSM2xZMzB0enQwVnJVYitvczlpSmY3VnN2UXFwUS9Pemx4YnVH?=
 =?utf-8?B?RENUYWRMcWU5bmNCSC85d2l6TTV3Z0lRaVd6SlZMa0VpK2RLdG5HckdaT01L?=
 =?utf-8?B?MTl3SFhJY0kvWHFPdElwYmpJS0RST0w5cUt3eWZZYlZxakw0cmtxd1pPTWRu?=
 =?utf-8?B?Mlc0eDhBemtjTjVmTjllamYzclNKYVFmU2cxQW5UMHhNSWNNWlBQL2puNURP?=
 =?utf-8?B?RXk2UFloanBiNUFvbVZvbWpPUERZV3ZYLzVIMS9vcXZ6V09JSmR4UHVvU2FX?=
 =?utf-8?B?T3pRK0o0ZjRiVUJ1MW1sOUowRjk2bUdUeXJzZ09wSDBSQlRZZnk2QWZqY2xj?=
 =?utf-8?B?dm5NeGVIS2Frd2pvZVpNSnF1WDBaRnZoQmphSlFBc1ZGV2JwY3NUS0x6TDNI?=
 =?utf-8?B?dlZ1QStPNlFrbHBNVDFvY0pCTG1WUksvMGVSSjZyV2l2cmlHSW5ES2NWdzUx?=
 =?utf-8?B?VGt0WWUrSFVCME81SUxSUzdIZTJlTXVqSElXL0Y0aW53a3FuNy9zWktJSnR3?=
 =?utf-8?B?ejJVajM0QXZ3S1UwQm1yL3d0N2F1UVJOVmovUjNVY2dkemhvRmhRQVc4Rnlj?=
 =?utf-8?B?MzdtaW95SzVUcGZ0b1ZUaXlxd2pCWnZnQXNQY3drcXRBTU9BN3FXWmJlUGUy?=
 =?utf-8?B?b0w5VkovT0ZjY3BRTHhtYnJGNlkzdVpnaU1xaldZR3VhV2RyZ1d1UG4rN25L?=
 =?utf-8?B?aEtJbjVtcHNDTHk2M1lwNjQ4TVdrL0hpOUdRM1pEMmdlcWkwM3I2bWo1Z2Fx?=
 =?utf-8?B?VjVXQWtHNE5pTXBKZ3lUdGtDK2drK1hNYmJuZXh4eXVBNDZrZlJKQ2o4c1M4?=
 =?utf-8?B?OVgwelhtMlZTT3FsR3VtRzF2S2NxcGw1ZExkWlFla0MzSWt6ZGc0S2l1UlpN?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f4bd24-d213-4083-dd25-08db3babe76c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 23:16:11.3363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bUCILDqsNGivhc5bVGLk2Lfm+jO2UZxsblPUFppQohC1bT2CBhJxE2+UMUN1o3zQ5479JJukUMC1+fY2HC07wevs6m/fZ+yCcNtWJcUyKQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6064
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 12:29 AM, Hariprasad Kelam wrote:
> Add QOS example configuration along with tc-htb commands
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
>  .../ethernet/marvell/octeontx2.rst            | 39 +++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> index 5ba9015336e2..eca4309964c8 100644
> --- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> +++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
> @@ -13,6 +13,7 @@ Contents
>  - `Drivers`_
>  - `Basic packet flow`_
>  - `Devlink health reporters`_
> +- `Quality of service`_
>  
>  Overview
>  ========
> @@ -287,3 +288,41 @@ For example::
>  	 NIX_AF_ERR:
>  	        NIX Error Interrupt Reg : 64
>  	        Rx on unmapped PF_FUNC
> +
> +
> +Quality of service
> +==================
> +
> +octeontx2 silicon and CN10K transmit interface consists of five transmit levels starting from SMQ/MDQ, TL4 to TL1.
> +The hardware uses the below algorithms depending on the priority of scheduler queues
> +
> +1. Strict Priority
> +
> +      -  Once packets are submitted to MDQ, hardware picks all active MDQs having different priority
> +         using strict priority.
> +
> +2. Round Robin
> +
> +      - Active MDQs having the same priority level are chosen using round robin.
> +
> +3. Each packet will traverse MDQ, TL4 to TL1 levels. Each level contains an array of queues to support scheduling and
> +   shaping.
> +
> +4. once the user creates tc classes with different priority
> +
> +   -  Driver configures schedulers allocated to the class with specified priority along with rate-limiting configuration.
> +
> +5. Enable HW TC offload on the interface::
> +
> +        # ethtool -K <interface> hw-tc-offload on
> +
> +6. Crate htb root::
> +
> +        # tc qdisc add dev <interface> clsact
> +        # tc qdisc replace dev <interface> root handle 1: htb offload
> +
> +7. Create tc classes with different  priorities::
> +
> +        # tc class add dev <interface> parent 1: classid 1:1 htb rate 10Gbit prio 1
> +
> +        # tc class add dev <interface> parent 1: classid 1:2 htb rate 10Gbit prio 7


This part of the doc is confusing. It starts by reading like a list of
algorithms, then transitions into a list of instructions. I think those
should be separated into two pieces, one with the explanation and one
with some example how to set it up.
