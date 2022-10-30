Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8F161297D
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 10:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJ3Jf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 05:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiJ3JfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 05:35:25 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B12EC4C;
        Sun, 30 Oct 2022 02:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667122521; x=1698658521;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=LNgIpwF897Q7WkyEvOOzXdv591N2oBUWm15YIs/P7P0=;
  b=KLq79bh+04wB3MVDRrNSn/b56ARU4/R/wR0TlcTOI/NsK9a6MJNvmP/I
   ddpNZHK3KTtAEeKscIj6rEy5cMhALQVBkwsaTz2pOZ3S5Hzhh76Un/uwd
   S+DJKKPidbf1AzYHAKL3Xb6flLr5z17ad47+JpsbcCBs4Pcwwu2c9uYBt
   JfpLKPhwe2YRkVieR8+7+Ts4z2w9IP17BCUCFOe+M5DjJDKNkDcuEbdNJ
   5PzJ/9cprXKy4mJ+PhKdF5JS1oNBBRinf7mzx9NK/sPkFA8jNFp/H0CcB
   D5xoA166XBs3xzGv8NuFR+FHjO9CSoouZa13k3ZNBRTCiHVmnJcE9vhxm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="296140033"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="xz'?scan'208";a="296140033"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2022 02:35:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="775824038"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="xz'?scan'208";a="775824038"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 30 Oct 2022 02:35:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 30 Oct 2022 02:35:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 30 Oct 2022 02:35:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 30 Oct 2022 02:35:17 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 30 Oct 2022 02:35:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqQKEjFlYv5rhAXHmIDglCa4j/pxhuVPTmGSo1DBSFD6r/Y3G32N0+qhc/oUtvXQlcURwSIS2JSZJgrwPXjL34NX4EpFs0IIU0lmSmTfb51loBCAiPoyWUIfYx4ark2WzODQC6H2KbukW5w1yAAKdo0uC0/0/voclwZRJDV4q1DR6MzoqjaZEu0OML6Zgi40blDHIkk7uQ9CaLSlX01zTPaSdSYNogtNm8OUsqRUXVrDj6YL6utS1SWUMcU14y9qGPAF3KIbMJRVRur8H7eNnaHW/0FrO5tVJYUfjwOMR3b4XvwmnxKrEwZ3mpHnm7OjMpAkwsGtafFUY7be3NrD4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFOYhEFjE/PM/Iw7fYJEBQBvNo9rIoT9UKpUuD11b84=;
 b=XZxAJpA4BmQ5RcLF5x4EOoI5toPkbQOE6xIweakZZd8wi/ZZtddNeLXIPbILlEqhSNUM9Sz/9bEfEfzENI7d0GBPfgPzstZIOxNbAWi6rEbtxuZMS9oomPirN59LYv7ALxZruF4SuoHNbYFa4ymw/bzXW8cnngrSMDAzPl4IIE0452X7xEraagcXtnZ4Ahc+hEmhJY4nYa8vnBMC87OTRjhk2lSPTF8tLDuGdUKTQ5oFRVFTFl7RNdKFZhxw159R6mrRNhZkzoW6MrHxlFWV3J0QuhJ5TASOkNA2aTk+INI1DKH7op72Z54CjRf9QZBmlC2BiS4zHmsnXA5L9vfQ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17)
 by DS7PR11MB6103.namprd11.prod.outlook.com (2603:10b6:8:84::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Sun, 30 Oct
 2022 09:35:13 +0000
Received: from PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::7f2d:39e1:85b6:93c1]) by PH8PR11MB6779.namprd11.prod.outlook.com
 ([fe80::7f2d:39e1:85b6:93c1%6]) with mapi id 15.20.5769.016; Sun, 30 Oct 2022
 09:35:13 +0000
Date:   Sun, 30 Oct 2022 17:35:04 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <oe-lkp@lists.linux.dev>, <lkp@intel.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [linus:master] [genetlink]  ce48ebdd56:
 WARNING:at_net/netlink/genetlink.c:#genl_register_family
Message-ID: <202210301645.c89bc046-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="Z7k+UbnZoJp3f+oK"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: SG2PR03CA0105.apcprd03.prod.outlook.com
 (2603:1096:4:7c::33) To PH8PR11MB6779.namprd11.prod.outlook.com
 (2603:10b6:510:1ca::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6779:EE_|DS7PR11MB6103:EE_
X-MS-Office365-Filtering-Correlation-Id: 1796b6d6-89dc-44e9-e5fc-08daba5a0b6c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 68Xke6vcmyzy6sYe9AYKRQS8cDQxTGKOuADbyM4BBK2p1WbPLqBRMXPeOZOd6jysAHERPpwxiDpfRNKnMwa5HTHZryAdIVGf/fV6vhHrssINyu5TFo1UPfwEBa57evvGX+ASMNELdjuOgrXZMC0jQoJbXGQThHZKuobzyh66Ly4Wxutg1WjRcWlkzeKHME4Kxx3flrtHIg5vJOP6CTF7uw7vUAD7RDHx4EetG6V0miKRa7BIHhjPfhEHrms2kDd83kzFDHSOIzy7lgFkroR3+5kOdt+9GttmA93SXkEYlCTdBN6KgxICd0hr1qXFcLQTYtakpPcZoWg5ghhVjcfdOocmIk6FB321ICj4XlJPXzhcU45UymiMAs57FybSXyaiP6ZkIfi8nMM6o320JLD+cKnp+diaYf0wDIdrkk7zVVqduJ7BI0Ap1Ig+Lgnwkbo/DFG0r2aYep12s9jnYNt5TbjCc4Pwo9abelWR7AUZOeWVa9l8kxRxZ+7mMBBQP5NFQS/tna4osHZe9QY4uWINYs67p37wRnX0U6yS+S0g6M4/arEUEUvVMJ+K/pzlV3MmozVcSfGDbkqefwbm0cF/VFdd3tO1mGTBSrj6C/KWJ6COfJeH9UROJwvsReMf7jfgZYRG7kfReJla787Cb6U56/bt013oskyKNFoB03eWQJ+OQ90Wo+IWPUBgn3qjZKQbz0jS1zEP7FUR2TXSfIUXmkmzeC0MBale9VEr0PM3vI2MGLBdQCwbMNw7CnB5eNrb/AzAQCVNL17s6kYVjaugiLoRHPdO4ZkNbIUnCha4aiHFgIdmAdQJkGe2UGHj5q5ZUyDnMmgTHV1iu+I/d58wbNNC3PGCagANwOpyvswLNdX+BFBZbxOUB2XxJmRU+uVx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6779.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(2616005)(6666004)(26005)(6506007)(186003)(1076003)(6512007)(44144004)(83380400001)(966005)(30864003)(2906002)(478600001)(235185007)(5660300002)(45080400002)(6486002)(66476007)(41300700001)(8676002)(8936002)(66556008)(316002)(66946007)(4326008)(6916009)(86362001)(36756003)(38100700002)(82960400001)(2700100001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0wSB4VzqZLfSm34UMvzQZ4DHznYWpD4C26rHjMFp9rSi3sgQGcORIZCXmASR?=
 =?us-ascii?Q?1I18AAJ9sEI4xGolaHuOsvk2IBWtMBjSO/hiesOEs0VfWNq3NedZZr7H3nqa?=
 =?us-ascii?Q?w8woQ4aB26yfLnSJeUgzxYGMN3QEXUkwgCi+74BOnk3c4/fzsTLq6io5K9tS?=
 =?us-ascii?Q?y8U30n+WNJ2j+F1YeHwP/1YRrgChuFeNmYG+uRJ5dSHwqAGgQLg3/ZDp5JQW?=
 =?us-ascii?Q?UrhpOkQEXgdasJtwlGRVWTKjDtSsJsegExeECKk+Y8P+Ags9nL+4Jna2KZ7K?=
 =?us-ascii?Q?geU0xRXWmvMiHQjQnkdSsib8OdnP9Nz/dlA0ZKHBCKifwd2gat+SZ3unV3aA?=
 =?us-ascii?Q?hfZLVpb/xsXvyD2ak/TnxXINRtoKnJ7f97DQe2JT6xr2RmnUt6qlBC54H/qh?=
 =?us-ascii?Q?snak18qU5R4NStAgLXtxrQyJZXhBMjO9cD+KsIm6W8yd6mEoQXENLupXtbBH?=
 =?us-ascii?Q?I9exw9kaUGy60onjW2a7S2Mjjfs4bqKxgEbcLw4XeyZkAw3/KlegBjEMK7A3?=
 =?us-ascii?Q?k77l4OeiMVbhFgL2cZmPepYYnZ7+4MMFsmmgTuu9JKdaRbMM4evs71V5xGdx?=
 =?us-ascii?Q?uWRf3xAI9VaJ3WI63OCiZx8dAkBaZiNX1R0CVaWdEobKhehcdJK21QfnwdYi?=
 =?us-ascii?Q?u0JUPkcPVQeRj0O0PVIYttkCoJGCzyNnjzinJpS4vA0y7vIunylgEbcQAACk?=
 =?us-ascii?Q?mmQeWu/VmI4a/o7b/iWuq551P6d5O3HNRDW+cJLV9xTTkU40ocrjMaSK5KOk?=
 =?us-ascii?Q?y70mar/Lg7m66mQZ9VG2fD9G4FFmqbmibV4LvqKH0K2lPMiOujrtV6Kl3+gq?=
 =?us-ascii?Q?hR6wCeZsmdygcSmk/s6QdKfaD08AKx62v3YliE1ciwJY/HyJR9Hjted8BN3S?=
 =?us-ascii?Q?rbRla9C2FFq0xxCRK2YrqVjpSIQ4TqyOdri8ft1fMqxsgAQp67LkDzxPynoB?=
 =?us-ascii?Q?B1jjmDeeWEphCKFiwQpcs1buAAUTiBFcviThDG+qyBi5v9mTzmk+/x+OF75J?=
 =?us-ascii?Q?IlgGariebJzvotW2MIGfiydqplpR5BY7f5BsZ2XLBUSUcE4eJOd2QtjySMuA?=
 =?us-ascii?Q?CYiH8m9NePAaHWcn38IM1FrFxRaZNZMCgenxpTpiCaPE2nGcjNR9uiId1DET?=
 =?us-ascii?Q?9eF5vQ17vApJl2EqDOHuUt90eWNwqlyR7QeImmqHFh/xWzKxGxyttTgjbNj/?=
 =?us-ascii?Q?8GUQf/qs/tA+QhRvo6XOuRD/GzzaF6/j7Lv+rMeeNKHAHkDyoTEgzyaPNDt/?=
 =?us-ascii?Q?4MsYzAtyTfUp9S7Et+4BtbYuJbhjmwnNl0Vi7/X2P0NfXhvUqWHkPYJv9oMn?=
 =?us-ascii?Q?iecDZHikOzjG0APsHP7Pleg+CqQBXCbI3TNKDGbVI5ovXDxPYk7WBRBGgMDY?=
 =?us-ascii?Q?LgLrIjK7hBDU2dsQyxi/81LRF27rgiz0YfhOHijWUtU3kVpfamrGNYLfVR4H?=
 =?us-ascii?Q?GzytE7PhORyNS8yF4dYW9Xsegp3LRV6eGPbXwQ3kZAIQWN67m+OgYUBCpGuw?=
 =?us-ascii?Q?Hzyl4uGU71TMo7gsKnZagbeJv0xnplhve/t065OAWt6vQV2kHVOdkwZYoHHo?=
 =?us-ascii?Q?lX/SOftnBmxV6AS/3EsOS2OM+Y53dQHfUpOYbImess5d4JHyrCX8xUaOpQDI?=
 =?us-ascii?Q?3g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1796b6d6-89dc-44e9-e5fc-08daba5a0b6c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6779.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 09:35:13.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tfz0PutvUk8k+ofGL628nkgYNKsMQqkyoId4rn+st/YfV7husWK2soQIWh2WuNTx+2J0SPD8vl+zxWENvNJ0lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6103
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Z7k+UbnZoJp3f+oK
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


Greeting,

FYI, we noticed WARNING:at_net/netlink/genetlink.c:#genl_register_family due to commit (built with gcc-11):

commit: ce48ebdd56513fa5ad9dab683a96399e00dbf464 ("genetlink: limit the use of validation workarounds to old ops")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linux-next/master fd8dab197cca2746e1fcd399a218eec5164726d4]

in testcase: boot

on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):



If you fix the issue, kindly add following tag
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Link: https://lore.kernel.org/oe-lkp/202210301645.c89bc046-oliver.sang@intel.com


[   13.397342][    T1] ------------[ cut here ]------------
[ 13.398381][ T1] WARNING: CPU: 0 PID: 1 at net/netlink/genetlink.c:383 genl_register_family (??:?) 
[   13.399867][    T1] Modules linked in:
[   13.400473][    T1] CPU: 0 PID: 1 Comm: swapper Tainted: G        W          6.1.0-rc2-00093-gce48ebdd5651 #1 e169ad32aa69920420b9c04cbfc68b3caba60cfb
[ 13.402793][ T1] EIP: genl_register_family (??:?) 
[ 13.403628][ T1] Code: 0f 0b 8b 45 c0 85 c0 0f 84 ef 01 00 00 0f b6 45 d0 8b 75 ac 88 45 b3 3a 46 28 0f 82 44 01 00 00 80 7d d3 00 0f 84 3a 01 00 00 <0f> 0b be ea ff ff ff 8b 45 f0 2b 05 f0 d0 70 c3 0f 85 7b 02 00 00
All code
========
   0:	0f 0b                	ud2    
   2:	8b 45 c0             	mov    -0x40(%rbp),%eax
   5:	85 c0                	test   %eax,%eax
   7:	0f 84 ef 01 00 00    	je     0x1fc
   d:	0f b6 45 d0          	movzbl -0x30(%rbp),%eax
  11:	8b 75 ac             	mov    -0x54(%rbp),%esi
  14:	88 45 b3             	mov    %al,-0x4d(%rbp)
  17:	3a 46 28             	cmp    0x28(%rsi),%al
  1a:	0f 82 44 01 00 00    	jb     0x164
  20:	80 7d d3 00          	cmpb   $0x0,-0x2d(%rbp)
  24:	0f 84 3a 01 00 00    	je     0x164
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	be ea ff ff ff       	mov    $0xffffffea,%esi
  31:	8b 45 f0             	mov    -0x10(%rbp),%eax
  34:	2b 05 f0 d0 70 c3    	sub    -0x3c8f2f10(%rip),%eax        # 0xffffffffc370d12a
  3a:	0f 85 7b 02 00 00    	jne    0x2bb

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	be ea ff ff ff       	mov    $0xffffffea,%esi
   7:	8b 45 f0             	mov    -0x10(%rbp),%eax
   a:	2b 05 f0 d0 70 c3    	sub    -0x3c8f2f10(%rip),%eax        # 0xffffffffc370d100
  10:	0f 85 7b 02 00 00    	jne    0x291
