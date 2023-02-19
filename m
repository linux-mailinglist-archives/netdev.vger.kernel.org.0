Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7816B69C27F
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 21:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjBSUqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 15:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjBSUqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 15:46:14 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2138.outbound.protection.outlook.com [40.107.223.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AB01632E;
        Sun, 19 Feb 2023 12:46:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xqogk5KUMGfbp43E+B12qK8yVd8GBZLcNedUZXQcr2OodjlUfOud4rnu/FMRn9z3yr7C4JqUhE0vF6cmDotOgHVXkgGPBEKyDTtDdO9cHTfYSPwZA6mh6LXJo6T7PxubRHSLeIHv31hLgxSbu8BX3mBJ+2EmnYYAtadyPp3L4enJ4ApLkuCZdwMhQ/4/VnRPkGi3AzX84+7MmyO3J+c5G9M8yJE+QOMm/ylF2/LHvWhKEqQJH6L0SA+3N07Wd7Lbi7Z8bu2KiAlJ8kuH6GMWTelykjDxIl7qtCaFTR/YKvV1uPD7Fx3A0ltmZpUyEUkrLko5XKSuZU336y1195njhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqLJnOHmCl8euW43ezvP//HK24FdfuXvWKj4CntkD3w=;
 b=RutnsmGsJTH07TpSwPHPjieDcI6Co7KEMORPxwXEnI56NIace12MQ6ZLA75fAavkqwvDPdT4J0WtqyDkXypsWj9zRUe1cOdnlKd6HyBbp6YdWU26nAKPSJwLfijYQPiHOrl14QG/Q8dMehhz5zYr3Q6ABekjEcYEN/PO8IKsMjPzGiQWRi2spqHoODImaWKvNPYDDwAJ5w2dIoS7NLuQne2B67iEgzkkWq8UNGxFd+zv25n1x0cIhtbg57v0cOFqqCJmomy/5/PrHk4Wnty5ZPvnGfdiFnnHpl3ha+cQCWdzMtDv+Xfo5EiqplFRW6N4Xg9wNlveJEbv7Zk65+dcnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqLJnOHmCl8euW43ezvP//HK24FdfuXvWKj4CntkD3w=;
 b=Q67dMSnfgvixOJvRGSkdQD//zhhBPM8/nRAGqavejsCjE7RfBFkgA3Q5unwXdh/KkRRAKg7lNI0oZWz1wmzBHCwgOrLyZ7CwUHBdl0E0z56bZgxPD8E/OIAmx5eAWxdNOQPdOH/jEWjjoFAabaWV5E6ArQJnbYKYGvmLd99fkk0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6239.namprd13.prod.outlook.com (2603:10b6:a03:526::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Sun, 19 Feb
 2023 20:46:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Sun, 19 Feb 2023
 20:46:08 +0000
Date:   Sun, 19 Feb 2023 21:46:00 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v3 4/5] ip_tunnel: constify input argument of
 ip_tunnel_info_opts( )
Message-ID: <Y/KKiNHnJ5vHqWrf@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-5-gavinl@nvidia.com>
 <Y/KGJvFutRN0YjFr@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/KGJvFutRN0YjFr@corigine.com>
