Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F5461FD1C
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiKGSQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbiKGSPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:15:20 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E6C1AF06
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844869; x=1699380869;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Lfzl13qwrcNbN6FCqEK46vNdGB2/sGRcHSXnQxBh3DE=;
  b=LanPWuxs+fj8CqE2CtKdiTwEuXFxsMWkR7lTIMb/jGj3eJgS/8uNZdN3
   1hmJLrQ8roEnY2pvfTCslU+gBgeaaKjiPh95YxfIhex2GG7iwiMZczVrW
   LzNslOSZW6B6ZpurXYzDWg3dj3Me+yhZ33ao2TMZcCkAy/SA1ZPtXyq+/
   P50HYqPr8G9aab2ziYisSX4kj/+I0FxFhNp0cYBW6OseGj1m0Ni2ZCBpw
   IEXkElLdfnaOBZZmVs4zDO7zD9fpCKMRRgMJXNbOYVH8b08YTZN8J3jv+
   QRfKad+yZHjsgcx9gQMmdQz7Av6ftZQx4do9UYhaWFwOaOm+vKojXUM/W
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="293852072"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="293852072"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="613962825"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="613962825"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:14:26 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v10 10/10] ice: add documentation for devlink-rate implementation
Date:   Mon,  7 Nov 2022 19:13:26 +0100
Message-Id: <20221107181327.379007-11-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221107181327.379007-1-michal.wilczynski@intel.com>
References: <20221107181327.379007-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation to a newly added devlink-rate feature. Provide some
examples on how to use the features, which netlink attributes are
supported and descriptions of the attributes.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 Documentation/networking/devlink/ice.rst | 101 +++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index 0c89ceb8986d..d3299bd160dc 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -254,3 +254,104 @@ Users can request an immediate capture of a snapshot via the
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
+It is assumed that this feature is mutually exclusive with DCB and ADQ, or
+any driver feature that would trigger changes in QoS, for example creation
+of the new traffic class. This feature is also dependent on switchdev
+being enabled in the system. It's required bacause devlink-rate requires
+devlink-port objects to be present, and those objects are only created
+in switchdev mode.
+
+If the driver is set to the switchdev mode, it will export
+internal hierarchy the moment the VF's are created. Root of the tree
+is always represented by the node_0. This node can't be deleted by the user.
+Leaf nodes and nodes with children also can't be deleted.
+
+.. list-table:: Attributes supported
+    :widths: 15 85
+
+    * - Name
+      - Description
+    * - ``tx_max``
+      - This attribute allows for specifying a maximum bandwidth to be
+        consumed by the tree Node. Rate Limit is an absolute number
+        specifying a maximum amount of bytes a Node may consume during
+        the course of one second. Rate limit guarantees that a link will
+        not oversaturate the receiver on the remote end and also enforces
+        an SLA between the subscriber and network provider.
+    * - ``tx_share``
+      - This attribute allows for specifying a minimum bandwidth allocated
+        to a tree node when it is not blocked. It specifies an absolute
+        BW. While tx_max defines the maximum bandwidth the node may consume,
+        the tx_share marks committed BW for the Node.
+    * - ``tx_priority``
+      - This attribute allows for usage of strict priority arbiter among
+        siblings. This arbitration scheme attempts to schedule nodes based
+        on their priority as long as the nodes remain within their
+        bandwidth limit. Range 0-7.
+    * - ``tx_weight``
+      - This attribute allows for usage of Weighted Fair Queuing
+        arbitration scheme among siblings. This arbitration scheme can be
+        used simultaneously with the strict priority. Range 1-200.
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

