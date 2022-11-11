Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4FB62632E
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 21:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbiKKUto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 15:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiKKUtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 15:49:41 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2103.outbound.protection.outlook.com [40.107.244.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1012A845F4;
        Fri, 11 Nov 2022 12:49:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgB4Nnp5VM1JfUPKfPP+CwVAYAgZ/fpmQYhpOjrnqQ98zmwV3zX+TsFWTQUqSyq/GCr2BNlzl1/jxi2Vf8OMyn8glLesqfVurtD2e40K6lJ0RGCI5/FqTbBQEmDu0cD/j6bt0aNoOmqbrbRJUegttJjD4w/LrxxjwNt5rG2I+aKzf8qu9lQfTx04UIeBqx/YrixVEa2Vu0rlcyAnAydQ5o5xuVroSERrQcP56qcPZuimK7C+8VmePl0NJxPaR72JbrI6ldWBjCcYhlHxrgEMgFlbQjLGQ2djIrx1gjmAaOagAqxmfJ3le+QkzZ9iIYtDP5Z9xxV/CEn5bQpBAnvBvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZUoz2YplCCLX7QgBLOJKzHfSbrknzGqbMKkbXMx+V0=;
 b=jwoZ6WGtJE9JKSpeownKrdbo/EdDm9mNfmX8wtrC4LLpVrZoZCNZwfPLU8H+mh9pkFqOqzsncEnFHys89jSKQN22ICMwbqXlPY0q5jxRUFSw1EU/ljYD2dn1tldny2Fop46b/jjWivjQ2nvkDf/eXvTUX3cW36aNhx2F0F0ueVHWHVtvjrooRmYYChTANF25g3y88gq2nP1KWwMAJHkEsKXNw2KAoC5O3sy2i/gcFnOcO8+OWb/Gnmw13tEpx3ooaJlzN3xa+Ey5sF2EGxyB85Qp6nqXaNlyC2IYUqV2vEuPlk2QpoeMg3CsVsrN7tCLNxaKA4wX4C+JmIFqX1UaqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZUoz2YplCCLX7QgBLOJKzHfSbrknzGqbMKkbXMx+V0=;
 b=W6kbJcdTzblBFHM/AbyTOiQ3wgXkStGW6BU4fqTomzT00YkdeGVvpsc9qxy4oemOKiU3buB0M7YtyeSAijEcA7OylV2X7PzDoEizdd0vhZNW67CdschdoaaKFSX3JY6LQM6d2Xjb6nT8yL52xX4s3J3c1c5EqsEtsjNpJ9GRMJY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4588.namprd10.prod.outlook.com
 (2603:10b6:806:f8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 20:49:38 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5791.027; Fri, 11 Nov 2022
 20:49:38 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 0/2] cleanup ocelot_stats exposure
Date:   Fri, 11 Nov 2022 12:49:22 -0800
Message-Id: <20221111204924.1442282-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: bca842f0-bb07-43c7-5a5a-08dac4263f92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: huO/7GXMsmynIWV3Rh5wgtOhhFY1sIvvDJlMCIElIBkNJReLrQFx1ebfSYwnI5DgEUjZYxGn2SEeUlPf2AAt94uGZy49NyhQHMNSAOSZ5Ly0bUwp4gtbqRQ3lsrLCy0v2JzSjl6GZvBlI2yt+zPd1jv9Li+dYCMCFmwcAeIq5GaG2azby6ZOgVTm0e+zu0szK9ewo2lu9PZG39014AUGD0KXiZRO4fXVzf/0yUU1eiMCQAFmcCE7k52ZAfScHiLTHue3L+RS6vufzIevjKXSNUtxBnltyGUU3IZ3WrOuIpzSoTYbyRoPsoc7oWkiEsPOM1AAUTRsgtftTw0fWlycU/QiNtDL9wZA4waGWUIr1xstFYiTyAy4N4Vsr8hrKUi/lXSpWxCRemcz0x2EnHLnMj9i8oRAJhyX1SaN3Gc50+t+Zfn/c8RXiZUvfQZqZUkX9MdMJLFxr7GjxfoqX22rqW/i6wu2e274tisWJfiiajwyr8WQy7LnX6aV7BmQDs2O+WRVmE/CFhnFuplrcrCbOmTbfA9GnrQn95CVG7zYypXX4b9CQ7H8WvYnHwEMjf0MUw0gOAdyLNnTkWEKVJT6GScpuy0LSy7Kt54WX1vm/bd9dOajqwiwKOAYC5z6PaoZdkSWtpd6IMO3ljb/vGHECdT5AIi2Je4wdPOvPW8axNl7jGMkeiWDB8A5wFsee17NnYmQrvI/oi77rW1i2bvQg/vVH6Vkn1F5SVzizr3XbUDul0wPwkQl6vYlPC0nQU30
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(376002)(366004)(136003)(346002)(451199015)(54906003)(6666004)(86362001)(6512007)(26005)(36756003)(2616005)(4326008)(66476007)(1076003)(5660300002)(66946007)(186003)(66556008)(41300700001)(7416002)(8676002)(2906002)(83380400001)(316002)(44832011)(8936002)(6506007)(52116002)(38350700002)(38100700002)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZpShppgjFJRGL582RSR7yUpt2az0mjrZTmJUp0OKF7HVBpgwS2A2v9QU1yPi?=
 =?us-ascii?Q?Mlee5uiFomDjqSulpF+4VfXpr0HpC7WjY6kZy7Ke1NLK9z8H4JKUJVTPEMv4?=
 =?us-ascii?Q?CAfnDqB8P1f2Qw2RxO6+X3nFikwy9W+QucQS0Ss6tTHU6DmmUuKljW2fasJW?=
 =?us-ascii?Q?+VPCF8tYLVwZvwVp27Mzb9ZtRF0J9j3a96pUfk74ew/hc3y/awYTBOn6Ooql?=
 =?us-ascii?Q?e/c+IDjjlpbNiXKcR/XXvWKx8tN3KVhO7G5hOF0okBgHy4xlCvhvbdH0Aym3?=
 =?us-ascii?Q?niPT0q3Bnos/Jg/FVbjQbY7csj4MOhMs6G9mWrzZXA6MMWm/j3pIbrCMoqUk?=
 =?us-ascii?Q?hxl9MczUFbn6RX93mbgw1wxv1r1HI9b3sZH2PcfqI9OGv+99dGn1yOwwmrRR?=
 =?us-ascii?Q?uhOTi9jPdEJ2RnLR9mD6kVhZNpsmYV9aqIDgSFOrWXQB19XIqWjAK+6xDflk?=
 =?us-ascii?Q?sduoxDjZDMJ/Mkx//gJ0V7HcHHh7XapL99Db42njK+xjaDtagSKzf0Gmf6bk?=
 =?us-ascii?Q?fxBMhEZPUewHCCZVwBtmomnUz4D68vEy0nnU7lF54CihlF5ezsBFmDx0aAWk?=
 =?us-ascii?Q?FMWABnXgAmJW8Xln0HF4fAflEdsOeGSBPLl666jZeuymqfDxwNiruGS7mWo5?=
 =?us-ascii?Q?0FrIz7SqTwt90taD/x8gMZclpiJD4anAcFiRB/vKXJLzB3X6CKDuE2cHd13u?=
 =?us-ascii?Q?OppFBPyyzr0cm0z3sH7b+p/XZOpxR1H5FEkgEA6rANxu2UGj/4sR0ohchBCa?=
 =?us-ascii?Q?73gS8PHN1EbOkfX/lT3gp0q8esM8t+7+BiM/fgd4KU7S+N531qRQwQIGtBz5?=
 =?us-ascii?Q?JAJsryMzJS/8xwZJWhKqhRs/ijbNi41EFAMJnIfGKeK28TWhKi9n+THf9TLH?=
 =?us-ascii?Q?WQgh6gudS6AlRGgtnihUdn+UodbHi8g4hWN9uAGrTd5P0LlRlLcWYvhlhODu?=
 =?us-ascii?Q?sOThCJqLqjfN8NYeT+d1ZcF9p+ZT5AOKsyv98WcclsLXhwvVQZNiKl6EgOho?=
 =?us-ascii?Q?QzxWZ26g7Bms7xM9i5ojYllVvhTY579KN9rMdeD+6w3Zl0NL613dfpiJFap0?=
 =?us-ascii?Q?Wfdhzqmdb0jUB6DxdqeaMPmdKaB3oHAS1goc2rwXFrMeqCwyohr6GjZNYjCZ?=
 =?us-ascii?Q?o5RDIbQ95yzHCdhh//V/4okljmmtP26h2R2TIYP0V4WBjfPUvg7YpLvroCrC?=
 =?us-ascii?Q?E8XWZS/WtxjinUhUVUh68kiDf3b156pk/AGoFopc5wSonjqHPKwl0FjUOk0f?=
 =?us-ascii?Q?qL6Z5JsyUpS6adCFK9N45WZTj7w1Zr6BN3LTuFEh/wk/jnyaQawNRVq6w5Bv?=
 =?us-ascii?Q?bgD2rwPvYWW/ibI5iKC5qk7BweMCN6iUiwVGd115KxeqTNXSvqPK1hvCotgN?=
 =?us-ascii?Q?KTYEWoi4x08KOO8SK+j2DyPgWn7cU6CHGBp4U+142cWivlbZ6mYKAvrPOA8m?=
 =?us-ascii?Q?2l8hpJ2frnMxgYHqEqRt2n/XLZ4FHnhODRT18HjDmA+RBD+HrT4Sn9NC79D1?=
 =?us-ascii?Q?nQwqvu5tIUAvu8fv+6Mli0MPspsyhTG2XUu4adJtp+1fOfzyjhmUWuyfy+Z6?=
 =?us-ascii?Q?1gU9v02F23Lfxb3xVSp69P4YJcoKvmKHE4hggaPq4NzjuT96En+S7U/FalM5?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bca842f0-bb07-43c7-5a5a-08dac4263f92
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 20:49:38.3672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: msL0CTB0EMryamr8wkjMfMstO1HUC4Klu2tBwr0D4MQS4aUpjJQbpST5HEf/+2ztRVc8Jiaj5cmEFjlWCxYYeekMac/WWQzmkb9SzucrC8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4588
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot_stats structures became redundant across all users. Replace
this redundancy with a static const struct. After doing this, several
definitions inside include/soc/mscc/ocelot.h no longer needed to be
shared. Patch 2 removes them.

Checkpatch throws an error for a complicated macro not in parentheses. I
understand the reason for OCELOT_COMMON_STATS was to allow expansion, but
interestingly this patch set is essentially reverting the ability for
expansion. I'm keeping the macro in this set, but am open to remove it,
since it doesn't _actually_ provide any immediate benefits anymore.

Colin Foster (2):
  net: mscc: ocelot: remove redundant stats_layout pointers
  net: mscc: ocelot: remove unnecessary exposure of stats structures

 drivers/net/dsa/ocelot/felix.c             |   1 -
 drivers/net/dsa/ocelot/felix.h             |   1 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   5 -
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   5 -
 drivers/net/ethernet/mscc/ocelot_stats.c   | 236 ++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   1 -
 include/soc/mscc/ocelot.h                  | 216 -------------------
 7 files changed, 228 insertions(+), 237 deletions(-)

-- 
2.25.1

