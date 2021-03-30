Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A872034E718
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhC3MGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:06:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:33814 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232070AbhC3MFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:05:53 -0400
IronPort-SDR: 1iGF2GMFfvGnA4fXIWCPHFsqCwmisj9g2BEx+dtymkZ1/sigoNxK8t5rfhw4i7GGB9p6uA8rmo
 s5a6frk3ITbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="171158219"
X-IronPort-AV: E=Sophos;i="5.81,290,1610438400"; 
   d="scan'208";a="171158219"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 05:05:53 -0700
IronPort-SDR: HT3KRORVvmcg4mfuV28S5tQXjyJh8J7m/6+5gvRt3dZx9bzd6HjEvi/Z619XDf2/7QScFoF+1p
 kfuDKah6SJXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,290,1610438400"; 
   d="scan'208";a="418145830"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2021 05:05:49 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        alexei.starovoitov@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v3 bpf 0/3] AF_XDP Socket Creation Fixes
Date:   Tue, 30 Mar 2021 11:34:16 +0000
Message-Id: <20210330113419.4616-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some issues around socket creation for AF_XDP.

Patch 1 fixes a potential NULL pointer dereference in
xsk_socket__create_shared.

Patch 2 ensures that the umem passed to xsk_socket__create(_shared)
remains unchanged in event of failure.

Patch 3 makes it possible for xsk_socket__create(_shared) to
succeed even if the rx and tx XDP rings have already been set up by
introducing a new flag to struct xsk_umem.

v2->v3:
* Instead of ignoring the return values of the setsockopt calls, introduce
  a new flag to determine whether or not to call them based on the ring
  setup status as suggested by Alexei.

v1->v2:
* Simplified restoring the _save pointers as suggested by Magnus.
* Fixed the condition which determines whether to unmap umem rings
 when socket create fails.

This series applies on commit 861de02e5f3f2a104eecc5af1d248cb7bf8c5f75


Ciara Loftus (3):
  libbpf: ensure umem pointer is non-NULL before dereferencing
  libbpf: restore umem state after socket create failure
  libbpf: only create rx and tx XDP rings when necessary

 tools/lib/bpf/xsk.c | 48 +++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 15 deletions(-)

-- 
2.17.1

