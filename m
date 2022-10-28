Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B107611C02
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 22:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiJ1U6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 16:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJ1U5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 16:57:43 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11021025.outbound.protection.outlook.com [52.101.52.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E384522658C;
        Fri, 28 Oct 2022 13:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnPJuftSLpFq39ySG1DYAxDLK/HBLVPY/OBI72c+UJ3SIIOuw0HcRvgnIWmLGN9av3+dmbWNCFo1ArLMBz3W9lVSxSsxsDgkps5501npMMP/evBB3buEPDsu9ebnjTi1CF14HO6qJf60tZkdLmK19PzZXuVfa6+q+oYANd3a0ZCmfcUA+KWHjvobz4rEeBD7znhg93ujqmYriyVFDgBV1l+ALZZXlxWOmneDxOhrvWSAfJekiQFZV/lHhmk+L/MKBZ+zLhkhKEK2xWEBM9BoDEt73ZaAsF/iuI2cAKRHuYWSgTlCHeIcGx/Xtznw9dtnoef/XiNqiXU2/6EFzX18Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIvsfBoUlx8X8o2tPgZOm7bAnD0kMXnofYnq8hjc5O8=;
 b=AfSxUCK07EGvKUf76IztI5DvNUg+7NHxrrIuUFXUJJlS4MUmoVSlmnMdcXqcw/BIiAGb1IF8RNup/sF5J0h2eUng3yMi6VQPwuf9PW/9L3DHVUkvyGyr4OyhOP9h5U9WB5JUtE3e55Y65pCKDGhfIt8LCuyW8pdeod7Bt+sQi5ditI77ONLwITITKjRLTESmRxNfYUq5yjmiUEiqwHaKp6fhJxz9E3CtpuVP0En80xHmNwZo/co2r4qr7nUx44MwFknPx3yzWA8tEaZqi1QPt9gjuJcn1Ry0fq2gg7vFU4mDtiOr1ufZ7YjFfbgrYSxSdkOCQCuEPomNvrQndLo9yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIvsfBoUlx8X8o2tPgZOm7bAnD0kMXnofYnq8hjc5O8=;
 b=K57ipt7vTp5EXIUiuCp4NEBYk20MXVFHdNnXTpwazGuNeNL1zcMJeFL7aeMWNT0BIUYtr4v4MXtZJkyMsKaiS6eI9I125dd3c4JRsUmPCdYHs7wFfjVs0KaS4Uh7um8u6ppV51vhMlPSGqZpkHoWp/f+S5RDZllHLsAkF0PoKMg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH0PR21MB1912.namprd21.prod.outlook.com
 (2603:10b6:510:d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.9; Fri, 28 Oct
 2022 20:57:33 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::a746:e3bf:9f88:152f%8]) with mapi id 15.20.5791.010; Fri, 28 Oct 2022
 20:57:32 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     sgarzare@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arseny.krasnov@kaspersky.com,
        netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 2/2] vsock: fix possible infinite sleep in vsock_connectible_wait_data()
