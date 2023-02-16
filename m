Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D321699B65
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBPRjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBPRjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:39:41 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFE93B855
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 09:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676569180; x=1708105180;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HXrQeSJNEwZJmtKTMr0271JY0m5Ii43bjyN0nIFQQrU=;
  b=ePyBgFEw8QgppbtIMFyNo3tFsgdf8HutlKdWidVQLqhrpZjHApsyDpGf
   bDpsbGOOAnGR58EAXZq8QKLa1WxV+1XAHQnpg58VQUdkVa8FsGng8JIOv
   qL7dRdbstaULbEOUhqYkeZxkWmsynezUIrrwwazW2t0OvK5c/Kl38u6iD
   0E6b+7QUAQ5sCL/dt9Rw7qvyucfTiA6YAwTF909OxqxuNMQwyjSnhqHyf
   VDfLv74qag+4OxrjlxYG19iyYMLFAzSCfwVoejRHLmAwYhXpeFH0fpq2S
   eTwI3z3OOxwP8qNNFcf7nXg3WuGwJoHn+YXfInifW5H68l77mqmTWvDR6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="396454097"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="396454097"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 09:39:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="759020514"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="759020514"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Feb 2023 09:39:39 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 09:39:39 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 09:39:38 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 09:39:38 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 09:39:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7FQGETP9t/TQqabdMaciPJCKQSB0qPOspkhrb9kkon41K9wsDw1yTFr6O1mqsbHaT3rTxbw91kQKt9Gwt9T8P3fSGAVJxvOnVRKOsxpRNi6YcadoVDNhBlrv6+eOuUq9CqKuigniuB3Mb8ZSVQNIptM3W4KE42qWnnoGmKmEhhYzMinTCTYxPMgKvbWlXOfHaM0wete2xdOFjTCtX831ngEYVLo/FnNbA5OkAI7Jf/5sGI7OECccLrCR5mfvT7+O61I2LLfeLpU2oytXtB3yJCjd5mW/lkJVfBdWuSmr4Q8EkADNOAihsJAOdAwbWTvuQDWwNUhmYnkqdfziiaaxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JVKhBIg1DqC88NJPu6LrCa5rGSrHf/pMK8ZNzXHkk0=;
 b=cuYgDrBIhjej8sHTKKbIjxyzBPKZPVVyjvbo3SLak2Olh091Oi489px/E7JCAPZla73UIABjKgKkBBXdnI1MfqBObFOCupJaeJbqrMhEW4VhKPiHBiqPFL279KWGvCJ6MOzqe5xeKK4fqb9lzP7TRs9ol8sU57hx1lULndqKobp1wy07750Ywynbdw5iZtjitagAkZQ5a4InTJ7qoIhHzlHPr5RycDZpL1czof1+rknRyLJ9bCsUJF4Xjb4dYH7FbwHer0/Ywf6bCBlS1K7pQAy81a3eElEAsLV8JPhtsq7RUf/2s3GcgZPZGP7Q89Un4vI5EYB1Ecofn9iv9tA+1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY8PR11MB7946.namprd11.prod.outlook.com (2603:10b6:930:7e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 17:39:31 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 17:39:30 +0000
Message-ID: <fb59cc0a-d92b-ca16-4594-79d54d061bd7@intel.com>
Date:   Thu, 16 Feb 2023 18:38:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] net: wangxun: Implement the ndo change mtu
 interface
