Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0EC6C6CF0
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCWQJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCWQJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:09:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2100.outbound.protection.outlook.com [40.107.92.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB21EFEB;
        Thu, 23 Mar 2023 09:09:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkxrFRazlVvl8sWI35bJ8BQ8/o8FZ8nyQg8kFCN3yScy1Eq9/ZIgC0hcXW/wmrqbxpFQ19AeN9GqJJXywuJQiij6hsLyorYVtEOO2hPuTw7xs1Fe6Ypi+ji/OeQ9mHCKb7a4x87XX85s+F1bBlX0RIwMTpEuK4YE9kZKwBU0nL2Pxn2A+lD2JkUE1rt5GSp9Svk3A7GUDSnnW1PThHQrXb8bGdm4+XgAhe9SSXtibFDlWz5iEAYq4f/LSGOWVFsQuEn/0JxuSeWzc2ZEYA+/QUdoSyTxPLohQNVWt+6Q1iYRyxq5E8MJkEnZiAENUI+E5SJeYnk2Zls36w/qTiiHcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oHkefe7rzzxst438y1wzj87O+I8w/1oIK4EER73HAb8=;
 b=X57dAjvi7Rvhh0OJtzkiK8KhbvZZ7n+IGZoFPTACAWF1jqn1BVsSJtcJYUyZADr3NR9jUgKN4R/g1zo1Q+JWua6pJ8OV7gYf96Vbj5NnfcEieFTP9NPkQmf3j3ciO0LTMgDMYxP0MFrp0l09tHYJmLdSev/W0TF0h4+OESRitq95kRH/FDPcfnHZ96pKeCmmRcZyn2rSkdj2ccL6aSPJDlpr6EE7flWJqWd8nK3l/jfso7KmCP/tzQhhR3HNQ2aD4h0JQ9T5upF35PMSJ9q1TFFCCtR7tYymg06kEdkYPD9up/z4U5XHPJ1iwM4tDbRycdAOf5bdfqF6/YEfAtIyQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHkefe7rzzxst438y1wzj87O+I8w/1oIK4EER73HAb8=;
 b=I0sV+lvCiZnb80IHohOZwqKlylPE08EvTeIpg+JY9M0T4Dw6gPfxOgbX1MGqq6Tf0WGsXBVPKeXlVBxAMyNJ6YI55lQ7IH6J2VNugv1gn1ZAxvLzt6kqSqE1ILWQLjFwdCIYHeA9DeKfkE+dtYTdVsQzPetxxk87LW9Tmj2ccW4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4654.namprd13.prod.outlook.com (2603:10b6:5:3a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 16:08:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 16:08:58 +0000
Date:   Thu, 23 Mar 2023 17:08:52 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/9] net: vlan: introduce skb_vlan_eth_hdr()
Message-ID: <ZBx5lP9C+JHO/N05@corigine.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
 <20230322233823.1806736-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322233823.1806736-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM4PR05CA0020.eurprd05.prod.outlook.com (2603:10a6:205::33)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4654:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e4da351-8c77-4e6a-9179-08db2bb8e8e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vL8d+YGIrIhKHaH0aEQBKK7TYviN75jKpIh/jfFCQoUYG5x2NIOZTZqJ58YgruSDLu33CiTxNDy3bKfwy4rWd2WH+jRoBbRCB+uSBRu+Ve6D42CMSYTXhV5iNKkM7GPn0Yuw9ICt2pPT22ADKVCx44j8ZKafMSnKZ1zw7WwETVRI+6B/EgH1LnG2y1iJCr8PZqeVF/OdA1OEW46v3nmJIEEBq5XuaRUfno3yuTNF0lBGwcXnazp/rF+MEnic1q0/4WEFn2hzjCelEUMh209P9xR1J+9Zt/ujd4hvqXWIx+P+QcFbPy8a/ifUSCZr/fkFd07XtWk8F2+wb5R1CZHtKDe8MPMzlONWl8S2yIt+1C++7PqnEhAezVLWEauPd7nqGTxTFJj/iYJBIUhrBymSzgwqNolgLuSuOXMVQr++cS6ibuc2/l5HQJGhiuDveVoTyJIAIvTJUxrCR+C3nUO0grW/E3Lr13yR38oV2yqmZwJZ3MmzfTAa1dw5ZvVLEtluzSMkczmGsqm/JE0UbBOjSSrx/L7OCVeWxlW4LMpm1Sf77ZlxVXRYtHuxahJWh+nR90YI1KnzStLh8DzqA8Vq5NCJRqYau+1M2RDE1dhsSTAg20ca3gqJe6cNRkypx1Vaz7nW+gjvYLaWXH273liA0USVplXLjvc1vY2BaQSvrubRyGRIyMQscAd1WPBAFFsK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(396003)(39840400004)(136003)(451199018)(38100700002)(2906002)(478600001)(6486002)(2616005)(316002)(186003)(36756003)(86362001)(54906003)(4744005)(8676002)(66556008)(66476007)(6916009)(4326008)(66946007)(6666004)(8936002)(6512007)(6506007)(5660300002)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WWS0XIAT0FscC4jj5qoyd+4CvFtS5r7PLzctd9Z3n0fvZht9w5y0pMAq+Hqg?=
 =?us-ascii?Q?fxMgYwFY5TSh5zg+MyfSoWQKPgGJqOnYAWHLRsgDkA0rkxnaRlL3j9GIZRL/?=
 =?us-ascii?Q?lCHJBrdilqUHLFHllOJkThuMaf7pWoaDvvojWRGrcidQ/VzZTgWNw2QoW9Hm?=
 =?us-ascii?Q?W8eEAPeWUZWIiGCfFfnQvVKeAZoZoBC3yn9Sd5TxJAl0kpSL/6izX+NAizXT?=
 =?us-ascii?Q?RV2jm5520Ox8/w/giNYyUZIrpThHxhjsuEDNZGC9KG/wdDcKJiiIoekx7h0Y?=
 =?us-ascii?Q?PMPFIH1WGNqqXe5izv0sIcgSAHidJp7blsoLYUMv4oMW2G6E+UHUQzTJ5R/H?=
 =?us-ascii?Q?yujTGGAIBniudX9xkxs1PoNRkiExWPX7IUD+7ywqA/42E4vI6EhPDJNFhwyk?=
 =?us-ascii?Q?dDmLtIqkUVTtcG+b7UcWqmnJoAqx0u1uT6ZItNNGBdM+b+PADYrY02kEbzZq?=
 =?us-ascii?Q?qM7JzKYYFzzjHlLyuL/kkedJX6IevX5cdpm8ca5lRH8ZWARJfwgaeirR5PWS?=
 =?us-ascii?Q?cqspJ1A6t6pF/Opm+KFPk6yUbYA8CMRWgam4tWxkOI6DKaUzQ04wN9UF82Bf?=
 =?us-ascii?Q?Z9etPrzlCO32dN+UXiG5wMiRXhvr4dSqEfTZsFPmJPrzVvpgNovRPEC34hM8?=
 =?us-ascii?Q?8THA5sokAANxGZsIuuDo6ol17bVBw173p0iCkspJ8fwV8KG8cISrGufiETpj?=
 =?us-ascii?Q?OJJce1qTxNGGd8vMUrX1xQqjPje6XakcNaqc371c90ucCL6CAasspdYM5Oge?=
 =?us-ascii?Q?ndNNRxqisxvI9LBlMxxsK8tem1Q2BHTucVciZbkQRtVyOKmd2+f3RtrGrh+u?=
 =?us-ascii?Q?iPqSnDs2bB6EluiDQM2p7zwTluwvnL5BmHL8U0w0bAZ78/cFpj0I5pxrNsiR?=
 =?us-ascii?Q?Y16E+LHcOMNEvA0ybvWS9n7EpCxyCVnClRfcaHFh/LYoMuNDUVwTJaPafPtw?=
 =?us-ascii?Q?JZvFGeiT7Qen/YWNf1y4CF/RKq+tKAkYva+KfbGB6gLN+IV8gSZkGuXVx/kc?=
 =?us-ascii?Q?3vGX/NrfY5EM4k5+U2hR+rSxj04Vn48byDIE0j7sNiz9vxzy8mj3VsfcHUzt?=
 =?us-ascii?Q?9/aPJUZVZS4SWYyqBsRgCwONukf6KAG1BG71mnYAJ8PNBF9cCHYdI5L6cTIo?=
 =?us-ascii?Q?FsyUB7JBGaPqxETfK+mC16k5KgZxxwTfH4zzgPjuN6jFkXpjXIPkq4H9wiy3?=
 =?us-ascii?Q?DBRuAZRT5OH44wtm73m4YG5yw9GIxCfqHJjMzDSQsxaUnHzjsWOz/8zJ/1dz?=
 =?us-ascii?Q?SV3Ra+y1PYl4OJ2xvSo7toNzJEvUhMDrVg4LCWHzRBja6EdxIKrwgPX5K7ft?=
 =?us-ascii?Q?wBbwqzOvxVREBjVnhjzK0SVJBLG1Q49+t8emCl5owXtC0k9iTnPAEbCtOhty?=
 =?us-ascii?Q?kIK+jViagEAEkti0YUbzFuwKclJwwvW4FRY1wpOjZEl1FdNNDJfQY3VMUzkm?=
 =?us-ascii?Q?LL5q1VnY7LahG0PmtUHmtEss1ZRuxhnmFquOOcV7h4OaMUNwC1o3UkV7/r1H?=
 =?us-ascii?Q?Or2zLIXUMNZMkLtjbzBtNnHtFxQBcjgu1cAwVc+wFnjuBXlN+LHjm2UuPni1?=
 =?us-ascii?Q?5morG9wTH6fybK+JUQ4naW+tQ8UNAymDg7FR4Q5rB16c7g5/q4NRHecJcrJ+?=
 =?us-ascii?Q?UF4Nk2G2PcAGqabD9gwMtNpktH/YJpEFKkbVEG0KVPwoyKC9TGFNk7ks0OXA?=
 =?us-ascii?Q?Cp/Naw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4da351-8c77-4e6a-9179-08db2bb8e8e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 16:08:58.6630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edtIRioT1YNjTacyYCFKySStBnuOo2B5vS1qn2l7FB8nkBPFzKPlhmL12FwJRloDIavHp8vp0evrFhv/ZFZ+1tmph32Rl59M6bMNRgC+3Qs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4654
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 01:38:16AM +0200, Vladimir Oltean wrote:
> Similar to skb_eth_hdr() introduced in commit 96cc4b69581d ("macvlan: do
> not assume mac_header is set in macvlan_broadcast()"), let's introduce a
> skb_vlan_eth_hdr() helper which can be used in TX-only code paths to get
> to the VLAN header based on skb->data rather than based on the
> skb_mac_header(skb).
> 
> We also consolidate the drivers that dereference skb->data to go through
> this helper.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

