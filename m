Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D0166E614
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjAQSdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjAQSay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:30:54 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE80E3A596;
        Tue, 17 Jan 2023 10:01:29 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HG6Dci031445;
        Tue, 17 Jan 2023 10:01:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=C3W07MX49DoXFn+PQhH0IS+B2wD4qZN/G+SrD2R2f7s=;
 b=jgd9qoy9wwGIKWEegZrARlNn7qoaqmeCGq65dwq2Ax4HXERUupya4ajOQyCdz25/y3Yy
 edcdXVFzDp9bDhDOtKpwNzrb0UNlr6tHtc0lXoSSQihleV85M549gF382DdSQOca8Xw5
 dDKTp2nzmKafYg/RxvCC7FF2bwO0kGf2AEpy0ctYzBEAfZzosTq1pG1wNpIj0Ancta54
 fNGP6kAgoMfA4u0bxRwpwsJBgvC4aaTjtvZarE4k4USGn4wedW0a8DKbkLHbGa8ugrVF
 aXLdtWq1u7oUjarCwZ7ZcVMaSRShgV3qtZiap7LXA7LaAWcBYPIalNLp0BOmBt8aBUZ3 /Q== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n58dke2hp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Jan 2023 10:01:11 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server id
 15.1.2375.34; Tue, 17 Jan 2023 10:01:07 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "Arkadiusz Kubalewski" <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Vadim Fedorenko <vadfed@meta.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>
Subject: [RFC PATCH v5 0/4] Create common DPLL/clock configuration API
Date:   Tue, 17 Jan 2023 10:00:47 -0800
Message-ID: <20230117180051.2983639-1-vadfed@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::8]
X-Proofpoint-GUID: oLWThWXLYAjV1k9uVCliarVK2aSxfE05
X-Proofpoint-ORIG-GUID: oLWThWXLYAjV1k9uVCliarVK2aSxfE05
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_09,2023-01-17_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement common API for clock/DPLL configuration and status reporting.
The API utilises netlink interface as transport for commands and event
notifications. This API aim to extend current pin configuration and
make it flexible and easy to cover special configurations.

v4 -> v5:
 * fix code issues found during last reviews:
   - replace cookie with clock id
	 - follow one naming schema in dpll subsys
	 - move function comments to dpll_core.c, fix exports
	 - remove single-use helper functions
	 - merge device register with alloc
   - lock and unlock mutex on dpll device release
   - move dpll_type to uapi header
   - rename DPLLA_DUMP_FILTER to DPLLA_FILTER
   - rename dpll_pin_state to dpll_pin_mode
   - rename DPLL_MODE_FORCED to DPLL_MODE_MANUAL
   - remove DPLL_CHANGE_PIN_TYPE enum value
 * rewrite framework once again (Arkadiusz)
   - add clock class:
     Provide userspace with clock class value of DPLL with dpll device dump
     netlink request. Clock class is assigned by driver allocating a dpll
     device. Clock class values are defined as specified in:
     ITU-T G.8273.2/Y.1368.2 recommendation.
   - dpll device naming schema use new pattern:
	   "dpll_%s_%d_%d", where:
       - %s - dev_name(parent) of parent device,
       - %d (1) - enum value of dpll type,
       - %d (2) - device index provided by parent device.
   - new muxed/shared pin registration:
	   Let the kernel module to register a shared or muxed pin without finding
     it or its parent. Instead use a parent/shared pin description to find
     correct pin internally in dpll_core, simplifing a dpll API
 * Implement complex DPLL design in ice driver (Arkadiusz)
 * Remove ptp_ocp driver from the series for now
v3 -> v4:
 * redesign framework to make pins dynamically allocated (Arkadiusz)
 * implement shared pins (Arkadiusz)
v2 -> v3:
 * implement source select mode (Arkadiusz)
 * add documentation
 * implementation improvements (Jakub)
v1 -> v2:
 * implement returning supported input/output types
 * ptp_ocp: follow suggestions from Jonathan
 * add linux-clk mailing list
v0 -> v1:
 * fix code style and errors
 * add linux-arm mailing list

Arkadiusz Kubalewski (2):
  ice: add admin commands to access cgu configuration
  ice: implement dpll interface to control cgu

Vadim Fedorenko (2):
  dpll: documentation on DPLL subsystem interface
  dpll: Add DPLL framework base functions

 Documentation/networking/dpll.rst             |  280 +++
 Documentation/networking/index.rst            |    1 +
 MAINTAINERS                                   |    8 +
 drivers/Kconfig                               |    2 +
 drivers/Makefile                              |    1 +
 drivers/dpll/Kconfig                          |    7 +
 drivers/dpll/Makefile                         |    9 +
 drivers/dpll/dpll_core.c                      | 1010 ++++++++
 drivers/dpll/dpll_core.h                      |  105 +
 drivers/dpll/dpll_netlink.c                   |  883 +++++++
 drivers/dpll/dpll_netlink.h                   |   24 +
 drivers/net/ethernet/intel/Kconfig            |    1 +
 drivers/net/ethernet/intel/ice/Makefile       |    3 +-
 drivers/net/ethernet/intel/ice/ice.h          |    5 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  240 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  467 ++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   43 +
 drivers/net/ethernet/intel/ice/ice_dpll.c     | 2115 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dpll.h     |   99 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   17 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   10 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  408 ++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  240 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
 include/linux/dpll.h                          |  282 +++
 include/uapi/linux/dpll.h                     |  294 +++
 26 files changed, 6549 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/networking/dpll.rst
 create mode 100644 drivers/dpll/Kconfig
 create mode 100644 drivers/dpll/Makefile
 create mode 100644 drivers/dpll/dpll_core.c
 create mode 100644 drivers/dpll/dpll_core.h
 create mode 100644 drivers/dpll/dpll_netlink.c
 create mode 100644 drivers/dpll/dpll_netlink.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.h
 create mode 100644 include/linux/dpll.h
 create mode 100644 include/uapi/linux/dpll.h

-- 
2.30.2

