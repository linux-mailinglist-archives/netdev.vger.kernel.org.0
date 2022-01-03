Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832BC483100
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 13:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiACM2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 07:28:53 -0500
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:64865
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229586AbiACM2w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 07:28:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrWVUjCn701SMO+ma15494phPAzuI4IQSyRtyUstbW8MFmVmEP1oRcY+r1J+3pqRAoV5JTTE3hFj108RK61r5g5CXKvxatZ10M6YUCyAgIjZZkJw8HSGpM2zumadVdS+I/cDGexONDhjKtgikqpxv3jtJqwSqodZow4A+EZ0wCxI0Y6zXzl7hsQLf5aJu1Oap8u65y0LksftVRclnLEOcYq8r5vmtjT6PeA6O+1cdJ8ndEb6pF/Em7dqdmOzj49rs2c6qcMA9EzAJvBwviic/rzbm8hXs6F1xEtAp6mAMd0AqUvBDexxtlkQoU/Fpud9KQpruZmNqhgi2+vNbal01w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjCQo3l2T7uxwmQO1Lnmt/o/VIqUIwvPMPyVKdFlNZw=;
 b=U2oeYSyCqBtXholNVpwN5VeHVxXG1iVgsFrWBb7pqxv7Smh7oy30H5YGPGAfFxwPxsOoE6xWZU5Tn01Wna98wT5Fc6nG/ryXtKDy+H41pDJd5FNHxAYkgi+IwTtSwPInjKfxmQETCaDK/nr8Z5LmfRflNU1jD58SfVOrVk1vKnfHSn7rx1BgGelo6VNIm3Vid3VSkbxAbpSXMdVDZDFvKk0Bbl0kkGmphDTHMSx85MSMckgyLDOUt1KpktqRI+ysx8r1tPK0WkgZmaLVrDWcwyeihcmJfWcd1l5MCCj1IgwM2BQf/IqWZ1KnPBqxTjxUXXPp+kTBHr3LQwUYcMUlQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjCQo3l2T7uxwmQO1Lnmt/o/VIqUIwvPMPyVKdFlNZw=;
 b=Q6bKLZvsf5bqzFHb8s7wb/IODOyJ2JerbT2wSYkVsq0zxqnyQEGnYS1BCh7rFx4PJg5dAnckWHalLF67YscvcYO+/naFGcB+BUBsY9i2cw6hkWEMmAoMhAygnP0xNhut9UWWJYL7TncYxz0HmLYk4SFrGNAiHMPhjHDbmrandIM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AM9PR04MB8699.eurprd04.prod.outlook.com (2603:10a6:20b:43e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 12:28:50 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%8]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 12:28:50 +0000
Message-ID: <3c21a8909a745d5ae1bfa466aaac5c40752cdfef.camel@oss.nxp.com>
Subject: Re: [PATCH v2 2/2] phy: nxp-c45-tja11xx: read the tx timestamp
 without lock
From:   "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Date:   Mon, 03 Jan 2022 14:28:43 +0200
In-Reply-To: <20211223202417.GC29492@hoboy.vegasvil.org>
References: <20211222213453.969005-1-radu-nicolae.pirea@oss.nxp.com>
         <20211222213453.969005-3-radu-nicolae.pirea@oss.nxp.com>
         <20211223202417.GC29492@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:803:118::48) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d56d3ef-1ee2-496c-220f-08d9ceb498b2
