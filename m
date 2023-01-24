Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B806367A064
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbjAXRsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbjAXRsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:48:05 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BB536FC6;
        Tue, 24 Jan 2023 09:48:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUDEA8Lxt/rOu1BtbgKH5Hm6/He2AaZIqC78r/Sbay0myuz6fLooBjugxwHcIi5Vgaj1LB70vTVGX21P2gMi945eJMmpSwQCs18g3Ue4QdzVrgibucBJawfDO8tfSNWnlVR/Ad5TCRVkWsbtEkgdvvrJnmLH3LWeVxUPVOhRXIga6/tDKfbghmeGox8dwFCHKZY1kEhF51AbZ9D7WH9lMBZ17vm5IldVpKozHNv+KWgJwn7+gDYmgIyBoMYigVthsd2W6cgO5S7pPA96SiaAJtZo4xijvyhrXRMsMlO/jZ+peZNALyDWotY63MbQmK+4b2drHfPS/oMpf/2CqyQvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQ3b2QLhz7WRUQJs4C8t3KFBNDEodREWIhI58Em3PYI=;
 b=lyfCntKQn3yRiGhxe4mDbN5Rvemju+n34JPDGGSrflViqCnMZP1affLE8eA5PUIXu0aDtseK9hHsdauLDUXC0CptDcZztu4tcoxlt9T8RO/t4uetK7vR6UzWYj2FyozdYOk8p5V9Qcat90fvIY5IBWZtDVYxfQQLPoRKd3my4w1BmNuCdapi2m0g3TOMjcTWEZvG81KT+z4Ez62eKqj8eNkSgzkRWb3hnm90Czsnn/AuLqZSxH5M+cWogC6j20/zFDCyfGcy+G6yhpLqG+4vkbCW7m+W6Poo7ihMiJcIOTmP68BH7rVvyKrRpCumvR8ICP7E1GqFFC2q7JVST536XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQ3b2QLhz7WRUQJs4C8t3KFBNDEodREWIhI58Em3PYI=;
 b=jpOgMfUy13DngAecsIL9eEk54ly8Ddr8RnKPtAZNVv63NqY4h88/2PtT72paPhrTGFa7OTS3YFUCbIhPfHo17izpMH4K3jqZQv7mGMYA/4+3Y9qEFGdIEGteK4Wj1/brbsg1wIX4I4Me4IWfzo3/ZbeiYBFB8v+hjmeL/IcJqvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AM0PR04MB7026.eurprd04.prod.outlook.com (2603:10a6:208:192::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Tue, 24 Jan
 2023 17:48:01 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%5]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 17:48:01 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v1 0/3] Add support for NXP bluetooth chipsets
