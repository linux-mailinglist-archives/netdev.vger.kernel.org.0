Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B12506EFF1A
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 04:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242707AbjD0CKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 22:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjD0CKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 22:10:36 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7E6359E
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 19:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682561435; x=1714097435;
  h=from:to:cc:subject:date:message-id;
  bh=tlw4f/pHL5rCdVNeUQLtVXqUWutm0kPiuUz6hyOGIvs=;
  b=E/JFCVrWh7Upx+p/GLTuJySR7tJZ6trI286GjrWg/ZkLJxjIcVueBRJS
   0cJwRJ97Er/SmJIAB7xHCL+cCxQtwBRgY6BbovDRDcCQz3dY55HIk0yUu
   Hub5pQWbJEvikCLiiGu+WRXY27gxXaDeTMTSaE0Va2qxlCO9elD20o4bZ
   ma0zSwmscX3ae4BWFGs0K5GnoDbnOotFeCVkcRVXPYqOKivEqyd61jhWz
   FJpbOgRfym7PKtA1OIyOgdcsp5pi9cPxrZhh8K5+S1A53i9Nh3QFP47D4
   dCJhFJ4RwV8oQf55WE6Ul7ZegLWfa/yFJVEP4YAotnJKzHn1cdaU63vpq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="336234441"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="336234441"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 19:10:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="818326127"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="818326127"
Received: from estantil-desk.jf.intel.com ([10.166.241.20])
  by orsmga004.jf.intel.com with ESMTP; 26 Apr 2023 19:10:34 -0700
From:   Emil Tantilov <emil.s.tantilov@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, willemb@google.com, decot@google.com,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, alan.brady@intel.com, madhu.chittim@intel.com,
        phani.r.burra@intel.com, shailendra.bhatnagar@intel.com,
        pavan.kumar.linga@intel.com, shannon.nelson@amd.com,
        simon.horman@corigine.com, leon@kernel.org,
        Emil Tantilov <emil.s.tantilov@intel.com>
Subject: [net-next v3 00/15] Introduce Intel IDPF driver
Date:   Wed, 26 Apr 2023 19:09:02 -0700
Message-Id: <20230427020917.12029-1-emil.s.tantilov@intel.com>
X-Mailer: git-send-email 2.17.2
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduces the Intel Infrastructure Data Path Function
(IDPF) driver. It is used for both physical and virtual functions. Except
for some of the device operations the rest of the functionality is the
same for both PF and VF. IDPF uses virtchnl version2 opcodes and
structures defined in the virtchnl2 header file which helps the driver
to learn the capabilities and register offsets from the device
Control Plane (CP) instead of assuming the default values.

The format of the series follows the driver init flow to interface open.
To start with, probe gets called and kicks off the driver initialization
by spawning the 'vc_event_task' work queue which in turn calls the
'hard reset' function. As part of that, the mailbox is initialized which
is used to send/receive the virtchnl messages to/from the CP. Once that is
done, 'core init' kicks in which requests all the required global resources
from the CP and spawns the 'init_task' work queue to create the vports.

Based on the capability information received, the driver creates the said
number of vports (one or many) where each vport is associated to a netdev.
Also, each vport has its own resources such as queues, vectors etc.
From there, rest of the netdev_ops and data path are added.

IDPF implements both single queue which is traditional queueing model
as well as split queue model. In split queue model, it uses separate queue
for both completion descriptors and buffers which helps to implement
out-of-order completions. It also helps to implement asymmetric queues,
for example multiple RX completion queues can be processed by a single
RX buffer queue and multiple TX buffer queues can be processed by a
single TX completion queue. In single queue model, same queue is used
for both descriptor completions as well as buffer completions. It also
supports features such as generic checksum offload, generic receive
offload (hardware GRO) etc.

v2 --> v3: link [2]
 * converted virtchnl2 defines to enums
 * fixed comment style in virtchnl2 to follow kernel-doc format
 * removed empty lines between end of structs and size check macro
   checkpatch will mark these instances as CHECK
 * cleaned up unused Rx descriptor structs and related bits in virtchnl2
 * converted Rx descriptor bit offsets into bitmasks to better align with
   the use of GENMASK and FIELD_GET
 * added device ids to pci_tbl from the start
 * consolidated common probe and remove functions into idpf_probe() and
   idpf_remove() respectively
 * removed needless adapter NULL checks
 * removed devm_kzalloc() in favor of kzalloc(), including kfree in
   error and exit code path
 * replaced instances of kcalloc() calls where either size parameter was
   1 with kzalloc(), reported by smatch
 * used kmemdup() in some instances reported by coccicheck
 * added explicit error code and comment explaining the condition for
   the exit to address warning by smatch
 * moved build support to the last patch