[   13.406809][    T1] EAX: 00000001 EBX: 00000000 ECX: c29f8800 EDX: c29f8840
[   13.407879][    T1] ESI: c2ea7620 EDI: 00000004 EBP: c0243f0c ESP: c0243eb0
[   13.410241][    T1] DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010206
[   13.411421][    T1] CR0: 80050033 CR2: ffdda000 CR3: 03ec8000 CR4: 00040690
[   13.412508][    T1] Call Trace:
[ 13.413037][ T1] ? ovs_flow_cmd_get (datapath.c:?) 
[ 13.414061][ T1] dp_init (datapath.c:?) 
[ 13.414690][ T1] ? batadv_tt_cache_init (datapath.c:?) 
[ 13.415520][ T1] do_one_initcall (??:?) 
[ 13.416301][ T1] ? rdinit_setup (main.c:?) 
[ 13.417241][ T1] do_initcalls (main.c:?) 
[ 13.418185][ T1] kernel_init_freeable (main.c:?) 
[ 13.418950][ T1] ? rest_init (main.c:?) 
[ 13.419594][ T1] kernel_init (main.c:?) 
[ 13.420259][ T1] ret_from_fork (??:?) 
[   13.420991][    T1] irq event stamp: 1618993
[ 13.421873][ T1] hardirqs last enabled at (1619003): __up_console_sem (printk.c:?) 
[ 13.423220][ T1] hardirqs last disabled at (1619010): __up_console_sem (printk.c:?) 
[ 13.424548][ T1] softirqs last enabled at (1617448): lowpan_nhc_add (??:?) 
[ 13.426117][ T1] softirqs last disabled at (1617446): lowpan_nhc_add (??:?) 
[   13.427451][    T1] ---[ end trace 0000000000000000 ]---
[ 13.429026][ T1] initcall dp_init+0x0/0x111 returned -22 after 33525 usecs 
[ 13.430395][ T1] calling vsock_init+0x0/0xed @ 1 
[   13.431786][    T1] NET: Registered PF_VSOCK protocol family
[ 13.432729][ T1] initcall vsock_init+0x0/0xed returned 0 after 1536 usecs 
[ 13.434055][ T1] calling vsock_diag_init+0x0/0xf @ 1 
[ 13.434899][ T1] initcall vsock_diag_init+0x0/0xf returned 0 after 4 usecs 
[ 13.435981][ T1] calling mpls_gso_init+0x0/0x25 @ 1 
[   13.436818][    T1] mpls_gso: MPLS GSO support
[ 13.437528][ T1] initcall mpls_gso_init+0x0/0x25 returned 0 after 709 usecs 
[ 13.438850][ T1] calling nsh_init_module+0x0/0x11 @ 1 
[ 13.439701][ T1] initcall nsh_init_module+0x0/0x11 returned 0 after 3 usecs 
[ 13.442947][ T1] calling hsr_init+0x0/0x14 @ 1 
[   13.443868][    T1] Cannot create hsr debugfs root directory
[ 13.444953][ T1] initcall hsr_init+0x0/0x14 returned 0 after 1222 usecs 
[ 13.446262][ T1] calling qcom_smd_qrtr_driver_init+0x0/0x11 @ 1 
[ 13.447352][ T1] initcall qcom_smd_qrtr_driver_init+0x0/0x11 returned 0 after 104 usecs 
[ 13.448702][ T1] calling qcom_mhi_qrtr_driver_init+0x0/0x11 @ 1 
[ 13.450041][ T1] initcall qcom_mhi_qrtr_driver_init+0x0/0x11 returned 0 after 125 usecs 
[ 13.453081][ T1] calling kernel_do_mounts_initrd_sysctls_init+0x0/0x1b @ 1 
[ 13.454517][ T1] initcall kernel_do_mounts_initrd_sysctls_init+0x0/0x1b returned 0 after 44 usecs 
[ 13.455973][ T1] calling hpet_insert_resource+0x0/0x1f @ 1 
[ 13.456933][ T1] initcall hpet_insert_resource+0x0/0x1f returned 0 after 5 usecs 
[ 13.458383][ T1] calling create_tlb_single_page_flush_ceiling+0x0/0x23 @ 1 
[ 13.459559][ T1] initcall create_tlb_single_page_flush_ceiling+0x0/0x23 returned 0 after 2 usecs 
[ 13.460999][ T1] calling cpa_stats_init+0x0/0x23 @ 1 
[ 13.462085][ T1] initcall cpa_stats_init+0x0/0x23 returned 0 after 1 usecs 
[ 13.463213][ T1] calling pat_memtype_list_init+0x0/0x31 @ 1 
[ 13.464170][ T1] initcall pat_memtype_list_init+0x0/0x31 returned 0 after 1 usecs 
[ 13.465413][ T1] calling reboot_ksysfs_init+0x0/0x53 @ 1 
[ 13.466604][ T1] initcall reboot_ksysfs_init+0x0/0x53 returned 0 after 76 usecs 
[ 13.467824][ T1] calling sched_core_sysctl_init+0x0/0x1b @ 1 
[ 13.470087][ T1] initcall sched_core_sysctl_init+0x0/0x1b returned 0 after 21 usecs 
[ 13.471431][ T1] calling sched_fair_sysctl_init+0x0/0x1b @ 1 
[ 13.472488][ T1] initcall sched_fair_sysctl_init+0x0/0x1b returned 0 after 18 usecs 
[ 13.474016][ T1] calling sched_rt_sysctl_init+0x0/0x1b @ 1 
[ 13.474985][ T1] initcall sched_rt_sysctl_init+0x0/0x1b returned 0 after 21 usecs 
[ 13.476214][ T1] calling sched_dl_sysctl_init+0x0/0x1b @ 1 
[ 13.477207][ T1] initcall sched_dl_sysctl_init+0x0/0x1b returned 0 after 17 usecs 
[ 13.478660][ T1] calling sched_clock_init_late+0x0/0xa2 @ 1 
[   13.479623][    T1] sched_clock: Marking stable (13455826937, 22697179)->(13505147251, -26623135)
[ 13.481029][ T1] initcall sched_clock_init_late+0x0/0xa2 returned 0 after 1406 usecs 
[ 13.482530][ T1] calling sched_init_debug+0x0/0x105 @ 1 
[ 13.483424][ T1] initcall sched_init_debug+0x0/0x105 returned 0 after 2 usecs 
[ 13.484690][ T1] calling kernel_lockdep_sysctls_init+0x0/0x1b @ 1 
[ 13.485949][ T1] initcall kernel_lockdep_sysctls_init+0x0/0x1b returned 0 after 26 usecs 
[ 13.487293][ T1] calling cpu_latency_qos_init+0x0/0x33 @ 1 
[ 13.488562][ T1] initcall cpu_latency_qos_init+0x0/0x33 returned 0 after 338 usecs 
[ 13.490051][ T1] calling printk_late_init+0x0/0xf7 @ 1 
[ 13.490996][ T1] initcall printk_late_init+0x0/0xf7 returned 0 after 28 usecs 
[ 13.492179][ T1] calling rcu_verify_early_boot_tests+0x0/0x60 @ 1 
[ 13.493238][ T1] initcall rcu_verify_early_boot_tests+0x0/0x60 returned 0 after 2 usecs 
[ 13.494755][ T1] calling rcu_tasks_verify_schedule_work+0x0/0x70 @ 1 
[ 13.495860][ T1] initcall rcu_tasks_verify_schedule_work+0x0/0x70 returned 0 after 2 usecs 
[ 13.498451][ T1] calling tk_debug_sleep_time_init+0x0/0x1f @ 1 
[ 13.499455][ T1] initcall tk_debug_sleep_time_init+0x0/0x1f returned 0 after 1 usecs 
[ 13.500730][ T1] calling bpf_ksym_iter_register+0x0/0x19 @ 1 
[ 13.501939][ T1] initcall bpf_ksym_iter_register+0x0/0x19 returned 0 after 19 usecs 
[ 13.503199][ T1] calling bpf_rstat_kfunc_init+0x0/0x14 @ 1 
[ 13.504158][ T1] initcall bpf_rstat_kfunc_init+0x0/0x14 returned 0 after 32 usecs 
[ 13.505423][ T1] calling debugfs_kprobe_init+0x0/0x61 @ 1 
[ 13.506571][ T1] initcall debugfs_kprobe_init+0x0/0x61 returned 0 after 2 usecs 
[ 13.507771][ T1] calling bpf_key_sig_kfuncs_init+0x0/0x14 @ 1 
[ 13.508794][ T1] initcall bpf_key_sig_kfuncs_init+0x0/0x14 returned 0 after 28 usecs 
[ 13.510307][ T1] calling bpf_syscall_sysctl_init+0x0/0x1b @ 1 
[ 13.511301][ T1] initcall bpf_syscall_sysctl_init+0x0/0x1b returned 0 after 22 usecs 
[ 13.512587][ T1] calling kfunc_init+0x0/0x14 @ 1 
[ 13.513404][ T1] initcall kfunc_init+0x0/0x14 returned 0 after 2 usecs 
[ 13.514700][ T1] calling bpf_map_iter_init+0x0/0x27 @ 1 
[ 13.515612][ T1] initcall bpf_map_iter_init+0x0/0x27 returned 0 after 22 usecs 
[ 13.516835][ T1] calling task_iter_init+0x0/0x79 @ 1 
[ 13.517909][ T1] initcall task_iter_init+0x0/0x79 returned 0 after 22 usecs 
[ 13.519058][ T1] calling bpf_prog_iter_init+0x0/0x19 @ 1 
[ 13.519979][ T1] initcall bpf_prog_iter_init+0x0/0x19 returned 0 after 11 usecs 
[ 13.521217][ T1] calling bpf_link_iter_init+0x0/0x19 @ 1 
[ 13.522356][ T1] initcall bpf_link_iter_init+0x0/0x19 returned 0 after 12 usecs 
[ 13.523561][ T1] calling bpf_cgroup_iter_init+0x0/0x19 @ 1 
[ 13.524509][ T1] initcall bpf_cgroup_iter_init+0x0/0x19 returned 0 after 12 usecs 
[ 13.526987][ T1] calling load_system_certificate_list+0x0/0x2c @ 1 
[   13.528043][    T1] Loading compiled-in X.509 certificates
[ 13.528928][ T1] initcall load_system_certificate_list+0x0/0x2c returned 0 after 885 usecs 
[ 13.530473][ T1] calling fault_around_debugfs+0x0/0x1f @ 1 
[ 13.531400][ T1] initcall fault_around_debugfs+0x0/0x1f returned 0 after 1 usecs 
[ 13.532647][ T1] calling fail_page_alloc_debugfs+0x0/0x60 @ 1 
[ 13.533822][ T1] initcall fail_page_alloc_debugfs+0x0/0x60 returned 0 after 2 usecs 
[ 13.535091][ T1] calling failslab_debugfs_init+0x0/0x53 @ 1 
[ 13.536054][ T1] initcall failslab_debugfs_init+0x0/0x53 returned -1 after 1 usecs 
[ 13.537326][ T1] calling debug_vm_pgtable+0x0/0x241 @ 1 
[   13.538421][    T1] debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
[ 13.540097][ T1] initcall debug_vm_pgtable+0x0/0x241 returned 0 after 1676 usecs 
[ 13.541371][ T1] calling pageowner_init+0x0/0x37 @ 1 
[ 13.542426][ T1] initcall pageowner_init+0x0/0x37 returned 0 after 1 usecs 
[ 13.543563][ T1] calling check_early_ioremap_leak+0x0/0x4c @ 1 
[ 13.544549][ T1] initcall check_early_ioremap_leak+0x0/0x4c returned 0 after 1 usecs 
[ 13.546051][ T1] calling fscrypt_init+0x0/0x6f @ 1 
[   13.547215][    T1] Key type .fscrypt registered
[   13.548030][    T1] Key type fscrypt-provisioning registered
[ 13.553064][ T1] initcall fscrypt_init+0x0/0x6f returned 0 after 6189 usecs 
[ 13.554378][ T1] calling afs_init+0x0/0xf9 @ 1 
[   13.555149][    T1] kAFS: Red Hat AFS client v0.1 registering.
[ 13.557914][ T1] initcall afs_init+0x0/0xf9 returned 0 after 2764 usecs 


To reproduce:

        # build kernel
	cd linux
	cp config-6.1.0-rc2-00093-gce48ebdd5651 .config
	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 olddefconfig prepare modules_prepare bzImage modules
	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 INSTALL_MOD_PATH=<mod-install-dir> modules_install
	cd <mod-install-dir>
	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz


        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



--Z7k+UbnZoJp3f+oK
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment;
	filename="config-6.1.0-rc2-00093-gce48ebdd5651"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 6.1.0-rc2 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-8) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23900
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23900
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=123
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_UAPI_HEADER_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_DEBUGFS=y
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
# CONFIG_BPF_JIT is not set
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# end of BPF subsystem

CONFIG_PREEMPT_VOLUNTARY_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_PREEMPT_DYNAMIC is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_PSI=y
CONFIG_PSI_DEFAULT_DISABLED=y
# end of CPU/Task time and stats accounting

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
CONFIG_RCU_EXPERT=y
CONFIG_SRCU=y
CONFIG_TINY_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_FORCE_TASKS_RCU=y
CONFIG_TASKS_RCU=y
CONFIG_FORCE_TASKS_RUDE_RCU=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_FORCE_TASKS_TRACE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_TASKS_TRACE_RCU_READ_MB=y
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
# CONFIG_PRINTK_INDEX is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_BPF is not set
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_NAMESPACES is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_IO_URING=y
# CONFIG_ADVISE_SYSCALLS is not set
# CONFIG_MEMBARRIER is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
# CONFIG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PC104=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_BITS_MAX=16
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_NR_GPIO=512
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=2
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
# CONFIG_GOLDFISH is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
# CONFIG_IOSF_MBI is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_M486SX=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_F00F_BUG=y
CONFIG_X86_INVD_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_HYGON is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
# CONFIG_CPU_SUP_ZHAOXIN is not set
CONFIG_CPU_SUP_VORTEX_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS_RANGE_BEGIN=1
CONFIG_NR_CPUS_RANGE_END=1
CONFIG_NR_CPUS_DEFAULT=1
CONFIG_NR_CPUS=1
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set

#
# Performance monitoring
#
# end of Performance monitoring

# CONFIG_X86_LEGACY_VM86 is not set
# CONFIG_X86_IOPL_IOPERM is not set
CONFIG_TOSHIBA=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_CPA_STATISTICS=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
# CONFIG_EFI is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
# CONFIG_MODIFY_LDT_SYSCALL is not set
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
# end of Processor type and features

CONFIG_CC_HAS_SLS=y
CONFIG_CC_HAS_RETURN_THUNK=y
CONFIG_SPECULATION_MITIGATIONS=y
CONFIG_RETPOLINE=y
# CONFIG_RETHUNK is not set
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_DPTF is not set
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_PMIC_OPREGION is not set
CONFIG_X86_PM_TIMER=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_ISA_BUS=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_COMPAT_32=y
# end of Binary Emulations

CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_ARCH_32BIT_OFF_T=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
# CONFIG_SECCOMP is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=8
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_ISA_BUS_API=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SPLIT_ARG64=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
# end of Executable file formats

#
# Memory Management options
#

#
# SLAB allocator options
#
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
# CONFIG_SLAB_FREELIST_RANDOM is not set
CONFIG_SLAB_FREELIST_HARDENED=y
# CONFIG_SLUB_STATS is not set
# end of SLAB allocator options

CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_SYSFS=y
CONFIG_CMA_AREAS=7
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
# CONFIG_ZONE_DMA is not set
CONFIG_VM_EVENT_COUNTERS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_KMAP_LOCAL=y
# CONFIG_USERFAULTFD is not set
# CONFIG_LRU_GEN is not set

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_INTERFACE=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_AH=y
CONFIG_XFRM_ESP=y
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_SMC=y
CONFIG_SMC_DIAG=y
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
CONFIG_NET_UDP_TUNNEL=y
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_ESP_OFFLOAD=y
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_ESP_OFFLOAD=y
# CONFIG_INET6_ESPINTCP is not set
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
CONFIG_INET6_TUNNEL=y
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_IPV6_SEG6_LWTUNNEL=y
CONFIG_IPV6_SEG6_HMAC=y
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
# CONFIG_IPV6_IOAM6_LWTUNNEL is not set
# CONFIG_NETLABEL is not set
# CONFIG_MPTCP is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_BPFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y
# end of DCCP CCIDs Configuration

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
# end of DCCP Kernel Hacking

CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_IPDDP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_6LOWPAN=y
CONFIG_6LOWPAN_DEBUGFS=y
CONFIG_6LOWPAN_NHC=y
CONFIG_6LOWPAN_NHC_DEST=y
CONFIG_6LOWPAN_NHC_FRAGMENT=y
CONFIG_6LOWPAN_NHC_HOP=y
CONFIG_6LOWPAN_NHC_IPV6=y
# CONFIG_6LOWPAN_NHC_MOBILITY is not set
# CONFIG_6LOWPAN_NHC_ROUTING is not set
# CONFIG_6LOWPAN_NHC_UDP is not set
CONFIG_6LOWPAN_GHC_EXT_HDR_HOP=y
# CONFIG_6LOWPAN_GHC_UDP is not set
CONFIG_6LOWPAN_GHC_ICMPV6=y
CONFIG_6LOWPAN_GHC_EXT_HDR_DEST=y
CONFIG_6LOWPAN_GHC_EXT_HDR_FRAG=y
# CONFIG_6LOWPAN_GHC_EXT_HDR_ROUTE is not set
CONFIG_IEEE802154=y
CONFIG_IEEE802154_NL802154_EXPERIMENTAL=y
# CONFIG_IEEE802154_SOCKET is not set
CONFIG_IEEE802154_6LOWPAN=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_CBS=y
# CONFIG_NET_SCH_ETF is not set
CONFIG_NET_SCH_TAPRIO=y
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_SKBPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=y
# CONFIG_NET_SCH_PIE is not set
# CONFIG_NET_SCH_PLUG is not set
# CONFIG_NET_SCH_ETS is not set
# CONFIG_NET_SCH_DEFAULT is not set

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=y
CONFIG_NET_CLS_FLOWER=y
# CONFIG_NET_CLS_MATCHALL is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BATMAN_V is not set
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_MCAST is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_BATMAN_ADV_TRACING is not set
CONFIG_OPENVSWITCH=y
# CONFIG_OPENVSWITCH_GENEVE is not set
CONFIG_VSOCKETS=y
CONFIG_VSOCKETS_DIAG=y
# CONFIG_VSOCKETS_LOOPBACK is not set
# CONFIG_VIRTIO_VSOCKETS is not set
CONFIG_VIRTIO_VSOCKETS_COMMON=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_MPLS_ROUTING is not set
CONFIG_NET_NSH=y
CONFIG_HSR=y
CONFIG_NET_SWITCHDEV=y
# CONFIG_NET_L3_MASTER_DEV is not set
CONFIG_QRTR=y
CONFIG_QRTR_SMD=y
# CONFIG_QRTR_TUN is not set
CONFIG_QRTR_MHI=y
# CONFIG_NET_NCSI is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_IPV6=y
CONFIG_AF_RXRPC_INJECT_LOSS=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
# CONFIG_AF_KCM is not set
CONFIG_MCTP=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set
# CONFIG_PSAMPLE is not set
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_PAGE_POOL=y
# CONFIG_PAGE_POOL_STATS is not set
CONFIG_FAILOVER=y
# CONFIG_ETHTOOL_NETLINK is not set

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCI_MSI is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_PCI_LOCKLESS_CONFIG=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_HOTPLUG_PCI is not set

#
# PCI controller drivers
#
# CONFIG_PCI_FTPCI100 is not set
# CONFIG_PCI_HOST_GENERIC is not set

#
# DesignWare PCI Core Support
#
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# CONFIG_PCIE_CADENCE_PLAT_HOST is not set
# CONFIG_PCI_J721E_HOST is not set
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_FW_LOADER_COMPRESS is not set
# CONFIG_FW_UPLOAD is not set
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_SPMI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_REGMAP_SOUNDWIRE=y
CONFIG_REGMAP_SOUNDWIRE_MBQ=y
CONFIG_REGMAP_SPI_AVMM=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_FENCE_TRACE=y
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MOXTET is not set
CONFIG_MHI_BUS=y
# CONFIG_MHI_BUS_DEBUG is not set
# CONFIG_MHI_BUS_PCI_GENERIC is not set
# CONFIG_MHI_BUS_EP is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_FW_CFG_SYSFS is not set
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_GNSS=y
CONFIG_GNSS_SERIAL=y
CONFIG_GNSS_MTK_SERIAL=y
CONFIG_GNSS_SIRF_SERIAL=y
CONFIG_GNSS_UBX_SERIAL=y
# CONFIG_GNSS_USB is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_AR7_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SBC_GXX is not set
CONFIG_MTD_SCx200_DOCFLASH=y
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_MCHP23K256 is not set
CONFIG_MTD_MCHP48L640=y
# CONFIG_MTD_SST25L is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

#
# NAND
#
CONFIG_MTD_NAND_CORE=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
# CONFIG_MTD_ONENAND_OTP is not set
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set
CONFIG_MTD_RAW_NAND=y

#
# Raw/parallel NAND flash controllers
#
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_DENALI_DT=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
# CONFIG_MTD_NAND_MXIC is not set
CONFIG_MTD_NAND_GPIO=y
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_NAND_CADENCE=y
CONFIG_MTD_NAND_ARASAN=y
# CONFIG_MTD_NAND_INTEL_LGM is not set

#
# Misc
#
CONFIG_MTD_NAND_NANDSIM=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_SPI_NAND=y

#
# ECC engine support
#
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SW_HAMMING is not set
# CONFIG_MTD_NAND_ECC_SW_BCH is not set
CONFIG_MTD_NAND_ECC_MXIC=y
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_MTD_HYPERBUS=y
CONFIG_DTC=y
CONFIG_OF=y
# CONFIG_OF_UNITTEST is not set
CONFIG_OF_FLATTREE=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_KOBJ=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_RESOLVE=y
CONFIG_OF_OVERLAY=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# NVME Support
#
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HI6421V600_IRQ=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_PCH_PHUB is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_SRAM=y
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
CONFIG_XILINX_SDFEC=y
CONFIG_HISI_HIKEY_USB=y
# CONFIG_VCPU_STALL_DETECTOR is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_EEPROM_EE1004=y
# end of EEPROM support

# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=y
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_PVPANIC is not set
# CONFIG_GP_PCI1XXXX is not set
# end of Misc devices

#
# SCSI device support
#
# end of SCSI device support

# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
CONFIG_WIREGUARD=y
CONFIG_WIREGUARD_DEBUG=y
CONFIG_EQUALIZER=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
CONFIG_NET_TEAM_MODE_RANDOM=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
# CONFIG_IPVLAN is not set
# CONFIG_VXLAN is not set
CONFIG_GENEVE=y
# CONFIG_BAREUDP is not set
CONFIG_GTP=y
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
CONFIG_TAP=y
CONFIG_TUN_VNET_CROSS_LE=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
# CONFIG_VSOCKMON is not set
CONFIG_MHI_NET=y
# CONFIG_ARCNET is not set
CONFIG_CAIF_DRIVERS=y
CONFIG_CAIF_TTY=y
# CONFIG_CAIF_VIRTIO is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_GEMINI_ETHERNET is not set
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
CONFIG_NET_VENDOR_EZCHIP=y
# CONFIG_EZCHIP_NPS_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_FUNGIBLE=y
CONFIG_NET_VENDOR_GOOGLE=y
CONFIG_NET_VENDOR_HUAWEI=y
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_I40E is not set
# CONFIG_IGC is not set
CONFIG_NET_VENDOR_WANGXUN=y
# CONFIG_NGBE is not set
# CONFIG_TXGBE is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_ADI=y
# CONFIG_ADIN1110 is not set
CONFIG_NET_VENDOR_LITEX=y
# CONFIG_LITEX_LITEETH is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
# CONFIG_LAN966X_SWITCH is not set
CONFIG_NET_VENDOR_MICROSEMI=y
# CONFIG_MSCC_OCELOT_SWITCH is not set
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCA7000_SPI is not set
# CONFIG_QCA7000_UART is not set
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
# CONFIG_SFC_SIENA is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
CONFIG_ADIN_PHY=y
# CONFIG_ADIN1100_PHY is not set
CONFIG_AQUANTIA_PHY=y
# CONFIG_AX88796B_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM54140_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM84881_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_BCM_NET_PHYLIB=y
# CONFIG_CICADA_PHY is not set
CONFIG_CORTINA_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_INTEL_XWAY_PHY=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_MARVELL_10G_PHY=y
CONFIG_MARVELL_88X2222_PHY=y
CONFIG_MAXLINEAR_GPHY=y
CONFIG_MEDIATEK_GE_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_MICROCHIP_PHY=y
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_NXP_C45_TJA11XX_PHY=y
CONFIG_NXP_TJA11XX_PHY=y
CONFIG_AT803X_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_REALTEK_PHY is not set
CONFIG_RENESAS_PHY=y
# CONFIG_ROCKCHIP_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_STE10XP=y
# CONFIG_TERANETICS_PHY is not set
CONFIG_DP83822_PHY=y
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_DP83TD510_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PSE_CONTROLLER is not set

#
# MCTP Device Drivers
#
# CONFIG_MCTP_SERIAL is not set
# CONFIG_MCTP_TRANSPORT_I2C is not set
# end of MCTP Device Drivers

CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_OF_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_BCM_UNIMAC=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MDIO_HISI_FEMAC=y
CONFIG_MDIO_MVUSB=y
CONFIG_MDIO_MSCC_MIIM=y
CONFIG_MDIO_IPQ4019=y
# CONFIG_MDIO_IPQ8064 is not set

#
# MDIO Multiplexers
#
CONFIG_MDIO_BUS_MUX=y
# CONFIG_MDIO_BUS_MUX_GPIO is not set
CONFIG_MDIO_BUS_MUX_MULTIPLEXER=y
CONFIG_MDIO_BUS_MUX_MMIOREG=y

#
# PCS device drivers
#
# end of PCS device drivers

CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOE=y
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
CONFIG_USB_LAN78XX=y
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SR9800=y
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
# CONFIG_USB_BELKIN is not set
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
CONFIG_USB_NET_QMI_WWAN=y
CONFIG_USB_HSO=y
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
CONFIG_USB_NET_CH9200=y
# CONFIG_USB_NET_AQC111 is not set
CONFIG_USB_RTL8153_ECM=y
CONFIG_WLAN=y
# CONFIG_WLAN_VENDOR_ADMTEK is not set
CONFIG_ATH_COMMON=y
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
CONFIG_ATH9K_COMMON_DEBUG=y
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
# CONFIG_ATH9K is not set
CONFIG_ATH9K_HTC=y
CONFIG_ATH9K_HTC_DEBUGFS=y
CONFIG_ATH9K_COMMON_SPECTRAL=y
CONFIG_CARL9170=y
CONFIG_CARL9170_LEDS=y
# CONFIG_CARL9170_DEBUGFS is not set
CONFIG_CARL9170_WPC=y
# CONFIG_CARL9170_HWRNG is not set
CONFIG_ATH6KL=y
CONFIG_ATH6KL_SDIO=y
# CONFIG_ATH6KL_USB is not set
# CONFIG_ATH6KL_DEBUG is not set
# CONFIG_ATH6KL_TRACING is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
CONFIG_ATH10K=y
CONFIG_ATH10K_CE=y
# CONFIG_ATH10K_PCI is not set
CONFIG_ATH10K_SDIO=y
CONFIG_ATH10K_USB=y
CONFIG_ATH10K_DEBUG=y
CONFIG_ATH10K_DEBUGFS=y
CONFIG_ATH10K_SPECTRAL=y
CONFIG_ATH10K_TRACING=y
CONFIG_WCN36XX=y
CONFIG_WCN36XX_DEBUGFS=y
CONFIG_ATH11K=y
CONFIG_ATH11K_AHB=y
# CONFIG_ATH11K_PCI is not set
CONFIG_ATH11K_DEBUG=y
# CONFIG_ATH11K_DEBUGFS is not set
CONFIG_ATH11K_TRACING=y
# CONFIG_WLAN_VENDOR_ATMEL is not set
# CONFIG_WLAN_VENDOR_BROADCOM is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_WLAN_VENDOR_INTERSIL is not set
# CONFIG_WLAN_VENDOR_MARVELL is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
CONFIG_MT7601U=y
CONFIG_MT76_CORE=y
CONFIG_MT76_LEDS=y
CONFIG_MT76_USB=y
CONFIG_MT76_SDIO=y
CONFIG_MT76x02_LIB=y
CONFIG_MT76x02_USB=y
CONFIG_MT76_CONNAC_LIB=y
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
CONFIG_MT76x2_COMMON=y
# CONFIG_MT76x2E is not set
CONFIG_MT76x2U=y
# CONFIG_MT7603E is not set
CONFIG_MT7615_COMMON=y
# CONFIG_MT7615E is not set
CONFIG_MT7663_USB_SDIO_COMMON=y
CONFIG_MT7663U=y
CONFIG_MT7663S=y
# CONFIG_MT7915E is not set
# CONFIG_MT7921E is not set
# CONFIG_MT7921S is not set
# CONFIG_MT7921U is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
CONFIG_WILC1000=y
# CONFIG_WILC1000_SDIO is not set
CONFIG_WILC1000_SPI=y
CONFIG_WLAN_VENDOR_PURELIFI=y
# CONFIG_PLFXLC is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=y
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
CONFIG_RTL8XXXU=y
# CONFIG_RTL8XXXU_UNTESTED is not set
# CONFIG_RTW88 is not set
# CONFIG_RTW89 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_SILABS=y
# CONFIG_WFX is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
CONFIG_USB_ZD1201=y
# CONFIG_ZD1211RW is not set
# CONFIG_WLAN_VENDOR_QUANTENNA is not set
CONFIG_MAC80211_HWSIM=y
CONFIG_USB_NET_RNDIS_WLAN=y
CONFIG_VIRT_WIFI=y
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKELB=y
CONFIG_IEEE802154_AT86RF230=y
CONFIG_IEEE802154_MRF24J40=y
CONFIG_IEEE802154_CC2520=y
CONFIG_IEEE802154_ATUSB=y
# CONFIG_IEEE802154_ADF7242 is not set
CONFIG_IEEE802154_CA8210=y
# CONFIG_IEEE802154_CA8210_DEBUGFS is not set
CONFIG_IEEE802154_MCR20A=y
CONFIG_IEEE802154_HWSIM=y

