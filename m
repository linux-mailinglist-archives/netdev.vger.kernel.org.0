Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4436C9353
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 11:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCZJPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 05:15:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCZJPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 05:15:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2109.outbound.protection.outlook.com [40.107.92.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDD19032
        for <netdev@vger.kernel.org>; Sun, 26 Mar 2023 02:15:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRpcotWNSktdeZGBKlQPcAEgDR0OllmBpppT83smFa0f4f6z8ciz7nszfIm7k8aT0mSuA+CRmQRW3tlxW1YIFq85m27UAmvcTkXYxJUbTo7mox8CViWjJYFNfF7tkJ31yJpCags9wzYp9I/c1TNjLt8yqK6j/aiXX07JQ0GFI8kYY5IwSVL5QP8ssta/rXM6NWDqmVcVTilFTXgi29b+2//XTx4fE2/I+d/Kyn4pPJ6EtKPYy/evxkuFu0HyYSvMMFO0fbaZB8JEG2kTeJTCpxJ+r7nGH2WGLbuEF4aKMKECdPGw92YwuFnHB7ZHHmlpZQQKwzI5tuJMtJ5fLIuurg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5gqqcYWiXYGjy1O7aLbUXe1lArQkHYWUpf1zfJp+o0=;
 b=BfVT7e3gOrxe4vEsc5OFsE6Q5T9fEt0URicBqMfS+87I/9JgKjbuQadRR0Jo01ET7ZIX7c3dv6T/R1UPOWgZhbkPxlAMeAZ2QPzRkga8IcEJjHauOyHTV+QJ5BigkerziQ+uzP58WVe2FJJG/fDpo2VWdnuBp/C+4ss/o3b1lLWRN4ewmR6TFUbvCGXfjJhUopPJzlchqyXzPdnk8aKV3TWU13+tBSzXQMDSmcT01fBecegKzSndqWOlEFnNkTF9w6jN9Rf9ElwqvsFZqnpAqQb8dRhMS3qLs2ea43wfD1EQcNyj2pZVJqGCNB+4SdZs9kE0815dz6qGhz6LG51QTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5gqqcYWiXYGjy1O7aLbUXe1lArQkHYWUpf1zfJp+o0=;
 b=sCpKJQ9cUg79Dj1CuyFzfEqQNEGsTXQlwYDrfb5wOENZWj9k4yVhCJ8vCELocQCp2ym6NC8EOMCn5it44lXuxa/uW5FtfPGYBQbrvpYpD9OsRBg6lP3GKc6neSfpzZyNFijown/T8HhS6AzH79xAwyEMEM18VWhBjLNaQdGWUPk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5457.namprd13.prod.outlook.com (2603:10b6:303:181::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 09:15:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 09:15:32 +0000
Date:   Sun, 26 Mar 2023 11:15:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 6/6] sfc: add offloading of 'foreign' TC
 (decap) rules
Message-ID: <ZCANLhn5QygaA3m4@corigine.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <10dfddca2008ee4c2fab6407af4dc3722f4ff384.1679603051.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10dfddca2008ee4c2fab6407af4dc3722f4ff384.1679603051.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM0PR03CA0022.eurprd03.prod.outlook.com
 (2603:10a6:208:14::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5457:EE_
X-MS-Office365-Filtering-Correlation-Id: bf20c452-015c-4a02-47a8-08db2ddaa673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IGeY9E8tK/E+SZkdhjtMGt89LyURjVBcllPml2n+W9Fkz+QHp0mChoaO2yHOgYeq75jA6h1wx/yAKIh/q/4FyYvO6lRHsJIY8ZIUG1SJQa4ssZwQ9bRX7Y/v8ntapd7ioEXKMYnf0FjXvvqRrRp0xBxWWv7ri3/r1vXziq6+xk/38Q7W5bhZ9CVKVntU+vatflgW+4p/NtCZRwgvQXYv4wu6xwXRCr4EoOurhYdDF9uZeZaasQFI+22qIikGvPrzqRuWXb7ajgpvp+BcwQXQLuFijHvNj3+Od9m5lIT1LCcmTS/M5E+3rQLTuutU9gO9k4yFoY8CqnLC7ivIA1Xh5iMimyyHm6kBBCw3dZ9277oR61XboS6uvBGfBuKzXWVR6VjhRv7MGD0CWS2DkUk0af9gyS4mnpeg9pNiqTbWfLicjtznnDcFlDQ2LBiv48IwBowssIaTEuLz0m1ZfCfKDvoEUSIEz7Z44csx2z5lnWLktG/wjU8MC7iBVx/EIcaRRARJF/ntqrCyQed99xAojUPT7t0qKwFXBjoVnR0AUwlb5VT4B/0ziLNBu8Fx+Wet
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(376002)(366004)(396003)(136003)(451199021)(36756003)(83380400001)(86362001)(6666004)(186003)(2616005)(6506007)(6512007)(5660300002)(8936002)(66556008)(66476007)(4326008)(8676002)(66946007)(7416002)(6916009)(41300700001)(2906002)(38100700002)(44832011)(6486002)(478600001)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p3So6B/lO85pMmAPn5a3vJzQTpDFKrSPjTBYxyaAmoPowSZ+oX07O3UbTmYs?=
 =?us-ascii?Q?KaG4VyLgi38bgTgQUc5KycP7L77Ou/zU7PJkjVbenPx/YOB0OpB72pwXEyVT?=
 =?us-ascii?Q?KLyqPXCC+R7r6hrtOBvgnLt2ww+az719CLlhj0bNcAGt0wjNfrp2h4BMUeRE?=
 =?us-ascii?Q?phT/1PqeJtH+bjdWvG7dWUBssxqzwSKiiDKwpQjW1qZUKPydShiOkEvzYnRa?=
 =?us-ascii?Q?Gi4M87unuH+otJ9alNfPYjEaJt3YsUtnjbAyp8soFydZfpmZgobCoX52QKYx?=
 =?us-ascii?Q?5HuDmKwLyhPXJGKa5W46va9qwZA/h8yHY+VWS9d0234Xawl6JXg+yCd65DuO?=
 =?us-ascii?Q?snpruMjfdW8rklHC8dLDUuDf++aoCxbA58J1ziRp4d6G5rveaoh9SESe5Ht/?=
 =?us-ascii?Q?VexbvaEW3p05Qv+Jy6dELYJhKZGtiZ9HMjQ/yNg5p7dD7+EE9tf4efPFLUwP?=
 =?us-ascii?Q?R1v9y1HKxCgO/MDq0qvDhT5jN1soJYCZFSY/84CpwUHweN79KS4pk6fYFGEx?=
 =?us-ascii?Q?KUdeU6xcQ/IKYsrYdC+yOMS5/nUGrYyR8lJgUE5QhS573uZWRm+y1RkZUuX7?=
 =?us-ascii?Q?zIEvxBJ4zC9sCJnM+EKgjDN71NBzNoBetfcGl5ND6XaWiZtOINsaCIJ8DK4n?=
 =?us-ascii?Q?09LxMwbdW6SjX0xILmX55bXkBSWs4yCV3L3tksdPJGM5Q82Rm1aWuau+KXbw?=
 =?us-ascii?Q?kiuNS9RfE2SL6S5iBMkEJyJ4Fp/mekHHNnljbKodHZNdcvFfbpzKRlKv6QyA?=
 =?us-ascii?Q?qtTmbebK8acgeLZYgl2K6zF9V2W/6mDWXfAs4efU+9VLQjxNUmkzFJU0/CwD?=
 =?us-ascii?Q?LMH4KmfvxOJvEfgkIYPc1sEDupTj/pmFBejFfmYZmZkE1NR6RhKw+z/nKGXR?=
 =?us-ascii?Q?W8yYE1mk15+S+spUcGjls4BEV4zZVDbNP/5AqCSR2MTuFg+ldb35LpVmq+SS?=
 =?us-ascii?Q?r/oEZmtxoVW6/TceCxMnjja+zZ6V98txpaxaXmsE55wN73cW8UJvf3BNPwR+?=
 =?us-ascii?Q?XOHNh6+ylbXa3MfTyShjd6VnyIAPAXyUURwjB8lfjb7abHSuNeayGXLqrGEh?=
 =?us-ascii?Q?DI51MWaSigbfHxjXwL6ui1+kOCDk25d3ljLfsSDdLae48G7MM75UttHW2uWC?=
 =?us-ascii?Q?cJD/OtWOc9p1prC621i0BAnBSH3BpqtVU55oMdGfsn5Gfe30g4h1o194CMPA?=
 =?us-ascii?Q?/nPOHgQdGzBe9s2tU+GOIDZ34GvE97OK4tR92qdTv7FFYn7K9m27uwUchUHg?=
 =?us-ascii?Q?yRDDd/L+Op2h28MZi7CNQcAaG6nO8P5chZNIbE205yLPgporjuzMDOyWf57i?=
 =?us-ascii?Q?4ay8zmXbae1jpsDanB342GRFzkLquhm+oaqXMTK+hG0JQkm5kclPiXP9lUzq?=
 =?us-ascii?Q?4pFp2pHi7g1w8+ke5ly+EdVgt8+FH7Sh1WGpmBDL5eZBALcfrQsw2eB5EmVL?=
 =?us-ascii?Q?OPMCyUn5+P2e4fikvxg9Vy49DXlbxpgSfDS333s3+awE9qYFFV4KAVAq72iw?=
 =?us-ascii?Q?s+JtiLPxgZxzoV/31sVZ9P/52sGiAhb/CqAb1GST7Bbai6J0sgw14zO5sACA?=
 =?us-ascii?Q?wARu0UKAx1f8+XrtRjPlCSotsB8bro/PWQtZ5WY/AnRVYvwx/yxNOYMFGc7H?=
 =?us-ascii?Q?hJ9Aome5YaDeWIJRCXAErVinHoK6upT1ut0hdnwW5tVIkYB6RUH6Nxps00pg?=
 =?us-ascii?Q?oLhIxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf20c452-015c-4a02-47a8-08db2ddaa673
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 09:15:32.3635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l9Rhy3OW9dkf0lm+kd11U6bcg8fZ7PBudQut7xi1ZVN4ugY5JUnKbSodEV3ZtfXR6tDnGW+sXD9IONQkuT5tNUMxLNOS55Uv+XUBSJvNvXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5457
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 08:45:14PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> A 'foreign' rule is one for which the net_dev is not the sfc netdevice
>  or any of its representors.  The driver registers indirect flow blocks
>  for tunnel netdevs so that it can offload decap rules.  For example:
> 
>     tc filter add dev vxlan0 parent ffff: protocol ipv4 flower \
>         enc_src_ip 10.1.0.2 enc_dst_ip 10.1.0.1 \
>         enc_key_id 1000 enc_dst_port 4789 \
>         action tunnel_key unset \
>         action mirred egress redirect dev $REPRESENTOR
> 
> When notified of a rule like this, register an encap match on the IP
>  and dport tuple (creating an Outer Rule table entry) and insert an MAE
>  action rule to perform the decapsulation and deliver to the representee.
> 
> Moved efx_tc_delete_rule() below efx_tc_flower_release_encap_match() to
>  avoid the need for a forward declaration.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Looks good to me.


Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

> +			list_add_tail(&act->list, &rule->acts.list);
> +			act = NULL;
> +			if (fa->id == FLOW_ACTION_REDIRECT)
> +				break; /* end of the line */

nit: 'act = NULL;' could go inside this if clause.

> +			/* Mirror, so continue on with saved act */
> +			act = kzalloc(sizeof(*act), GFP_USER);
> +			if (!act) {
> +				rc = -ENOMEM;
> +				goto release;
> +			}
> +			*act = save;
> +			break;

...
