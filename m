Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D545D5B5102
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiIKUDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiIKUDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:01 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9362A27FD5;
        Sun, 11 Sep 2022 13:02:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1qUK32mcbroVbEu4tB9jIkg81zedsp9posPpZm7tHnlejrOo39c9eStHGQcM+SR5jfTixoXksj7wtvAdoWRd8WuirnNupKE53zWTxI1Xbvk0CdJRwpQlRV1bKm2dcQ7aqr4j5s/2b/yuU2bRdbp6Had8TaXYxQ7AWtxOZndxETlCHRcyqvEEgUEMCJHUo8w6wUOsoVsN9sq0fp816r70iaLi+4bNVMAG5dLIww92Cgrn89Wc92ixW0dXqRDAVoZItPe4UOgFny1S1GPVLgX8alK2yymbXOlf7ima2pq/kb556IG2DDDd6/TzcwWjjryG/YyUYKM5lavjBKkV4CQaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cpV1VI71HSvQ3UxMzcGqUWKgFE+DOfcGIORDFEjBvI=;
 b=AgET5Xq8je/A3owY/l5X7JIvMkhNV7CJ0U2Z+x7fyDMBuaJyrbdHJGk3GJ6XkPiGH9VHwWFAZLMeei21nWFFfPO3ZXgKitefYxQUCXTSnLqIm3x8+gNUk8dRk4c2qW/hP0B0sLCAfC+klj382Oa6ZGqfbfBs0BY6iSi0NzPzc7bSsFKu+5smrLRF7pfNlqeh+suINpSE8cf/nGIsFVAx3HvfxUZOtZtfDRbIV9ooYKDk63fF9umElhDk88ltCgyS3tfNYJnPwCX+ZkN0ylMmxWrNHa38bZNCR4oi5G0XB3KSq4Ov4a8sLOLQYKgaXwvp0IYTblLGq1hADM0CXs8P1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cpV1VI71HSvQ3UxMzcGqUWKgFE+DOfcGIORDFEjBvI=;
 b=x3Fy00xgx0CyB9qT1bPMRhEKRPMNXXG5q5fno6QTOJjW5g/eT+Fa6FVeXCoGveUq+SZUgJEWF5zuN08ARt6tjdEG690RYFnLvCq95NsgTMidS8SMldkqFepDXKgIhUHDLuTnVVIuKjiwcHogSPyuMahPYUQtIZeHynT3iu0sIVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:02:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:02:54 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 0/8] add support for the the vsc7512 internal copper phys