#
# Wireless WAN
#
CONFIG_WWAN=y
CONFIG_WWAN_DEBUGFS=y
# CONFIG_WWAN_HWSIM is not set
CONFIG_MHI_WWAN_CTRL=y
# CONFIG_MHI_WWAN_MBIM is not set
# CONFIG_RPMSG_WWAN_CTRL is not set
# CONFIG_MTK_T7XX is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
# CONFIG_NETDEVSIM is not set
CONFIG_NET_FAILOVER=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_LEDS is not set
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=y
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_PINEPHONE is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_IQS62X is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CAP11XX is not set
# CONFIG_KEYBOARD_BCM is not set
# CONFIG_KEYBOARD_MTK_PMIC is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_BYD is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
# CONFIG_MOUSE_PS2_FOCALTECH is not set
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_ELAN_I2C=y
# CONFIG_MOUSE_ELAN_I2C_I2C is not set
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_JOYSTICK_PSXPAD_SPI=y
CONFIG_JOYSTICK_PSXPAD_SPI_FF=y
# CONFIG_JOYSTICK_PXRC is not set
# CONFIG_JOYSTICK_QWIIC is not set
CONFIG_JOYSTICK_FSIA6B=y
# CONFIG_JOYSTICK_SENSEHAT is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=y
CONFIG_RMI4_I2C=y
# CONFIG_RMI4_SPI is not set
CONFIG_RMI4_SMB=y
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
CONFIG_RMI4_F3A=y
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_GPIO_PS2=y
# CONFIG_USERIO is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_LDISC_AUTOLOAD is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
CONFIG_SERIAL_8250_FINTEK=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
# CONFIG_SERIAL_8250_MEN_MCB is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y
# CONFIG_SERIAL_OF_PLATFORM is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SIFIVE is not set
# CONFIG_SERIAL_LANTIQ is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_SERIAL_FSL_LINFLEXUART=y
CONFIG_SERIAL_FSL_LINFLEXUART_CONSOLE=y
CONFIG_SERIAL_CONEXANT_DIGICOLOR=y
# CONFIG_SERIAL_CONEXANT_DIGICOLOR_CONSOLE is not set
# CONFIG_SERIAL_MEN_Z135 is not set
CONFIG_SERIAL_SPRD=y
CONFIG_SERIAL_SPRD_CONSOLE=y
# CONFIG_SERIAL_LITEUART is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_NOZOMI is not set
CONFIG_NULL_TTY=y
# CONFIG_RPMSG_TTY is not set
CONFIG_SERIAL_DEV_BUS=y
# CONFIG_SERIAL_DEV_CTRL_TTYPORT is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SSIF is not set
# CONFIG_IPMI_IPMB is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_IPMB_DEVICE_INTERFACE=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_BA431=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_CCTRNG=y
CONFIG_HW_RANDOM_XIPHERA=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_DEVMEM is not set
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_SPI=y
# CONFIG_TCG_TIS_SPI_CR50 is not set
# CONFIG_TCG_TIS_I2C is not set
CONFIG_TCG_TIS_I2C_CR50=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_CRB is not set
CONFIG_TCG_VTPM_PROXY=y
CONFIG_TCG_TIS_ST33ZP24=y
CONFIG_TCG_TIS_ST33ZP24_I2C=y
CONFIG_TCG_TIS_ST33ZP24_SPI=y
CONFIG_TELCLOCK=y
CONFIG_XILLYBUS_CLASS=y
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_OF=y
# CONFIG_XILLYUSB is not set
CONFIG_RANDOM_TRUST_CPU=y
CONFIG_RANDOM_TRUST_BOOTLOADER=y
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_GPMUX=y
CONFIG_I2C_MUX_LTC4306=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_MUX_PINCTRL is not set
CONFIG_I2C_MUX_REG=y
CONFIG_I2C_DEMUX_PINCTRL=y
# CONFIG_I2C_MUX_MLXCPLD is not set
# end of Multiplexer I2C Chip support

# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set
# end of I2C Algorithms

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_AMD_MP2 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_EMEV2=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_GPIO_FAULT_INJECTOR is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
CONFIG_I2C_RK3X=y
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_DLN2=y
CONFIG_I2C_CP2615=y
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PCI1XXXX is not set
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
CONFIG_I2C_TAOS_EVM=y
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

# CONFIG_I2C_STUB is not set
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=y
CONFIG_I2C_SLAVE_TESTUNIT=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

CONFIG_I3C=y
CONFIG_CDNS_I3C_MASTER=y
# CONFIG_DW_I3C_MASTER is not set
CONFIG_SVC_I3C_MASTER=y
# CONFIG_MIPI_I3C_HCI is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y
CONFIG_SPI_MEM=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ALTERA_CORE=y
CONFIG_SPI_ALTERA_DFL=y
CONFIG_SPI_AXI_SPI_ENGINE=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_CADENCE=y
CONFIG_SPI_CADENCE_QUADSPI=y
# CONFIG_SPI_CADENCE_XSPI is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_DLN2 is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_INTEL_PCI is not set
# CONFIG_SPI_INTEL_PLATFORM is not set
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_FSL_LIB=y
CONFIG_SPI_FSL_SPI=y
# CONFIG_SPI_MICROCHIP_CORE is not set
# CONFIG_SPI_MICROCHIP_CORE_QSPI is not set
# CONFIG_SPI_LANTIQ_SSC is not set
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
CONFIG_SPI_ROCKCHIP=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_SIFIVE=y
CONFIG_SPI_MXIC=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_ZYNQMP_GQSPI=y
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
CONFIG_SPI_MUX=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
CONFIG_SPI_TLE62X0=y
CONFIG_SPI_SLAVE=y
# CONFIG_SPI_SLAVE_TIME is not set
CONFIG_SPI_SLAVE_SYSTEM_CONTROL=y
CONFIG_SPI_DYNAMIC=y
CONFIG_SPMI=y
# CONFIG_SPMI_HISI3670 is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
# CONFIG_DP83640_PHY is not set
CONFIG_PTP_1588_CLOCK_INES=y
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_PTP_1588_CLOCK_KVM=y
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
CONFIG_PTP_1588_CLOCK_IDTCM=y
# CONFIG_PTP_1588_CLOCK_VMW is not set
# CONFIG_PTP_1588_CLOCK_OCP is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_GENERIC_PINCTRL_GROUPS=y
CONFIG_PINMUX=y
CONFIG_GENERIC_PINMUX_FUNCTIONS=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_CY8C95X0 is not set
CONFIG_PINCTRL_DA9062=y
CONFIG_PINCTRL_EQUILIBRIUM=y
CONFIG_PINCTRL_MAX77620=y
# CONFIG_PINCTRL_MCP23S08 is not set
CONFIG_PINCTRL_MICROCHIP_SGPIO=y
CONFIG_PINCTRL_OCELOT=y
CONFIG_PINCTRL_SINGLE=y
CONFIG_PINCTRL_STMFX=y
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_MADERA=y
CONFIG_PINCTRL_CS47L35=y
CONFIG_PINCTRL_CS47L90=y
CONFIG_PINCTRL_CS47L92=y

#
# Intel pinctrl drivers
#
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
# CONFIG_PINCTRL_ALDERLAKE is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_METEORLAKE is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_PINCTRL_TIGERLAKE is not set
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
# CONFIG_GPIO_CDEV_V1 is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_74XX_MMIO is not set
# CONFIG_GPIO_ALTERA is not set
# CONFIG_GPIO_AMDPT is not set
CONFIG_GPIO_CADENCE=y
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
CONFIG_GPIO_FTGPIO010=y
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_GRGPIO is not set
# CONFIG_GPIO_HLWD is not set
CONFIG_GPIO_LOGICVC=y
CONFIG_GPIO_MB86S7X=y
CONFIG_GPIO_MENZ127=y
# CONFIG_GPIO_SIFIVE is not set
# CONFIG_GPIO_SIOX is not set
CONFIG_GPIO_SYSCON=y
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_XILINX=y
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_I8255=y
CONFIG_GPIO_104_DIO_48E=y
# CONFIG_GPIO_104_IDIO_16 is not set
CONFIG_GPIO_104_IDI_48=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_GPIO_MM=y
CONFIG_GPIO_IT87=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_WINBOND=y
CONFIG_GPIO_WS16C48=y
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADNP is not set
CONFIG_GPIO_GW_PLD=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_TPIC2810=y
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_BD71815=y
CONFIG_GPIO_BD71828=y
# CONFIG_GPIO_BD9571MWV is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_DLN2=y
CONFIG_GPIO_LP873X=y
# CONFIG_GPIO_LP87565 is not set
CONFIG_GPIO_MADERA=y
CONFIG_GPIO_MAX77620=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65086=y
# CONFIG_GPIO_TPS6586X is not set
# CONFIG_GPIO_TPS65910 is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TQMX86=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_UCB1400=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# CONFIG_GPIO_SODAVILLE is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
CONFIG_GPIO_74X164=y
CONFIG_GPIO_MAX3191X=y
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_PISOSR=y
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
CONFIG_GPIO_AGGREGATOR=y
CONFIG_GPIO_MOCKUP=y
# CONFIG_GPIO_VIRTIO is not set
# CONFIG_GPIO_SIM is not set
# end of Virtual GPIO drivers

CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y
CONFIG_W1_MASTER_SGI=y
# end of 1-wire Bus Masters

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2405=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2805=y
# CONFIG_W1_SLAVE_DS2430 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2438 is not set
CONFIG_W1_SLAVE_DS250X=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_DS28E17=y
# end of 1-wire Slaves

# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_POWER_SUPPLY_HWMON is not set
# CONFIG_PDA_POWER is not set
# CONFIG_IP5XXX_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_ACT8945A is not set
CONFIG_BATTERY_CW2015=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=y
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
CONFIG_MANAGER_SBS=y
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_BATTERY_MAX1721X is not set
# CONFIG_CHARGER_88PM860X is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_LT3651=y
# CONFIG_CHARGER_LTC4162L is not set
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_DETECTOR_MAX14656=y
CONFIG_CHARGER_MAX77693=y
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24257=y
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
CONFIG_CHARGER_BQ25890=y
CONFIG_CHARGER_BQ25980=y
CONFIG_CHARGER_BQ256XX=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_BATTERY_RT5033 is not set
CONFIG_CHARGER_RT9455=y
CONFIG_CHARGER_UCS1002=y
CONFIG_CHARGER_BD99954=y
# CONFIG_BATTERY_UG3105 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM1177=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_AHT10=y
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_CORSAIR_CPRO=y
# CONFIG_SENSORS_CORSAIR_PSU is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DELL_SMM=y
CONFIG_I8K=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_GSC is not set
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_FTSTEUTATES=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC2947=y
# CONFIG_SENSORS_LTC2947_I2C is not set
CONFIG_SENSORS_LTC2947_SPI=y
CONFIG_SENSORS_LTC2990=y
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX31722 is not set
CONFIG_SENSORS_MAX31730=y
# CONFIG_SENSORS_MAX31760 is not set
# CONFIG_SENSORS_MAX6620 is not set
CONFIG_SENSORS_MAX6621=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MAX31790=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_MLXREG_FAN is not set
CONFIG_SENSORS_TC654=y
# CONFIG_SENSORS_TPS23861 is not set
CONFIG_SENSORS_MR75203=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NCT6775_I2C is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_BEL_PFE=y
CONFIG_SENSORS_BPA_RS600=y
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
CONFIG_SENSORS_FSP_3Y=y
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
CONFIG_SENSORS_INSPUR_IPSPS=y
CONFIG_SENSORS_IR35221=y
CONFIG_SENSORS_IR36021=y
CONFIG_SENSORS_IR38064=y
# CONFIG_SENSORS_IR38064_REGULATOR is not set
CONFIG_SENSORS_IRPS5401=y
CONFIG_SENSORS_ISL68137=y
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LT7182S is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_LTC2978_REGULATOR=y
CONFIG_SENSORS_LTC3815=y
CONFIG_SENSORS_MAX15301=y
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX16601=y
CONFIG_SENSORS_MAX20730=y
CONFIG_SENSORS_MAX20751=y
CONFIG_SENSORS_MAX31785=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_MP2888=y
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP5023 is not set
CONFIG_SENSORS_PIM4328=y
# CONFIG_SENSORS_PLI1209BC is not set
CONFIG_SENSORS_PM6764TR=y
CONFIG_SENSORS_PXE1610=y
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
CONFIG_SENSORS_TPS40422=y
CONFIG_SENSORS_TPS53679=y
# CONFIG_SENSORS_TPS546D24 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_XDPE152 is not set
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SBTSI=y
CONFIG_SENSORS_SBRMI=y
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SHT3x=y
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC2305 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_STTS751=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_INA238 is not set
CONFIG_SENSORS_INA3221=y
CONFIG_SENSORS_TC74=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
# CONFIG_SENSORS_TMP108 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83773G is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_INTEL_M10_BMC_HWMON is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_OF is not set
# CONFIG_THERMAL_WRITABLE_TRIPS is not set
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_THERMAL_MMIO=y
CONFIG_MAX77620_THERMAL=y
CONFIG_DA9062_THERMAL=y