Content-Language: en-US
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
CC:     <netdev@vger.kernel.org>, <jiawenwu@trustnetic.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20230216084413.10089-1-mengyuanlou@net-swift.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230216084413.10089-1-mengyuanlou@net-swift.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0176.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY8PR11MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: 76061fce-be31-4a06-8d77-08db1044c23d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96aH+guHnGYmL7JGk/JQMw7oAp+dtglcpA98SkA5LSULhMoZ89FEfNrHQpkesZnzx5wKX6uWzyijxhgIre7tIRWUrLn1FeKV+FLBTWthT3D1/6wR052sRi1/rRqaF5WrvmghlORV+xGULyNHZpNzOCLXUU7ONPgeACHv2/OsOp1Pqp6t5fi79/RGBv3kVRURWhP3cfaSU1VmyHPjHOdgFCcdE2Iee6h/9gXab844/vBvrx2TYiC23mHmlXo4c9aTmPQstzyyQrqyFgB9L+njj3cTE1KaCXSkDfCtS8+HIkDlBM76Yk8csINeZoRYpwTF9ljiM4a63Sg2nWFUw5JIWjouLWixizDznCBlBQmwbotovfTLhCFrGcHwQIAMVEGfP9aJ/JC9qb6U/QAktxxUbOsDcRu+1CAV+UNuh9Ih31X734HUWO2Ug8oTna98YaJBgRuVyCP2vr1csguvm5ohYrvXYzMqjCC2i7iH79KsynaYt0kj0qWvoy/bXeg6ISM2oPJBhzARtp8+Z7t2tJT2uAVdCpARV5L7M9q2xnp885qW9qw/O1ClFEhPuSNnhT17sdqmMEFlHctGrN8rTO7HbJLLXTwg77xY3zQM0qbT1urWXRDDYkEyWH37DI0zgC83z4B9tHDctrg0rh8mTzyeWyIVdY1jyufaPwZ9jk+9tX2ZD7IVzpQVHXCkvZUl0MK+N3igqIGCqWspynImL/IV6nTW/HZcDr2NJKu3aRnqpXk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199018)(5660300002)(8936002)(2906002)(4326008)(6916009)(41300700001)(478600001)(8676002)(66476007)(66946007)(66556008)(316002)(36756003)(82960400001)(2616005)(38100700002)(83380400001)(31696002)(6486002)(86362001)(26005)(186003)(6512007)(6506007)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWpHMG96UUhsUFdPNUJsRmJNdWloS1ZYUjA3QmNQK2VyTS8xaGFDTGhCMWNK?=
 =?utf-8?B?WlRuSHVIa1RKWUFlM2RaQlROMVdUYUFKOXdvVVF5Z2NTSjBuaFY2ZnI2Nk1y?=
 =?utf-8?B?ZEliV3hLQi9XTVJHTXVqY2p4cFkwd05mUkFKVytwYjFLVlZUcWRBRElia3lh?=
 =?utf-8?B?dTk0VCtKdU1FbU4zK3Ztcm5wN25EdkllWnJvc1NyMkU0bU1WaExLSnlaVGRB?=
 =?utf-8?B?MW1KVlBrZTZxN3RmKzdGdE1GRCtnSTZJL2hmWVlYeGFGekhCUHAvbU1YWVlD?=
 =?utf-8?B?MzRiWG05Nmc1MnB4ZU5YL3ExWHFrRThIY0tmMFpoY3p2N3FJeExPUzhzZUQ1?=
 =?utf-8?B?RS9oKzVUekxKR1p6VE5PZThUUTNXSVFsRGFEWnVRL3NoZlE4U0wrRVBOcmto?=
 =?utf-8?B?dUtpbW55QURLWjV6dE5ONThVakptQ1I3VHVpMGdxVEVFYzVIT05LODRXcFBD?=
 =?utf-8?B?N1BNQ0FCUVlGdHRwcXJLaEhrMmljTzR6em1MT0trYTBnZWpFWitwQjczUjc2?=
 =?utf-8?B?STZ1N2hTTjU3eVp5OGVkNXhJUlpGTWhMQ2NibHNpQ3hhYXBZZ3lPcWNLcFBL?=
 =?utf-8?B?blY1RlVkdDhycndnRlIvY2ZtbkVFRnd3WHpab0ZmSkVoZDRvK0ZWdjlNMXBP?=
 =?utf-8?B?UVU4U29TK21yYjJhMDJtTENHUkRVeVJiUDJiSDQzMC9BZHFTTnBuVTViWHRX?=
 =?utf-8?B?UHBBZHRQMTByb1ZEaENaT1pKRkkyU0ZaMExGdTdSTHhDNCt1T3VYcWVLUEFi?=
 =?utf-8?B?ZUdHR1dmeExlQkZ3K2plcXVtQ3NPUmZDbnc4ZTRsSGtVY1J1OFZIUVdKTXFX?=
 =?utf-8?B?VHk0RHpVZ0VjVjUzRm92WCtQWitka1Z6OUNSb3U1Um5IOG5jU3AyTVFUVkNP?=
 =?utf-8?B?NldsWmc4cGxGVHRLaXd0QWl1RGh4MEpocERZdEErMFFGalFzRkN5OEh2Sis5?=
 =?utf-8?B?Um1UYU1ER1NOTUZlOG1pRUFHb3V2Mk9HT1R2azdNRnJhTVdwTWh2cmpTQUZW?=
 =?utf-8?B?b3VzczRaZEpwRjBjRGNnNlQvVjZJMkEyclRxNnJwKytNbms0NkQxM2lSSGV1?=
 =?utf-8?B?MVhZZEtkd05EbFZnT3h3aW5Hd1B3WGJDR3JyREc4ckRGcnBGZUxSVUUyOUdK?=
 =?utf-8?B?eVRnUVFNcHVTV2hiakVVQkovZ1Y3UEhLTW15Vmc4UGpUU1JMaEJ3cjN3MnVE?=
 =?utf-8?B?NEJReXZLSVRneFlMS2RQRTdNTTdSZS9Zd3dibkpxK3puUUdxNXhPSk1xVEJ6?=
 =?utf-8?B?VFF1bktMSERXc2U0QTRPSU9PMldvN3J1MkdSSithbmJ2SWVKb1g5ODl4QWhF?=
 =?utf-8?B?aWpZWTYxdG0vaTJDMnBTYUdSQUJSVGxJWVNXcjNvRzArdTB2NGFXOEZwNVBO?=
 =?utf-8?B?QS9FNTdXbHluWkU0Yzd0elVBMm1YYUNKd3Bvc2Q5dmJRSzM5SFRiOHd3Sjhn?=
 =?utf-8?B?bmNMSnJHdS9kbkVxVyt4bFZGUWtjS0lnUVpsbmZDWmhCbStDZDRmRkhtUjBl?=
 =?utf-8?B?QUNwVWg0Z1JUSmhXbFpNN0dVUGU2MmxFYU9sSGVvUWhnMGQzOTREeWtoWUpy?=
 =?utf-8?B?elNqTzlDSTdyZHpEMVNjaHVZS2ptcVg0NUVodHFSdlhEdmNVcXNmT1FYb295?=
 =?utf-8?B?dUMyWnhxSitTTUJWNjREZys0VFJoV3NDcEVZaVN5QnVwN2cvYkxIdzhSTkVn?=
 =?utf-8?B?T24xbVFIbzhCOXhObnJJWXBzZzhKOTRHOFlXWk9lNHFWbGxBdnVic0xLaWNk?=
 =?utf-8?B?TXpmVU9Zdmx3RFcyekhYb25pSjZ3N1JJeE10a3NERGExQXJKeXIvQUg4MUhT?=
 =?utf-8?B?aUR5bGc1cFRsK2pWWVZkaWhVUmp3YkR0K0hCQ0FxQjllVVBFUTNVd2VLVVlC?=
 =?utf-8?B?L0kxOWkxUVFBcFh3RmlvRHdKUm94V1pTNXlLYTNQSHVycGxrOEptMHMvbFJ3?=
 =?utf-8?B?ZUR0RGRHQXNUaWtoeWpUNWZFbnBTQjZWY1E5N2lnYmZGSFY2Z2w4TTZONE1T?=
 =?utf-8?B?c0VFdU53Rk12WGlkMlhES3NYYmRUNTRFNlZIT3dTZ1QyRm1Fd2N4TDBDRytw?=
 =?utf-8?B?SlRuUU8rbjZwUUJvT201SlRwOFk2ZWpseU1mMXdYMkNtWHVOZStiN29EbThx?=
 =?utf-8?B?ckNmNnNzbkdyc256dzVkRUZGVXZHOXplK3pSdndPd1AzNnZ1UG1mWWU2b0wr?=
 =?utf-8?Q?0jqC8Zxa/RnmOqdEjpkkmL8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76061fce-be31-4a06-8d77-08db1044c23d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 17:39:30.7253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UKdLotPrcZ2ZzFqpo6abPDn5b/P5+YUFkh1Vj866x6bev7rbl0Hq323DAemMJ32iT6f16JAwoF2WNO+bUZq6NJbf24WHdbsG4Ti3+IAhS9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7946
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

