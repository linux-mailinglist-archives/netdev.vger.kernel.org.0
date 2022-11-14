Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD45628368
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbiKNPCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiKNPCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:02:36 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2113.outbound.protection.outlook.com [40.107.220.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F531EAD7
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:02:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOR3Z4/34zc+tj69MH+uCroKR2yHnKVte5TxeuzAekHP+Oxc9LZTDaYpVSd55JFdv1V8277pNyj5v9cFkXdf4lccyN44cTD16bnEFgZmqD48eWsiPdn9G9i3LKLwkKFKoT8oVSTPOUeVKK3TTF7tiw0GI/vfBopp93gVvpkHIqSvC00iFeKGP9lnhcfBl9+opUESJ5XCEGirYKbMhjfi54JFVnfM+u9RdN/mIwmgOqjzLL3/7SqRNfJ2ZEO59KqqysyUi9JPImW7t+p8Ry+fUtRPNzGSQGs661ta5+kx9GlaNsxJkH0NPpli31ZG8zsuD323uvdlyYJ9hdKXUEp3gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68pixkXslQKn1ZqHrG6QtPgJQijPunw5h84DWISdV7I=;
 b=bmiumssdWb9+IPHlefL0UhUjgfWyaVwm3GtMNrtkOkPJblLPUhC4rEPmLK3mSisJjoVr02JDYiTuzvOoNq9efJ6RcdYvm6Lhc8FKQpcmXEH1jM2rkEBXmj0TFg7Jr6mS05QoeuIbWNlOz2BTE6B9G6DS5ot+DhQ/AjpOuuzcNSdfBvjCMrn53xKPKRZ/3L6ZtaMQ+0mFwAsZnOC3JytL3HnXLu75/2AU8nzi4r/exuh1aXhxLAi9AR0Fd6taz3sG9rskc4nqS6ZxWTIiHFhEHBWCPRHiSFQ8iCsdnQWzOb7A/1KblXY+94PbKUiKKGhWW7QbK0NhNbEaYI94g4AxLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68pixkXslQKn1ZqHrG6QtPgJQijPunw5h84DWISdV7I=;
 b=NJs/TC0kN31jr2llvwZxPoBbWw5RXiDS7hP9jOcliu/GQDzEp3RxG86+6EEdv6tkL724wixRHAcBkL10yzQHZLP4RMyOCOz3GCNsFRFrD/IPppSeZCUXONOVrLmrkA4MVItfjTagW6759wGC0m/J3HIrYbFpMy4m3uhzgXPyETU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3713.namprd13.prod.outlook.com (2603:10b6:a03:220::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 15:02:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:02:26 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Walter Heymans <walter.heymans@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2] Documentation: nfp: update documentation
Date:   Mon, 14 Nov 2022 16:01:29 +0100
Message-Id: <20221114150129.25843-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0302CA0036.eurprd03.prod.outlook.com
 (2603:10a6:205:2::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3713:EE_
X-MS-Office365-Filtering-Correlation-Id: f72cc8a9-01c0-4dd9-ac95-08dac6513e2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQRYsUjM28LZGgOQNcMqzKf4KscYUwQE5/tkeNNk5FZJUXUWzJd5vm75/+BkDZszta41U4bhJi7G1JDv1fNSCM+2noajJoAVtemdfKQnBjLkUJmn69gaoehpYHiN2aALCvor4QlfNK8Hl+dObZEIo8iC5oimyPl0FXhS15W3kDIyNUjT+xQKm3J1Xr8DgN5w8+vAovTXYkswnduiZdEACbzHDTkP8yEJktxo8iqXWYQWx7aQ4+uwfNVODSKJ5NJQTwDvTj9s3BfCzK1Ae+AwPacz+4KeX0ZPcv6uYzfbKbS+xLBQsvqHTEPQR71CH7dy+qH35Ipk71NjKb9kh0icOD/NJMZtn4yt6zwGXAamvV2yciM5wqi9NZXENKdef4sG2VOh8HH2pOasHPV0M8xL7FQexC6/Tn7faroNVfQ7XavJ6kU8Z67QODy2FUR10vjyYLjSeedM85C32HVcKkVfEEBVKYJ0IM4iAj6b3iVDVIJoFW+lJxcp9xFgmKFEYEA4f2zKgvcC1kdoJGj7YakQrrDmjYDXbyn6LuJexYj5LJUaejTQFoUrG8IsSwPWx+JjNSnrKgSzT8azjjst6wgamSlu6eVowyZU7dtxm4nY75swvo40jlm/kD3oROWH0U4NCpy3oa3czVArglCcZtJxxusRXQLmQHplFxIfPCaLzj+kTQF18qPTS8yDcxlz5pUXYMJu34ndpIlxv7sqI6gwOwqJ1XJ/0PH0SseRFkOLSaw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39830400003)(396003)(376002)(136003)(451199015)(15650500001)(44832011)(2906002)(66476007)(66556008)(66946007)(5660300002)(8936002)(4326008)(8676002)(41300700001)(107886003)(6506007)(52116002)(54906003)(36756003)(110136005)(83380400001)(316002)(66574015)(478600001)(6512007)(1076003)(186003)(2616005)(6486002)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUVxTjBFL2dBRlFSZVdNRVNKdFYwZUltRGl0YjdjV2FVS2xucmFtWXFodHk5?=
 =?utf-8?B?ZVpLcTVXelpZcmN3N2RDT0hlS2lLeXA5SXAwQmNlR0dMMXlBb2tGK3hnNUFS?=
 =?utf-8?B?K1pZT3VkbVVIZ2crQTg5WXRUcU5lcGpMcjEyUUdreW9razBIUk9TZUlMTUJO?=
 =?utf-8?B?d1VLZzg2alNUWFkyNk9hdE9VWWRQdjMrb3VGenZuaXlYSE5TVk5aQjVWeDR2?=
 =?utf-8?B?ZVl6aFY2V2tlSjFVOXMwOXVTZmJ1VjJmdzRCakYwd2VIZ1REZVdJR25TWUd3?=
 =?utf-8?B?TS9vQmd1VFNtQ1BKbEovajl4UEE2OTV6YklJKzhhRXhwU3JNS01Ob3gwNGNy?=
 =?utf-8?B?eFdrTEsybVRVRFB3NWFCNVNhZUVyOFB6dGxoSFFraGhsOW5Kc09yRUN4aHlV?=
 =?utf-8?B?b0trL3lDVHBrY0xEWlVLdzhnOGZnaUo4QjEzSDJQOXlBeTAzOVdkMVcrZHUw?=
 =?utf-8?B?WnBqUnQrK1RJdjJzNUgrRDVaY0F2WXVWQzZWRVRxWWtQNjFqMVI2L29NTEdW?=
 =?utf-8?B?VEw4dWtJUElNR241Z1hYamRxYzRvNjNwZ0RHeDlLNDNuRUNTVjJvejJaVnZI?=
 =?utf-8?B?ZW9GU0VVK0w5am1KTWIyenZ0K01qNk0wL093eU1kVEhiUjRwcG5wOC85WGJW?=
 =?utf-8?B?TXlKaSszak9HT3F1R1hvejg3eWZkS05zQTN6VjVobGJsQjU3ZUI3VEdXMi8r?=
 =?utf-8?B?MVZzQmE1YWFUSzRGWkgzSURFSnVGTVc5c0ZSNTRrL2FJSzNRbHlPNXZiV1RW?=
 =?utf-8?B?ZmVsQjY4MWhVR1o0d2ZlTTZzSTVjUUVYeUZxbVBmUUh2WEh4TFhyZS9USzZm?=
 =?utf-8?B?SzB0bUJwbHpvTitXN1cwNGhuYlhwSDJOMEFJRS9kdkYxV0trNldkNlNJZ0lF?=
 =?utf-8?B?ZDBCMUgyc0dqVlJTUkxIWXVTVUJqd1JGTmZkL0RqWURQZlRJN0NicklQWEpw?=
 =?utf-8?B?UFpjUWtOUWlFQmw4a25UWVZyUmxRU2t0TDFyV0JpNHhWR0ZOZkd4WWxTaDNm?=
 =?utf-8?B?bDdDUkd4N3JXY2FvYWNPYWtQMjhCNTZ3SXYrcEdSQnJJMFZnUkZiVFQ4OUdv?=
 =?utf-8?B?d0d5SGR4STdVK0w1RmVvTis0QzQrKzh4bmNGaitlS3NsVXpUd2lXVGMxV2pn?=
 =?utf-8?B?VFhaVjk2MkVCQ1pIWld1Q1Y2cmNaRkV1Zit4VmpaVEdnTmNiWHhEK0lDSm9T?=
 =?utf-8?B?MEtBNG0rcGRWbEtCK0FpTk9MSkFtc2NjeGppUC9ndjJCbkIycElueHR2c1Vt?=
 =?utf-8?B?bmV4QmJ1ZFVPM1cxMVU0bjRNdHdHSzF6eTZ2eUl4aHk4dGpoUmZIQjY5QTFB?=
 =?utf-8?B?cE1Tck9tM3hrT0hDZzU3M3YyNG81R1FGV1g1RUU2ODJEKzBwV0VvbGs4Y2Qw?=
 =?utf-8?B?ckorYnJOdkcxb2V6VzFzV1E3WVAvekVYcDlLRGhxa3dFek1BL1pHTzV6T1pO?=
 =?utf-8?B?cFRycWNvRnBFOWVWRi9taTl0ejQyRFlJeFNUanFieE1WSnlFQ0VRaHloY0FC?=
 =?utf-8?B?TzlFTCtZMDhtZ01nQ2M3VmNQai9NNTZKZnJRNlgxaC9SaWlvbW9jQlM2a0NZ?=
 =?utf-8?B?dTZ6akhUTlFCVDl2OCt5QWZ1MTRjVS9nUkxJbE1Uem9ZU0R5UEFqbGkyOEw5?=
 =?utf-8?B?Y1FRK1RabTRrV1dCWjNzbDAvcXhWOFlCTEZ1VmdtNFdLWCtUTTMyL1BXUkh4?=
 =?utf-8?B?WTBnVU1XWHV1UDhHNVVwRTJORHdiTmx6OFJVYm9DWlBNOWJGb0NNREFEN2VB?=
 =?utf-8?B?bXhYdTRKbXdrcndtdEdDeUxwOW5OTUdudEFRZnlMZk9ERk1VMFFaY1g3dFBI?=
 =?utf-8?B?ZGNUWW1zTlBTKy9LRWZBODhBUXlmTzFpUXFtTGFaSnM1RTRTMkRhaldycDNs?=
 =?utf-8?B?UU1zTmR4KzhTd2pjallaM2JrMmV3RXkzbXhKaHFFWUxBb0NyTnFWVXJnTzBL?=
 =?utf-8?B?ZlhQdHlpemdSamdySGV4RkE2NThteHhrSkxmaGI4WlVzMUpvdnpuUjBRTEVD?=
 =?utf-8?B?Z0p3cTdUNjBsRlpONHpqQlZicURLU1d5OTl0OTlyd0djVVYzMm5PSkdhZlA5?=
 =?utf-8?B?Q1BiaVRpclM3RE15cEdiQUVGYlpXaURYcThVdnRwMlBMaDFPQkhQbVAvZysx?=
 =?utf-8?B?ek5sWk9NdWhQckFXM3l6WmVZSFVkTnhDYVNieUFNc29kZTB2VkdvSnpJK1VN?=
 =?utf-8?B?d3hHemlMMXhKS2hZL0Y1ZTUxU0hhb3hnNk52UDkzMFZFRWdmcGRObW1BVjlk?=
 =?utf-8?B?M09vNGJYQkFPZHF2U054Vkc4TWJnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72cc8a9-01c0-4dd9-ac95-08dac6513e2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 15:02:26.8839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vvlQnEx6fOyEmpRFs7Zg9eiEFjrbrPi1ithPtIU7Z6k1VQK5N7ftwLc6rIy5iUIUtJIQW05Jt7ZplFQ58p2KSGLodWGat6pX1WaXoC/9sPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3713
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Walter Heymans <walter.heymans@corigine.com>

The NFP documentation is updated to include information about Corigine,
and the new NFP3800 chips. The 'Acquiring Firmware' section is updated
with new information about where to find firmware.

Two new sections are added to expand the coverage of the documentation.
The new sections include:
- Devlink Info
- Configure Device

v2
* Add missing include of isonum.txt for unicode macro |copy|

Signed-off-by: Walter Heymans <walter.heymans@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../device_drivers/ethernet/netronome/nfp.rst | 165 +++++++++++++++---
 1 file changed, 145 insertions(+), 20 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
index ada611fb427c..650b57742d51 100644
--- a/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
+++ b/Documentation/networking/device_drivers/ethernet/netronome/nfp.rst
@@ -1,50 +1,57 @@
 .. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+.. include:: <isonum.txt>
 
-=============================================
-Netronome Flow Processor (NFP) Kernel Drivers
-=============================================
+===========================================
+Network Flow Processor (NFP) Kernel Drivers
+===========================================
 
-Copyright (c) 2019, Netronome Systems, Inc.
+:Copyright: |copy| 2019, Netronome Systems, Inc.
+:Copyright: |copy| 2022, Corigine, Inc.
 
 Contents
 ========
 
 - `Overview`_
 - `Acquiring Firmware`_
+- `Devlink Info`_
+- `Configure Device`_
+- `Statistics`_
 
 Overview
 ========
 
-This driver supports Netronome's line of Flow Processor devices,
-including the NFP4000, NFP5000, and NFP6000 models, which are also
-incorporated in the company's family of Agilio SmartNICs. The SR-IOV
-physical and virtual functions for these devices are supported by
-the driver.
+This driver supports Netronome and Corigine's line of Network Flow Processor
+devices, including the NFP3800, NFP4000, NFP5000, and NFP6000 models, which
+are also incorporated in the companies' family of Agilio SmartNICs. The SR-IOV
+physical and virtual functions for these devices are supported by the driver.
 
 Acquiring Firmware
 ==================
 
-The NFP4000 and NFP6000 devices require application specific firmware
-to function.  Application firmware can be located either on the host file system
+The NFP3800, NFP4000 and NFP6000 devices require application specific firmware
+to function. Application firmware can be located either on the host file system
 or in the device flash (if supported by management firmware).
 
 Firmware files on the host filesystem contain card type (`AMDA-*` string), media
-config etc.  They should be placed in `/lib/firmware/netronome` directory to
+config etc. They should be placed in `/lib/firmware/netronome` directory to
 load firmware from the host file system.
 
 Firmware for basic NIC operation is available in the upstream
 `linux-firmware.git` repository.
 
+A more comprehensive list of firmware can be downloaded from the
+`Corigine Support site <https://www.corigine.com/DPUDownload.html>`_.
+
 Firmware in NVRAM
 -----------------
 
 Recent versions of management firmware supports loading application
-firmware from flash when the host driver gets probed.  The firmware loading
+firmware from flash when the host driver gets probed. The firmware loading
 policy configuration may be used to configure this feature appropriately.
 
 Devlink or ethtool can be used to update the application firmware on the device
 flash by providing the appropriate `nic_AMDA*.nffw` file to the respective
-command.  Users need to take care to write the correct firmware image for the
+command. Users need to take care to write the correct firmware image for the
 card and media configuration to flash.
 
 Available storage space in flash depends on the card being used.
@@ -79,9 +86,9 @@ You may need to use hard instead of symbolic links on distributions
 which use old `mkinitrd` command instead of `dracut` (e.g. Ubuntu).
 
 After changing firmware files you may need to regenerate the initramfs
-image.  Initramfs contains drivers and firmware files your system may
-need to boot.  Refer to the documentation of your distribution to find
-out how to update initramfs.  Good indication of stale initramfs
+image. Initramfs contains drivers and firmware files your system may
+need to boot. Refer to the documentation of your distribution to find
+out how to update initramfs. Good indication of stale initramfs
 is system loading wrong driver or firmware on boot, but when driver is
 later reloaded manually everything works correctly.
 
@@ -89,9 +96,9 @@ Selecting firmware per device
 -----------------------------
 
 Most commonly all cards on the system use the same type of firmware.
-If you want to load specific firmware image for a specific card, you
-can use either the PCI bus address or serial number.  Driver will print
-which files it's looking for when it recognizes a NFP device::
+If you want to load a specific firmware image for a specific card, you
+can use either the PCI bus address or serial number. The driver will
+print which files it's looking for when it recognizes a NFP device::
 
     nfp: Looking for firmware file in order of priority:
     nfp:  netronome/serial-00-12-34-aa-bb-cc-10-ff.nffw: not found
@@ -106,6 +113,15 @@ Note that `serial-*` and `pci-*` files are **not** automatically included
 in initramfs, you will have to refer to documentation of appropriate tools
 to find out how to include them.
 
+Running firmware version
+------------------------
+
+The version of the loaded firmware for a particular <netdev> interface,
+(e.g. enp4s0), or an interface's port <netdev port> (e.g. enp4s0np0) can
+be displayed with the ethtool command::
+
+  $ ethtool -i <netdev>
+
 Firmware loading policy
 -----------------------
 
@@ -132,6 +148,115 @@ abi_drv_load_ifc
     Defines a list of PF devices allowed to load FW on the device.
     This variable is not currently user configurable.
 
+Devlink Info
+============
+
+The devlink info command displays the running and stored firmware versions
+on the device, serial number and board information.
+
+Devlink info command example (replace PCI address)::
+
+  $ devlink dev info pci/0000:03:00.0
+    pci/0000:03:00.0:
+      driver nfp
+      serial_number CSAAMDA2001-1003000111
+      versions:
+          fixed:
+            board.id AMDA2001-1003
+            board.rev 01
+            board.manufacture CSA
+            board.model mozart
+          running:
+            fw.mgmt 22.10.0-rc3
+            fw.cpld 0x1000003
+            fw.app nic-22.09.0
+            chip.init AMDA-2001-1003  1003000111
+          stored:
+            fw.bundle_id bspbundle_1003000111
+            fw.mgmt 22.10.0-rc3
+            fw.cpld 0x0
+            chip.init AMDA-2001-1003  1003000111
+
+Configure Device
+================
+
+This section explains how to use Agilio SmartNICs running basic NIC firmware.
+
+Configure interface link-speed
+------------------------------
+The following steps explains how to change between 10G mode and 25G mode on
+Agilio CX 2x25GbE cards. The changing of port speed must be done in order,
+port 0 (p0) must be set to 10G before port 1 (p1) may be set to 10G.
+
+Down the respective interface(s)::
+
+  $ ip link set dev <netdev port 0> down
+  $ ip link set dev <netdev port 1> down
+
+Set interface link-speed to 10G::
+
+  $ ethtool -s <netdev port 0> speed 10000
+  $ ethtool -s <netdev port 1> speed 10000
+
+Set interface link-speed to 25G::
+
+  $ ethtool -s <netdev port 0> speed 25000
+  $ ethtool -s <netdev port 1> speed 25000
+
+Reload driver for changes to take effect::
+
+  $ rmmod nfp; modprobe nfp
+
+Configure interface Maximum Transmission Unit (MTU)
+---------------------------------------------------
+
+The MTU of interfaces can temporarily be set using the iproute2, ip link or
+ifconfig tools. Note that this change will not persist. Setting this via
+Network Manager, or another appropriate OS configuration tool, is
+recommended as changes to the MTU using Network Manager can be made to
+persist.
+
+Set interface MTU to 9000 bytes::
+
+  $ ip link set dev <netdev port> mtu 9000
+
+It is the responsibility of the user or the orchestration layer to set
+appropriate MTU values when handling jumbo frames or utilizing tunnels. For
+example, if packets sent from a VM are to be encapsulated on the card and
+egress a physical port, then the MTU of the VF should be set to lower than
+that of the physical port to account for the extra bytes added by the
+additional header. If a setup is expected to see fallback traffic between
+the SmartNIC and the kernel then the user should also ensure that the PF MTU
+is appropriately set to avoid unexpected drops on this path.
+
+Configure Forward Error Correction (FEC) modes
+----------------------------------------------
+
+Agilio SmartNICs support FEC mode configuration, e.g. Auto, Firecode Base-R,
+ReedSolomon and Off modes. Each physical port's FEC mode can be set
+independently using ethtool. The supported FEC modes for an interface can
+be viewed using::
+
+  $ ethtool <netdev>
+
+The currently configured FEC mode can be viewed using::
+
+  $ ethtool --show-fec <netdev>
+
+To force the FEC mode for a particular port, auto-negotiation must be disabled
+(see the `Auto-negotiation`_ section). An example of how to set the FEC mode
+to Reed-Solomon is::
+
+  $ ethtool --set-fec <netdev> encoding rs
+
+Auto-negotiation
+----------------
+
+To change auto-negotiation settings, the link must first be put down. After the
+link is down, auto-negotiation can be enabled or disabled using::
+
+  ethtool -s <netdev> autoneg <on|off>
+
 Statistics
 ==========
 
-- 
2.30.2

