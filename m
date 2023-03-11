Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2976B5B59
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 12:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCKLva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 06:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCKLv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 06:51:28 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2123.outbound.protection.outlook.com [40.107.244.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CB711787B;
        Sat, 11 Mar 2023 03:51:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGw081nto9vizL+sWztzADOpCnCofaipGH5InFnpwt1Dzv7s4mpx6hd8QC4ieBg0KgK2JUvIqhO289v5d5zYagysTQkUG8DF5wo/1NLM29D5/1AUMuJWcaVzbbyH1JhoCtDWJ8oFsftruIEtnEwWKaHnUcKlTHfHTayyMoTMXhudeHkkWVNVeLUeOLrxk40kwoDRyzOLlepwV/nPAAhqZ2/fXcY4avhkSuD/5QMI4ZQHFY6bIsGvAMIqB2jZyzxtJQvPg67CKoic5P7rpeGTbGu4yCjYNE7NFmOI+dCOABTcLagH+1FMA2q4W0+2iUgb8pPE4r9huH6Vhml09LKQ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSPmIer9gBjZLNPXIF5J78zSOC0ool6Fqb/T1fMkNIc=;
 b=lb7ePnFhIYgAsfMrQ3K3nLrmWwo/Bw0T942h1qcjhmQYAPSUxmFaofqAPSVD6ma3zd5Ep/0tCu9c5bzAuIU3zd+92z+OiYoHUNQBw6PxYcLPGcb0H7YBYD6HVUcxANYmw67fEupBDzFhfWmjGBTwFkBOE9/yiGF5pz4pYGmHo2jh7GMPln6U61RAYc6rf5C5LtjTP2K2UOgrVFcCzoYgXqJfgN0R0QakCKAWjAyq0ccSyobR7VQ1Sqlx4sr+Hx+F0NvnD8oksdTjTNrcBtQ0MDHofKxPdQRyO385/+pbzmRUrkYsJp/pUmYMkxlVwybMHz7mTnMZjbXztjdJb1u0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSPmIer9gBjZLNPXIF5J78zSOC0ool6Fqb/T1fMkNIc=;
 b=QKJ4xdCsj30IvK1zn9sEMXN++8nmBURn5O99M//JgRExn9fkJTD5IpOVASK58icUvSRPz+JdQIsecY2ZpnrOVFnqAfhjvRsb9iqQObRW5N0InaKumrz03UIkZzM5XevelpUOUVs3/Sz+wfmW9HI99FQ8O8YG1PIcpuwHvibyYxk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5121.namprd13.prod.outlook.com (2603:10b6:208:350::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Sat, 11 Mar
 2023 11:51:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Sat, 11 Mar 2023
 11:51:12 +0000
Date:   Sat, 11 Mar 2023 12:51:04 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH] net: Use of_property_present() for testing DT property
 presence
