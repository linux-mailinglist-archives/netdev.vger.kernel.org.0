Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A0D6B987F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCNPFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCNPFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:05:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDA1A028F
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678806327; x=1710342327;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Gl1ZqBLt9h6FFTvNcTDh8RNYJLRZ6dVagGZ4P0R1urI=;
  b=PFYwXbqXyLmO4lZer+68LbmQi+iQm9NUUrjZogfLmBFAubL1+gN+Wd9M
   WCnERaKqMEKrd9BJaWdjistVD7wmOqGuwh16vYq9cMdQqi//zjxxbG+QZ
   NN1AcKV55mp+4ad+GZJbCbUM0nQW2h6757MdItnNtFkQ/HFgo1HWkrJYz
   tWiWywBJYm9fMrfG+ynAHxxyg1w9GlTO/BviNMuPJUuei+NEnjUGsoPNg
   PtLmoMelyWa3PKh7zHUFCioMa41qfFW8k4XBnPdLtg0mqoOhUfwTYiaPO
   PfC9LDktyf8cTqSTHeAyMGBwxsko/9Ad3sB42XSQemksVgdAR7IkXGhPu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="423722786"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="423722786"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 08:04:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008449168"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="1008449168"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2023 08:04:52 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 08:04:52 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 08:04:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 08:04:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 08:04:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9HWTLr2hjJBvXiHDk6L7u0hNc++JghYSS9NhdOGRdlu5aTEI8AM5/U905tDE7+USfYIBFfrISrkWRqqPipL2LfrpoebNEAoI2aAdqbAbQyHTmFDt3IEpnbQJrZ7N5T54/isJiBKvdlzhuzVMzZxCO7lW9dMOf9V6j4Lu4PT3ELp03px8hBdK2TIMt0i5TEMfxEDeBUpI9dU9K7xTb1Uk0BS3NjsBWRWSZpgBl1sPb+41OixILcffZS6CBhTykR1KvPbub7Vsh8daB99F/hKLYOlCqTIx7mnLTvpEV24BFcRdaJf1U6+1jjJPmyh16KEZwk620WNmAITbgTY1CcbYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A6TkJorC0EpYnoPpd3NpHchCaaiY16/VoHJWjmyYLn4=;
 b=ZVmIEk5plX2LCtyUpzdf5ZBqG+28JUQQwXS15YWymnQf0Ky9Fx4V1CreSIyR8mfllexrhZVNOTcy4VirLVSeK4JN0oC/tINezVAO97dolNAjgQgiriIlJ7WyVN6S0ztu8I6INlGuEPpGFQpEy9EhKcJJhy/r2YqTKwdj9Gl8Frnjarc3ZtJzY0HFjzoMNgeN3Qh7oNzKdkoBVYR099GsjjWLORkqriHj7pFWYIfjsajjvtV0o9nS5ghyZdAqfo9qAmYznhxmLAen/30mll6VvYA8x/24E1J9b6ZKnxjnbuheM41qVaI4ISitiKfF9ShtyLgaor9nLQcADYp99wk/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 IA1PR11MB7776.namprd11.prod.outlook.com (2603:10b6:208:3f9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:04:49 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:04:49 +0000
Date:   Tue, 14 Mar 2023 16:04:43 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
CC:     <netdev@vger.kernel.org>, <monis@voltaire.com>,
        <syoshida@redhat.com>, <j.vosburgh@gmail.com>,
        <andy@greyhouse.net>, <kuba@kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com>
Subject: Re: [PATCH net v2 4/4] selftests: bonding: add tests for ether type
 changes
Message-ID: <ZBCNC+EWSprrFTVo@localhost.localdomain>
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-5-razor@blackwall.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314111426.1254998-5-razor@blackwall.org>
X-ClientProxiedBy: FR0P281CA0108.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::8) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|IA1PR11MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b103671-d28d-480c-a715-08db249d74ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D7w6Cg9n+dI8F2L7h1rzL0MLgyr8s8Ok25OgIlZ7V+OxWfYMQTCGSfzysL5Orq82ppLRMEcJzBmHUh9jRfgH8j71RNXht2F+MirMxkbPcp6u5I449r4U04ZB+nXCkKrR0PdXUUr1f2Cf7AwJGd+E9M8Mhcn5307WhkV3tNNvjB8DXbJDHX8PZasL6+Ypf6sIRJj4k958dhVBTdLpXxsf3ipMsHF1e5oCwRB2NJ42Gh1zW8dUwG5uuCU574asLZZqXHO+5Qm0+WYXfDGYmbMavFL3OXf5SFtcgMJ8TkDR6HjeNQsvhr8hk+wqmvjncMv2gDYkMOOIfjUC90DkwmvWczhWS/G5q+5w0qkG7fdmqgfgNSQfkqsPx3siltZ/vGEN9rnyZaNvx9rlfU/dIv1sKoUy0YPNHSSZggb/OK5KMgcZrie/bVqnxQv7GugBIiqL3KLIA/RgCUFD+FyBkzYG4lYq6ASYL3ZfwNyzNML3nckDDc2bRCL6HRCk+8upF+epkMhHiJVJnyl0ZOHywBWjJT2eyYU0oYjttFrShtIX27GJzUcL454sC7tMpnzEhRCtYAGxlw+/vEYEuTeqOSf4ZWoSCFGkcVAzssmclsqmuOjw9akPlXPEjSPx1dCX2gpxNHNXSakw2+F2ZYarrQ837VorvpBeotKvjY7OAFnMzsm8BswvMVwFA9dg9roEsitkhtf0UEeSwsieG4kgSPoRAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199018)(86362001)(82960400001)(38100700002)(41300700001)(4326008)(66946007)(66556008)(8676002)(8936002)(478600001)(66476007)(6916009)(316002)(6512007)(2906002)(44832011)(7416002)(5660300002)(83380400001)(6486002)(186003)(6666004)(6506007)(26005)(9686003)(966005)(99710200001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lZc1WT+GoisPWMyXQ20jt6qj72JwIvy2i5Vv65ea1ZEUdP7ejRDnlunvo2ya?=
 =?us-ascii?Q?vejdyZdxCQs+hQh+uV52dgoJTDmq1awSVRnMdCTabaMWfb8hELGESJsTxgHf?=
 =?us-ascii?Q?KhWMc8vC12ZW/xjosEI55UA+xJgMOzOGK6G9JkkCs8EFMd0pzAcD9iCXrVXy?=
 =?us-ascii?Q?6NuZBUkkhcu+YTn9ewAd5szafZY7x5e36T3Rc0YG2GA28SVwBxJe1dmTjNpL?=
 =?us-ascii?Q?W9kA25myONACd6f2gm2u1gh9GU34sL9kgMd4o0ReUQgtVkOzMh7R19jS9d1r?=
 =?us-ascii?Q?bQi3TSAps111I8V+vwmWlLvxCCY5+c3oH04Pf5BsASaOLZTtTK8PKKXYw8S4?=
 =?us-ascii?Q?ygRpCi/C/ry6sv0lbyzzyBE/BXpyhkVErOxeYDw8YBDJOBuBZYGLYF9cU2rv?=
 =?us-ascii?Q?oOcjqPcfEfDUkF+BJxaz1DIMeuxXzMjLIVzqAPG+C9J8tysLFFp4rHpqPITN?=
 =?us-ascii?Q?28eVr1zJMENcEMDzVStPqkZfAjCNDK1jaRfI+ClUvB2iONauIeX4Uozz41es?=
 =?us-ascii?Q?aVOb4ANgv4Hgad36+5lMrvBSRBhHciM3gWuzV0gilpDwje7fWMb3QZTm4cz9?=
 =?us-ascii?Q?/A9rt8yYtqgfmCyTAEip1GNUPeEBJsKP9C6Yfc/jn2ed5dGR4tVg1tRmuWPA?=
 =?us-ascii?Q?HJPN0wLwnT4X/6b7JXkoWDX8eFOelUrJ8D8YUovfBNhzY36RueNHVpDTVfQK?=
 =?us-ascii?Q?ErEZzkhOuMZKx7xLLdkhv30aVOzxEmxz5sZ8IkkSalkdCOUVvHWzHLeWkFX2?=
 =?us-ascii?Q?AEpV0l1aWtzVQL5uNmblt4iK16RuXavpDc8hr1lOPFatMyOFO1dUr2v6AXj5?=
 =?us-ascii?Q?DuXoSwWqS8cBnJoRMbMJTKvqN9ADfrldZwNh7xS5DBp6jRpcu+lwk5mZsIMW?=
 =?us-ascii?Q?nVQ1XZ+tF9sqg+rwpywAV7qjvDt/5Ie1TMyZCwfppvTYl2xcNELaJFYlB5S+?=
 =?us-ascii?Q?+Uepzv0LAk7WJKMrj0BQaSjFkq4G7FHLFvrxj8X8a5lgdNrIdhFxkKyh1DEm?=
 =?us-ascii?Q?4VrDz3JVPL0u8GIwuWll0pTxQEoXgJXigs8ue15wywKHaK/6pBWIGX7wE+9z?=
 =?us-ascii?Q?ry9Wz0Tpk/QVFQm3WJbW9DnhRpJ3JH7kYfOdI3zEyQNwtg2fv3iHB+Ro+0c8?=
 =?us-ascii?Q?j4vjxOTtA38CRBWv+txNzcI1foi74H3myJ0JgFiQnhGzm6iCanWleR7VqE1B?=
 =?us-ascii?Q?zh15n0C1iTVvM5/1kL/TvMc6helxCFB0oiwyk+lJTANHerooD5Vtdla1lo5u?=
 =?us-ascii?Q?z2C77ZVA+rmnKWD0aF+6qrIE52NV5+M6ksIo+XzQXeedZ5lEbh8mv7m4Rz6D?=
 =?us-ascii?Q?UmRNj0oKIC/Yh1d+iyn2OfClYDnJ2BXfubB7HCP2+fj/fwtZe092kz1TrbS6?=
 =?us-ascii?Q?IGIKvi2t1ToAX/mJvO4VfGf85cabQlEH0HDNoWOBeQmoyFVsP4TZNIP0+JKp?=
 =?us-ascii?Q?pS8tSTiqlNr/qvGdKuPk9JVy4PZ8YgD+ofGSKQYcM3s/at+RgK8N/5lzPqRd?=
 =?us-ascii?Q?Q7et6cKriMnSG/WqtkwlqaJ1yzIIGMSaFSCHqJ74rdAUjQJuzcvkCiTZ5RxT?=
 =?us-ascii?Q?Xi38TVj+439ncEs4XKPRGYqFaj4NFvnRjps2gwrZrefEIEZx1LGl3Pwwl/s/?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b103671-d28d-480c-a715-08db249d74ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:04:49.4620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hcZ/v6Le2eCObcS/LUT0A2O7YMo8MsMqSOrVD0st/dnWHLXfjtTyzW/rqSqGWRJCLVZOhdoMQHcK1+O5jk8hcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7776
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:14:26PM +0200, Nikolay Aleksandrov wrote:
> Add new network selftests for the bonding device which exercise the ether
> type changing call paths. They also test for the recent syzbot bug[1] which
> causes a warning and results in wrong device flags (IFF_SLAVE missing).
> The test adds three bond devices and a nlmon device, enslaves one of the
> bond devices to the other and then uses the nlmon device for successful
> and unsuccesful enslaves both of which change the bond ether type. Thus
> we can test for both MASTER and SLAVE flags at the same time.
> 
> If the flags are properly restored we get:
> TEST: Change ether type of an enslaved bond device with unsuccessful enslave   [ OK ]
> TEST: Change ether type of an enslaved bond device with successful enslave   [ OK ]
> 
> [1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>


Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

Thanks,
Michal


