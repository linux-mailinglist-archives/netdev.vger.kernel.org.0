Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B836E99E2
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjDTQtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDTQti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:49:38 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2134.outbound.protection.outlook.com [40.107.101.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BED2710;
        Thu, 20 Apr 2023 09:49:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbtzSP8k4xZskqWqUzA1zAUJkWHkvbdqUwcau7gRJNnZMpqCNM/QnmsuI0tQGEEFLggFE1oV2DEQGFO4/fMvSor2fZZK1l5IvYiLHfOzmzDhnsveF62cM29za+0DWGpnExTEFYh1b0zaG7wtriZZWX0rfibMmW9AsH/pq4VAVVndSA3D3xM4l//SMPXwmw1ZFNKfmoTjCG75nZw/1D//wpqlYOVVmwwf9AbifnKLpHZSMPIsruzQt1c55CaPmxf1TytrOAnY//MmqmGH9DsSHLA1aqBXT1NL93GDih5DAThCgpTIDew7zRuAAsszDQsREsdTrITkfkRL+SvJGa8oNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRUGAsTglCAyPaD2qqPp307hRSbH7SQ58At8/WHpiuU=;
 b=HLCJkMVn8vN+vlXhkpxTi3uT5M/L/Wqlewur5pSMNxtUixcfDgnTHKjHRK0nFjcOJ4ZTcfg1ihiOJtSwRhBbi9PFswqqubuM02HE7TP/7AvcWCk98j6h/MA740RS2Z0b2RdTKm7r4EZjuBcXzmOl3DRc1Y2aStrQbfiVsGElTU2hYyfH2YxiakJemJVWnCuFgRDWoadiqZk7GbTrljQKGJkFPfMbqmGpr7IlJrkyjKNw+StVrS1hQxl3eolWiYXFH4JA6hPwycRkaae4TW3tkubOPhWBza19KZCOtCfOX7Xb+BA2MDWC4F9VYTPGmgsI4jsBjn/tLl4eoRlS3r78HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRUGAsTglCAyPaD2qqPp307hRSbH7SQ58At8/WHpiuU=;
 b=YeTxmB0YUW+Iu5W7bfr4wJtU8g75uZMnnJ4bv2F3am0UGfASnUJUI+CzBFhLtSRerMpTKl9iWBDNhEWmCY5GO3JVws0RjD8ZVyQsessdd/WAQgiLrYPsZRrflMD+jEyPakbYSsIF1WPWjBFcrZwwYpx1caENEeeyui9wCPyjA3g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3646.namprd13.prod.outlook.com (2603:10b6:208:1e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Thu, 20 Apr
 2023 16:49:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 16:49:32 +0000
Date:   Thu, 20 Apr 2023 18:49:25 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/9] net: enetc: only commit preemptible TCs
 to hardware when MM TX is active
Message-ID: <ZEFtFX9LXxcc+Umn@corigine.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
 <20230418111459.811553-4-vladimir.oltean@nxp.com>
 <ZEFPbNCNDWy0c8eK@corigine.com>
 <20230420163453.4moc7ie327g5rgfn@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420163453.4moc7ie327g5rgfn@skbuf>
X-ClientProxiedBy: AM8P189CA0025.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3646:EE_
X-MS-Office365-Filtering-Correlation-Id: e594725a-ee89-44b1-77a5-08db41bf3749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JiAzeqESuBZB7xhNctqAaN48lMpH9LBWGJq2tm8yae3wbRR083luN+AxiSb3kOO7QIFgDzTODjeKrS0tf7kZIYoOQ9+KBIYhYxX8+ilMU/SVaKTFakOMgl0JnSD2DOBV7nQptDRqe3pXDgXjJH5z3Um4mULSYHI0IMszgJeesG+1PnuguPHO2Y1FF9EWZv9jDYh37UIPUy2SNRtRvz78Qo+mN1zPpjsGoEuiGrSgq3phpFik/VKzlUgXNcCdmNsEVvgAnx56ZBs1QtnSbBLN4ui0edwtNz7FifF1CvkGRuGPax4Ga27lkGBGmYIH5dy8d9OlE9lpIZz+2/kj4swZqYpBzz49OBxR0oDbLPHK3jN/voJ0vGExXUJgTbbnbsQrOr4pocGXdbfmgSwiFCl/Dyv3dO5+RGyDmqnCW4BW92biKzFHW7Z3emAkdViASw3EdWjFwIPM9WdYsgo3/RsBYA8IbxPiJ9TSRQjRgOD2pzbyNVO3tdZ3s6oCECxqEXorqe0ydTBxtCKJnTAhQTDarQ0Q2wXdknULCCRjpZOhDsvc2Gl1/3MEVyBTDS7CrD1RTimXuVvXaycjTt7+PpTEMnewx07j2KDKZ7UiDKpz4DQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(346002)(366004)(136003)(451199021)(36756003)(478600001)(54906003)(6486002)(6666004)(41300700001)(8936002)(8676002)(38100700002)(66476007)(66556008)(66946007)(316002)(4326008)(6916009)(2616005)(83380400001)(186003)(6512007)(6506007)(86362001)(44832011)(2906002)(5660300002)(7416002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9/T2YwL4heUItZzfgb7stNoKZbME3ASMxXU6ZfTKR92+TtPP/gZ99SaiUue7?=
 =?us-ascii?Q?EensX2PCPmrdETaXXmGun2bTeKl8lTpOLuvY9v1jHlVJCSAHj4qOqrLtIAbr?=
 =?us-ascii?Q?DJS1scNVpdIAI+G1M48nWL1cXxpd4Xc4O6I2hJqEPa9T+A12mEcgdMvEQ6W9?=
 =?us-ascii?Q?MSAmV/z/90fTtcRCFJcBT+jSxOfI0zom+1omYg8eBhwnnTUU4ieDJ8GfmJqZ?=
 =?us-ascii?Q?xeQrW6BSC26VR2xC2QtnQ0oAIEM+CAoJe1MDA0bFyq5Y1DIry1yc8FNVNQ1o?=
 =?us-ascii?Q?okRfswdXophCebtrsbc3qXaO8c+2+k7b0AiVpcfdJ3e2XTVYMm2nDrcZ+nts?=
 =?us-ascii?Q?eOGtxHaexRgUe12rMfQrRoS+f6t6ZMVAxYy9aQpYmcpFmK17q87cGeF4KFpX?=
 =?us-ascii?Q?x4hp38vf8YzhPxNYEsTuGENII5IjQgWJ6cPopywlMyn39VBlCHyNhTczdWrJ?=
 =?us-ascii?Q?yfqMrkcA4JQ86MkTp1u0CekKYTS2vtDMc+1DquEmt0SKA8Oj3EUz/U110EQo?=
 =?us-ascii?Q?4S0Lh7tW6NEA0hRa+SYE3fcush42+UeTQvtvh8IyWDO1l2TRLEQA0X5U7bbs?=
 =?us-ascii?Q?1NX4skve1ZS9w/PIRsDz0RmTpzJcJFObALptQsZQbAC/jbj6KYbiFGj/MpG7?=
 =?us-ascii?Q?ZMRMvBbay9Us0zQIUd30MycYZGpLh/DjBjVGYN9lTcBwgxSvi1/2dJ4w9FXe?=
 =?us-ascii?Q?6thKGns1tqo/urVQUtprJgEjeYpYNfl2UYAK1X2lNr8emNpcrUJrQ2y9iYtN?=
 =?us-ascii?Q?HRiBz56uWla9zLmbbz9wR+L2sKGJYpsmYheWn899HlWENVkpf0fP5Ua63HN4?=
 =?us-ascii?Q?T4StbTrKcA1vuIgRc5QA4nQ8LOuQVmWR5qps9SO53wxy0cFqg74RogbGfqxj?=
 =?us-ascii?Q?sWfWC+O9nRRtFbRkYXnANfLtHXzB/veEmUiW+uJFXlVq0mO/Ffvu2ZRPjDGn?=
 =?us-ascii?Q?Li+kZYlm422bNON5wZO2p6CQ62w3Bxh5aIvDzja94ViAWSrr/4GAeZJ2ZQKs?=
 =?us-ascii?Q?JXUpImpVTTZ9ISN7YWQEYfBDtIS0sn2cGnAVq1uOuSamkIaa9y6IYYP0gAcv?=
 =?us-ascii?Q?nzdPFiOUp82Va9OMi5IUiXDtXklHPSbcjREYDqAZdga0vbP3413yQ6o8q7E9?=
 =?us-ascii?Q?T/HMT/KJ3Z7AHpDNyvtBfqAN7tj/4M2CdgXPCejQg8gHAOG1B4joLh6eURg4?=
 =?us-ascii?Q?iw1PEorExDkX4pEgk4UTPiNOO8UTkJoAydTbOWSO3OPs13onat8ynlard1x4?=
 =?us-ascii?Q?IlEXOf9gnvVEZv7sPVLoT04QkK5ank6J5/QKADPUXdVdmN8bv3nyFcScCi6g?=
 =?us-ascii?Q?hLk7JgZQxKCu2+Ww8qSslh7XnQCtfufNyhxCK6a0lCXoh1Zbt1rADql/Ppea?=
 =?us-ascii?Q?Z+8iU7bdvkqCfKfUf9h7KT0k6ZhYdlZiFNzUORoQ6nXOC2KVxGXFnj164H1Z?=
 =?us-ascii?Q?XH4G09muens9vHtV/mbbpT/1+eQ9zqgP6JeCK84SBBrwNj2tziBvo2KOLxCN?=
 =?us-ascii?Q?LI1zff0l+ndLimuGyo45YMF3hge6jx8WlKvzFCJktQtSnZExHJ3YZLW/jsUA?=
 =?us-ascii?Q?MAxi/ZQFLCshj+DI+qvyrlZgFj55YIJYg8w8kRU8TCvs4vvF6rGX0+g8ojNG?=
 =?us-ascii?Q?c564zbUk4/0srk1Rxe1HLLeoRx8gEJ1MXYx8Z+lEnzq7OTb69CXzsUD4RCpI?=
 =?us-ascii?Q?Lf1m9g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e594725a-ee89-44b1-77a5-08db41bf3749
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 16:49:32.7199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ea6mWctRDosiPqVshePMQl4+3ABj58JczrLyOxfO4iH2AhDAuIx9GSpFyIFA9dayQMXl35Le6gpFvXS8EzGU2vvEO42+WU8Etxxc5tDH2AM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3646
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 07:34:53PM +0300, Vladimir Oltean wrote:
> On Thu, Apr 20, 2023 at 04:42:52PM +0200, Simon Horman wrote:
> > > +	/* This will time out after the standard value of 3 verification
> > > +	 * attempts. To not sleep forever, it relies on a non-zero verify_time,
> > > +	 * guarantee which is provided by the ethtool nlattr policy.
> > > +	 */
> > > +	return read_poll_timeout(enetc_port_rd, val,
> > > +				 ENETC_MMCSR_GET_VSTS(val) == 3,
> > 
> > nit: 3 is doing a lot of work here.
> >      As a follow-up, perhaps it could become part of an enum?
> 
> IMHO it's easy to abuse enums, when numbers could do just fine. I think
> that in context (seeing the entire enetc_ethtool.c), this is not as bad
> as just this patch makes it to be, because the other occurrence of
> ENETC_MMCSR_GET_VSTS() is:
> 
> 	switch (ENETC_MMCSR_GET_VSTS(val)) {
> 	case 0:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_DISABLED;
> 		break;
> 	case 2:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_VERIFYING;
> 		break;
> 	case 3:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED;
> 		break;
> 	case 4:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_FAILED;
> 		break;
> 	case 5:
> 	default:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_UNKNOWN;
> 		break;
> 	}
> 
> so it's immediately clear what the 3 represents (in vim I just press '*'
> to see the other occurrences of ENETC_MMCSR_GET_VSTS).

Thanks.

I did see the code above, and I do agree it is informational
wrt the meaning of the values.

> I considered it, but I don't feel an urgent necessity to add an enum here.
> Doing that would essentially transform the code into:
> 
> 	return read_poll_timeout(enetc_port_rd, val,
> 				 ENETC_MMCSR_GET_VSTS(val) == ENETC_MM_VSTS_SUCCEEDED,
> 
> 	switch (ENETC_MMCSR_GET_VSTS(val)) {
> 	case ENETC_MMCSR_VSTS_DISABLED:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_DISABLED;
> 		break;
> 	case ENETC_MMCSR_VSTS_VERIFYING:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_VERIFYING;
> 		break;
> 	case ENETC_MMCSR_VSTS_SUCCEEDED:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED;
> 		break;
> 	case ENETC_MMCSR_VSTS_FAILED:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_FAILED;
> 		break;
> 	case ENETC_MMCSR_VSTS_UNKNOWN:
> 	default:
> 		state->verify_status = ETHTOOL_MM_VERIFY_STATUS_UNKNOWN;
> 		break;
> 	}
> 
> which to my eye is more bloated.

I guess it's subjective.
I certainly don't feel strongly about this.
And I appreciate you taking the time to respond to my idea.

I have no objections to leaving this patch as is (with '3').
