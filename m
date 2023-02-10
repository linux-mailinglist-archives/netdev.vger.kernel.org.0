Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22E9691FAA
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 14:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjBJNUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 08:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjBJNUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 08:20:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB0457747;
        Fri, 10 Feb 2023 05:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676035208; x=1707571208;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qnfFDNBWHODfz8uTU/RLFvokxf6D+ozqB842yL2TwPE=;
  b=cTVJLuv4/sC994mJ0R/0NgYEY6iPwT3DjqjjVCjwLQZxPPVfN8AZ8dHJ
   mAm+vCYiduDiMlbOP7ESZBg/dC94hSK0CBeckPCsmsRWQaezogSZihbL4
   /U2tzttlSfjUyk7a1Gepws1gZRLukI9t589cVqdp3jUjS7FxV1HGnnZuC
   OzMHq6XrZwczD5/8ncroJYxED2ccWX4W1hB3ECzrxxsy6Ef6qyBDRxyJa
   fx8nWAUye6YUo9cTa3VoY6KpCpR3NL6+s4HekIrt49WXxRz0JCgl2fgOT
   rRt04x14sQB9mJjFKMkkIQB/o0zZX7r207SaehEXCM0YMNmmaJz/lrxK8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="357815761"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="357815761"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 05:20:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="776920101"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="776920101"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 10 Feb 2023 05:20:01 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 05:20:00 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 10 Feb 2023 05:20:00 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 10 Feb 2023 05:20:00 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 10 Feb 2023 05:20:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNzbMF6td+y24yoi6tjrG1ImHQgNUlccYjT3/LAXGzbrMX7xbymJwrzrcbDnJt83lWA+iX9igCmSTh5W0JpKUaxXR0wn1yENccIZrD09wzJITIlBbsGD+qQlHfPg3juZg1nRUC0U4pS+u0XORCLvXhG+kg+qPbB7t0psA3T3Bxgdm+Hep0cMO6TltxiZL0xQMND9P0f/uBlrROJAjzNcdv1SoeEG6gpEoeZwjlvrZyIOVt+FkP62ZP7wXZ+DfXgdJCZ5HAHmtBjo73tsJCw2NlrQ5kyjN5X/NwwvuUTx8YrViweBxDaGJJSg0Wz+sxXdcu4XuKNa1d0WWTNZ9L8Cxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ux63h9MdcgfYH9LJpR+Hvx8Qunrgax/B3gi9+UnvfJI=;
 b=ifoT8ItU3KOMsj97RbTuKnXyAs1IG8i863LXqIINlJrkvN0hYS0YyoAGPVBQqxCPT6a8CYLXa5qDZasO0yt2jEtipXYT2CsBKOPso5GW9RLUjQ1rKsCfL932AIydYGxFDcxnCahmOLxILvp5pFQRWoM2rkmiNX5mIJzS32b+yFcQcJ2mN305tlVA4g46nhlO1Ay4qAQBNiSnkk4dbe+yA7AAlfQ9YxSbonorLnDs2zAnaWnu+ZQ9tiUH5BwqUQjzOYNSx3p1h8eOhtUYtuLm7GwhnSOQemEhNhrs/beZ2FXSBvsATZDQYkUocz91WzqAQ8O14H1gaeDrCz//fco1DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3624.namprd11.prod.outlook.com (2603:10b6:a03:b1::33)
 by SJ1PR11MB6155.namprd11.prod.outlook.com (2603:10b6:a03:45e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 13:19:59 +0000
Received: from BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::e816:b8cb:7857:4ed9]) by BYAPR11MB3624.namprd11.prod.outlook.com
 ([fe80::e816:b8cb:7857:4ed9%4]) with mapi id 15.20.6064.036; Fri, 10 Feb 2023
 13:19:59 +0000
Message-ID: <734a0c9f-83e0-2c99-7130-c02feac246df@intel.com>
Date:   Fri, 10 Feb 2023 14:19:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
Content-Language: en-US
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230209172827.874728-1-alexandr.lobakin@intel.com>
 <6db57eb4-02c2-9443-b9eb-21c499142c98@intel.com> <87sffe7e00.fsf@toke.dk>
 <701f6030-72d7-0f11-173b-a2365774b6f2@intel.com>
