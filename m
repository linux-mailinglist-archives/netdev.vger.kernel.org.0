Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D226E023C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjDLXFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDLXFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:05:06 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0BD1FD0;
        Wed, 12 Apr 2023 16:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681340704; x=1712876704;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Dp1YgPyvmNWUHyhL4OUAs/8mvHd3QnbaLZuGc9lTeto=;
  b=LhCLNbOy6dcftPI2JCnzZkwaTlgWiiaZ6EyHdAljNHtdvY+qrqa4ssip
   dLKw5lyK+cSHTyqfyUFG/HO1KXmSXjMJdOm6/TPoJW0xlI8gab/q1vK1B
   fEweKEPPuhuCRsLhAZTQ4WUshMylahv3M2onDCzM7qa7RNmLYhXMI28j2
   ZsL2xNzP7L+XZuBJyARtVQ0IcAvW6Vco+XHpV6j3cKjPKrZoZWjb7+sdW
   W26eCOSARAzcn/izb/kbVc8AgeIu2EEROqL3vffTfmt0GKmJP1QDIg2we
   PGUPP/TaXxAwLUih/nFTDX8XhFuWhlN5B+TelqwJ21AukoxGQGQUBGRsY
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="406875997"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="406875997"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 16:05:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="832841997"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="832841997"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 12 Apr 2023 16:05:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:05:03 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:05:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 16:05:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 16:05:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIC05Vqn3Vtg9wtgHT86JaFJp2SQmkKxRvMacFB5+44nsy5drkyM7bRvRJSkySkNd+i2+O5RDgU1ONDMjneeFucIj0Kt3duzrsS5dKI+RiQqRyJbBfSza3RLTBkpl+LfRkZQ2hBEtObwtsFSiXXVLvFggK1Ah+iUEeGBiVPX4M+DsvddYJZ4CHRHIzXbM728OuEy7p842IZ3GYh+vaGubzH8oiwdzquRkmqjAW1svqm7tcHB9Uuxaa8x5jXKZURDyTQ6rpUfwKO8L5PL4LE0eZhn/Bg7yZsvbl/qBUHsqOylV3MKl48ysrUGbVtMn4ITsvA2L2ChUzgn76Vmn3md3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dp1YgPyvmNWUHyhL4OUAs/8mvHd3QnbaLZuGc9lTeto=;
 b=S+ZYSRM4qZEMILIV/3BPVRKN7cffe/3gk+PQRn5kG2LgY8JQgcSpgYRuLuIBpIParCEPo6uGlJer952Dpr4D40d0RRoeCwsM052OYuiD5F+zO3VeYjCskHbp4SJ531SkGlV20bnteeNn6zQQYQk+uZoa+W0LVSJSEzPHMHy6h8vOR5+TjtH/y4RZmPgp04Ix2VHInmkws7WtGV6YmkVnWgpLG7pfgXsA8bdA7oHlPcnoLuaPYVVl89NYRvDA7YfR3yZtWmcVSVuj0RijGrE3GaUdAG1WZOBq47xDAYpmJKptl9eE4+W/AZaY44qsxSRIiqcHur16I21Z25QeIx9DLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH8PR11MB8039.namprd11.prod.outlook.com (2603:10b6:510:25f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 12 Apr
 2023 23:04:57 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 23:04:57 +0000
Message-ID: <16ee729f-9d45-4d1d-1840-6eee746b2312@intel.com>
Date:   Wed, 12 Apr 2023 16:05:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: fRom db62b365277f354bad482ac77be8308f8ac326b4 Mon Sep 17 00:00:00
 2001
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
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230410072910.5632-1-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0065.namprd17.prod.outlook.com
 (2603:10b6:a03:167::42) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH8PR11MB8039:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c39a8ba-4e5a-4535-9b20-08db3baa55a7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXcdYrGlcU91TyFD13TQhrThFQA1tND4j6k3FejF5Bg2+D52z/NJOpNeybsMa936N/zr+1XYQvy7k0mbxaTLHLS4BUZ2MBUaJ4i9oMRmQev2C6fkJv2A1BAZc/EN8bJdMqqz+jY5BIWEScn/NnxHbOc7VCbzJQDAwPIj4M8z1ZfYFtA5RmU5qIbOXpTj0S4/t5Kpo12xMJjaUd6fclX//aJzbn7jxsu77cLWOczFLhgH4cxjqVWDjV7uZjpAEkr92orw9idCHOrUSjRBOnvphhVl7rcFiWyzkLGzNSOPxcRuqeqZ9h6PxI+qVTqX2Jofuo9zKC9j/f/+LKEuqcDdFUioD4wHcMp1xhMPJVW7udO8GqVFnvinBl9DybG4BEtzmqUGq20AO7m0nmuwIIqXSHGd0M+Hfhg9/uAQV4nHGDvZEujsRstsY5c+H62/eWwx16rxy5VGcXPx/Ze5PqKFtJGALL0/gQvBZDF8NuowqAQd+KfEGjwf04Noxjddd86+70AlpHRw5cqI/hwntyEQwhqFUTKRIwaS+Zole/G9OEWF2UWyJ3mpszvQBMb4utT7r3FTGe9S5/1m/YfsXvO1+WfF+2XQGP/8UBtMGfVE/4/CUID6Ydz+0GACnKC5TlfN+gqIs6HMJYGdRe/Po06HYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199021)(558084003)(2616005)(6666004)(6486002)(478600001)(6506007)(26005)(186003)(6512007)(53546011)(2906002)(316002)(7416002)(38100700002)(36756003)(5660300002)(66476007)(82960400001)(4326008)(41300700001)(66946007)(66556008)(31696002)(86362001)(8676002)(8936002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTh4M3lRd3p4b0lXd2o1cUxZQnY1NjBQMXo3VW5CTlBsZmZCcHZ5V0pMbmFI?=
 =?utf-8?B?WmQyNmRIS2hMUjB2U3EwdCtPWWV6ZXlRczNuRlBMZ3lMNFBwZkNvMTlkWHQz?=
 =?utf-8?B?ZlhDYnFaWTJCOTlveFhVVWdFdysvb2orNWJ4ZWpyNTZ1eUErVzNMOG5iK1Uy?=
 =?utf-8?B?UjZ6QUdzYUxuNzEzV1ArUW9xYkw3NTlhOFFLTEJCK2VibGVrcFJXaWJNeW5t?=
 =?utf-8?B?Q3dNNTJ5L2QwV3VKdDE3QkVmamdvNWo3NGZJaVFiUEZDZTd5dWEwUEZrK0RN?=
 =?utf-8?B?Q3pXaUlwejlYd1ZJdXFmcDJSc3F1eHQvRHdyNGJwb0lYdGZTYzVZcXp2N1RV?=
 =?utf-8?B?aG9JaXpZdXhwbHRoTUVxQmtSU0g5dGl3VGZWNDNiZVFHWVNXRDNZYlpSRlBD?=
 =?utf-8?B?TWRLaS9Mb21JdUE2L3NnYzM4WEZ6dlVMRUI5TnhoY2NHMEZJcFZyRVJ2ckZr?=
 =?utf-8?B?MDBqRzJnOUo3V2dFY21GY0ZuSC95LzNTVW1VL1o3dmxRMlFWRHNzNy96dURa?=
 =?utf-8?B?SnorQXpPV2trNkxkcVIrdElhOWlhWEpERzZsVFdVYU9KbVJNL0tpbVZrYW85?=
 =?utf-8?B?Y0R1dmZQNjhKak5qcU05VDdEZTFzT1ZLRmhxWDRKTklDWDJFVWV4M3k2MEND?=
 =?utf-8?B?dGNNVTFOTmhHRyt4bXNjd2plbjZ4Tm5lMC8rc3FWZ1BRVklQcjJFNTNNaktO?=
 =?utf-8?B?VnIxZTA4TExNNEhGTVUxelNUUHJmOFBvb3lMbWxLTjYrYmRJaklZZXVMcEp2?=
 =?utf-8?B?cmR5MGl0bVA3elgvaVFjd3pLVXYwU3NZRW9jNFEzaU5iM0NNMSt6aFFMa2Rw?=
 =?utf-8?B?VDRzMFJTYVpIZHYwUG9TdmNiMEZhWXJ0NFdyem5pamxCanp1b28reGZrVFNt?=
 =?utf-8?B?eXVpalQ5NVZtNFFaamtpRUdMWFIxNzA0QW9lS1crY2JDaW5oVERSeVFvSU5s?=
 =?utf-8?B?aktlOWxlcXdBRTk3ZlMrMWtqeU1FWStvZjFXMnpycFN4ZjdBcWdPKzNpckxW?=
 =?utf-8?B?N0w0SGU5L1VlaVIzZHlVNzdvWEQzdllkWTN5ZHZ1cytJaWlHQWxlSXZ2bmx4?=
 =?utf-8?B?Y0ovQ0FDZ0F6R3VBTWo4aW8vN0RnOUIxZE45ZWp0SkYxZXBKeUlIVEtuaWoy?=
 =?utf-8?B?TkFkbWRNVGovMzkxTEVhd2FhSFpvVVplRDNGbnkxK05KZnkvV3J4aUQzY1FI?=
 =?utf-8?B?RWtsbUptNGZHV3NHNmNhSUY4c1NnU2thWHRPL1FDR3FrejZaL09BYXNMYVpO?=
 =?utf-8?B?SUpkSGk3UjRMamwvVUpXOU40djFjNldMT0tUL3NJWWdtcGdjUjZadXREYU5k?=
 =?utf-8?B?REkvWW5WYzVRWW1teXcwZVhPdllKMTQrZS95ci84UW8yOTBlWHB4bzMxNFFE?=
 =?utf-8?B?Q245bXE1RDU3RFR3NnNvM3doSWs1dktMVlFBOWE3VXBhNnFJclBwMmZzUmk5?=
 =?utf-8?B?RFVIWFo4NEhrTUpUdFpBZ2VXNHB2Mzl4MUxxU04yZmlnbWkrLzhqTFUwQllN?=
 =?utf-8?B?Rnl2clRFQldXRlplMHZXL09oZHNqbWFkTlBKSksvUVlZTVBGOEcvRU5nemlU?=
 =?utf-8?B?MmtQR1dpcHpTU083VTlpc2dQcEl5N29NOVB1Q3FWa1ZmUTk1amdiMXBzN2F2?=
 =?utf-8?B?d3BzQUk0cXd2ZktJeVFmbFZCMGdrcWE5RTFmN0g5bjJBSkdBUngrd0xDVU9p?=
 =?utf-8?B?RTdMY2xxVmtiR09SQ295ZWNPdlMwN0RhaWtBbjZoRmQrYmo0SzVoZ2ptZmV3?=
 =?utf-8?B?MytOWGdYTEk0ZXc3bzE4QUNkMlAvaStmMDI3Q256T05USDNuYjZOanZzcEtR?=
 =?utf-8?B?MnJidGRLNnBZM2FnMUdCL1RGOW9TaGRZaE1YSXdrWjZDMmRYT0ZnQVNjc0RL?=
 =?utf-8?B?MTRrdWwxVkVYTlF5YnViano4bFlxZEsvVTk1Si9sRUdPaFU4OHVpYXRXZHVz?=
 =?utf-8?B?TmFSSHpxZlFoSS8xWDJKNHVQUlgvUVg0QVo4aVBWenZhMWVMWkNYNXVncWxv?=
 =?utf-8?B?eTNvaENWczFyaENNemZMV1ZRdlN0UzhsbzhyUi9xVVJhMElnMjU0Qy8yWUhQ?=
 =?utf-8?B?OS82Ymo2RDNXNEdmQVltVGdUeG5CcTBiaWVhYVd3NUdOWjFKZVB1K1BhR1dm?=
 =?utf-8?B?bG5IcG43akFtcFN2UEd5U3ZKL1JVTXd0anBuYmgxQk4zbExYeFZrT0tYaGp2?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c39a8ba-4e5a-4535-9b20-08db3baa55a7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 23:04:57.3493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOH6yFiqHWXZxhd3/SDLxzlpMwHeimHQNQNkzf12NENvyCX3mwXtO1EJmR7CVDTWAlwCzk2IEQiSua9pakP4T1uwgaVhgZW/8JMwXDBPFhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8039
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

It looks like your subject line got a bit messed up. Not sure what would
have caused that.