Date:   Sun, 11 Sep 2022 13:02:36 -0700
Message-Id: <20220911200244.549029-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91aa36e2-9410-459b-f8bf-08da94309d35
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fGGQnFNuDNRKhHjdK9yU1vDA0aEXF8AVSb1iqJIN75ZWxMq1WpnC0vck/CmhZYS/3edjw87ZS4cE7uOD5HywDGGYxQbpHFebNjnw+4pWs6wXMbldV+VR1Il01ASA75ekaqyV8+3jc0teIHMmmEct8L1akSNHZ92Xn4zptDPmGMTyfx4zJnSdBYy31+1sEx8STLJsmvRmVusgDGT7PY8fBS1ylMCWvaDx6M2CHAas2x9Yw9wpr5isHCa9MH+I2R9YSmM3Swq2Minn0aYWUSOFSwycPh/XZ9BKttkc8SBeJtWAKa3ocKZ8xMwiCO7lPDn8HRn/t6wn72NhNBX1Xgfk+EbkzgQyszwJGAWvN9s5ECLnu4MbAHa8HR90eqLwuoZmN6RaqqNmBDhA3M1qKwflfk5g3j6/W0uhjFm+BLqSEu9M9LrQ49dLhceh+k1M4diinUChfvLgdMrWKrRW2MszcRHKuprKY2ewuApTNtnpmW+4kAY2H5kWlTHq11EHib+ra+Gv4fhHCVrO0zOzBsIf2KaurCGYa38tbD22pDd3OFmOri7F4FglF1emYhC0/9YlGBlbcLJRom4cJwQtjRAHjoXZYynDg5cG1lx38BdolSHQ2yxYIudLnv0MLEDwVUii6MvjLoL2deMpsQ5QT7SFLk92UCQv4NycNj0GXNmEth6Awe2FxboF+9PmkfxCd1YLXNVgBOlRNbxSfpyqrKFQ5Fz2ExgwbBI5fYTIbJRq2WHzDl+qoWszDsRQutjwOAvbpVSNlT5MzweiosAq/CUhTrtP9kZnBmH0968e4rCmfwE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(966005)(6486002)(6666004)(26005)(316002)(54906003)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QvNSfRKIYeqtbRcwZGmDMUNTiG7MriIm9+OjjA0d37xwXCxaTkS6xFK2hVC4?=
 =?us-ascii?Q?EAZ4ewORHqfg8llhBtfPJTBsl03gE5GawockKB4hMi+9KjOqunS28GTFjY/5?=
 =?us-ascii?Q?52MFfIos44xIciMl0mQ7RtEqc3KPfe03SafHPCseIoQmV44akiG4PrJuf67p?=
 =?us-ascii?Q?J3TbGvjngni12IPCj2NyLL5I5+z7kLOp8fCnMoVVqlY7iMkVo5ISu4BNi8/J?=
 =?us-ascii?Q?HX0mMdp99O4S+iwgQ+tGKvaN6Ko+gynyw7nTjx63gXKerhgD0i6W03NLsTVL?=
 =?us-ascii?Q?2Icd6+LGzDlv6ciEnrrv+vREMSR3BINXnqm15c+qSDppeE0H4Qy0/YxlUfs6?=
 =?us-ascii?Q?q80Lb37wrtMhMbLle8Jjvow3R9wnSMxHlWkE4oYrZj7TsLoBbVOzTh4FpeLd?=
 =?us-ascii?Q?i1pnXf5Ul5RfIklzs9Vb96Z+mkNjWWphyeQW7Jov/ryki2monLvRLopm9eYM?=
 =?us-ascii?Q?hrCVwEaErWQDeKAsi4z6h0M/ooJXYY8ckfRuVPGN3uUsO9+AZzwYE7dhBUUe?=
 =?us-ascii?Q?emgkkVZkEnq7AxbjctRT6/rqJx74j+Em0Z0ipoo+ikSvjHGqTzj9RQ87fixB?=
 =?us-ascii?Q?t591Xli4I9FTGDPPMfTX99Nx//1KuM46xA/uFLngjS/+6046pK9fMFgq5pW9?=
 =?us-ascii?Q?B6e1CQdcjGJHIlSuDn93bcovNSuhTAxLb9yPnuW+YUZerKtxW2ECO4HcdEsx?=
 =?us-ascii?Q?DSdz2KHzQgtzZ/dJPZwI2iymY34CIPa+Of+w3MI/JGxqE/Gv4t/4MidwxjfQ?=
 =?us-ascii?Q?Q7O8XzCgW5HcMY8W9gyVZ1MxXiCjrZQ9O3MlSqcvyKO/QmKnMVoXHMmXGDrW?=
 =?us-ascii?Q?mxdNucpu6HHvl1iO3bQlFv1wP6RdfCIYhkrvbckTmkoGetVKqzjxGRvy63yz?=
 =?us-ascii?Q?qNlje7PF0d6WNbX+PBRwlQ7Mmfd8kcIGaWagKbOcOPI2PdFYeUbGpzjt8AVc?=
 =?us-ascii?Q?2dqkeC5WLqIa7QEx66AQKlzVlC4jrFoswSwASOvU2HKzfrl7o494nqUpumgW?=
 =?us-ascii?Q?NP2RXJLhvJPoEaZ2/8X7yTJD95zwVbpD4QyzkOE+FLGs84IuuS6EDrnJULR8?=
 =?us-ascii?Q?hoekMHPM1aLP5X4rgjk7qnNs7Y6PuVrfDCDj/FBT2MguCsT63QkCeX+gaceT?=
 =?us-ascii?Q?+cZxLEV6QCyLnSD/rgDU4ouiFUhK1m/6cAmv1vfR7XTGccIrB1nm5keEJt+j?=
 =?us-ascii?Q?b/M7smnH5B/30V20EL8LJoYjRRen5/zslm5+p/+dkQWsNp0x/BC0iMsSVSBE?=
 =?us-ascii?Q?RbKWScMi7Rk0Ta9czxhNiVpq9SYcZ5/jedZ11re/OlDAkGz1mU7/ONoojLih?=
 =?us-ascii?Q?igkq6sTJ7E4WLJrpLI2KQxiHXjph2obbIx4rh61CU2j6tQ/nk3C2aq0b2JvI?=
 =?us-ascii?Q?5+NnNVYJWqoArz4Xh74e+ONk8IXUlg5Bwqlg3CcOdmUflZ6vwbwmHZl77SLL?=
 =?us-ascii?Q?bnae54KaLFrymRoPy2WplVJDw45JlNfoa7ff6JpaKDSHhmInhf2xmPcWezCj?=
 =?us-ascii?Q?IYSrbLaTTB1EsImyvwIRgol0Qccd5tbUMtqQdMZ0Fx5SHy/VSWZFKvIudRGg?=
 =?us-ascii?Q?rbCyHtp+b/GZ2AOOL6JdKQPL9VnQj9SA/DapICThcUjWKbnE//hDAPkd1JK8?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91aa36e2-9410-459b-f8bf-08da94309d35
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:54.5434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DjWe8+Glm47h53Ddm/X3FSyGjZdMj9S4cR9HEAsgbjpESZO3NNEOcBXN6GnJNApq3RpE3SQY/eImd1YKg3U+GXAjWItuheRLm3KIycQDO6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is a continuation to add support for the VSC7512:
https://patchwork.kernel.org/project/netdevbpf/list/?series=674168&state=*

