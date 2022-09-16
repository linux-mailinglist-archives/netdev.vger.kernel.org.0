Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B095BB4AF
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 01:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiIPXMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 19:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiIPXMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 19:12:19 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2104.outbound.protection.outlook.com [40.107.100.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5918275B;
        Fri, 16 Sep 2022 16:12:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRwaTKGpMI7F1rlx6p5vYR9n0zcsuqeOAugN8SP7FYLGjP8eLn0tvhrSYWFqxqFa7KTr9UmWxIcSL6MnlLcWKhVsGVBEf68uaC/FyjBQeNxpHBhjCEbk7qetQHECVy8N7Ck7fHv02mKU/JPQOONx/2N/tVOBxzeZBTkHhGf7iIAKjTvLx60qpYm638+krgzqji+HEKVyn0YyrdsJ2ZSdzvWCQtcunM/RMgfeD0prBcElWQQz9Fwh+9duqb8M6/cXCKlw8UA59hLXsZO85kdKjhH5zissO1faTxtXpoMlMcYdidvKHJH1h+sv2A2o5MwjykKmuXz8+6ItbA7w/iXbHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTXAPV8BVYXxBagD3b9dEcWltqeolf3pHS6cHZwPO7E=;
 b=iyaLC6QIxdT4YGYAfnYPvnGIcYn8+8qkOxdIcys/c86lZi9mx7UOUqTrjT7lbGSHQtq6PA0lzAKLbjFumt/xUojGpszzpq183ZTUcY1FkbqkRWW3azmthuc1eolWSdxxm8dXNikLkdnZ/dCT09GP1Kv/GIE+WW9QV/HrgndN1Q2rTBkPlVwKbCWaVjxygL8npUwd9cTlnEcbfxkGsQ4bgUnumWB/MgTsw3U1fI+/bsxPomiele6Vf20Me7HggaCwFEk8O5FyQ9SX4L6Nd7Ms9Yn1yx802nWn6h7/cIOoPy17yB+D88nTj2GEzZ7YY/u0L5M0chz5MrpAiSZY9dMfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTXAPV8BVYXxBagD3b9dEcWltqeolf3pHS6cHZwPO7E=;
 b=eN9qzay5DyWIr5K76lP3/kLeZyC5gFfdrAi1BRaseDSonkS2haf4klu3rirs/OGp8Akac2L6AJ73czBDunh5RswamTRfWb+rTrLVowdn3Vm8E8ZGNM4e0AOjwDj4I3j/vxxGCWouMF3QHZENqmYv7ivrfhcWd5eTWmuRrG3CgwQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6202.namprd10.prod.outlook.com
 (2603:10b6:510:1f2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 23:12:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 23:12:17 +0000
Date:   Fri, 16 Sep 2022 16:12:14 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 2/2] net: mscc: ocelot: check return values
 of writes during reset
Message-ID: <YyUCzh0HdEZ3DlQa@euler>
References: <20220916191349.1659269-1-colin.foster@in-advantage.com>
 <20220916191349.1659269-1-colin.foster@in-advantage.com>
 <20220916191349.1659269-3-colin.foster@in-advantage.com>
 <20220916191349.1659269-3-colin.foster@in-advantage.com>
 <20220916224009.g4prlpphnji5i4zi@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916224009.g4prlpphnji5i4zi@skbuf>
X-ClientProxiedBy: BY5PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::17) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6202:EE_
X-MS-Office365-Filtering-Correlation-Id: 536a50f1-bf3e-4c44-cd22-08da9838e60d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l0yTDdH8UEBM0F7q8+3GtqzDW1GbHgYSyvYB/Yt8Wqz6nbuBU5p8cr/QJzEOxxbVgNDmhCOijwkDU0TPsGH3fzuOXm8dH2uE0Wg9Rq0YSTCQecHxaDljmQVDMUos9KMORHiW2AN0i0siHVPxQzVHzs82YWiNfirToPSx1tHx65EZCPpU2JrOGg4zm1p1AZdqMUarwh3SuO/QT6yvI0+RK4jf6h2zj4Mc4SBRvyItRhcNCA8K6IArEYAahpSHUGKNOZGcLp98qurV8AbVEEQL9G5v8BMtVwSDCAeMCBfsphlZE3N4odnRZjr2Z0pWtGrmltOC1ldtBnB+kB77igoQuaAGYvlEKrO9Lj40TkPdrGydCeQ4Z2E6aXx73+wNvB2VIGjbnDCCfQvWBZnYOr0y8f4YaTsaz9/u1S+2oFGfWEOmMVolLOIM6vSzyXBncfRfUOiO3Tuni45dYWC43MCdzTSD7Km6tIavDRi3R45jPhpc8yNkiIq64gdsLhMvoaIUTrGfAjfIVeAP/cpa0QDI+yG3/i1Gbrsh5AqM+KIXyR9SM99Bkc8MlM2df2cE3kkyNEvFIei/tSy3h5g9JzAT6Vv0zoUW4URI7SQRycpv/aWQuRE1yL0K0tST7q1QmmQAVV15v85wcfhZ476ZRTxkrauWecSScxeSI4bK0smrdKYVUR5mpM+63ZjEHSB1x3sAB4jz85RYqgLTrOplS+YrAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39840400004)(366004)(136003)(376002)(346002)(451199015)(86362001)(316002)(41300700001)(66476007)(4744005)(33716001)(26005)(186003)(6512007)(2906002)(6506007)(66946007)(5660300002)(6486002)(7416002)(38100700002)(4326008)(54906003)(478600001)(9686003)(66556008)(44832011)(8936002)(8676002)(6666004)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?npzk+FgIzzPShnKeSigK182u96iAPiTVGyHqpMpAEehI7fyQr1axQtkdFdRo?=
 =?us-ascii?Q?mX8OdIWMe2aX4wkMuB/XO9aadRmT3oUJKPbq7c2kFyeOytTH0gTeSC1JPqJs?=
 =?us-ascii?Q?Ze+SI7f+DNtcFizoEe/SjsP0onZXr9XKTVnCOprKZEpOi7wc99b7MlsKmfB9?=
 =?us-ascii?Q?UMVD9i8ur5evGO5AV0ELcUKfVF3GaVnp952Txit5Tc7uIwtD0yV43oWOiutF?=
 =?us-ascii?Q?QJ+KxBEVVEfc4fJEIIf31FOF9CQhfkIaQ6y8ab6oUM2ZQ8GWxb4d2xQ7xUmz?=
 =?us-ascii?Q?i8vuPSqaxqDMQQg4XSYcx6A03O6Sh2YFNKRCcZAqotXa+65gApaX3jOjEn1b?=
 =?us-ascii?Q?gLcMKfe5NC7fd171PG6CLIzKqJyve567n+p7BdbH8UaayoxuKnFetvxMpJkK?=
 =?us-ascii?Q?XD3EhiLBFSMF31F4HLhWFbMiIhs6dju53QkDNpsJOEITTAzUw1UIJj+/Osa+?=
 =?us-ascii?Q?G/1ujsX7KnM1LUEx3h+B14kldzYJ8uW5jWSZnc35YexwO2QsYqIyhymEFkmK?=
 =?us-ascii?Q?vFiH91VLcp5Z0UjEXen+to0l9+o5A6j06jQLKhqW3veIwC+WdMoGgEHErmO/?=
 =?us-ascii?Q?j6YdwqYQ92ejn4fkL3QfkUu5Fi7h+1KXY/p4HoGzTboJ9uIlcQOuIfuOH0Wj?=
 =?us-ascii?Q?d24YyVFRNsZmmPcQeweZoeDEKho9RQArvDzcGBCEKiVn0/TVuo5zoco9/ZM9?=
 =?us-ascii?Q?B+2PgmvbtvpaNOHcCbT12n8zSqDPF5sN4JLUFQ3JmfMEwkPzCateW6HANLHq?=
 =?us-ascii?Q?wnqYSps77sY+y5Gm/5K7wTryaSrsF6oRYUXrO5b7xRZqqba8c3/dAV6NaVSJ?=
 =?us-ascii?Q?Qz78JDJQOoTFGSaIHG0DbSzVpYLPc78uDDTqN1bVmkqmoC+HqZEfhu8vjIqU?=
 =?us-ascii?Q?6lIa6YFwwapQ2nfH3+kcOcIaSmCjrfqgdeUGoToWtiG2Qb9OdxyXtAQA93BX?=
 =?us-ascii?Q?5Y4Ci8hUktPbSyiZzF8WX3ju3atTNeM0IH9mW9FseCvaP53Aw6CI9xfyD5is?=
 =?us-ascii?Q?vKyAEpdp6fsJuUB5n+PykcbsTpZHh4jliE7ffbd+CGx6uStB8Xu8CB9gj7p2?=
 =?us-ascii?Q?kz4Lvxm/eEtbYS5orGoOKodK75qlmE3uVIVKoNYxjZM3C8aFQZicKLUvtWF4?=
 =?us-ascii?Q?jkO7Wf8J/ZeJoz1xlYPFjLepqkebHF2Q0GAuc29avJOIoKy5gHoebUjhkBbz?=
 =?us-ascii?Q?/Uu5oFCTI9IVvGkdRgZwIYTpRggkaeexlhzrtqvIVYJAij2nPP0ymb4F1iSZ?=
 =?us-ascii?Q?Ei0nGiQ0/Irqcn3IXggFN8J1/kUB28/pGZ4Dj6f28jpfu3PjW7Rz8JUgS6fx?=
 =?us-ascii?Q?WJPvy6lWtN8tbEszRh3qmVabiu0VOrXnu7KBPRIrcILmE2zFOt2QL9RA0wLS?=
 =?us-ascii?Q?ughFzBWpiW9O9JXdWDNbx5PxjBzm2+I4PuymkxtPx/nlnMW28p18ENCF/7ka?=
 =?us-ascii?Q?A/rnqfN39SplCxhn6A0FAnH5uPBLmPvbcT1+qi8hLiMG5Zg3cKPZUjq7Fo+S?=
 =?us-ascii?Q?iXv8bBgsTejSjWJRj7KyrzOoNnyA5TnRNTEZcIJlCEgghcwbrDp1JIMoG9i/?=
 =?us-ascii?Q?dQYNHkYN7pSBpzMrESk0+pTf64GFc5WppBEgZWoATov8fycmQ6CS1WAEmxAd?=
 =?us-ascii?Q?xVrhNlGKsgRHFHleRKmaJy0=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 536a50f1-bf3e-4c44-cd22-08da9838e60d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 23:12:17.3163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gv8CUpKSaArOTxt425qDPSYGYchbKgkwiWs2IROabUL+9i5s3ew6bH3WKNcfyaOdtNtCB+GlP+5fzT2oMvrBVojP46t6OP/rX+eRgmwqgGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6202
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 10:40:10PM +0000, Vladimir Oltean wrote:
> On Fri, Sep 16, 2022 at 12:13:49PM -0700, Colin Foster wrote:
> > -	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
> > -	regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_MEM_ENA], 1);
> > +	if (err)
> > +		return err;
> >  
> > -	return 0;
> > +	err = regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> > +
> > +	return err;
> >  }
> 
> A kernel janitor will come and patch this up to:
> 
> 	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
> 
> so it's better to do it yourself.

Good catch. That and removing the IS_ERR_VALUE macro from patch 1 and
I'll resubmit after the weekend.
