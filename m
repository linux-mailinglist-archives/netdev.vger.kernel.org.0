Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355D74B0E15
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbiBJNFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:05:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiBJNFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:05:00 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2108.outbound.protection.outlook.com [40.107.243.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D245C49;
        Thu, 10 Feb 2022 05:05:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmK8FhczbV7AF164BDrNzT64esIQ8XfQRKUmJHnaufNLNiZTrlV/mktiUE9E2qrcU6e9kcE71RvarVLSVJxPGxU5ET1YgRBjEno8cfBcV83L8mcI/po3Q8kvRC7X9rvZMrsHULftNeBJMEl0XsbmdrvbBdVCHqg35qdoez53UW80rPJw4Dcs/phf4vKnKkVX6/VAes8m6Hhmv2dBwrz1mbgnhJwj9AFaCwdTNN5y0ps1MExiBDiUoaJH0oNifk/C3MdVFAuwNLpHFRqAymI9gTrNRHbRU904Y3BmANtysWohtPsdnO96ECclG4n5P9gaXnSNPM1gejff6nrmqOlwOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaKJyJQe9jzto/h7pFMBbVXbFd4NRv3XvIDgPYmXe5E=;
 b=k4D34gQ7VIphIOjGKX9TuLPVpQS9G0HAzo1aWVVM35k+IVxQE+em+NtbTBhBLtv6rq5+YRoEp6wBIvWdB7fj+SYCmzir9dwLGDUVEdCFEnu41JRWdGKrndwiy7quJLRi0vKdH0T61mTDW4eHMm1Z/H5BN+qfCrepxeeL7eflx0nrtccp7Osy9xRrcPhUhc+oWrvejKypoHpxtdNIV5mJi5pnooFeuc8mqoO6FFnLNoxq0TjI4DKTsgxNbPs+lBtjnJtuDGWXOapzWfWS5YE5Syzi+LWZ3sLfenVa41C1rOOg5dJPMKVBcmkvjngaCRListp71y44OyZ+nPnbmHyPjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaKJyJQe9jzto/h7pFMBbVXbFd4NRv3XvIDgPYmXe5E=;
 b=VtbkYmkvEeRWghJ/UuXxOj/3T48JHAA9l6sP6yaHADgf2h4cLaUdeOJX9EE2XNv1PhgNXTwvf+bQKpQE5MLH0RE8LAiEann3YwHbfsJpBQtyplhmjJj4AeGhcdiMyV8d4PTUNa/EDSd/U/KWMeq0sAA6F6UwmkIhMWrlYPM36WE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3061.namprd13.prod.outlook.com (2603:10b6:a03:18e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6; Thu, 10 Feb
 2022 13:04:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%7]) with mapi id 15.20.4975.014; Thu, 10 Feb 2022
 13:04:58 +0000
Date:   Thu, 10 Feb 2022 14:04:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        oss-drivers@corigine.com, netdev@vger.kernel.org
Subject: Re: [PATCH] nfp: flower: Fix a potential theorical leak in
 nfp_tunnel_add_shared_mac()
