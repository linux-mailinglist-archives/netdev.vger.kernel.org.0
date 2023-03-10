Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591D96B383B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 09:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCJILn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 03:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjCJILW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 03:11:22 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2093.outbound.protection.outlook.com [40.107.243.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8A4F8E71
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:10:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdnz+uAueyYI7pF7FHpVm095Y0JgFsfWnb48OzLvvu7+ffunHbqkL+FssIOzalz3Iy8kudsY4++wTySc1q5Jpg4oFn8FFHo39+KfEBd/MZMZdcZYgsCV/7iqs8RZDV3xHwNSWC4n9ibjDKXfZtDLthgesd6icPXpI8o23fhfKfaWPljKSZ16ROSjN/GEoynMU12wRhZaPM5StGz8gBPUkCaTX0KPtd6O31QtmuYAlvGK0QC4CNkp3x5BHoTckd+ID+Ouk4s5Mg0wk/IyrxhR05VYj7Wa0ZlosM/s5sAd/Lr0YglD5zT6oLqUVc9creyNYNSdsEvtMoexks7tiOII3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voCIJsKWAEVx4lIRM1sJmmqbrcTy0Nv8n/lHDNsZqhU=;
 b=Yws/dNtyPAcvjE1enbvRcfTSWA9vTOLwe4y9UfdMiXA7vJrUd2UN8S10XBIoTYyNZXA/N4pkVD1L3sZN3kryxjNP+z6AG1EUjBl2eOpcjB6q5RSVs16dh2oM+4Ng3i/tdcEM3RYIJFjDbBecT8f30EUQaWJqls0a5bsVS8kzbSj9TBySbCZw0QqnaX0NcmrRk6xbL2iMqTBBzJtdBNrh9FPAvdWkaBbWLAK9pIImx0wa130+dafapHj9d8XK+qcJ+DfzjkGMPK0dd0lwyDHeOWZHO0DXmq36vGnL8VoqDcdOf4DSQ8SR4e784akxC4a73y8K6bT+sJIxkzB7ODmODg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voCIJsKWAEVx4lIRM1sJmmqbrcTy0Nv8n/lHDNsZqhU=;
 b=W6y0LGyOS/mYemnQNqTank04HTQvRWRc33WXhYdq3tIQQ7YK6/wSeUT9pTK6UaCFkwouZPm8qnjmGVInQUGsHKgMYeQWtjuo7wHkSp9mEqQdMWebases7evD9jVEMyoQWptL86PxZRjRJDzYDTMM0xjpfe4JDODbKmvan5eykYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5511.namprd13.prod.outlook.com (2603:10b6:303:196::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Fri, 10 Mar
 2023 08:10:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 08:10:10 +0000
Date:   Fri, 10 Mar 2023 09:10:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] man/netem: rework man page
Message-ID: <ZArl3M0nRN/1WUXp@corigine.com>
References: <20230308184702.157483-1-stephen@networkplumber.org>
 <ZAnrnrKzuE3Mj8K7@corigine.com>
 <20230309134727.340b9520@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309134727.340b9520@hermes.local>
X-ClientProxiedBy: AS4P191CA0027.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5511:EE_
X-MS-Office365-Filtering-Correlation-Id: cb537500-2745-481c-f371-08db213ede32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGfDPxMMYUtbJCqXtIsemyZsC5KLb8h2yxIxx9ohrf+KvGShdV7bYwLVLNwow2uiGIUKzXX+7KkKSVdmbPtP95ABuJnU2EBODKrYJ6LPq4v8r8Y0CXcR085DudrL1ON3lwQ/s6F7k4CWYuDqnNPLNNsZG0HLG0piIr8YJaabns0sNI3BuZmj4jW7ozMTn8tcA3cZoLpQWDeQTesKTWOq4F9rC0GkNmvegkAWHfhiz1IXBMse1rNS9uTz4/cT7IL/uV2PBB46R28sMXbbZWiAn2mZr+iAXnDYFxgIQqnsga3RC8uvNbeTtQ2WMNZ+ynwuG8VrEdy7N/NlrfCUtKIHZlnzU5t2/4+3ClKWch5gbVcC8zmv6ekgZ/kgG5gYMSAG0ddSjODBEYkwNnTLjogJIIOr/QI0YpV8efDPSb6LGdqR3meb7+xzYLQzZPVbYgD4KoV6wc4EFIi5cbY/Ct30qQfy/L73lROQUK21Qdj88jNdhT/n9ckQ34C38+Hmj4l80Lx/BdNvGLeD73FxwNqIMUue0VMTFcnaOyQyelCX2RenAgdGHTT6MBoRhtpKvVQssIeUk4CKCDfNgPn2RsHJIlR1Jr14xmlbDrAL9WYjhuI14KV2d7usdP9qe9BnE8/dG2TRvyJTrxZOh0+4ZZR33uaFcedxZCw4ubl5Q3GeM/lV76JsORkKqVEJIzRup8cX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(396003)(366004)(376002)(346002)(451199018)(36756003)(316002)(478600001)(5660300002)(2906002)(6486002)(41300700001)(6916009)(4744005)(44832011)(8676002)(66476007)(66556008)(66946007)(4326008)(8936002)(6506007)(186003)(38100700002)(2616005)(86362001)(6666004)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ecBbfWMnX15O1fez/P8vRw3wCG0D77+zfUXY1aMw8HixSGqo0aTBScaff4Ni?=
 =?us-ascii?Q?gC+p8fxuJxh+tf++xxkTh4VRItTWLmgaPQy1aSwavQWyZWTMpbtoZnfgKOir?=
 =?us-ascii?Q?0P3y8tr0yUpFH8SvtAJwKCU5KYaJKT3RWI1Oit3q2YdhgF93c4OQUdX2lLbG?=
 =?us-ascii?Q?38IWxEKMMu6P0Aa3PuBvYnAMgXfDDrXmYgfTOCI4JzYV40mFJ46/1bqzJnTN?=
 =?us-ascii?Q?O2en5GPHgbjr/HwyDyegXPtdGeWFeBoC+lu10NHvXe6YFS0I6umv4UVhg4nO?=
 =?us-ascii?Q?17bz1M13eETs1hx5ZbdbSeJ9TJB82J7h59mR+ycBmARilqtGyGMasZLyyZm1?=
 =?us-ascii?Q?3Ras3aXB+FdJ/1xrcZJ3hnVpnWLWgre5ku3bEVa/7Cp4MF2FweOHjhhhD5jP?=
 =?us-ascii?Q?iVYQ8eAJnznwav/Uz9FO3hwWQJ1rsylwPaEj7oZTPEpvT16MVQrMfUnjA7hi?=
 =?us-ascii?Q?z8oF/BBvst6WH1J34PMRhyfAOOhEPitFN2AwqTPVTh4l1RYVT+1vymUPTdvk?=
 =?us-ascii?Q?jWOFF0qxVHDPQebsbTNm9mcoezYBWoz5QIyss6fqWSxNklXH+gOdE3Y7Y8sm?=
 =?us-ascii?Q?D3cHlENB6eP+2YR5lP2LQxNGZViVUXUxvmdAknzfLPBj+v1iuGs+likwys/p?=
 =?us-ascii?Q?dils1xXDj4Kv736tpCFnCzi2mGv5reoXO2zUEMjCIVpExZh+7lJNQi3lCJmq?=
 =?us-ascii?Q?/crFi+CnvAhn3CAe/wn+le5gd1Jug2xE7xyk+HB3SGV5uzCzPleh6Ug3HLS1?=
 =?us-ascii?Q?BGn4RcaTJdTlPLigH1xoU3Gf+najzg87rImN03aIOsIw0lnvRGEI/xHGXkgE?=
 =?us-ascii?Q?ydo6zeFeRzUGBEspctaT2Q8hm/uzMy7zx5tsF0Oe0hKbdSuioRSA0lefr3ol?=
 =?us-ascii?Q?hfLAKsf73nfi9EuXJbVpSg0s8ujwY1x7v7XzrX1MjYzdHfJJnEfbb6ZbwN9n?=
 =?us-ascii?Q?3VDCyX7H5dtJTf5YHCNTIe8Cpdv7DP1f1iEyogyfgVSeQ0uhChTJVJJ3tMIx?=
 =?us-ascii?Q?oMSTNY0WvRLUh9AcQ8mGJPx9gtK0+9ts5RqPCMjxLwm1vPUpRPC32ohRr542?=
 =?us-ascii?Q?oIRI6f+Su3+jMVD/MXsKAnBJbUZtsz0unUfefSIlCF5TsrJCJa7oZLYZWTZr?=
 =?us-ascii?Q?ssgKil2W4Lgc0HmZXr0z5hKfdgbYowo01k2SBvt3BacHgis4nRmwN+l2FkYJ?=
 =?us-ascii?Q?ch2DwaDiLeFm6IK+Jz8SVzjktkIuV3auvkKuIRi6BbktyXpn1BCk45NXHtTK?=
 =?us-ascii?Q?/s4zeBOhFMNDJsS3krxv5em2J2XUO1d5pbqzx4w2zlY8Lt+PEDXIumFPYutS?=
 =?us-ascii?Q?hHfpTXVf/iq+X58V0vyTMFkK4QIFJOJ0niSzybeRSosVY/BN9bFHk5gpCSaD?=
 =?us-ascii?Q?LIB7svQ89mfOb5F9fe+rw/X7D5Mtu20CTfDMmxHCYO/0iJLH8+KKmTANVrmJ?=
 =?us-ascii?Q?3nKtBWV7DFzW8JtQk0Noi9lCPAPfYFyO6UUf2GX3gIH6YacbYWQMgpAr5/jA?=
 =?us-ascii?Q?J1iluWvDAeFRCbKNtxffjxS+l0NBTZ96ZfOluUmrRqSoOE8RRqTteGAosBzt?=
 =?us-ascii?Q?TimnTZS1P+mCdaRWpcgjXQnjCf7Rb74oB3LYH4TpbUdWAeiH1Kauahh2iwEk?=
 =?us-ascii?Q?l624vI/2qyrwIhqX5s0+9fZroI61J9s1xOIOUW9Dh0QUJnBDVwUvwNm6snuM?=
 =?us-ascii?Q?Al2m+A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb537500-2745-481c-f371-08db213ede32
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 08:10:10.4814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gpuCda9uMt4GcOs4Pt6gwmhlYLojA8RPn43R4eNb4ZMEZ0yzgUajw/13h/K0cPen6YGR5tNsGyXdK7hriShjqgBgWad4kS7XDL0zHHtxhTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5511
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:47:27PM -0800, Stephen Hemminger wrote:
> On Thu, 9 Mar 2023 15:22:22 +0100
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > On Wed, Mar 08, 2023 at 10:47:02AM -0800, Stephen Hemminger wrote:
> > > Cleanup and rewrite netem man page.
> > > Incorporate the examples from the old LF netem wiki
> > > so that it can be removed/deprecated.
> > > 
> > > Reported-by: Jakub Kicinski <kuba@kernel.org>
> > > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>  
> > 
> > Thanks Stephen,
> > 
> > some minor editing suggestions from my side.
> 
> Thanks for the review comments, which I incorporated before
> pushing the final version.

Likewise, thanks.
