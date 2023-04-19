Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB6D6E7E4C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbjDSPa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbjDSPaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:30:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2096.outbound.protection.outlook.com [40.107.237.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FFC30F8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:30:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlDNX1vTHokxFoZMuIMWYnzQtBA4pogy4UC0C0mb/Q2RloR29bSgNW1y65cT4bpZ7r699/EexzW9YhvA+1d8Sw31rL4SMkLmQXBAFwzATO1ZaIrzA5nbAs736bX0lu8JcKVJInDcSIHeYtOpmLPC+r3UDDiAV55NFZx4InhrUYeMq5bfPfn5Z5+QgZepUc7rJIKusqaaHl28gUvyq8q9ly5Wl+ihiWy+JTgmJzk0yYXvc707jI97umpIthwESsiH01sIzEhgEhd2Qja/uZDUC+i8YBz/WyTbois5YTLDvmWDT9DsA/OG1DlEBYLym15kSwzvauXVNs9DAffPkjSVlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aq660+XVlbyiHoaA2RIEuQnqE2ufg85h2nXsAxcgk1E=;
 b=YyXoVjZYDpUxLD2ZZ+n0nneRXxVDYyDjtGjLreo+HgI43NYNUYrC+4vex7xqsSjOp5B2hf53vvQY+O1AiMqZ5puwVX8zycgXVAatKYd5gGd6zhzk4RtaOKx80fA87f7PiCj4+YgvfmX7IJWUuTiS+iodS/p++8ClzNiu05rHGov+YKfFjsSKqxeFcYOBsC/I9uSBQY9K+rFmqjWj1nOrcUftLiSuydbS5YVfcQRSpQvBJOd7K8GMIc24W+wlJWdGOdhTlRBRSQ4T4OurVxCJoCfBOxRLfSfoBuTEZYWce8NRhuFw7tBLhHTjrNTa45LhRZcHjr0jHOoPwPYD6dpxsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq660+XVlbyiHoaA2RIEuQnqE2ufg85h2nXsAxcgk1E=;
 b=vwf4JOhdIVVgMuhzS7vrtF93GnzL52TkFewxCEiYP2AvOZSBffsPHOAXtCsOF/51qKQoxVwHfqbR8/K+rzle7ZTwkbaoxWA/3+Jgv/skwyMwduUmATjOO0K3zwCzE/INhc90auCiL8SveAnq0iHGyvvVENz8/2A8nVTOzolr4+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4087.namprd13.prod.outlook.com (2603:10b6:208:263::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 15:30:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:30:41 +0000
Date:   Wed, 19 Apr 2023 17:30:35 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2] iplink: fix help of 'netns' arg
Message-ID: <ZEAJG2L3ARDfP/fX@corigine.com>
References: <20230418155257.1302-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418155257.1302-1-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: AM3PR07CA0103.eurprd07.prod.outlook.com
 (2603:10a6:207:7::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4087:EE_
X-MS-Office365-Filtering-Correlation-Id: 6716e63f-4095-48bc-a311-08db40eb08b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQahCOYhSNRrEvA0h0dMF9zlJiOgTwzH4PQsXMibStRLRJ2AbcUPZFTVxT9Bh2P0M1Q2EFjNDv9cdwZnN0GW6jaS4J2n2sQoX7tAmS1ixXOuDG/Dwd7pxJnAVIe3VopoEOuXAsgs5TfWBK2cvoMN/I0bNBMHPyn/iL91wtC7Kg8ZvHE9oMZngiA6d9pGRAkEnaeZiWKRwiY2i4avK4VGcJ0JJpEqHAf+o6PfaaxOwzGJzqJNMjXgCw4Kz6NH5TeozEeR0FoIEI0G2J6yKdc07RqYyeSbKgL5G1GslSz6LBZZQIMcabMi8MvOHA+g2/WAe8DTRrCtKhDqQRqZJZdXJms4eTn7fs0nq3VqKULcR+/Y/CTj4cTX8xfaeweOkUg/R2k+mTp7JHTz0shPWu7bT0N+opNBvrL6HHXfj3Syd53EHXFM5uq/ODw7ocqjE5qYfnwAhraS1My5nzK1mxQ3U+oPpm8F6zDUFRYwSAPVUYO7ami13dWJ3o2NoNGd1qfSlJooOYz02utlQPCcw57aFrdq/pTEKcGYqQ+7WuGnHcVSBm4PR/11UgIvTK9OPSSL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(366004)(346002)(136003)(451199021)(6666004)(6486002)(86362001)(478600001)(2616005)(83380400001)(6506007)(6512007)(186003)(38100700002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(5660300002)(8936002)(36756003)(8676002)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6c6oDPlka34Bu6o7ijVaJhzVApA6HVXMQ6rJDqK37nw0zd/uCG0E2AonMd3k?=
 =?us-ascii?Q?xPvx/UtmuCAZz3tcyFHflBissHwZa090dbL7dYf0KloGSEI6CXuBh3xaOHm0?=
 =?us-ascii?Q?FyOcLw3XOjL7voLhK5S9oGZMRk0dzxcc0vsiwESS2mEBxF6YYHEC+ALm6dYu?=
 =?us-ascii?Q?XXlnTT0sfqv5rwQHlOQMJMyr0ysiVu2/twXEB5N/GUbL2uCBu2ifh6BZPfLq?=
 =?us-ascii?Q?AKKQzIHsl8oUHzk8b1G8Ma9vjQ/reIzLBUJvsIv3/tZwCFahSTqG833T4K/m?=
 =?us-ascii?Q?NV6k9OsVfLHRTw8s26lWLUf0Jkgfb4guU6u3FVA9bVqnFb++UuCgVygGDALA?=
 =?us-ascii?Q?47+Db6P7eROeEKA7UJsU1I7kTZH0NYwZeuLD3y3aDRBqYh2X7j5hWoRLgSzB?=
 =?us-ascii?Q?YifIzLb7ybAtt30kPaR575JJLIUhwAxAigtyAiFUc1L61TOKz7xgfG9+RZCh?=
 =?us-ascii?Q?FQq3v0JHdSeavX1ZiW0KUQMRdSREy+6fFSEiVH3a83F7k8B1lLwdEggIJcEI?=
 =?us-ascii?Q?e/0uffdWEPwPtq+9x5h1cs/dyDvy8JukIc/o+qi+qZBFH7wFL1vMAXh0LMPr?=
 =?us-ascii?Q?axWu0kBmFFkcODZXz1RfP0VWkCZz0qwu6D4b6gvvavbkjR4q3JRNbeXx9mTk?=
 =?us-ascii?Q?hVitAOkemq/f6wCbSk/tivuyP8J7qTthxTrMdVWCL4J1HlP8kBmQxKZWgjKd?=
 =?us-ascii?Q?yNUn72vUkplbKy09K9O/9R1QtqXhonhHNaQxk5V/sxbiCwczKWWKI4VQn+5B?=
 =?us-ascii?Q?JD91DkP3Lxk6EwduMv6DgvIwIcisGmqbFyDaNTIH0G2IK6+acSTIpM8ZxeaK?=
 =?us-ascii?Q?3Zl4Z4yeCVhqRxdAp6s2kQaJzPvC9DknYYPnKmEuLLtc4zhiF0IRkWEKCZXx?=
 =?us-ascii?Q?N85kvM7yiKk8thRpGVHPRp+zpzdE0ibR+u42olBXEH6SGku8lD8NKfaaBTTD?=
 =?us-ascii?Q?XRv5m2q8/oEDYy8DDCfvxeDMCqjxH0CjgMFf12iQ1zUiqptT1AGhMNGWO18x?=
 =?us-ascii?Q?6cysOqKlVCd0n3391I0LhhH5eB/EIaOQWm+lLpNsEY5xldZf2oVSKc5Hmrl7?=
 =?us-ascii?Q?H1b+DY8s+CNSePu0fy30g+30DTE2Zv1crvEiwRzX2GzM3PiGPeWdA7XHE4FF?=
 =?us-ascii?Q?ZcBTlTrG5fcD/ETIB6mBt4DiK4UHZKU5rcCe0LM5aV8BW+UkMdNmvAwUn2JF?=
 =?us-ascii?Q?wZCJttbRRWC6LrQJmCeGgPLiGtByY3hFhE1ue8lts+1277zOcx/Q210/7mBX?=
 =?us-ascii?Q?E3SXwHMT9iI+XLj5KILII2ffP2WOXZFfXsLaWEwhkrjDNXhESYtVCynG3Nmx?=
 =?us-ascii?Q?vxsSbyWAl6d7JLAsw0Hl44Z2Q3Z7whlwyQQRDHZbxwNAnpktIbEaIxEQCkdb?=
 =?us-ascii?Q?MQaWVDFCvQb2V9bKqFJZ7GyUFCTN7BHcoaoy/oeB5XnabGg7HpzNKxn92XXa?=
 =?us-ascii?Q?tbMsS3vYreu33D6YcyAbFAKWQX8HJHZVJHUaLs1hqnrr9s3SoDoUSo9FPAxm?=
 =?us-ascii?Q?PmfsWKgM4PBw+o0PmhPdej3nBk8sZb76EPi2dugqKOsHLCaj5/IWWw31PCva?=
 =?us-ascii?Q?Tef0uHk7MdyerJL9TrWfYfHipF4Or8an6PZVNv8LXLWcuf9hfyXr7kWCfObv?=
 =?us-ascii?Q?55rHoIjiW17qGio2Fq092WJAM3v6fg0kfIX+tbkahNSrMGM4g9Ujmno2E/Rs?=
 =?us-ascii?Q?DP1D8Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6716e63f-4095-48bc-a311-08db40eb08b4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:30:41.2750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y360CteqwBxhtRtgWXyONV5LxLul7nBHhu+Z9S/fWSPtpxBTM5A3KIWuFYXo1TmVbfKMVXk56zoGQUpoatzriaq5/noxHBivj0dulHOe8M0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4087
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 05:52:57PM +0200, Nicolas Dichtel wrote:
> 'ip link set foo netns /proc/1/ns/net' is a valid command.
> Let's update the doc accordingly.
> 
> Fixes: 0dc34c7713bb ("iproute2: Add processless network namespace support")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  ip/iplink.c           | 4 ++--
>  man/man8/ip-link.8.in | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/ip/iplink.c b/ip/iplink.c
> index a8da52f9f7ca..f7db17a9869d 100644
> --- a/ip/iplink.c
> +++ b/ip/iplink.c
> @@ -63,7 +63,7 @@ void iplink_usage(void)
>  			"		    [ mtu MTU ] [index IDX ]\n"
>  			"		    [ numtxqueues QUEUE_COUNT ]\n"
>  			"		    [ numrxqueues QUEUE_COUNT ]\n"
> -			"		    [ netns { PID | NAME } ]\n"
> +			"		    [ netns { PID | NAME | NETNS_FILE } ]\n"
>  			"		    type TYPE [ ARGS ]\n"
>  			"\n"
>  			"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
> @@ -88,7 +88,7 @@ void iplink_usage(void)
>  		"		[ address LLADDR ]\n"
>  		"		[ broadcast LLADDR ]\n"
>  		"		[ mtu MTU ]\n"
> -		"		[ netns { PID | NAME } ]\n"
> +		"		[ netns { PID | NAME | NETNS_FILE } ]\n"
>  		"		[ link-netns NAME | link-netnsid ID ]\n"
>  		"		[ alias NAME ]\n"
>  		"		[ vf NUM [ mac LLADDR ]\n"
> diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
> index c8c656579364..5b8ddbf20359 100644
> --- a/man/man8/ip-link.8.in
> +++ b/man/man8/ip-link.8.in
> @@ -49,7 +49,7 @@ ip-link \- network device configuration
>  .IR BYTES " ]"
>  .br
>  .RB "[ " netns " {"
> -.IR PID " | " NETNSNAME " } ]"
> +.IR PID " | " NETNSNAME " | " NETNS_FILE " } ]"
>  .br
>  .BI type " TYPE"
>  .RI "[ " ARGS " ]"
> @@ -118,7 +118,7 @@ ip-link \- network device configuration
>  .IR MTU " ]"
>  .br
>  .RB "[ " netns " {"
> -.IR PID " | " NETNSNAME " } ]"
> +.IR PID " | " NETNSNAME " | " NETNS_FILE " } ]"
>  .br
>  .RB "[ " link-netnsid
>  .IR ID " ]"

Hi Nicolas,

I think corresponding updates are also wanted for the set and add
subcommands in the DESCRIPTION section of tip-link.8.in.