X-MS-TrafficTypeDiagnostic: AM9PR04MB8699:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB8699E09CE55093D60C7BA0199F499@AM9PR04MB8699.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQpNumk5n/KK7BkUkUkejZHVnAsz5r/M4P7ZAIOTyAM9YO/6wa3vOKb6OZ6QT2qtVlUzsy3oXtN/zU8a7Fl6ueU3Jk7r3g2CQBrvWsO17eCo7Cm9VSczxU/F16qvsi9wk8GQS2GrzcDRBsU22O8r0HUdx9fnL6PUHctbqZkjJ0rCD+wyI+c+3qV211HidDW6SVuYI+yeFfVWIVmZq3Hb5kuSl1YR737afI828f3P1hW3vSvPBn4FxiTBx2UQNpAo/Y7ZLs3HywQX231OsLYu91Ea+m33Qsx7HaTXaKp6jC05uszSUSCTCO7XuuzcJT2E75yrh4mTMlz5VgousDTqBCfa9yaxcg8rGZEGtbK1+NA28n4tjqGzTZG4Tye2r0zI8hlGxcA78iivp1md1AFfpRqIMPahOLEGPoS9n238sKFt2X28xks+fPN6j9rrDA0IAPTw0vYr/nPLXQtpEYnI+5bUtmHUy89O96x74bTIZODhjKCBoZwJ+iQPZTht5RmY5e+yD+zYWzgH2EfDu2Vmkh1+PjOEMcECJJrV+CuxPr4nE5OpkuCG9PChLmxA1FM6SmYnI/zTbCTrKmuN69hlN7XU1pKqeau1jHODGW4M4r0Yv+Rqr1VxKjCEet0ggVbpCYu7bJt+ewes5M/oslPDRc9QpIXWHF26qvB0h/aQCUd2eIL1uUnOG1sktlIcZ9LdSBqA/baZXfXLaC3lrOZQ7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(6486002)(316002)(2906002)(83380400001)(6916009)(4001150100001)(6512007)(8936002)(26005)(2616005)(4744005)(86362001)(8676002)(6666004)(66946007)(66476007)(5660300002)(66556008)(38100700002)(508600001)(4326008)(38350700002)(66574015)(186003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEpEdU8xK3JHb1JrMVBJWTE4SFg5c2JHU2h5QU5XTzRRSDZVWk00WWtMNnRS?=
 =?utf-8?B?Nk00RDBPWS9hQktqaHFUYlVuUFpTREYrSlhZQmpNRHFPMUtudkR6YjR2cG1t?=
 =?utf-8?B?VDhKMkVBa2k0bDRoTTZ5d1hSeE90czJyRklVOHpSUGNabzFyRFF3TGJ6OG8x?=
 =?utf-8?B?V2M5TFA3S21heG1RalMrczFHN0JleFBCeWw4NlZjMFBWWW0wTUkvcUsyWkZw?=
 =?utf-8?B?bG9RK3ljZ2FHRE5zR2U4WG5JRzlXODFCSXFlR3Y5bzBSeEhzYXpkbzRvbmU4?=
 =?utf-8?B?MGthV0pJN2dxdlo3K2RhRFNEZEF2Z2VIWHdDY05kYnFud1Z1ZFpkNWw5Ty9M?=
 =?utf-8?B?bFlMNnBSS05uRkc5Y0s5enhtTC9la2hwV20yOWRURVN2K0NnRTJGWmppMkVj?=
 =?utf-8?B?bHJsNFB4V3RDUGxMUnVnN1h4MXhBVGdlTmxwdDBsUFJLUzU2a2Q0YU5JaGpZ?=
 =?utf-8?B?cXJoMkdZQkRQZXcwNmJOdDNreWxYYnN6a2syS2FkSzlpUjVSMmsza2pISWVr?=
 =?utf-8?B?NkR5TEFYdEdZVFYxOWZCbElSNXBnY0d0RGZ5TDBDQkhJUWp5MGV0UUtmRUQr?=
 =?utf-8?B?NnFRTWVRYUNvOUZWNDdLeFJxR2tOV25PUmlzdU52WEhjeTBrNkE0TW4vWVpX?=
 =?utf-8?B?QW9YNlE0WkY3RlZHZzJzTlRkNmtWT2dEM2JYVFFVQVNuK05VbXVHRzF1aFdX?=
 =?utf-8?B?Z0JlS1hsTXhwdEVnZTN3eTZDWEY4anFtdmlVZTFrUzRHNDZ6M3UzMlV4WnVI?=
 =?utf-8?B?RklLMXJWdWFqZloxeFIzbG10ekp3R3RVSHZvTmxTT0l1TldyY0JRcEVqUW91?=
 =?utf-8?B?MGNHdVRFeFJ6THFXR3UxZ1JVMnBQOTIvb1Rsd3doRVk4aFJmNXJQT3FNOStk?=
 =?utf-8?B?TkRGTkd5QnIrYVlsQStHaEpUSnJ6WVkwZi9uY1ZKT1R0b3RBVlVLZm5lYmJ2?=
 =?utf-8?B?ZEd2SVJlUkNTWkZlbTU4c01ZdU1uQnBhaW5qVnhmeTVhaFVWUGVoeDFJRTBP?=
 =?utf-8?B?Z2Y4SjlBSFZQOG5EV1psQjBnc0NjaUVnQjN4QSszMjBoWFc5bUErVTlraEs3?=
 =?utf-8?B?TE9UeEcyRTBxMWRxREZMNlFROHkwTlBYckFDUEN0dHhiamQ2aVRIcmZYTVhi?=
 =?utf-8?B?R2M2QzFxa29zSHpYR0FmVk5VNVBsRjVGTU02RDhCUmkwMDFKMDlmZUJya2U4?=
 =?utf-8?B?TDl3d2F6bjFjOVYxTThGbzVCOExGTG1LQk9YMEhaQ2FWZzFQaDRiaUtOODV0?=
 =?utf-8?B?ekc0SEcrdVo2M0dicVJWMHhjTUt4SENDenRpaXc2Vm05dUZrR2pzZEgwWUhW?=
 =?utf-8?B?NWxWcjF2TFlTMGJBNXdBQlEwdzhJMGxGNW8vbXdYL21FZVdGU2RUTlRRRFhr?=
 =?utf-8?B?RjVwZlpUM3drOXhXdzRjMnowQm55bnovSTNsUVR6QWdMeHRzcUlOemljRjMz?=
 =?utf-8?B?bjlBVFVKV2xtU1RpcXBwaGZjSDJvNzh6K01RTEh2TVI5c2kvN2RqS3NTaVZm?=
 =?utf-8?B?b2tQczk4dFF5WUJETXJQcDF1Vit3WmpxYndiOTdQOHZzTUpXdHY4NEtaT3ZR?=
 =?utf-8?B?TmwxcTdRNUl0YkFjNWg2ODNnSS9jWll3UHhhbkpwL09qbm80Vk0xWHJ5NVR4?=
 =?utf-8?B?cUEwTFViaTljSExCb1dib0NlNHhxRmNtbEpYREdqcDJNbVhsSHZyVnhvS3lX?=
 =?utf-8?B?ZGN6aENucVk2QkpGUDU1N2EwR2p5Um11SGdZcUptVHQvY2IyZW1PcGJzRHg2?=
 =?utf-8?B?b2dsSlRlZmpxTFBuRGpCb29YdENrTjBRc0JTV29iUTBlNXcrcTA3cHh6TVc5?=
 =?utf-8?B?UFdtTDMwWFd0UzZvQTlPTlVyWDZlaFpXeUlsbnZQM3ZjYnUvaXY4RFYxRWV2?=
 =?utf-8?B?SGRiOGtSYjBNamowaE11NmtXcGh0VFpQbTNqUjVsNnhzOXV1cExhdDlVWm1U?=
 =?utf-8?B?cHZZK2tLNzZBa2RTLzZQMldRUlFCaDFLQVZac0Nta0ZMaUtiNFdxMXMvZWRV?=
 =?utf-8?B?dkFGVTk0a1FoYW03VmRuSDZ1KzQ5TTVsMlhXUkI0dlg1R3lkVUw2ZVFkM1Qv?=
 =?utf-8?B?MnlLNFRyZUQxVTgwQnUwMHZnU0wxN2UrQ0ZoekY5YThaeUtYVEFiUE5SQXkr?=
 =?utf-8?B?YmtnaXdjMDdKNHBUa0VOZGlFWTk3OERKWkdQOXArL3QzeXpkZHB4aWxYd3Vq?=
 =?utf-8?B?VWp0cE13OUZQQ3VUVjl4WUFMeDR2OGVGS3Y3ZGZmMHdJWDNRdm1IWTJDVytD?=
 =?utf-8?B?QkNrRVhpUHBucEtRTVhTSGI4cHl3PT0=?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d56d3ef-1ee2-496c-220f-08d9ceb498b2
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 12:28:50.3848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEeRbJhcsB9DOrV1TMQSak2rt1r3vvo5uqWoqxcQ/ynXJ6xhxsMh1Ttf946aOCHkKMZptCXng/agELlpQVHbslrS6rEztYhigSXq1SvadYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8699
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-12-23 at 12:24 -0800, Richard Cochran wrote:
> On Wed, Dec 22, 2021 at 11:34:53PM +0200, Radu Pirea (NXP OSS) wrote:
> > Reading the tx timestamps can be done in parallel with adjusting
> > the LTC
> > value.
> > 
> > Calls to nxp_c45_get_hwtxts() are always serialised. If the phy
> > interrupt is enabled, .do_aux_work() will not call
> > nxp_c45_get_hwtxts.
> 
> Reviewing the code, I see what you mean.  However, the serialization
> is completely non-obvious, and future changes to the driver could
> easily spoil the implicit serialization.  Given that the mutex is not
> highly contended, I suggest dropping this patch in order to
> future-proof the driver.
> 

I agree. This patch can be dropped.

Radu P.

> Thanks,
> Richard

