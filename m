Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D39547CDF1
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 09:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243221AbhLVITh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 03:19:37 -0500
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:55482
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243198AbhLVITg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 03:19:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TS0lFEmGJc++NT+BikRJdgv2i9eSJSnU2Sdhbnm77M4/tr6XDM/TyM9fvp6tNWzU+nu4dp8KzQKrU+ZM5Ao3je78B8rN3hsJTWr/vq0tvwKOyGkuLRyoo2JK8BLYC6vPnD/eqJbBJ4uCcBJQQ9VRfuCk/u/6YDwZLYfztLC9NgPcGsYq5tZSWMov/yhf5PCd9NwdTGdrlZOvwp8WQmkuzHikj3jDMJWukJzwKDGzSYqyStxWq9IUOFYDf5UvFTsFin/oOZtDn0xLp2cLPpVULPNtt2Rs7F227kGBgXPmdpd2cyMyeXAifyAyhkE/CGpWrMq3Ty9QeIilMHOVCH4mWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Al4+1bkvJce5Iij92iakArkw44qiho4/tF5UwndQmyI=;
 b=gEN014gFeCjYP6ObkUy+omzL+45JCxAVqsnAGcFcu7DakWIHbbNfwjaqmUhfBponZg3iCivZ8GF4GGveVJxXuHm6B3N9SPI5F15xlWy0u8hILP2bAlVo2UXxLUxkmfhaITcIgUb03J7UvCTXUneasHUyAy6raEzDvp8+ywn9rQAtBByLlqqW1JypB5uFfd0I4GPIRfNAOXWXpAtfTriJ2d+qvNq3FTEwzP89LeMRT3/ReR3ALBa2PUADv19KaeQsRLA1JeDd8V0n8s6vmr7Ylpx2nvaplLWOgupcs2WWxhddCpv88ocUmRgU7B7i78U7wbqZbEqpBFgrFlZ3XrxKjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Al4+1bkvJce5Iij92iakArkw44qiho4/tF5UwndQmyI=;
 b=RPsSlYZEiaPYUgD89o+u87o6iS50agJpL8ilurntvcvjHRmyFCqK0i40u9JKi5EGHGoDT/ER8vzZaMY+Qes8drPsyTd8M+0e/gHm4EicyxXZX4M1yE1+OtSIgKir78YqzSrdGgNzS5tmc7TJsMgiOTf+32JwRJjbk8QGbXYZOAs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by AS4PR04MB9459.eurprd04.prod.outlook.com (2603:10a6:20b:4eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Wed, 22 Dec
 2021 08:19:34 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::1109:76b5:b071:7fce%7]) with mapi id 15.20.4823.018; Wed, 22 Dec 2021
 08:19:34 +0000
Message-ID: <389230ed31212b2c9e242c9d2f55489aadc89bd1.camel@oss.nxp.com>
Subject: Re: [PATCH 3/3] phy: nxp-c45-tja11xx: read the tx timestamp without
 lock
From:   "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Date:   Wed, 22 Dec 2021 10:19:30 +0200
In-Reply-To: <YcCc84XAlckpTnkF@lunn.ch>
References: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
         <20211220120859.140453-3-radu-nicolae.pirea@oss.nxp.com>
         <YcCc84XAlckpTnkF@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0147.eurprd05.prod.outlook.com
 (2603:10a6:207:3::25) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cca72b6-75d6-4426-94c4-08d9c523c90b
