Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FBB6BAAA5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjCOIUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjCOIUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:20:32 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2098.outbound.protection.outlook.com [40.107.244.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D1A1A64C;
        Wed, 15 Mar 2023 01:20:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FqnXNjekbPw/qJsoBifBdTv2WMVcNYT5kd5NTVxsGb0epN4fapoykCypbY+MitPIAqaED2Moaz1sfXR04hqXo2kcnulcrf9QAiDLYSOfB2Jso2P95ufb/GQJ8cEViXN92ZGUy4UMutblIWKBCIO/0HMPcAg0/UHJiLGXNTQ4CEl2NlH58dreBEBtUmscz8l9C7OGJDAbxTLkxeGP9ksfMvD1qNqIwWWVLVdDWl0De4AtLrFtyvp2am3oyEHt85r0Zsb8dhEME1apXKdotnQmeVTktVNGQMCUCF16Vjjy71jp5KTs/ETfrzRgwJArvd54Ue8FfyQDVK9wB+Zp1C9wWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jchl8ID/5Ja0XSBwbqy+rXYiJFBVUlefmV6tHEIuF1A=;
 b=U2la+/oLCr8ehLcj70D903tPKWhyfSuVs+ZHgg4PmekAlXOB5MOoTOiPdFcTrlhjX5GXQUgKIa45Y4uOOkuW0ecuMH4JI+hg3ohT4eglR5HH58TFjQuYtKnBzvwYvLHrCtsImR/5O0qFQdYwEPdVYl18pc6YKBk4gPv1Did9VnBcf5UOVEsz57vx38k/ajhXp6R9kbLgLAnIq5r83THYjuZnVLA6F8A5kM4SXX/Jo9bq8Xs21266j3J3zKnEMSXeCPW4G3TI+CtywmMkkKcaI0aLX6122exLKXmfzXyi7ZWh5KTEtBfLQc9DfskMdrNZhePIKAQMOYtdLoIWGIDZng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jchl8ID/5Ja0XSBwbqy+rXYiJFBVUlefmV6tHEIuF1A=;
 b=NjJ3Q+fm1PapbV1mosyZSng2URLpaigz//ZnDblQLFW2tzeft+/ba1/GOtd8bbCk8ogx3cDMq4RdTgtI/nfRp3AoYjxcEqsBP7f8Rxu4PM3RFOWEEePvTAHKJLgiONiQz/a6Y6r6KmoOoDbnN1q7rlvCDFytuHFAmc21e0QIAMI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB6047.namprd13.prod.outlook.com (2603:10b6:303:14e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 08:20:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 08:20:24 +0000
Date:   Wed, 15 Mar 2023 09:20:18 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/9] net: sunhme: Just restart
 autonegotiation if we can't bring the link up
