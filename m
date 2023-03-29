Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7F546CEC12
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjC2Orw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjC2Ore (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:47:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2104.outbound.protection.outlook.com [40.107.237.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1BE619F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:46:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpr4b8DNz1TjxyNPV6B0cxsXuFgsiYpy3hnbOA6l7kqCljo6+pxKAYbAP/7CKPyywXZTfgEEsfF5X2pVw0Af4TjA+hMNq+Ds+lcdwyOUf1MaRj0TKR+/diwSlPr8T9L/eI9pJi3GaIwlNeziKTI13HEWoIkM8vXGpFg0Z/lsy33H3nIY3c9bUqo91Qs/syqxHP13o7Qra19H7UJ5BIQB0fe4HQyweDMq5srs9W3e2Dvvv+cGnubKrgUh7elJEMHVarfxt8+5QtVAmvF0JP+yx6VRLouMjKY0fv6/tNqWWOs9H0J4weSpu47nDh2Riv1aUQS7Oy/+igQFsk06uui2IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmfQOceEffqcrqaYJEOtoddyaTGzSYMqkCj6H/a/9SI=;
 b=k2NKc1YMH5WslsBZF+nNhmzaVYBHzYgUWNW42RQ3shYawZq1S2gBAwIhhWCoQjoFF0/AGNxebBqOC87+PcdzYI47jmG5Sjg5pAJWZRdKsG4EaaHleXxUV72/DilkWZQsi/1ZZMok5ZyMOV80MbMQ7So/hiprBg+gFb4MMlOzZUAa/PZXKuEn/hJ+/5rZMq2qcWreuLH1eqsvhed9O1L3YZyDz1T3KwWtdXiGQvGTVtQkGPcGrGXOaGN3iT2PncvVNjYbHixt1kBuPascO1hOQeSxsVWfdsH3dnFOUvPcckVNnkPXO/a+z0GIHCgWMQYMMCmShVgBJ8oBgK6G1wv+Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmfQOceEffqcrqaYJEOtoddyaTGzSYMqkCj6H/a/9SI=;
 b=p5PcIdOMvp2JS7FdmZ7ttj+mnE5XTfAeY1oeenJ6/nQHzBPAhIVc5ODUIU5GBTNo2xchuK0+1OBFkjnt8OitzNzDgIdc2pTht/462yH1hxx7S2dNNmsYIc1k5Ro9aiJnhUGobn/tntBCHmA7Tr3lW15p0RDkB/1LoXRt9SuaS5U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA1PR13MB5588.namprd13.prod.outlook.com (2603:10b6:806:233::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 14:46:12 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80b4:733:367f:7e84]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80b4:733:367f:7e84%6]) with mapi id 15.20.6222.029; Wed, 29 Mar 2023
 14:46:12 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: [PATCH net-next 0/2] Small series of enhancements
