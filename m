Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18C5767760B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 09:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjAWIGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 03:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjAWIGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 03:06:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2101.outbound.protection.outlook.com [40.107.243.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E1B125AD;
        Mon, 23 Jan 2023 00:06:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTfv7M6OV3DMAOiKddl1H8YYyivFh13QzRGMkJfCXtnEwlt5gTfWugjyqryrLQDO7DS0LQHnyNS4NZFxwL1EaLPYJ0Jez5Onnqo+iwhG7Fq4iGb/BJf5dJ9GjKUiPNv4FPdnAjfSf7ummlGuTlbyJMOwVLKqhRQ9+sK8ux6m9fpZRWltYQ/zf6+0uMsqNpoK55s0/pdBvJ2KlJN3AVQHMWLuCsyqfuoP8J4/WRVKXFLwkSHYRnYpGxdGXkPrM4nm0Uosbj7Ed7Jo0qzPNr6fsttdi3ZeDetIfBgZW9LjDW4YolW054pbKf/3oiyr0EbihBRvP9RdsNM8iJqXJ10oDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37nqR+UcfAdML+Fhd8dE/2KXGDWWP9JdRdHagFWt0VI=;
 b=OqrQGLF9Nz9G116Stb4G0Splol3Nm6+U3yJgTX2KkO5vIjtdbZzQrEpHesckOAu8IRWSc9S37mKgHifnMP/SWqA7bBBIhBOj7WcoRKBzszrK7QzZG9JU3XBdjsZbYVmR4GF8UG/hzOoGf5znvSttCS8BNTPFjDQdf138FmtRz3HikD4VdYQRIv0uVSo3wNdV/QhvR6+UJLiJzGQLUmaHDCfLTfPC9VV2a35bqxXEtz1h/1NfCkYPnyHXzW+XL6Spf4Pyp/7934FFNWQeGl3xWTxROl3OeAY6MnnL18l/hqQpheaE3pUvqMIs0icxqedCJRJtIFxhbm3CeTww9sr5NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37nqR+UcfAdML+Fhd8dE/2KXGDWWP9JdRdHagFWt0VI=;
 b=gJBjxdU3aoTFPQcLdK8dJlq+fhWY7znR2a2y/iKrx8Tj+0LsWK3IOywvfDmR9F4ErnoftW7voporDtJgcKH+hAYfBxyyH8W/0tKe8pNNxqpUaSuTNrVWVgFmeaaPyeeH7KKqkLf0GRNGmbBXfeppqoO8yucvNqwbyC8jt0BF570=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5372.namprd13.prod.outlook.com (2603:10b6:303:14f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 23 Jan
 2023 08:06:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 08:06:09 +0000
Date:   Mon, 23 Jan 2023 09:06:03 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Doug Brown <doug@schmorgal.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dan Williams <dcbw@redhat.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/4] wifi: libertas: IE handling fixes
Message-ID: <Y84/69P2y84WVWok@corigine.com>
References: <20230123053132.30710-1-doug@schmorgal.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123053132.30710-1-doug@schmorgal.com>
X-ClientProxiedBy: AM0PR10CA0007.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5372:EE_
X-MS-Office365-Filtering-Correlation-Id: 7565fb55-39a9-4065-aad4-08dafd18afad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JJ9WtsTKZZYLi6hiuf7Dhxmt9JoFUL+XkVwzPDdnQCRvwEihh0EudZ0royWOb07pcz3sJ0GBOKS+lA3FxqdzolpKAtyLuzGzADKtXeq67oBbv52I7hZ4tXAB2VXIWyNqLWz/6onFElQIuI/kqfPskFt5l85/64nHDUWyqG0S7XBf8E0xcxPTd4xjYq6ZuthOUNd5tXc/AGD5D03JpSP0/Pe8ENDeQC4xVDkidCDZx0V5SnyJYNirNYiFBFtWvTZqIszB8xgqVHPCme1Pv9VNrfrVcpiBQDZ14Z08u75POU5nDYCinIb5PPUgvOx4g8MGw0MjISz9/nosLCG3ojKFOOjANqV4ZGBDCjVqjuQsZzjigEvQJq3Cggaj+lK+PdoPj2fZbnVwwnipI36w08RRmr0QkHbKuhJyVTw+kOiTskP9z2ns9CPE5+pGhX5ekCdXb7OmX2HImjb2sUvMI3KZ4cyQMkdt39ZvqenC78cq1Npxnx5liJy18q0GHF6Oma3ddjvBGDpv4WchxfPxkk2HdWzI9MgGT36d3Ff7ca6l1eEOa+fp5bQbrV0zxVMVpbg2s3L2ReVM0p5kncoyB4kMjgIm/rw64WKG9Of7CTp5vT/QNRGtt6V720k4crygtE/0gjPLVzNOmwOT5KnUBIgq7bdgjeqAhUyAPEPMY3WGZoz9eiH5kNrwk5Lo5Rbvrv7w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(376002)(39830400003)(451199015)(36756003)(4326008)(66556008)(41300700001)(66946007)(44832011)(2906002)(8936002)(83380400001)(38100700002)(66476007)(7416002)(8676002)(6486002)(5660300002)(86362001)(6512007)(6506007)(6666004)(186003)(54906003)(316002)(6916009)(478600001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Md7Xk4NNympgDlaJ5/DN5lcJu7vRBnl5ExkFJCCK/4/6essD585LU+sAmAAS?=
 =?us-ascii?Q?JpPcrkJRktbVRFAZ8Y9bN+3lhqFMIyBg+BztTmgHlJGv9U1iLXYr4BmAMYi3?=
 =?us-ascii?Q?07GHh5tEqQ8UrCO8ZOSUxcFY/ltzIpsAlQ9IxPSpLwxE3estlAkjLlgU7JRB?=
 =?us-ascii?Q?WloRJxHXq1g+bsuT+axq2HEaUYEfaOOPc2PlQZE9cifaN1fG4CIk2YHThfEe?=
 =?us-ascii?Q?oqMEYOIH7SPRLJ4nZlo0JlQ0wJ2l8hohU6YgOrOjBERhi4FTc87Xl2zYiW3F?=
 =?us-ascii?Q?hBlSQoV5bh5ghdeZNf7LbRlSE1a2PrqaDU19tl/QeGu7o2t6xin51uYgyBUD?=
 =?us-ascii?Q?dJ1eJljvj7AnSvZdVAM45P8GY1eypuALwHwtKT7Q8SpnleyBcIde5bsgCgDc?=
 =?us-ascii?Q?8jrYdCH1EorkrPMBe+W03icbAwFye3uYIIdaYx5r4PS2RkfKZPTuRd4lQrXe?=
 =?us-ascii?Q?sH/EsNqWgd1vcPIimymjN/nyYMIh/OfD7P/SxDA5LNgXsufkys09NQ52IA7p?=
 =?us-ascii?Q?4AOpgcq/V8Oh2Hy4MMq4v6jEyLGy4fW4YaGUQIWFGKSfovs57zyFRyOo+BhY?=
 =?us-ascii?Q?o4IfEbRCEF/GShz7hhgcMBWXSHuTxoIc9IYoVLzjpZOpPj2QQfKbF9HfA92F?=
 =?us-ascii?Q?8VqR1K2qtSD3acDCVSbtcJF6HSXMO9P0il1Xh+Y1EQ2LTJgJaMaqyO2bkxqI?=
 =?us-ascii?Q?YQb+YprG4n1RbIy4fPRajY2VdjeMzIk9ctCzhCyX/tN7WbhQJ5nhuv7cRE6b?=
 =?us-ascii?Q?y/ssGFNIFio7aBm5sCsMPV6gOWNFdiJ9jAlZXsPoBX9b1ooOdWppVhs/bPmV?=
 =?us-ascii?Q?xCd/p+GwWGRG7ezDWnBerJgIZPQAdL0O2fODjsVOd9ldPp7rUiMm8eNGj1Xe?=
 =?us-ascii?Q?PyNITDMtZiOsdIlHMv8oPOvTVHBnz+dqa8wCr3yRy3k8n6hxaa9C4T8n6jZ/?=
 =?us-ascii?Q?jGBCV9Ax/S4HTOCNi7SDkQN2VXAWP75gtSQFyV046z/1PEMbj7wn+/tnhIBT?=
 =?us-ascii?Q?Gvuaa1jctDwU0Ox8dgzlu/j/W8yDtPGTdtxE+PPlVP9NWDTt0Qbq/817BVME?=
 =?us-ascii?Q?2r5yDF096NJKW3/6DDvtOZOIUOc7mckRCzaEI7dL9u/REioVuvKNTmu4EoUN?=
 =?us-ascii?Q?VAlnGrJxuSFBJhnaC8673fEv94Rg+BdkMBe9I0a+eGt0bkG3ThTcRj30h676?=
 =?us-ascii?Q?tpQNIK+FEgpzmsJsEL8Qfa7zL3hCZDp5WVSJYlcYqnCAhKlApwVJRamznmM7?=
 =?us-ascii?Q?CFhu3Uakz0mwIS1xbnMrX2qgTNNAmFURiDn+5kXl7bToSbTmreuasU59+PT+?=
 =?us-ascii?Q?3S16ZEASmZNuBKIFRDV6TBJi4nT56WkmVhUnTB/PkFwAOCFVpwWsBw82tM5B?=
 =?us-ascii?Q?5puuAp3w6LTYf20QVZQagVWyFW8abLDtF3aCVemQPfrFaS3ZdUMXH2bCXM+c?=
 =?us-ascii?Q?Z2EikkMNsxQysejh4lVP8sjwgGH75MzbprvNmbtEomvkaeMQQuJ2dW4x/gel?=
 =?us-ascii?Q?kpG7ERE2Gdi2EisuU5FVWtqns8SjPw/lg0KOFemWGhm0tDl6U+GPDddFmNlK?=
 =?us-ascii?Q?bTHHn5faHbR3SzMq897Yi/g6gIqbJt/TsMRfYwihdEaotYehNC+g7m6W+a9p?=
 =?us-ascii?Q?HM073WsdOzyRBWKOWizVtYbVKePkNthPslHT0iBazbOkIscIEhuR+4p5bItV?=
 =?us-ascii?Q?ST9ijQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7565fb55-39a9-4065-aad4-08dafd18afad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 08:06:09.6344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwHXQrN60tcGRihHLdUDnsRFTMo/NQIWyiaVZWtcUrSGl6LoFGgPYhm3iOAt0IxKAu1479ZiYl+mOEWVBJ5sSCKqR0P0XVLxVqGJ1/zs33c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5372
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 22, 2023 at 09:31:28PM -0800, Doug Brown wrote:
> This series implements two fixes for the libertas driver that restore
> compatibility with modern wpa_supplicant versions, and adds (or at least
> improves) support for WPS in the process.
> 
> 1) Better handling of the RSN/WPA IE in association requests:
>    The previous logic was always just grabbing the first one, and didn't
>    handle multiple IEs properly, which wpa_supplicant adds nowadays.
> 
> 2) Support for IEs in scan requests:
>    Modern wpa_supplicant always adds an "extended capabilities" IE,
>    which violates max_scan_ie_len in this driver. Go ahead and allow
>    scan IEs, and handle WPS based on the info that Dan provided.
> 
> These changes have been tested on a Marvell PXA168-based device with a
> Marvell 88W8686 Wi-Fi chipset. I've confirmed that with these changes
> applied, modern wpa_supplicant versions connect properly and WPS also
> works correctly (tested with "wpa_cli -i wlan0 wps_pbc any").

Thanks,

this looks good to me. So, FWIIW,

Reviewed-by: Simon Horman <simon.horman@corigine.com>
