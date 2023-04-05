Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A016D7C46
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbjDEMS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjDEMS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:18:56 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2088.outbound.protection.outlook.com [40.107.21.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F2340D3
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 05:18:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBM0UYROZyBT/fWsHl/9dyIr6TztbndfumxxcSaU+QqAoZljSp2INcAfL3n/kIOEf5JTxvaM4MbfHrWfH71KxhDJLRoN0m5KySYOu/PAUr1GgnBQdtLDSdR0FsmpX5MfvA17oEI4q1EPPAHreBTaOSNsmmJPMvs4lDuDetKybSrR44FAULMV9/r3Pl5nrs+YBO1BfsMz8IOjen2RMFZ6DtcCm5IHiZ0ZMZn70VFIiWucMfno/6w0ob4AiWIppvTP8/j56MJTG7ZWyUJKGWuy2tRWXb8/26u6fAiSvpqv5Q/nOxg9lfqPONrU3frBigOk/QmVX8dUs0fqZdlWfVZ0CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMMoROKH2maYuJpt1kvwNPBHrHLhp0+amPD9gdqjkZE=;
 b=BufL65u4309dqO3CSv3j6BPmQ8kUKctXvAsjYc9QfuenSBc2R1F1RFlV8RU4qwqbykw3rfQd5Ju3r7KdALu0EPX04Uu7UxRDIR2GPvu7kbE394Ecbg+Emo5iRL6b3yrEnx3u0+/tqu6KAZDynR0lDTLmrVpxwt5wKcyawGzHjWf28rbamT7KoJ9JNx9siso5cKLuTetMqSQEsB/KERCHOrLa+hbC1mBBgbngtuUynT0r45C8FTMGgHnzg0NfsmGPbirHmDk67oC27WjdaGpEvK6gBVGCcCP7JTZKrAipCIBszgS2UhsWnyqtFNRwRqnND9IaN9TkiJsU1caZVvhu6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMMoROKH2maYuJpt1kvwNPBHrHLhp0+amPD9gdqjkZE=;
 b=npwf0wNNcUS2W2rgdAQ1aA29pHJIxGwDIZmbRY8daYubiGR6lxq0liOp3Gdbk8d7JsV7B45EbvARFbZ5gtQGU7xc9W69yQDClR8x8Y4M19AMiNODYsHgzajcDql4+yXLDBGpTZYjWV3tTV4CV0pk5YcIHU4cr685X/oDJtMS9JY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB9218.eurprd04.prod.outlook.com (2603:10a6:102:221::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Wed, 5 Apr
 2023 12:18:51 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 12:18:51 +0000
Date:   Wed, 5 Apr 2023 15:18:48 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 4/5] Convert netdevsim driver to use
 ndo_hwtstamp_get/set for hw timestamp requests
Message-ID: <20230405121848.yojvkbms4cvfriec@skbuf>
References: <20230405063330.36287-1-glipus@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405063330.36287-1-glipus@gmail.com>
X-ClientProxiedBy: FR0P281CA0174.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB9218:EE_
X-MS-Office365-Filtering-Correlation-Id: 4768fae6-5f50-4fff-e691-08db35cfeaa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLikiDQT1kr+Q9e3NquEha2wlDkRoS4A+C4xXYBciY6W20iu0dLQvMNMCB7nx0Dwyb8gVyqNdZgkTh6Aftktp2JJy5a+t6lJfLPhGCTeKp7D3Pf6mgZ+6z1JcWz7b5vhjFo96+xBXxdHMLeg6jVFF0ikvn4r9ar9ZvJUcYDE/xFn7Y5NTnP56gJF2EezZB5fWiP+lE88OA2KmGUWTPoendf3fTTcGu2hydR/Po2m4rzD+Ln/b1+vZg4AC6/amXLxy0fik1aseTBWjcgd6ux6JSwUGiOzd8ePKyuzh4UsBi3wo0LqpOIWMJ0MXgZ9JMzwzFocQrXBZzMyaQohUHf9O7ENvvp6nagscDnffplIb1DOOoctU2891xGpQGF8dTt35t9aijgMtx3rJLxYft9joxhQjZFn2wX0qgocwSWQj0GqOcFky/orttD1KIUs7kd3MYh1TddB1gx8UpcXQWVAOdk2h8HJB7rnWNEVusABC+YgUwMpihru1Sm+9H5DCfKDQ3IJMAWf78G7+o5btIBxiNF7GpC2pyOaeP/adc9Y/Uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199021)(83380400001)(6486002)(966005)(6506007)(9686003)(478600001)(316002)(26005)(6666004)(1076003)(186003)(6512007)(4744005)(44832011)(38100700002)(5660300002)(4326008)(2906002)(6916009)(41300700001)(66476007)(8676002)(33716001)(86362001)(8936002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JPbSZVE2kAT62Yv6YPP6JWI6DeVHdmK2z1Af8T7M8Up8SnLJ0660xu6cH79g?=
 =?us-ascii?Q?3fzdsatxGPbgLk+qOJty7AL3UiRFdJxTjVwmh1lB7y/hRpSbe2UEUr8JZ6bm?=
 =?us-ascii?Q?PgCkhu0bEcMnpzi5XHsx8W64T2kFsP+hS/mkREziMLH9sV6oZEhMfGWeDMsc?=
 =?us-ascii?Q?IniQ8sYHApHKamnbzhjaA8FkdQBcZtdzUB7lYD3c4W8kth5IHbGHYOr7dv9S?=
 =?us-ascii?Q?LXwpl2VGDuH4Jr8NhdlGWN1T7//Sjd5kv6AvXDYZgaaqlMQtXiL18GfQ34MT?=
 =?us-ascii?Q?Qvu5Xi7FUW4g3OSelWc1rVQxDQIvQ3Ahmb4fkhfIUBMy0GQXOSn+z96SP/bZ?=
 =?us-ascii?Q?/vO80ESBuGNO8uPHG6+BerohDqdB3+8csBu71PvKMkvqw1FRdaC6emXF6pCM?=
 =?us-ascii?Q?UDmiCjpGUidWFTUJXdzzUXK7eSXtQtbpkm0NEsrF/JJUWrLBybRp1OfVuY6m?=
 =?us-ascii?Q?n/sdSV8wQ7bpL4BybflXkfpT3gYaVLuoLLsnZrTM1gvEo9t38Fqmu0SUZIrl?=
 =?us-ascii?Q?pF8HH/E6GGoPIPgTan4QYVNe33Sr2JeWLHQVjg3MSAi0+1aGY1Kbn5o8W5hn?=
 =?us-ascii?Q?mlUCkvyWILcOUzEt9Q/hGyJUi5dbCjbAtK0lMWDH9xzHfAP3qYBUig8EzZoJ?=
 =?us-ascii?Q?1+yRKcZSlERPK/yCsYgiovD4RGtqFED0bMTjxDnx5QABedcSswr2JyZsblRz?=
 =?us-ascii?Q?OsznIO4HnRWXi7NixJITTsouqY28VBRMmKkvCObbicoULoD53Dkk6qhV8tVZ?=
 =?us-ascii?Q?F92lz5IyK0in31SBnDb4UPA443G8m2/whiQsPVydEZ9CxUrjI/aU6C13PdlZ?=
 =?us-ascii?Q?O5O6ZCeDc+JUJoOTX12lYAdOQCUHYjqmmHLKEv9ib2SQdr8yGXpCGViYSRrK?=
 =?us-ascii?Q?3WMM2WcuGehAf4W1RQTiAL+rxLEFt44wsuDwaH1Ejmm3gdOWmMXzSN8AbWtj?=
 =?us-ascii?Q?3M8qPkCnDLlTTy6Zdn6RZ1Xl228JBIzZLuxw7IOEA/z9oDCtQsPSgWt2SW+u?=
 =?us-ascii?Q?5AaMviMRYAmmPK20o4zFX1DgMFJwnfLZxj6UAoDSj1HhF2SYDoXTOtYJfOHB?=
 =?us-ascii?Q?2iLkJSXlILgVaLkCy0b4IH1Yt/9/sewfNkwfFeegWw5AxCdVVqqc/HjlhjV5?=
 =?us-ascii?Q?qG6Osj6EgMIRhtGm7H6Q6DTmvf7NBqTOxfxFq2yrn80ldLfSqlLU7MaNS7Ao?=
 =?us-ascii?Q?vkMeB0LFOwtpUxFIfVeE5Wckb+rEpDatOaATjoDyr1RJd3yxddXyw6Kv0UOh?=
 =?us-ascii?Q?Tip9NOPoY1WxKvv54J/uM9Jd33L/moWV0gpwMQr8BknOhBVlxdrc7maSInaR?=
 =?us-ascii?Q?u6ndIKR0njhwhmXOFNLkMOr4mRdfjrMNXIndmtdEVoDsQNug/Jk7oteLEP1Z?=
 =?us-ascii?Q?JF/qfwIxn78kYUpzscsnl7ntXklILR/zslcWwHvxRvf36FkwI4RNuTyJYP4e?=
 =?us-ascii?Q?i2juL9RAguC1D4J40S0yzWz2m1iMxLsPeXWnpriOAJrFrbz06QADdhCopcgO?=
 =?us-ascii?Q?J2hJDCscq32BJPNdX9R3PmN/PSs5lZTGZqNQW7WwXX4ctOs64hYNyt7uQyqA?=
 =?us-ascii?Q?rSEDTl+ILjHFZFiT6GnwhgFzOxXOX28WAXmliSaD6p+eKy1ZQN1T3lMKUVmn?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4768fae6-5f50-4fff-e691-08db35cfeaa0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 12:18:51.5783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVnocQctljiGM0tWXDK58k8RaeiougAxXLTK5MbuPKTaA/FQpPCagF0+OHzslX/HBvLdLuhYuhwpOpYJQSGsBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9218
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 12:33:30AM -0600, Maxim Georgiev wrote:
> Changing netdevsim driver to use the newly introduced ndo_hwtstamp_get/set
> callback functions instead of implementing full-blown SIOCGHWTSTAMP/
> SIOCSHWTSTAMP IOCTLs handling logic.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Maxim Georgiev <glipus@gmail.com>
> ---

The commit message describes a conversion, but this isn't a conversion,
it's new functionality (which to my eyes is also incomplete).

Also, what happened to:

| I'd vote to split netdevsim out, and it needs a selftest which
| exercises it under tools/testing/selftests/drivers/net/netdevsim/
| to get merged...

https://lore.kernel.org/netdev/20230403141918.3257a195@kernel.org/
