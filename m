Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2994CE5E0
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiCEQUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiCEQUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:20:18 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2124.outbound.protection.outlook.com [40.107.215.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7827630F41;
        Sat,  5 Mar 2022 08:19:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E62xQ4BI7KYB5E96RYX2d91eCYx2DN7hm6Hl+xMkhCCLFzZ3H0HqUEv59lRl6W1eLQO685zL+8QCEdADQgYY4h+lrrmwgrbjrR02zpuY8jiM52eIX3xL+a/DSRWAN7PmYhSWu9aWrJvllrfyrTGZJlOMqls7VeQpbg4qaVrMDecZSgDimB0DkDN3OfTvZJAz9dWPfdBp+ntEHKh+iip/ajWtBy8+MFGPQBzLbCLhCQRw6burTfv289n2Cn+FTaVKiEhdsxvCXO2GTD9yc8czDIAjR9iUywCt0dPPHsTUTt0TpgCn4saKRNlXi5VWaaPLqztq7921wf07bA8IZPfXUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hy3TQGhSBywW8pT77J+4FQkaJlonxbA2KliKY7bfK1g=;
 b=f7qSSTfLBI85YExgYZJv4vd5Y5VXSuek02xzW17RWmZ1AzmmcGCHryFIUikvulwDsnFkA3TvEbAKxIbUJe4WW++lGU4jnktr6wcyOv1mN4ER1pVbbmruPEHILhJvHsD1CRLLC1S5Qsrwcx/q4xS4pMivOBrIcfstnvCH2iDDUf9bdwcSiMRoD+nhvsE1k3tpFbFZaZAu19VvV1jXqTK6Xy+5McNL6NgPo+yymquU10Xakdz3P0+Kb0d9Ux2eJCVn/g2v5EAk3wPbcy6xO0pnPgZeH4SlI6stvdjks3UdMU7flfTEoMa4F2LTq+ss+eZ5Y8NhSSEzRYW5rOlLfqb9lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hy3TQGhSBywW8pT77J+4FQkaJlonxbA2KliKY7bfK1g=;
 b=XzzWg9DkwOG8YbBNMkMJRqY7JONdygZeV4dcGWixUSCnsLi6/A6J+P6IA7k+pmfvi/QsZRuGke3cjVpY+m8dxWrd4P97pGTS9+eGJq9d/p4sZLyu50w43/6++Z6rloE5AwtbL/U+tRHrbByAJeMjTnw1KS6vSzQWMTxixXqDmYk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by PSAPR06MB4517.apcprd06.prod.outlook.com (2603:1096:301:8f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Sat, 5 Mar
 2022 16:19:24 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.020; Sat, 5 Mar 2022
 16:19:24 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] selftests: net: fix array_size.cocci warning
Date:   Sun,  6 Mar 2022 00:18:35 +0800
Message-Id: <20220305161835.16277-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0057.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::21) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 854c4367-3095-4597-55dd-08d9fec3e90a
X-MS-TrafficTypeDiagnostic: PSAPR06MB4517:EE_
X-Microsoft-Antispam-PRVS: <PSAPR06MB4517C684C2F35FCC7A13DD6FC7069@PSAPR06MB4517.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AmFMiz7b9rtP5AS9ql2o9x4RJdvJpODgkhiNChB1NcF1ceFrwKC1nzK5Tvgz6Y5F38lvl4k3JpXjefw4DU8ENGY+KVzAJwZSNcdx3PiLhNP/ImxnSScVAF93/jGedjMpL3IbcXI88GKqVoZvbRMHHP/sNzEnExZCy3LMBSgf9TYHIeSKBk2vgb6LvfX1NaJeIxMYgWxHs6OJIez7/WnLjtLVHEuiNIqNS6RjY48fP81Ta2dTTI6cSzliS4q/FTvl2yTF34FkFPJSRjW39O7OH5/1YRU4lUr78Sk1mjSfIxP2viSUzjvBDUei06KjIO39Hq56kvK2eOTY1e9bBZJ/7oCIoSRxRocL0orp5SBreKqOGHlmlDQ9I7Ut3eigABvJmUecuOZc+WqI9aCW+W7VE9UnoKoe7TLBrjvTuYBNbBVBVHoLnFZU7Dk1CkG00XPx5JMIZ/PcQs+nSQyTLnEEmMPVL+OHj2+HWR/uToOChYo30a8ZfmL/UMzq6c7Xo4qNe/waP7Q0nytl66u6XI04Ag+aLm7X/je1MDLhkz+AHXjPurRxpE64BXcZlgdn9sGGvCCKYvkTilxg3+wob4msWuRY/yAgDIgBt/ry/G1m8cDx2jgVg9ZUgyEQf8myA0S53MEoz//oVhlj3kex8bJHDC60fXj7THD2TWRZvfZVyxae+w/ubWPmlxLQPgC04/hEmqPLg30Y99aTuOjAPV4aQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(8936002)(38350700002)(38100700002)(921005)(26005)(186003)(2616005)(107886003)(1076003)(83380400001)(52116002)(6666004)(6506007)(508600001)(6486002)(6512007)(66556008)(66476007)(66946007)(8676002)(4326008)(316002)(110136005)(36756003)(86362001)(4744005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iWpiiAC4J7YYHnrOxxXZdt1C1+xA+w3ufKIRCvyobLECldUr5aZ5NYN/HoLK?=
 =?us-ascii?Q?POnjjM6jrJrkXtu4DPlz8CcVmIUcc1R4IKTfbSHhgYBeYxwQ8S8jUAlpf9HF?=
 =?us-ascii?Q?Gfr77nSidS2rU2kgU/6yKyD/tGqtStHYJhUKomL5G+bImQf/hTh1440fPZfS?=
 =?us-ascii?Q?5rBh9khSVyQTy95PCAdS5EjcxOvp+PZLAO5LApjkxSBJi2aGets/oaF/7u8k?=
 =?us-ascii?Q?BkmNKzlqKRUyVXnx1YXyI5ohgeoejB8sHR3HVrvF/qTm006IMVACr7gQ7Kd0?=
 =?us-ascii?Q?08yka/g9jAyj/OoGv8YlwrJlEJFmVUYkATHRqooPIQsFv4pw1Z39B5bM0XMv?=
 =?us-ascii?Q?qnzAn9YUXXSGqKtF5ZHk596x9shhsw8AINN2d9JJIMcpg6henI/vdyIOOjCL?=
 =?us-ascii?Q?XdAkO5ul5+h2eLcXR/I93ZONcK4kh7z/2qNokzgKyZEF8uMvzRkitXO/0kTF?=
 =?us-ascii?Q?ilG9/5dbVEHCn8ws+IfKSbxUhiV1YSrxs1lm3yc6JaQovkjFEjMb1CTb+1Jg?=
 =?us-ascii?Q?HNwkwCitFMmdj0aIwY+viqZup7TTJKJsP1ThJpBVP3Fpdwchd0rZc7UeQaqg?=
 =?us-ascii?Q?mbtXbI7vn6B/e5kOyjSwZ8VA2TJupTurr+9G2qxBZCOEy1eYh8tov+dovElY?=
 =?us-ascii?Q?0b34eDubraJ9HbDte4JcW5//ei2VR0pujLj8MA/Ry2GJEFLKSGI2EiVDaKqy?=
 =?us-ascii?Q?i4sDAKQgYcwFtJkIG3JavYhkxv+R/vy12ls5NcL9Qc7EUXkqJiHRVb6HMz1J?=
 =?us-ascii?Q?EUKuJF5MSePjqu+wEJIFj9/Q4hcnuu0VT40R8A9IWA+Q0pu4PruotdPvodwu?=
 =?us-ascii?Q?KbSgKKxKLkohntTeA0BxltjvCn8uUCZdCiv7sYHM9jxVpl9uzJhQTl13n6Um?=
 =?us-ascii?Q?t5a/Nttjq+AdgbpvFqHMGwHnr9CHe6OQMwXHdaYg7o87n7bUSv6WeDTxz5Pa?=
 =?us-ascii?Q?dbo2NuvpUu55eBGiZW9aHU9M93v9e3klZkgNJngapVrrRrdkNxnkWWuqIcoY?=
 =?us-ascii?Q?DTmlOlTFrGMHhFoBrEx66nOkKxC5v4jZwpp+aercTvGzz8N3g7D0ddYfgUMP?=
 =?us-ascii?Q?Pz6lS8F0m0r8l5Z6Qr4/h8p971YDgq75TnWG7SgR6YLe1fX0og2XrvuELdxO?=
 =?us-ascii?Q?adX99dNRYIZkt2ptTUKXtHsYa3XyWnA0iPv29Lx5EB7y2eH0qgW9YQViG2Nv?=
 =?us-ascii?Q?4AlYMLWIlW10rL/M8+b9Di26vFyoOc6iGqmiUhmLovXm2bZZx33ACmOO9cNC?=
 =?us-ascii?Q?PzLGMIdHBu71ZEWUoJi9GEEJmzklQY/upoRGt0HibCsmJxO52CuCPw57KPIa?=
 =?us-ascii?Q?veJJze/k8va5FqiNyVL1u0e6SJC7drtRh47iJlveID9b7wo5/mAZkamgRQgm?=
 =?us-ascii?Q?nT62dWrY1r6riUh7xyhDaueIKvHtfRIBOic0yFZ3hz8KQEA1mA6Q0WgaEjuL?=
 =?us-ascii?Q?huu3B4BlnzzYU6ObHVp2aiT3TarpdoRKUoG4hsDcDwAr47doCWU2+Y9s3rLj?=
 =?us-ascii?Q?xDM7wo7lO4gYZ8LHGLRf/cEySl36epilOzzmYjN82Xn+nksT+h/CZRweF+mT?=
 =?us-ascii?Q?TkThCfr5gH7XcvAyTM3iCaDkDDyFJ4Z2hkcs/Ridbcy5dMJHef1Ky8rGuuIM?=
 =?us-ascii?Q?hClPJ44sDu2SuqXdRcQRPIg=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 854c4367-3095-4597-55dd-08d9fec3e90a
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 16:19:23.3825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6MIu0B6BJfiBcXUUeqJ6CwJHooqIDb3n+0QmEd2V5Fc0aJuAJXjsLLSa2XLoBRgP9EEvyyeN2c/VueC+022OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR06MB4517
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fit the following coccicheck warning:
tools/testing/selftests/net/reuseport_bpf_numa.c:89:28-29:
WARNING: Use ARRAY_SIZE.

It has been tested with gcc (Debian 8.3.0-6) 8.3.0 on x86_64.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 tools/testing/selftests/net/reuseport_bpf_numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/reuseport_bpf_numa.c b/tools/testing/selftests/net/reuseport_bpf_numa.c
index b2eebf669b8c..c9ba36aa688e 100644
--- a/tools/testing/selftests/net/reuseport_bpf_numa.c
+++ b/tools/testing/selftests/net/reuseport_bpf_numa.c
@@ -86,7 +86,7 @@ static void attach_bpf(int fd)
 
 	memset(&attr, 0, sizeof(attr));
 	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
-	attr.insn_cnt = sizeof(prog) / sizeof(prog[0]);
+	attr.insn_cnt = ARRAY_SIZE(prog);
 	attr.insns = (unsigned long) &prog;
 	attr.license = (unsigned long) &bpf_license;
 	attr.log_buf = (unsigned long) &bpf_log_buf;
-- 
2.20.1

