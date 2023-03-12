Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF0C6B62EF
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 03:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCLC3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 21:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCLC3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 21:29:22 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EEE4E5F1;
        Sat, 11 Mar 2023 18:29:02 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C1rY3C010086;
        Sat, 11 Mar 2023 18:28:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=IiEIPOj0MCC6jF9xWUqkCvwXa9TOl7ZDOKSEWzwEQaU=;
 b=Ffsa+M0TLwBd4tHuGkSAJp/2MqR7L/kpxVufi90SF3lPkeDoj5oOLrLjltZP99WuEl4t
 mfrHkZBOz3Xt8YxVmeRoMf636UkELVYBD/eVOxKbMxhw+CHGOiXwrLu6aGp5o3/1WYVT
 i+JvdAJ4kAcew5rLNrQ6W99XcIKgG0svG1oWu5LX4qYOvCQMhNDDkI+dqFY1TTB7YkXh
 9RbigqZaPrbPqgRLNlb+zj4jfoyEYt5kSUl89lv77Fp+tRiwgF21vZ22tgrD/YjXllkK
 avmaV0gB9Nfb5LmcF4e5iLk0Blj73GHnP6YIWFfrUpUzoUdeDEUZ5b7ZYdGTPSIcUTMw 7A== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p8rc1sccm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Mar 2023 18:28:51 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:21 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:20 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>
Subject: [PATCH RFC v6 0/6] Create common DPLL/clock configuration API
Date:   Sat, 11 Mar 2023 18:28:01 -0800
Message-ID: <20230312022807.278528-1-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-ORIG-GUID: uBIogvlMKuMCYgpO5ZkqWpRSWw3JOjGp
X-Proofpoint-GUID: uBIogvlMKuMCYgpO5ZkqWpRSWw3JOjGp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
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

v5 -> v6:
 * rework pin part to better fit shared pins use cases
 * add YAML spec to easy generate user-space apps
 * simple implementation in ptp_ocp is back again
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

Arkadiusz Kubalewski (3):
  dpll: spec: Add Netlink spec in YAML
  ice: add admin commands to access cgu configuration
  ice: implement dpll interface to control cgu

Vadim Fedorenko (3):
  dpll: Add DPLL framework base functions
  dpll: documentation on DPLL subsystem interface
  ptp_ocp: implement DPLL ops

 Documentation/netlink/specs/dpll.yaml         |  514 +++++
 Documentation/networking/dpll.rst             |  347 ++++
 Documentation/networking/index.rst            |    1 +
 MAINTAINERS                                   |    9 +
 drivers/Kconfig                               |    2 +
 drivers/Makefile                              |    1 +
 drivers/dpll/Kconfig                          |    7 +
 drivers/dpll/Makefile                         |   10 +
 drivers/dpll/dpll_core.c                      |  835 ++++++++
 drivers/dpll/dpll_core.h                      |   99 +
 drivers/dpll/dpll_netlink.c                   | 1065 ++++++++++
 drivers/dpll/dpll_netlink.h                   |   30 +
 drivers/dpll/dpll_nl.c                        |  126 ++
 drivers/dpll/dpll_nl.h                        |   42 +
 drivers/net/ethernet/intel/Kconfig            |    1 +
 drivers/net/ethernet/intel/ice/Makefile       |    3 +-
 drivers/net/ethernet/intel/ice/ice.h          |    5 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  240 ++-
 drivers/net/ethernet/intel/ice/ice_common.c   |  467 +++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   43 +
 drivers/net/ethernet/intel/ice/ice_dpll.c     | 1845 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dpll.h     |   96 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   17 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |    7 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  411 ++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  240 +++
 drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
 drivers/ptp/Kconfig                           |    1 +
 drivers/ptp/ptp_ocp.c                         |  206 +-
 include/linux/dpll.h                          |  284 +++
 include/uapi/linux/dpll.h                     |  196 ++
 31 files changed, 7135 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/netlink/specs/dpll.yaml
 create mode 100644 Documentation/networking/dpll.rst
 create mode 100644 drivers/dpll/Kconfig
 create mode 100644 drivers/dpll/Makefile
 create mode 100644 drivers/dpll/dpll_core.c
 create mode 100644 drivers/dpll/dpll_core.h
 create mode 100644 drivers/dpll/dpll_netlink.c
 create mode 100644 drivers/dpll/dpll_netlink.h
 create mode 100644 drivers/dpll/dpll_nl.c
 create mode 100644 drivers/dpll/dpll_nl.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_dpll.h
 create mode 100644 include/linux/dpll.h
 create mode 100644 include/uapi/linux/dpll.h

-- 
2.34.1

