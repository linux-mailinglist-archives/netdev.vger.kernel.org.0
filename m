Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709B1633BBE
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKVLr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbiKVLqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:46:55 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D231019;
        Tue, 22 Nov 2022 03:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669117609; x=1700653609;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+83K5QDbGVcrdrVPg5lur38//swk81q9wLpksBmQa8c=;
  b=ODqhcVJg0TOJqNcDrG+4kfdGO/3ZxZJApL+5keveANNsRL8WS2qJBIvQ
   rdijRlLpEzD7Q3iatP1Yqq7u731wKKSYrg7mVnpzGI/k34zH8+KA4H6x+
   9QbRHMXpY+KEEkxM573VmiL3s24VZwtX2JsS1jgeyjPBuHoKP3QIPrrHB
   J0D1VoSyRDa8ydPsumuA2mjGqKacwC1TxL4im9v5tDK1lh5SSZChoYjqF
   NQzDbsg1HsHId1yBnu7PCqz6/h8KKMXQxSWNEmzBd4ZY1X2UoBhGWDDgN
   9xP/u9M9cs028lxI3o9L5djhhwhvQ7376WF6hCAAcronfhVUuYyILl4GW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="340664803"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="340664803"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 03:46:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="747323008"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="747323008"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 22 Nov 2022 03:46:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 03:46:48 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 03:46:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 03:46:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 03:46:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMMzLVtLJUadxickry/ZBSxJz1ximZ1UJ2m04kxogo0bNFeGo2cAwlDoRSK6X9C9d4xwFSEdCUgwN8CE21ddaqn8k+o0xemJah3lbffnPNLSh8lhzzG0lPvRtcXpojpPk7ti5Q7x3DUoFwU8Sir2bfTVTJJYz+KZPqS/ITavOG5dyLda9NdMLn0ecG3a6sGrKudmdESATMV8EVL0r09NfbxzP8jGmC42SwXCBAYNjTukRSDqYOZ6IZxeqCQZwUeGzdj6TlvD7jsoL39pnPUXI5BH4tTKEOj0JM/KOio3I8vfwmxUXhyAbbtitZzkHI/KCzQmrfRqsSSptQR4qucBeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3AbAkdihtvWYt3m8LLzwg4009A+Es9CeN65kZ7h1gc=;
 b=FFIfPtmSBWKPwsUsbjhfaREsrSQGUxJjbzHV2iH9i6rxi9aZlmGD0aEA7xGCi8yMuZ6U2YQTYDp3u3iNwG01Jxl4/X0TYX7Ricd2P2j1XHkDlgkibPaVOiua5yaWJW2GcBgFTFxUKEN51FLZb2HzbG/swqedfJ5fVuXpkUSP3n4UK4lpNeP2TMuQxIGh/yO5ht+P/BxuS1spgdOX5HN9d2qtZeUGv+7kbHv9cGvX5Uf2izl5RGzx6gvPGCYSGxYi2jsekKO9zBp1HMlsD/5HZrcmz89JJTPlLKV7EWMKX5+1E/EBbNkwPdItEO7MuBBlS9gR73CWpZ2ujp7SAdvwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 11:46:47 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 11:46:47 +0000
Date:   Tue, 22 Nov 2022 12:46:40 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Roger Quadros <rogerq@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vigneshr@ti.com" <vigneshr@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] net: ethernet: ti: am65-cpsw-nuss: Remove
 redundant ALE_CLEAR
Message-ID: <Y3y2oLutlESoqS6r@boxer>
References: <20221121142300.9320-1-rogerq@kernel.org>
 <20221121142300.9320-3-rogerq@kernel.org>
 <Y3u6iSiJOgcy38cL@boxer>
 <Y3wfpd1p8zbyYByy@lunn.ch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y3wfpd1p8zbyYByy@lunn.ch>