Date:   Tue, 24 Jan 2023 23:17:11 +0530
Message-Id: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:194::12) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|AM0PR04MB7026:EE_
X-MS-Office365-Filtering-Correlation-Id: b1087160-f287-49f3-22cd-08dafe332330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P86tX+e0bNQ0DuxU5Q1v5BQaqOtloS7H/z2NZsiHvvcPmpzdqPFnZdZj0+KmeGgeFzgYMqSxUlmNIaaXNA53EOA79dogn4ZAKV19KZP4XwIoxqpOT/HYIsTzrUR2jolCOBWPBlaEiioCjJEEa+7uf2ktrRk9Xf3BV8LPeMf74IbEOt95XFZmKEAVFJyuBwJLJIScycdsfECPZJEkTqrtuiRleDWSwIOHdJADJtYNYZ/83QuQYKBlb+qckVB7oYkqStBaDQEcAWmjEZy9ug970/K0DNGzK2gcKJiG4ERdqnwyVrxszjYtelcYyS9gBk2VImPtsitOPZQi2p//0qwgfMRyxu1FsQthZkt4wmkaOEcCmpGkJux6wAAGhGpyBn7PI6ZxqKh4sAIWTC6FhzbY5IugN4+TB61CdbONIizNfsgv4e3aMaq7C+pIUTXu1rJ+Y8jeAR501ZXI0kjMyjSU19px3UrwECz2pvLNO+UKIhLUZTdAHs0Q+jGSVd/4ckXz2HyiBfCq2D5KXveOH2/K0E4Ix8FndmsIEAq286Upl+YBUDpqq3TUOgIIuSIm+agQd1a78pSrXBIAF9Csp0/U8IEjfqqkMSGoRyPHE2EeaLEmnGtVaiFxgY8kFd56iOA2yximrsFv1eROR7ckwfeuitKlgcRnmqcuvvpwZbGiqMSPYab7CivEIMUxNkizb7mr7+9aTD9YdI5EzJQXdqRSBywlR/X62UD2orwzyDivzd8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199015)(36756003)(86362001)(921005)(66556008)(66476007)(4326008)(66946007)(2906002)(8936002)(8676002)(5660300002)(7416002)(38350700002)(38100700002)(6666004)(52116002)(316002)(478600001)(6486002)(41300700001)(6506007)(26005)(83380400001)(2616005)(1076003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GWbxvnBeEpmDUnJ6ApW5VcSx7ILJZsSbmqw9Aqc6NS8sAjBxDgYB7IlqJ+gB?=
 =?us-ascii?Q?KmmA6QcfOBQFtjsglxUdlVnQnIiFEsBk+Dqz4wy+swdMqJdU5ADjNTFLqL0A?=
 =?us-ascii?Q?F5s2p6z+ByLxRF0FrvAsd5cZgIxU0V1UonHxu9gO81MyVY5tFkGLEQK/rLuk?=
 =?us-ascii?Q?AAry+MlAROPmrFmGMypiR1cgNtyGbBALSj/025ZBzI4HFh3kqnaZHJFtbPTa?=
 =?us-ascii?Q?Ws533OVHe6ghRuPdEQVill9itMl8NLpoYntQnnj4y3iUWW1wK3F11H8iUz2O?=
 =?us-ascii?Q?YRlHGOnnLks/xK9BG8YkTwN3aLAzzPLnmepl57E+pPc3JieDh8IuwBIhxxZ1?=
 =?us-ascii?Q?YD90Q2pvkIrnNTAsqWUCTWpaxB8encRb3Qb3zTspT64kCsvfdNr+JTbLbNfo?=
 =?us-ascii?Q?aqwpXJ1MK8+TjbsrM47zc/bagaFHfNhHbTZfM0WjUrSex8r9gHkWEiiTuJ0T?=
 =?us-ascii?Q?es36usNEw6EyHaYvmYQucq9dhKozR78X2EXl5h4pK8aplVQ+7ndKgHnzLEO9?=
 =?us-ascii?Q?fVwxiq3Gs4jVvndHexXj9mUwbSZKTp+7XGCJLptrapJatJdYaiJXyjGrMP5f?=
 =?us-ascii?Q?4+9e5m5He57XEEMyd3563BaSqQK8Se4F4SGeYFZjZHMqC2JtENTgEG6vVXZG?=
 =?us-ascii?Q?U7SUUvp3NMR4QONcNbXoP8JGIEGqgR3D+wA/wiv6zodwwbjzTObZcT340A00?=
 =?us-ascii?Q?3JIGI7cB+WzgE9mrajbvxNncu81hjsTigAMIxSedskEsdFwg8CUI5XOudi4A?=
 =?us-ascii?Q?3zD7lUEnhT1nPMS+hQjoGFSn7EEF9vQlltY9y6XS5142/Hpzd7dpVyab9JsF?=
 =?us-ascii?Q?8a0cryS4hRguEDkJz9Izrl37JtGlx0/eB8TG2b/rM0w/S9enkuhycngrX2sb?=
 =?us-ascii?Q?6EqFIxMLg/IuyG0dnH0IDpQ6eAFMYaHZz7Cn1imM46vgh48OK6YWu+4uWyJQ?=
 =?us-ascii?Q?fiu6iuDVGDlwf8lcyjOPV18XVoi5i/OKyWeLfAW76fsHKKrPjwy/3G9lt7zD?=
 =?us-ascii?Q?tZCc7+iM3sAnd+P8e/s1gfNf8WSrna/M4c2dqcgXljIVpGdH6SaTVCX5fRmr?=
 =?us-ascii?Q?ZQOGJVjkTm1sFbE85lTHCUsu1TdgOXxz3M/pUshEDjST9NsxrRZ5LPJgbgxi?=
 =?us-ascii?Q?baMWAAgvTmoAsR2/0VRUzJEcJ36au040eqtG0v09EvtO23/V7/e71Abx5pG4?=
 =?us-ascii?Q?3vu70QqObYqOMrHkyxz0OJMTuuiEFjrKSezVNDGhI1VcCM0tY8S8Awe24N2e?=
 =?us-ascii?Q?16jqOMDS1ncfzHIZi4cSaVbZNb/hoY0KUY6VSlIZ7/+pQWuWtpAWkutXaut0?=
 =?us-ascii?Q?3l0JPkdlHAG1/qYxOFEdnJ53WzY97ETIC942RteRDGPqVeLbV5pGqlhl9CB0?=
 =?us-ascii?Q?Sx9HypJAof3JbpwR5P/Y6rwPENCMyO5S4eApHW+7Q8tDr7+KljqaIz9dJFb7?=
 =?us-ascii?Q?rT+zAofFA4JeZI9z0cMzlqi+U7pnaeuj5obwa7HrTBnHSBxUZ+VaU/bR2NxM?=
 =?us-ascii?Q?ecFLAT1rtlIsJlqW3xy5Il6KBYhjj50OstAjrdBbx6GR5ZwOxoX2HGcq2Pj5?=
 =?us-ascii?Q?LTKJIW+cZNxAbpF295E57gv9jY0SptM4L8LDwJYaUSrtYHVSEcMMxHGP4Cr9?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1087160-f287-49f3-22cd-08dafe332330
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 17:48:01.6939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gmGsVp55DAXbXq4VxqhWhM5Z0gwsyiCHvwAmqQLdO1lnIJlGmlv4TrPGy1N/jA6DDH4EQh4Qyv7M6oFlKfc+8JT2NOHaMuRLTn5ocPPER9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7026
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
The driver is based on H4 protocol, and uses serdev
APIs. It supports host to chip power save feature,
which is signalled by the host by asserting break
over UART TX lines, to put the chip into sleep state.

To support this feature, break_ctl has also been
added to serdev-tty along with a new serdev API
serdev_device_break_ctl().

This driver is capable of downloading chip specific
firmware, where user can either define the firmware
file name in DTS file, or in the user-space config
file. Each chip has a unique bootloader signature,
and the driver is capable of selecting firmware file
based on the signature received.

The document specifying device tree bindings for
this driver is also included in this patch series.

Neeraj Sanjay Kale (3):
  serdev: Add method to assert break
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../bindings/net/bluetooth/nxp-bluetooth.yaml |  45 +
 MAINTAINERS                                   |   6 +
 drivers/bluetooth/Kconfig                     |  11 +
 drivers/bluetooth/Makefile                    |   1 +
 drivers/bluetooth/btnxp.c                     | 947 ++++++++++++++++++
 drivers/bluetooth/btnxp.h                     | 188 ++++
 drivers/tty/serdev/core.c                     |  11 +
 drivers/tty/serdev/serdev-ttyport.c           |  12 +
 include/linux/serdev.h                        |   6 +
 9 files changed, 1227 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
 create mode 100644 drivers/bluetooth/btnxp.c
 create mode 100644 drivers/bluetooth/btnxp.h

-- 
2.34.1

