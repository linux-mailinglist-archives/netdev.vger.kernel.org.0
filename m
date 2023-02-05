Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244CC68AEFE
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 10:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjBEJVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 04:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjBEJVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 04:21:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2105.outbound.protection.outlook.com [40.107.92.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F172C22011
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 01:21:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6Xs+GsPQ6Yp5JGROBN7uk+Ptt9fzYFl1iqvAyMegSPNdDS2HncC1Wie5DE2QQxT6WsiX8PAP52lw62UXUHNTxCA26Ev8ZXvmn/5/dop9p93HbW3nsGyRdfa7FUMurB2darjUiNNe7eislWrzxgEsCaj3Ipnjf7+nrw+NA1IagJU2C8vhjGVYSWMgpBeksxMcJeIxQAV7vzP8x3QESSuuVIOsca5lCP1Ri0u+Le/K4t2DWMa8S2bQXu1crZsSzc/Vqk39FV3Fzs+xaKVEZ5WtNFvJ3xCdmoPPEMiEXaGGDvqipu4lrQ9SmYvDfZdVB1zgJthv7BVj7zD5n/8FNLbfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESDDhyY7se28SJzYSxXIm+Aao+RgDSrOtPLMisu+FOQ=;
 b=L7WetKBTqZHKe57zffIkpU8W0GPprCG18uLl+xq+oKazSy6lm4RefmxQXRvLaJ4ZOpYjn6wh8rC32dIGezznLFNpUT8gmxgZgaipamRbb/Y3eRLjz6M/FTAokyuOBQW2wG3RwGAPjGl0W3IF8NPrxvvcz51LWR/aFy5aOuhznhSmmcLd37F768d9/MgCkgG/FcLqGKVwXhirhAydSKozrky+MPC9IQLkSNudVW2gJ36UtwImLtpZORmHXVyuK8N1/nc3PfZFoztbWdWN2yu1eGpWQtHY2EKq+5XSwA0IEu5Z7AUmQ5YrmdQrrqwv4OujkqNrAixgIOdpPKAlUxwepg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESDDhyY7se28SJzYSxXIm+Aao+RgDSrOtPLMisu+FOQ=;
 b=T67ml39FC93o7WLzvKW72gRlGjpEjB9uq5snidNwnAuampbIAaN/JcdfaLPyUCnmyjrNfXD52Gc88N4E0zHtCT0yUqBeRJ1+51MPQ02tsmHOZ2grUNL8CM5Vx+1UG4KtjFabypIao/SMBf+THG6kWRwBNpHT7znnw8cQmYhebg0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by CO6PR13MB5305.namprd13.prod.outlook.com (2603:10b6:303:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 09:21:43 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882%5]) with mapi id 15.20.6064.031; Sun, 5 Feb 2023
 09:21:42 +0000
Date:   Sun, 5 Feb 2023 10:21:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Pengfei Xu <pengfei.xu@intel.com>
Subject: Re: [PATCH] 9p/client: don't assume signal_pending() clears on
 recalc_sigpending()