#
# Intel thermal drivers
#
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
# CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is not set
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
CONFIG_WATCHDOG_PRETIMEOUT_GOV=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_SEL=m
CONFIG_WATCHDOG_PRETIMEOUT_GOV_NOOP=y
# CONFIG_WATCHDOG_PRETIMEOUT_GOV_PANIC is not set
CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_NOOP=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_SOFT_WATCHDOG_PRETIMEOUT is not set
CONFIG_DA9055_WATCHDOG=y
# CONFIG_DA9062_WATCHDOG is not set
CONFIG_GPIO_WATCHDOG=y
CONFIG_GPIO_WATCHDOG_ARCH_INITCALL=y
CONFIG_MENZ069_WATCHDOG=y
# CONFIG_WDAT_WDT is not set
CONFIG_WM831X_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
CONFIG_ZIIRAVE_WATCHDOG=y
CONFIG_RAVE_SP_WATCHDOG=y
# CONFIG_MLX_WDT is not set
CONFIG_CADENCE_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_MAX63XX_WATCHDOG=y
CONFIG_MAX77620_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
CONFIG_STPMIC1_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_EBC_C384_WDT=y
# CONFIG_EXAR_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
CONFIG_TQMX86_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_ACT8945A=y
CONFIG_MFD_AS3711=y
# CONFIG_MFD_AS3722 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_ATMEL_FLEXCOM=y
CONFIG_MFD_ATMEL_HLCDC=y
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_BD9571MWV=y
# CONFIG_MFD_AXP20X_I2C is not set
CONFIG_MFD_MADERA=y
# CONFIG_MFD_MADERA_I2C is not set
CONFIG_MFD_MADERA_SPI=y
# CONFIG_MFD_CS47L15 is not set
CONFIG_MFD_CS47L35=y
# CONFIG_MFD_CS47L85 is not set
CONFIG_MFD_CS47L90=y
CONFIG_MFD_CS47L92=y
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9062=y
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
CONFIG_MFD_DLN2=y
CONFIG_MFD_GATEWORKS_GSC=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_MFD_MP2629 is not set
CONFIG_MFD_HI6421_PMIC=y
CONFIG_MFD_HI6421_SPMI=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_INTEL_LPSS_ACPI is not set
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_IQS62X=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77620=y
# CONFIG_MFD_MAX77650 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX77714 is not set
CONFIG_MFD_MAX77843=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6370 is not set
CONFIG_MFD_MT6397=y
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_MFD_OCELOT is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_CPCAP=y
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_NTXEC=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_UCB1400_CORE=y
# CONFIG_MFD_SY7636A is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
CONFIG_MFD_RT5033=y
# CONFIG_MFD_RT5120 is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_RK808 is not set
# CONFIG_MFD_RN5T618 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
# CONFIG_STMPE_SPI is not set
# end of STMicroelectronics STMPE Interface Drivers

CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65086=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TI_LP873X=y
CONFIG_MFD_TI_LP87565=y
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
CONFIG_MFD_TQMX86=y
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_LOCHNAGAR is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_ROHM_BD718XX=y
CONFIG_MFD_ROHM_BD71828=y
# CONFIG_MFD_ROHM_BD957XMUF is not set
CONFIG_MFD_STPMIC1=y
CONFIG_MFD_STMFX=y
CONFIG_MFD_ATC260X=y
CONFIG_MFD_ATC260X_I2C=y
CONFIG_MFD_QCOM_PM8008=y
CONFIG_RAVE_SP_CORE=y
CONFIG_MFD_INTEL_M10_BMC=y
CONFIG_MFD_RSMU_I2C=y
# CONFIG_MFD_RSMU_SPI is not set
# end of Multifunction device drivers

CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PG86X=y
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_ACT8945A=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_ARIZONA_LDO1=y
CONFIG_REGULATOR_ARIZONA_MICSUPP=y
# CONFIG_REGULATOR_AS3711 is not set
# CONFIG_REGULATOR_ATC260X is not set
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_BD71815=y
CONFIG_REGULATOR_BD71828=y
CONFIG_REGULATOR_BD718XX=y
CONFIG_REGULATOR_BD9571MWV=y
CONFIG_REGULATOR_CPCAP=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9062=y
CONFIG_REGULATOR_DA9121=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_DA9211 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_FAN53880 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_HI6421=y
# CONFIG_REGULATOR_HI6421V530 is not set
CONFIG_REGULATOR_HI6421V600=y
# CONFIG_REGULATOR_ISL9305 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP873X is not set
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP87565 is not set
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_LTC3676 is not set
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX77620=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8893=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX20086 is not set
# CONFIG_REGULATOR_MAX77693 is not set
# CONFIG_REGULATOR_MAX77826 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_MCP16502=y
CONFIG_REGULATOR_MP5416=y
# CONFIG_REGULATOR_MP8859 is not set
# CONFIG_REGULATOR_MP886X is not set
CONFIG_REGULATOR_MPQ7920=y
CONFIG_REGULATOR_MT6311=y
# CONFIG_REGULATOR_MT6315 is not set
CONFIG_REGULATOR_MT6323=y
# CONFIG_REGULATOR_MT6331 is not set
# CONFIG_REGULATOR_MT6332 is not set
CONFIG_REGULATOR_MT6358=y
# CONFIG_REGULATOR_MT6359 is not set
CONFIG_REGULATOR_MT6397=y
CONFIG_REGULATOR_PCA9450=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PF8X00=y
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_PV88060 is not set
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=y
CONFIG_REGULATOR_QCOM_SPMI=y
CONFIG_REGULATOR_QCOM_USB_VBUS=y
CONFIG_REGULATOR_RASPBERRYPI_TOUCHSCREEN_ATTINY=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_ROHM=y
# CONFIG_REGULATOR_RT4801 is not set
CONFIG_REGULATOR_RT5033=y
# CONFIG_REGULATOR_RT5190A is not set
# CONFIG_REGULATOR_RT5759 is not set
CONFIG_REGULATOR_RT6160=y
CONFIG_REGULATOR_RT6245=y
# CONFIG_REGULATOR_RTQ2134 is not set
# CONFIG_REGULATOR_RTMV20 is not set
CONFIG_REGULATOR_RTQ6752=y
CONFIG_REGULATOR_S2MPA01=y
# CONFIG_REGULATOR_S2MPS11 is not set
# CONFIG_REGULATOR_S5M8767 is not set
CONFIG_REGULATOR_SLG51000=y
# CONFIG_REGULATOR_STPMIC1 is not set
# CONFIG_REGULATOR_SY8106A is not set
CONFIG_REGULATOR_SY8824X=y
CONFIG_REGULATOR_SY8827N=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS6286X is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65086=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65132=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS65912=y
# CONFIG_REGULATOR_VCTRL is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_QCOM_LABIBB is not set
# CONFIG_RC_CORE is not set
CONFIG_CEC_CORE=y
CONFIG_CEC_NOTIFIER=y

#
# CEC support
#
CONFIG_MEDIA_CEC_SUPPORT=y
CONFIG_CEC_CH7322=y
# CONFIG_USB_PULSE8_CEC is not set
CONFIG_USB_RAINSHADOW_CEC=y
# end of CEC support

# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_MIPI_DBI=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DEBUG_MM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_DEBUG_MODESET_LOCK=y
# CONFIG_DRM_FBDEV_EMULATION is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_DP_AUX_BUS=y
CONFIG_DRM_DISPLAY_HELPER=y
CONFIG_DRM_DISPLAY_DP_HELPER=y
CONFIG_DRM_DISPLAY_HDCP_HELPER=y
CONFIG_DRM_DISPLAY_HDMI_HELPER=y
# CONFIG_DRM_DP_AUX_CHARDEV is not set
CONFIG_DRM_DP_CEC=y
CONFIG_DRM_GEM_DMA_HELPER=y
CONFIG_DRM_GEM_SHMEM_HELPER=y
CONFIG_DRM_SCHED=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_I2C_NXP_TDA9950=y
# end of I2C encoder or helper chips

#
# ARM devices
#
CONFIG_DRM_KOMEDA=y
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_RCAR_DW_HDMI=y
# CONFIG_DRM_RCAR_USE_LVDS is not set
# CONFIG_DRM_RCAR_MIPI_DSI is not set
# CONFIG_DRM_QXL is not set
CONFIG_DRM_VIRTIO_GPU=y
CONFIG_DRM_PANEL=y

#
# Display Panels
#
CONFIG_DRM_PANEL_ABT_Y030XX067A=y
CONFIG_DRM_PANEL_ARM_VERSATILE=y
CONFIG_DRM_PANEL_ASUS_Z00T_TM5P5_NT35596=y
# CONFIG_DRM_PANEL_BOE_BF060Y8M_AJ0 is not set
CONFIG_DRM_PANEL_BOE_HIMAX8279D=y
# CONFIG_DRM_PANEL_BOE_TV101WUM_NL6 is not set
CONFIG_DRM_PANEL_DSI_CM=y
CONFIG_DRM_PANEL_LVDS=y
CONFIG_DRM_PANEL_SIMPLE=y
# CONFIG_DRM_PANEL_EDP is not set
# CONFIG_DRM_PANEL_EBBG_FT8719 is not set
CONFIG_DRM_PANEL_ELIDA_KD35T133=y
CONFIG_DRM_PANEL_FEIXIN_K101_IM2BA02=y
# CONFIG_DRM_PANEL_FEIYANG_FY07024DI26A30D is not set
CONFIG_DRM_PANEL_ILITEK_IL9322=y
CONFIG_DRM_PANEL_ILITEK_ILI9341=y
CONFIG_DRM_PANEL_ILITEK_ILI9881C=y
CONFIG_DRM_PANEL_INNOLUX_EJ030NA=y
CONFIG_DRM_PANEL_INNOLUX_P079ZCA=y
CONFIG_DRM_PANEL_JDI_LT070ME05000=y
# CONFIG_DRM_PANEL_JDI_R63452 is not set
# CONFIG_DRM_PANEL_KHADAS_TS050 is not set
# CONFIG_DRM_PANEL_KINGDISPLAY_KD097D04 is not set
CONFIG_DRM_PANEL_LEADTEK_LTK050H3146W=y
# CONFIG_DRM_PANEL_LEADTEK_LTK500HD1829 is not set
# CONFIG_DRM_PANEL_SAMSUNG_LD9040 is not set
# CONFIG_DRM_PANEL_LG_LB035Q02 is not set
CONFIG_DRM_PANEL_LG_LG4573=y
CONFIG_DRM_PANEL_NEC_NL8048HL11=y
# CONFIG_DRM_PANEL_NEWVISION_NV3052C is not set
CONFIG_DRM_PANEL_NOVATEK_NT35510=y
# CONFIG_DRM_PANEL_NOVATEK_NT35560 is not set
# CONFIG_DRM_PANEL_NOVATEK_NT35950 is not set
CONFIG_DRM_PANEL_NOVATEK_NT36672A=y
CONFIG_DRM_PANEL_NOVATEK_NT39016=y
# CONFIG_DRM_PANEL_MANTIX_MLAF057WE51 is not set
CONFIG_DRM_PANEL_OLIMEX_LCD_OLINUXINO=y
# CONFIG_DRM_PANEL_ORISETECH_OTM8009A is not set
CONFIG_DRM_PANEL_OSD_OSD101T2587_53TS=y
CONFIG_DRM_PANEL_PANASONIC_VVX10F034N00=y
CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN=y
CONFIG_DRM_PANEL_RAYDIUM_RM67191=y
CONFIG_DRM_PANEL_RAYDIUM_RM68200=y
CONFIG_DRM_PANEL_RONBO_RB070D30=y
# CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20 is not set
# CONFIG_DRM_PANEL_SAMSUNG_DB7430 is not set
CONFIG_DRM_PANEL_SAMSUNG_S6D16D0=y
# CONFIG_DRM_PANEL_SAMSUNG_S6D27A1 is not set
# CONFIG_DRM_PANEL_SAMSUNG_S6E3HA2 is not set
# CONFIG_DRM_PANEL_SAMSUNG_S6E63J0X03 is not set
# CONFIG_DRM_PANEL_SAMSUNG_S6E63M0 is not set
CONFIG_DRM_PANEL_SAMSUNG_S6E88A0_AMS452EF01=y
CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0=y
CONFIG_DRM_PANEL_SAMSUNG_SOFEF00=y
CONFIG_DRM_PANEL_SEIKO_43WVF1G=y
CONFIG_DRM_PANEL_SHARP_LQ101R1SX01=y
# CONFIG_DRM_PANEL_SHARP_LS037V7DW01 is not set
CONFIG_DRM_PANEL_SHARP_LS043T1LE01=y
# CONFIG_DRM_PANEL_SHARP_LS060T1SX01 is not set
# CONFIG_DRM_PANEL_SITRONIX_ST7701 is not set
# CONFIG_DRM_PANEL_SITRONIX_ST7703 is not set
CONFIG_DRM_PANEL_SITRONIX_ST7789V=y
CONFIG_DRM_PANEL_SONY_ACX565AKM=y
# CONFIG_DRM_PANEL_SONY_TULIP_TRULY_NT35521 is not set
# CONFIG_DRM_PANEL_TDO_TL070WSH30 is not set
CONFIG_DRM_PANEL_TPO_TD028TTEC1=y
CONFIG_DRM_PANEL_TPO_TD043MTEA1=y
# CONFIG_DRM_PANEL_TPO_TPG110 is not set
CONFIG_DRM_PANEL_TRULY_NT35597_WQXGA=y
# CONFIG_DRM_PANEL_VISIONOX_RM69299 is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# CONFIG_DRM_PANEL_XINPENG_XPP055C272 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_CDNS_DSI is not set
CONFIG_DRM_CHIPONE_ICN6211=y
CONFIG_DRM_CHRONTEL_CH7033=y
CONFIG_DRM_DISPLAY_CONNECTOR=y
# CONFIG_DRM_ITE_IT6505 is not set
CONFIG_DRM_LONTIUM_LT8912B=y
# CONFIG_DRM_LONTIUM_LT9211 is not set
# CONFIG_DRM_LONTIUM_LT9611 is not set
CONFIG_DRM_LONTIUM_LT9611UXC=y
# CONFIG_DRM_ITE_IT66121 is not set
CONFIG_DRM_LVDS_CODEC=y
CONFIG_DRM_MEGACHIPS_STDPXXXX_GE_B850V3_FW=y
CONFIG_DRM_NWL_MIPI_DSI=y
CONFIG_DRM_NXP_PTN3460=y
CONFIG_DRM_PARADE_PS8622=y
# CONFIG_DRM_PARADE_PS8640 is not set
# CONFIG_DRM_SIL_SII8620 is not set
CONFIG_DRM_SII902X=y
CONFIG_DRM_SII9234=y
CONFIG_DRM_SIMPLE_BRIDGE=y
CONFIG_DRM_THINE_THC63LVD1024=y
# CONFIG_DRM_TOSHIBA_TC358762 is not set
CONFIG_DRM_TOSHIBA_TC358764=y
CONFIG_DRM_TOSHIBA_TC358767=y
CONFIG_DRM_TOSHIBA_TC358768=y
# CONFIG_DRM_TOSHIBA_TC358775 is not set
# CONFIG_DRM_TI_DLPC3433 is not set
CONFIG_DRM_TI_TFP410=y
# CONFIG_DRM_TI_SN65DSI83 is not set
CONFIG_DRM_TI_SN65DSI86=y
CONFIG_DRM_TI_TPD12S015=y
CONFIG_DRM_ANALOGIX_ANX6345=y
CONFIG_DRM_ANALOGIX_ANX78XX=y
CONFIG_DRM_ANALOGIX_DP=y
CONFIG_DRM_ANALOGIX_ANX7625=y
# CONFIG_DRM_I2C_ADV7511 is not set
# CONFIG_DRM_CDNS_MHDP8546 is not set
CONFIG_DRM_DW_HDMI=y
# CONFIG_DRM_DW_HDMI_AHB_AUDIO is not set
# CONFIG_DRM_DW_HDMI_I2S_AUDIO is not set
# CONFIG_DRM_DW_HDMI_GP_AUDIO is not set
# CONFIG_DRM_DW_HDMI_CEC is not set
# end of Display Interface Bridges