That series added the framework and initial functionality for the
VSC7512 chip. Several of these patches grew during the initial
development of the framework, which is why v1 will include changelogs.
It was during v9 of that original MFD patch set that these were dropped.

With that out of the way, the VSC7512 is mainly a subset of the VSC7514
chip. The 7512 lacks an internal MIPS processor, but otherwise many of
the register definitions are identical. That is why several of these
patches are simply to expose common resources from
drivers/net/ethernet/mscc/*.

This patch only adds support for the first four ports (swp0-swp3). The
remaining ports require more significant changes to the felix driver,
and will be handled in the future.

Lastly, this patch set currently won't apply cleanly to net-next, as it
requires a sync with the MFD tree. This is being sent as an RFC, and
additional changes (e.g. documentation) will be required, so I expect
this won't be ready to become a PATCH until the next version (v6.2)


v1 (from RFC v8 suggested above):
    * Utilize the MFD framework for creating regmaps, as well as
      dev_get_regmap() (patches 7 and 8 of this series)

Colin Foster (8):
  net: mscc: ocelot: expose ocelot wm functions
  net: mscc: ocelot: expose regfield definition to be used by other
    drivers
  net: mscc: ocelot: expose stats layout definition to be used by other
    drivers
  net: mscc: ocelot: expose vcap_props structure
  net: dsa: felix: add configurable device quirks
  net: dsa: felix: populate mac_capabilities for all ports
  mfd: ocelot: add regmaps for ocelot_ext
  net: dsa: ocelot: add external ocelot switch control

 drivers/mfd/ocelot-core.c                  |  91 +++++++-
 drivers/net/dsa/ocelot/Kconfig             |  14 ++
 drivers/net/dsa/ocelot/Makefile            |   5 +
 drivers/net/dsa/ocelot/felix.c             |  10 +-
 drivers/net/dsa/ocelot/felix.h             |   1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   1 +
 drivers/net/dsa/ocelot/ocelot_ext.c        | 254 +++++++++++++++++++++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   1 +
 drivers/net/ethernet/mscc/ocelot_devlink.c |  31 +++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 137 +----------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 108 +++++++++
 include/linux/mfd/ocelot.h                 |   5 +
 include/soc/mscc/ocelot.h                  |   7 +
 include/soc/mscc/vsc7514_regs.h            |   6 +
 14 files changed, 529 insertions(+), 142 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c

-- 
2.25.1

