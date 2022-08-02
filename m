Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCC85879E6
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 11:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiHBJeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 05:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiHBJeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 05:34:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2110.outbound.protection.outlook.com [40.107.243.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19D23F33F
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 02:34:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSI+hygqJwMi15HG0g8ZWgbwKzNtdRWt0uWDbY79fowN658OXj/qdgvtrMz5HBiaObyxjYuE/nRdVRRGQHI3ypy465AxNVh8TrJA8u7JZ59NNIRdd8UOoifN0JyJwBLEtVGeTSq+ToIoDCqsAbYDo+On7v2sFgIVg64BvAxbITkrRiswCKqf7SY68RExzfTMhIwS+svw6MlYg59p1e7PUWzPOU1uu69sTcfuQAGBUwY6aa2/xltA+aifskSArfezA9M/qmSLyIgjWQ8Z75k2BfT5fwTDAlesMDPDhDyVzaE/ippYJlcKzktA0eNx4FR1cgGASPF31A4hKKpXhdMnnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QzKAK00rDym7IixJ8q5pdN94wmuHLbPb1iD16J+eN4=;
 b=Wqf1E9tQzvCaLZr+Yx3H384nwu2jzp0c6rV68f+sORmDlyhGZefVdYPTqAB24ttu12DjMa6Zsa0PU2eX3zkaeROo/xzy4l1qK1QdLZhgAo1pC51IVyiEIKEHMrTaY85dv3LVal9v/32YF+dcpwzMzPJHYOupVHENd3nL5hfiZgrGKmsX03zeZnVtf/+g5iA1T+FF+3If6D4UdjZp2Y7mhVLm5BreycBO0DO98mrnkq0K0j0Qv46AUghtvToI8HIrwrg0NpJ1B5niytrfYdpg8HiJ6Dp++mFz6SSQzHrfc6Fok4VC2eXWMsF7EV0usCm3+VHbzR8HvIEz5wTcSt4yyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QzKAK00rDym7IixJ8q5pdN94wmuHLbPb1iD16J+eN4=;
 b=F4fMdwO24o3Z5ECwnCx+6MHqsepV+jBYD8bx/4G0l9ZWypaHytDZeKXblUWrUJUbSVklLuIHpntVuYkX1lTg5Sq9rKhFwBrnnY3VLss2N3OrZbL7D70eG+Dg7bdhq2vJSe04bhAQ504p/7k9ptSR5TbznquveV2HUH0PphG/nnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN6PR1301MB2081.namprd13.prod.outlook.com (2603:10b6:405:34::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.12; Tue, 2 Aug
 2022 09:34:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5504.014; Tue, 2 Aug 2022
 09:34:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH v2 net] nfp: ethtool: fix the display error of `ethtool -m DEVNAME`
Date:   Tue,  2 Aug 2022 10:33:55 +0100
Message-Id: <20220802093355.69065-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0079.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d360106-af3b-45bc-2cd3-08da746a2728
X-MS-TrafficTypeDiagnostic: BN6PR1301MB2081:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OVU7N1jHadSc7rklML1ZRPHhz609cEeKNrlR3LDT1glCoxmjMmDSL+horgHUlnOf1LBq6CPo4FRhW7efEglxt+CnO29RLb4H4gWwT7v+fE1m0sWn8yAvJKSNZ4AJ95cis8OfMdy6KtBdmaeM8EEJJOVp1muBJrGhcSuKl6Tfhk2QdbiAHcUcD6L5tV2Z/GfYl+YFmStBDuX2GDb+4Zo/kGxQv7ulKT096G85wdFSHhc0o4MH2sCuNdXTcMMvAnus4eCH+XFJpTSgAD3qh65/UgC5a6fbhCITbH4iunC4UzANYjT4fZ6mSD6670hOOgrwVZ7UxMzf5M6HMuo2PuDuXM6eJRYJWKnfd2TdyA8u+nVfsdU9KMZ9phm/mEjJCnzJO/9ZhSUq/6U/C1W80xTckrhbKXhXVh3Bkd3NSOcg8STZKz5T0zQLm19SjqLXZSN0ePUoOIgaICGjtcFpB+0kGZJQj5mY2iZRdhiQE7oQMKZAsl1mx04QUXjyhWFOFcT/hgLh7lBEwMRT0Stm+dmaByXf4owzcvb7Br4DkUlYqnOjZ0PcuYqat6K6LlwZOR4BEYmyyDStucq0AWQhRcrwDqe8zACgq9gztNa1yu9pjLF3PVL3fkzQCdfOtfESiOWs7+OQ1ovQZeh5AqwhPyYG8P19LrfeR4t/fNQuGZKKSp3HBbnC+dcnwfF0hS84+BVJiYygmsmObbocxjSLsXAD97I496rl+eAEeBdIbKfIGPtEFQq7VZRCPqp6hjhGwiysl/gqWqfuc6OVHdv/0w0XP3fnnsbL4EQjRB5llO1oDRwdKqX4BWLcUXiEp46AhKdi0u8mIbrT4pZSQAMdy5mNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(376002)(346002)(39840400004)(26005)(6512007)(2616005)(36756003)(5660300002)(186003)(52116002)(38350700002)(44832011)(38100700002)(107886003)(1076003)(86362001)(6506007)(41300700001)(316002)(66476007)(6486002)(110136005)(66946007)(66556008)(4326008)(8676002)(6666004)(8936002)(2906002)(83380400001)(478600001)(81973001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7aBfB1No/iBSua13zbpJIMlCYy7DGiOlHk+gSCx0HDF28uFNyJpG+CFnsj20?=
 =?us-ascii?Q?zucPAwWmaEhHc3HDPB8QrWo2mZIeoStus2EUOHM9lFtsveWR19kGglJ7MVhE?=
 =?us-ascii?Q?wujsRiFPB98N0pmzL8Znpz1o2flm4QZgv1R1a7UfEDTv+KuoLk2XvCixOYwC?=
 =?us-ascii?Q?3Y95HTWFh+UD3dX7qyL9fHVAmaJlEP0/ZIOIRH2n0Z1ogrNi252iKKkdoTYz?=
 =?us-ascii?Q?aQPrS7uwHN4vE37+XcGDcxnv84bHru87x9oyQgpKLdFnr4ecqJxcCjtFuS25?=
 =?us-ascii?Q?9tBCPCW+RsKsDO2BgqnFYmDOcPwqp3vutSiIq7efLQRobJBEFnpJtozL6spi?=
 =?us-ascii?Q?+zonPvSc4VNehUA2YJ0nGbJGP4xedkR5z/CwS49O1t/GnUzqu8/J9Svrc6aY?=
 =?us-ascii?Q?KD9+E8sYUdO0zwMhGEOh5H89WGqZL1wtY2ZvzDPdFcPl7zKe9Ukb+qSs99sh?=
 =?us-ascii?Q?TVbK9aEbkj9WROshU6WdmTx8OWzwo0+agLb0Kbym5iQyJGlOJKnXJI08E9YK?=
 =?us-ascii?Q?dNh37NOHsDPQv+rfT99yie32GPIr2DbRT8xFGFycqK2drWo75FogTGR+BFPa?=
 =?us-ascii?Q?wOPKIY/1UveLmZ+QwtUAVIkcjqu9huyzJ+fY1en/uIt+yu6jUv1h7o/8jAQ7?=
 =?us-ascii?Q?u6wgx6ofRjZ4aqsK946CPsDcI3FIImBns5RR96wlpYqeulSCRBWq1Xr7SJre?=
 =?us-ascii?Q?2cI0mY0d40qkxnd5ry3wik9fM8ojkruiRdCxP9LlwDcfn+AqSYfQ8r9RiOiN?=
 =?us-ascii?Q?UAGykN7e9EfMPaDObtGmXnZ6Z2OFsWd/Q5x8A8pwDbK99JmFPAjOdC9Z5qxB?=
 =?us-ascii?Q?f8YKQ6AqdfakV2lArOv892PhNtwrmxGA/jv2Hdy7LesmpIiLKuDu3zJwFEeS?=
 =?us-ascii?Q?RdurAonwbc8fPZwyY8AQAXnaDkBfshrBr+6CvoZ0mBX2/+0FKsxv9TQF+TOs?=
 =?us-ascii?Q?yDgRqSXlZTcV/5lhbpamz9t4Rw3Jhnsruj76kmvGRp3zcfjbPnajjuQIU463?=
 =?us-ascii?Q?eh/UEqeALzrEHHYl7F136cwKqAm4KCAJS6oXZpqh869Telurg7TUK0z47NkY?=
 =?us-ascii?Q?3/cth3bGQz1bH+ayNfVUIsR5q+dw6O6sYKvoetPMwg3ktEToOuesa4+iTLrl?=
 =?us-ascii?Q?VxrRQLqf/hX8SKRL5MAYO20HN5N3M63+Qai1u/xBUgQOtcZS00SmCM5mo9GH?=
 =?us-ascii?Q?sz+UutrrZdy+th0CRGWREfLtlZutsPb1QG7FTvuBe+gQgd4JmrNvoe20sJj0?=
 =?us-ascii?Q?DSs2UCtPk8x/VcsX2CFuM7yG5ccfjZlfkAqAwI9eYHvUJEJAN4A3eYjnUQ11?=
 =?us-ascii?Q?exCOCfSAZK7Q98NBIj9YqvMqR61n2Kvvz3QXU2HY/DroMzE7+eq43ZaUKku7?=
 =?us-ascii?Q?xB27QdBhEpb5MePiilry1j2vno41+oUFeYF7qmCa9GQj4z4BQ1Ncy1mFa6kH?=
 =?us-ascii?Q?DLdJixhiB3YvVzr7wCIpROSHS+tUXoXJjBBKXxfFTFyXUyH3W6MPEs4b18nu?=
 =?us-ascii?Q?JIGKvi/KAhvZTKjmjNxuaNFApBbo8+0jHEoTRq5Yn5W4j60oOccP07HGInUs?=
 =?us-ascii?Q?+bJyDOjrsRpShJoZdEu2FxeX7X+3sfXtSF/nBQmiSHNslCB41VWWA8dD6yJS?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d360106-af3b-45bc-2cd3-08da746a2728
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 09:34:09.9583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eHjyQ3MKNcdPQJhSaWbRWzOrDjWt2IoPS1zl5Z78/an0g/FIcM/q/H2lgiJ/GI2k8NIkPw2D3kRMGyFK4blGAriqU88vL8LqORFttkoD0BU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1301MB2081
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

The port flag isn't set to `NFP_PORT_CHANGED` when using
`ethtool -m DEVNAME` before, so the port state (e.g. interface)
cannot be updated. Therefore, it caused that `ethtool -m DEVNAME`
sometimes cannot read the correct information.

E.g. `ethtool -m DEVNAME` cannot work when load driver before plug
in optical module, as the port interface is still NONE without port
update.

Now update the port state before sending info to NIC to ensure that
port interface is correct (latest state).

Fixes: 61f7c6f44870 ("nfp: implement ethtool get module EEPROM")
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index df0afd271a21..e6ee45afd80c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1230,6 +1230,8 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	/* update port state to get latest interface */
+	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
 	if (!eth_port)
 		return -EOPNOTSUPP;
-- 
2.30.2

