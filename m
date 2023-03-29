Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C7E6CEC13
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 16:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjC2Orz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 10:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjC2Orm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 10:47:42 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2134.outbound.protection.outlook.com [40.107.101.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBD56EA9
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 07:46:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SE7rU9mhcxq4PIgH4ScVJzYJDFF+xO0YkiBtBv9BGjpf8Ht/sfbQHZkegPBqhN7EepEHnugLWdaJLp922x15R3w0lymujaparXzngU5X7DIKVCIO2tfZ60/hXOP4YE1KUh/P8akoDcMS5UGE8JXEei7Chs0JfN0SMNhO6Nl1/G/0l8mgGbR74vn6iEUrisJYA5dqUV43kf4DQbpJhjj1mB/2aUbpkJz/ahDzcmUt2/m/sdl5yGgcI2HQ1pXwvGlBCLmRCdBcCOh1FhgNT7A2h4xw7W123YfgK9bMPeyaXV43meeB9g+lgytQ65EdakU6Utg+PlPY8ncH7LWNLBfcGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFd8W8beTFTrBJEZrIX4f3SzqqcMTx3x7OwM2itVAEI=;
 b=gkue1F5vzz389FIuSR+bI1gNr52uNp+p/GsyJns6ZW95tFaYFr5eagZt0WyH1mnUIuAJF2PPFF8rf7BtmxsTqXhAev9d4NggXAlNmhikMFJgr/QwsWzL9AK8cK/dym8XZot6XYQgUOL4e9kjcQk9zctBO+VhB3T7PaOVlgcOi88AKDZ8WURSTBDN8bCWUxCJA7ykgxB/KU4rXhJRCz/TIOMDcxepWk0UN59T1D7RXKKQcznSg1ju3INgGoQXr3iPvMpmngNij32tbMxtk37udn4U6tF0g02iC9l654DZWzQYs1s9L16kr1J96mZO2NcdVSGUV0W2NKWD0gNas3J/bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFd8W8beTFTrBJEZrIX4f3SzqqcMTx3x7OwM2itVAEI=;
 b=SoHhUSU4IiKs2WGmrBpWW1dVWB12U2xhVqAJGJhDN+d2c0aWVveQzmcW1vPyrmG+4cpNRoMPW7HCIZkETWgxKjIFSBF5vWUpM3E60/IzP8edBwH5M36Fq+LsDoMQjm0QDbisG4JRD0vxgLzojGNK78OLDTKRcM366hyitmI5LTE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 SA1PR13MB5588.namprd13.prod.outlook.com (2603:10b6:806:233::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 14:46:17 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80b4:733:367f:7e84]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80b4:733:367f:7e84%6]) with mapi id 15.20.6222.029; Wed, 29 Mar 2023
 14:46:17 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with correct id