X-ClientProxiedBy: AM0PR02CA0143.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6239:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c490981-2640-4dcd-656b-08db12ba53b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1qW4xUn8pKre8U/DVoVkSw84yGYh+8fPnlBl1lrjDh2eF+0OHMOs+CRax2Tn5lJtAC/UVReuYSyfg/NRJ/nu+WSUWDNK8oBFmnlZT9Nf5zBm3IyPZk9+UQfsHHTczVAX38TmbHCdZd7G935N5yb5GQp0xSqgHad2imHRx8+sbQ4uygOXZgb9WqOIfOzz+R9BGbpf05+dGuzeUoeBdha9MVtYuqKx8/GhLf/8Rllqg78DPPmsBrtEFUaVGxuD1ucx58XfKJkIXHZUBNo7aDPTkes+lix9nNupcbgx9sALsWkQHCYuksNJvKQzppZjY9BmCIMdgB+oQ6suAGrL51SMVJn1d8j5Y7woKlrJsZHd96l0+mDuWqDe5kVduykX739mLsJiyhFjwv/K5Xdax+CDDlotEsJoDw0lxj47m2TfWqKp/TiU9MGz/+rz4wAn/RyjejfahY6U+oCT1BCmR99iXmXx1lGf41b4Jrmko3U1OX/sbtZc40qlkSCNLjWVHzTJrOlH1sRVijzhQuOiG3M+6DRHcGklpfyIsafuLkUave8BFQyQyuhcWR53RyHITiyyPEcLtA41VnoszmDslCNPvGjTJeJAZhSwN/BJoUf4H3cr/xfQIurEDNWaf7NO7DNUtZiLquqXA+VmCLA/BPGaXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(39830400003)(366004)(451199018)(86362001)(36756003)(66946007)(66556008)(66476007)(6916009)(4326008)(8676002)(8936002)(41300700001)(5660300002)(44832011)(6486002)(316002)(7416002)(2906002)(83380400001)(38100700002)(6666004)(6512007)(6506007)(186003)(478600001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QsHJyShp+zg7uAgFc2blhVVkKEPZZZM+faETGCtoVipWSXUWCO3xE4VIR4lt?=
 =?us-ascii?Q?2vg7/b/+X1WO13z1rmCdD6XKk83WFdvmlu6sni884bBomySA8y0KvxnYk+bN?=
 =?us-ascii?Q?GEWAijB7OpUDa9+kGfXt0Mxd5F8S72s8eBM6OUjF2mTc07jpcmGYV13UVZVY?=
 =?us-ascii?Q?HAqIuPG64cxt1Va0rhEyIBlKPHyp7O0katcybiZXdz78fI8os4/NyIdKH7lQ?=
 =?us-ascii?Q?PHjsXwNoZCSXcbiG/hgfHcgfiefdZpKyoGBESQh4zwP67ZgvHYKc2/Nx7eRk?=
 =?us-ascii?Q?bEGsTS+pUI6+KCNK6fbRR0n3XPBn0MJS2R/8UwohimDJk5svKq+ZJV1C/Xfg?=
 =?us-ascii?Q?gf5S8Zu0IaPvn6WoN4bpf0YKCqy+0zGpzFHvI+CPiMoZhrg10ataUplKnt6x?=
 =?us-ascii?Q?+zXGa63UJx+HJuCebVtlcrTrmH/CDDzWH3L6Tu/y7UktfxGTmMJm8r+nbJ0i?=
 =?us-ascii?Q?zMEwtDNHzakFKs/pF41+4bQm3M0tN8vx2E7h89ZQW9CYb6IgG7/hFJpHcIvR?=
 =?us-ascii?Q?sPuQdcIk+umCJim5yzgR+IIXLk4kywlK9Quc3ljyWbyYnZH+9N65PLEjnFt0?=
 =?us-ascii?Q?C9eUCLREQc1ufZ6hb3zT6ocTpMWEg9pH2uf4D0J+zL0PmpZ8N5d4rUe3JggQ?=
 =?us-ascii?Q?6HVNnuKYffGX92LTzicB1Ku4QUaHhJp8ZRuP3/Gcc7+wkVGjugFke0B3whTy?=
 =?us-ascii?Q?HPzBu8WzTKQCpXjep9yDIj6iwrz0/6ulrrrM7eJsNDIH7PuWM6ChyPhwb5Bk?=
 =?us-ascii?Q?BaCgGKngpYt8GHNCpq5Huu760EO7Z7n3nBmjC77PmzMOJbLm1+7OBbjhC+IF?=
 =?us-ascii?Q?3umNEDGWqB4PHwYbLKwDeY/9LK/KUi/fiupJttNHOYBwUUZxDBNnBWcgZLGj?=
 =?us-ascii?Q?IKK58MlvC5eDcbi+m+mPd6Ij7t4n3yXas861rr3ezbn8+EWs4YSnEBa0Rf7b?=
 =?us-ascii?Q?BqXf5ZdNjuBY12vM92IVzG60xnP5y4KS5M5YBJSYaYrNTPUphkZBFhxoSeh8?=
 =?us-ascii?Q?Iuut6e9NNVu9E36dXiN5nBlLt/H7C1e3sAwkf0pi378xJxNEwj2oOMdueFmP?=
 =?us-ascii?Q?FZBDLmXOYAv1VEZiMrpMdtgoyiVM568KUtZzls+uZp4yeeL5eqPyde97Q2I1?=
 =?us-ascii?Q?+qe0e75wIDkS4oCgZd9mmqCeXwjjGtqq9NU+Ep4AA++Mw9MrsN5W3+pT+1x5?=
 =?us-ascii?Q?B8636WMWOUfhr25mJB5+PH2UoKn31N4zKyHbl/4XPSA7XSDQIS6yMHFAxlaa?=
 =?us-ascii?Q?4QfuAyJ+SlYO4tkUY/Bczaaiy7V8slsPxgcFG47df4fZhRp6gYDYnbbhV1xI?=
 =?us-ascii?Q?f8r6CY5iYeUpb4Ko+zzH1mVMvZ+Ew2M9yT23ZG7fozAvwqzLCKOrrzhKJXuW?=
 =?us-ascii?Q?0/twN6skjy5WzCcW3UNUYLqkg/4NWoEb2oDZz5Zs1hNMJDxHJ2RkORxacBV/?=
 =?us-ascii?Q?UiMJW9Q6yY0WYRWlPM2fc3QWwOS4cf+vbIxctu+FSw65BRMAxEmfA65ZY0fL?=
 =?us-ascii?Q?Lt48bDypKIyRX/oSCXSh7xqu/zFyj04loU1X2p2HItrm9QR+SA9Dx5khCWK2?=
 =?us-ascii?Q?TDqebAFwGrp4RL3vTMLoxYNp4AunsFKrgyuZKJ2QiDJUodWBMNvI91oivHLp?=
 =?us-ascii?Q?Gdzgh0dV/7ySU0PNJA2YWJjUs3njecrMb6gWq1JGEbBRMWmHm8c9k2tpevqC?=
 =?us-ascii?Q?43Y4uw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c490981-2640-4dcd-656b-08db12ba53b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 20:46:08.1996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YvnK97TT8thb55VjqYD6tSeYj0KEbmYItiiTrOFxOwQ8xBvOcQo7tB72D08C/BtxjjSVu9aDz7ZTUk9yySJJHat7pYstvxW7Jvi3qIb4Pl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6239
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 19, 2023 at 09:29:21PM +0100, Simon Horman wrote:
> On Fri, Feb 17, 2023 at 05:39:24AM +0200, Gavin Li wrote:
> > Constify input argument(i.e. struct ip_tunnel_info *info) of
> > ip_tunnel_info_opts( ) so that it wouldn't be needed to W/A it each time
> > in each driver.
> > 
> > Signed-off-by: Gavin Li <gavinl@nvidia.com>
> > ---
> >  include/net/ip_tunnels.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> > index fca357679816..32c77f149c6e 100644
> > --- a/include/net/ip_tunnels.h
> > +++ b/include/net/ip_tunnels.h
> > @@ -485,9 +485,9 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
> >  	}
> >  }
> >  
> > -static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
> > +static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
> >  {
> > -	return info + 1;
> > +	return (void *)(info + 1);
> 
> I'm unclear on what problem this is trying to solve,
> but info being const, and then returning (info +1)
> as non-const feels like it is masking rather than fixing a problem.

I now see that an example of the problem is added by path 5/5.

...
  CC [M]  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.o
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c: In function 'mlx5e_gen_ip_tunnel_header_vxlan':
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:103:43: error: passing argument 1 of 'ip_tunnel_info_opts' discards 'const' qualifier from pointer target type [-Werror=discarded-qualifiers]
  103 |                 md = ip_tunnel_info_opts(e->tun_info);
      |                                          ~^~~~~~~~~~
In file included from drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c:4:
./include/net/ip_tunnels.h:488:64: note: expected 'struct ip_tunnel_info *' but argument is of type 'const struct ip_tunnel_info *'
  488 | static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
      |                                         ~~~~~~~~~~~~~~~~~~~~~~~^~~~
...

But I really do wonder if this patch masks rather than fixes the problem.

> 
> >  }
> >  
> >  static inline void ip_tunnel_info_opts_get(void *to,
> > -- 
> > 2.31.1
> > 
