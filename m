Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED02B6740FC
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjASSaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjASS3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:29:53 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDB966EEA;
        Thu, 19 Jan 2023 10:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674152969; x=1705688969;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AM6JXJbuGgRER8kMr70U20+l9l3rtiAwy7pmr3sVhSU=;
  b=bgEy7wDOf3zh5y3RMnzquyohK7A/FjSHvQrijwdcboqbQqZi1rmKG2Ja
   HrDZ02sLsvDjEt9gR6KF8nvGC6nv1kBQ1jscDmZvrRns2YHHw7ae6Zw11
   O2xWP+iUzfyzgVw6i4BO+UorrHXAVOO+lXsWDXUNltC4cRmL+Oc9qhFy9
   Fyg8RXIv5RFp+4cKJGkE2hxNuFz54FJkbXHD7uLxVtpKgT8EYJpExUm9z
   07I1ozlutj3DNj3rZOueNiUt+pQDtsqqqQa6+/R+qDb4xBy3JojvevNB7
   TxMLjjTmgGP/tt0wZ7qP/3iLN92/eUQjhKaMS4d8wacf3T1+8gOSv3ZVG
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="305742845"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="305742845"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 10:29:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="749024371"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="749024371"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jan 2023 10:29:04 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 10:29:04 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 10:29:03 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 10:29:03 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 10:29:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvVevdh6Cs/LWF98vSDw+NSow4UrcwGmTq+FFowEcFmUhLO9JP+u7TTzY7Y/xHGoD5NfcP0vNGsWafiUjxxS8NKsCb7QeGu3pdisxwg0IWvn0Am47w6jJEjGPGuUHpPTqtPYMxBRpnzgNTUirrj4KSS+zP3M8BBtM0EXd1MmpYJJQqGiYaWS1s9woTleYgzp8VjqCmmA4QpjczulSbsp2ssHCR+Vwy0YYCWR6w49iAM2Vk7KF3yiOjrJeir81cIcQXa6DEWb/Rdzp9EtB+cRSScGXZcHRQ9ZCylcJoLxHcwaWNZIfwv1nEv9LyipAX3LNsalXvujxfDPTZe2ULJsBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucSFnQjHmEIuLhdNmSU6uKYpOdT41UhWrv+618o53sc=;
 b=Qar+t+YRGhm/R6bYk0//j9rJUJvThJqU0UibhIwBeKKBcd+CcBZnYw7FfN/+Y0GA+cd1ecxpndXJvOJPPeje7i1sdutT134uz9QWANujYOU5v3FCrgIhUvVhBQhEJhJXuV1OMQxEdQYz+Yv7T3sUmm+JGOJ13ppFwTJGqKnKVBLC4THRrioYJdYviplxwbqrRzHpDpIimx3W7LMCWqr1xoG3HC+371KGbNkVHbWecmp/RrBgtd1DqsfPNhc23R/6zNbWp01fQkmieHF0Ap/phgYuPDpAUBecBS/tO4v4TlKFJFtoMp35truOBg1IDJ6u/26NDOQA8z37UlYIPAToMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 18:29:01 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::4700:1fa1:1b49:1d5c%7]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 18:29:01 +0000
