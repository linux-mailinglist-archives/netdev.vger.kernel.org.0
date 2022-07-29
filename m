Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D25584DF7
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235563AbiG2JRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiG2JRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:17:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2126.outbound.protection.outlook.com [40.107.93.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA14E66ADD
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:17:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdGNNShVYoi2R9IAwwbLM3XqUNCXgcO0Z7vLDSlPCwYnzYYRiFTeLbagRNkFCQkPHZHYN4MDiTMQo6T+aJT7x+cDuZUeMQciGoJeZ4SeY7BsDjEwqrhyime1ayNKW7CXlAsMY69QgqByZTj11Eh1G3fV4JXoefY0gpwC3arJ8QF2Ksg/HC1T9y2QmDJ6RQzNd0q4jbJaNoYBSZCvSFuFfP9aTU97uo7WV9y7KGOrib6oEhpQKYRHdcOxEVFIJ0qmUCoFSNuabM87z7eVWoe1wrfpuwkXAwpusX9YUmlajY6a9Zw/LUMVc8QcW+av+r5F1LvUTDhk00Si1cWctsxIDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yam4qx6DR1E7EQSP4gfgu7XY8bDP5nr5mqDJwcFXk40=;
 b=Zg+S4DZ23ueljawLiqtlCVceOuf4PPnOWIDQ3JjzBG89/MUl0EJdmxDBgPmHBcJqy4KgoBX9oXC5pSti1tc5xAFiFs8zZQHAxI305QnK/uS0zaCnuY+zaMhjqJYpeoNqviQ+LFQQ7u56mhPiUtmvDUnkBsebEx2trSl9aTj15qECfdmJJwjLyuFpnd7GEuDqeQC4jiYOVx4HgrIQlTqX7lCImyQiqBpz28N5HbXTHcUgRpXiL0Eu4EPPX936rEmkFX8mU0pdcGxhI3MDZ+d5gBMcXpwvb2WzWxfUFN7Mn1bHbtRNAYiL2HkT5QugvEVZaYZibNFphds4cZkRWLTRHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yam4qx6DR1E7EQSP4gfgu7XY8bDP5nr5mqDJwcFXk40=;
 b=lofRpeacFuJPBUkZRjdJNKUFzNVcBQlJdTGLhQBmO5leWj6JX2Dh+VpyQsKsddjeG0YcNoA5xTeFyyGxSEjF2kQgLgvELHlhmUBcXZGI5uhh8zpcSjjYI8x1QkpUHd9e+PBqU3SnC+kdM+TE7DOaT3uyVKVQGHmImgkET3uRxaM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5406.namprd13.prod.outlook.com (2603:10b6:510:126::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1; Fri, 29 Jul
 2022 09:17:00 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%9]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 09:16:59 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next] nfp: flower: add support for tunnel offload without key ID
