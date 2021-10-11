Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06A7428CC4
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 14:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhJKMOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 08:14:48 -0400
Received: from www62.your-server.de ([213.133.104.62]:36936 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbhJKMOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 08:14:47 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mZuAf-000Edl-JE; Mon, 11 Oct 2021 14:12:45 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next 0/4] Managed Neighbor Entries
Date:   Mon, 11 Oct 2021 14:12:34 +0200
Message-Id: <20211011121238.25542-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26319/Mon Oct 11 10:18:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a couple of fixes related to NTF_EXT_LEARNED and NTF_USE
neighbor flags, extends the UAPI with a new NDA_FLAGS_EXT netlink attribute
in order to be able to add new neighbor flags from user space given all
current struct ndmsg / ndm_flags bits are used up. Finally, the core of this
series adds a new NTF_EXT_MANAGED flag to neighbors, which allows user space
control planes to add 'managed' neighbor entries. Meaning, user space may
either transition existing entries or can push down new L3 entries without
lladdr into the kernel where the latter will periodically try to keep such
NTF_EXT_MANAGED managed entries in reachable state. Main use case for this
series are XDP / tc BPF load-balancers which make use of the bpf_fib_lookup()
helper for backends. For more details, please see individual patches. Thanks!

Daniel Borkmann (3):
  net, neigh: Fix NTF_EXT_LEARNED in combination with NTF_USE
  net, neigh: Enable state migration between NUD_PERMANENT and NTF_USE
  net, neigh: Add NTF_MANAGED flag for managed neighbor entries

Roopa Prabhu (1):
  net, neigh: Extend neigh->flags to 32 bit to allow for extensions

 include/net/neighbour.h        |  34 ++++--
 include/uapi/linux/neighbour.h |  35 ++++--
 net/core/neighbour.c           | 196 +++++++++++++++++++++++----------
 3 files changed, 187 insertions(+), 78 deletions(-)

-- 
2.27.0