In-Reply-To: <701f6030-72d7-0f11-173b-a2365774b6f2@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::19) To BYAPR11MB3624.namprd11.prod.outlook.com
 (2603:10b6:a03:b1::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3624:EE_|SJ1PR11MB6155:EE_
X-MS-Office365-Filtering-Correlation-Id: 683e205e-7c62-42ff-342a-08db0b698228
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xh+OudT3CuwN6VzCkVNhBtq9Wxx2wjJy5YT8Mz+K7p7UmFx41p68IVsQ16Wl20DKu1/pfvfOF+YVtdqIYDZP5YTYEdOIjlRmoVpSda8Oyo+ZzOXH3/Enqg2S2ip31D68o0tqmJ0E0EhiT/SQvuabuCqfIci637pwxMQkDrs+EJqdOUAnVct4WlE1I11vxcer+acqcwIYrN0y8h1IYNK7WL9eX23/hq028wa5JkNe8CE/Py2/9qLax5zqXKRrVu2N3p9MTG8FPmu2zwzpvMPi8W5lnUv8L64bSgcJ4Kmps6FcyO+41ssF9FeSXw0zyCdpurnQ96R6UjCXKQDVDwO3K+8/q/ab2gIH9BLMyAXe5RyoWi9wOGpEb1TmZEOgZnYE8G5+rB42fIWiSsCqJnCVPU9WEKfBomXUrQwzI7z+GkNnkK+vZ9/CfwGsGKjzeWJOwCySiWtP7WpgdT22Sy9acDGnkjxJ5aKSZj4nOCT86JVCDKDhRkuSOXWoNOloAG/A9mXz1pd8nPW742NoqVYzbr2WRfSXhpufVUKMwD/6y7qyhDAGn/vs0JKasCYeS6kGlVWoW1zzwQz+bIG9GXmMk7Fzc8j2bWcNWMtbbS9TxDvJeIataM1Ibf6L9Kf1bO2wt6UgwC2sRDjdUu9Lw9OeiWPKDCk4+UfsMD+B9BW8rDrp4cD1BqiYKvgeIO/IaDm90IxNQQHpKFG3tUU1Cf0A4rpPiwcsPL0LQs7v5ebK+AQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3624.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199018)(4326008)(31686004)(66476007)(8676002)(6916009)(66946007)(66556008)(82960400001)(38100700002)(2616005)(41300700001)(316002)(26005)(8936002)(2906002)(6512007)(6506007)(6666004)(186003)(54906003)(86362001)(478600001)(31696002)(6486002)(5660300002)(7416002)(4744005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTMrYWNyTm1LQkg4NUp1R1VncW1UYkpLK3ZDNzdFazFQcnN6Y0NremJORk50?=
 =?utf-8?B?UGl0aXJ1bHgzUDJiMXlxMFNhdmJvdWpwRVdMOUt3UjIvNFhZdkloYWY3eUJF?=
 =?utf-8?B?L3QreTRlMUpTMGNBWnJUdDF4UzBtKzVPdHV2SXRac0ovTlE0M2NZZXpNajBH?=
 =?utf-8?B?VTIzNUdQVTJiaXJyZ1h5N3pKU3NvbnJpZ0JzeFpkL2d0azRZZk1lVVRXVFRt?=
 =?utf-8?B?SGdhM1BxeEdGYmZXd1MwdG9HRUNiK0w3YnV6WVVvamZQQlJnUm9aVmM2MGtj?=
 =?utf-8?B?end6eTZUa3diZ1BaM3pHNVF1UlpUaE9tdExpb3gyZnM0Z3Jkck0rcTRPT0tn?=
 =?utf-8?B?WDlMYnlucjRtRVVzSmlucms4UUhwNlJ5ZStwRzQzM1ozSVhqWktjaSszd05j?=
 =?utf-8?B?cEJheWNSQ3FyUEdKK09wNTIrMG4xQnUwaHlwUVhHV3dYOFlYTDlaaXk1b2Ra?=
 =?utf-8?B?YmZSWFlrdENiblBxeVM0ald1d3VtSXEvczZYY0xJOWVBTlhWZFl0ZW8yNFdi?=
 =?utf-8?B?VkVFQ2F0RzZJQUs3OTRBZ1luZ0JSNTlCeWtrRW12ckRwdkxIZ0REMWhOZlc3?=
 =?utf-8?B?bzMvWjZUamtvNlNKY1VXU3Y3WllmdmV5WGFaT3QvZnEwSCtWQnVOeWNtVEFK?=
 =?utf-8?B?QmxMQUxJbGluckV5dy95amgrS3RjWko1eWp0L0VseEtaSUxPQlYvMTh5RDVM?=
 =?utf-8?B?RTVHUGRqZWM1MlNnYXdMbHVvTjFGRzZlSGtPRlJQUjUvTkNEdThFQi91YVFS?=
 =?utf-8?B?YTdVRk1yd0tEOHJvTXZLNjBFQy9pOCtHR2loSlhFV2dZVlAwK0N6ZHNuRDJS?=
 =?utf-8?B?NUNnZ2twZEltSHNWRStYUENGV25OSW5lUnoyNVNOcXhUaXp0eFhNakpmSjhk?=
 =?utf-8?B?RnNOTEZQaHoweVFlSFBEWExaak93WmZVTGJUK2MzNDU1SHI2T1hPTllqYmdX?=
 =?utf-8?B?RFZ0RGh3Zm54MVFFYnRtOUtpaGY4TDlaQXhUUkI1TENsVWdhUzZabjFqbVBG?=
 =?utf-8?B?RlVVdmMyUXhoMC95QUxXL2hFQ09GS0NQY1AwMjByZW43RkdsQ3BOQlZXN1Y0?=
 =?utf-8?B?NW1saExXT3BudWZoSTZNUjNrcmtOZi90THh0VG51aWF5ODZid2lsQ05STjc0?=
 =?utf-8?B?blZCZzE1NWRycklPMUpUNTFnbEZFTGlPZkwzVThwSlIrSU5RNWhYRG1EcmNt?=
 =?utf-8?B?RVFYYVQ0QlRpM0VJZ3AwYTFhS1VSdGsrWFdyRmZ0RFplTStxdVd3UUFqZnJ0?=
 =?utf-8?B?WlNnUXgrNmVvZGRncmJtWG05ZktKR0d4MFNKZFZiMk10dmFXeXM1aUVFZDZM?=
 =?utf-8?B?OWNmZ0pKbTkxUXlBOWhxVXZuUm1Td2lTU0NBcGVTdzFCWEtxVjloQUdNOGJS?=
 =?utf-8?B?TENDdlNNWW5GQXArRFFReWhVSGxlQXZweGd3QmZzSFY3d2JsY3ByZEppNTZE?=
 =?utf-8?B?bVY2aEhUSGJMdTE0TThML0VKQUYzVXIwem9kUCtjb2Jmc01HYnA1a0lVYVpr?=
 =?utf-8?B?dHFWMUFTQ3JEellHMmM2UnNkcE5ML0lvc294NTNmNG1zRGFOanZzdmdnQ1Bj?=
 =?utf-8?B?TFRySlNKQ3huRWpEWVk1eEdIUUJIN3U0M0VpRjhhaUgrWndpNExLY1JlYVJP?=
 =?utf-8?B?aEh6N2xoYXBOcW5zci9JRWlPY0JrOUJaRnRxeWlpdXBLYWZBUE53cVZySlZz?=
 =?utf-8?B?dVRxRHZCbjAvYlJhekVCRG9yK1c2MzB1UU1Lb0kyZ0FZWlhiUWtPV3VqeTNM?=
 =?utf-8?B?cENxZUFRd0orS2pjMkU0OEM2ZDA0MmF0OWwweWwxbytFQUo4SnFiQzF5RWtW?=
 =?utf-8?B?Y0dsT1M0WlE3RTJqaTVUeVg0QjFWZS94OUVSa2N1UlpTUEsvVVd6ZjdZa2wr?=
 =?utf-8?B?TVdjNUUycWxYbTZWKzJxOVJFYnNKMyt6T0pNTXoxeWdBODFWNE5zdk5JUDlL?=
 =?utf-8?B?MWFicHVyYzJwQU9Ba3BuMG9qenp0Vko2OHJaOTd3Y1EzN0Z0NDJCUjBId3Zp?=
 =?utf-8?B?Y0tTa0lRMFBxMGtoM3hsTmtWL0RXRTZtVXB2d2xWQ1ZtWkN4ZGN2VlhZZGhU?=
 =?utf-8?B?T0JYY3kvem82RU9pdCtLdGV6aFp3YTFtNXlvbXJudnBhSGdoWTBNZHZ2WHdO?=
 =?utf-8?B?Y21YZnBERDdGMzZ3a1hwdHljR2Z0bWxXYVMwYW1IWU54NTVyMzJHV0t0WUNP?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 683e205e-7c62-42ff-342a-08db0b698228
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3624.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 13:19:58.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Wp4InW7L3v9fDjV7yYcbRcTsFd6AtkypESOUq4wFlSOpzHt7txIM4SEdR9oSWeQgXMkYX2HaEautcoPjpYYT6EqysJRr4L5vAUJry4y+AQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6155
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Fri, 10 Feb 2023 13:31:28 +0100

> From: Toke Høiland-Jørgensen <toke@redhat.com>
> Date: Thu, 09 Feb 2023 21:58:07 +0100
> 
>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:

[...]

>> Hmm, IIRC my reasoning was that both those cache lines will be touched
>> by the code in xdp_test_run_batch(), so it wouldn't matter? But if
>> there's a performance benefit I don't mind adding an explicit alignment
>> annotation, certainly!
> 
> Let me retest both ways and will see. I saw some huge CPU loads on
> reading xdpf in ice_xdp_xmit(), so that was my first thought.

No visible difference in perf and CPU load... Ok, aligning isn't worth it.

> 
>>
>>> (but in bpf-next probably)
>>
>> Yeah...
>>
>> -Toke
>>
Olek
