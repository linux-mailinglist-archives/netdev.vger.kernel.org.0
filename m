Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2241E628724
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbiKNRc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbiKNRce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:32:34 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CF14092A
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668447148; x=1699983148;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/xxh64RNXYUySv4bBkPPjXv16iZsxrRitjQtxzKaFWA=;
  b=i7wa5kDUVxl/gZaxMESo85eIixpmkZ1ODXVvQqcS2c+2hRPiPIuTKcNB
   CVW5FfSWGt1WxJthcaZ5iWPFPmyNnmjpEMmHYTe2dY0HKLGY+OAyZ5k8u
   NU3wV3/3wN7yZgro/M0aubDkheTD8K7KfXOb2AhUjgvIhdv6hhn3iAZw8
   IPPA+gWZ9VOcIEUpjUrbodzEryFgi8bczeJ92JyIpjwi50dQdwcvWrjLN
   0EHJtkQJfvpx7/4z+TWa0JYl7T0+PcNRWKdy3Jhb2pd0YqmNIfTspvkma
   202PTYtwtE9RzHesixtCbaFDx4nZKu91LUdQUq1nzsuKifknXlNte+rte
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376297782"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="376297782"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 09:32:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="781012192"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="781012192"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 09:32:26 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v11 10/11] ice: Add documentation for devlink-rate implementation
Date:   Mon, 14 Nov 2022 18:31:37 +0100
Message-Id: <20221114173138.165319-11-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221114173138.165319-1-michal.wilczynski@intel.com>
References: <20221114173138.165319-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation to a newly added devlink-rate feature. Provide some
examples on how to use the commands, which netlink attributes are
supported and descriptions of the attributes.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 Documentation/networking/devlink/ice.rst | 115 +++++++++++++++++++++++
 1 file changed, 115 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 0c89ceb8986d..62bf353a4527 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -254,3 +254,118 @@ Users can request an immediate capture of a snapshot via the
     0000000000000210 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 
     $ devlink region delete pci/0000:01:00.0/device-caps snapshot 1
+
+Devlink Rate
+==========
+
+The ``ice`` driver implements devlink-rate API. It allows for offload of
+the Hierarchical QoS to the hardware. It enables user to group Virtual
+Functions in a tree structure and assign supported parameters: tx_share,
+tx_max, tx_priority and tx_weight to each node in a tree. So effectively
+user gains an ability to control how much bandwidth is allocated for each
+VF group. This is later enforced by the HW.
+
+It is assumed that this feature is mutually exclusive with DCB performed
+in FW and ADQ, or any driver feature that would trigger changes in QoS,
+for example creation of the new traffic class. The driver will prevent DCB
+or ADQ configuration if user started making any changes to the nodes using
+devlink-rate API. To configure those features a driver reload is necessary.
+Correspondingly if ADQ or DCB will get configured the driver won't export
+hierarchy at all, or will remove the untouched hierarchy if those
+features are enabled after the hierarchy is exported, but before any
+changes are made.
+
+This feature is also dependent on switchdev being enabled in the system.
+It's required bacause devlink-rate requires devlink-port objects to be
+present, and those objects are only created in switchdev mode.
+
+If the driver is set to the switchdev mode, it will export internal
+hierarchy the moment VF's are created. Root of the tree is always
+represented by the node_0. This node can't be deleted by the user. Leaf
+nodes and nodes with children also can't be deleted.
+
+.. list-table:: Attributes supported
+    :widths: 15 85
+
+    * - Name
+      - Description
+    * - ``tx_max``
+      - maximum bandwidth to be consumed by the tree Node. Rate Limit is
+        an absolute number specifying a maximum amount of bytes a Node may
+        consume during the course of one second. Rate limit guarantees
+        that a link will not oversaturate the receiver on the remote end
+        and also enforces an SLA between the subscriber and network
+        provider.
+    * - ``tx_share``
+      - minimum bandwidth allocated to a tree node when it is not blocked.
+        It specifies an absolute BW. While tx_max defines the maximum
+        bandwidth the node may consume, the tx_share marks committed BW
+        for the Node.
+    * - ``tx_priority``
+      - allows for usage of strict priority arbiter among siblings. This
+        arbitration scheme attempts to schedule nodes based on their
+        priority as long as the nodes remain within their bandwidth limit.
+        Range 0-7. Nodes with priority 7 have the highest priority and are
+        selected first, while nodes with priority 0 have the lowest
+        priority. Nodes that have the same priority are treated equally.
+    * - ``tx_weight``
+      - allows for usage of Weighted Fair Queuing arbitration scheme among
+        siblings. This arbitration scheme can be used simultaneously with
+        the strict priority. Range 1-200. Only relative values mater for
+        arbitration.
+
+``tx_priority`` and ``tx_weight`` can be used simultaneously. In that case
+nodes with the same priority form a WFQ subgroup in the sibling group
+and arbitration among them is based on assigned weights.
+
+.. code:: shell
+
+    # enable switchdev
+    $ devlink dev eswitch set pci/0000:4b:00.0 mode switchdev
+
+    # at this point driver should export internal hierarchy
+    $ echo 2 > /sys/class/net/ens785np0/device/sriov_numvfs
+
+    $ devlink port function rate show
+    pci/0000:4b:00.0/node_25: type node parent node_24
+    pci/0000:4b:00.0/node_24: type node parent node_0
+    pci/0000:4b:00.0/node_32: type node parent node_31
+    pci/0000:4b:00.0/node_31: type node parent node_30
+    pci/0000:4b:00.0/node_30: type node parent node_16
+    pci/0000:4b:00.0/node_19: type node parent node_18
+    pci/0000:4b:00.0/node_18: type node parent node_17
+    pci/0000:4b:00.0/node_17: type node parent node_16
+    pci/0000:4b:00.0/node_14: type node parent node_5
+    pci/0000:4b:00.0/node_5: type node parent node_3
+    pci/0000:4b:00.0/node_13: type node parent node_4
+    pci/0000:4b:00.0/node_12: type node parent node_4
+    pci/0000:4b:00.0/node_11: type node parent node_4
+    pci/0000:4b:00.0/node_10: type node parent node_4
+    pci/0000:4b:00.0/node_9: type node parent node_4
+    pci/0000:4b:00.0/node_8: type node parent node_4
+    pci/0000:4b:00.0/node_7: type node parent node_4
+    pci/0000:4b:00.0/node_6: type node parent node_4
+    pci/0000:4b:00.0/node_4: type node parent node_3
+    pci/0000:4b:00.0/node_3: type node parent node_16
+    pci/0000:4b:00.0/node_16: type node parent node_15
+    pci/0000:4b:00.0/node_15: type node parent node_0
+    pci/0000:4b:00.0/node_2: type node parent node_1
+    pci/0000:4b:00.0/node_1: type node parent node_0
+    pci/0000:4b:00.0/node_0: type node
+    pci/0000:4b:00.0/1: type leaf parent node_25
+    pci/0000:4b:00.0/2: type leaf parent node_25
+
+    # let's create some custom node
+    $ devlink port function rate add pci/0000:4b:00.0/node_custom parent node_0
+
+    # second custom node
+    $ devlink port function rate add pci/0000:4b:00.0/node_custom_1 parent node_custom
+
+    # reassign second VF to newly created branch
+    $ devlink port function rate set pci/0000:4b:00.0/2 parent node_custom_1
+
+    # assign tx_weight to the VF
+    $ devlink port function rate set pci/0000:4b:00.0/2 tx_weight 5
+
+    # assign tx_share to the VF
+    $ devlink port function rate set pci/0000:4b:00.0/2 tx_share 500Mbps
-- 
2.37.2