[2] https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/

v1 --> v2: link [1]
 * removed the OASIS reference in the commit message to make it clear
   that this is an Intel vendor specific driver
 * fixed misspells
 * used comment starter "/**" for struct and definition headers in
   virtchnl header files
 * removed AVF reference
 * renamed APF reference to IDPF
 * added a comment to explain the reason for 'no flex field' at the end of
   virtchnl2_get_ptype_info struct
 * removed 'key[1]' in virtchnl2_rss_key struct as it is not used
 * set VIRTCHNL2_RXDID_2_FLEX_SQ_NIC to VIRTCHNL2_RXDID_2_FLEX_SPLITQ
   instead of assigning the same value
 * cleanup unnecessary NULL assignment to the rx_buf skb pointer since
   it is not used in splitq model
 * added comments to clarify the generation bit usage in splitq model
 * introduced 'reuse_bias' in the page_info structure and make use of it
   in the hot path
 * fixed RCT format in idpf_rx_construct_skb
 * report SPEED_UNKNOWN and DUPLEX_UNKNOWN when the link is down
 * fixed -Wframe-larger-than warning reported by lkp bot in
   idpf_vport_queue_ids_init
 * updated the documentation in idpf.rst to fix LKP bot warning

[1] https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/

Alan Brady (4):
  idpf: configure resources for TX queues
  idpf: configure resources for RX queues
  idpf: add RX splitq napi poll support
  idpf: add ethtool callbacks

Joshua Hay (5):
  idpf: add controlq init and reset checks
  idpf: add splitq start_xmit
  idpf: add TX splitq napi poll support
  idpf: add singleq start_xmit and napi poll
  idpf: configure SRIOV and add other ndo_ops

Pavan Kumar Linga (5):
  virtchnl: add virtchnl version 2 ops
  idpf: add core init and interrupt request
  idpf: add create vport and netdev configuration
  idpf: continue expanding init task
  idpf: initialize interrupts and enable vport

Phani Burra (1):
  idpf: add module register and probe functionality

 .../device_drivers/ethernet/intel/idpf.rst    |  162 +
 drivers/net/ethernet/intel/Kconfig            |   10 +
 drivers/net/ethernet/intel/Makefile           |    1 +
 drivers/net/ethernet/intel/idpf/Makefile      |   18 +
 drivers/net/ethernet/intel/idpf/idpf.h        |  736 +++
 .../net/ethernet/intel/idpf/idpf_controlq.c   |  644 +++
 .../net/ethernet/intel/idpf/idpf_controlq.h   |  131 +
 .../ethernet/intel/idpf/idpf_controlq_api.h   |  188 +
 .../ethernet/intel/idpf/idpf_controlq_setup.c |  175 +
 drivers/net/ethernet/intel/idpf/idpf_dev.c    |  165 +
 drivers/net/ethernet/intel/idpf/idpf_devids.h |   10 +
 .../net/ethernet/intel/idpf/idpf_ethtool.c    | 1330 +++++
 .../ethernet/intel/idpf/idpf_lan_pf_regs.h    |  124 +
 .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |  293 +
 .../ethernet/intel/idpf/idpf_lan_vf_regs.h    |  128 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 2349 ++++++++
 drivers/net/ethernet/intel/idpf/idpf_main.c   |  266 +
 drivers/net/ethernet/intel/idpf/idpf_mem.h    |   20 +
 .../ethernet/intel/idpf/idpf_singleq_txrx.c   | 1251 +++++
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 4855 +++++++++++++++++
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  854 +++
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c |  164 +
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 3820 +++++++++++++
 drivers/net/ethernet/intel/idpf/virtchnl2.h   | 1317 +++++
 .../ethernet/intel/idpf/virtchnl2_lan_desc.h  |  448 ++
 25 files changed, 19459 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/intel/idpf.rst
 create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq_api.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq_setup.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_dev.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_devids.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_ethtool.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lib.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_mem.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
 create mode 100644 drivers/net/ethernet/intel/idpf/virtchnl2.h
 create mode 100644 drivers/net/ethernet/intel/idpf/virtchnl2_lan_desc.h

-- 
2.17.2