Message-ID: <ZBF/wr8HUg49gWZK@corigine.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-2-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314003613.3874089-2-seanga2@gmail.com>
X-ClientProxiedBy: AM9P193CA0024.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ad51321-cf34-45bb-8c45-08db252e2009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sbUkm0SdLbs369HsROoEKw+Daga18+Fi6JMR3OlN/H17spaqIONY/L/ojlASCNSujXsaD/2/GFB4YnQpklGTFRFPr+jmJXqA61q+/Xem3zcI/enYXI50+yZD8kjtkhfGDmJznFM1c9p/PGmP+OUNo6qdU9Dio7rWwzsc0oZU8HeqpmU2Gzme8T3nuUHoaesSJqNWKM9Z/V0Xd7/UHwhD+2wLFvQGUjB+FqVgcduTuXFrhY4VuxoU6lI+cC2lQJRuCRLwBqUNxKodtmklYJtwnBPLgXIqN/4ES6BWbVxGYdS0WYl13X6SMPT+N39EEInENFLP9XIQVQsRZn9OCovExaZBlyiRNffwcofOwqUTOB016ejdU58EvkA7C7HZ1vZ4711OrG1OhPFd6eaXKnjqGrnAOpHJf2PAf2IlaLMHTJqtUd1IWeoUYE4e5edvcQ2B4O8mHCYSv6npkZYLds6mw/2pVqhUrf/Xm5vzskGW9PonS1dy9+QPUeHdU2zGC1+F6zpgqQtUqd/aZV2VumV9Ch0SGZq7VHsd4KxjqhWIkTtioTXWnfcvD5NtjV7KWU9X2D33S8Pdvu3uHTnJHWLAc94s/IhZsDVXepbnHfiVebEmJg5RxwK5vdbYQLSeqBIrJwe7sLQm47AcXhJCgr+eNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39840400004)(136003)(376002)(366004)(451199018)(8936002)(44832011)(5660300002)(4744005)(41300700001)(4326008)(6916009)(86362001)(36756003)(38100700002)(2906002)(2616005)(6512007)(6506007)(478600001)(186003)(6486002)(8676002)(6666004)(66946007)(66556008)(66476007)(54906003)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JUP9VFAvXeMLS440OPNr8tLn8znZCo2nk+UB8PvBtLrDoCv7D8rch8XGakMF?=
 =?us-ascii?Q?ecLyF1qPxMDYQGFdhYC/41Wul2bosAiSZTwjdAUNW9VshJA7p8Y2X9kADDlh?=
 =?us-ascii?Q?62nBnuq5omnCuG+n8NqVx4/wZfJQFSgdJZB8LRI/LCAJBb4Di1smiV4sDLzP?=
 =?us-ascii?Q?u6ifJcLP3k/PmjsSslOL2btYg/I1mavPINKE5uztKnuEa6kL18AqtyTo0nDs?=
 =?us-ascii?Q?XSjOYjyJ3snf94Q843GIUiC8jiri5Uh0t4Z3lRPPENRw7BWEElS3+mY0ByMZ?=
 =?us-ascii?Q?zzNB2bxlXfW/wVVmEGAOuHENQKl8hLTzfR0JflcRqjOulnPHvBggxSVhgikC?=
 =?us-ascii?Q?5GokBp8KE83Ccqkz750Gt06wHVCKOIsBNuWarXt3QGnLrgRkG+BEzTYQYQdk?=
 =?us-ascii?Q?CzmSziPp7BhPzwDGSjANr169mx3p8b6DxxbWmDCyTwQIgFerqNG8d23g7xup?=
 =?us-ascii?Q?QVN1Jk4W3ivn/4ggYH60iDJD5Duw+k/MFPwy0AXoj18eNceFmux2AVqtb+HQ?=
 =?us-ascii?Q?ZBgh/A9HTWXwZ2Z+PfRdA/R5ejAmnP8E250f5KAqKvBsEMI9YsI9FEjKd1B9?=
 =?us-ascii?Q?+3PwDigrk4Rf3XCizni5/R+5YP9MV2e4OkFL2Os+KTuI8U+EV2LALB7AcTBT?=
 =?us-ascii?Q?yVWMz98IcfmVkZoAkZvv8BKvhHWasTmqrjvsgzAc5K6CLcqmuyhtjp1WzYjV?=
 =?us-ascii?Q?se2nbWhbo323Eg3hobVV3Arbw1NP5ZXKuv62mDUTArkLv0ZR+8N+aY1A3OHM?=
 =?us-ascii?Q?tGXnaRY6oH5co/hhw4dFM+rl7v1aHk2IVOsGLUGP0zxvH9vDYMtGMXPwGeq7?=
 =?us-ascii?Q?v2G8useQfaENDRmenLI2q567p5FXydN1RKrLRlV4mqCd5I9Ph0Q91MZ+4owF?=
 =?us-ascii?Q?eHwxBv06VHxtKRhgWWUb2mNoVTWEDfxV4J5q2c0+tFTziahsNSPpTeTOBits?=
 =?us-ascii?Q?HHUQzSGrMXvLXqNUv/PLK4GJyIgMWHUqy8p6Z73V+lX+7zF/U4828AUUTTvo?=
 =?us-ascii?Q?m/4ZSLwDRWSS6Vir3hD20vM9Uc2qnlLT/h5mBWd2XwVoUibcPbQh2kcdBbBz?=
 =?us-ascii?Q?3WlAIRumKSag1OkuSRonqoH041fPZF+qMCJrwJu5MZZSPbIwCm0vIqWpnsAx?=
 =?us-ascii?Q?48g07bjWt+Ei24+vw397T+l8n+f3jWhnjn7S6fl1sn4m3EsyQKaD+IwIGg+y?=
 =?us-ascii?Q?5mjIOTlqqG7DtEJUGbqKck6ZEZQaNptgfyDBok6flsNhTC4aKsTbQRIbbyAs?=
 =?us-ascii?Q?fEZ8Pasiyw7C0wGLN1QvRGYQWClXyDOayjqIUBOgIJJITNi966XDsMYV1d5c?=
 =?us-ascii?Q?jizb0wT4Jk0daqrmonfSFhxN05VCvDT54pVYKBr421icTGLbQwzKV2aHLgRV?=
 =?us-ascii?Q?hI6XCzPv9YqbAWr4lcFlKdiz0L/44nT8XTB1tm14ZPZVQwk/6SnCoBbvZG5K?=
 =?us-ascii?Q?KD05brfjBZXHmvhrXB6GtSSMXg29HclxXXpj2Bi8R54I47NwIgHElCe7bE7X?=
 =?us-ascii?Q?7PYn/onE0EaxX9gG4dBgvcNVbKXv86Z6el9BaC17mUoTSGNRbV/C54V3UsG8?=
 =?us-ascii?Q?xQTCWIsZEufMgsis53PTNG/R67q1yjSMcjZDdltjX3kSJbwCla4cd8bpJnfw?=
 =?us-ascii?Q?q3kAkslYr81aFx33ccQYH1piA8dm7RsLu9FJi92BAnUVplq87n+yswEvN3ZJ?=
 =?us-ascii?Q?1cQEEQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad51321-cf34-45bb-8c45-08db252e2009
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 08:20:24.0682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: beyG/Gv9aV3snX9tDzyxCQ/kq+lzYCNhHN7TvO4YfkwIrDz8tjEqyC+MFoAxCzw5mT6i0ANnz3b2pIEBxiCdLlMlqSnZTnHenqSpGYSO3bM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB6047
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:36:05PM -0400, Sean Anderson wrote:
> If we've tried regular autonegotiation and forcing the link mode, just
> restart autonegotiation instead of reinitializing the whole NIC.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Hi Sean,

This patch looks fine to me, as do patches 3 - 4, which is as far as I have
got with my review.

I do, however, have a general question regarding most of the patches in this
series: to what extent have they been tested on HW?

And my follow-up question is: to what extent should we consider removing
support for hardware that isn't being tested and therefore has/will likely
have become broken break at some point? Quattro, the subject of a latter
patch in this series, seems to be a case in point.
