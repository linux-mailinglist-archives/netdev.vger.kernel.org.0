Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C157679602
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbjAXLCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbjAXLCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:02:38 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2134.outbound.protection.outlook.com [40.107.94.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EBE16319;
        Tue, 24 Jan 2023 03:02:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwUceRgawJiSCoUZ6VnX/yduvsgFYcwpwsG+Mt9bT+RY0yMwt7Ex0cOE2QzcnTumuDurhwV+QnEHSGiFmL2JYX2VxKiKpexoAaBQXS98laH5vd+el7W//SRDhVYXplOi/2Oc1/+c6CwggChuDGP38VFwWZZaCVM8jMs5j3HTvk6TtPZVgo1aIcJTgroxxAugVAd+yO1Xv/87FHuNqOUDHErvpqPEqFnssBGX8/u5UF8gYauCcc7l/E7VoKZCA6JR/5EzfOTxsuXl8CEB7JtmP6bCzIU6H7myT6Qq9eR1l8CKMfhqRkx09zm+nny3lGwEZ17qqWXnlXD5dNTOvDDI+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEoCYfbDxiDEDr7GuSFHKLwM4QYnnmdlOgn5Vl6aGe0=;
 b=CF3EUBxKGCsx3SEIFi1kerE6e0SgShHQa3DhnA+3UN23NubUs/9FmfHlfi+DRVwdYT2+d7RX/sp3pAJAgaGOZ4Wu5FTkUTmbebuACmNQt8DXSSA1j77W/1HPy8Os2s34yqlO9iZbEp6xG042iVDQ/7ktW2L2RwZCbr2fEEyrijpV9VqHQdjOQTPbHrv1c/NHUspl7PzG/qFE8mBc7qMgiP9Lc6xYREfVNYGMAE1vCx2+EJE7AIL6E9l4TyePLkz/8HPgK3vUHo56Eycwc/2dG6Cda28X4KgsH3J2QALOb1JFxLRcujo3en7KnLtGRova1BroQirsnqjWkz6GCJWZDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEoCYfbDxiDEDr7GuSFHKLwM4QYnnmdlOgn5Vl6aGe0=;
 b=QuVxDOl0h623NZI721n2C9nDaFC/ynn9Gld5wQfNCx1nGjKiZn4dA1frl/RHAnBcpMVjCJEFRjMG14EWNKfFi2k0D6KizoVTmWiYOkClxOgvdK1u3f6y8ebuzhujs5FdkJVzEW9iSO7VPEoMEU9NKzt6OX2rTLoMJXyFDuYYCpM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4606.namprd13.prod.outlook.com (2603:10b6:5:3a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 11:02:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 11:02:31 +0000
Date:   Tue, 24 Jan 2023 12:02:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 00/12] can: rcar_canfd: Add support for R-Car V4H systems
Message-ID: <Y8+6vyM+ddSqwEAj@corigine.com>
References: <cover.1674499048.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1674499048.git.geert+renesas@glider.be>
X-ClientProxiedBy: AM3PR03CA0062.eurprd03.prod.outlook.com
 (2603:10a6:207:5::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4606:EE_
X-MS-Office365-Filtering-Correlation-Id: 69ac6f38-53ad-4a68-4bf4-08dafdfa7cdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7YWr3KUvtGpvf9D3lSaAO+95LOdXKW/VdtfzA/0rPb/puuK5T8CMWuXtaH9t2vc89lPFcxUHklIrlu1grS6F6wO9MmklbJhI/A1w1joValyFKdwYCplsrfSn/1Vni5DgheQIqwGWKytQsiP4zaoxqRG2KBpw8v3oPJUWLCQ6qyf6ft0kARuN2QSyQ5EM/XpJqIWU+vtPB3aHemovMkw7o8Nznta10hgd/wiV01QXZfwCFxjDqkx4YG/NooK4YCXAUpwU7pYwSNvLLBivFtXj+gzLgpqHCeh46n4To6NmFk/SkM4pEfNxhQnTs3Kg90q76mVjzQoPgnK33DI1C7OeNO9saTbSXRmydcWLiatjj+p86wtEV5DjeiPYm0Q0k43peHH48+obhbAXJnUXJ+FUqZyLZCESg2siCty4VEjNvk02SBk7zYyGkfe/MZTh2wBs5R5Y+ZxNDNdWD9g5MWEA2xbTeLMyCzdhXPdSRGxg8w44oNOnJ6BExugDcy/wy7dCl1Rbia8BqaK03AfElO+tdemyjXOHnzjHCbZna0UHXW343UhNI1BRnaOSLKZuS6mQpcgiMpi2KjU6NC4Z80zNVCOeWF0vLnwrnJwW7UfeHWO4GUOB54AX9tE6uRbJ1LZgKBCPVvWfVWjCy+qwX66sXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(396003)(39830400003)(451199015)(8676002)(66476007)(66946007)(6486002)(66556008)(4326008)(2616005)(83380400001)(6512007)(186003)(8936002)(44832011)(6666004)(5660300002)(41300700001)(7416002)(2906002)(6506007)(38100700002)(316002)(478600001)(54906003)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TdPowIT/K9SIaKxVMI5uEvZPBJpBaLdJU6IzVPk4lwwwhDvJTyxPqOR/MrHf?=
 =?us-ascii?Q?aVAR8CjUFAkkQOSndO3foF8fjB3f64RcV7/QysRU8YXThEdtf+tmd4WF4mU4?=
 =?us-ascii?Q?Og6X9G+a/lGbICo61zqrLxrWxphdv+WthwCjYrHZaZqEVs1qEKPb/Yrs+yWA?=
 =?us-ascii?Q?X6TgADjnthfru0yCaxtqeWjF3KfGDO7HbqtCRtFMh7nfM7CUXOQl0npE3BAL?=
 =?us-ascii?Q?XIRIfrkK/XDgiOG9eiV556VyUD8mgnOpsGFgOX2RoPy9dADx6RzUTvmdQM04?=
 =?us-ascii?Q?m2ZKg40nT7livyaEt/sAwujOMqm0QNI2iM+ja7ntmV1S7RZXDGa6/e73ArNq?=
 =?us-ascii?Q?hwu5iSf8M+xW4jzORxwWzLLvP35gOBvLMe/mTL1KP/FcttlIb/6KQP++E5iS?=
 =?us-ascii?Q?CK7c8DQTAcatA/GwY5MtVjF5XdZhZynUQhX5ZRvPyYdNoLsCj1D+I+kPq563?=
 =?us-ascii?Q?IipjRUA41cJPSe85W87OibxBfdBlVnxbOttDuDalBDv+iJAFwcFLx/wNB05/?=
 =?us-ascii?Q?s19BQsJ6OO6qQgWDifz3v9/DUM5QQeqBIhaN85Q7fgmPzBhEBuyX3qF+o5cL?=
 =?us-ascii?Q?EurtcEyvgoRb/3AOPBhValc6v3FiOVerYXo8V+64Scz41RzzRtZtmMX7oNr0?=
 =?us-ascii?Q?hVJckfOHE0hRPRoYPXz8t3QqSpGeV37L1YHFqLlL0/IaHaDCB9/rnLiDFBP/?=
 =?us-ascii?Q?Tiux7SmeulOHZNoFfVwnYuynb39jwNgGtTLmRJme1itHcLDhf/LZvHqEqGyy?=
 =?us-ascii?Q?G7aS7iaCyn6roUE0PQt7ksN5nwDejPJUCgqBjPWJaeUm8KqqmUTlcgCjMsvo?=
 =?us-ascii?Q?zhoiGLZpaALoJrtjj9gKmHTW7FOKJ9Zd94Z5IEjJ2pW08Ntykehy52aZDyY/?=
 =?us-ascii?Q?ZZJwoFKTaA/4MmJ2ahyMjwoAAZq97UfoxVxuK4XEO84XjmcZDIjJIlQU5TxW?=
 =?us-ascii?Q?6xOvqCpur28ZPH9OR9ZB3txaDLDDgHKymdtIt6j+RjJFUkA76yDT5Q4JiROu?=
 =?us-ascii?Q?GwYAlIY3mTdFBR4kg1dMiADRnXHLesl6NY8dKjzHUgP9ibewMcStoxZkMaYp?=
 =?us-ascii?Q?miuoZSM/50tw/CbmO9WrfH11kdnaf2J4/L2mwqdHURvfWqaICBHq6lsbcfDw?=
 =?us-ascii?Q?0c08Gh68nGKQI5OYjqG4n91yjiLYNsbV6An2kJfI1//0Escx4Ph1+zKXx7xz?=
 =?us-ascii?Q?p2KkLiIa0DzkKSqqMfOQBYBkV50gRtpLCEbi71/JNnxSWGd235aFVDcf477m?=
 =?us-ascii?Q?VMaaJn1a9Q3ICiFkNKV+k7t5iWdtNmCjmvcXoySFa8gDd23RsxVhSnbsNVC2?=
 =?us-ascii?Q?GSAVvSrBbcgfrBEmdOAZzqq2pRMaDuE1fWvbllwve4rHeYSobCyayK/TNlLt?=
 =?us-ascii?Q?z7AJ7FdkwCw0qfk5YJmDKc+45sAlNlzC0NzVctDUQrnmDasw5lDFoNyhi7s8?=
 =?us-ascii?Q?ug7XHdBF13sXkwEIxVBiORyJx4fVgYuIzvYvIMD+UUC8po1g7oxXz/FIEfwg?=
 =?us-ascii?Q?QB/18B5IzKq+/MTGJjQRfkqv4PgPhnCT3JyRRecHFqHWIZRsZ5CynZ4l0W0M?=
 =?us-ascii?Q?nJh45MRGMxGkwUGQgQiAOWct/x4XCpi8ibnJLkQq4X2tZNei5h8OPCkjNd9S?=
 =?us-ascii?Q?CnuyO2IVBsCitdiJIQ5DUs43Z/UtbA3KNB3b6vMuBVIsKOwS+JXxxRvQI0mG?=
 =?us-ascii?Q?3NllKg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ac6f38-53ad-4a68-4bf4-08dafdfa7cdc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 11:02:30.9352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIqOd9HIFjKJseubmyEyhIziBWLR7qnFgyRHhDkTs+AarIcCE316sm0dW9KAyXNY0WlAQTaVV0r5c9dggVILzgdVbtKHmjBPBnoXjKRg5l0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4606
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 07:56:02PM +0100, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> This patch series adds support for the CAN-FD interface on the Renesas
> R-Car V4H (R8A779G0) SoC and support for CAN transceivers described as
> PHYs to the R-Car CAN-FD driver.  It includes several fixes for issues
> (some minor) detected while adding the support and during testing.
> More details can be found in the individual patches.
> 
> Note that the last patch depends on "[PATCH 1/7] phy: Add
> devm_of_phy_optional_get() helper"[1].
> 
> This has been tested on the Renesas White-Hawk development board using
> cansend, candump, and canfdtest:
>   - Channel 0 uses an NXP TJR1443AT CAN transceiver, and works fine,
>   - Channels 1-7 use Microchip MCP2558FD-H/SN CAN transceivers (not
>     mounted for channels 4-7), which do not need explicit description.
>     While channel 1 works fine, channels 2-3 do not seem to work.
> 
> Hence despite the new fixes, the test results are similar to what Ulrich
> Hecht reported for R-Car V3U on the Falcon development board before,
> i.e. only channels 0 and 1 work (FTR, [2] does not help).
> Whether this is a CAN-FD driver issue, a pin control issue, an IP core
> issue, or an SoC integration issue is still to be seen...
> 
> 
> Thanks for your comments!

FWIIW this series looks clean to me:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