From: Mengyuan Lou <mengyuanlou@net-swift.com>
Date: Thu, 16 Feb 2023 16:44:13 +0800

> Add ngbe and txgbe ndo_change_mtu support.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_type.h  |  2 +
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 38 ++++++++++++++++++-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  1 -
>  .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 38 ++++++++++++++++++-
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 -
>  5 files changed, 76 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> index 77d8d7f1707e..2b9efd13c500 100644
> --- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
> +++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
> @@ -300,6 +300,8 @@
>  #define WX_MAX_RXD                   8192
>  #define WX_MAX_TXD                   8192
>  
> +#define WX_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */

Please use tabs.

> +
>  /* Supported Rx Buffer Sizes */
>  #define WX_RXBUFFER_256      256    /* Used for skb receive header */
>  #define WX_RXBUFFER_2K       2048
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> index 5b564d348c09..78bfaff02aad 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
> @@ -361,6 +361,15 @@ static void ngbe_up(struct wx *wx)
>  	phy_start(wx->phydev);
>  }
>  
> +static void ngbe_reinit_locked(struct wx *wx)
> +{
> +	/* prevent tx timeout */
> +	netif_trans_update(wx->netdev);

Why doing this? Your driver/device can reload for longer than 5 seconds
(default Tx timeout) or...?

> +	ngbe_down(wx);
> +	wx_configure(wx);
> +	ngbe_up(wx);
> +}
> +
>  /**
>   * ngbe_open - Called when a network interface is made active
>   * @netdev: network interface device structure
> @@ -435,6 +444,32 @@ static int ngbe_close(struct net_device *netdev)
>  	return 0;
>  }
>  
> +/**
> + * ngbe_change_mtu - Change the Maximum Transfer Unit
> + * @netdev: network interface device structure
> + * @new_mtu: new value for maximum frame size
> + *
> + * Returns 0 on success, negative on failure
> + **/
> +static int ngbe_change_mtu(struct net_device *netdev, int new_mtu)
> +{
> +	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;

You must also account `2 * VLAN_HLEN`. The difference between MTU and
frame size is `ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN`, i.e. 26 bytes.
...except for if your device doesn't handle VLANs, but I doubt so.

> +	struct wx *wx = netdev_priv(netdev);
> +
> +	if (max_frame > WX_MAX_JUMBO_FRAME_SIZE)
> +		return -EINVAL;

(Andrew already said that...)

> +
> +	netdev_info(netdev, "Changing MTU from %d to %d.\n",
> +		    netdev->mtu, new_mtu);

As Andrew already said, it's netdev_dbg() at most, but TBH I consider
this a development-time-only-debug-message that shouldn't go into the
release code.

> +
> +	/* must set new MTU before calling down or up */
> +	netdev->mtu = new_mtu;

If you look at the default implementation, you'll see that netdev->mtu
must now be accessed using READ_ONCE()/WRITE_ONCE(), so please change
accordingly. Otherwise there can be race around this field and you'll
get some unexpected results some day.

> +	if (netif_running(netdev))
> +		ngbe_reinit_locked(wx);
> +
> +	return 0;
> +}
> +
>  static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
>  {
>  	struct wx *wx = pci_get_drvdata(pdev);
> @@ -470,6 +505,7 @@ static void ngbe_shutdown(struct pci_dev *pdev)
>  static const struct net_device_ops ngbe_netdev_ops = {
>  	.ndo_open               = ngbe_open,
>  	.ndo_stop               = ngbe_close,
> +	.ndo_change_mtu         = ngbe_change_mtu,
>  	.ndo_start_xmit         = wx_xmit_frame,
>  	.ndo_set_rx_mode        = wx_set_rx_mode,
>  	.ndo_validate_addr      = eth_validate_addr,
> @@ -562,7 +598,7 @@ static int ngbe_probe(struct pci_dev *pdev,
>  	netdev->priv_flags |= IFF_SUPP_NOFCS;
>  
>  	netdev->min_mtu = ETH_MIN_MTU;
> -	netdev->max_mtu = NGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
> +	netdev->max_mtu = WX_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);

Same regarding frame size vs MTU.
Also, these braces are redundant.

>  
>  	wx->bd_number = func_nums;
>  	/* setup the private structure */
> diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> index a2351349785e..373d5af628cd 100644
> --- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> +++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
> @@ -137,7 +137,6 @@ enum NGBE_MSCA_CMD_value {
>  #define NGBE_RX_PB_SIZE				42
>  #define NGBE_MC_TBL_SIZE			128
>  #define NGBE_TDB_PB_SZ				(20 * 1024) /* 160KB Packet Buffer */
> -#define NGBE_MAX_JUMBO_FRAME_SIZE		9432 /* max payload 9414 */
>  
>  /* TX/RX descriptor defines */
>  #define NGBE_DEFAULT_TXD			512 /* default ring size */
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> index 6c0a98230557..0b09f982a2c8 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
For the second driver, the questions are the same.

Thanks,
Olek