Message-ID: <Y991H+54aoY6pH8s@corigine.com>
References: <62bcfc44-aef4-2536-a2da-acc8a68286de@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62bcfc44-aef4-2536-a2da-acc8a68286de@kernel.dk>
X-ClientProxiedBy: AM3PR07CA0125.eurprd07.prod.outlook.com
 (2603:10a6:207:8::11) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|CO6PR13MB5305:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c4e9e4-0e94-4c26-6a2a-08db075a64d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IZpNQnyRtTYzH0XKx+pCLHm/X1Yl+NududaurF7dySYZScvZM33M+E0hawmuSxeQgskxMsvUMlWOe+biYeTOaKhQcqlAqDH1lZvEo1+09Mjxpts2N+D79CEnvZlqW95qbaq6H86QP4HN2GxizNPrl26h3vx7mLYa6ryiWpXSbgDPVNHO+kI1wCOpBOpIes4GhLzzxnN9XdOzpSrsXsYAxWEIRiYPtjImC1IQ/T1JrBIPbDs6IUsUAYiGaObfuiAnwej5RX7OaUe+1R3bVNaU2pBaMFmssuYtZE+aYxq3eeFphf1k5s/+iOc+vy5w3WMVQ4UHFjCGvRFUPVoQJZXQ5MriXHHQxwBKPSePk4ycU7p2UzP00L/3MOIoGIQOBvPRrKBZUozHWyH00UypINHV1VrEiDV2tYPF15Jx7QaWiCnfKVECyAcfP49Xyy+7+h41vt8XghseumQJpG9F1ze0TYjz4oFkK2q1yUIXH9o8FtTqFKTLo7yaTiTGWbG9hXPY1RaTH7krw+JamWtbC9VcKnI1pXP734vzIgpNeHKZZGbrgfUcToQ7D1tlhews2VUC7nhSHUcK+5pYucISJHvkDDiAp+SY6QiPjGw+kbq4FzsPKSqzc6cm2IvDijvk1kS5ak5JQJWIA9GgLeOslAXgBdjMCfkLSnAjOpAvUHu3DnWQ+IjsavJSZGs35SLQecrRGaVLb2TGeHjTEvBfVeSMS6Rw1Ly74T4ZHoLLZTyxB0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39840400004)(376002)(346002)(136003)(451199018)(36756003)(86362001)(38100700002)(44832011)(54906003)(6666004)(966005)(6486002)(478600001)(41300700001)(8936002)(5660300002)(4326008)(6916009)(8676002)(316002)(66946007)(66556008)(6506007)(66476007)(2616005)(2906002)(186003)(6512007)(66899018)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BeryfnP9nsvl8KxB6/30t9klR9K1Y2qzMsp8j+jgXtQlvBiKq4q3viklaLnq?=
 =?us-ascii?Q?2sCm5XCAAo4q49OfYLl9xq13wadb8hq1/JkLvV3S5XGw2vqQlzbkm3PyBcUL?=
 =?us-ascii?Q?kc448mBk+RFGmjKWq+uOntXuVudrGAv7kJGPcw+qvd7pHnUMPfpmPpOpkawT?=
 =?us-ascii?Q?K2iJYurtkNDNopq5aDXoB6XblGKgLnJsW74cyA6NvNjx0IBMzcxQdDFxka9b?=
 =?us-ascii?Q?8VIHnXJYJTr8QvqSlAaaWCaK7+pa+nNTorT2A1iTX+TzNbRiReSceVSSDvYu?=
 =?us-ascii?Q?zsSkWFgOE7bvSaklCCxFh2+/LyzTGkiwPyW9w5iXgkZ72Sm2IkgKgdbVUq4G?=
 =?us-ascii?Q?zGuztCahwRMXwWhka6U4R2jhWFu5R4jWG3oPCt2FSkfBZmbAcnNX7xfdCa2K?=
 =?us-ascii?Q?O3d4a19aY08C/04UREw4uhyf0PBxcioWKAeXuMDFrRd7kFKkcnRRwB8OAouY?=
 =?us-ascii?Q?rRlRbN0v7NCaJVX5rr/VkWDWtZzfaeEtk+iOoOZVLaOVREr30jmM0JoGRuQH?=
 =?us-ascii?Q?GazYpadANJeabAtK2VtM1Ogqcd0xQcYOnEwCFC/Yxkifxxp1xvOjbhzdWiBS?=
 =?us-ascii?Q?jB5T2P7B+2ZD5o2ln3uOznez3QYK+hr9OY4O5cmI5Sgm5MlHhslf5x6K2AOg?=
 =?us-ascii?Q?T3Vm8wdK9ady09ExHTenayva/Z7Xlr9hhRtP1fQownyQoRQtjSgHJvLdn51Q?=
 =?us-ascii?Q?PpQ18diXg+3ItNHAJDG+J4bZ2gFy7lFjBmQaTEpHzbqW/7IoCtvfxFLPLi5e?=
 =?us-ascii?Q?CbgScTpyjORY95nHgNzBwbQlPz3LB6WplgNUSubJPt1SR1vYxTrmgD9YBL2n?=
 =?us-ascii?Q?kKuSzf811+yQsQtmeA9C+8cHDV2QJDsMbwp2kUjIs9f28yul7ZgVwYZ6B40Y?=
 =?us-ascii?Q?TQh9M9LBoc2xrp7vexzegx0no9mcLefkycnNq3kUR4B8QCeBpPYmdVKTV3jH?=
 =?us-ascii?Q?K8r+DXsWCSjV4ZG63plWv6Oqp4XuWV4/fc810g/Emoj83IsqqaibhS3Bt92t?=
 =?us-ascii?Q?sAn8N7i2G62bMTv8/iAIn8ltw+8mXogDBuhAAohxnyiTquREHgGb/aOv3LZ2?=
 =?us-ascii?Q?qd54OWt9ty5+PFpuHOwP37notAGcHTHkaQtmIOGCa5s8juDl+yS/2Py4mC0H?=
 =?us-ascii?Q?1jGMcZW7WJlL1y38rR8+H7X+7Rk41PNWELO47Bdz3Vwou8prXxGCw/fJ60XO?=
 =?us-ascii?Q?XS93qzZaoAV+vtCuUKtgzoLmrd9mbbNkuwqqBrQrIGssL512HFFPlVOm7T/E?=
 =?us-ascii?Q?yX3MOVQV4PHvBO87yyJo2eABabV53HZfNMlP+iKUdW6loADxuYyKJAe/GGZw?=
 =?us-ascii?Q?krtvdj3IM6UvlFr5mf9Wy2aRaLaiptQ0LtzBTrlJUSGpalGvdJoBtlPmbJhs?=
 =?us-ascii?Q?fIJIvp/+UkYkuUuYoOr95b17etp1xWyNE8TpyqljukW8EH82PIT1OBCZNrYx?=
 =?us-ascii?Q?tvqtPUMdYpZbZIrtpgFh1XtpfegmzSwMXw23fyjTNQTj9J6opGZ/elh7kgkJ?=
 =?us-ascii?Q?OnDF8NQjUusYEOR/kofMwCT3/cHkhz8PtriBak4mkcIMDiPwEbiR6KSmYQDK?=
 =?us-ascii?Q?luOW2BGNe7is7cz0+kQhZ70XFQxESVgYTCV4cbrOfFkDaeLmVZ/ceeoQmRgK?=
 =?us-ascii?Q?t2a1z0NURECnJQ20C+ooJoFTY2DihKESMF9PwiXhPge0G7TSzhQmhQ7SHByy?=
 =?us-ascii?Q?UbS+sg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c4e9e4-0e94-4c26-6a2a-08db075a64d7
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 09:21:42.6003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3n91jpjbujjwL2fLKIWBtQDj4GmYYlzdJCDQR97+YtkbkIcsL/d86u6SqLmQRI+3R77zmUGbv6ZSEMfVMqjM/6i7eO/U7gBU4ZTIaeJJLyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5305
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 07:02:42AM -0700, Jens Axboe wrote:
> signal_pending() really means that an exit to userspace is required to
> clear the condition, as it could be either an actual signal, or it could
> be TWA_SIGNAL based task_work that needs processing. The 9p client
> does a recalc_sigpending() to take care of the former, but that still
> leaves TWA_SIGNAL task_work. The result is that if we do have TWA_SIGNAL
> task_work pending, then we'll sit in a tight loop spinning as
> signal_pending() remains true even after recalc_sigpending().
> 
> Move the signal_pending() logic into a helper that deals with both.
> 
> Link: https://lore.kernel.org/lkml/Y9TgUupO5C39V%2FDW@xpf.sh.intel.com/
> Reported-and-tested-by: Pengfei Xu <pengfei.xu@intel.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 622ec6a586ee..7d9b9c150d47 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c

...

> @@ -652,6 +653,28 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
>  	return ERR_PTR(err);
>  }
>  
> +static bool p9_sigpending(void)
> +{
> +	if (!signal_pending(current))
> +		return false;
> +
> +	/*
> +	 * signal_pending() could mean either a real signal pending, or
> +	 * TWA_SIGNAL based task_work that needs processing. Don't return
> +	 * true for just the latter, run and clear it before a wait.
> +	 */

nit:

	/* Multi-line comments in networking code,
	 * are like this.
	 */

...