Date:   Fri, 29 Jul 2022 11:16:41 +0200
Message-Id: <20220729091641.354748-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PAZP264CA0121.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1ef::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b33aefe-5a26-4dd5-fa40-08da71431779
X-MS-TrafficTypeDiagnostic: PH7PR13MB5406:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9cdpM2dM9qmC4i66QXn/8FJG2D8wUpOhDl3u0x4oeBPW3yDE+dfzjrH7i8w6EyNbkfdrTYuWTzuilKC/wzjojNyKe2WlXSNrVCSw1yGNUp1bqplcu8yBqxuGCIRDR9KT8ydYI9u3AZe/Uw1HCdHkpx2hJ6Z+aPTNfPW/+Tww2E6H6vfBMXp7H70IuTQG2DT5iD7UrZHdkhXvF+1kxj0R9fKkvUNW1qtTpaTurzchAGcE/BlhPw/rT2jDXWLfHQoULJdG3Uxd8sXWnOnSxr5b+8sJ0leilxi++0kgyqwzNCwdBScYnIe7tmWgwZSIkrhXFTRNSK12O/xB3ZKY+mUNc5Fma2ui3XHtEkdCtDc5swvmhVO6KxEBueZOMNUNFXt/OhWHjj+AGoTVz3UFDFVu4TejcF11nUo3Algbt3Gg7xw/ajUgrPwkUqin99M+HMH54FZyw/rO4c94DyudNzCB5HvKekR39y3YMHJuVS/6CEagMwKJcd5W4/cC42HTkO8jyLnDa2UZeEFZExAXjvDABeKQe25SNpISrz1yMGIWLtmFSJK+Tb3jzrPrGz0f13NEePiwW1+tjxZ1zM04D/WzMQYaeAphrn3CtNs3orlYrOmV1T86cEZ10paoKGr0eXlVS5O9MIhz0N69VcvzeLjfO8xicrLswQC/YKIa+cMXZ6J6g99cHM6ULDtf3gm2uzc0ra9zktpihlQzCHOf4p5CYo1Q0h6uRLSqHLy/yXqeh8ochZAoLUSU5k8HjgSALjurlStWLhqBuY21y0ETOYkjUxB5FPSgSCaxm62K9rYPnJou5Zmsww3UVZsesjdnk03oonXYoXnrVwj+eWf4Xr84o7PFnwB49xiUpLCDHBVPBM8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(376002)(366004)(136003)(39840400004)(8936002)(6506007)(316002)(86362001)(478600001)(5660300002)(4326008)(1076003)(26005)(6512007)(2906002)(2616005)(83380400001)(107886003)(6666004)(66476007)(186003)(44832011)(8676002)(41300700001)(110136005)(6486002)(38350700002)(38100700002)(66946007)(66556008)(36756003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6FMvfR7BlXq1GMWTdhdva1U77Xtbr1UnKgys5p5/swsjr2ZII11roAOAgTcV?=
 =?us-ascii?Q?F6k0vBcpdvkE2+phCwx6uv6dWSWgdtfnBGIOSSHksYsaxLefWS+TV7cOz+bU?=
 =?us-ascii?Q?Gskosu+k6C4bNFBSeuAFBWC5BE3AFlS3tMPWRPuBzoUGcY1jdC2RkYf5ucxC?=
 =?us-ascii?Q?alMXL0/UtvbwCa4L+Oa6AZcvJttJ5j+eLBJVZOvKFdT/TIN8VBKbx3CJF2At?=
 =?us-ascii?Q?5d9WNtrZpws+A8E7WKi+WSlVuvl7IcdAZVt1tDQpk8C+9DuSRbMhCCjX4b7b?=
 =?us-ascii?Q?GhbqF7SkWEEKb6V7RlhS33wzsUmXw/M1myaey0vF1XYho96jzsjfJcXlyUPG?=
 =?us-ascii?Q?brrjIR+r4XTSL3qRkljrs6ceQzvnED5Fo5LI2p4GgYLCHHwXzebAJBrxmqcb?=
 =?us-ascii?Q?T23wI357k21Exu4gVbsUa1p8OHptiyAGTUqsukHkov/065qY1nH66294gp47?=
 =?us-ascii?Q?/ujUdVVEXLO4CtLhmih/ttcPl0dSOXOPvc9zX8v9CiMRqpdyoJYmpOggSMQz?=
 =?us-ascii?Q?VHI8WKYACIG/AUoF574ThDt6mb8PlVZQssaiU0y7XFji6hjWwdpjaMn128wK?=
 =?us-ascii?Q?Ua+/ByItRp2q4ePosjFjKcTd4icNpIKIJoaiksoT+vtXiBC59ZHMsP1PVe1c?=
 =?us-ascii?Q?KDYSMGqIJVQt7cdEUGveKElyLL6lKjj06f3UvxAuvhGEv32U9DtR2gD+n1DR?=
 =?us-ascii?Q?BqwPtHnRcepnm1CFd4lOr8IGRSWdqFZ+BLMZbeQbeek0yVBkdwQJugRs3PX9?=
 =?us-ascii?Q?89d+/aSSvdMoOi5qpfhiD56Hs0uBQv8KTmzrkblN997rqppXTpW7D2RBrul+?=
 =?us-ascii?Q?J+jVmeqsttmVzrMlrcHHqUqvJtMO4AgWKlkmQK7ZKDlKkv1N94C3V1w+3dma?=
 =?us-ascii?Q?aOhopKP7ss3EaoQo6EyvVCkBBraVOK48rY1Uv1zsoF0yf5r7GCRYo1OQIF4Q?=
 =?us-ascii?Q?erZrxuq0ORhsu3+fAzVC30OBUDg8eMk6ggMdxARaf3eRoZ4iJ59M68VvdTYO?=
 =?us-ascii?Q?Pr2u6Q3JNHHPYBoRjWpB9H7JHeSzyKt6YJsOQIAtxT+A0MAk8LDm2PMQm3Dp?=
 =?us-ascii?Q?dxQWpjdwAmqJ/GtUME6oxXMUxTa+XEhayaEZAEvbz396n2qemkLKoKLBPX7C?=
 =?us-ascii?Q?xXXGBtLPZU7Gr90oqVbVqGjCuqK5/4E1AVIkwKqSQVtyC+Yngv1Ctpnnfb0n?=
 =?us-ascii?Q?N8vdzJRTiPFAUU9qweJHB1NEG9UeRJ7aCFmr7DMVOF43r4mY7N+74AfZ5ytT?=
 =?us-ascii?Q?so29csdQ7TgVk81dpviQGJ5rrJAZIFszSjBO25rOrxUHx013Gs0jZ+0Jr4/f?=
 =?us-ascii?Q?h1yiTKIpiAnZ+0SQAkaVdg2lsZExl4341Um8X9Q+/DCMhIQoxKLligl57YPW?=
 =?us-ascii?Q?6Uo/jtpuwvFYj1dxDNs7xfHiwYO2lN1d+tp446h7rCG5sPeCxmYiK0mrLWNu?=
 =?us-ascii?Q?8+3lJx0U83+CBQrfcKPa/8jss9XC4SKLIPk/egfeUhZLW7r4Tccut35Mqf9f?=
 =?us-ascii?Q?IWQ05/tbHsAxY8rvmzyArghvf6kdj1bgTTFwl5VrDpNahQocEI/dduWrsDfx?=
 =?us-ascii?Q?8stJLBQ4+Tfv69smun+8/F773WRMLFld6sk6UNxZnMcdUJRBNqbKFpYPpa4j?=
 =?us-ascii?Q?Rw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b33aefe-5a26-4dd5-fa40-08da71431779
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 09:16:59.8410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w7S1ahWnqHL0E/QO8ohNTEj2oWa7xbmn5TIId+4o2SC2RvaDTgZJzMV0P4Q5KeSon42V8Lk3RMZQ17ZUKJWrM9BvJUpyqXTp/Sjt7tS3kKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5406
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Currently nfp driver will reject to offload tunnel key action without
tunnel key ID which means tunnel ID is 0. But it is a normal case for tc
flower since user can setup a tunnel with tunnel ID is 0.

So we need to support this case to accept tunnel key action without
tunnel key ID.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/action.c    | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 3c7220a4603e..2b383d92d7f5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -427,6 +427,12 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 		return -EOPNOTSUPP;
 	}
 
