Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2914574CB3
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbiGNMCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiGNMCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:02:39 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9499C39B84;
        Thu, 14 Jul 2022 05:02:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8gvuMnh2iXs+8z9HFFk9P5thEyYyoMZ8ZnEMBOjoerK+sLIyI1BSzQOkcXDuIVootnf6PkaazT3PPeM2J8o4JpW9uHN25I6e5qu/A23rSjyt5/yJYBe+pMmr3QYVnUtnMQdcOY2Znyl5XVIvSTWXTLvi3ZWdV/mx2GdAFmeMHdpW62K/OzRKmRyqdhh+uqVVcsFyvYIRF3M4eorRtfQeefaM6hud67KcGLieZjdn9ZUq2JnqOKBDNpw3e2pAMu1d7JpW0GJVJxGucoHH9QmLDKtgnTpKDBAoKDfk8uA2SG/xjzWnSbq9grYDyCqrw3g26J+23gfMHGdHxox9VNiSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLTOReH/PVP6RGVYpobmm3Iz4GGuGvWeB9KNrtkkHL0=;
 b=f1oYLx1oOm6pGWOOMYFWJiEyTuBH8WPz2Y1XFsOOcL10R/vISANdG8vCmeMhrb7Ovt0K1bto+JEGPRqr5nEjDwlW8P79RkrbBLwgIRGYXyuMS360K/41W8lbf+AWT4Ehk7Qk5LnLtAbpwSaRyIEfHVQ7lQndmLwZF4lTlfvxYDNEIo4sEttlvGHBa+v/HXIhLMrac+LrCHb14Wz/SFZGzlJrn1f3sunxsbbAlozHozRCGpBW7mwK7gm9LV0F797DMNndcVhLpzLpaJMatzBbJDjSb27mv8esREB0/AuUhKz1Hc1eRko6Nvfc4ELlkUpg6JrlvTM0TJDWqHDo7SYKRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLTOReH/PVP6RGVYpobmm3Iz4GGuGvWeB9KNrtkkHL0=;
 b=UVXgOamp+EkoktL3AkcbXpTn+9qcvhRBI/txuXolrPrKqpVnP752mrovRQECoJUI9cQqriPqN1fe+Fha45txey0cyIlnWtBlYdTcqnqdWojANWjx1PSxl+c/YE5bIT4RJQ3ghp/On/Ce19raa9lscyexrUbZEliN33jjWZ3AV14=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synaptics.com;
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com (2603:10b6:a03:386::12)
 by BN8PR03MB4915.namprd03.prod.outlook.com (2603:10b6:408:dc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 12:02:36 +0000
Received: from SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666]) by SJ0PR03MB6533.namprd03.prod.outlook.com
 ([fe80::d52:5cb7:8c3b:f666%6]) with mapi id 15.20.5417.026; Thu, 14 Jul 2022
 12:02:36 +0000
