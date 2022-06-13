Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159C55495D4
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244230AbiFMKpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 06:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346101AbiFMKnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 06:43:31 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D99DEDF
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 03:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655115881; x=1686651881;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PEsdp93wvc1fL9qH5EgR315FZGofJNycm63tynp6czo=;
  b=XqGs/VzSW91P30XwZMV1xvs0rNqeXGlpFeIyCsbynBhnnQZWKTfOBOHM
   Sq4ZExBLG/qldoiVAw2nJRdMLx1wYfHBArX5eY7Mb7ghgNY147CT6ecP1
   dQVMx2TbzxZuCliePXHXHbIIptjH9HcrVIqyl0nths594h7tr1vKk8YdT
   wzuBLnNyJZvdJvQCzlW5jt+dmAm9dLvAH4E3cX+wLEez4Wq/o9+ioF4C7
   ZlO8ZCsggCQol52o9jhK0+yrIbcL6dxG95EL3jGYSh5OU6y8nbl0dvGY/
   XjjTltMqsIHWcKTJF3MVmqb/gDBDtIi9p7P/Gfksy13MPJmeQnJyXeagS
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10376"; a="266930296"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266930296"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="829730380"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2022 03:24:39 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/6] ifcvf/vDPA: support query device config space through netlink
Date:   Mon, 13 Jun 2022 18:16:46 +0800
Message-Id: <20220613101652.195216-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series allows userspace to query device config space of vDPA
devices and the management devices through netlink,
to get multi-queue, feature bits

This series has introduced a new netlink attr
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, this should be used to query
features of vDPA  devices than the management device.

Please help review.

Thanks!
Zhu Lingshan

Changes from V1:
(1) Use __virito16_to_cpu(true, xxx) for the le16 casting(Jason)
(2) Add a comment in ifcvf_get_config_size(), to explain
why we should return the minimum value of
sizeof(struct virtio_net_config) and the onboard
cap size(Jason)
(3) Introduced a new attr VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES
(4) Show the changes of iproute2 output before and after 5/6 patch(Jason)
(5) Fix cast warning in vdpa_fill_stats_rec() 

Zhu Lingshan (6):
  vDPA/ifcvf: get_config_size should return a value no greater than dev
    implementation
  vDPA/ifcvf: support userspace to query features and MQ of a management
    device
  vDPA: allow userspace to query features of a vDPA device
  vDPA: !FEATURES_OK should not block querying device config space
  vDPA: answer num of queue pairs = 1 to userspace when VIRTIO_NET_F_MQ
    == 0
  vDPA: fix 'cast to restricted le16' warnings in vdpa.c

 drivers/vdpa/ifcvf/ifcvf_base.c | 25 +++++++++++++++++++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h |  3 +++
 drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
 drivers/vdpa/vdpa.c             | 32 +++++++++++++++-----------------
 include/uapi/linux/vdpa.h       |  1 +
 5 files changed, 45 insertions(+), 19 deletions(-)

-- 
2.31.1