CONFIG_DRM_ETNAVIV=y
CONFIG_DRM_ETNAVIV_THERMAL=y
# CONFIG_DRM_LOGICVC is not set
CONFIG_DRM_MXS=y
CONFIG_DRM_MXSFB=y
# CONFIG_DRM_IMX_LCDIF is not set
CONFIG_DRM_ARCPGU=y
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_GM12U320 is not set
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_DRM_SIMPLEDRM is not set
CONFIG_TINYDRM_HX8357D=y
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
CONFIG_TINYDRM_ILI9341=y
# CONFIG_TINYDRM_ILI9486 is not set
CONFIG_TINYDRM_MI0283QT=y
CONFIG_TINYDRM_REPAPER=y
CONFIG_TINYDRM_ST7586=y
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_VBOXVIDEO is not set
CONFIG_DRM_GUD=y
# CONFIG_DRM_SSD130X is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_NOMODESET=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
CONFIG_FB_IBM_GXT4500=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
CONFIG_BACKLIGHT_RAVE_SP=y
CONFIG_BACKLIGHT_LED=y
# end of Backlight & LCD device support

CONFIG_VIDEOMODE_HELPERS=y
CONFIG_HDMI=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_PCM_ELD=y
CONFIG_SND_PCM_IEC958=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_PCM_TIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_PROC_FS is not set
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_CTL_FAST_LOOKUP=y
# CONFIG_SND_DEBUG is not set
# CONFIG_SND_CTL_INPUT_VALIDATION is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_SERIAL_GENERIC is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SE6X is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
# CONFIG_SND_HDA_INTEL is not set
# end of HD-Audio

CONFIG_SND_HDA_PREALLOC_SIZE=0
# CONFIG_SND_SPI is not set
# CONFIG_SND_USB is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_AC97_BUS=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
# CONFIG_SND_SOC_ADI is not set
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
# CONFIG_SND_SOC_AMD_RENOIR is not set
# CONFIG_SND_SOC_AMD_ACP5x is not set
# CONFIG_SND_SOC_AMD_ACP6x is not set
# CONFIG_SND_AMD_ACP_CONFIG is not set
# CONFIG_SND_SOC_AMD_ACP_COMMON is not set
# CONFIG_SND_SOC_AMD_RPL_ACP6x is not set
# CONFIG_SND_SOC_AMD_PS is not set
CONFIG_SND_ATMEL_SOC=y
# CONFIG_SND_SOC_MIKROE_PROTO is not set
CONFIG_SND_BCM63XX_I2S_WHISTLER=y
CONFIG_SND_DESIGNWARE_I2S=y
# CONFIG_SND_DESIGNWARE_PCM is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
CONFIG_SND_SOC_FSL_SAI=y
# CONFIG_SND_SOC_FSL_MQS is not set
CONFIG_SND_SOC_FSL_AUDMIX=y
# CONFIG_SND_SOC_FSL_SSI is not set
CONFIG_SND_SOC_FSL_SPDIF=y
CONFIG_SND_SOC_FSL_ESAI=y
CONFIG_SND_SOC_FSL_MICFIL=y
CONFIG_SND_SOC_FSL_XCVR=y
CONFIG_SND_SOC_FSL_UTILS=y
CONFIG_SND_SOC_FSL_RPMSG=y
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

CONFIG_SND_I2S_HI6210_I2S=y
# CONFIG_SND_SOC_IMG is not set
# CONFIG_SND_SOC_INTEL_SST_TOPLEVEL is not set
# CONFIG_SND_SOC_INTEL_AVS is not set
# CONFIG_SND_SOC_MTK_BTCVSD is not set
CONFIG_SND_SOC_SOF_TOPLEVEL=y
# CONFIG_SND_SOC_SOF_PCI is not set
# CONFIG_SND_SOC_SOF_ACPI is not set
CONFIG_SND_SOC_SOF_OF=y
# CONFIG_SND_SOC_SOF_AMD_TOPLEVEL is not set
# CONFIG_SND_SOC_SOF_INTEL_TOPLEVEL is not set

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

# CONFIG_SND_SOC_XILINX_I2S is not set
CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER=y
CONFIG_SND_SOC_XILINX_SPDIF=y
CONFIG_SND_SOC_XTFPGA_I2S=y
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_AC97_CODEC=y
CONFIG_SND_SOC_ADAU_UTILS=y
CONFIG_SND_SOC_ADAU1372=y
# CONFIG_SND_SOC_ADAU1372_I2C is not set
CONFIG_SND_SOC_ADAU1372_SPI=y
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_ADAU17X1=y
CONFIG_SND_SOC_ADAU1761=y
# CONFIG_SND_SOC_ADAU1761_I2C is not set
CONFIG_SND_SOC_ADAU1761_SPI=y
CONFIG_SND_SOC_ADAU7002=y
CONFIG_SND_SOC_ADAU7118=y
# CONFIG_SND_SOC_ADAU7118_HW is not set
CONFIG_SND_SOC_ADAU7118_I2C=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_AK4118=y
# CONFIG_SND_SOC_AK4375 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
CONFIG_SND_SOC_AK4642=y
CONFIG_SND_SOC_AK5386=y
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_AW8738 is not set
CONFIG_SND_SOC_BD28623=y
CONFIG_SND_SOC_BT_SCO=y
# CONFIG_SND_SOC_CPCAP is not set
CONFIG_SND_SOC_CS35L32=y
# CONFIG_SND_SOC_CS35L33 is not set
CONFIG_SND_SOC_CS35L34=y
CONFIG_SND_SOC_CS35L35=y
# CONFIG_SND_SOC_CS35L36 is not set
# CONFIG_SND_SOC_CS35L41_SPI is not set
# CONFIG_SND_SOC_CS35L41_I2C is not set
# CONFIG_SND_SOC_CS35L45_SPI is not set
# CONFIG_SND_SOC_CS35L45_I2C is not set
CONFIG_SND_SOC_CS42L42_CORE=y
CONFIG_SND_SOC_CS42L42=y
CONFIG_SND_SOC_CS42L51=y
CONFIG_SND_SOC_CS42L51_I2C=y
# CONFIG_SND_SOC_CS42L52 is not set
CONFIG_SND_SOC_CS42L56=y
CONFIG_SND_SOC_CS42L73=y
# CONFIG_SND_SOC_CS42L83 is not set
CONFIG_SND_SOC_CS4234=y
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CS4271_I2C=y
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
CONFIG_SND_SOC_CS43130=y
CONFIG_SND_SOC_CS4341=y
CONFIG_SND_SOC_CS4349=y
CONFIG_SND_SOC_CS53L30=y
CONFIG_SND_SOC_CX2072X=y
CONFIG_SND_SOC_DA7213=y
# CONFIG_SND_SOC_DMIC is not set
CONFIG_SND_SOC_HDMI_CODEC=y
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES8316=y
# CONFIG_SND_SOC_ES8326 is not set
CONFIG_SND_SOC_ES8328=y
CONFIG_SND_SOC_ES8328_I2C=y
# CONFIG_SND_SOC_ES8328_SPI is not set
CONFIG_SND_SOC_GTM601=y
# CONFIG_SND_SOC_HDA is not set
CONFIG_SND_SOC_ICS43432=y
# CONFIG_SND_SOC_INNO_RK3036 is not set
CONFIG_SND_SOC_MAX98088=y
CONFIG_SND_SOC_MAX98357A=y
CONFIG_SND_SOC_MAX98504=y
# CONFIG_SND_SOC_MAX9867 is not set
# CONFIG_SND_SOC_MAX98927 is not set
# CONFIG_SND_SOC_MAX98520 is not set
CONFIG_SND_SOC_MAX98373=y
CONFIG_SND_SOC_MAX98373_I2C=y
CONFIG_SND_SOC_MAX98373_SDW=y
# CONFIG_SND_SOC_MAX98390 is not set
# CONFIG_SND_SOC_MAX98396 is not set
CONFIG_SND_SOC_MAX9860=y
CONFIG_SND_SOC_MSM8916_WCD_ANALOG=y
CONFIG_SND_SOC_MSM8916_WCD_DIGITAL=y
CONFIG_SND_SOC_PCM1681=y
# CONFIG_SND_SOC_PCM1789_I2C is not set
CONFIG_SND_SOC_PCM179X=y
CONFIG_SND_SOC_PCM179X_I2C=y
# CONFIG_SND_SOC_PCM179X_SPI is not set
CONFIG_SND_SOC_PCM186X=y
CONFIG_SND_SOC_PCM186X_I2C=y
# CONFIG_SND_SOC_PCM186X_SPI is not set
CONFIG_SND_SOC_PCM3060=y
CONFIG_SND_SOC_PCM3060_I2C=y
CONFIG_SND_SOC_PCM3060_SPI=y
CONFIG_SND_SOC_PCM3168A=y
CONFIG_SND_SOC_PCM3168A_I2C=y
CONFIG_SND_SOC_PCM3168A_SPI=y
CONFIG_SND_SOC_PCM5102A=y
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_PCM512x_I2C=y
# CONFIG_SND_SOC_PCM512x_SPI is not set
CONFIG_SND_SOC_RK3328=y
CONFIG_SND_SOC_RL6231=y
CONFIG_SND_SOC_RT1308_SDW=y
CONFIG_SND_SOC_RT1316_SDW=y
CONFIG_SND_SOC_RT5616=y
CONFIG_SND_SOC_RT5631=y
# CONFIG_SND_SOC_RT5640 is not set
CONFIG_SND_SOC_RT5659=y
# CONFIG_SND_SOC_RT5682_SDW is not set
CONFIG_SND_SOC_RT700=y
CONFIG_SND_SOC_RT700_SDW=y
CONFIG_SND_SOC_RT711=y
CONFIG_SND_SOC_RT711_SDW=y
CONFIG_SND_SOC_RT711_SDCA_SDW=y
CONFIG_SND_SOC_RT715=y
CONFIG_SND_SOC_RT715_SDW=y
# CONFIG_SND_SOC_RT715_SDCA_SDW is not set
# CONFIG_SND_SOC_RT9120 is not set
# CONFIG_SND_SOC_SDW_MOCKUP is not set
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_I2C=y
CONFIG_SND_SOC_SIGMADSP_REGMAP=y
CONFIG_SND_SOC_SIMPLE_AMPLIFIER=y
CONFIG_SND_SOC_SIMPLE_MUX=y
CONFIG_SND_SOC_SPDIF=y
# CONFIG_SND_SOC_SRC4XXX_I2C is not set
# CONFIG_SND_SOC_SSM2305 is not set
CONFIG_SND_SOC_SSM2518=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_SSM2602_SPI=y
CONFIG_SND_SOC_SSM2602_I2C=y
CONFIG_SND_SOC_SSM4567=y
CONFIG_SND_SOC_STA32X=y
CONFIG_SND_SOC_STA350=y
CONFIG_SND_SOC_STI_SAS=y
# CONFIG_SND_SOC_TAS2552 is not set
CONFIG_SND_SOC_TAS2562=y
CONFIG_SND_SOC_TAS2764=y
# CONFIG_SND_SOC_TAS2770 is not set
# CONFIG_SND_SOC_TAS2780 is not set
CONFIG_SND_SOC_TAS5086=y
# CONFIG_SND_SOC_TAS571X is not set
CONFIG_SND_SOC_TAS5720=y
# CONFIG_SND_SOC_TAS5805M is not set
CONFIG_SND_SOC_TAS6424=y
CONFIG_SND_SOC_TDA7419=y
CONFIG_SND_SOC_TFA9879=y
CONFIG_SND_SOC_TFA989X=y
# CONFIG_SND_SOC_TLV320ADC3XXX is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
CONFIG_SND_SOC_TLV320AIC31XX=y
CONFIG_SND_SOC_TLV320AIC32X4=y
CONFIG_SND_SOC_TLV320AIC32X4_I2C=y
CONFIG_SND_SOC_TLV320AIC32X4_SPI=y
CONFIG_SND_SOC_TLV320AIC3X=y
# CONFIG_SND_SOC_TLV320AIC3X_I2C is not set
CONFIG_SND_SOC_TLV320AIC3X_SPI=y
# CONFIG_SND_SOC_TLV320ADCX140 is not set
# CONFIG_SND_SOC_TS3A227E is not set
CONFIG_SND_SOC_TSCS42XX=y
# CONFIG_SND_SOC_TSCS454 is not set
CONFIG_SND_SOC_UDA1334=y
CONFIG_SND_SOC_WCD_MBHC=y
CONFIG_SND_SOC_WCD938X=y
CONFIG_SND_SOC_WCD938X_SDW=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8524=y
CONFIG_SND_SOC_WM8580=y
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731_I2C is not set
# CONFIG_SND_SOC_WM8731_SPI is not set
# CONFIG_SND_SOC_WM8737 is not set
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8770=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8782=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8804_I2C=y
CONFIG_SND_SOC_WM8804_SPI=y
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8940 is not set
# CONFIG_SND_SOC_WM8960 is not set
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_WM8974=y
CONFIG_SND_SOC_WM8978=y
# CONFIG_SND_SOC_WM8985 is not set
CONFIG_SND_SOC_WSA881X=y
# CONFIG_SND_SOC_WSA883X is not set
CONFIG_SND_SOC_ZL38060=y
CONFIG_SND_SOC_MAX9759=y
CONFIG_SND_SOC_MT6351=y
# CONFIG_SND_SOC_MT6358 is not set
CONFIG_SND_SOC_MT6660=y
# CONFIG_SND_SOC_NAU8315 is not set
CONFIG_SND_SOC_NAU8540=y
# CONFIG_SND_SOC_NAU8810 is not set
# CONFIG_SND_SOC_NAU8821 is not set
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=y
CONFIG_SND_SOC_TPA6130A2=y
CONFIG_SND_SOC_LPASS_MACRO_COMMON=y
CONFIG_SND_SOC_LPASS_WSA_MACRO=y
# CONFIG_SND_SOC_LPASS_VA_MACRO is not set
# CONFIG_SND_SOC_LPASS_RX_MACRO is not set
CONFIG_SND_SOC_LPASS_TX_MACRO=y
# end of CODEC drivers

