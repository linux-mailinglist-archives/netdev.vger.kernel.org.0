Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633956A7012
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCAPpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCAPpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:45:49 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2068.outbound.protection.outlook.com [40.107.241.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78527144AC;
        Wed,  1 Mar 2023 07:45:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jm1hAESRIv4MyJxbvIVArr8A78Sp6fptpmuebYYJOhy8DcV/rK/AbPgYAyUBBg4N6KQuM7OtObgnTYjGZxADA57bJ+R0a5UI/WKgtNmE/BrqLbrd+3NyyG08JfX+WFez+qZpZo4lEtALBRDYlUPZYKrmRe+EfUNE2Jw6GoigzLjLFXgIx8paNxC3B7sAgL6D/YfZ9xQsHnmRa62kQGjZboKl8RC0XqDX4zTZy4sJ5BA0eX/5ZkVnoSk4wX25XY5ykp6UfcOCmnbBhxpOW4rQZZNbmbCjYvhgpctVozNCp8LleQJ7kpN41maMmmI3I0INK8mYkgw+5lKNLm3qWa7ChA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzhQtZcnRg2edw+52YyDH2xoGaTt8OW1tNBRqFy8L60=;
 b=VPWVSw9U55QfcK1iWgPAsDAeHSU3LJSUM88Ab+V+QgSY0y3D7Zk1LqQu9JZNlDROoy1xAmCV8J9o+m/ydWOuVQc3ush7smJglGtKkSJrkGPVVvSMsajcw23v5OH9y6Ryw+TZZXCDP6D3tFPzqHQlJmA95B23wlFXuAsn/oKQr/8otbPc04gEKPSguyZ20mrvqwYrtODWAWFvFSWNoQvv2nWlbCtK4wr+Jniyfll8AdjY1yfEPvk4j4hE5ceMhlUxDEf8RKSB7p1ueksvHxy8KPfH+8IxOM8H9ALNkCKiY+tds913mNaLjl26XTm4FelyfwRNl0mLZHz5fqo3iNntDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzhQtZcnRg2edw+52YyDH2xoGaTt8OW1tNBRqFy8L60=;
 b=JvejJNwzH1Mpq0IRb4KG14+Qwyg+TUojJZDoWJyrOlyIo91VVwUys7dvme/i3Rbxkdj0cXFGv8TqiaDSmaXoAl4rmdSVkkAy0G2bOw1RzPSTgPJ1jSB1hMKLpG2Mah7FDIVUw5aWyzQ6lgHJMkLxqIydNCiw7vjKqLMySCDFcP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU2PR04MB9129.eurprd04.prod.outlook.com (2603:10a6:10:2f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 15:45:45 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%4]) with mapi id 15.20.6156.017; Wed, 1 Mar 2023
 15:45:45 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v6 0/3] Add support for NXP bluetooth chipsets
