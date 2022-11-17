Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17DC062E00D
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbiKQPiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbiKQPiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:38:08 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2094.outbound.protection.outlook.com [40.107.102.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C148759177
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:38:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWWJ5IRygQAixTag6d1yi0hT+X9Qx/6T6kPEjhtOeAwGxWdAvVOlgtqgAxHniOJqnq4R0tUcxjqs6Y43Ht9nisgmTFCubHn9EvGyk0nySpTJc+PK3VWNmLH6RX0NFA1czh50r+zeJ+q4htxKrHWPs3+I8lJHoPZRh4/LbHEbEuSIX3MeIE/xOz/XkIx2tfvquyiCZAX6UIAYaCjKLA41k2X478VoorBRylZGe4m3DexGvIHrnyfQ5pL9gjKdC1seVVslapP6rVZbccNXTLaUhYF4rWIG8uci/OCln8+1+dOBdk00kfCm5DFYihbAzSWYOK6YCsEomLfF2juiFKMGoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OWcc8PNqGfLcnWzwOUi8USAHpRledQBy2ZL/Tg83KRw=;
 b=fAt8IlXLHYtXhacCMINfFKVbjwLnbTTxJH+0Rs9VAoLLCNGQbQP5ETNMNzrDy4zLOtluZXbT/nA6BNU1/1BKrWbgnk6s9fRd6F+WTUf+MGtvqLMIVZrifnxXcOTOc6bN2/vxAGP9kNmyh0pfLDx2eO7v6FGWQ0TKfx6BUeYUv/RqoT2u/vgRqexyybKxVBioSgjBWEAXRFz7df32HdSYKQjgL+uMXBVDHY9Y7y6i+n3z1RZ1npWpuXTgARt3BSIfhrAz4mjrlcaE6UsTBp0LY4PetJTGGWoH5PWJVPVm11luczYM4pZWDqG87+Cx+Y6qH6AYwrVXWqZTsVMHKqE9WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWcc8PNqGfLcnWzwOUi8USAHpRledQBy2ZL/Tg83KRw=;
 b=mg4OpXeDJFD7EA2RNOqXSDrC+5dcoiZctv/rKHMslEkMAtdbTFvaNd3Kim5+HVPEdDfAI+9ry0UzNkjdnA0tJ77f2I4EJi0d6BbKPuPmAYfwrFahL/3OBOLZIHx1GTURQUEFZ6DIhu1dholkRg6MxsGktyNkAbZh9WTc1nHvN2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5242.namprd13.prod.outlook.com (2603:10b6:208:345::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 15:38:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 15:38:05 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Jaco Coetzee <jaco.coetzee@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 2/2] nfp: add port from netdev validation for EEPROM access
Date:   Thu, 17 Nov 2022 16:37:44 +0100
Message-Id: <20221117153744.688595-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117153744.688595-1-simon.horman@corigine.com>
References: <20221117153744.688595-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:205::32)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 657e1ff9-69e9-431e-3b62-08dac8b1b781
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1JyKfqhqZ0DOEtrbdQsqYfhIQciG7gW0j53+QRsjDZDg4xY0gPnkVBen9nxX8ZpeQEwTOp4/KRgg6lu5SBh6MYyQiucoAL+zcOgwCsIp0uLxNC8h+tFVUh4OoluFZF/XvW4tSeXFLfokLY/fHJMsYbcAYmneizXr+i5Ru3Qak85mmCEG5OXfE+oJqK/YguefZD4VpeZjOeVwVY6V3UgzaZGaRFyhSoGnorCSEbsViVMow5nw85fKl71MLNGf71qYv3ER8tjEfWwLHPgjMNWXIvLUl0jDyaGAf+kApjxGlU2D/DN3SFnS2EWG6j1z2azYefJeoLJ9qCCCBI111V/9kJPQEaM1l7LFTdrBcZAGc9A4lMzeLnn9U9X6AbMOiV6TcB4I53TBj3zbjCPrGUdRB39l/0SAN4E5Yu2OJd9hSgDUcQtGuBF04QcKUN/cO42WK6t4v16lfMfJFMrwlqxvxUblDyJd6M0DFYyH5OWOJVwzf03qebvjT/oAq23vhAn7S022jsvAolYsWJjrAAxAkG9OHiHikQx8MnYhF+BOrf533LLzP2YDp2C+Gy1CtdK3WDUwdAMHBbPoaK+Q7caglYe/O/dG3d4gSvR4LT2RFilufRbPQm/2OrjwzUrLfIG8AYsCqK+elGC5a0Fh8CDsi2mLjhEKP5Kk7/1eSHEx49+lDRhSPKZjQSiOd4jkgNJe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199015)(4326008)(83380400001)(66476007)(86362001)(8676002)(66946007)(66556008)(5660300002)(44832011)(8936002)(41300700001)(38100700002)(2616005)(6506007)(6512007)(6486002)(110136005)(186003)(36756003)(52116002)(478600001)(6666004)(316002)(1076003)(107886003)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/89WrlcKom/g8DgdTcmhl3el9FvoJG1lFRml2YNGA9t/5DvjSy2Wubqf2oTx?=
 =?us-ascii?Q?0G4a8+EYqqFp1j4B98oPvrQqhF8ayW9+HnMovosRi1V5LIQA2bHrWXwEorIg?=
 =?us-ascii?Q?+21uRwIVcK9EKTXrHfY+SWTHWf3VgG+1N959jfKosqfGMjY/A2Owz7O47qEI?=
 =?us-ascii?Q?8eOAjpmtwt4K4iitGbNoTd8P0HVGj5Df4OwlrhZciU69VR0Q0u5Dnk8N5qvx?=
 =?us-ascii?Q?DI3vjVf6QAvPKLkiq23i/Q83hwCt9aZEx6H+5mzL7/J2UADSWPAXcNNfE3R4?=
 =?us-ascii?Q?eHc10m+viZN7CRuiGREpa3/blfbvBqIXJZMgJgTaPUo6zPB+lzDquGYJ2Jy0?=
 =?us-ascii?Q?6xnlUySd4kDrzgjjutNDoA8y81I2SK82+nPMwxXt5sHo7drPyObTf8Rvrkbl?=
 =?us-ascii?Q?PYKW1Q9N+8kTItGr8o+mFxvR0uR+cK8yx2Y1cry0AwkMcHKw5IcuNmbHPytd?=
 =?us-ascii?Q?Ra4iOSdrZ/ZMoRJ9CTF3lAOUH2fv8Y5bl8L3QjzXgPRKQrrTCXBjFZdGOOZA?=
 =?us-ascii?Q?rfpPZQ+iu28kEf7C34vh78x9I8ED+aCGAVIFgxSWny5wKP7/O++1gncG9m/4?=
 =?us-ascii?Q?zKmfJ4CXpYl0vJgRMoms+TVEMaG+G+RSluADXQWdi8TvcJjLcT4wMkTvreIO?=
 =?us-ascii?Q?KRrpl0WdJ70TzMX8vSWwpcFgPvdrjEC6c0QOmxTu33TB395jja66xEi6C8kL?=
 =?us-ascii?Q?rJDw9JEbPYOb7OPabH1qvMnnGJYK3S0ZfLrLtkNh/0iBVPwK14XY4yzHPlaW?=
 =?us-ascii?Q?551rBNuDgIyRXT/CmXt/GfQXccnuvWqmIUeipXBHG6cPxg97TeVhS4OvBCXm?=
 =?us-ascii?Q?o+3EqLxkO3+NWVOwfkgQEYIUedTTp7HQmM1MVuC6RtFkfjAEs7wBhsD/Z39P?=
 =?us-ascii?Q?JQxEbUJX6Ht9MqP/Ey5G+W+7tcR8GCbkId5iC3TXWXDWmuoNEmvBYpYADkGl?=
 =?us-ascii?Q?7wR+0j5rQzVTR8tSDmFTqyj3mG6bxGQYLlhusYEXtyFZQAJD3c1+nPI358Hx?=
 =?us-ascii?Q?JSWsAWf0VAmAZQ7izcRaXZIXQK2L7qPgL0XhNEjJ5dpctsnWHnCd/TJcHezc?=
 =?us-ascii?Q?Dlt9r0zvyDrAwbiUiUkYcXow2o9tNF34+wTu5z8EZ06jQiwRuICcvzMaG9gU?=
 =?us-ascii?Q?6dv4g5ki7jzOw0fDZ6ZUTgCF4r4aJZ43HU4wWFLNjwltauUnHIkW870a71fj?=
 =?us-ascii?Q?6OjK0zm+yye2XnwjJh6bK3FgzYz8Rj8jjTNUH8jM4SmufsB+lyxtUgK3ctUl?=
 =?us-ascii?Q?hCI4/Y7KIaB//X4kKjAIEgjhmtukaboFEMNsaUykiAZI0KFj+HmC5m8mXtfo?=
 =?us-ascii?Q?qx6JCk7pBtWdMR/2xkqtCmS7KMfJuURirI0jKjUvUpcXF2lZ6juPgxt1rDiw?=
 =?us-ascii?Q?3MtSzdy4P5U7a446D6wWa7aWmOlb5n38f+aKyLvBtSctBz18ClGNXGMdO4jc?=
 =?us-ascii?Q?q0vOflshLD5P4ygc9/4XvU2cOrbVKm+4xwtJd4r68vw5+prVFvw5gXHnx+I/?=
 =?us-ascii?Q?9TrN09cb9XmDLr6sP7wkBhknUfuWAJuUK+yYDutm2EsQ8SSsb0562Fuw9wYv?=
 =?us-ascii?Q?WOf9E0fkS8jp9H0z7y4+GHSRiHyRJEtjjacA+sxvaAyRQt7uHEObSkGbXROR?=
 =?us-ascii?Q?Tm1IJXqOl6C6+0l+lblLjPKj1UcKpEJco7wPfJJOqntX43SN//y/0bd6rC7n?=
 =?us-ascii?Q?D2vQ1g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 657e1ff9-69e9-431e-3b62-08dac8b1b781
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 15:38:04.3108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L2XKt2kNwKzECfQ7BnFwEm93hxZ/kfFjYnnBnDb2r4qkxv4dfg7iICtP5xO1FzGfmKXbtm9fq6cGuO8A4s+VNOjcE6Xo+zwai8TIXObdLsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5242
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jaco Coetzee <jaco.coetzee@corigine.com>

Setting of the port flag `NFP_PORT_CHANGED`, introduced
to ensure the correct reading of EEPROM data, causes a
fatal kernel NULL pointer dereference in cases where
the target netdev type cannot be determined.

Add validation of port struct pointer before attempting
to set the `NFP_PORT_CHANGED` flag. Return that operation
is not supported if the netdev type cannot be determined.

Fixes: 4ae97cae07e1 ("nfp: ethtool: fix the display error of `ethtool -m DEVNAME`")
Signed-off-by: Jaco Coetzee <jaco.coetzee@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1775997f9c69..991059d6cb32 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1432,6 +1432,9 @@ nfp_port_get_module_info(struct net_device *netdev,
 	u8 data;
 
 	port = nfp_port_from_netdev(netdev);
+	if (!port)
+		return -EOPNOTSUPP;
+
 	/* update port state to get latest interface */
 	set_bit(NFP_PORT_CHANGED, &port->flags);
 	eth_port = nfp_port_get_eth_port(port);
-- 
2.30.2

