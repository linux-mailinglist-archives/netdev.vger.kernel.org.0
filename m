Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9737D4D5FF4
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbiCKKom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbiCKKoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2114.outbound.protection.outlook.com [40.107.237.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5713A14EF5A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUnU8IFiBJvdLZr7OrK4Ap/s90MSrEMO90aDeUilt5Fvj65EHfgHI5H/pK9SnOIEuUCUnEo1AtSBE+26/HP9xgLqIQhZDEZFN6SRks/pU/gwiQejHOZXf3/OAwrLnCEp2gduQT+kSmOMcYhaStVlWQe9DI6FawY68n7Q4TszDeBgV39cnuaheK4vvYWvdt0uuRcBOfE2KsYWQdfTS3PntTOubXdxFeqtKnGM1mE42b3rF/13QJZNEMG2XZvmDsu3tO0EZV43Pad4yfpp5dpHwmVVIwBBVxW6VSUXxqtKcgWDElvgeDqV0mZQn7Z4AicPZvGdIhezgHsUpZgLiOrzjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRPNbz7RkC3rn7mAsRMdKlq/yUo2It7OWCfpDDp1R0E=;
 b=NH+wvzl0wskDcK3KtYCi/RnedGF345axD2LJURCEPMFLi0z8dv0lR3CgVQFM51Tyqo1/zhr1VbjWF/bxYVuuiXaUXOJSy7ldnsBVYjFxXER8MNhdvFFOcGQrxDJE6XMQTy42amrsd4VXwgZ7LWE0rhfg/zzq6q5cIvagyeIp6Y45/93d60SNxsLfShAysf5kGUkRgPXbmZAVVCkQqqiPQnc3bu59lhBBGiDZjf5BrcYdMcVcBkFj/4JynD+8wwArUpyUgr1pTCoYNwKLdD6Ppbji7llWxQTaLP3UOh1NYDCX6ftzFvhYtExs41FSmAWuQMyYPr76JWlu53FD9/EydQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRPNbz7RkC3rn7mAsRMdKlq/yUo2It7OWCfpDDp1R0E=;
 b=wU+9RJo9vHhfZ8RRG9noyc6MxaJ5L/pTFjGDFBFAjlxMd3omJVhH1+m7zGtm07P43/+PFVNhNu6tWHBqCLkjylrKR/Ags0klsEapy6Xf6J1ETYvnGwQhesvk1Mc2/vO0h5qbJOmNl9sMURSSav5de0/GdZWQmRel9BeVcHXDH8s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1184.namprd13.prod.outlook.com (2603:10b6:300:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.8; Fri, 11 Mar
 2022 10:43:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 0/11] nfp: preliminary support for NFP-3800
Date:   Fri, 11 Mar 2022 11:42:55 +0100
Message-Id: <20220311104306.28357-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f026f3b4-dde9-40ce-ffe3-08da034bf660
X-MS-TrafficTypeDiagnostic: MWHPR13MB1184:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB11845F632EE35CB9DBB775A0E80C9@MWHPR13MB1184.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x3q/dSgIPu2TBhDQrpAX3SGxPCTGMUCTN8Zj9aARjzrMejswIe7FalZlHX6mggPKeBG0+DwarpiPjRvVrFF9uLkXaQVCs8UOoKTMEgrj35NIGRHSdaDnoJ/4b0Ypcz8WwWQ3UEO+j7b52CAfJ52N9CnpAd0ge6KyYJWhP2QLiBfHUYOgMy2K1u6pDPYaTozmoCS1KXxlp/A1MyYJborGWVqVvp5w0tw4WIz8VNg8YxIXJpztS7sT/jbuuRUn8k6sukvq6+CSWgL2+VeIdG773b7ERqDPNcKAY4y0gCJi/+WUb3EPP7Tc37t8xKNFq5ST+bypWA+eDrM1TVOtStc/hPp1WptrN8aDBR7Ammak9SYaWzdxIhkv/MOmbPL0y+fN4gzfIQPFb7GgCMey6JrZR6nvdHniXxVPAOV5xLLl+LePaISF8/mq6/sgfdOJqFkIa0mPs+V2Ha7YwichrWntXrMippkk7wtdt/qRXijqN0G6QIgMjoOSbcPznOsoHE+K0P6Ed4GK28EgUuQ8rSoZM2eXp5zy2X+NmWMca85v+9voAPhFq708cj1WW+C8/qQhnpAKOIo5/SrvRlAaZgJqosOTSv9WdfsJ5MjWlYJX/tdnVpvFXPaVmtqRBS5+OzyaDz/wBPQMbHBabxKZlW+tXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(376002)(346002)(39840400004)(136003)(36756003)(5660300002)(2906002)(44832011)(66556008)(8936002)(66946007)(6486002)(110136005)(86362001)(316002)(508600001)(6666004)(2616005)(1076003)(186003)(38100700002)(52116002)(6506007)(6512007)(4326008)(8676002)(66476007)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YEEWj3UxtemBGRYzKgT1H6AWVoSCeZ2owezkNBr16oE8rTICDBrX5UBWMV/k?=
 =?us-ascii?Q?vmlW9jwsOFFnAGMuiT4kCHmF5Q/GNn3b5nqsDIGEQyrkT/zHk2sYhJTih6iG?=
 =?us-ascii?Q?eJxkSvO6IPnv1mN4JrK9uYjpcJ1FBOntKg+MoPdPzwlYHbcptUBtoldII4ex?=
 =?us-ascii?Q?vUWsAS8JPFPejZvFl5pWIB/5lJ+Kc3tnHaoLSDXgvZE/lz91QvISmtHsvnLX?=
 =?us-ascii?Q?BWaQJyDe3aXDYn5JfdEninkLH4KW+u5cWsBPA86JAlTYTCE7ralYw7L2K4US?=
 =?us-ascii?Q?mBRnB4dPIyUdnplUALDJ8rSgn+0TvhSLfvjGC1MLq6tB21t9UDt7+IzxOwa1?=
 =?us-ascii?Q?R1FBeRj1kCfO9sgEjRe0Wm8xeN3AIoS+E+DxJzKcJ2bogoB/zYHX4LVfVGFs?=
 =?us-ascii?Q?PPZhq2DF51OgYo2ZT2R7CgTY8DbMgq/VxtlK5iofXsQVplGiit/sjxxAm8/r?=
 =?us-ascii?Q?aEjmH0UbW6jn0CKEbiBej5C+QEeOBuZt87lERc2Qa9SV6cUAk66IXbHyLbCv?=
 =?us-ascii?Q?bCIJNAx0LWgrBk0quUHburUFNEgpmY+V52VdBto1++TQhehBLpsk+9r+8tUx?=
 =?us-ascii?Q?e7/6NPyDHacGoAyozrxhI40KSuRcKhJ4AoYS/h3dnL9dzBPC8u9Fim+l1ArQ?=
 =?us-ascii?Q?NdNZJk504yfRAlcTTt8wvsZApl7OXenJ1eXRxfGeXMJ1FUoIVWBKfAiMoLim?=
 =?us-ascii?Q?dErbTG0jXWHJNf6U+55zszAT4Y885BzLiAxIJQuJgPmLz0T/fsC0ZzjZG9QI?=
 =?us-ascii?Q?64Blc3A3jytbG+peJi3qrKXzSSgVDGp7Wr15sTVvpJ+Idb7VU3ig7dV1hJVK?=
 =?us-ascii?Q?VIIF96JFI/35z8y9VG9qPePhxOjEmwNjIKXb/y0ZfOhfuy8R1r4PnAtfW2Kc?=
 =?us-ascii?Q?47aIQNBcHytEmxv9HUL+sZtLhPogprt9iq4cbf8D8kovLUpG2ZdXkepUM0Qa?=
 =?us-ascii?Q?WOTbVwpu0R4G0rSYJj0qywAJuxmjJsrOMYZAtMdnkJf98uZrX8+NkSx4vHKp?=
 =?us-ascii?Q?evquyG6EAemnW5ytEXEJLjFHFsv5kJ/tsmqlzfAXQ6+HOcU9P2paLyQvxP5j?=
 =?us-ascii?Q?WDGutoHQ1ZMMs+ATYT3iy8sUlPWslra1ZlRExNNIsoA47bM2LJ8AU/CfXleG?=
 =?us-ascii?Q?6Xf+iavha/EL399/gkQ3VuG/Ycp9hT28cHhFXRa7rzbnaH6FmCvUsewzKKhc?=
 =?us-ascii?Q?0u8sjMOQT9NCiCKQJfRrMQS/dkxKdvCplXVOcAGBfIQpf2Ws5/CwQwRLFnGH?=
 =?us-ascii?Q?bYURsGLrBGrQ67birv9xLg+MTr+ZhxrzpheVVYw9BtSsnkJ3ANmkM+9nuSnf?=
 =?us-ascii?Q?lqrNG2tdb3GGbEmBC8lXiUgmYimzBmrx1XUNUJBXqZ8pGr1CO9e1yeTV6LHR?=
 =?us-ascii?Q?I/NyykuKmNnaf84iKVuvsFDV4MOEf1awd0AXSzq/pthAOpXEvRTU/rcAp8e6?=
 =?us-ascii?Q?J/tF39GqMXuMDkkxBsaMPilmdpnskWF+5wBevLQ8tBcpFG+VwSd8lBAknPyq?=
 =?us-ascii?Q?M6dIICzjeHXDcd15blZx81/LyjDwIRHQgk7i1b0xhMZWws69eNwIEqjKag?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f026f3b4-dde9-40ce-ffe3-08da034bf660
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:21.8422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSDn7pRoB9W2WZwgvkYfA09RrnYTQx3ZB+hLTPsWFQTUu5b/ZsHu9a66OVRzhuI0g44OH/Ibblu2z+qovfz5puNO7KvD2vcVl/Dv3Jcv0pA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1184
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is the first step to add support to the NFP driver for the
new NFP-3800 device. In this first series the goal is to clean
up small issues found while adding support for the new device, prepare
an abstraction of the differences between the already supported devices
and the new Kestrel device and add the new PCI ID.

* Patch 1/11 and 2/11 starts by removing some dead code and incorrect
  assumptions found while working Kestrel support. Patch 3/11, 4/11 and
  5/11 cleans up and prepares for adding the new PCI ID for Kestrel.
* Patches 6/11, 7/11, 8/11, 9/11, 10/11 adds, plumb and populates a device
   information structure to abstract the differences between the existed
   supported devices (NFP-4000, NFP-5000 and NFP-6000) and the
   new device (NFP3800).
* Finally patch 11/11 adds the new PCI ID for Kestrel.

More work is needed to drive the new NFP-3800 device after this first
batch of patches the foundation is prepared for the follow up work.

Thanks to the work of all those who contributed to this work.

Christo du Toit (1):
  nfp: remove pessimistic NFP_QCP_MAX_ADD limits

Dirk van der Merwe (3):
  nfp: use PCI_DEVICE_ID_NETRONOME_NFP6000_VF for VFs instead
  nfp: use PluDevice register for model for non-NFP6000 chips
  nfp: add support for NFP3800/NFP3803 PCIe devices

Jakub Kicinski (7):
  nfp: remove defines for unused control bits
  nfp: sort the device ID tables
  nfp: introduce dev_info static chip data
  nfp: use dev_info for PCIe config space BAR offsets
  nfp: use dev_info for the DMA mask
  nfp: parametrize QCP offset/size using dev_info
  nfp: take chip version into account for ring sizes

 drivers/net/ethernet/netronome/nfp/Makefile   |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 24 ++++++---
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  2 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  | 52 ++++---------------
 .../ethernet/netronome/nfp/nfp_net_common.c   | 12 ++++-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  1 -
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 14 +++--
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  8 +--
 .../ethernet/netronome/nfp/nfp_netvf_main.c   | 23 +++++---
 .../netronome/nfp/nfpcore/nfp6000_pcie.c      | 29 +++++------
 .../netronome/nfp/nfpcore/nfp6000_pcie.h      |  3 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_cpp.h  |  4 --
 .../netronome/nfp/nfpcore/nfp_cpplib.c        |  9 +++-
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.c  | 49 +++++++++++++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_dev.h  | 34 ++++++++++++
 include/linux/pci_ids.h                       |  2 +
 16 files changed, 176 insertions(+), 91 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h

-- 
2.30.2

