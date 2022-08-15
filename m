Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23143592742
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 03:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbiHOA5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 20:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiHOA5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 20:57:01 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2126.outbound.protection.outlook.com [40.107.100.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8C112625;
        Sun, 14 Aug 2022 17:56:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhaKMSFu5FbvHisSp+CvmIbMWUy6FPWSunCEjJo1nIC6BIjalN4gkQsOfo1PoSLIbs+lp725CaskwzGEWjuulFm1ShenI0DcrbgXu5QsdaQOBeTNl3OHFK/gorQ8CwNIDio8iW49IESMlWPUyQ0JrqncMi+fhsma2FJllGxN34k40V8RO/Re4MZkdP1xAGCmqhT7AENifcB4M+35iUgiHLZgh8VsiHM6y4fG1M/Vok5dtv/0OarIBYCZWN/NO1O/zkBKZ3cZzT46AsVTCp9aO7E+wOrqo6JH5Fruai8Q18c0AM0i5Nt0a6MApRJhn1qhGCSAec1UjZz4UXzqbyWPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkWt1g9y1Rj2yx6TLx+yEiwfaAPfZe2xipge1N5vais=;
 b=RCmvrCqjsSw2jSG/PHVAlKRkUf113h1CZR475uiaUB4kWe+MPhbzc+ZZhBn0sHqunTqkGTRZ73l1lXYbVCuEHSh5l8wOrf75V7+fW3IS0n+GVoq9BbsLgW+Smchm0D6Swh47XVQJD7ccMqWYtCR2jxvyeRjBIHjm8wIl/lV1hPNnL18OyNlRbRY9apcIHfwHGwn4azHWc/2z7cMNRNCP5intKuOnYwKZNmrzOssOYBh20eVTgd4B8U/0u3OOswDP3w2XXWezY897H9IwHwC3QaasfsSgVD+DvBmmg8wXWrVyP7UvusstnqjxBE2WaLQnm9TjcY6I1GqBmbzfzLAZhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkWt1g9y1Rj2yx6TLx+yEiwfaAPfZe2xipge1N5vais=;
 b=kW1hNgzIaO6vEXpRsE7R8pzVrIYqKQpdA1q9/RXHk/KIjmVGQh/CVedAsZR60c5wyimiu/aebTkF/POQ11Eee549ZM8CtQ/DoHnvk48UnwgUyuINvIvpnhbqycZ1JseEplSdcxi0MfAr5h9i0BoHa4Cn3eLoNN7rQ2LLSxIU9Tc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB3862.namprd10.prod.outlook.com
 (2603:10b6:610:8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 00:56:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 00:56:15 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v16 mfd 6/8] resource: add define macro for register address resources
Date:   Sun, 14 Aug 2022 17:55:51 -0700
Message-Id: <20220815005553.1450359-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815005553.1450359-1-colin.foster@in-advantage.com>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:a03:100::47) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23bc5fbc-eae8-4da0-1237-08da7e58f476
X-MS-TrafficTypeDiagnostic: CH2PR10MB3862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NVK+2cWj4GUukHm0BTd1hGFh/aRLXnic/1bNi8xI4xaL0PalOFT8UIBIsnVSAFNJpmDJ0gabK5uPycLqkEApA09CTEhaLQhUfoNTIw6K4txH9pC5pw6Umj97XFnat/ehAlyeUMj2C8ipRLzuF9P84ciKSEiBH+q9BH1fNI0RuDLKaAtp2PndKMkcMaOm25D3VHPX7iarp0xxaQI/bNWExheD+DfDyPJsWWtG3XFCX1nyczOR06o0X9ddDZ+FnYSk0v2XQbHgkISkfXxeF/+RSyEZeObS0Q24PuAY2DY3D0CIeZVf6uHPeBXBjUVk4qxizvxsgS3jHcUHNfQjVH9/UG+ObczgBOF8LaobZRxIPlQGWwZbx6IKrUylEWzheXz2N6DznYuW5Esz8+1Mbaif+c8km6sHg7xMSxxs446d+DqP3Hr2iYMzrjEunqQ+i17xxex5Nvy5qtvJa187iUTAMpTRHzEGy7hQM5uTH7zNACXfgjgkIQOZQvW+V5PkK2vYOXgwzwUwdV3UIrQmNoTR77o8QTZea31fI84CHTHUTDHJ/x0DzS7FUB9kOmkLd2T/UPXJRbI6afed/uArLzEJ+nb1vhFEOSwjN1prXmXZUc+4Ey6pYbI83ibJX3pXMYTiIdihXFjhlqW0OJDMivYyqNfI0+GFFTMwTrgFc+MmMjlS5odFgPGTOioq6ka4/4E5//e1FpXa5VK9VdsRFnC4u/in3Q6QDtf/mJ5DfTo4gZjrCzAvTjbjqPAV4xwR/94DI3/5u6EXqp6yma0qsvYfalD0soz21DKkNWmZ7rXdgMQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39830400003)(396003)(136003)(346002)(376002)(1076003)(54906003)(41300700001)(52116002)(2616005)(6666004)(86362001)(186003)(6506007)(26005)(36756003)(6512007)(316002)(4326008)(66946007)(66556008)(66476007)(2906002)(478600001)(6486002)(5660300002)(44832011)(8676002)(7416002)(8936002)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vYsLeUZdoTGCJK9zgvaK94z8RZ3U3Iu1vtbIDimhy1o5f+WhnRlKXGwuy6t7?=
 =?us-ascii?Q?Xf//nB4w53+zaTwyxV8oTOdl7bxAHGh6dKhPEaI7oQxB8EsNKEJZSBlVNOri?=
 =?us-ascii?Q?PCsDKi9PWz0Xybdw+LxwRi59GM2yxctz57KeeOe5fMIZDjiU+AdjTDIsuCta?=
 =?us-ascii?Q?OBU2KBGBClm7IAPsdvduo7SXoloKZ4ywAG+X+x8/u4fOkpuagutRDyMtE1JP?=
 =?us-ascii?Q?bYW4Z4y5G9c3m17uf+putLkpjPyGnG7Hk0pa0u/zHvrKK8peH1zY+qaIMZWe?=
 =?us-ascii?Q?rchF64N7Kn3xucmLmOY9FMorT0aGATdo+Ne2buKWudcx5Iaj3Nxy6LDyHk93?=
 =?us-ascii?Q?Jd+emNYaa6kWJJYALIl3GzbOwd3udubfQtHtEqPYnGNK9snsi6qeHCMwnCSQ?=
 =?us-ascii?Q?YT5/Vpfk6ctp+XtjXN9lLsbPhxXrsnltG1+Z0YvGPNCC5m9NkgAsTBC1RawV?=
 =?us-ascii?Q?Mu844e8fjTMW9zDd+PMx/ildn4Fgxfh9awn4A0FT7Xv8YXspb0ALwsSUs/Jk?=
 =?us-ascii?Q?8V8/+t/6g32Kt1te6mp7ecQOXlEjMtf8ebBD9SLx4LTBEmNPc+y/67mvO3+s?=
 =?us-ascii?Q?ozmAJL3E1EeP2hHvJtE0wko4On8wo9+fI6Kgy+cylxgAzbnj07Etlej92RR8?=
 =?us-ascii?Q?N1qBlBLp/JFZP6+OF9Pfp/veXi/yHWvLO9qH6l0ZdSB+HV8o9gafeKtLw7e7?=
 =?us-ascii?Q?tkcgiomjv2Xp5YOSI9u/yd0uf/KcAH5QzPniO3GsH4zHGf3N7D3zWqcgnMsG?=
 =?us-ascii?Q?dhE24jOYxkoLaXXe/mY+61QnKTMq5yayAr9XJLwvZnWtHmX4v85Pw4z2HS9w?=
 =?us-ascii?Q?wg/WuTagI5fHOdYl+faCiuhzpTRHsTTdF0HgmwPX72/3A9ZIWszvvmH2pvEH?=
 =?us-ascii?Q?I4ohAgbukHZlIm87J4hegIm9xTsQGMrOySIJf4NK1wFpJzUSwqlJ9mrdJrqH?=
 =?us-ascii?Q?G8okQ6fQpwSgdgBl2j39X/JYS+3jSt0ZKfSPQQGqRHx62OhUbpRsbgGpmdxp?=
 =?us-ascii?Q?NI0ZYAPkX+jDomMF6iF7qeG7pEnGH5Qly/siX3lx4e4legvmJ4NpZhB3iqvM?=
 =?us-ascii?Q?G5l17EFawEzrziBFPe+JvWHJLvuarh7lzVhm8WjPlMVdJhIuEXDOeJ6RoNue?=
 =?us-ascii?Q?Y+VmtTffq43U4HDLpKc54ZrUNJ7IybnbJcjZUlBaa4MUiypGDygqyky9rphc?=
 =?us-ascii?Q?IRf8hhO8ml6VG4zzd7vZrD/c+zzEB9gIQ0+EPcUfI9evPaZw9Vmlvv3um/i7?=
 =?us-ascii?Q?HC+4ge6jpbn/CjGkqfKbQQUmxeRmQ7uF87t5R1cBDlSWwza6cNrh8oi9krjR?=
 =?us-ascii?Q?6CBzmPTra15MBPhoLaV+RiD0aXoV4pjymLPndUAkE5TNfBTr3Vc37fS9nVX1?=
 =?us-ascii?Q?AHyi+mKTxVl5uorGX6vsgHAAblxXyxbwrPMwhVjdGx3rp+rbJ1UQOKXPsbEc?=
 =?us-ascii?Q?M2sQBYpZ7/6REuHEI/RZft5skwo78Gl++rnqYe75+jpeTcy8+JjUqh8ebpJP?=
 =?us-ascii?Q?FpTuNLz0GmoROSu5T068RhjuAE2o7uZ1fDp9lThwbAbP7tvrcgazGaCxZqzl?=
 =?us-ascii?Q?H3Vy4cbsboCC4L1CPIvyroSSfxn8lzW1CsAELrb0NIWpBH0y/RLNR1AZf3J/?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23bc5fbc-eae8-4da0-1237-08da7e58f476
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 00:56:15.1821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPG7q+yNg9TyPc0wfnmse3M1uG3YHP7KsY8AR3fjfRlPAeBPikg+OkbUipeUMJEwY0Qy6bS9o/epgJLFdY20iJLyHj4JxuMhB9Al5JM37V0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3862
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFINE_RES_ macros have been created for the commonly used resource types,
but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
to all other resource types.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---

v16
    * Add Andy Reviewed-by tag

v15
    * No changes

v14
    * Add Reviewed tag

---
 include/linux/ioport.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 616b683563a9..8a76dca9deee 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -172,6 +172,11 @@ enum {
 #define DEFINE_RES_MEM(_start, _size)					\
 	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
 
+#define DEFINE_RES_REG_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
+#define DEFINE_RES_REG(_start, _size)					\
+	DEFINE_RES_REG_NAMED((_start), (_size), NULL)
+
 #define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
 	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
 #define DEFINE_RES_IRQ(_irq)						\
-- 
2.25.1

