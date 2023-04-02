Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758EC6D37A2
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 13:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjDBL3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 07:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDBL3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 07:29:06 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2126.outbound.protection.outlook.com [40.107.220.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F730E19A
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 04:29:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLx/6fHPZg+TnXNUoVnQyQpGepLF/xdUQAAUxrtvrV/MFWSBR8TIcqEC6+DQwlt2v6STfp+TujvlZmKAOK2IviAfh38xNSJ3Yhk3TNMmnrPq6KMtzjJhExd3JdIxoJmyDLzRHhrxEHdRi3LsvfuXwzJVCF6BNFVNiBb87oieBxfw8OzfEbBubX8i5W1ONsH/W6I802yKqbV6vOFoATf2yu/yTn5rFBh0/uzqI3q0wA/KxEifmuHVGMaL9caNRDSGy9tFzY2bYZHhzU/S3d1H8sRfeM+kqnG/oFSvWjxemwqvLuIVPvUqjjJgW86R0UIr8FVFvS1gJdy43g3EAG3NVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4jfABLcdJ+SG41PAMwULvGDXTK1dg9b5bHZgkTMnCc=;
 b=hd975pdNS6avlEmCwz0B2R0Oh8VbmSVuB5OqXQr6Kjc0hl3RJ6Xtt0X7sMdGYDrRNQGFKK0BaPPKja3TqIXEfiYAd+aaa6apfIk3jF+N9jPLNmuQ5TuGHkeHsFwc8J47jHkTTd6wEauyD8bEctup8UDe3mNOGiMMelaYhtQmHul6dEq32y/td5gV9Z/Pp6/Sxw1hsj+0d6WtnU9f2LRQpH9MpsUJQEguNEcF48BXhi08rfeOs0K9k7WzPiHQ6+A1QvYH5+SJSaxjnZaJw1zVkxF8bphOof8KtP85L6IvAUSAiLOvSgNd+ounoWTynsEq/yo3ocfRwPzHRTiWyOP5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4jfABLcdJ+SG41PAMwULvGDXTK1dg9b5bHZgkTMnCc=;
 b=iYIGCeqVLwdEcDs0HmHVw4yAO05JnwChNGc+hqAXZT8hMK6X6msPEcPCAs8+lReurmz3tI++2Zs/jFFebKZf/MtJMkTjNl53Ys/JuhOp/0jlSDF65TewaEscOdi0Bu4MM0wBk6HC+ILbWDANA/c9I3N7/SBmJgCqhfXhMUF8asM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4858.namprd13.prod.outlook.com (2603:10b6:510:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.29; Sun, 2 Apr
 2023 11:29:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sun, 2 Apr 2023
 11:29:04 +0000
Date:   Sun, 2 Apr 2023 13:28:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 2/3] mlxsw: core_thermal: Make
 mlxsw_thermal_module_init() void
Message-ID: <ZClm+RaO93TSDgiZ@corigine.com>
References: <cover.1680272119.git.petrm@nvidia.com>
 <7f2b22b660fa20f0a4cbed0126b579e40af44dba.1680272119.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f2b22b660fa20f0a4cbed0126b579e40af44dba.1680272119.git.petrm@nvidia.com>
X-ClientProxiedBy: AM0PR04CA0095.eurprd04.prod.outlook.com
 (2603:10a6:208:be::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4858:EE_
X-MS-Office365-Filtering-Correlation-Id: 82b6182c-f569-4db0-1139-08db336d76a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EJNe1ioNmffmbcUJxddZtmj2fjwScl9LaPXShjsxbRztkWkASijQsRLnFQDtbdeFz4+zL0NS8pHHq+eeqduzBkwtGuT3+h5MHt8jhSDTFl/oK24NKvf3aaxK1JuEmCfIdk0COGTLGqJZz+5xI5V1l3y4fZ5lU4/52hCR99uvwbskJPqmy8bfZd1zOl2qiKA+ljdvptzEqKVuAngm7G0FrtgrL+FGq50beyfwjylXNZc16bTvU1LMaySzNcGkefu+Ie4PHNH/GD1WQayT9NXPbFZey+N7EaOeXX5V/O0S3FJq4Y5uSKx00xzmJufrb5tafXkwzQA11fukJpN/JDSVQQLQu/n8JgQPKCt3imocJDuFUzASHYprdwEoFgbJxtgM/Hri9udyyI5RrAncn7+SeX/2TPk08GPoQvuTLmPG8PwUZbeYoOn+TNPs2ZYC0M7ni6ybWPVY3kXNhxl+5MBGkNP4fB87dJMQLKVF91AIwyQHp6gUKoI0sPWq7ii5dLJ7NxA99B6U7s9P3gkX6v1Vh5STVzWDI6nRzhkMuzll+RZXBj5OnXz/paqkjvkwFoZmNTKpK9189aRto9zxFXJXx263cjSsnsBPCi8YUN+SyG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(136003)(396003)(346002)(366004)(376002)(451199021)(4744005)(2906002)(6486002)(316002)(38100700002)(36756003)(6512007)(6506007)(6666004)(86362001)(2616005)(478600001)(186003)(54906003)(4326008)(7416002)(8936002)(8676002)(44832011)(66476007)(5660300002)(66556008)(66946007)(6916009)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3rhVY/5cdWdeGopqizmE4dU7v4JSMlCIXltOtuoxXIsJHI1Er0lLlKFnnHij?=
 =?us-ascii?Q?2HeimbhgmzCpTqTZ9pfClrdNprTOmVY6rmhrUu3WeamXS+Ln4RHEKpvgbwai?=
 =?us-ascii?Q?dn3g+2tM8dhc+w3oSbbJkgl9dv3rrEjPPZS2EGjz2ox8cqyr7o20VzvdCZqB?=
 =?us-ascii?Q?7u+hBNadOBmFX8mgG+J2wTraFiFyvdOxBjpncUplyolDtWRCpVSkkM3YeV42?=
 =?us-ascii?Q?bDwxJ/ot8b+6XPQJzfc4hSUFe1zH334OUiHqEtvNmjA7iBGCI1TkZZQ0TIjq?=
 =?us-ascii?Q?7g2Vji7+dUCdNfK3V2XM3KwlnESwFAHEqN/AGRwmlRuct+dXxpkfjNSzREUY?=
 =?us-ascii?Q?HU7hkQRpyPH1ofWSwqE3GFl9KbngR612SKdfG4bssUcgs2gr9z7Iww9XdK/m?=
 =?us-ascii?Q?MksLooC5209c1UFuSu7Ofj9RpKLadbUoNx9hFNE1yQE/Of1mHBQ3JcjsH2kv?=
 =?us-ascii?Q?vxEqQbjRYzhQd02gR5pEnyYeNSbQc6/rOjvsnEXbJ65Atf+MPgrXm2e9+JGk?=
 =?us-ascii?Q?UQjyoZZ3mbYUNIRKCN6wdc8485+zFvcoKDC3sOFqzRmvFnGb0zY1GLaBZ11D?=
 =?us-ascii?Q?5JtcbP5HBzxolw5Mf0NalvIZrjLLbqnYqgBgfLTiVvc/g8RLIYhkUTHCrAZ3?=
 =?us-ascii?Q?VxlcdqiQOKTG2WEjNfU7bbMBkBQU4nihPvx/c72D7N01+qpFgnx9aEEJUxZS?=
 =?us-ascii?Q?QT+6tOpglpDKi5jOlhrBsSajG6V/7PT0mXOlaxCKRkKzlP81ptfIjmlo1/2x?=
 =?us-ascii?Q?v69OHK2B3RODJFo7hi6Y0tCo6p+0iJV34ndDlGYCtLwvb3zBBvzUgZTOK0Nf?=
 =?us-ascii?Q?ehGtKeu72auUtIBaT9FAMnD+h5flArg3bBlBwvR2Bzh7OiCH2wKv47R9uqAt?=
 =?us-ascii?Q?fLaY1MUjGatvwYAh2zJiApDOkpWn1EX+19A0Lo5Ah+eIJAWMU32nDuGaVrj6?=
 =?us-ascii?Q?+qdagCXOS6KjTcGgrfvJbkgg/BuIZh3Udmfq5+TZjPRjpqYO6lh7Ck5NtMiM?=
 =?us-ascii?Q?cmQ5ghjP9GUYu7Af+qTcTxZuI7VlaV30f+ydxYYojjZAAKr/z9iI9yG/5xBr?=
 =?us-ascii?Q?aMlt1z2DMddYp/ZMTZH9q0EtDqaCiilS2PX6HBcktgQrzAS3R+fshJfXYqjx?=
 =?us-ascii?Q?MmWWB7zWXypOHtbIZPDVg0pvvb72/1xwuSBQS23dq+mgCG4Iho5ahlws4t7w?=
 =?us-ascii?Q?CMXLa9UhqrDQOLn34pSlxkVRyeVO6qcN56Je3SQXYBOR5tooy/S/WaoKdawf?=
 =?us-ascii?Q?ry/4x5srYGZtLPtctTFr5WcSq25qWQJunHGK9v6lB/oMC8lkHv+52ubBamoJ?=
 =?us-ascii?Q?hVT8uwOWjXnNjJjRBXKfNR7ZlceDta7+YHBmvqLxjU2Q9t9XVOJGhyTMio7W?=
 =?us-ascii?Q?zGJuJ/W/EGLZTwOZw3GyU6n4hHd3sjwW38E2OjstyiEM8yAYZ24+4fSpDUqA?=
 =?us-ascii?Q?0hir+xfItqnmhmKWETYLWe785Ghc/ceALAMnTwIuGg5tTLekV3SxVvBHCRAs?=
 =?us-ascii?Q?O9nb6PYJDtHsszSJakiODgGbxyP6u/p4yVVcE3Er19jAidGG7LmO/gAWHIzE?=
 =?us-ascii?Q?WcPPKhH2pF1gVMidbfydhIDnovrFc7VDzY8iamVCdDS/YLQyKfCbx5d9L78E?=
 =?us-ascii?Q?DlDwtxmdBgFRHfFYlBS5zhF32sd/gRpGeG4+jjpEVq/OhHxTw9255OqDSDOY?=
 =?us-ascii?Q?N50lWw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82b6182c-f569-4db0-1139-08db336d76a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 11:29:04.0075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/wSidASQLOktOBVcYEpTJPMPq+9Wkl1ZGb3JaqFU2aqlkHALd7dkAFAdAWVBiKAq0fWVFw7EmkMxFhGw+lOjPJQ5YZnvxjGRhuffD1gsfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4858
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:17:31PM +0200, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The function can no longer fail so make it void and remove the
> associated error path.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