CONFIG_SND_SIMPLE_CARD_UTILS=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SND_AUDIO_GRAPH_CARD=y
# CONFIG_SND_AUDIO_GRAPH_CARD2 is not set
# CONFIG_SND_TEST_COMPONENT is not set
CONFIG_SND_X86=y
CONFIG_SND_VIRTIO=y
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
# CONFIG_HID_CMEDIA is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GEMBIRD=y
# CONFIG_HID_GFRM is not set
CONFIG_HID_GLORIOUS=y
CONFIG_HID_VIVALDI_COMMON=y
CONFIG_HID_VIVALDI=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_VRC2 is not set
# CONFIG_HID_XIAOMI is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_ITE is not set
CONFIG_HID_JABRA=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LED=y
CONFIG_HID_LENOVO=y
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
CONFIG_HID_MAYFLASH=y
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NINTENDO is not set
# CONFIG_HID_NTI is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PLANTRONICS=y
# CONFIG_HID_PLAYSTATION is not set
# CONFIG_HID_PXRC is not set
# CONFIG_HID_RAZER is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SEMITEK=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_TOPRE is not set
CONFIG_HID_THINGM=y
CONFIG_HID_UDRAW_PS3=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y
# CONFIG_HID_SENSOR_CUSTOM_SENSOR is not set
CONFIG_HID_ALPS=y
# end of Special HID drivers

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
# CONFIG_USB_MOUSE is not set
# end of USB HID Boot Protocol drivers
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
CONFIG_I2C_HID_OF=y
# CONFIG_I2C_HID_OF_ELAN is not set
# CONFIG_I2C_HID_OF_GOODIX is not set
# end of I2C HID support

CONFIG_I2C_HID_CORE=y
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
CONFIG_USB_ULPI_BUS=y
CONFIG_USB_CONN_GPIO=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_FEW_INIT_RETRIES is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_PRODUCTLIST=y
CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB=y
CONFIG_USB_OTG_FSM=y
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_DBGCAP=y
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_XHCI_PCI_RENESAS=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_FSL=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_MAX3421_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_HOST=y

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
# CONFIG_USB_DWC2_PCI is not set
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_USB_DWC2_DEBUG_PERIODIC is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_PCI=y
CONFIG_USB_CHIPIDEA_MSM=y
# CONFIG_USB_CHIPIDEA_IMX is not set
CONFIG_USB_CHIPIDEA_GENERIC=y
CONFIG_USB_CHIPIDEA_TEGRA=y
CONFIG_USB_ISP1760=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1760_HOST_ROLE=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_APPLE_MFI_FASTCHARGE=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_HSIC_USB4604=y
# CONFIG_USB_LINK_LAYER_TEST is not set
CONFIG_USB_CHAOSKEY=y
# CONFIG_USB_ONBOARD_HUB is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
# CONFIG_TYPEC_UCSI is not set
CONFIG_TYPEC_TPS6598X=y
# CONFIG_TYPEC_ANX7411 is not set
# CONFIG_TYPEC_RT1719 is not set
# CONFIG_TYPEC_HD3SS3220 is not set
CONFIG_TYPEC_STUSB160X=y
# CONFIG_TYPEC_WUSB3801 is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_FSA4480 is not set
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

CONFIG_USB_ROLE_SWITCH=y
# CONFIG_USB_ROLES_INTEL_XHCI is not set
CONFIG_MMC=y
# CONFIG_PWRSEQ_EMMC is not set
CONFIG_PWRSEQ_SIMPLE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=y
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_CQHCI=y
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
CONFIG_MMC_MTK=y
# CONFIG_MMC_LITEX is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
CONFIG_LEDS_CLASS_FLASH=y
CONFIG_LEDS_CLASS_MULTICOLOR=y
CONFIG_LEDS_BRIGHTNESS_HW_CHANGED=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_AN30259A is not set
CONFIG_LEDS_AW2013=y
CONFIG_LEDS_BCM6328=y
CONFIG_LEDS_BCM6358=y
CONFIG_LEDS_CPCAP=y
# CONFIG_LEDS_CR0014114 is not set
# CONFIG_LEDS_EL15203000 is not set
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3532=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_LM3692X=y
# CONFIG_LEDS_MT6323 is not set
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP3952=y
CONFIG_LEDS_LP50XX=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA955X_GPIO=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_TLC591XX is not set
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_IS31FL319X=y
CONFIG_LEDS_IS31FL32XX=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_SYSCON=y
CONFIG_LEDS_MLXREG=y
CONFIG_LEDS_USER=y
# CONFIG_LEDS_NIC78BX is not set
CONFIG_LEDS_SPI_BYTE=y
# CONFIG_LEDS_TI_LMU_COMMON is not set
CONFIG_LEDS_TPS6105X=y
# CONFIG_LEDS_LGM is not set

#
# Flash and Torch LED drivers
#
CONFIG_LEDS_AAT1290=y
CONFIG_LEDS_AS3645A=y
# CONFIG_LEDS_KTD2692 is not set
CONFIG_LEDS_LM3601X=y
CONFIG_LEDS_MAX77693=y
CONFIG_LEDS_RT4505=y
CONFIG_LEDS_RT8515=y
# CONFIG_LEDS_SGM3140 is not set

#
# RGB LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_ACTIVITY=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_LEDS_TRIGGER_PANIC is not set
CONFIG_LEDS_TRIGGER_NETDEV=y
CONFIG_LEDS_TRIGGER_PATTERN=y
# CONFIG_LEDS_TRIGGER_AUDIO is not set
CONFIG_LEDS_TRIGGER_TTY=y

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
# CONFIG_INFINIBAND_ON_DEMAND_PAGING is not set
# CONFIG_INFINIBAND_ADDR_TRANS is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_OCRDMA is not set
CONFIG_INFINIBAND_IPOIB=y
CONFIG_INFINIBAND_IPOIB_CM=y
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
# CONFIG_SW_SYNC is not set
CONFIG_UDMABUF=y
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
CONFIG_DMABUF_HEAPS_SYSTEM=y
# CONFIG_DMABUF_HEAPS_CMA is not set
# end of DMABUF options

CONFIG_AUXDISPLAY=y
CONFIG_CHARLCD=y
CONFIG_LINEDISP=y
CONFIG_HD44780_COMMON=y
CONFIG_HD44780=y
# CONFIG_IMG_ASCII_LCD is not set
CONFIG_HT16K33=y
CONFIG_LCD2S=y
CONFIG_PARPORT_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_CHARLCD_BL_OFF is not set
# CONFIG_CHARLCD_BL_ON is not set
CONFIG_CHARLCD_BL_FLASH=y
CONFIG_PANEL=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_DFL=y
# CONFIG_VFIO is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VMGENID=y
# CONFIG_VBOXGUEST is not set
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_VDPA=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_INPUT is not set
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=y
CONFIG_VDPA=y
CONFIG_VDPA_SIM=y
CONFIG_VDPA_SIM_NET=y
# CONFIG_VDPA_SIM_BLOCK is not set
# CONFIG_VDPA_USER is not set
CONFIG_VHOST_IOTLB=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y
CONFIG_VHOST_MENU=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_VSOCK=y
# CONFIG_VHOST_VDPA is not set
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# end of Microsoft Hyper-V guest support

CONFIG_GREYBUS=y
# CONFIG_GREYBUS_ES2 is not set
CONFIG_COMEDI=y
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_BOND is not set
# CONFIG_COMEDI_TEST is not set
# CONFIG_COMEDI_PARPORT is not set
# CONFIG_COMEDI_SSV_DNP is not set
CONFIG_COMEDI_ISA_DRIVERS=y
# CONFIG_COMEDI_PCL711 is not set
CONFIG_COMEDI_PCL724=y
CONFIG_COMEDI_PCL726=y
# CONFIG_COMEDI_PCL730 is not set
CONFIG_COMEDI_PCL812=y
CONFIG_COMEDI_PCL816=y
# CONFIG_COMEDI_PCL818 is not set
# CONFIG_COMEDI_PCM3724 is not set
# CONFIG_COMEDI_AMPLC_DIO200_ISA is not set
CONFIG_COMEDI_AMPLC_PC236_ISA=y
CONFIG_COMEDI_AMPLC_PC263_ISA=y
CONFIG_COMEDI_RTI800=y
CONFIG_COMEDI_RTI802=y
CONFIG_COMEDI_DAC02=y
CONFIG_COMEDI_DAS16M1=y
# CONFIG_COMEDI_DAS08_ISA is not set
CONFIG_COMEDI_DAS16=y
# CONFIG_COMEDI_DAS800 is not set
CONFIG_COMEDI_DAS1800=y
CONFIG_COMEDI_DAS6402=y
# CONFIG_COMEDI_DT2801 is not set
# CONFIG_COMEDI_DT2811 is not set
CONFIG_COMEDI_DT2814=y
CONFIG_COMEDI_DT2815=y
CONFIG_COMEDI_DT2817=y
# CONFIG_COMEDI_DT282X is not set
# CONFIG_COMEDI_DMM32AT is not set
# CONFIG_COMEDI_FL512 is not set
CONFIG_COMEDI_AIO_AIO12_8=y
CONFIG_COMEDI_AIO_IIRO_16=y
CONFIG_COMEDI_II_PCI20KC=y
CONFIG_COMEDI_C6XDIGIO=y
# CONFIG_COMEDI_MPC624 is not set
# CONFIG_COMEDI_ADQ12B is not set
CONFIG_COMEDI_NI_AT_A2150=y
# CONFIG_COMEDI_NI_AT_AO is not set
# CONFIG_COMEDI_NI_ATMIO is not set
CONFIG_COMEDI_NI_ATMIO16D=y
# CONFIG_COMEDI_NI_LABPC_ISA is not set
# CONFIG_COMEDI_PCMAD is not set
# CONFIG_COMEDI_PCMDA12 is not set
CONFIG_COMEDI_PCMMIO=y
# CONFIG_COMEDI_PCMUIO is not set
# CONFIG_COMEDI_MULTIQ3 is not set
# CONFIG_COMEDI_S526 is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8254=y
CONFIG_COMEDI_8255=y
# CONFIG_COMEDI_8255_SA is not set
CONFIG_COMEDI_KCOMEDILIB=y
CONFIG_COMEDI_AMPLC_PC236=y
CONFIG_COMEDI_ISADMA=y
# CONFIG_COMEDI_TESTS is not set
# CONFIG_STAGING is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_ACPI is not set
CONFIG_CHROMEOS_PSTORE=y
# CONFIG_CHROMEOS_TBMC is not set
# CONFIG_CROS_EC is not set
# CONFIG_CROS_KBD_LED_BACKLIGHT is not set
# CONFIG_CHROMEOS_PRIVACY_SCREEN is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=y
# CONFIG_MLXREG_IO is not set
# CONFIG_MLXREG_LC is not set
# CONFIG_NVSW_SN2201 is not set
CONFIG_OLPC_EC=y
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_SURFACE_AGGREGATOR is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_P2SB is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_WM831X is not set
# CONFIG_LMK04832 is not set
CONFIG_COMMON_CLK_MAX77686=y
CONFIG_COMMON_CLK_MAX9485=y
CONFIG_COMMON_CLK_SI5341=y
CONFIG_COMMON_CLK_SI5351=y
# CONFIG_COMMON_CLK_SI514 is not set
CONFIG_COMMON_CLK_SI544=y
# CONFIG_COMMON_CLK_SI570 is not set
CONFIG_COMMON_CLK_CDCE706=y
CONFIG_COMMON_CLK_CDCE925=y
CONFIG_COMMON_CLK_CS2000_CP=y
CONFIG_COMMON_CLK_S2MPS11=y
# CONFIG_CLK_TWL6040 is not set
# CONFIG_COMMON_CLK_AXI_CLKGEN is not set
# CONFIG_COMMON_CLK_RS9_PCIE is not set
CONFIG_COMMON_CLK_VC5=y
# CONFIG_COMMON_CLK_VC7 is not set
CONFIG_COMMON_CLK_BD718XX=y
# CONFIG_COMMON_CLK_FIXED_MMIO is not set
# CONFIG_CLK_LGM_CGU is not set
CONFIG_XILINX_VCU=y
# CONFIG_COMMON_CLK_XLNX_CLKWZRD is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MICROCHIP_PIT64B is not set
# end of Clock Source drivers

# CONFIG_MAILBOX is not set
CONFIG_IOMMU_IOVA=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
# CONFIG_REMOTEPROC_CDEV is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
CONFIG_RPMSG=y
# CONFIG_RPMSG_CHAR is not set
# CONFIG_RPMSG_CTRL is not set
CONFIG_RPMSG_NS=y
CONFIG_RPMSG_VIRTIO=y
# end of Rpmsg drivers

CONFIG_SOUNDWIRE=y

#
# SoundWire Devices
#
# CONFIG_SOUNDWIRE_INTEL is not set
# CONFIG_SOUNDWIRE_QCOM is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
CONFIG_LITEX=y
CONFIG_LITEX_SOC_CONTROLLER=y
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
CONFIG_QCOM_QMI_HELPERS=y
# end of Qualcomm SoC drivers

CONFIG_SOC_TI=y

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_FSA9480 is not set
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_INTEL_INT3496 is not set
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_MAX3355=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX77843=y
# CONFIG_EXTCON_MAX8997 is not set
# CONFIG_EXTCON_PTN5150 is not set
# CONFIG_EXTCON_RT8973A is not set
CONFIG_EXTCON_SM5502=y
CONFIG_EXTCON_USB_GPIO=y
CONFIG_EXTCON_USBC_TUSB320=y
CONFIG_MEMORY=y
CONFIG_FPGA_DFL_EMIF=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_PWM is not set

#
# IRQ chip support
#
CONFIG_IRQCHIP=y
CONFIG_AL_FIC=y
CONFIG_MADERA_IRQ=y
# CONFIG_XILINX_INTC is not set
# end of IRQ chip support

CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_RESET_INTEL_GW=y
# CONFIG_RESET_SIMPLE is not set
CONFIG_RESET_TI_SYSCON=y
# CONFIG_RESET_TI_TPS380X is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_GENERIC_PHY_MIPI_DPHY=y
CONFIG_USB_LGM_PHY=y
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
CONFIG_BCM_KONA_USB2_PHY=y
# end of PHY drivers for Broadcom platforms

CONFIG_PHY_CADENCE_TORRENT=y
# CONFIG_PHY_CADENCE_DPHY is not set
# CONFIG_PHY_CADENCE_DPHY_RX is not set
# CONFIG_PHY_CADENCE_SIERRA is not set
CONFIG_PHY_CADENCE_SALVO=y
# CONFIG_PHY_PXA_28NM_HSIC is not set
CONFIG_PHY_PXA_28NM_USB2=y
# CONFIG_PHY_LAN966X_SERDES is not set
CONFIG_PHY_MAPPHONE_MDM6600=y
CONFIG_PHY_OCELOT_SERDES=y
CONFIG_PHY_QCOM_USB_HS=y
# CONFIG_PHY_QCOM_USB_HSIC is not set
# CONFIG_PHY_SAMSUNG_USB2 is not set
# CONFIG_PHY_TUSB1210 is not set
CONFIG_PHY_INTEL_LGM_COMBO=y
CONFIG_PHY_INTEL_LGM_EMMC=y
# end of PHY Subsystem

