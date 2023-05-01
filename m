Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3A96F3283
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjEAPJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbjEAPJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:09:01 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2103.outbound.protection.outlook.com [40.107.95.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F88173F
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 08:08:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bInxi285xBCUngVmqLGjddv+1VwE95yE/JnC0Az4NzMVJDDGTdFGkFuuRHUsGEh8d3cPI8S7kiKX5R6YDPY5qDsyg9EZp8ScMGHO5dcLVV0CDRHddh60HMGsGXfIJRsMbzoHOgjuAXiy4MKmkhLiUicDUmN6HtOsqCKSolqpAzompeOc/7asGdanINc/ry5ZyyVC5c7fIrb/55SgHz8HbS6QFeJu+q80IceC3bLWgi5849hJyVCGAiHHqDg+ZHJKRmqRljplFIcbP99AysANbW9uyplazBG1hyZXdjnMmLeBqojyIwR32ejlGB8SCLr3Qs1oTKC0mgK8JHh9rsmaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHATafq9D3D8/2t6H5EmWBDCYzjsJC0s84cq+mKC+sw=;
 b=ArudZUW+i0fjYWS8e2fRNIpvCIqSD0HPz5tSgzEYW32D05EEX+9grNbDB+67gi8MzR1n+LMlf+EV4R2yg7LM2Z4mgXVMzfL7j5aYkKhKYO2CUdsqY2sR6puBgabl2wHlbeFl8EvaazfNTiKbp5wVhRldmrA2jxzoZG0kuXrXcs3zEkgHzaVdBizrwkNmtWuRtETKrs7GIarYYJVm9VB80Vvr6orLPc0AY2N6aZU+zIvWXA7T8lHvTL6UOmUI33hKg7KXzyO2Ucjs5Z03733zIX9eGlBUTOvwLwujcAZQdfxyj2Fp2AVqY2OKeG94sdzgc3SKSQApUwZR1JezJIgN3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHATafq9D3D8/2t6H5EmWBDCYzjsJC0s84cq+mKC+sw=;
 b=WFm81Ng0JP8e7E9I2aaGHjd6fFW8+C72NGQ4YHnBWUniTEBWsz/ip6TLAYNenkcMtERB5W5LMRq4W95ZgSNb0VTbw7hxV1wnM6nY7RJBAwOLr5OKwksVNJwNLnLgHOly4Njn2WaTOO7ivzrcrpV8baFToFLDoFWHj4GA5x1EHFs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5059.namprd13.prod.outlook.com (2603:10b6:a03:36e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:08:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:08:57 +0000
Date:   Mon, 1 May 2023 17:08:51 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 07/10] pds_vdpa: add vdpa config client commands
Message-ID: <ZE/WA4lSQkKc90Eg@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-8-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-8-shannon.nelson@amd.com>
X-ClientProxiedBy: AS4P192CA0012.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5059:EE_
X-MS-Office365-Filtering-Correlation-Id: e1fa5d44-fc15-4540-9206-08db4a55fc92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kxoCmwOL187lmbePcOnOuqGdH20ISowo301wquSbfy/P7vTjZa+Q83BDO8mZl69NA4S9xS317bWj9+NCAG1oD6FRlae/UJDOqvQ2L2U0+jBl831Rgfjs76NVFglpxs5tBFNYjaAjccbR+4quxUNBdLQW7d1H60tlr6JX7ezO0t5c/Kh93z42ssNSqDI6doolHXwXB9oZduk/sY9riqMwiRSZqhUCcACbSeNFhdqO4Y0BMGnOyks9TCAEldsZJgLhQXTAzu67/HEcY3UWA5YwFTyn+IWfymztmmLkvBFUT/zdllurjEWAM/hu0u1DZk2SGcpW76A4375ETj0Z4s3dX4PYlKrqtWXggenSsAq3OZ0kuP380Jtrbl9xkyzgt82RrbY1KxXvavMTm/jTZ2488apGACXgGmp/GY1v95HR9l87onDPPq72AqUyk2UYytT3kE6E9wTEMkkZ0FlNUx9T6JMjqBXVh3DAwGg3yk2I5gypmSdWi5sRdg851GJdJfs0Ys+JbtWRZQlD0RlUmB3lVrvBbfwNtGqpA0jrFZdffZ9V5qJ5Fht7r26q6Z20GirF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(366004)(396003)(376002)(346002)(451199021)(86362001)(83380400001)(6486002)(6666004)(2616005)(6506007)(6512007)(186003)(44832011)(4744005)(2906002)(36756003)(5660300002)(38100700002)(66476007)(66556008)(4326008)(66946007)(6916009)(41300700001)(8676002)(8936002)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nst/cpbDvXPy4L/kltp2rnvOeoLo3K0u1muqqBVDSG3NofoHpbFHjsQz6CQ7?=
 =?us-ascii?Q?YzXYX0Mvh3Yf25GpZra+XeOvHsqjhq4Pda9DTrR5/35OxChEfMAhf390ugUf?=
 =?us-ascii?Q?8bKH6WjTTgA5DDtZcHzUbaRGlC8gJvQcOfWbIVKDtLOFRs2YQVlcTSqgtTvy?=
 =?us-ascii?Q?vZOrnWjhStOdJdyDBvFBl99BSx9KscvfwhHMDqn/prpKBowILs9aocM6YkWj?=
 =?us-ascii?Q?qDONxXEw9k06eHx3AbMUlSRHY//QFPT+RlZqFHFiLAjUx3OLVazdeZoiTkQW?=
 =?us-ascii?Q?sLORyMMHTowEnOVBP7VlG2b6fZ+9ws10vJJVbmKUTWLjanxEh5D0e2QLO1ra?=
 =?us-ascii?Q?jv8M07h6vsLJgQXzR2lU3A6CQE8locX087jQ1O0IGHwYH8MypnOABGUSXyLi?=
 =?us-ascii?Q?subX0yfCSG1wBQricrybdmviIahKO7aF6Gm3LKRNcKLoYIAfDrQVXUoODuu6?=
 =?us-ascii?Q?6Thdd9h1fPLcZiwcUhkR+FQU0pzsI5FrMH0mCOau18YlvWPltmi7VJoXJkIW?=
 =?us-ascii?Q?PL06LmF7dPP+tBqgg1TnzNxJhTicpN4Gp/DuKvEBByAYURPxtJU7QnhtVbUz?=
 =?us-ascii?Q?JHmr3FHNDwGwpNfCVAHZTrC3LnI6sf/OleYgnrIAr1uOplB6M66GWYGkEF4i?=
 =?us-ascii?Q?5nhuPv4x9fUDxhBofbZ6d9i0EYgMNN4GzAmSc0F/aqzsDodZ1wEdsvVYDcKq?=
 =?us-ascii?Q?qM8mMDgxXAHLy5HoRdimIE5iMzu70yJMIy59K9H70rVKRrU3CmvtnpoOOmTU?=
 =?us-ascii?Q?WsNi+anmrASnixBLD2BHJG8+zcci/BHu8GaDkNg90gaTYDHPiL4MS0ZCeyIS?=
 =?us-ascii?Q?0mT6SM/9rE0U1kJa6nXRK7VjW3JaqM6gvOBRAIbh0Ix8BzIx8YmoCc/FacHf?=
 =?us-ascii?Q?WnWQKd10SwoMIy6FLa4tuz2XHEP1GXdXbzOlIQBVi8WOhTNnYiWkXOLIUdW5?=
 =?us-ascii?Q?5wJIjcwDcOBczBMLtOf1aqBk8tDQiGXXnn/12G48ZLZAzvwxHZIj0ZQfGS6A?=
 =?us-ascii?Q?kySUQNCBpigBLghAFI0msEAtv3fvUUCNaKBRQ7jD8UeZwhQn19c77UR4deQP?=
 =?us-ascii?Q?LHDYrtH1vwdA/wHG+HmoRak43JVIhHjrjqeHdjPK/h4nc0D83BxHOi884npU?=
 =?us-ascii?Q?phlPAYHJsEf/8dmOWkEZ8mnlIc7Ej7ZghRXmBDBXQhZJnGnNmwTsddw2HAxR?=
 =?us-ascii?Q?m56umXxIBWHyFWEPJ4OWGtMIgT15hpA6+W/uaTcYwW4x3HOrAm7yw+3Sj4J3?=
 =?us-ascii?Q?g/zZMontDJR1TW1TrMnSeMeBrVbi6FJrFq3OQBgIWATPuvY9vycPMErv2iKB?=
 =?us-ascii?Q?CqkmjwUS1CisK8EppPj8NJXKG6ef3yiXjBWhbY4oqd8/qYadJ8k7h5RUBKc2?=
 =?us-ascii?Q?ooOylvXeSc1oA/Zkkac/YNiDkZZ5vpqB/Bj3bI1uocjOca+zaKx3jxeFQVT3?=
 =?us-ascii?Q?LDCAXvLGzexRoDTlrt+XdQxUsd4jLZGKTmBeRteLPiUFluYPlN7OuIwLxZeY?=
 =?us-ascii?Q?pzxFAIyCavWh1g4vFw3ew/FpUyW2mFBcdI2xNDPmyZFhaTdVMxdUYpQwn9jv?=
 =?us-ascii?Q?2vYn5xiyzMGtuvF5vWh5+pmGOqfz1wg9QvAovlT/96s0TvfxipHrBid9nCFL?=
 =?us-ascii?Q?DsYRocQXv0i5CCCd2qYJb3RObwBv4fX3ByWXvlzTRrNtQaEr/dsW26+UOlbQ?=
 =?us-ascii?Q?rstuJQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1fa5d44-fc15-4540-9206-08db4a55fc92
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:08:57.4892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6uS+v4UOwi0jJQch2IaNzCJM4lPHHz4TaIO4/tVasbi0NMeGt5WH416//VUGn7+i14VEl6/xBVUPp/JsJVgFGqoQmibWEqh0GnHB0H3trYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:25:59PM -0700, Shannon Nelson wrote:
> These are the adminq commands that will be needed for
> setting up and using the vDPA device.  There are a number
> of commands defined in the FW's API, but by making use of
> the FW's virtio BAR we only need a few of these commands
> for vDPA support.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