Message-ID: <f90837d0-810e-5772-7841-28d47c44d260@intel.com>
Date:   Thu, 19 Jan 2023 10:28:59 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 9/9] ixgbe: Remove redundant
 pci_enable_pcie_error_reporting()
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>, <linux-pci@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>
References: <20230118234612.272916-1-helgaas@kernel.org>
 <20230118234612.272916-10-helgaas@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230118234612.272916-10-helgaas@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::14) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|DS0PR11MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: ef2d48cb-5559-4556-cb99-08dafa4b092f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtxSOI6t8bN6rnKbCex9XNddRyvLASTCqNCFUdCVzLVlFb1NpZM57YQ0g5FZ2ZO2iJ7nW6rd1ClhjZHVYmPWfrJ5tATJvqvWiK9jTGOITArckzAiRscIALfQ8jk3Jg4yP3lYil+7DCkksKJkDDKdAuJSIGtPCvNhza2lnNbwFUnOsApBDsbhsPia7d6M5x+Q9mM1N6YmI5VhNXDfrot38AmYMEHrV35ae8c4F1oNXEW8dNeQ2lUSrIKqtkQZoaukEipiGFVhnAJElliVv7QBxmCeFrj8zwbh/e+zAMpG+y3rCmTxPOW7ufAHUm3kgD8JdsEaOcsbUX1tSbip89NdJJQjy3BPhnqhOcDT0+j6PRdiaUTdDfJBmII42ci/ITaImg7WVnFA9gSRjLOT2PtYlwKhGDmkdqsFrtEAVQq9l54i+yLxeUCP8rJgvZ4II4KVzCbMeCWCgxB3PfBKpzP2/7rd+9KJ4mpGv0X14CbRZ1iOjnvlf9XDXsI/f+x7URw+a5odMydgnGb3PzWX7qgfwE/Q0mpk+25szlMOs2rATOJ2ZTHWfV8c3qpTZCQDPDl8DJjfxoMIQH5fJl9S9M4EoKq14hMfG0zr5FgRtXpEjbUixoGcSX6hSQ3L3EWuFed56uM0izMq2mkpa6q9oX6Wose2EXHEtUKr8iizuaCZOGc8OiUcaMJekcWYseumMmtH6V5A0agqWxetp1yVOzlrCFBaE+ca8CzVoFMpHXff8uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(38100700002)(31696002)(36756003)(82960400001)(86362001)(31686004)(2616005)(186003)(53546011)(6506007)(6486002)(478600001)(26005)(6512007)(5660300002)(8936002)(2906002)(41300700001)(66556008)(66946007)(66476007)(54906003)(4326008)(8676002)(316002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDFVS1pyZTBicTlOWHFjNFcvNFc3Rmo3ZnFVbEx3UnNLMzRvRUJMRUM5WTVG?=
 =?utf-8?B?QWkzV25nVGhPMmZWVDYvM0c5QThwNzRGcWF3Z3JVWUpwRStwV3RxcWlGVy9J?=
 =?utf-8?B?cXphbzZ6bTJqcUp3TUE5anBGQXJVcmN6V0NjSGR3bkNuTTg5NkFHVU5lZnh4?=
 =?utf-8?B?WU1PVGp0WUxhN0xVbk5YZlhyZFAyalVHR2c4T2FxWWc4QjVadnk3cEVWYWVk?=
 =?utf-8?B?SUg1VHFaY2lCanVlaDhYMDIzK0Z6aTFQMjl5UTNVWEtCVzdsamRFTVFGZW1j?=
 =?utf-8?B?V05lc01Rd3pNRS90NjJzK3lsa1g3YUpjZ1ZvYy9HZXBOaytUL2luNEt5N3lW?=
 =?utf-8?B?UzErT2NieXNYd3RlOGhJZENBYzR2VGpVemtDeHBETGtaZklKVG9rOEpOSVVD?=
 =?utf-8?B?UHRCQU9lRFJUbzhMbVROOHgzUXBPQW5PcURXMkNPYVFnanplWnpUdWZYNHBZ?=
 =?utf-8?B?RjBEeUJ2SDFZZnJ3OTM5aERQY1Q1YlJzRlRaeHo4YzVNdVZaVGV3NHc1TnRw?=
 =?utf-8?B?czhxNi9wdnNuN0ZyS0pyeFpQelQ1MW9jamdIcXprYy93YVVFQStGcjhCcVRs?=
 =?utf-8?B?eG03TGZMNnY4emJ6Tm1HNS95dFBRU09NcGNnTmM0QlJrT2w0L1BOcUdKMFpm?=
 =?utf-8?B?YnRreldWY1lZeDNXWnRKTUF6Qk05OE1zY2lkbWZVb3I0cTQzSVJOS2RRS0Vn?=
 =?utf-8?B?ZFJacnVpQmNUaUlQcmQ5VkZoNTdxZklRbTU2dWJic2tVbGp5UDV5VkZPc0dJ?=
 =?utf-8?B?TEQwalcxRitWN1pucXd6Y0FEeUt3eFF0bjl1QXJhTUlMTkpGcHBzZkIwb0dy?=
 =?utf-8?B?d08yUEhOZzA3R25DWVZhKythTU40WjQ2cGJvVkRiaTVMaDUxYUFxZEJQZ0lq?=
 =?utf-8?B?bFlYdjQ3cFZFVWNXdlNQTGxRYVRXWElMUUxRZlQ2MTF2NElpVGpBcHB6QzlN?=
 =?utf-8?B?TFBMSG9CT3RQMWRCYjlJcDBneTFwbEIvZnJuaWd4YVJCa1dWQ3Bpd1kwV3U2?=
 =?utf-8?B?ODBndzQwcldTZ3lyU0h0Qyt0OUNXTzJZdjdadTE3QitKTjViSzdSYmpZQXNS?=
 =?utf-8?B?ZUQwbG5kMm9ZbmdMM3dZdDFyeEo1TXVTZVJTV3dSck9UODFLQmREUCtXaUR6?=
 =?utf-8?B?RklORkxOR3lqT3RySTczeUFLUjJlK0RncEhrRm5qcHVIeHNQLzcwVmlDL2lN?=
 =?utf-8?B?QTYrNmY3VmV4T3B0WEp0S3FjbHI0MEZldVVYN2loWEZFWXZMTVVIeFFsUDJS?=
 =?utf-8?B?M1FEcXVOYWJzMVp5a01GQkpKWW9oWlR2R0ltbVpyQlk3L2cxdmZ3akJXZkxH?=
 =?utf-8?B?dVVKaFl3SStIbUtWeDd0aTA5a0dmNVZmTDQzY1JiVk0wZ2FnNnhRaGFOWUhG?=
 =?utf-8?B?ZEdkMTVTWjg4TnN0TXBLTXo4Y1UxQTRteHlmaW5Bc1VDcDdvVkZKTU5oYWJl?=
 =?utf-8?B?VWhCU1Y4UkY2U1lPVkQyLzBhbnYzTk5JdlFnWUJ0bDBMRytLcWtCNE5jcHZ5?=
 =?utf-8?B?TTBiUGsxWmNCWG13VEIxMkNyRXJnUVBOYmU5c0NIb0pxSVlTalVxbWI0TVhI?=
 =?utf-8?B?THc1M1oyVFVRVWZEZHZLeE4ybFo3WW9KTkJsTWk2SnduYTdwc29PWTFlY2lz?=
 =?utf-8?B?enR5Mm5BL2gremVvM2t4MEFkYXVEMk5icnhhdnNOK0Ixd1crSEtJdXRWczBx?=
 =?utf-8?B?RGNDSVh5N3dQV3F4VFZJbXlYb3J1b0V6K0U1Sk1QcDRnS2QyenExSVFXUHk1?=
 =?utf-8?B?azFPa1laV3FyUDRQakxpb3hhR0srMHh5UFlNU1pNUVZSVVZvc2h6SFZFU0xE?=
 =?utf-8?B?bTNGc2Q2T1N5ZUtpV0ZKc3dFSFJYNEtieiszY3FIcHUzUDVtK2pLOVpWQWl1?=
 =?utf-8?B?QlYzRzhOaWw4TUZiTDEra0REbHdURmhibTdzVWh3Wmc3NGZxbW1ZeHpxU21E?=
 =?utf-8?B?ekRtYlVWZ3BuaHc3ZjZRWFBiRXlaUUtQYkxjZTdlb0NEc0xGR3Z5MnpXcEYr?=
 =?utf-8?B?ZG9oWTVianVYeEhmQXRyN21KMkpSNkc5Rjh0OEF1bG0yeG56YUd6R3Bwd1Vk?=
 =?utf-8?B?Y0lEYmI1b3BpRUk1bGk0TFAvTXRFUlZxL0Q3RzJyaVpKZ1pKdTlJOXFXR3Aw?=
 =?utf-8?B?UnA5dTFkV2V0QWIvRGJ6anh5VzVqMEJkalloOFl6MW1reGJJQnZTenVmUVN5?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef2d48cb-5559-4556-cb99-08dafa4b092f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:29:01.2308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYNNb6CO18sHxsymvIl0jDwJpDGxe/H3na2Ub5bqW1j4iyPliXJJ6Obnq2pwdcM/WP9RIqvo8ZeF1VN2cqcfhfBcJsS0GF+Ih6fPJEIOJF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7410
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

On 1/18/2023 3:46 PM, Bjorn Helgaas wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> pci_enable_pcie_error_reporting() enables the device to send ERR_*
> Messages.  Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is
> native"), the PCI core does this for all devices during enumeration.
> 
> Remove the redundant pci_enable_pcie_error_reporting() call from the
> driver.  Also remove the corresponding pci_disable_pcie_error_reporting()
> from the driver .remove() path.
> 
> Note that this doesn't control interrupt generation by the Root Port; that
> is controlled by the AER Root Error Command register, which is managed by
> the AER service driver.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 -----
>   1 file changed, 5 deletions(-)

Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>

> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..cb718c6216fc 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -10808,8 +10808,6 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   		goto err_pci_reg;
>   	}
>   
> -	pci_enable_pcie_error_reporting(pdev);
> -
>   	pci_set_master(pdev);
>   	pci_save_state(pdev);
>   
> @@ -11237,7 +11235,6 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
>   	free_netdev(netdev);
>   err_alloc_etherdev:
> -	pci_disable_pcie_error_reporting(pdev);
>   	pci_release_mem_regions(pdev);
>   err_pci_reg:
>   err_dma:
> @@ -11326,8 +11323,6 @@ static void ixgbe_remove(struct pci_dev *pdev)
>   	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
>   	free_netdev(netdev);
>   
> -	pci_disable_pcie_error_reporting(pdev);
> -
>   	if (disable_dev)
>   		pci_disable_device(pdev);
>   }
