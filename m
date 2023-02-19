Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F6769C242
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 21:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbjBSU3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 15:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjBSU3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 15:29:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FD81116A;
        Sun, 19 Feb 2023 12:29:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L399ppR+tlIu/jdxhw+3GCTrzE+xZYQ6mDqbQHpaUbECN4zsDIe1YJ84smjUzAlVtbtANHI7utqzZi23l0Zlvzg3vpj5mzHllOfyOqjkPJor2t8gDosJqDwtNsAfWyjnKG39T9sgtwS6y76MCQiTgtUwC+/Lf/nSYdqtYNPGCinAJDSjk1mxdv5+kp/9yToAhrYx9ZlX6fHIGBIJwvtKIomu/S1EPKaD+/BHLIHDOy2KwUbaY47Rt+d5s5nGx6PZBtIUFDKD6F14BG+P3/Lu36aw5UvUL1/NI8zh0mky+3mY1C8z2HzGwUCI0GLhoVH89k1xSIn9tii90U+ZyM9uEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HU1jKgf4FPejdwF1A/rDqp7HVcBTcUee7GTiqQciEK8=;
 b=EEfXyjLKVlE1U+0uPVz1zdocwWGiAbvdgomOqm6PX6RHJiYfa3OjOzwqW9XoT8+LBogwkPJCIkPgxW0150hNYOlVDJr46/syvlOKo9R4ftJDxX1nrfEaUavfuzqzeK+GIENV8OKH/sTbK1qDHKYf4l53w11fZm+pCryArcI/QKsFrl0kIixpz7bJ+uJUOWlmkYKDSGWmub9MxOy42pJEbWw1yYNYoayZ4ZqreSxLWvm6/OXbnv1C+cY8b/PkNZ0O9Pz4APkkv1+vjusobwDkzhQbHRE1rdwl3PaRa4f7kpyI003sMXZ1+bPncZ6KGogtc3C62yp6qDj8/v/Q7aWKaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HU1jKgf4FPejdwF1A/rDqp7HVcBTcUee7GTiqQciEK8=;
 b=se4skpKYG/3Xgn73krZVTz01HiRzyLdc6kQgs43jpf7eQpDJTw/q0mVfYE7jQ6E/ShhEHzvS/h+CgJcgUcCm1AREmV3WQqeqRo0A1GVqsjV2/j1yid2kfQL2y4ONUjnFHEaXiLEZrh6kq2TxWUkXtx2zZi2jTdtd1vrzUJ3EakY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4556.namprd13.prod.outlook.com (2603:10b6:610:35::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 20:29:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Sun, 19 Feb 2023
 20:29:18 +0000
Date:   Sun, 19 Feb 2023 21:29:02 +0100
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
Message-ID: <Y/KGJvFutRN0YjFr@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-5-gavinl@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217033925.160195-5-gavinl@nvidia.com>
X-ClientProxiedBy: AM8P251CA0023.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: dad278f0-01de-4d65-8164-08db12b7f9ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CTHQrxnqcojhtM8te4lMVX3R/eiCNvQSZ6bMQtnSyBkxL22ysMH5QJURT3gGJmS0j/60a2iQuNxRcmEaP1wi28h/hwGYXOfpHaqCAqfEhQUYOca1YmWEDUE3i7OjGOFACsrtZmVjtQab0DPE7mgQA2s6cjQ7RXjfYGRmAEGupbtyeYfLoM+ncBjYxC+dE+WV1Su6NgjAVgcQRg3qpaau0AEk1zC800lnEaB6mOlKusVwLz+/9xbPr5HVMiziWB+wv1uB76r4ObvAQbptuDJxcC0kH1VgdGTWTE/45yLw5vQ6UMfm46ZbP5o+H9Eqw+NGQMt6Qn8EvClDNt06fAYVYpnHeLouGXVnnX4V+6cAN2VxnfdTqUNoiDT9y6Qc22psBeAdugGQflZT+muI/bPak1Ytk8FA3YPBYOA9Y1+Fm4W3LvkxW3i2ZdVvRQyk/0ShDkQJ50pofQvCIW7kO/bT9Ls3EKQQyUk5fQAHyiypZc+gSM9C9YrLVUtsjgo23Z+bgCN9ATIi7l5IoCD4P8up0+yaXwdEAHAcexen8isfX/LS6ut7QvU/+Y7pfCGC4iOBa61R/cvNlLIacIdDJ0cymvWQN0NzEBAmsHSVLqnU1ycNU2XBcsBIYfyZEaUcZrveK7LT/hHZPX4jm5zFca7JVCQSWySb/uT+Zk2BqeV29Nkz2f5S7NSlzANWiGh8RY+3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(366004)(39830400003)(451199018)(44832011)(2906002)(83380400001)(38100700002)(86362001)(2616005)(66946007)(36756003)(316002)(41300700001)(8936002)(8676002)(4326008)(66476007)(5660300002)(7416002)(6916009)(6512007)(478600001)(6666004)(186003)(66556008)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GPGQltAwmzwR3DNJLzQIRrrdkXgvgmD1TsjdLEvhfo582qFNT9tH3Ow9MQWB?=
 =?us-ascii?Q?9y2XXKyC8xF/nfGZgbxMu3JIetWIwJKZHqcBRT6+Stul3iIoBNqLgDEDGI11?=
 =?us-ascii?Q?QR91+LzAsGghAZszw+FuPMT35wbSgc5tshA9pRUFIJAJMpioiVhuIMUrk1+9?=
 =?us-ascii?Q?mcycgVSM9irhQRRY8OoMj2L1i/5RYD+9Fs2Jh59jJo9JqJtKzahVzUVJteZT?=
 =?us-ascii?Q?OYKOuR8013edS6VMWmiwFFRwNhmqURmRmiQ4los0gjPF+qMI7vLs7ISuvlTT?=
 =?us-ascii?Q?rUpzLkXLjRqXY0Mj9WaMC3ZyULztpG0KmFNGziK9WqY/1bMg3K8CptvwjBKa?=
 =?us-ascii?Q?IZNvYIBVUJYWDX3cyrpeIr7Rs8vTVoaUsbeSqZYXO612VeAZ/y+iy8MYRtZk?=
 =?us-ascii?Q?2VXPvyOSAy0rtxgVmXRTDDzokgCcHw9AfAdWruAWe+84STt3/wYvNFfBVKAr?=
 =?us-ascii?Q?Rv7R8Bd1zEOc0aXOnoZeDfbtj41c7Js2GJm3m5ZcCRZ4uYLBDhSKGBle/SRM?=
 =?us-ascii?Q?QrtVL/R0FhjjkT6Y33v+BLEUu3CTOWTvqfxOF8/3kHWBN+w7YReel7WaGG/2?=
 =?us-ascii?Q?Akcx+Bhlphnq/a2jzafccKw5Bf77c7AE6zQe6NqucTSGA+kD9ew2a90n4iUF?=
 =?us-ascii?Q?D4bm8nQLE7GM2ayFeYIj/TNhcexHN2ihr/ceJXeZhqTRRBM7uushAPaGGuQg?=
 =?us-ascii?Q?wLf0xFv+2RXlWt3nVr3HD92NIhEqjcu5Yo5pK1rrXSKI+/cirePlOKRAkzvx?=
 =?us-ascii?Q?SV+Nf0n3MrYPPdfFVeUThXYTs2c6mIccbsA3qWF+iyAslIkDP6ejE4yP5OK3?=
 =?us-ascii?Q?YDZVqtirClRxb4QhiXhiY/G0z2v81l0c+dxacUtHNkUDXJzpRLLvXONbGkDn?=
 =?us-ascii?Q?lHKQX7un7ZH5S9Qp3z5W0cKWnz9FbARUNMCbJ2I4+0Hv4NbOBck2qaa0w2m+?=
 =?us-ascii?Q?d8V8Ygm5QU/VBZEuCcDS6ZYwi4/o2LdfQeJIwOq33b7ditd7qHBDIXNyhoF1?=
 =?us-ascii?Q?khdl8poHYjZuajRPzfT0QVt5w9jpWPQpsIUcIgVj2WU2e36xQxBuHhOzjsnG?=
 =?us-ascii?Q?OBpaT9MBcA56bLMqcyAnqFWurQ2Gu8b8uPqE6Rjm9zuZgyYGDE96oQv/oXUB?=
 =?us-ascii?Q?WQI0MhjNWDYrhvJ6+2GC/Q3Aq484kA6T4Adpi+M0US4PbmcGdWibebYUmuTU?=
 =?us-ascii?Q?5X65fNT6FXbasppgLyDxN12QnDTpwxoD+SEwhMZmA/hSG0PwSEBbG17TbjgJ?=
 =?us-ascii?Q?3K4TSLPEIPtDnZrouehduJVK6mj8ulbuNT96eS2QLwt8Jtz6N8J7/4tB4/E9?=
 =?us-ascii?Q?h60pG6RdlQRrYleQKgUgq1awMbqnq31mc7As4KNYSd6Efj1Izjp+T438oNmE?=
 =?us-ascii?Q?7sRWKewGKW8ECOnRplht00tt2RMEu1YykLD4HcCLcXFkfLrXJUcX1IaMUQqW?=
 =?us-ascii?Q?rC3mzzqUsOL2Zu0xgkX4Aoj8hbM9eLPfViDzHIvtWZySqvAhuSUO/eBOYwov?=
 =?us-ascii?Q?0gVk0Msy7ve0t36zGY9X+YIpN+hQi/gQ41lpm6qmYuV0HOcbfhJRg+JpUHMc?=
 =?us-ascii?Q?7pv7lgQPBlAfEuSuyG++g0I7y020tvIGtH5todC4X9UCRzUwBUVfqAS53aB9?=
 =?us-ascii?Q?v6uifIUGfgtAfQ2oTFeglAjE281KruCxaierX270GMOQFJ1TmwbGraPrpqzN?=
 =?us-ascii?Q?7RWhhQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad278f0-01de-4d65-8164-08db12b7f9ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 20:29:18.6404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tHElW9MBWZZwZsTIvJ3/mX94tg1UFLMkI4b46hsqm/bJOodhf0/9lIWmOwkMWTl5SAhhHCQQ8dQDYjpLaWEY8AvY3q5Jzt+00kpLRhgANCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4556
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 05:39:24AM +0200, Gavin Li wrote:
> Constify input argument(i.e. struct ip_tunnel_info *info) of
> ip_tunnel_info_opts( ) so that it wouldn't be needed to W/A it each time
> in each driver.
> 
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> ---
>  include/net/ip_tunnels.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index fca357679816..32c77f149c6e 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -485,9 +485,9 @@ static inline void iptunnel_xmit_stats(struct net_device *dev, int pkt_len)
>  	}
>  }
>  
> -static inline void *ip_tunnel_info_opts(struct ip_tunnel_info *info)
> +static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
>  {
> -	return info + 1;
> +	return (void *)(info + 1);

I'm unclear on what problem this is trying to solve,
but info being const, and then returning (info +1)
as non-const feels like it is masking rather than fixing a problem.

>  }
>  
>  static inline void ip_tunnel_info_opts_get(void *to,
> -- 
> 2.31.1
> 