Date:   Fri, 28 Oct 2022 13:56:46 -0700
Message-Id: <20221028205646.28084-3-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221028205646.28084-1-decui@microsoft.com>
References: <20221028205646.28084-1-decui@microsoft.com>
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::27) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH0PR21MB1912:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f44e39b-cbcf-4d0c-1443-08dab927089e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j3kkpxTvHY/6v82qAvRaPkv5+G8SguZqPQ9fuPnFhe8mu7l+SIDzxdMd7W5Fie1PUF4K5irDFqiiXpXET5NsydHwxblgtIRQoS2Qk3um2UfcjLPXqThh1OTCjBK+ANiDQ0+qVUtZipHYepUMfmBgQdfxxo9c5jzZopTpX+ofMSmn/45p+EAf5617cVSQM/DPaSjUGGqa5QdXYK+z0CGCfXy9H74dr3FznqOW5gIhzSQWN14jVb9uaovViUOPCLXztzDhsKIMPVjGDQT1OwZLj9H9RO96+uJ4GEt6CtKOHebZBrdxBFMgQ3cUNMgiETui+ZbRSgXpTm0367Dy0JYoP8kcpWrznnDepGTAbsXmOIfSyBgsVLVv0yFwXj/1FyeHul1EAFQKYXijQCfOrDK++rxGyYf7WyQORzYPCdqPHxZKimGTjWHj/SEp13T67AZIAfmAdlhtbggC7Q7T6Mnkx1mVaunlOwvLsaKeo+RVN8AKu7BOadRmhbKruSZM/DBSka4lIKVpLo++BlBKgnOqluJnzyFs0tBODpRstKBh+bcAde7YumQ3sg8iXGzXPU16hESGV7uXE2f3v0CnUOLkbKVLd/kn0rMnu/vKlzCPj4EEjJ7tk0BcZXvw+tYnasocgBJ3/O4iz5Ca/V98QtxngLdRXv59Jm976ofx3nQeP4EZ6TDnEUz0RpVhqWkUFwx1bVB7tLJqMM5vRwThpl4sPvi9iXsSlLslw03/az+1xwCxqACARruxs7iQUJQfoMAI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(6666004)(107886003)(52116002)(6506007)(82950400001)(8676002)(4326008)(7416002)(2906002)(3450700001)(66556008)(5660300002)(82960400001)(38100700002)(1076003)(41300700001)(86362001)(6512007)(66476007)(66946007)(316002)(36756003)(2616005)(186003)(83380400001)(6486002)(10290500003)(478600001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QccOEw7B8D5KEOfi6PYCZoFhupOzIjLAx8lu0W/wLYQAGRY0kw2Wc7jOwBIA?=
 =?us-ascii?Q?UI66JJmNHNE7gCUg2Jb4dnQgoOSw7c0nhh8HaJzfZCkE7p3/RSFIqVXyBnvA?=
 =?us-ascii?Q?q7SDK0NNBSxUjNqXvCF4M1dq5bsLlitcSKLkJAH0qoOShZA2st7MPCSIsmFh?=
 =?us-ascii?Q?81ApLOAKRH/BYV6PMpAodYpAPBDa2OpGNCr7rl4xX1PtSU5XH/bwMX5Sq7H2?=
 =?us-ascii?Q?891Es8OsH/aO8JISno/Bo910zw3ZYinutbGguNAWA8A6mQ1JF/MmfXAl/+hM?=
 =?us-ascii?Q?ewifc6w35sTuF5YyfS7CV+UD6F1X9v0p+gOoKp1rQIYcYh3LWAYh5Wy5Osvr?=
 =?us-ascii?Q?11dfc1h7xQ6G1m+nnaminM/1LfO3mgCJJbxQRM3vtSd+sPahU6H7W00/1Efj?=
 =?us-ascii?Q?akJdIUOHScl4pCur+Tzxv7hvrdk1E85mlJSKgLO9q9R1pgCv0OwhL/45ZHsR?=
 =?us-ascii?Q?rQM7KcB3JDFhjGvZEBF/dLc4qA3VzQ6wgkjmiAh1ubkSt+vKxLwmtf8Mn6Fk?=
 =?us-ascii?Q?44Tk59TyPd3FjDuNS8Q/M7lOR3pUmYJYwxuBhGpm7W4Yy1tDm4zSbHdVzi7Z?=
 =?us-ascii?Q?+7IY3awbT+5iyeoHWFeALRcUx3jW8CEbysukGdXhyEJpX+WqUt3SDuxCttZq?=
 =?us-ascii?Q?zKuIem5ybHhOqEswCRFSXO6tQnZo2hQgKrZTqnMPlpIRXrE3W505ph6pIur7?=
 =?us-ascii?Q?2zrmyNh0GwUXjggiVhHjOlb97ln+WClj36hi7VxiTwNeulX9GzGovDXrkyOX?=
 =?us-ascii?Q?cO+WU8jOiMM4SSB152zwH23XTVYpUlbd8oEnHJwGQS42xr9AQ92RyKB8KEKh?=
 =?us-ascii?Q?48mUfDcRQXlhl3YMgvZpGTvCMwbAtceUZkVqjiTR/Qx7GclwJ6ERnbm+qjrE?=
 =?us-ascii?Q?quWq24ESvWaM44rF8RjW5tpGbp7DIqjCg8/asAP9lFcYAk8WIEemubJ94XKN?=
 =?us-ascii?Q?E7RXUw9Zw3zHf+ECJjFiXYkWg7KrLZqoDfQkcUIkv5Uvt9rPk4VJLaE/TCMU?=
 =?us-ascii?Q?B4W7p8jprPwVyDAhzl5IbpXUBR22aMs1pVjfLyo19XZFKSbj1WXofvQOYtXX?=
 =?us-ascii?Q?r+oumpfUyFYmleaBYjxlv9jmmCoWHjiIQYr+gwSZsaHGzifmLxlMPBoNMc1q?=
 =?us-ascii?Q?FWaxuynHRXqG7qNGqn+4zcmZcl8B9f2+PjwOUh1Ara+DBYkz2nD+WWVhbEOV?=
 =?us-ascii?Q?Zyq6x8b2goRtykxnjheuj7vbxqbXU8dXiJtuMamjvmt5hm6bvYL+6lhYQezA?=
 =?us-ascii?Q?f/Hzu83mkra0WQtVe4A+aen1DQ+We5k6gxjyQu4WO9+Hwvsfs+wVhWFm41Xz?=
 =?us-ascii?Q?sfHNXbf9CLJ53uwBt5Wtwo8gdhNoqUxSVGaTh9PI7tGWTtXYnm1jKKoEsAWX?=
 =?us-ascii?Q?CCVoqTwSp6IQ6mwNFMZNL/4OBHWkcqM4XqssVZDgjUYwIzFv15B0WudeXlgb?=
 =?us-ascii?Q?Dt2JGHTMohUicLnL18b+HcZKnkkquIWmF1NIXshzFBOzq1ytWhDxPbqZwa1h?=
 =?us-ascii?Q?NyMkjN3YwbDtSUQnCdO9qBaKwWd7TLbLgKZkjuck5bFl2ToXI0ZdM/ntKMY6?=
 =?us-ascii?Q?eo1PSNqdmzZAlp5MmfactRVQFCeAi/Xl6PlqcDz3ARWVpp/ndJtaN9V/mjO4?=
 =?us-ascii?Q?8X/RhVsGi0zC6ydT4CSw+rh78veofePeha+JIR3nQ+yp?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f44e39b-cbcf-4d0c-1443-08dab927089e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 20:57:32.8298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXIh7+vDvT/H76kuCOuyg6ff0witgokUW8+10Xx14pntpux3bhrLwLbv4M8duJaXyGXeCeYEuxw/aeVKjCU4Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1912
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently vsock_connectible_has_data() may miss a wakeup operation
between vsock_connectible_has_data() == 0 and the prepare_to_wait().

Fix the race by adding the process to the wait qeuue before checking
vsock_connectible_has_data().

Fixes: b3f7fd54881b ("af_vsock: separate wait data loop")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 net/vmw_vsock/af_vsock.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index d258fd43092e..03a6b5bc6ba7 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1905,8 +1905,11 @@ static int vsock_connectible_wait_data(struct sock *sk,
 	err = 0;
 	transport = vsk->transport;
 
-	while ((data = vsock_connectible_has_data(vsk)) == 0) {
+	while (1) {
 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
+		data = vsock_connectible_has_data(vsk);
+		if (data != 0)
+			break;
 
 		if (sk->sk_err != 0 ||
 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
@@ -1937,6 +1940,8 @@ static int vsock_connectible_wait_data(struct sock *sk,
 			err = -EAGAIN;
 			break;
 		}
+
+		finish_wait(sk_sleep(sk), wait);
 	}
 
 	finish_wait(sk_sleep(sk), wait);
-- 
2.25.1