Date:   Wed, 29 Mar 2023 16:45:46 +0200
Message-Id: <20230329144548.66708-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::11)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA1PR13MB5588:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e9c8acc-63d7-46ea-e027-08db306456b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cfi3oWm54fBDMj/JNfAzCfFrhQUyNhU3cWGMKKlQWJ7Ufsf6rxPOfXHFlcl/P50+qqrvAJWLbBbSdZIwJi7l14rIfngQJ7kopThJ4nRu6CYCkXQ4SsrjCO7hoICHECu08aJdfcnL2D/I0b/u1r9dit9SB2a46y6xcaRPHhJNDf9UoVWQo9V2gU1cKnQAOdcVVufEeoOTI6TovFJsX3qezED+COkxf+xd3Eyyaky7gPWyJqe2NwA6m8LTcQCJ5Fr3GSy3voaEGuEVGXtkp7Oa4t6aXAk87o1Kvt8UDfIQQ31sP5/4jOSSOYF8cKTEUiSWHdvPy9y1V+PKeFeaRuCHZuFP641oaY6fqvOM0ZaCFIQibDfg811L/uPw8YUcET/RzDcPbTBtIIvRakmEiGq/FlqJp/ZDJIfPe4fT/hHqWxk+wUEqr6yZ8qz9flwekL8icTGrJrqAPl5TqwPcLbPIqPp2rk2Nj1rDLsCwu7x987WobUHJ4wD5JYLYcjsdieA98l63B4nZEoSusFji2FmLw1RmQsEX7Uagh6bmI8gs8ErLbQlwLAovl7/ybocOt9d5B18y6HZgxGoPtmLFaL5cFGECwZDFetkEQtbxeetEmZv4c8nMm2B+BGh/5UqP2tPi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39840400004)(396003)(346002)(376002)(451199021)(6512007)(26005)(41300700001)(6506007)(1076003)(6666004)(107886003)(186003)(6486002)(52116002)(83380400001)(2616005)(478600001)(54906003)(110136005)(316002)(4326008)(38350700002)(44832011)(66476007)(38100700002)(4744005)(66556008)(2906002)(8676002)(66946007)(86362001)(36756003)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cxKOYYE+x/REYHPSL4XQmHFI+XL5OcVJWlaewqWLPYeGacIHUQQ9BeKl3d/l?=
 =?us-ascii?Q?aRBpwf8Pnk5Zx2a+s+fOyRzgfUM6pcA0k1tFiHHl+JGv2okTsV3LJH6iByva?=
 =?us-ascii?Q?Y4JSXwGBxxPUAT1CkL7IEnhXx6cA0ijjWeAJRj6s7ZP5HGTgSNQ1DLlbnaD2?=
 =?us-ascii?Q?38sFaFdV4zhUS8CcQ8RiOE0RfuG9pDcT2nwAQQCuitznp6FoHdNpfxM+guiD?=
 =?us-ascii?Q?4LCpfOGjqskEPtuIEsv8Hh7OnsbZIar2PjQ4XdQVmnaNlIU8GsX6QvjnCCZg?=
 =?us-ascii?Q?jRm8EqV6sbqmppefvANURmM/zC5UDbejsZsjY2UO3+MvcYMJjquoTZux3E5O?=
 =?us-ascii?Q?03b4/gOkFs2AHD4X+kdtLRDTfTdClwBGobivn2CuEgDUiybIsB0/3+7zEujt?=
 =?us-ascii?Q?xwpJ2lRgMDPl1EpBVuPxvRgzMbE+hddNCDVvZOvdLzVraO4U82b3vAwKoh1C?=
 =?us-ascii?Q?U7gtYrjJCtBWrw/ApKA/3P1IFAbRFtIzWrLd+UXcbd8Ya7y0X8+3rdbi15Rk?=
 =?us-ascii?Q?ld8cGtyiGiTEeSZBXyCRFhYpl5JjFkc+SKjpGX8LZ9rls245tlMyxG9N5wHV?=
 =?us-ascii?Q?hEl30z442aOamw2qlgtm+crrazW0obWeA7dfafLDmCqewXpFcyJStWlq3bEr?=
 =?us-ascii?Q?FSuRcTKFRd24dlOzEyx5gJgHVUC0gZmaJr2NvJEwy5fhTvuGhY/s3S31xV5N?=
 =?us-ascii?Q?oW/T2Wt724l/hWeyyW98/rXHsOsNX1nTrTA10hK9eSA1LduPWPFJ0aN+Az8b?=
 =?us-ascii?Q?pnrNJc2tgpZQ2ckzsnoez6tTZVkvu+7bnyLggyVEwdefedqHtaCoNnV2FvGO?=
 =?us-ascii?Q?zpko80xPtNl9XJQCSFqLmNyqnSCWBruwJNkUy0/x2BM7g0DErE5ACXPKo3bw?=
 =?us-ascii?Q?GDM5fLO3wGQhQUFYmBcbv7HwnwU7sQJb5TRAzSA1q5QvGbGjAH4fB9C2Aw0r?=
 =?us-ascii?Q?exOh8XdEUV7JhX+KhloPYxc9iVFOd4b+KGXzO6v2GB7Fzazg8pEK4WHWbTaw?=
 =?us-ascii?Q?FL4XBX0nuDEuUhC+pKg8cOM22f0Omh0gpMZbRMPmRiydvTJi3SskPsLmjmEH?=
 =?us-ascii?Q?2ytlzlSvgHMzRhbxNZhDhKCT7YUOUsioYEP+rhaOmPmvaZEQGPNclqy+iszb?=
 =?us-ascii?Q?jAt7ZbZaW4O0jRmP76zDH8sf92sjvWdF2lsTxz6cuZ9OX+HeQqKWEJY7maZq?=
 =?us-ascii?Q?60jJti9jE0lbYMzuF8bRnKgqr442Tis4NdqpX6B6u5bihaKPw2oHDuz48K6M?=
 =?us-ascii?Q?SRXL6gNSEArMRBjhiz+5lmNCziIBnhlFRhKbajuIwARhlohvGl7YAQVRDYHE?=
 =?us-ascii?Q?tidZnkH1TSib/E5s2yaTt3TNFY1Pkx0KWK+kQ6k7JBQOphwL5zrKf+xHvs26?=
 =?us-ascii?Q?KUqvi3lNODJprP2yjMrQUwXdRb/3tCVSoJIESQMGCIaYQ9nxV5DAqCptQuLJ?=
 =?us-ascii?Q?HE+kDfm4UN1PGGh02CEKFJHF3xXCEezeK9+008j4lwwWh/WBVolTSEOgEy7w?=
 =?us-ascii?Q?Rbf3hA0ZvpwOKDrXlGsTaMVjZ8f4n8rZdPD3IsMMoNvHErH+XE8Dx47yaaFZ?=
 =?us-ascii?Q?uWNroME5hz3sCHpz71PuaMD/ScqlTya0HjxZ7yv5j8+sU3MAtAvE7lERQlit?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9c8acc-63d7-46ea-e027-08db306456b8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 14:46:11.9322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOXLnsdE6pRz8wB66nLMxs5Y/fgvegyHPcOcfuc5U80Cm2mIo4SE8z/u6hpznhXJT6bsFCRavnVPYdwMYNQFegWyyPqCJvpx+PC0ITck0tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5588
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series adds two changes

- The first is a simple update to make sure the dev_port id is getting
  populated properly.
- The second changes the lower link state of the phy ports to be
  disconnected from the admin state. This is mostly for SRIOV cases, as
  explained in the patch. Functionality to make this behaviour
  configurable is added through an ethtool private flag.

Yinjun Zhang (2):
  nfp: initialize netdev's dev_port with correct id
  nfp: separate the port's upper state with lower phy state

 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 103 ++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_port.c |   1 +
 drivers/net/ethernet/netronome/nfp/nic/main.c |  20 ++++
 3 files changed, 124 insertions(+)

-- 
2.34.1

