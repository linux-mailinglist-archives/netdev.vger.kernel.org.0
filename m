Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B605A947E
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 12:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbiIAKZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 06:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiIAKY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 06:24:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C9E6141;
        Thu,  1 Sep 2022 03:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662027894; x=1693563894;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DE9er/r++Eh0HGejGPGgfn/Yx6ttgENKFiXi7F9Gl14=;
  b=lrHt/Q7uWKyTnGbejFFkBpKMXVIQV1oHMNkkfEz5VccHzVBpAswgZdB8
   ypPqBXYfbmmnhgMwTu/2GGjRGGygdpREZPXbrkU1Wg/D/U+9lgWKcb3iq
   YIzHqkiunypES1n6rT2PIUgVeV0AbjGJpQp6MIGqpOPJMgSzFJg5ERYUf
   wCRdH2YuneDSj3sK4vDYOsQMkxFMJDbr2+nzV1P4w0scC53XwVIT/HHQu
   mDK0y51b6ri/PKiCztFJOqCmKQTApSeE6c5EYL8IVukQbBk9JjLBETL5x
   oj95LYasYnjLSqze5YPfsZCyIj0w1H91ss0dq6Xd3EepeRLme226HoFTV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321825549"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321825549"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:53 -0700
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="642276416"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 03:24:51 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 0/4] vDPA: support VHOST_GET/SET_VRING_ENDIAN
Date:   Thu,  1 Sep 2022 18:15:57 +0800
Message-Id: <20220901101601.61420-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add ioctl VHOST_GET_VRING_ENDIAN and
VHOST_SET_VRING_ENDIAN support for vDPA.

Endian-ness is a device wide attribute, so QEMU
can get/set endian-ness of the device by these
ioctls, and QEMU can be aware of the endian-ness
of the device.

To support these ioctls, vendor driver needs to implement:
vdpa_config_ops.get_vq_endian: set vq endian-ness
vdpa_config_ops.set_vq_endian: get vq endian-ness

This series also call vdpa_config_ops.get_config()
instead of vdpa_get_config_unlocked() in
vdpa_dev_net_config_fill(). Then do endian-ness
covert properly through __virtio16_to_cpu by
support of vdpa_config_ops.get_vq_endian.
So there are no race on set_features() any more.

Zhu Lingshan (4):
  vDPA/ifcvf: add get/set_vq_endian support for vDPA
  vDPA: support ioctl VHOST_GET/SET_VRING_ENDIAN
  vDPA: detect device endian in _net_config_fill() and _fill_stats_rec()
  vDPA: report device endian-ness to userspace through netlink

 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 15 +++++++++++++++
 drivers/vdpa/vdpa.c             | 31 +++++++++++++++++++++++++++----
 drivers/vhost/vdpa.c            | 32 +++++++++++++++++++++++++++++++-
 include/linux/vdpa.h            | 13 +++++++++++++
 include/uapi/linux/vdpa.h       |  1 +
 6 files changed, 88 insertions(+), 5 deletions(-)

-- 
2.31.1

