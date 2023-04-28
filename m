Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71EB6F0F7D
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 02:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344438AbjD1AVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 20:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344465AbjD1AVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 20:21:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC9E40FE;
        Thu, 27 Apr 2023 17:20:54 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33RIPmcV029097;
        Thu, 27 Apr 2023 17:20:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=NYdUMJvVDkQ93vROgTEHRiBpmRyQC3+ON6XrWgewyJ4=;
 b=VfurQi2l35LLHtbhDhG97l6/S1IlJI8t4mWXxUtUHAJgAbi7B4i49Kg1KFlU5u4xZufy
 TmLm2jlTNDkbTxbIAXmMSwbM9E6vB5SWlwcIcbChMFOJMuPIi4aQY9oJXs7FejNxEv0V
 NmJgD72hJ+oHXMIdiE4rluDDd6ara90Nglxz77RAjVJ0jl49xIIJ0WtUImaNQUa0+XFs
 wFC4Nrz33HjdpHA4mWmKLu8GHurz9n+GYpCnK4fmYvBx50U+Kh4ocVRvfjrYbFubr2ev
 j/+A48Uz5P5ek1w6zowIoGmvWjC4RFd4/Y+bQ5Bw/KlwP8ptyb/T+fDuMBFHisKZO1vU 8w== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q7e8hgsv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Apr 2023 17:20:35 -0700
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server id
 15.1.2507.23; Thu, 27 Apr 2023 17:20:19 -0700
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        <poros@redhat.com>, <mschmidt@redhat.com>,
        <netdev@vger.kernel.org>, <linux-clk@vger.kernel.org>
Subject: [RFC PATCH v7 0/8] Create common DPLL configuration API
Date:   Thu, 27 Apr 2023 17:20:01 -0700
Message-ID: <20230428002009.2948020-1-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: USJo7jUamDGqxv346iHC61P-0R9J4cv5
X-Proofpoint-ORIG-GUID: USJo7jUamDGqxv346iHC61P-0R9J4cv5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_09,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

Implement common API for clock/DPLL configuration and status reporting.
The API utilises netlink interface as transport for commands and event
notifications. This API aim to extend current pin configuration and
make it flexible and easy to cover special configurations.

v6 -> v7:
 * YAML spec:
   - remove nested 'pin' attribute
   - clean up definitions on top of the latest changes
 * pin object:
   - pin xarray uses id provided by the driver
   - remove usage of PIN_IDX_INVALID in set function
   - source_pin_get() returns object instead of idx
   - fixes in frequency support API
 * device and pin operations are const now
 * small fixes in naming in Makefile and in the functions
 * single mutex for the subsystem to avoid possible ABBA locks
 * no special *_priv() helpers anymore, private data is passed as void*
 * no netlink filters by name anymore, only index is supported
 * update ptp_ocp and ice drivers to follow new API version
 * add mlx5e driver as a new customer of the subsystem
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

Jiri Pirko (2):
  netdev: expose DPLL pin handle for netdevice
  mlx5: Implement SyncE support using DPLL infrastructure

Vadim Fedorenko (3):
  dpll: Add DPLL framework base functions
  dpll: documentation on DPLL subsystem interface
  ptp_ocp: implement DPLL ops

 Documentation/dpll.rst                        |  408 ++++
 Documentation/netlink/specs/dpll.yaml         |  472 ++++
 Documentation/networking/index.rst            |    1 +
 MAINTAINERS                                   |    8 +
 drivers/Kconfig                               |    2 +
 drivers/Makefile                              |    1 +
 drivers/dpll/Kconfig                          |    7 +
 drivers/dpll/Makefile                         |   10 +
 drivers/dpll/dpll_core.c                      |  939 ++++++++
 drivers/dpll/dpll_core.h                      |  113 +
 drivers/dpll/dpll_netlink.c                   |  991 +++++++++
 drivers/dpll/dpll_netlink.h                   |   27 +
 drivers/dpll/dpll_nl.c                        |  126 ++
 drivers/dpll/dpll_nl.h                        |   42 +
 drivers/net/ethernet/intel/Kconfig            |    1 +
 drivers/net/ethernet/intel/ice/Makefile       |    3 +-
 drivers/net/ethernet/intel/ice/ice.h          |    5 +
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  240 +-
 drivers/net/ethernet/intel/ice/ice_common.c   |  467 ++++
 drivers/net/ethernet/intel/ice/ice_common.h   |   43 +
 drivers/net/ethernet/intel/ice/ice_dpll.c     | 1929 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_dpll.h     |  101 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   17 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |    7 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c   |  414 ++++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h   |  230 ++
 drivers/net/ethernet/intel/ice/ice_type.h     |    1 +
 .../net/ethernet/mellanox/mlx5/core/Kconfig   |    8 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |   17 +
 .../net/ethernet/mellanox/mlx5/core/dpll.c    |  438 ++++
 drivers/ptp/Kconfig                           |    1 +
 drivers/ptp/ptp_ocp.c                         |  327 ++-
 include/linux/dpll.h                          |  294 +++
 include/linux/mlx5/driver.h                   |    2 +
 include/linux/mlx5/mlx5_ifc.h                 |   59 +-
 include/linux/netdevice.h                     |    7 +
 include/uapi/linux/dpll.h                     |  204 ++
 include/uapi/linux/if_link.h                  |    2 +
 net/core/dev.c                                |   20 +
 net/core/rtnetlink.c                          |   38 +
 41 files changed, 7966 insertions(+), 59 deletions(-)
 create mode 100644 Documentation/dpll.rst
 create mode 100644 Documentation/netlink/specs/dpll.yaml
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
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/dpll.c
 create mode 100644 include/linux/dpll.h
 create mode 100644 include/uapi/linux/dpll.h

-- 
2.34.1

