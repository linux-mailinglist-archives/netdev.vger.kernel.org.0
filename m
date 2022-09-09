Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67AF5B3536
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiIIK3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiIIK2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:28:18 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D8E12EDB4
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 03:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662719296; x=1694255296;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O7/uQQcr8SWEvy19q1c51hgdUtPoJt162kdZfhgVZZs=;
  b=cw2ZmnTUoWnmRzGmrejkC4d/3RmHLixgdlGyDVjDtShp2/HQrO7ytUGh
   BY7nHFfSnv8imW3NreH+QI9L8WmGb4mso2/OUYaMeUNmgbCwZtW/QwQ8w
   +ozLPhpfeoyxh2rgit4RALDs2yoEqCLuuyGHMTlYyOAbJa22/ykiuV0Y5
   onkBxy/UvdJath29OQNnhL68nmYFCXmZ51iyxs2499gLxwoBTO9KViTSx
   ypD9BcIMxES3bYv91+4tgp7T3VKuU8tgxKh0chTHjsm6aj6bTjG/K5fkb
   Gb5ddZg2n0fWgwD+Oldnvh4O2ZPnEFnpuPGVkQT5SabXaDWmPcl5ix1D9
   g==;
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="190129684"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Sep 2022 03:28:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Sep 2022 03:28:15 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Sep 2022 03:28:13 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [RFC PATCH iproute2-next 0/2] Add pcp-prio and new APPTRUST subcommand
Date:   Fri, 9 Sep 2022 12:36:59 +0200
Message-ID: <20220909103701.468717-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series implements the interfaces of the kernel side patch series:

https://lore.kernel.org/netdev/20220908120442.3069771-1-daniel.machon@microchip.com/#t

This is posted RFC as the kernel side is not ready to be merged yet.

- New pcp-prio parameter has been added to existing app subcommand.
- New apptrust subcommand with parameter trust-order has been added.

Patch #1 Introduces a new pcp-prio parameter to the app subcommand. This new
parameter uses the array parameter to map a pcp and dei value to priority.
The key is the PCP and DEI value in numerical and symbolic form, respectively.
Also dcb-app.8 man page has been extended to describe the new parameter.

Example:

Map PCP 1 and DEI 0 to priority 1
$ dcb app add dev eth0 pcp-prio 1:1

Map PCP 1 and DEI 1 to priority 1
$ dcb app add dev eth0 pcp-prio 1de:1

Patch #2 Introduces a new apptrust subcommand. This new subcommand has currently
one parameter: trust-order. It lets you specify a list of trusted selectors, in
order of precendence. Also a new dcb-apptrust.8 man page has been added, to
describe the ned subcommand and its parameter.

Example:

Trust selectors dscp and pcp, in that order:
$ dcb apptrust set dev eth0 dscp pcp

Trust selectors ethertype, stream and pcp, in that order
$ dcb apptrust set dev eth0 eth stream pcp

Show the trust order
$ dcb apptrust show dev eth0
trust-order: eth stream pcp

Both patches makes changes to the uapi dcbnl.h kernel header. Changes to kernel
headers is probably not dealt with this way?

Daniel Machon (2):
  dcb: add new pcp-prio parameter to dcb app
  dcb: add new subcommand for apptrust object

 dcb/Makefile               |   3 +-
 dcb/dcb.c                  |   4 +-
 dcb/dcb.h                  |   4 +
 dcb/dcb_app.c              |  70 ++++++++++++
 dcb/dcb_apptrust.c         | 216 +++++++++++++++++++++++++++++++++++++
 include/uapi/linux/dcbnl.h |  15 +++
 man/man8/dcb-app.8         |  25 +++++
 man/man8/dcb-apptrust.8    | 122 +++++++++++++++++++++
 8 files changed, 457 insertions(+), 2 deletions(-)
 create mode 100644 dcb/dcb_apptrust.c
 create mode 100644 man/man8/dcb-apptrust.8

-- 
2.34.1

