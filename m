Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7185AF2AD
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239766AbiIFRcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbiIFRcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:32:24 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-westcentralusazon11010010.outbound.protection.outlook.com [40.93.198.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C711178;
        Tue,  6 Sep 2022 10:28:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GF9wvze+O9dtUsEwCpFnrEIzy77euHXpeNUbw4ZLENzRzX1MB+S2ZQxurPiv1GKEkLK8l2BH92Z7/2hTg+45L+qzJ7YzQMhzMHtc5AvrPQQKrJZLl/TYmVVFYtRPYuIdikTcUXXjlKktQzTo3bWtoIo90Um2BTGQfXujBP2kW6iOZHtjm8Z73NSzT0NCAvKAZUlJwhoc8M3DFmTcfUVXjFl1bOY7wSMz7C33FW7hmdR9Gxui0RaV5PzR8iEIcvQbq03smJC24jkGQb5E3FeV6cgpq+o03/5wyhJS0OrJApya/CqQiQewd8o4CTIVnRIZ7RvrOBrnfKQjOb7wa4ZQRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTIMLrTHM7cQ6b2tvRYYqq04m8+aq3ZwOku6Sv3UwIs=;
 b=ctny9mo0YAxTll+jUD7UgDVJie0zulFmnwv0V7ktgfDcP2C6/ulpQvFis699+kVXxPUnbm2a35NuUWzlp0QDReWxbKEoyTWmvyazoiR4yLRDThKxfY8ZJkjQghErfBXxe46rPcgNz1GH+hSMOMYajHL558QGO8X3lD/XIwBKYOoDPw0d8xYwp8BOGc0lkt9ahw6Dxqq0F33Gucer2GMt+h3MwAm1m7Wz3Zwrf8Xgw6ij3wpnf4W3qnfMaiSG77WIckvpza1nzis5O4qFqWgVzZQlQeZZFEzulcvhCPYk+7JcFTGsQVwvrrTWh9mOvTOrxakG/eWIjzRfcOT8W/3uIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTIMLrTHM7cQ6b2tvRYYqq04m8+aq3ZwOku6Sv3UwIs=;
 b=R65+CZX5wrgS10zjOm8ogBT4GmKr6L7VdhfWxOZKtbjGW+sKLzEFi6po4sp1oNwSVDrByBzsZDhI0tbC88cIYt29zAM7xXtnKzHSahIMF38/kpwAs+PSIcWZ07ZlzAOHJ3oicFjJZ7Yh66AZUC3xN+Qp+2SHpUhmZjgaH19Rkr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
Received: from BYAPR05MB3960.namprd05.prod.outlook.com (2603:10b6:a02:88::12)
 by BN7PR05MB4276.namprd05.prod.outlook.com (2603:10b6:406:f1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.5; Tue, 6 Sep
 2022 17:28:19 +0000
Received: from BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::a8ee:57cf:b2f1:b818]) by BYAPR05MB3960.namprd05.prod.outlook.com
 ([fe80::a8ee:57cf:b2f1:b818%5]) with mapi id 15.20.5612.011; Tue, 6 Sep 2022
 17:28:19 +0000
From:   vdasa@vmware.com
To:     vbhakta@vmware.com, namit@vmware.com, bryantan@vmware.com,
        zackr@vmware.com, linux-graphics-maintainer@vmware.com,
        doshir@vmware.com, sgarzare@redhat.com, gregkh@linuxfoundation.org,
        davem@davemloft.net
