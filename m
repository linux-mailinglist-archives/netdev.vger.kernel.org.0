Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C435331BE3B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhBOQDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:03:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:36145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232204AbhBOP5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 10:57:16 -0500
IronPort-SDR: DY019EcOb2qfEaJhLQn94YCko3NDOY7uu/5lwEwVLoBwL9D3uAoz6DIfj5Sdxs9tICkWnK+V2R
 PvPvFosAWZ3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244189533"
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="244189533"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 07:56:35 -0800
IronPort-SDR: fkPDogwZcTtlpuJKedTaNCJnfJpZUWMMUiANBy7F+PbXzDx0kWbKPx/rdOfYGpkflK4qqioCcK
 2tuD5J9Oag4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="383413519"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2021 07:56:33 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 0/3] Introduce bpf_link in libbpf's xsk
Date:   Mon, 15 Feb 2021 16:46:35 +0100
Message-Id: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This set is another approach towards addressing the below issue:

// load xdp prog and xskmap and add entry to xskmap at idx 10
$ sudo ./xdpsock -i ens801f0 -t -q 10

// add entry to xskmap at idx 11
$ sudo ./xdpsock -i ens801f0 -t -q 11

terminate one of the processes and another one is unable to work due to
the fact that the XDP prog was unloaded from interface.

Previous attempt was, to put it mildly, a bit broken, as there was no
synchronization between updates to additional map, as Bjorn pointed out.
See https://lore.kernel.org/netdev/20190603131907.13395-5-maciej.fijalkowski@intel.com/

In the meantime bpf_link was introduced and it seems that it can address
the issue of refcounting the XDP prog on interface. More info on commit
messages.

Thanks.

Maciej Fijalkowski (3):
  libbpf: xsk: use bpf_link
  libbpf: clear map_info before each bpf_obj_get_info_by_fd
  samples: bpf: do not unload prog within xdpsock

 samples/bpf/xdpsock_user.c |  55 ++++----------
 tools/lib/bpf/xsk.c        | 147 +++++++++++++++++++++++++++++++------
 2 files changed, 139 insertions(+), 63 deletions(-)

-- 
2.20.1