+	if (ip_tun->key.tun_flags & ~NFP_FL_SUPPORTED_UDP_TUN_FLAGS) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "unsupported offload: loaded firmware does not support tunnel flag offload");
+		return -EOPNOTSUPP;
+	}
+
 	set_tun->head.jump_id = NFP_FL_ACTION_OPCODE_SET_TUNNEL;
 	set_tun->head.len_lw = act_size >> NFP_FL_LW_SIZ;
 
@@ -436,7 +442,8 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 		FIELD_PREP(NFP_FL_PRE_TUN_INDEX, pretun_idx);
 
 	set_tun->tun_type_index = cpu_to_be32(tmp_set_ip_tun_type_index);
-	set_tun->tun_id = ip_tun->key.tun_id;
+	if (ip_tun->key.tun_flags & NFP_FL_TUNNEL_KEY)
+		set_tun->tun_id = ip_tun->key.tun_id;
 
 	if (ip_tun->key.ttl) {
 		set_tun->ttl = ip_tun->key.ttl;
@@ -479,12 +486,6 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 	}
 
 	set_tun->tos = ip_tun->key.tos;
-
-	if (!(ip_tun->key.tun_flags & NFP_FL_TUNNEL_KEY) ||
-	    ip_tun->key.tun_flags & ~NFP_FL_SUPPORTED_UDP_TUN_FLAGS) {
-		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: loaded firmware does not support tunnel flag offload");
-		return -EOPNOTSUPP;
-	}
 	set_tun->tun_flags = ip_tun->key.tun_flags;
 
 	if (tun_type == NFP_FL_TUNNEL_GENEVE) {
-- 
2.30.2