Cc:     pv-drivers@vmware.com, joe@perches.com, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Vishnu Dasa <vdasa@vmware.com>
Subject: [PATCH 0/3] MAINTAINERS: Update entries for some VMware drivers
Date:   Tue,  6 Sep 2022 10:27:19 -0700
Message-Id: <20220906172722.19862-1-vdasa@vmware.com>
X-Mailer: git-send-email 2.35.1
Reply-To: vdasa@vmware.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0009.namprd21.prod.outlook.com
 (2603:10b6:a03:114::19) To BYAPR05MB3960.namprd05.prod.outlook.com
 (2603:10b6:a02:88::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR05MB3960:EE_|BN7PR05MB4276:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ad3eab3-91cd-447a-2222-08da902d30ce
X-LD-Processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JfMliaX6DPU8FQu773Otj1WeqImdq3pPcmK2kG5hv1rqiOuvKIl93DxSjG5A/YztNvmTR33uiiHUSeCg03TaZdUThUzX2SnI5YAHoVsHWCFhYZ7/o+u7BsrUXiK7GiKzlW8kxD7hUDBst7HBfMaZ/folwSda2SxQgy6MDGoQckJHAxm8An4rofKSvDIFJD8XPDxP10Dk0YoHQ3xRWKZboCpwHxqULumW+hiGyTFwPtb9aXmi1K0Dt640cn/z9dQ4ktIgizoIEwykQMixL49Leq1FK7DZ824kRx4X9X1Pv2IPFa9uk4XdMmTaqdCge9aYSpBWbuHlPI9b65ba60HETRsecqMvHsuz5SgqLb8p6hxoFxg01CPAuzBckxBzDgVilI3LSd/ug8ReIlFGnDVMgrYT+WUPsQ9TGqIZDRRAdx2cNMtm3sQ7MrtlfeC/pKDarXG5pbD9goVDbP0CZ+vJg2O5qgcNXh0v+jJrJoqQZq/58o6FfOG191Vk2JsyDFf8DFYCI1443xcf23XRKYQWbYKnTaxRXa0kTFGFH2or4FIB0R417nTH1pyttFFrYR7KC1rcNkQW3maQ39xrsOmw3HWvRubrPizYgaKHP1gul9pEENROCkb/GzaZ6XukObl7f3ktMDy24N6KW9hSOGfGDoSFgMcKNu/PPLAXT+GGpYoT3zR/f9IEfLTLt7hlzFUKB+T1iCUYWTSIBu1+HpajeKF8e5jPlW3p/zKC5pMov1vFn3M6l2NcEs9JnipvBYIHJQTUqwzzb5KELIG29/HQsOOULm4ONi7tpzg4dixpiNesD/aH/JPdvpdqgXUYqr4h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR05MB3960.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(316002)(2906002)(15650500001)(4744005)(7416002)(5660300002)(8936002)(186003)(1076003)(2616005)(9686003)(6512007)(83380400001)(41300700001)(6486002)(478600001)(6506007)(86362001)(26005)(52116002)(36756003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hYj43R9O0TghiJd9nboflVv4qN3knBMKIHsbeG7Zf+uTRiKEcaRNzx/g+W4q?=
 =?us-ascii?Q?bAPZGEfvNROxe91Zw28bayxSLDz8FILMzb/K25k2Ggkg0EWCLa+h9Vywz00k?=
 =?us-ascii?Q?j6amF4JCLQY4XppiNbpmQB75OYLcZ2baJuUNB1FlGBE5jmWDLWPNSk8UcN//?=
 =?us-ascii?Q?9EhWmSG7+lCCmr891jlXXM9HbsHMyrkWNW+HJpZRuaEU7xDOM3CxNQrEtnKH?=
 =?us-ascii?Q?j7PgBwHBPz0aF4BjAyKEFuEkC97EVMy/h/Y8uzy+6yRyg9RfzMsFmr5ca42g?=
 =?us-ascii?Q?zogUmCY5foBJjXeYW0CliwkD6/4l/vEN0FUKP/Rif1E4CUfd38YZBiSVo3KA?=
 =?us-ascii?Q?tI22GOYkIz32QeGIWRH4yfHbNj+sQi6AnTdzId3aPdBG2Ew4hlV4t1iO3mhl?=
 =?us-ascii?Q?qazlQmm7UQWNhl6KsDU3dgg8X14ojLN9Q71MYG+/TLo1vk2WHw+h/vC1ZpaH?=
 =?us-ascii?Q?iOzkT72fJTR4NDjHVOsaZeWhsTGIQdpdpvdCimAy812W7UXjqj+eCxJmE9Z4?=
 =?us-ascii?Q?NZtU5AAKVOQ4fCKiZ0NnGWNl/RRYs6V4TnfDEiJXlRqNv6p80J2WkyL743TO?=
 =?us-ascii?Q?B+AFtt/SQGIZas9g7lNmYhn6kfSiJUAh6ji92fIcv3zai4CQY4fxi0LkSvSb?=
 =?us-ascii?Q?OVFafRpTcOv+ZR+hY/yj1HAH/5eSkJGcxHjyq2q6NiDRZaXq8Nl9oIOHwdPk?=
 =?us-ascii?Q?HS0t5MGbqZg4SqZHWGOh3hKpZyKYGX9AQDiw7ScZC0TQgJ4/ChxmqM+liIMY?=
 =?us-ascii?Q?Xr/wfFFm5XhZ+pqj80ldZLlOf6d9Qh0/TNzdQB6YWsPu7rldvVKXeDFxd6J5?=
 =?us-ascii?Q?D7R9nVMn1YfOcgQMMQSXqb64kZqXB6sdFmkvUrscRGOnyqF1tV9bOepVkF2T?=
 =?us-ascii?Q?cPIik5mffOCtUNqjb/zzptV5NZafbzLCbzaipSIp9IAIMdnO+fb+ttGDEv+Z?=
 =?us-ascii?Q?Lv/swXrT3it2nJ12G6w6zp4W9IGYI6Uq/Au2nw5qFqt/FpXXkn9UpH9AITrD?=
 =?us-ascii?Q?cKkAxJ85DKeZ/ohdxJQqSi8+XyvSlIXKmB3E+ttgzARha74ekTNGB89oYkXS?=
 =?us-ascii?Q?m9kguJ/yE4uq+OW4AlN4qeQtqKXUuTMAZ8s83q2rFwVb0tiPLRAc4585gRVg?=
 =?us-ascii?Q?dqe8nhex+SShhBybWaUiRR/85bM8d2xsvEdOO8U/y/5Ru0FlKB+bu6FXV3tY?=
 =?us-ascii?Q?vjKkHWGNU1PqU35ovXselNsaqx1SiZYvP+Pj7AU6huLNzf8m8aM5eJNwb9Em?=
 =?us-ascii?Q?JJjuhFPKKziuKmaxbljFyngGKzLWfaDnXUiBgG24TxQa7wFgQfTbdDWqoLNg?=
 =?us-ascii?Q?AxayBSi4pmNIwqIxFRmy+CKvpwAHF6JfJJaUHrvIdGdqbKiwBoVRXLm7DfV/?=
 =?us-ascii?Q?Bs0BiPv3Oa+5hAaWRo64GEEDBJT4EiqhY/qrfE4XfJcEpwJyKSZGq2eBkQeu?=
 =?us-ascii?Q?36tyZV1KWMMRlY+wAHgkFEkYvzq3JHWQU12WpSNqTqbY1zwiXQ1h3ssJJujN?=
 =?us-ascii?Q?sCCBKPKEec+6qyr3vZZg85YWgbKgynVkTiLwii+cZKdXWdyVEQRI4KuMhofA?=
 =?us-ascii?Q?7/+c/vSGBhYaL2hwM4Q=3D?=
X-OriginatorOrg: vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR05MB4276
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishnu Dasa <vdasa@vmware.com>

This series updates a few existing maintainer entries for VMware
supported drivers and adds a new entry for vsock vmci transport
driver.

Vishnu Dasa (3):
  MAINTAINERS: Change VMware PVSCSI driver entry to upper case
  MAINTAINERS: Change status of some VMware drivers
  MAINTAINERS: Add a new entry for VMWARE VSOCK VMCI TRANSPORT DRIVER

 MAINTAINERS | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

-- 
2.35.1