From:   =?UTF-8?q?=C5=81ukasz=20Spintzyk?= <lukasz.spintzyk@synaptics.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com
Subject: [PATCH v2 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices
Date:   Thu, 14 Jul 2022 14:02:16 +0200
Message-Id: <20220714120217.18635-1-lukasz.spintzyk@synaptics.com>
X-Mailer: git-send-email 2.36.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0071.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::16) To SJ0PR03MB6533.namprd03.prod.outlook.com
 (2603:10b6:a03:386::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d87dfbf-ab4d-4af8-42ed-08da6590bda1
X-MS-TrafficTypeDiagnostic: BN8PR03MB4915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJ7dG1BQLUdvz1j8jCyWQBuk24OH0bQWThpNij2eVkt4NVViWF50NSJc7KfSPHJLqFm+x1+SdJcy2CQf3zK3w+7iq5sRWH2ldIfNKgHTOTAtTQTA0F3Pz7l+/SaoFr7NGa5TXgU6Odh3Y1xK5VIgE2oq+lj77BuBRMhuqHWEesSgy+xUIH7R+14aXHzkU2obJg3x96pa1mxEfMS+0zzJlAB+ZC/zQojTT+/HDnW+iJhjrW3/5ZTLpn4hFf8reOiy8Z6DuQHBl+76JCIQPQTQC4VAqFo9pVkBudXTH4qNfBUO6USYGgu9+XhE+SRYsXAiu1Xl5hhNIaGMeZA/nVzGvkKhqXoZXQuMUmDXozEgUjeObV9niEHnaIxn0BQtP53Kjvz1SJOCphho6c4nB5+bgE4XiJuw0m8jm4VCwDBi665XmxNHggHrvtuIVoLHusy8j9GZEWb1tJqYrKPVp1OZ/3r8MT7+DhAYBpy5db2/Scs0/2Yj6lLrJMD7tFTW6ylxWgwFWCyisag+zQ+K8vldJE8Q2b6IR3WtTxIMGVMYKDDZGFXU+8KKpudMNGPHy4bEyAYfly137OLZXcmSj8qgOgT6fmx6z0Qf0bI+d45jJ5zRGiROgeO8pk4OZxn8n7PoMulrjiUevh4PZ+7MX/YKOk3eR3FWUNIBi6vWruoTbzqImrYuAoPHcNy/H20JGcBVQUBp4upSpW/LGQebBC4+05QPvPY5jaOjWWR4NWBHhOmLeDG4Txm6linyvljuibvb6HHoDUkN7TBKGnYwkMyTcerjskWjd/9aOAIXfrpTK7lhsrITMieT9zYLr+mlKj+A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6533.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(396003)(376002)(346002)(6916009)(6666004)(1076003)(6512007)(66476007)(19627235002)(41300700001)(316002)(2906002)(36756003)(8676002)(6486002)(66946007)(26005)(5660300002)(186003)(83380400001)(8936002)(478600001)(52116002)(107886003)(86362001)(2616005)(38350700002)(4326008)(6506007)(66556008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2FLdzVpUFJwS2VuRm9qVWRsSHpoYnlESW1CRldHQzhGcC9CSGtqTVI3NnhJ?=
 =?utf-8?B?bG90SFFzZG9mODZoMHpNUUZlNzkxbEtlc1U2Tk5CN1FydTFLM2EyWVBBampD?=
 =?utf-8?B?UHoxUEJaZEZKZDlXYVhBblRvdi9Iay8rMVNXTGpRek14aUVocVlDY2JkM2F2?=
 =?utf-8?B?ZzlWWVJvR1JPejNiakFZaUh2UTBxcGM5SnZGdjd1NXdDZEN0ZFNLVHpuaEpD?=
 =?utf-8?B?YW5lZzFnTGIreXBOamNvUHlidEU4ejRYdjFwMWI4TWt2S1VCNGlCNytLTytZ?=
 =?utf-8?B?ZVptWFBBZnV1NWYxcWl0eVBSV1hmZVhoUGpKc1lJQlRBcmpyaXlncGo1VDgr?=
 =?utf-8?B?cnRQQ2xoays4dUU1RW5YM3V5SlNyOHJmeXk4cWNEL1JjMHp2WmZ2WFFScVVR?=
 =?utf-8?B?WFlwWGJMRGxGalBzSWtzUVdhZ0taOUk2Tm44amtVNnFzN0xJRlJDS01XS3Fu?=
 =?utf-8?B?QnZ5VjZ3Wk1MbTNrdU5ad213eGplT0pHYTFWK0RYT0x6dUptbUxWcXlaZzVZ?=
 =?utf-8?B?NUFoeDZBQks3MGNxQ1pkOTFjT09ZN3RDVkxuaERPMnN1TkFYUFpvcDZXNEMw?=
 =?utf-8?B?djBGNDF3THJlZVZObXBRREFDL1Rka0k1SnhvZ21QejBaamZJU3pXYVZycVp0?=
 =?utf-8?B?elFHSzQ0VFNJNGJxWkdINzg4Q25lUFZ3SkttUUs5aDYzN1FjUVlBSFZoVThn?=
 =?utf-8?B?ZEZhekNsMHlkc1pSeTJRUy8yZnR6NXRTaTVqeWV3S2pKQWc4amxVc3JScVE0?=
 =?utf-8?B?YVBIY1VqK0QxMTBDVlUvMUZIUStRUlRrbEI0bnB3N21COGlDRDVLRFZKSC9t?=
 =?utf-8?B?NWoyclZ3VmV0RWloYkJhSlc4R05xeG15c0lCZy96ZS82UHNCelFNbEpXdXFU?=
 =?utf-8?B?bDhrenBoNzRhZnY1endSNlhnMXlXR1Zlbm1rWjZDcUVpVmdVWjdGWGgzcEdk?=
 =?utf-8?B?NDF2NzBrYnNtVEdjZW4xN21MTkdmM1VwSldMK3lRak1oNE92bEs4UE9yR3dq?=
 =?utf-8?B?QXhkaDlMR3ZEZVN4Qm1KS29NUTB6T0lKTkRsSFF4cnFDYnk1bUpJMFpQWXpR?=
 =?utf-8?B?YVV0anJGV1ZYVXpZUkpjRkpRcndVYnlMaDZGdjFMNHFEcDVYa2Y3M2owZ3ZR?=
 =?utf-8?B?cmNHOVdNUjlBVUk5aWd6QXpTd1c2NVgrNGRST3QzLzl5b25aM3ZPS0xrcHM3?=
 =?utf-8?B?bDQzRHlzZVB1anBNeU1JWjJmWWpWM3docVJhNVBxZzh4TEVyQ21nWHpRU2pv?=
 =?utf-8?B?OFlucElpb0p0UWwwT1k1bmZ1Q2RaZWIvU2RIelg2U2lMQnYvNjU0WDJKWXdq?=
 =?utf-8?B?cENaMXlQeFlVcm9xaVllZDVSOUdaSEpMa1FTSUZTVk9KVjV6bWJacnFRMnc5?=
 =?utf-8?B?VnN0eTFjNzZEVmJGK1lLSkNOdytBV3lPcUtSWXRZTmpJNGExOCtPK1Nzbno5?=
 =?utf-8?B?eC9kM2lHOWgyVXdHOGVZczZKR3QrUnh0VGFtb1R4TXhxUmRhVFVxWEt6SVVB?=
 =?utf-8?B?Z2xHdG95MzYyQnJHenh0eTV3aGt2Y1gxWGFPWUxKU2plWVFKZllPSXpKOGtC?=
 =?utf-8?B?ZHM5c05kZGtqb2prUnJqWXBUN3JESCtHa2FMbTZZZ2xkU0pBSndWaWh1OTBF?=
 =?utf-8?B?bVhLQjlBeEVIWHYxc0hRekRBSi9ZTFlhQmVwTlJEdFFoRTNPdEtHR2JDdjEr?=
 =?utf-8?B?Tmw5SWhJbkRvUzlUd0kweWN6WTZHVGJPc2h0dllnNnRlbHNIWkVnemwyNnBk?=
 =?utf-8?B?UTFsWk1iUUtCSG5PWkVjb0FVSlREL3VaVlBPMTBDMzUzUXF1RnVKcjdPSkdO?=
 =?utf-8?B?KzdkNXFscENJWXBCbkM0RHR2RXY5bUlEWEdVK1duMjBjZDBPWGtpM01yVklz?=
 =?utf-8?B?YWQ2aW9pcWRsOHFuZTM0NnBUdGoyOU1JVG5UMzBJYlExTkVzTGNpdzNiaXJN?=
 =?utf-8?B?UnVUR05mZlIyUEtVQW9PSDdneWFMNjBsM3l0Vzdpd0FZQ1plRWtqc3ArckpI?=
 =?utf-8?B?S1dub2t2VktYakozVHc0dVRnWjlnQSs0UUJGbENKK25ORkFlV291TXhrbWVL?=
 =?utf-8?B?V2UwblJhaEdLbUVlVVR3RVNoZFRQWTJNYkJ5eXhITTQ2d3l1MGtzT3JUWUh4?=
 =?utf-8?Q?LrEejMfGxsMxi4KnsvBDY0HPO?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d87dfbf-ab4d-4af8-42ed-08da6590bda1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6533.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 12:02:35.8754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xeJDBrvntHD90rwLcfcTS3yOfcSqjMT7dqY2R/iPy65tHNohGw7eNE5y7rrfssMJM9b25cAbL3/JTot2zQ1WQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR03MB4915
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dominik Czerwik <dominik.czerwik@synaptics.com>

This improves performance and stability of
DL-3xxx/DL-5xxx/DL-6xxx device series.

Specifically prevents device from temporary network dropouts when
playing video from the web and network traffic going through is high.

Signed-off-by: Bernice Chen <Bernice.Chen@synaptics.com>
Signed-off-by: Dominik Czerwik <dominik.czerwik@synaptics.com>
Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
---

v2: Added Bernice Chen as company lawyer.

 drivers/net/usb/cdc_ncm.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index d55f59ce4a31..4594bf2982ee 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -2,6 +2,7 @@
  * cdc_ncm.c
  *
  * Copyright (C) ST-Ericsson 2010-2012
+ * Copyright (C) 2022 Synaptics Incorporated. All rights reserved.
  * Contact: Alexey Orishko <alexey.orishko@stericsson.com>
  * Original author: Hans Petter Selasky <hans.petter.selasky@stericsson.com>
  *
@@ -1904,6 +1905,19 @@ static const struct driver_info cdc_ncm_info = {
 	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
+/* Same as cdc_ncm_info, but with FLAG_SEND_ZLP  */
+static const struct driver_info cdc_ncm_zlp_info = {
+	.description = "CDC NCM (SEND ZLP)",
+	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET
+			| FLAG_LINK_INTR | FLAG_ETHER | FLAG_SEND_ZLP,
+	.bind = cdc_ncm_bind,
+	.unbind = cdc_ncm_unbind,
+	.manage_power = usbnet_manage_power,
+	.status = cdc_ncm_status,
+	.rx_fixup = cdc_ncm_rx_fixup,
+	.tx_fixup = cdc_ncm_tx_fixup,
+};
+
 /* Same as cdc_ncm_info, but with FLAG_WWAN */
 static const struct driver_info wwan_info = {
 	.description = "Mobile Broadband Network Device",
@@ -2010,6 +2024,16 @@ static const struct usb_device_id cdc_devs[] = {
 	  .driver_info = (unsigned long)&wwan_info,
 	},
 
+	/* DisplayLink docking stations */
+	{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO
+		| USB_DEVICE_ID_MATCH_VENDOR,
+	  .idVendor = 0x17e9,
+	  .bInterfaceClass = USB_CLASS_COMM,
+	  .bInterfaceSubClass = USB_CDC_SUBCLASS_NCM,
+	  .bInterfaceProtocol = USB_CDC_PROTO_NONE,
+	  .driver_info = (unsigned long)&cdc_ncm_zlp_info,
+	},
+
 	/* Generic CDC-NCM devices */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM,
 		USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE),
-- 
2.36.1