X-MS-TrafficTypeDiagnostic: AS4PR04MB9459:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AS4PR04MB9459A0316B43B8A9F902C5AA9F7D9@AS4PR04MB9459.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CmMWYjmMnVcIvKjOgg8XOuPKysfpF9vDIT+KQ874a04oL25gZqiCAyRkoCBWZhXb9B7i7D4qG8GTwT7UyQ0z2za3yafo0wDdJ2zJB8S/vpixF2UJ60BArN8afpfSI0v0yMUa/3ydcNn6Rhk3g2wMn+9H0DdBwTgS0n47h4GcoUOn7sh+/OLX9/fcUJfPiJA1xRCmPmegYe0efr+8kP8ZKKnz+1Axi6q5fJrSVXEafQ6SLAjG7MzI6FQLet2GkTeS6JxfDwbCcJ7wpwVwgRuYBnotNFgZRlLwOkqRwyqSulstvFBlejnWZsQadShgtvBDvo0Sh5ak3gPAei6euYsk4hCLGzmkXD81X4pzipEwa6zutKIxBVjXg26YMfDlHetFgP2FWWjd/lrZczg2bNQpfz0xrM4V3prdD8EkaTZLbp8Hb17EHZ0gZ/8+W266kx7dAZ5jgr00MIcRq5Ff5BBf2rlwjxpbW7nc/6yYg6WHzCHQEID3ROlI8ENJVs6RAnXzO6PIDU/NAPxsM1fi1eW51EPuMUtdOU2SE03osFebJw5sXJSLCEUVB/IvSbpZR5/yHC+JY8ZrS+nG0SikVOeaSXJ4IKitgFrI3Xv0WwrUwN4ptknM+5Ne88YbpF33Wvfv9xTY1GDzR/NtVAU/NrNcOty/0GDRiozKqhVKBoPceLcjSW9G0U+gZ3ms3Fm7nWsD8dMI82Tq7wYn8lM+lu3aYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(4326008)(186003)(8936002)(6506007)(4744005)(6666004)(6486002)(26005)(38350700002)(6512007)(86362001)(8676002)(83380400001)(508600001)(66556008)(5660300002)(2906002)(2616005)(6916009)(66946007)(66574015)(66476007)(316002)(38100700002)(4001150100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dEpaR1JmTmZ5L0xIdGV3dHZtZmxCaFlVbWs2NUlkWmtpNDdXRG5mODN3UmJX?=
 =?utf-8?B?OVltOUxrMS9vOGVFNnpKU01mNWVVdWNsV3pXdTNFcml4M1FTT00wcElaRmxl?=
 =?utf-8?B?blhCZ1RERCsrUXR6Q0FKblR1Zk9UbXdPY2RrM1U0NFo0UzVLek9URStBd2lB?=
 =?utf-8?B?Q0p2V0pVUVNsYXpWVTZDL3pzUWZaRDVMR2VuRmRGZ3hDWklJMEFsenMyTUk2?=
 =?utf-8?B?S2gzSVZwaTRsNTVGeTg3OUp5STFOUDlieWR4YUppRUFGWUhUaHZ6OU9ONnZa?=
 =?utf-8?B?U3JhMkM5OWFxQW1ZYUFiTHhnYzZFTlBpNUdFUkQzWnVpQURyY3Rsc1B4SGM3?=
 =?utf-8?B?YW9MVTlFbXdSUCtLZUZ2a2I4UUNReHhOOHJRRXp2U0FDWnZpK3lWNVlxRzMr?=
 =?utf-8?B?a0ljaFc4MlJUcmlUUmZScitNL25NUitPcGIycVdlMmYyOFdEcXM3T3ZEOWkw?=
 =?utf-8?B?L0tvd0RCT01kTmFncmZ4b1VzQkxTVUN3eXJRRkdKNDlORWNEMW9sR0xYZFJa?=
 =?utf-8?B?TE9wdWlHc2pQR05xb3FrS1Nnd1BEWkJqTndQbVhQdUJVNFFEV29zRUxsV1JD?=
 =?utf-8?B?YUllVTI2R1VtWEtXWitlWGpXMXMwZXI2Sk4vRFpyVXl3VjgwcmxnVFdadWFz?=
 =?utf-8?B?bDBPNkJUU09BamJyQ0JyT09Td2I4YURBd2l1Tkc0cjltSllJVEx6YW9OL0VV?=
 =?utf-8?B?eGxSMm1XSnZyRXJoWENIN0lBUmJsV2pKbGdZNEJVdms1Y094TDBRRXBSSGhG?=
 =?utf-8?B?TGxxd2xpSEQxMDNnNjhOVTFSa0p4NkdOZUYzV29NRWQ0MzA0enExanBxeFlZ?=
 =?utf-8?B?RDZtaG1oeDlGWXRCVmVLRi9MbmZrR3ZPWWplSkFFdENLTlplQUpJM0pyVVMv?=
 =?utf-8?B?bUlXbmFGckg3Q2RLTTNsaFVrNkR5alZPa2lGNnVBRHlVeTMybDYvZUxkUi9a?=
 =?utf-8?B?aDhRQWF5cXd4ck0zZ1hCbTh6OHJFVktmSkR2TDR6YkJaeTdtZEFvcUxpd25r?=
 =?utf-8?B?a2UyTzEycVIzek91S2M1dE1HcXVjQW5lSEc5bmIyd1h4VmhyT1JYUVc1MEFu?=
 =?utf-8?B?VVBkKy9zR2dIM2VzV2FnZTRjZW5zeEJUdE5xM09FWUdQTEQzNTVmMFBGUWNp?=
 =?utf-8?B?K2pKTnZXdlQ3SHJQNk1zOHU1UU5jNnBUN1hqQ09wOHh2aWoyTnlqVG9iWGkr?=
 =?utf-8?B?STFNb3hGcjE5SWZmMURMWlB0eTJaNG1EQktjckw3cFBtWVd2MktHWEVZUGVx?=
 =?utf-8?B?eGsvelFNRDYvMWlZaHovYXRGNk1LelM4VVdmandaVW9sQTZnbEkwN2dNM0Jm?=
 =?utf-8?B?Rk9kdmppdWRkcU5rS2dBQXpHaUZaY2dnK1g1RG9EYlVVWnpUMHZTOExndmUw?=
 =?utf-8?B?OWRtWXVDZk43RE9nVFpJZ1o1cnNGTkJhMktmK212c3FjS0llMEdMdzJlZUFz?=
 =?utf-8?B?MkFWNEJuOVBNWS81QnJPRmQ1dHdpQzVZSmpsSk96ZkFTbndBbFI1dmhLZjZL?=
 =?utf-8?B?dksvVmNiaE02Z2s1dHhaM2JIYkJ3b29kNkpvOWZGUmc4blZRODdydENXQ3Rx?=
 =?utf-8?B?T1ZCSkNpblZvbUpGNHJHQ1JOMkJTRjQzeGJrUTRpenNmOEdhN1dqRWVSMEw1?=
 =?utf-8?B?dkZIOXVzTS95cGhOQjZIVkFMa1BpNWZveW1HeUZjM01zVFVRRFovckpEZ0gy?=
 =?utf-8?B?V3lPRWxoS0V5T3gvcDBJenJ6ZFFMbnR0dlREYXlHSE9GOTBvRFZweFViUC96?=
 =?utf-8?B?d1dCaG9pMnV3NlNKUFBvQTM0OHI4SUxEUkY2dlhTZDNXTEpEZkIxcHRGbVFT?=
 =?utf-8?B?eThkZ1EzRi94UEhqSnl6YnJITXZEOVZTY3Bkd2d4dVVVVit0ZzVOT1cyeXZ6?=
 =?utf-8?B?YmZUdHJ4ajBhUWYzUjJBMEZ5cFpjU285QklMTGtHbFNTekg1b21OSGU5S2JO?=
 =?utf-8?B?bTZsSEJNRDVtUHErK3hLSTVSNHdtemtnMDk3Z2paaXlhUzdQelVaY201cmhL?=
 =?utf-8?B?REpQTXZOQWJ1OEs2UWlacVFYUnlwYzMrYTdsVnVha3lPUFZEcXBlVzhySWk3?=
 =?utf-8?B?UUQyTkszSi9EY3M1ZUJ1emh3bkZVU05YV3pPSDYvcU9vTGJiaExaSEp5QVZF?=
 =?utf-8?B?V2ppZUl3cm5IUStuVTkrYmxEVjBsMlFrUlhqSy9sU2JhNmJ1VklTeGk2amlp?=
 =?utf-8?B?MU01QkowbWlCdktQQzMvQk10Wkx3S0NjOC9ieE5IbHorN2tvdTdpMllpWUhW?=
 =?utf-8?B?cDJ0MDRPYUtZM3dFaDRmdlhHaUlBPT0=?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cca72b6-75d6-4426-94c4-08d9c523c90b
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 08:19:33.9810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /OgLYa1K8Dx51hyuu/O8q/8cJC5GnaLSN9adOH4+GMnHlQdVCis0bvm9qnfN219O3zoOEivEtiDm3OJA/3QI4Vc8Y4hLBOrPVvPUcUSYoYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-12-20 at 16:10 +0100, Andrew Lunn wrote:
> On Mon, Dec 20, 2021 at 02:08:59PM +0200, Radu Pirea (NXP OSS) wrote:
> > The tx timestamps are read from only one place in interrupt or
> > polling
> > mode. Locking the mutex is useless.
> 
> You cannot take a mutex in an interrupt handler. So your description
> is probably not accurate.
Actually this is the second issue.
I will improve the description.
> 
> Is it safe for other ptp operations to be performed in parallel with
> reading the TX timestamp? _nxp_c45_ptp_settime64()?
Yes, it's safe. The purpose of the mutex is to protect the access to
LTC(PTP counter).
> 
>         Andrew