Message-ID: <ZAxrKE5tjB3IPBBn@corigine.com>
References: <20230310144716.1544083-1-robh@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310144716.1544083-1-robh@kernel.org>
X-ClientProxiedBy: AM0P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5121:EE_
X-MS-Office365-Filtering-Correlation-Id: e1ac1db5-1588-41e9-ba27-08db2226e96d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xj4XfBvl/ALTH9hGzzMpbkVHnOrgcNJxkp2zTVlBBLUWf8L1Z3cMhcHkA5CyftoqDox+EYp5/ils8MvxMxKI10JeR41CyHzksPpJ2XAKcQC1Wg3vnlkJIP2QdW0Y2KsjZfaKyEJLsDlN0/4G7suIHtzwvOe1fCVcU9razkRODR8qjsmHDonO/7dB9T0iMco+1VouaCY1oEMy+5uovA0M39PE1I1FydxIWKLuUFWqF8/I0aussKH2bNc2YLCziF410j+JR3SNdRDWptgpdSE1LS+/SZQUzr1kPLhhO6CmGVj02SHD9ojFPhsPr4sfomy0YSHDESWyyp9bAKiWfBFw0if6OYgXyXESDZ9+FLyXaTxehCXTWnzTahGc6D4FwUqbkYZZXFkoqDl70HIl3T/Bo66S8WP6WxoMnvxxw1CsNAPu3dVNmUx0oP6ZXd1VLgvR5vW+AQL7pSrQ8TdeVx1lpOZ+wgPZv5YiudPZxppYO+TNWAMxlXpxANyyN6U+ZAK6C9/rrNSjluGYzN3pmGdctkaOBENpbhzqTNsqAdrszt2B0cWyviwNtpmFZ03uptNI3BMDHYJZuYmfW5vJjTBLefpyoOzQVxSRpHRLlT0kMoDnbcweEnp8GyYk3BNLspnerxMPRMqKL2tpCBTizegnrkRS2++Pl32mBRNxiyUiUrIxJX4+W+5p8uihuM58zAPU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(39840400004)(396003)(376002)(451199018)(36756003)(86362001)(83380400001)(38100700002)(8936002)(478600001)(41300700001)(7416002)(2906002)(5660300002)(6486002)(4744005)(44832011)(6916009)(66556008)(66946007)(66476007)(8676002)(316002)(4326008)(54906003)(186003)(2616005)(6666004)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qOQ/CjJd2V1fi0PLqZFa+XX/f7qn+Ume/HXLXQJj3D6x2zuBGLr6AlHpXH0z?=
 =?us-ascii?Q?YLAWv2qEc/O1SBoJfm/qrQwJRAZewSTF5JFkYhK9UvIplDvof3lbseqFn6Os?=
 =?us-ascii?Q?2qdrnRh5HnruQil1xfGLBjSOnz/nAF037p+Y8pFKeytFHCY3o1vA56H6NXAX?=
 =?us-ascii?Q?ZC8Bivqbbhkn7jRFjU1lrzzbp1PPA+AKv14u5ghW1BLtahvN9bSzZUwRbZpp?=
 =?us-ascii?Q?s1yuOWCeTKmKjl6ZUzTh8L9hhwbVTnA0ffYeW2L+BhkgnkGq5U4frPdLaL4P?=
 =?us-ascii?Q?1vQR5FdGb/yAeCM30Sgfw/EOT35M+t1Q4sDsaZL0v3Ge0zVdRF95nz8cNVr7?=
 =?us-ascii?Q?OZfCRE65uxg+1hGaXFcfbY8sOH1x7xeY3Z/20u7grFIQ6mg6uDQgPDKpfKnt?=
 =?us-ascii?Q?oKMm+CUW949iKzjxBb6v2yxSp03uxsQD2r7DZ9bOQsiHvcqpkFGzloGPbKPN?=
 =?us-ascii?Q?APjBFqMxOu7wDnkxCUtNHMa3gVKrH+QkXGDEFK1BMtTKZo6zEQAOzvUsOwQS?=
 =?us-ascii?Q?PxzVSYLVMOgdqhpv0NJon03sR/bFiJObefljQETVcHHcCJXpvWqqU81DyV4F?=
 =?us-ascii?Q?tVKfqZj8UmJYIMXD6k+hfo9z7+oEYKiFMzRZQxIcCC/jRI3hA2X5abjlq5T7?=
 =?us-ascii?Q?MBU5KoJpSlFvL2hgyNl367GAwSBu0GJV0Hhfo9xvRnOJlQDJ/fwmoSTR3aNx?=
 =?us-ascii?Q?IpjFbO8A9xez+4kEjIVlk/wMv4qC7/ouRQV3gd1ag+4yI0eiKPxwWFtdHeSF?=
 =?us-ascii?Q?o0l1I1oRt5YbQDdvvPmXorgFenxW+97wo+pFWBI0QEyAsq2WeBFrG4YhSbne?=
 =?us-ascii?Q?h92JaddRm6iN3eu0EWxJ9KIWzwDyZN5n1As6FJ4NLhiEuYpz1ng2gwhmzVRy?=
 =?us-ascii?Q?Fdl8sfOlam9FZr/as7UDQlS3/azBSpkx/ACGH6Ij67T5hKq1ataUxLpn+rWw?=
 =?us-ascii?Q?m/8LUVykqQiFdvD9khOkM8Ff7fdZiBZsdHNF2i2J4qYHPLwU65ZNIxmuHIN9?=
 =?us-ascii?Q?8oI9yGct1maB538E6FvY3/UX7xz1mtcCrmmIsH+hf9OtQozCE29I74F5MCDu?=
 =?us-ascii?Q?PqpRxdTWa3fd2MLCwjFmhJix/phT9cEatVTn2Sc27oRF3Wjs8549lWFWWAUP?=
 =?us-ascii?Q?niOzaVuS/aUTXsnfapgIiQp1COE+sT7Kwki+vWzpM0GgyMQpLb3W2bW5fxvs?=
 =?us-ascii?Q?myY8aAXAeJDFRSOQCY/aFr0/HUih3VoEatO+3anuzcI+d6c51ZHUIwkc9ZBf?=
 =?us-ascii?Q?dbwJz8rBa0LVCiTl9RBGu8HNgoScyXq9t2427TpAKWDRQWeoof9a8MBHBrC+?=
 =?us-ascii?Q?J7ZMi3wWJ+Wo3jWJT4CQdOy23Ckix+B21XUxAyoNSXhHix9xrecmltp1jRfy?=
 =?us-ascii?Q?/7qfmBB7D6gY9Q4aTHe6GkhMvLLWJav/JADPWyiNf14PIgfWwriE2mxWBrH3?=
 =?us-ascii?Q?usW8BEpIOHmJoLMsRybH58xhBb3lg9XAWiYFVdll3bRyEv5EkPI8BwpcaBHD?=
 =?us-ascii?Q?z8Vfx72f9WL2D5HoVLediA+ZejXO7HU3CGOJIHV7wLMfNGc9UOFdjM3GJpJU?=
 =?us-ascii?Q?NGFjYha1XKqCE/+dZpTqqE7g6Z1xTSNmA5VhaN5yyeBL6B4rxoFbtNFHIlIG?=
 =?us-ascii?Q?pzjKVDX8nBc8l7KJOFTSqf0BGerp/LnD2RedBafss3CwATK3YZoLeIUm6lXo?=
 =?us-ascii?Q?UFkPZA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ac1db5-1588-41e9-ba27-08db2226e96d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2023 11:51:12.5784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6e8kyI1p3RZqG7lmHliq0uAy/bXqSken7sDwTowSPgo08TZwRUasci2bjNCz90R+aAb1MEGzzasKgpO9ZYBzhNZGSdYUKAgT/9Ii0o5zhtU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5121
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 08:47:16AM -0600, Rob Herring wrote:
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties. As
> part of this, convert of_get_property/of_find_property calls to the
> recently added of_property_present() helper when we just want to test
> for presence of a property and nothing more.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