X-ClientProxiedBy: LO4P123CA0659.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::11) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|MN0PR11MB5964:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f49c19f-b418-4fef-ffef-08dacc7f3c3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9Fk0IIVzlI2pO/dJFgdkrWsWdZqwOOU2j8FH7271szFqZtBmd6pi+ZWu6YG8zOrFCZ8BYRuYpYefYhFE+/JINXkwYaUD8Xayf5leEJosmL+61bJ1M/TE4vEYRG7Ab3kgRFkXK2jMu1cjmHhGWjdN/GZGgf0wb2yPp1x76YTfHaKGxH+2o8w391WGrFwjOT8bOw033Az4MwtdFxCXnA9jVaq/iUvMjD49JdGJ3D0eNnDyk40855op5UQfzd1zKp7Lr/asxPDG+TFKJfWbzPAWgAIEV7YygGpGtxPUWdcnl6zXfst1W2Ol2fKFv3qKkx6GbZrIwTAytzd/LAG2legVajzxJyGSnzeGyysPbu6MRM8iNC0n3W5NefKi8wOODIkMjvWzGPWayYjHWsPUyaf0FLbCEY/1RlmFqVvtiGW4ibQd/Vi5hDCeXC9WCE7DyIngZx4fXtXdKq7WaIZ3dYj+W5yf7XotcYrZSahCOhMT5Scls8tq5EmyikYtWTQeCA1s/66lmDg7mNpmurha99GEnaugQYBJCTLs3hFTTlT+uXDfPoKVQoXh0n9ZQkT03FfyOxZUiNR7qZkGdokrYt4Fw1G2JN5K3cxTxmZKJGovbaJSd92CnH+I0Mau/I1tqzH3oRFjDRkHos4DHZOj/+ZGRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199015)(6512007)(9686003)(186003)(83380400001)(82960400001)(4744005)(38100700002)(2906002)(26005)(7416002)(44832011)(5660300002)(33716001)(6506007)(6916009)(66556008)(54906003)(6486002)(8676002)(478600001)(66946007)(316002)(6666004)(8936002)(41300700001)(66476007)(4326008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iAz86iet7+uP09WWdcHYBCQHRLjj4pOvdJFtXlx6BWG/q6NLNUTe1nIVfiWE?=
 =?us-ascii?Q?xDTxX8303bLOUzRQxgnL5elOLlgnNZKovtTwRAOkNUkM9Prlqktsisxdb2aV?=
 =?us-ascii?Q?dxXjE/t9gmvs0fZM/dMg8jSLtVF2g+h2TJjIkaxvwJxmtoDFXx5Uv1FrfYLw?=
 =?us-ascii?Q?M1EspifNmeaAdjIKmR409PM1se+plLtdNy8c29iUn2GB96sN1uHzYhc8apKR?=
 =?us-ascii?Q?FQDeGUgf01giyK5qi6o84L18YlPowvbKAukz2c6c+Zqwqn/kSaXM7ik2+IHW?=
 =?us-ascii?Q?GARcAKgM86JJ6QyX0mIVAoWBA50qgFAfReRUFZUDjBOSMTAPVqCCbfT1gSVt?=
 =?us-ascii?Q?vtXhDAtY81vr/5FMRVeYWhv6p6kTGHObvfU1mUfw2D1TJ7WU89ffu34cKPs1?=
 =?us-ascii?Q?r0wgFd7vtF27LQ6TTYoxAHhxC0csX8axUWSsWgGRZYs7RVjTcGQ3dV4nj6Xv?=
 =?us-ascii?Q?H4t36DPAR5rQa1S2umJVHCVeCQKeaT7Ghv7Loqw92iZZTVByQNmbkc3Xg+5a?=
 =?us-ascii?Q?jRktU7FEh9+YZxXjPciv1qanZenMccpafgf/ZJLp7UR4PP2S2E77M6Df4im7?=
 =?us-ascii?Q?Mej/bJTNPxzp4nwCaKocIO3c3o7l8kZNDmh4bTbet+p4FVVtV4W3GARRBqn8?=
 =?us-ascii?Q?b7CKxMe+UJSJ75JJTluSuDYHcq2NKe2zw7O3ss4f1nYKP01wgX4AWZH5SdCl?=
 =?us-ascii?Q?vQceFE0x2wMxWAByYE0chZsk7VmEfxFepHn8fZAJwadcJVCnOVUfG7J5qCc6?=
 =?us-ascii?Q?/Y195W/VbEjbo/hEO6PoQJdmKCcW/+cQO5Xy4ZptIoOie9bFFQE4lo2MBuYJ?=
 =?us-ascii?Q?B9b11v0g3OrGA2UjrVdZ8m+9PbJ+CD1JpR0C+N5y7A5wJUsoe36rjcoKO7ZM?=
 =?us-ascii?Q?nA3dpwL4TCukpUvEAP7L8KvCKClN0Vc7NpgLt4qE+8uYOt7mvLio8WAZB+4O?=
 =?us-ascii?Q?W13fT13MLqnI+Smpx1ZIsmbYJ4LJbyAhl4w+9NcpcaoF7XL2HmRxSNUufp5Z?=
 =?us-ascii?Q?eEs7dEa+cGMTVEoqx2QSo0BBk9NjZZs9EB7JiJ94VJ8TZ6EKe3GYsnNvV2Ju?=
 =?us-ascii?Q?9vA9eqiIhppHdicwwtQ5WrUJx+mZO19EuuyGA5wQdqA5Xyq5ku4FooAIl7t1?=
 =?us-ascii?Q?kTfErN8j/Wvxl+j7VwjJQhlpciEK5QyNOGaLXtCnkRTMw+GfJTvyjkT5YACs?=
 =?us-ascii?Q?cNhpVGOal1zpUY+ZhamJ8NZ9KCK4BJrMc8GWFaDrB5pSUFHk5jfJj7oA1QyA?=
 =?us-ascii?Q?PLnAtdFTHVIAX0xieT7OZK64R+mpOs3VucS4WiPsWsiO8jOs/zZDPZqgf94Z?=
 =?us-ascii?Q?F8znEX7wK8x/FBMxFSHFB7yJlhNDdFIlWDa3sd9j3jHtO+qMsPH7IU75vEpV?=
 =?us-ascii?Q?Na6/DNjTj0Iq23Uxl9OLpnd+xNHebQXnv3ErJpXl5HCzjFbTt+2H4QqWIMtj?=
 =?us-ascii?Q?m+x8TX8yEsase0/ykd02t5zZOUJ97dA75+kEdwTFtUdBBUTnIEv3q9u7r1FB?=
 =?us-ascii?Q?LGpDxx1sDbJvTQOA3r0JsCXNFIsj/Nnq18XnQ7JiaIFbS6OEPHIbZ6JDCgN0?=
 =?us-ascii?Q?UQHTryEhP83YulhvOTHaCYnlxIwQItfMmOKxNVgD+lcakaHjXkUL+phprElm?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f49c19f-b418-4fef-ffef-08dacc7f3c3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 11:46:47.0983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 08dpVJhwDuh+QmioLuVUcKAdZPG6YvG1F3Fs/JhQWKXjzoLzSYo0IIZ1/CxqQdlIPqETaBrM4KaMD3NwlKIsRmOIklWrcHrfRqXEPc7jXoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5964
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 02:02:29AM +0100, Andrew Lunn wrote:
> On Mon, Nov 21, 2022 at 06:51:05PM +0100, Maciej Fijalkowski wrote:
> > On Mon, Nov 21, 2022 at 03:22:58PM +0100, Roger Quadros wrote:
> > > ALE_CLEAR command is issued in cpsw_ale_start() so no need
> > > to issue it before the call to cpsw_ale_start().
> > > 
> > > Fixes: fd23df72f2be ("net: ethernet: ti: am65-cpsw: Add suspend/resume support")
> > 
> > Not a fix to me, can you send it to -next tree? As you said, it's an
> > optimization.
> 
> commit fd23df72f2be317d38d9fde0a8996b8e7454fd2a
> Author: Roger Quadros <rogerq@kernel.org>
> Date:   Fri Nov 4 15:23:07 2022 +0200
> 
> The change being fixed is in net-next.

Ah right, nevertheless I had some comments there.

> 
> Roger, please take a look at the netdev FAQ and fix your Subject line.
> 
>        Andrew
