Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89B96C703C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjCWScU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjCWScS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:32:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2128.outbound.protection.outlook.com [40.107.244.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDF824CAD;
        Thu, 23 Mar 2023 11:31:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQO6VNJwDerSoV8cFu3Mn12MdReE0kmNU0jhN95m1VOfhT44ojtfoOEV8T8dyq90PPgZsCS5+4wlc3qDfpjaxhugkzS8rrEIHPOuTMh2rlRgBgDHAvgvBX/lpvWZoK1bn4BWwExj3ArjYFSTsgX+EpCF//2ewOgyvK9jFFQRjqyyJ6I+D+vT4NPsoCZAL41FzNYLV8zmxfHHp85jSZA3UvwxGkhgGibwPe/9BKvpH/Dz+amIIfJkWMnlEZwHg1JTIvutSt5NaCIQJ7P8xbyfSYOYruDa0BUL4zV83U6EUH3+XrEfWVYga/8NQKLEm3ZIgBdp1CV0GXIT9QE1+O8+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lofKCubnXUaYWHmHuodlsCRyFwNUQNqBMaRVMvxVDoE=;
 b=d0wfgy4kAeWGbO0XaI3+cDrA/8ktkWujoFYskbW1W6/ILuicMubIrOIpeeuqIz6Vv0AeJtt5kMruiS8ScVhrRzySypO9zieg7I0AuHBNzmJSKuHBUgzKIQ+EC/Db+Obz/1cxtrdVOCcIdatSbFUAdmheFZjUwcUNyVv/7gwGEwS2UmC1RRPnISkD7wELM45Zs+G+/hfyLg5yl68QQeZk8l6x5rqxaHGgUCnfFSoth8fW1gmyQE0zRXRuSTuj09Soa1JL2YjmaFY4ldzkg89R46J7eR5nqPESoZrOR1fDQwd3sQe2S5Cwm8p+UM4PBYCZ5/5sWJy7CLvhg6b+4sNVXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lofKCubnXUaYWHmHuodlsCRyFwNUQNqBMaRVMvxVDoE=;
 b=XSYJ7MbbmI2t10TZKTAduxqc4rNUNPY7m42XGdq7wezZG6CuJL9C5SlxfYO5reyg2tUiysfwK7465IfuKZanrN6BPu24WMErf9RimbJX35JLinCoUzhMF9XmQoEyG/ZChAZgik17PbT/LaqWbKeMxmvyeX3APUkhZdvkOqgB4z8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5149.namprd13.prod.outlook.com (2603:10b6:408:150::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 18:31:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 18:31:44 +0000
Date:   Thu, 23 Mar 2023 19:31:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] ath10k: remove unused ath10k_get_ring_byte function
Message-ID: <ZBybCkpexqml5hHF@corigine.com>
References: <20230322122855.2570417-1-trix@redhat.com>
 <ZBtnbgeW9T75ZXfv@corigine.com>
 <0b9f9c45-7e88-deda-46a6-8c7961878b83@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b9f9c45-7e88-deda-46a6-8c7961878b83@redhat.com>
X-ClientProxiedBy: AM0PR03CA0041.eurprd03.prod.outlook.com (2603:10a6:208::18)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5149:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b4d2f70-5f0b-4218-8e5a-08db2bccda72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MqZWPIlhAKpD+mUo0mn2q60YO3J1TK4CxXAZpWKipnZwRhZLhRLc99fTwc9i0E0FOdoM9QBfmXOPQvMe5d90REoLqlqJmwC4FJ1yKmzmSWV2mkWZM2G++rf50z0udfzibwaKnrCk7LizeqdRgjvUFh1i0Hqw8z9XK4RbQHyB/pv9QnZ6XTv7Nc/hnpUB7y8Xrf4e9LGvRT+6vD2ty6Lrjej0jLkL+nJa4cgvDWEFkDtDoGgJF193n8ZzeDCfhUSQS97tz9HxbTN3ZAM+QAacGK8NpAB+VxdzMY/8FTrJ7w96gVCLb+O628HqcxxhXQl5GXJlOy52rjb+nZtPwk2YlOSkUbXog8OHTTCVp1nFZKjIQ3qwAeuhPw/Llvdpdt1mhKRHNMq1CSoJ9MlCStA49uUUJwsG/gkB3SFnhbdpQkj/5DOdjTjN1JcSTI2qoHqhUkYKJQ/3ZzyYhpMTC8i3sOaibe0OjRda1yMvk/6x9f6isy65MRkztmSnGGXqR1RN+ebLvZTyNw4+1UuKg9YdZ75D4zf/KA7RKLMJvONMeHh3ZuRcO6l+rkWW2rX/25eXFf38RM6TqTqNBuH8twufr9cGp+TsUTbiUdOTl2+Xk9+5Y6+sY0Mwvq1rF1siRrOUCvu59VgUWkQQCHoFZB4FTALFq0dA1Tb2eQt1RCBdIANzvXOKGGp65ssjHV8oDR/8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(136003)(366004)(39840400004)(451199018)(38100700002)(2906002)(6486002)(478600001)(186003)(2616005)(86362001)(36756003)(8676002)(4326008)(66556008)(66946007)(66476007)(6916009)(5660300002)(53546011)(6666004)(8936002)(6512007)(6506007)(316002)(7416002)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qt0SEXzdk6SFGE3SljezVfP7Q+8J0JXPDU1uK4w555ItK1UsHTqcsayigDFu?=
 =?us-ascii?Q?7V+rREiTndwooCG4mEdk1xFLF6kX+ktWZpmnMEA8oeMM00PQlBUZSEkc3JCH?=
 =?us-ascii?Q?1xfeB/FE9PpGigKn0Tjpb5ED0AyXzFft0FB5MFrYrYnF/H/XZS2lx+cyUDr+?=
 =?us-ascii?Q?AaCvBOEOL/1xH2RwY5m2Ng4cqJZ8ItaBkX8kAqdI5SEERWoy3GJh9YuNxNLg?=
 =?us-ascii?Q?A/DyyZm1iaUf8ThY2dTqJHgt7jVlsWy3UW216qxQ2rAP3AGzXpbbUKn4Fwib?=
 =?us-ascii?Q?Cb41KQPoftFSe2lDW+96nlGM/VBagCzGnMfndR3XkbTSIeE5oSWb6/N3k5wx?=
 =?us-ascii?Q?sLv9tfpq6xI77Y679FXH0t1PF1wyGT73bEVD0JivC9SYNBj2yKWO3xu3CN4O?=
 =?us-ascii?Q?WKAJxEqPy6E28qjtMVMNZ4UgcmLC2BovcZOQIL+nkrU3H4XXH5m0jTbNWESJ?=
 =?us-ascii?Q?I8nza1v/a4upS8B6lzVI+EgE+ivFB2U5XxeIaSCdQ0J2ObnNhg7IINA6Dk6b?=
 =?us-ascii?Q?iIs+MdUJ2oU/b8gvOYakP+VF6NFmzDkOL3RoLO2VANPr0MFi23sZdQB93Bjz?=
 =?us-ascii?Q?cSwC6wXErUfMqhmMr0m5hO292CAdPqwx+CmgZSZzQNSGYcNM96buarA+q2w3?=
 =?us-ascii?Q?0ivkIVQj5Zmsi6at6Jm/TQPFjxpYMfWwi2zxYtnqnfpz92XqEHdANlyZJ2ay?=
 =?us-ascii?Q?4n3qfArP7kh/DbwKhX0/8Rz/Em/AZ1SUI1xdp7s+lhpJfqyLrSqwq6LjkHCe?=
 =?us-ascii?Q?rt71aoAvo41Xyblq30AU9tnTJfhtPbGSprrRxf04uZ4y99qUpnKjtt1fyQ+w?=
 =?us-ascii?Q?1rXuXzImPoZLNnPzfQzYiWvphHk74IY1Yy16oVRzI+D7L5zh/Dr7HQ4yzv3f?=
 =?us-ascii?Q?GcpnLceIBGIsnw1hHkbpaVah/zHmLE5PeX48w6l6k0tz9Rrbec3nh0u1cBeA?=
 =?us-ascii?Q?d2VESzAtDBlJVRfFWURpuLrzuLLy5bchMLSla2K2wvnjw+Z02dJN+TW/bYEr?=
 =?us-ascii?Q?SK4/Vz20akWqL/C6Qj3667RDLZIHDsx3EJn0UnMG4+ZmD/g19+Yi5uxpTtFz?=
 =?us-ascii?Q?mTbK3fE7fWLtO9+KR73b04kNjl216BbWn8JQKUjIOxJzvAbeGAsAgh50AHI6?=
 =?us-ascii?Q?y0jLQnQ161IOS9kPheEe/xtr2ogPAjUEOS0Ceaw3getXCnMpF7Bl0Rm1ssiw?=
 =?us-ascii?Q?7XYHbO6Yt4Vwp1SKx1VEMzi2r4TDciraLxiOyhskFcfoEI5mQryYfRfrSZbW?=
 =?us-ascii?Q?hEx5G/uRfOBxFZhu5TLf+LeK9xrR/uUnGjDqSvDuYTvMJFqngoa/SgN9Gxax?=
 =?us-ascii?Q?hF4Pk1QHYqKVG39TIUziTZwHcrIUehe7vAIjZ+/zI9rjpoZhRj7U+ePVum+I?=
 =?us-ascii?Q?PHyCUuNUdtPfo88i6edPNE5RCWGoO7PVEwh3XpjNYLwBudmoyGqxtZZ+bIxs?=
 =?us-ascii?Q?J8gpzYwMrbhm9GISciJf/VRlNvqWdfOHGeNoyJtJ/xvPk7U/cKRYiItfbi6b?=
 =?us-ascii?Q?n1zO4g17/nPt1C/MqV0yLhBt7Rl8mfJ+mM1BnkSHZH6J/FR1szvb15EEw1G6?=
 =?us-ascii?Q?8Z5Y1xjiX8fmvUmstaOAKQom7wrcOPbfLuZwwSccledumb9vtHjgrBydECFo?=
 =?us-ascii?Q?DIGY+5SPlqCvrLoDDQTg7wA13FYoqHfLvFRkfC+f7u6Qa6MmMh+8I5WzfO96?=
 =?us-ascii?Q?UKtE3g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b4d2f70-5f0b-4218-8e5a-08db2bccda72
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 18:31:44.4614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGMDZxPTYrRzk7+pLZLMVpifim3zX0Rk1MW5YJ8oU8xJoa43biSMb7jjFB01bZYdRClNoTsAxwMRXCCgx3247gGevezCGtk6fzk8ij3HAn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5149
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 07:18:09AM -0700, Tom Rix wrote:
> 
> On 3/22/23 1:40 PM, Simon Horman wrote:
> > On Wed, Mar 22, 2023 at 08:28:55AM -0400, Tom Rix wrote:
> > > clang with W=1 reports
> > > drivers/net/wireless/ath/ath10k/ce.c:88:1: error:
> > >    unused function 'ath10k_get_ring_byte' [-Werror,-Wunused-function]
> > > ath10k_get_ring_byte(unsigned int offset,
> > > ^
> > > This function is not used so remove it.
> > > 
> > > Signed-off-by: Tom Rix <trix@redhat.com>
> > Hi Tom,
> > 
> > this looks good. But this patch applied, and with clang 11.0.2,
> > make CC=clang W=1 tells me:
> > 
> > drivers/net/wireless/ath/ath10k/ce.c:80:19: error: unused function 'shadow_dst_wr_ind_addr' [-Werror,-Wunused-function]
> > static inline u32 shadow_dst_wr_ind_addr(struct ath10k *ar,
> >                    ^
> > drivers/net/wireless/ath/ath10k/ce.c:434:20: error: unused function 'ath10k_ce_error_intr_enable' [-Werror,-Wunused-function]
> > static inline void ath10k_ce_error_intr_enable(struct ath10k *ar,
> >                     ^
> > Perhaps those functions should be removed too?
> 
> I believe these were removed with
> 
> c3ab8c9a296 ("wifi: ath10k: Remove the unused function
> shadow_dst_wr_ind_addr() and ath10k_ce_error_intr_enable()")

Sorry, my bad. You are correct.
Patch looks good to me (now).

Reviewed-by: Simon Horman <simon.horman@corigine.com>