Date:   Wed,  1 Mar 2023 21:15:11 +0530
Message-Id: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:208:1::46) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU2PR04MB9129:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c06c457-98c9-4cc0-207f-08db1a6c055d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F7fQzVeL5uSmDLYzubH6iSgCTHl8plEl79VxGihLdCkE8qAeBsl3zherOWEmxdebvT1teXRNRljKkZ/IYQztLtIKtiZENzwtoHVTs89l3XhmRzTanOkH94yWlSVcbdW8IYEjGFVyhK0dGEOrfv0Z9n5qQwFprPLQr80YpTarJTtzcaN9WzpUM42QD5h5O1Gb79HDoq/m+rabARk1BSw7umCIx0ZKbadlIdG7Z/IsNhSf7l/CJkwwVDjdZfLfiIWwtMFgdtu2EvC8gxyxcxVzEp36YdWXI5o3ynSZ5/IYa21fDvbLfh7WGsh9SiD1HOPWqA6biBwrQlL/7Vgvl5ZaB+OInCY57DI+bCdMARPstVUD2uXvAsAatWA1IxhyZxI9LUDuI/nayurOW12rpsHr+E+FYoQ6fudjESi75/NPvBj4isYrpG/98liqeCUc0CvcEsTROzqZiTojWGpv1XZcpZOE9dubzwkHnbWKAI+2CMkYy6TpLRIIb/BguI1lHdVwOaGy/6SKAe1J7RfX365caojY0xWOa/9x5PWM2fVE7JQ3LmXOZkxPrVYWqcon4X5yTL7LoNFHOWQljEs7ysMPFmGLQQUtNipewewtPY3I603N9lNyzJeGQw5YyKjyZ3rEoRyfSG1XuaoYLZGhHED6+pbZ2HPtFVsEt97OmLaCCiQWNLKdyflyee31Qf+TLElGuzOekT+CWpvjx88ZwPtUhi+6AHqyLeBHqWhyp7RO6bg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199018)(38350700002)(38100700002)(921005)(41300700001)(86362001)(4326008)(8676002)(36756003)(2906002)(5660300002)(66476007)(8936002)(66946007)(66556008)(7416002)(52116002)(186003)(6506007)(1076003)(6512007)(83380400001)(2616005)(26005)(316002)(478600001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vLz7h5KmG8YufBDfYLKlSLBGDCNHROSSQ4Ogd8KeXRdDVJtBC9V5TjlBtFnT?=
 =?us-ascii?Q?qRPAdl5g7LqhbkbPzlLLqADDOHrwa3URg5x9kov36iRYMFVz7EXQanpFHnej?=
 =?us-ascii?Q?pPyOuQJDuBFaCjwx2/9ghHiwmD9P7IFFpTZZYF0q2k4EfGBK8AqpU84s4HSl?=
 =?us-ascii?Q?srxJjtqQ1YEm1ulCB46LHu2MlQhNqyki2FJ65NEq286Mzzk7GRXT5Hmbsf+5?=
 =?us-ascii?Q?ef00ERQBpyTCKbs+TH7wKuBZ8t2vNPSpk3uIm6/cypYRuVNWIk9rfqN7bJlK?=
 =?us-ascii?Q?fB1HtTYzIjXteYUm3+yw/43a0bakThyF1Od+OxGjbnbPgXIxQ+pQQN6/yNbh?=
 =?us-ascii?Q?H6xxdepTorMhhmicgKaIUVbsUT2v+3xcNY9nOTvT551opm6kfRr5WmuAmjNV?=
 =?us-ascii?Q?I6ZWqeTg75h+Qi6gw8YDZjVIAS5qdwmwraAO1MFSl9GnwiuVJduxmxqVpmVt?=
 =?us-ascii?Q?EZiY+os409Cj93xEr4ct8eVMD5qjbETTiAxq9kVQqwWLmJ1ussIbBQrXlf5L?=
 =?us-ascii?Q?oBnZX1wR66G38j34tHc1Y+CCwIHdTRifEolquQtvzW51EWYCj3dOo5mwMojz?=
 =?us-ascii?Q?HcyRfopVi0SYFpIx9BQsyN4tqfpc6ihgNnMs73YXE5PmnUWy5LMJI2gRHo3C?=
 =?us-ascii?Q?dTwUvGdQhiYWKxIyJV8pELechpeQUbJXOLHd30hMOXLqhKkKAAMLFdaT07i2?=
 =?us-ascii?Q?zm+YUX0oOnV3XJCM+s3AvZQm+W9Wgib6BKW0NaJss6MvBzLQMVun4//kgMBt?=
 =?us-ascii?Q?k9utzi1Q98woGPqXgZtXKxhyvBSzXKaR558q9QwcflSjFFJa7YuRQ0LqtSMA?=
 =?us-ascii?Q?d8obqhXgxLcIbFFs1qY/5E5Q80Vf4Sy+P6fNoGrEEqgsb9dq3RNo5blvB03r?=
 =?us-ascii?Q?VNtYM1DAOo77Jqf9dcSih/zjLww3ULnGi+iAQseJrGgW9DQcpyd8Msg145f3?=
 =?us-ascii?Q?LguJhEwo68upmLzOGsZgQ98iKy4tEkQSlU1/P4+KqYg5WOk8HnW6bklWvU21?=
 =?us-ascii?Q?26Pz8Tc3jlDXrG7OpGZjmGJwE8bcmvv4abNmZlSGLl6tipzyIMQ9DLCe0Lmn?=
 =?us-ascii?Q?iWwefBGAkkcETNIXTI1w2i9jmoxo7PZDPdXSAJTHLhz+P190/bKIALBsxKTu?=
 =?us-ascii?Q?8DOaCRrFVoLZJBIGkgolrNgojbXC1wvb/DXYB+g9kRrYMGrXUP3QaZKJD/XY?=
 =?us-ascii?Q?jAAffhdbfmMMYINCd8ZgP+gh/vhSfwvS8q+eGVkwneQe+XrFZtNXA5jIPFJh?=
 =?us-ascii?Q?QwfvLHDt20occHvwURaH9RRHx0+YEjtBmCoMyvUdzBJVKBfMlsRzehUfjSTb?=
 =?us-ascii?Q?+RPnNQ/fgtQ0Ll2B7zxk21nB7Z5VCiSsw/PzqY9ShjaNZvVz3fSkh1lsOv8o?=
 =?us-ascii?Q?Y0+yIC4xBc75xjgla3yzp3GxOPA35Vq0kDo3cCMMn9bM32SghBPHkaoBx5nD?=
 =?us-ascii?Q?y9QyzZrYEK49k33C3y4P5zcNkcf8mtOXtWcpr84jQ6lOcaCVRqFetnuo51pv?=
 =?us-ascii?Q?wjOxCo64nFSlbpM5S/mE91oSsvDxcQzm6Po1qBmr6/HbZYr81vwsFlh9TGN1?=
 =?us-ascii?Q?DuftK9etiHx75FjFEJ+tTymKwU0hK19IAZk43xHJQxG2JQG+HFNRYilTluoO?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c06c457-98c9-4cc0-207f-08db1a6c055d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 15:45:45.4804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9CSuNc/FihYBEm82/tj4Xo+7SdNIXx/IoGKHD1GY7laHJWAxPGbMkxgSbDPVMXux4FrKFOHzovfqLrh1fuvRQmhsJD5PvPBkPabpO3+RKd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9129
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a driver for NXP bluetooth chipsets.

The driver is based on H4 protocol, and uses serdev APIs. It supports host
to chip power save feature, which is signalled by the host by asserting
break over UART TX lines, to put the chip into sleep state.

To support this feature, break_ctl has also been added to serdev-tty along
with a new serdev API serdev_device_break_ctl().

This driver is capable of downloading firmware into the chip over UART.

The document specifying device tree bindings for this driver is also
included in this patch series.

Neeraj Sanjay Kale (3):
  serdev: Add method to assert break signal over tty UART port
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../net/bluetooth/nxp,88w8987-bt.yaml         |   46 +
 MAINTAINERS                                   |    7 +
 drivers/bluetooth/Kconfig                     |   11 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1317 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   11 +
 drivers/tty/serdev/serdev-ttyport.c           |   17 +
 include/linux/serdev.h                        |    6 +
 8 files changed, 1416 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