Date:   Wed, 29 Mar 2023 16:45:47 +0200
Message-Id: <20230329144548.66708-2-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230329144548.66708-1-louis.peens@corigine.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNAP275CA0048.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::11)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|SA1PR13MB5588:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d9af36-5061-47f6-f73f-08db30645a2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqZga8RQPYzpDURXILJnCMlY33b56h8BOp83JnYiLPNshs2YXHP4qp7Jzl43o/A4zNZc7CwjX5t79nlBTVtUpgjS1jaoAMnZXUpdZuZDZC7iX98DyhjXzUvjtjtCASryWP8B+IYNPQLrmVntxTGnjKp60MecZ7XnXJ+0c5tinVCBVtccmIFWZMW3x6CO8et8dNtLa0z0XNl4BEkV0REg6kh48KafwYRw9olEQTrqPn3VTzM1ATXriMdd/EJnIA+h2hS8+QZdMfZXFAhDBhvF+Sx9cbMKchDtw3enRXtWEBsItZ1o10rLhwO/TTyBm6u5rjbrH4aB7rrhn98LWAxwzPIzmqjquDxTVqzJEcFPAKQLJ2jfXps2rmCgSlzII12W2q39d1DNUdp6kHr6UG6CBTPGGm+jwT29Y0fPxkfuKsd7DXRPFPo/lhyroVXeCZdyQUz1U0IvPxjqSw/c9iVjoitHrbZIal2Sp6JPOXhVLJS5+SBPQRZmKuQNIrfWD+TYSZNNTvwOxeuLea1FkPa8m7XPnBZvTV6oo8IBOSWHu0WhbQPTVgkrYQMUbup3+Sc+1jnSDtzBC10dNCVdT2/e0IkbPVBV5TZOL9iXFqCOteF4X+OrHzDsSJYj9Flvj/W5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39840400004)(396003)(346002)(376002)(451199021)(6512007)(26005)(41300700001)(6506007)(1076003)(6666004)(107886003)(186003)(6486002)(52116002)(2616005)(478600001)(54906003)(110136005)(316002)(4326008)(38350700002)(44832011)(66476007)(38100700002)(66556008)(2906002)(8676002)(66946007)(86362001)(36756003)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AYBgeA7n904XxM/NREUGS6w92RNkRyxn79aM+780qXhtAB6dQoerIFyTVfXT?=
 =?us-ascii?Q?kI48nHTShwF8LNpDIrXqYvyy6W72O9Ovpoidj0RdiBDewCDYbmGM1fLpv083?=
 =?us-ascii?Q?YWTlNUeXNAwddMyCh8ifdk4W5vJKobUxCZ/Ft7RCfZlp6INRv3BJ6Wg29TFD?=
 =?us-ascii?Q?ugdAddrG6eEdqTBO5tgJZ30/JaIJl1I+769OmB7Zd93N/+uEFAWrh25SFQ0X?=
 =?us-ascii?Q?bwj7p/a5X3jVcT44TpZIJ7YeOLChhX+9UKGiTp1eMRhhE2aYX9kek99G9rBG?=
 =?us-ascii?Q?KGQhv7Af3pHVC05LNo7wWQJk35NT+V+NeveqxqQ6FXRl3jRPuuTlHQOYSOkX?=
 =?us-ascii?Q?5hqXyXUa5oJAGKWSZzX0Zqv6miW02KJPOhx41+sxfnmVh88F41UKRjvD4R7L?=
 =?us-ascii?Q?f1DWnjIFtGIxkt/qlYaIab+vL1iaoQgx2Dzrv9/LAlYolZ/P1KBltdYODMSr?=
 =?us-ascii?Q?mIOETveuH3a3J2s0qCVY5VfgqGs089MitjaJhHv5rpIUsCKe1HOmOMr02vKi?=
 =?us-ascii?Q?FNd52CRtRtKxIXIfuKw9fUiPD2zI6oTe39P4GJDb3NtwaruY6brsVg2rDbVj?=
 =?us-ascii?Q?ucK0OpDDbs3fvaFqDHAYfGnSrfkwuuyH9bp6Dn9OGnX+JHs4pAbmNm5yVWGe?=
 =?us-ascii?Q?+3jtV1AG4jiwh3Wfs7GFXDA8XbQ/PpWHkD2gRswmtkIFXguG0xE550a9ujZM?=
 =?us-ascii?Q?uHpaG41sYtXDd1phfzZtvth6qriR7nCutVOFVvY5cM1Em+pyrRNhOvcSo4ok?=
 =?us-ascii?Q?0EeUbbpLrCxGLue6p08iLKrHoVfWvTIiLc8CiDtc8BCe5rcoDM7hzIVNnB4N?=
 =?us-ascii?Q?9HoqnaIzPJU7aPnRCGhkNzlMGuOTKbcPy1NcfyxlI/E0GbUaDwSFxnrAHavl?=
 =?us-ascii?Q?dXaTXxQlCgMNH6NpQxNMC6BvnG/+l0rewfpdvMoeVZUy4OvSy2SrGLfAzNOB?=
 =?us-ascii?Q?6odbI8Oo5ko5qw8jYCP4iBUeOin17s+vL7keQYqyi+8T9nK6D7EpyDCd3PfI?=
 =?us-ascii?Q?QS0ihc9rNMun8OY7i6Ejdhphv7Fs/I8wAU65nxsekeKfvZRrSGgxIP92WKrU?=
 =?us-ascii?Q?RaspiC/alyS81dMyFvxaXvYRolFd/bl8zKlY+wz/J6ZjD839Pt8tMkyFa17K?=
 =?us-ascii?Q?efJI15beeynUFnLFclKtSQE21QVkVVW5Kt+n4p6J0Av8weTWG0bVzEKwAcxC?=
 =?us-ascii?Q?bs84XwOGMDWd2FiUX6hH1xsVZbBiPTHvBbPiO5+Keq1P7ANM7cxPSTrDpD9O?=
 =?us-ascii?Q?IhpnBv6nmd8FuWcK8/SUE3AMNtPmTqb4M6dzh/RrnbHyIeHLkpXUKordyMPd?=
 =?us-ascii?Q?EHJkSREV4CiBH5YsjpK4tDmv4l1dTBuIg4zJJQX1QAn7kK5fMSHhZokbASG5?=
 =?us-ascii?Q?jG233bQQjTnYRNnktaM1IKUx9s5jSw4yj4IbYBBV5fULs0xaFF3gaWlpnmnI?=
 =?us-ascii?Q?XRIVHJ5sqLT7mJkOfDb/SmtZP9hGwqwpQfYvxWMMROWvoWcgWDH6u2/IVX3M?=
 =?us-ascii?Q?NCkdh6BCELNDkOH0bXG0nHz89uaZ8Vw4BC1cK1GupgfL355IQVRr9UvYnZzp?=
 =?us-ascii?Q?1A0ewcyr3/kASYtkGYiDlRExu3nL2mlmBTJnDgL/2wllUOzJjWxPaTr9zxeh?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d9af36-5061-47f6-f73f-08db30645a2a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 14:46:17.2096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmOSz6dTAGOlCSAHHD0F7Rx+uMnudKys15PTIuOcWIW+4nWE77/54vC8tWdQ8cOBg/H0O1QEvZs3c897ihld2YkO42Lhgct58gT3L197jeE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5588
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

`dev_port` is used to differentiate devices that share the same
function, which is the case in most of NFP NICs.

In some customized scenario, `dev_port` is used to rename netdev
instead of `phys_port_name`, which requires to initialize it
correctly to get expected netdev name.

Example rules using `dev_port`:

  SUBSYSTEM=="net", ACTION=="add", KERNELS=="0000:e1:00.0", ATTR{dev_port}=="0", NAME:="ens8np0"
  SUBSYSTEM=="net", ACTION=="add", KERNELS=="0000:e1:00.0", ATTR{dev_port}=="1", NAME:="ens8np1"

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 4f2308570dcf..54640bcb70fb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -189,6 +189,7 @@ int nfp_port_init_phy_port(struct nfp_pf *pf, struct nfp_app *app,
 
 	port->eth_port = &pf->eth_tbl->ports[id];
 	port->eth_id = pf->eth_tbl->ports[id].index;
+	port->netdev->dev_port = id;
 	if (pf->mac_stats_mem)
 		port->eth_stats =
 			pf->mac_stats_mem + port->eth_id * NFP_MAC_STATS_SIZE;
-- 
2.34.1

