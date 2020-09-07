Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA7C25F8F1
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgIGK4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:56:24 -0400
Received: from mga12.intel.com ([192.55.52.136]:22272 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgIGK4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:56:21 -0400
IronPort-SDR: TJTpybBuRxpVPkA8HQ6iVLofC9V3d8cooB+CqyPFFVXWzioUfFML+DwgZLfKHjG9UK+cEbNQg5
 pheE7jXA54GA==
X-IronPort-AV: E=McAfee;i="6000,8403,9736"; a="137503288"
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="137503288"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2020 03:56:21 -0700
IronPort-SDR: haIiBvqZXXwkE6pW6vKULio2NxvjM4+4EQxz752QobHhd0YNtT2XLPS9cIUT2vUL7wGSpe5dH0
 2L588EOQRovA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="303698262"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.131])
  by orsmga006.jf.intel.com with ESMTP; 07 Sep 2020 03:56:19 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/2] fix dead lock issues in vhost_vdpa
Date:   Mon,  7 Sep 2020 18:52:18 +0800
Message-Id: <20200907105220.27776-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.18.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixed a dead lock issue in vhost_vdpa.
In current vhost_vdpa ioctl code path, it will lock
vhost_dev mutex once, then try to re-lock it in
vhost_set_backend_features, which is buggy.

These commits will remove mutex locks operations
in vhost_set_backend_features, then as a compensation,
a new function vhost_net_set_backend_features() in vhost_net
is introduced to do proper mutex locking and call
vhost_set_backend_features()

Please help review. Thanks!

Zhu Lingshan (2):
  vhost: remove mutex ops in vhost_set_backend_features
  vhost_net: introduce vhost_net_set_backend_features()

 drivers/vhost/net.c   | 9 ++++++++-
 drivers/vhost/vhost.c | 2 --
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.18.4