# CONFIG_POWERCAP is not set
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set
CONFIG_MCB_LPC=y

#
# Performance monitor support
#
# end of Performance monitor support

# CONFIG_RAS is not set
# CONFIG_USB4 is not set

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

# CONFIG_DAX is not set
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RAVE_SP_EEPROM is not set
CONFIG_NVMEM_RMEM=y
CONFIG_NVMEM_SPMI_SDAM=y
# CONFIG_NVMEM_U_BOOT_ENV is not set

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

CONFIG_FPGA=y
# CONFIG_ALTERA_PR_IP_CORE is not set
# CONFIG_FPGA_MGR_ALTERA_PS_SPI is not set
# CONFIG_FPGA_MGR_ALTERA_CVP is not set
CONFIG_FPGA_MGR_XILINX_SPI=y
CONFIG_FPGA_MGR_ICE40_SPI=y
# CONFIG_FPGA_MGR_MACHXO2_SPI is not set
CONFIG_FPGA_BRIDGE=y
CONFIG_ALTERA_FREEZE_BRIDGE=y
CONFIG_XILINX_PR_DECOUPLER=y
CONFIG_FPGA_REGION=y
# CONFIG_OF_FPGA_REGION is not set
CONFIG_FPGA_DFL=y
CONFIG_FPGA_DFL_FME=y
# CONFIG_FPGA_DFL_FME_MGR is not set
CONFIG_FPGA_DFL_FME_BRIDGE=y
CONFIG_FPGA_DFL_FME_REGION=y
CONFIG_FPGA_DFL_AFU=y
CONFIG_FPGA_DFL_NIOS_INTEL_PAC_N3000=y
# CONFIG_FPGA_DFL_PCI is not set
# CONFIG_FPGA_MGR_MICROCHIP_SPI is not set
# CONFIG_FSI is not set
CONFIG_MULTIPLEXER=y

#
# Multiplexer drivers
#
# CONFIG_MUX_ADG792A is not set
CONFIG_MUX_ADGS1408=y
CONFIG_MUX_GPIO=y
CONFIG_MUX_MMIO=y
# end of Multiplexer drivers

CONFIG_SIOX=y
# CONFIG_SIOX_BUS_GPIO is not set
# CONFIG_SLIMBUS is not set
CONFIG_INTERCONNECT=y
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_VIRTIO_FS=y
CONFIG_OVERLAY_FS=y
CONFIG_OVERLAY_FS_REDIRECT_DIR=y
CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
# CONFIG_OVERLAY_FS_INDEX is not set
CONFIG_OVERLAY_FS_METACOPY=y

#
# Caches
#
CONFIG_NETFS_SUPPORT=y
CONFIG_NETFS_STATS=y
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_DEBUG=y
# end of Caches

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_VMCORE_DEVICE_DUMP is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_CONFIGFS_FS=y
# end of Pseudo filesystems

# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=m
# CONFIG_NFS_V4_1 is not set
# CONFIG_ROOT_NFS is not set
# CONFIG_NFS_FSCACHE is not set
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFSD is not set
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
# CONFIG_SUNRPC_DEBUG is not set
CONFIG_CEPH_FS=y
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DEBUG_DUMP_KEYS=y
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SWN_UPCALL is not set
CONFIG_CIFS_FSCACHE=y
# CONFIG_CIFS_ROOT is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
# CONFIG_AFS_DEBUG_CURSOR is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEPRECATED_API is not set
# CONFIG_DLM_DEBUG is not set
CONFIG_UNICODE=y
# CONFIG_UNICODE_NORMALIZATION_SELFTEST is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_REQUEST_CACHE=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_KEY_NOTIFICATIONS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_NETWORK is not set
# CONFIG_SECURITY_INFINIBAND is not set
# CONFIG_SECURITY_PATH is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
CONFIG_FORTIFY_SOURCE=y
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
CONFIG_INIT_ON_FREE_DEFAULT_ON=y
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization

CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# CONFIG_RANDSTRUCT_PERFORMANCE is not set
# end of Kernel hardening options
# end of Security options

CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ENGINE=y
# end of Crypto core or helper

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
# CONFIG_CRYPTO_DH_RFC7919_GROUPS is not set
CONFIG_CRYPTO_ECC=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_ECDSA=y
CONFIG_CRYPTO_ECRDSA=y
CONFIG_CRYPTO_SM2=y
# CONFIG_CRYPTO_CURVE25519 is not set
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
# CONFIG_CRYPTO_ARIA is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SM4=y
# CONFIG_CRYPTO_SM4_GENERIC is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
CONFIG_CRYPTO_ADIANTUM=y
CONFIG_CRYPTO_CHACHA20=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_HCTR2 is not set
# CONFIG_CRYPTO_KEYWRAP is not set
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_NHPOLY1305=y
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
CONFIG_CRYPTO_AEGIS128=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=y
CONFIG_CRYPTO_ESSIV=y
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=y
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_POLY1305 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_SHA3 is not set
CONFIG_CRYPTO_SM3=y
# CONFIG_CRYPTO_SM3_GENERIC is not set
CONFIG_CRYPTO_STREEBOG=y
CONFIG_CRYPTO_VMAC=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_XXHASH=y
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRC64_ROCKSOFT is not set
# end of CRCs (cyclic redundancy checks)

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_842=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y
CONFIG_CRYPTO_ZSTD=y
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
# CONFIG_CRYPTO_DRBG_HASH is not set
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_KDF800108_CTR=y
# end of Random number generation

#
# Userspace interface
#
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
CONFIG_CRYPTO_USER_API_AEAD=y
# CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE is not set
# CONFIG_CRYPTO_STATS is not set
# end of Userspace interface

CONFIG_CRYPTO_HASH_INFO=y

#
# Accelerated Cryptographic Algorithms for CPU (x86)
#
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TWOFISH_586=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# end of Accelerated Cryptographic Algorithms for CPU (x86)

CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
# CONFIG_CRYPTO_DEV_QAT_C62X is not set
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCCVF is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXXVF is not set
# CONFIG_CRYPTO_DEV_QAT_C62XVF is not set
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
CONFIG_CRYPTO_DEV_CCREE=y
CONFIG_CRYPTO_DEV_AMLOGIC_GXL=y
CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS8_PRIVATE_KEY_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
# CONFIG_SIGNED_PE_FILE_VERIFICATION is not set
# CONFIG_FIPS_SIGNATURE_SELFTEST is not set

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_EXTRA_CERTIFICATE=y
CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE=4096
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_LINEAR_RANGES=y
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=y
CONFIG_PRIME_NUMBERS=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=y
CONFIG_CRYPTO_LIB_CHACHA=y
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=y
CONFIG_CRYPTO_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_DES=y
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=1
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
CONFIG_CRYPTO_LIB_POLY1305=y
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=y
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
# CONFIG_CRC64_ROCKSOFT is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=y
CONFIG_CRC4=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_XXHASH=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_DMA_CMA=y
CONFIG_DMA_PERNUMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=0
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
CONFIG_DMA_MAP_BENCHMARK=y
CONFIG_SGL_ALLOC=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_DIMLIB=y
CONFIG_LIBFDT=y
CONFIG_OID_REGISTRY=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_32=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
# end of Library routines

CONFIG_POLYNOMIAL=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
CONFIG_STACKTRACE_BUILD_ID=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DYNAMIC_DEBUG_CORE is not set
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_MISC is not set

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_AS_HAS_NON_CONST_LEB128=y
# CONFIG_DEBUG_INFO_NONE is not set
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_DWARF5 is not set
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_DEBUG_INFO_BTF=y
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_DEBUG_INFO_BTF_MODULES=y
# CONFIG_MODULE_ALLOW_BTF_MISMATCH is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_HEADERS_INSTALL=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_FRAME_POINTER=y
CONFIG_VMLINUX_MAP=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
# CONFIG_MAGIC_SYSRQ_SERIAL is not set
CONFIG_DEBUG_FS=y
# CONFIG_DEBUG_FS_ALLOW_ALL is not set
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
CONFIG_DEBUG_FS_ALLOW_NONE=y
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
CONFIG_UBSAN_UNREACHABLE=y
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# CONFIG_DEBUG_NET is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_SLUB_DEBUG=y
CONFIG_SLUB_DEBUG_ON=y
CONFIG_PAGE_OWNER=y
CONFIG_PAGE_POISONING=y
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
CONFIG_PTDUMP_CORE=y
CONFIG_PTDUMP_DEBUGFS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SHRINKER_DEBUG is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VM_PGTABLE=y
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_KMAP_LOCAL=y
CONFIG_ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP=y
CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

CONFIG_DEBUG_TIMEKEEPING=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
# CONFIG_SCF_TORTURE_TEST is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_DEBUG_MAPLE_TREE is not set
# end of Debug kernel data structures

CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_LIST is not set
CONFIG_TORTURE_TEST=m
CONFIG_RCU_SCALE_TEST=m
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_NO_PATCHABLE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_HWLAT_TRACER is not set
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_ENABLE_DEFAULT_TRACERS is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_KPROBE_EVENTS=y
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_BPF_KPROBE_OVERRIDE=y
# CONFIG_SYNTH_EVENTS is not set
# CONFIG_HIST_TRIGGERS is not set
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_RV is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y

#
# x86 Debugging
#
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_DEBUG_ENTRY=y
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_FRAME_POINTER=y
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT=y
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAULT_INJECTION_USERCOPY is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_STRSCPY is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
# CONFIG_TEST_SCANF is not set
# CONFIG_TEST_BITMAP is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_SIPHASH is not set
# CONFIG_TEST_IDA is not set
# CONFIG_TEST_LKM is not set
# CONFIG_TEST_BITOPS is not set
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
# CONFIG_TEST_BLACKHOLE_DEV is not set
# CONFIG_FIND_BIT_BENCHMARK is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_SYSCTL is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_TEST_STATIC_KEYS is not set
# CONFIG_TEST_DEBUG_VIRTUAL is not set
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_TEST_FREE_PAGES is not set
# CONFIG_TEST_FPU is not set
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
CONFIG_MEMTEST=y
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

--Z7k+UbnZoJp3f+oK
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="job-script"

#!/bin/sh

export_top_env()
{
	export suite='boot'
	export testcase='boot'
	export category='functional'
	export timeout='10m'
	export job_origin='boot.yaml'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis'
	export queue='validate'
	export testbox='vm-snb'
	export tbox_group='vm-snb'
	export branch='linus/master'
	export commit='ce48ebdd56513fa5ad9dab683a96399e00dbf464'
	export kconfig='i386-randconfig-a016-20211014'
	export repeat_to=6
	export nr_vm=300
	export submit_id='635c3e8c75763925118c6f1a'
	export job_file='/lkp/jobs/scheduled/vm-meta-285/boot-1-quantal-i386-core-20190426.cgz-ce48ebdd56513fa5ad9dab683a96399e00dbf464-20221029-75025-1hvbt5z-3.yaml'
	export id='44aafa81c412faa5e28f078f73fc48e5b47e28a8'
	export queuer_version='/zday/lkp'
	export model='qemu-system-x86_64 -enable-kvm -cpu SandyBridge'
	export nr_cpu=2
	export memory='16G'
	export need_kconfig=\{\"KVM_GUEST\"\=\>\"y\"\}
	export ssh_base_port=23032
	export kernel_cmdline='vmalloc=256M initramfs_async=0 page_owner=on'
	export rootfs='quantal-i386-core-20190426.cgz'
	export compiler='gcc-11'
	export enqueue_time='2022-10-29 04:41:49 +0800'
	export _id='635c3e8c75763925118c6f1a'
	export _rt='/result/boot/1/vm-snb/quantal-i386-core-20190426.cgz/i386-randconfig-a016-20211014/gcc-11/ce48ebdd56513fa5ad9dab683a96399e00dbf464'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/boot/1/vm-snb/quantal-i386-core-20190426.cgz/i386-randconfig-a016-20211014/gcc-11/ce48ebdd56513fa5ad9dab683a96399e00dbf464/3'
	export scheduler_version='/lkp/lkp/.src-20221027-175933'
	export arch='i386'
	export max_uptime=600
	export initrd='/osimage/quantal/quantal-i386-core-20190426.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/boot/1/vm-snb/quantal-i386-core-20190426.cgz/i386-randconfig-a016-20211014/gcc-11/ce48ebdd56513fa5ad9dab683a96399e00dbf464/3
BOOT_IMAGE=/pkg/linux/i386-randconfig-a016-20211014/gcc-11/ce48ebdd56513fa5ad9dab683a96399e00dbf464/vmlinuz-6.1.0-rc2-00093-gce48ebdd5651
branch=linus/master
job=/lkp/jobs/scheduled/vm-meta-285/boot-1-quantal-i386-core-20190426.cgz-ce48ebdd56513fa5ad9dab683a96399e00dbf464-20221029-75025-1hvbt5z-3.yaml
user=lkp
ARCH=i386
kconfig=i386-randconfig-a016-20211014
commit=ce48ebdd56513fa5ad9dab683a96399e00dbf464
vmalloc=256M initramfs_async=0 page_owner=on
initcall_debug
max_uptime=600
LKP_SERVER=internal-lkp-server
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/i386-randconfig-a016-20211014/gcc-11/ce48ebdd56513fa5ad9dab683a96399e00dbf464/modules.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-i386.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export schedule_notify_address=
	export stop_repeat_if_found='dmesg.EIP:genl_register_family'
	export kbuild_queue_analysis=1
	export meta_host='vm-meta-285'
	export kernel='/pkg/linux/i386-randconfig-a016-20211014/gcc-11/ce48ebdd56513fa5ad9dab683a96399e00dbf464/vmlinuz-6.1.0-rc2-00093-gce48ebdd5651'
	export dequeue_time='2022-10-29 04:43:28 +0800'
	export job_initrd='/lkp/jobs/scheduled/vm-meta-285/boot-1-quantal-i386-core-20190426.cgz-ce48ebdd56513fa5ad9dab683a96399e00dbf464-20221029-75025-1hvbt5z-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/one-shot/wrapper boot-slabinfo
	run_monitor $LKP_SRC/monitors/one-shot/wrapper boot-meminfo
	run_monitor $LKP_SRC/monitors/one-shot/wrapper memmap
	run_monitor $LKP_SRC/monitors/no-stdout/wrapper boot-time
	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test $LKP_SRC/tests/wrapper sleep 1
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper boot-slabinfo
	$LKP_SRC/stats/wrapper boot-meminfo
	$LKP_SRC/stats/wrapper memmap
	$LKP_SRC/stats/wrapper boot-memory
	$LKP_SRC/stats/wrapper boot-time
	$LKP_SRC/stats/wrapper kernel-size
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper sleep
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time sleep.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--Z7k+UbnZoJp3f+oK
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
A6uBFVPzCl6xxGf7AgAAAAAEWVo=

--Z7k+UbnZoJp3f+oK--
