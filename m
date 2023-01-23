Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CD06778E9
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 11:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjAWKQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 05:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbjAWKQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 05:16:10 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2122.outbound.protection.outlook.com [40.107.244.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A3F35A5;
        Mon, 23 Jan 2023 02:16:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8+gRc1tGXwaRlsRK3YEGvtLLSTKI+PFP6OA2J+GxjgLgDzzJTDwURWnDgvCU0W9vnVUJBtRROXY38Mr/NzUZ/o0Qtmopf8WUH/o9/hxS86mw75RoA1RP5kiAWQwVwLlOoF63h39ITK+t8yFh+tupz2QZ/KqYDlhRwtfKNQgX8822OJPIMwr5m1r/YwYQ8C8/DygeHr1RjqeONe5NYr1XzZ3ElNbf0LTdNFWweYIeP506FU4gIMkfYDZP3XJnpT1MfZSuXA8QuyoSZviHABcp/zq19Fsj4fg4Elm0FbL8alTFlmVo3bNZqWH1Jsg7P8fw2oiKHV+PaZK92LpLWgi/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jZNeU0xU8RcepaZtiZ4nVCJslQjMKVUwqNkG23cTbQ=;
 b=DjgteMKEbJLaEvKA12nfKwNeqOWRkBe6fRdVMb8W0wvmm2Jjlewo4hrw+60I5rwHrUeQB3g+TR2qQp4qx4voGvoZLZkjEt3J6thWrWt9gQnwWSUCUK1ILcbVTdkuR7T1hCeYw5DsA5rJ7vyzW6sCK4ZupRSG0hCmsCSdMtAGENXxHoI/K2ZddyxKOYiOuVVyXEj1MEH/WfZVRTkq6gUTGdHKDZs8wFIn/guLr7dSa6lOx2qae95hRpc9xv8Yw4P+GV1jx5em7d/JBO5yhLDkYm74/h8gJJfSv8LrPvcxZI97v/rv3oizppvBH47H/U5vlpnpsOgASpc5aSCCoK2SlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jZNeU0xU8RcepaZtiZ4nVCJslQjMKVUwqNkG23cTbQ=;
 b=vmTzVBVeG8NKxGE9JKOT5wNrWy1vOceL1rMGHfLr8JPAvf0T7qUDgNGO+9Omap70LDtOAVcHWkBIld0fjPOiTxD9GEcv6lsw1x1VbiwHUTKDndM0skvwug6XpYE8g9z8absxoilFeZcAdc2H5DxcdEImd1lM1cIH22yjzrFb8G8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5456.namprd13.prod.outlook.com (2603:10b6:510:131::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Mon, 23 Jan
 2023 10:16:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 10:16:05 +0000
Date:   Mon, 23 Jan 2023 11:15:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Diederik de Haas <didi.debian@cknow.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Sam Creasey <sammy@sammy.net>,
        "open list:8390 NETWORK DRIVERS [WD80x3/SMC-ELITE, SMC-ULT..." 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/ethernet: Fix full name of the GPL
Message-ID: <Y85eX2shWBXv+Z7E@corigine.com>
References: <20230122182533.55188-1-didi.debian@cknow.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122182533.55188-1-didi.debian@cknow.org>
X-ClientProxiedBy: AM0PR04CA0098.eurprd04.prod.outlook.com
 (2603:10a6:208:be::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5456:EE_
X-MS-Office365-Filtering-Correlation-Id: f23088dc-7f17-4d62-b9dd-08dafd2ad66f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MDc/ayBgFn/pHwavSLvoWmWFITDZ7nwhn4rxB2kzgzJIWgKc1GhiHBz+1sO1LRMkAZjmw82NJ4wfNkX4sGNjtmLe3jNciVCWtSJsufWRGmM+B9DalycltSZd8uktwIUruwAlz5JeZLd5vtfl0Z6IW/pnyWS+eHsB5+zwlyjb1LDaphgMQnqkBUDDZJhFRGJr71SdTETpXQX/+afSd6iOl3PNhl7qZDuX/XUWDhJTd7SJtyhpj1rSfbGOImM0brFc4G12HmoGS1/x30OE4v6TAYkqigTxgoeESkZ6Vjq+obhiOh/xytp7backl2BcpONSYpH2kIs+uB++/k7Ra3omwx997fXY/RTGozg76bXTTkl+I6BuvieFzbUnxmhG5POWNg1rv3mDU+yFBCfH0wrRXtnFOw26RG7Qmvg+LRciq+EN+z74wM6K7lFlWmQuF4QLKKU/57LnewBikPs5bbwzJr2WqUKOJxh6EhuHaqYNO+4yfbmWJCqO51qkjBvNHXWgHdk+XHrtNuPrl397Qg7HdOn4UYQ96YQK5K7KdZvqezvm1uAREWMQbMgw1fRCLSE6R2zB6smxpEZobl43eaQsmou3Djn7rjYv9z9mbe5URJvpekf3ALi5GPxMb9w4NBCnmjQS+FhXTGgtvELWcarlINeN7KIBZMtliNN69u+1Z8RDVl3TrnBahwlNld8rDhXx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(396003)(39830400003)(376002)(451199015)(83380400001)(478600001)(36756003)(6486002)(66556008)(86362001)(38100700002)(44832011)(2616005)(8936002)(6666004)(66476007)(6506007)(186003)(6512007)(5660300002)(4326008)(4744005)(66946007)(316002)(54906003)(6916009)(41300700001)(8676002)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hRKRoj5mZetreaTD6Kk16hye7P/+ir4HIYWsOGNhZRuIbpDOa0qKPfdgYlA6?=
 =?us-ascii?Q?UeVpZU0p4pLndb9YKiuA8kuX2KLVS9yhM0ROUHjCPuNiczUf3rlMqO5l3GQV?=
 =?us-ascii?Q?Bbv0s+ZvKPJxMDlU644i9VTZvb0zLt5aZ0PP0EGaX0hmclAiAYAOeyw+WqCR?=
 =?us-ascii?Q?U63NMnZdW9GKMulf1+zwybXIZaUfB/LOlUsY+SuZEzwkKnh9T08KhpvXHzsf?=
 =?us-ascii?Q?dbw4Gm3xAfaaejYKe5rp6x6+/tIUjzaqhuzO/ll5BxNSBmsZJLAmtdiLFFgG?=
 =?us-ascii?Q?eghxmc6c8TID4NjvmIHclPH4HG7+9KVPEtTOqANAS8HAv1ZFP2WkQtUBBaFz?=
 =?us-ascii?Q?8U8tkziCT/+S/G4uSWHJHL+qi8Xr5h+Ce2fF2vr0ILrX5yUClZ/+a+DX4CAG?=
 =?us-ascii?Q?Zr26Lg2RT6ecvbJ0epp6bIAVPwnE64pu35VOGpvX42xbefmNg5IvZ1Zf1XoC?=
 =?us-ascii?Q?ithymE+Vqn54vbO7h9/8AAomT30lNHDHWmuRgSKxQAiKJ+DX6bbC8aELThnH?=
 =?us-ascii?Q?Ts4mU48gFSiCBrFtydaS3GSrvWiJN8BZcpBcu02E6qqMB18hCVzUxxIIk4ZS?=
 =?us-ascii?Q?2MlLzZR+aZwHOrXXF3qpY8KNSYKy9q0WbnTBT/WyJX8at7b9z1W1lPDvvUwC?=
 =?us-ascii?Q?XyCwnR14AhjaLlmPajU6kodG1atkF1Cn7ysdIdRNef8pxV5OefVgks/2TFbM?=
 =?us-ascii?Q?q3OkiWAmt7RBeftBpbw2tmiesyKdhwsZlmJh1ayYyWK6bwY5wpE/bZHk6koQ?=
 =?us-ascii?Q?bhdtMnYtrIAfSXZw+L0xy83pO/B6a8iQZltpzmv+hnZ8U3YvyNbGyqAstABQ?=
 =?us-ascii?Q?3TOncIFpXD9owZmyHRYyQzXkR8hW6XKG6VuxwmbMRYv+v0nxTklzSd7qi8Bg?=
 =?us-ascii?Q?ZvseCT9Xj5c1Un1Xowxszg4966z5pNcyQpwpYMLOZFp/2OedOelq0ytG9vPO?=
 =?us-ascii?Q?pWJUq3mbhiNyPW/WQupHTyMRsf9Nqh4bYpvUh2c5hy/SfLQavsKWpl2nGXxw?=
 =?us-ascii?Q?i47EaAYF4ftI2mRZNFUpTr4nheLvN20TpFInMQVcUcVnanhNj5ciGZ8Ep31K?=
 =?us-ascii?Q?sklqzxxqVL33MS+xJO4mDCBn9Tf/j9IfpYa33eMBAqPQhzt5IslLtdnIOf7J?=
 =?us-ascii?Q?CRGMilN+dTiMpTzB85YPck9wiOo1XYhntBzyv7iseAWCaz8zVV8mMUg80ZON?=
 =?us-ascii?Q?w36iSgG7q6oOHi/o16Y7TFEcgzV7IwoDtM3YyyYU9+RpVsmAn8S+EY7mMsG8?=
 =?us-ascii?Q?TXv7LZDn+GHMaJ+YiJCLGNzoZkxejHyV6yooerMhHTBaL367Fm7ELqXFy/fA?=
 =?us-ascii?Q?QIhT1UIADFZxjbiJRvWQ4U5Zi3qQRniA1uxcxW1xZ9ZCNHkm/5DafJWYIL9k?=
 =?us-ascii?Q?ZLv9B/RZhiluyqXalWNJNacr1asDs0ktQ4o6hWZyjHtwfHuiBe1MWxohcCCX?=
 =?us-ascii?Q?YX2NfxLJp8l+WQtw8LLKSfQYpwdm8osuzWmw0Ww7p7kHNHpAMEvK5BmtmKzs?=
 =?us-ascii?Q?O823U4zRxrEKdKOMMt2tnx/05HKKgX1H6qYusq4W+ZSaz3/BBhdVPDCzceKI?=
 =?us-ascii?Q?DJ30Ulc5+Rf0Tjx6w1LnnjxasSzHiIyK89KVczlnPHkyYMEpDopAPPZGRVG3?=
 =?us-ascii?Q?s/H3qxvBCXKihyR/KALXTvnuVDvixlkC8WNnAPqvk+guqm5qzVoN04KPdVQV?=
 =?us-ascii?Q?hcTAsg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f23088dc-7f17-4d62-b9dd-08dafd2ad66f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 10:16:05.6164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eNXPi961WknZFRGf+wHWZ8IrQc292DS4gYrWq41pci4ihDB3Sx4IUSI1lfN1a0bNteChzQIo0EQ6FtDvS7OCDLnBDmolsu00mlLSbK5ME98=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5456
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 07:25:32PM +0100, Diederik de Haas wrote:
> Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
> ---
>  drivers/net/ethernet/8390/mac8390.c      | 2 +-
>  drivers/net/ethernet/i825xx/sun3_82586.c | 2 +-
>  drivers/net/ethernet/i825xx/sun3_82586.h | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Hi Diederik,

as we are here would it be better to just move to an SPDX header instead?