Message-ID: <YgUNdJgC9dNJN82P@corigine.com>
References: <49e30a009f6fc56cfb76eb2c922740ac64c7767d.1644433109.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49e30a009f6fc56cfb76eb2c922740ac64c7767d.1644433109.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba54996c-4140-4702-0fed-08d9ec95f063
X-MS-TrafficTypeDiagnostic: BY5PR13MB3061:EE_
X-Microsoft-Antispam-PRVS: <BY5PR13MB306109E43C1B80C6F3A1D33DE82F9@BY5PR13MB3061.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DS9OOGoOlOyINa25i4ThleXVks7pRsoclkquhVkCoIU3inHf51r6mnuzXVD5uVGic6aNYjJQGj1D5kVj5hB77FaRZQJOISKii9Xmp/nc5BAblRikwccF7zDinLQH+0tzNjkRTcSO3isdnzf2LxolhCd/FmbLd6xPkwf+x2/Jsv7iHQ84WwSDJxryB+WLZqO2w3cRAypR/uF7oLgKI4BHJuaxn7X4Omnj49+qrCFfJJN8/9FYhp6R/8ghlRipV/0RhipBeTou1HwmP0ZHrm39cIrLdihFIvrqijvv4s45pewKAI7RdIihAof3UdpORWD1Pz8ysIrPHYEZpoKgaKdCJrYd4OainYU3wZ6gj98k1euqM5u/YeyenxSKMtU7ICFgpy64H3mhYjNuHqrNKYrr+W7aVl6+eJBZ3CnCjPPJ3WAjMnm9ZVRy1Sy9rf/oYUkuwaEyI68LQ0H7dxiMP1SbqgxxR70QDzyqDrTWOMAESXTalBuSnUIu12YU+92YFHo58afdGmVZS1mmsLzdOTfbuucK/t6am0m9aIfJbJbxN+2j76wN6OGOn3GJKig6INJK59IBQi3f/zudx6KpYOsy0ejQsdRIQv4YcQrCBOEind3n+L14Hsr504AeG17LTMR52Skgu8/jHY9c/e2M337ifH6jIJYR0gepBaMW4bCgJBSUgQUJF410qJ5nOwPHy94bPcDLejBwrfZZ4360TDCvHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(346002)(366004)(136003)(39840400004)(54906003)(8936002)(186003)(6916009)(316002)(66946007)(66556008)(66476007)(86362001)(4326008)(8676002)(38100700002)(6506007)(52116002)(2616005)(6512007)(6486002)(508600001)(83380400001)(6666004)(2906002)(36756003)(44832011)(4744005)(5660300002)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gU48jXDmOcQQKeHXgzzYmYlOq3jMXVTn8d+J5BLfCORilHcUmtvsAewzO4m?=
 =?us-ascii?Q?akX821un3d+xvx1vqXtB58lHWius+mS6XRe61CxFu5KRzy11+sH5J1vAMXRY?=
 =?us-ascii?Q?t9Lnq66gEy0rjbM4yoM0IoT6b51mcubZq81CMxf5XkQnc4YBxw9dRpg8+0ZI?=
 =?us-ascii?Q?NN127BYV07o2RIS2/ntnMMR6SR0GA5H1N0/8JBY7GAcNuQoYHKzxeCL8Cw26?=
 =?us-ascii?Q?Oaag9Yo/s6C8agDabAk8X6IhIOHgTDDHf0ElV3q+gEamJ9UCnuk7sCdaFIXg?=
 =?us-ascii?Q?7ZViav/XYaDYzFi1Y0tyu3U8bE0IoIySi4VTAo3fiIsGRphqCBMNW/Y+9Hel?=
 =?us-ascii?Q?/vzWS8BzStlL4XY1TzDpUSfRCvAjQ2Mxappjtau21Q/gcEF9KJgXFf3Vn7lT?=
 =?us-ascii?Q?mQYC8gBy2MlzNGz0pp9LkOjGOsEMIkE8GddX4WnbI8K2GTmdrHANC7OLX+ja?=
 =?us-ascii?Q?hRZAmVHCeYDNf5JuAPCZsIZgUrpc/9sBxIweY1Hdlg0CxFa8XtS/+d1mF3fT?=
 =?us-ascii?Q?+VuBKpdVtsQN9rHkbsTQdQqVuDslsihm50Vs0LNcgl5D44wouLe9ZMteYRq1?=
 =?us-ascii?Q?VEpKWByQpSBfccrGdRDPAfjRXXHvw9JxZxf7rFNgNIfd2Spaci9LAtrU2kpu?=
 =?us-ascii?Q?vVMiTvMaUFLPmLrDut7lmDg4RV5PP+2ijkQGeNf4oT7yaY6xpcH/OrBRcnU1?=
 =?us-ascii?Q?hpg9qGZe/G0oYMLDYF8U1UduHiUByLbUlteE8mklzKT9SoJSk9+QDELAu258?=
 =?us-ascii?Q?CP5vMyybo0qItrZaiJC+oiL+h00NknFYVL5To7H0oxnPgW7PYnVc6vnbgNNG?=
 =?us-ascii?Q?QHF6VX1j91ntkLG3Lu+gYDzw2UTGxYfnoziJgXZgE22pSveJaR9/E8DZQp/1?=
 =?us-ascii?Q?PjX7WKDZ2CSiapy/DDH1w9788MB6l+gjCGFAUuO73vMroSE3pPk/60atAEsd?=
 =?us-ascii?Q?NlXa7KMBjqsorHl0EK1/HTyYkQBAKOKaCJruW3k26ki5mx+2yohBlWj6J3Fx?=
 =?us-ascii?Q?pVUio0JWZgB55pGzdXzSdeN4vP5fY9x8Zv48Sl/5VVdXXPryJQFTKjQs4fZq?=
 =?us-ascii?Q?SP40TVz3YQ879Ywh9C1wijuzkr6vCtDCaZmub1m1Ceef8TdfvHGmkg0VQZDI?=
 =?us-ascii?Q?ETpO8f0HX47WSfg7AZsJe2YMHhmObOOnYl5JcrOM0ILkRl5zg1d07FryVT+3?=
 =?us-ascii?Q?RLm9FQXimxnNejj+h/yxF70WSJdsZSNyZylk0p4ygd6QxcDm2SJ+hrF5ILwb?=
 =?us-ascii?Q?3fORtq4ZTn4k4iXFuR2+6tmLWi3iB5lv7w2VEBFqZFardqhJSDM7pOAsvfdj?=
 =?us-ascii?Q?2M6y5G1Cm5fM2wRzC7GL6ROGB+NJYpkztaI7R7dm/C3NteV1Fa4DiCmzYAyN?=
 =?us-ascii?Q?Yexbm6nqsLlR+w8U1nYK7IoW0sJ68E756uLB0v3+DVSGdRpbVnGQhcf61jxG?=
 =?us-ascii?Q?2iLbejoUnHO1CUJY5B8uguZ0SMa0AlO/Lzr61BzgUpHVU2khONrE9qEPS/Ga?=
 =?us-ascii?Q?0i0FWvoSlWatv5t4avf1Y2Ds9CfbOmFAsDOHeH0bUmXg7sP7qdZpNdWQhXxH?=
 =?us-ascii?Q?6T27hxqwzPJQ19cay27yvFCskhI5/mXe8X09b3YMoujpyXFuTmj6i33Pi+AH?=
 =?us-ascii?Q?9/U6s6JNmh81n+E8zg4u3xYc9azVF5wVuUmEyB8/kshuddtDUKe0WdIOgvkO?=
 =?us-ascii?Q?ijb3DfoANcI05gUEQyaHpZyo+RP98lH9VbBIHTZVup/HycFZ66l+L9hhhQY1?=
 =?us-ascii?Q?efqHsqBnsQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba54996c-4140-4702-0fed-08d9ec95f063
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:04:58.1160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzrMNUZDbqYZQL4+JAYzP3+x12bmNoEsEqXpzz+1oz6JHhwY+0aldDwE9x5WPcwgpDAbe0s1Cy32wRGpYZvYnHbMV9eXiaTmPiRYJU1w4k0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3061
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

On Wed, Feb 09, 2022 at 07:58:47PM +0100, Christophe JAILLET wrote:
> ida_simple_get() returns an id between min (0) and max (NFP_MAX_MAC_INDEX)
> inclusive.
> So NFP_MAX_MAC_INDEX (0xff) is a valid id
> 
> In order for the error handling path to work correctly, the 'invalid'
> value for 'ida_idx' should not be in the 0..NFP_MAX_MAC_INDEX range,
> inclusive.
> 
> So set it to -1.
> 
> While at it, use ida_alloc_xxx()/ida_free() instead to
> ida_simple_get()/ida_simple_remove().
> The latter is deprecated and more verbose.
> 
> Fixes: 20cce8865098 ("nfp: flower: enable MAC address sharing for offloadable devs")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks for your patch.

I agree that it is indeed a problem and your fix looks good.
I would, however, prefer if the patch was split into two:

1. Bug fix
2. ida_alloc_xxx()/ida_free() cleanup

Thanks again,
Simon

...
