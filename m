Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3831C31A9E8
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 05:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhBMEsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 23:48:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:39169 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhBMEsT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 23:48:19 -0500
IronPort-SDR: jq8UZgdACT0Jza3WrFM2xNQC/cmbecxnLWP6JOyvNfK63tDzDyIGGVXjtzu5wkEZaoOorocfYs
 ynlBnmwRlBYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="182579021"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="182579021"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 20:46:31 -0800
IronPort-SDR: 9PYXdlLVD1GGWgqnNqGexJNL4He3jXri3bWWuN0KtyuEDKvQ2AVEtEeREtxCZLVRst4mLgAKal
 kt8eDzYnD+0w==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="400088338"
Received: from coryjbev-mobl.amr.corp.intel.com ([10.255.230.149])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 20:46:30 -0800
Date:   Fri, 12 Feb 2021 20:46:30 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        Florian Westphal <fw@strlen.de>
cc:     kuba@kernel.org, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net-next 0/8] mptcp: Add genl events for connection
 info
In-Reply-To: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
Message-ID: <b89e4be5-cac-af1d-1c1-2ce92fa55e10@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Feb 2021, Mat Martineau wrote:

> This series from the MPTCP tree adds genl multicast events that are
> important for implementing a userspace path manager. In MPTCP, a path
> manager is responsible for adding or removing additional subflows on
> each MPTCP connection. The in-kernel path manager (already part of the
> kernel) is a better fit for many server use cases, but the additional
> flexibility of userspace path managers is often useful for client
> devices.
>
> Patches 1, 2, 4, 5, and 6 do some refactoring to streamline the netlink
> event implementation in the final patch.
>
> Patch 3 improves the timeliness of subflow destruction to ensure the
> 'subflow closed' event will be sent soon enough.
>
> Patch 7 allows use of the GENL_UNS_ADMIN_PERM flag on genl mcast groups
> to mandate CAP_NET_ADMIN, which is important to protect token information
> in the MPTCP events. This is a genetlink change.
>

David -

I noticed that this series got merged to net-next and shows as "Accepted" 
in patchwork:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0a2f6b32cc45e3918321779fe90c28f1ed27d2af


However, somehow patch 7 did not propagate through the netdev list and 
does not show up in patchwork or the merged series!


It did get archived on the cc'd mptcp list 
(https://lists.01.org/hyperkitty/list/mptcp@lists.01.org/message/KBY6UIFETMXCAOHNXQLYWKXNCHSGJ7AG/) 
so hopefully your directly-addressed copy also arrived. The missing patch 
won't cause a build error but does lead to a token getting exposed to 
non-admin users.

I will re-send it with an extra note about where it originally fit in.


Mat


> Patch 8 adds the MPTCP netlink events.
>
>
> Florian Westphal (8):
>  mptcp: move pm netlink work into pm_netlink
>  mptcp: split __mptcp_close_ssk helper
>  mptcp: schedule worker when subflow is closed
>  mptcp: move subflow close loop after sk close check
>  mptcp: pass subflow socket to a few helpers
>  mptcp: avoid lock_fast usage in accept path
>  genetlink: add CAP_NET_ADMIN test for multicast bind
>  mptcp: add netlink event support
>
> include/net/genetlink.h    |   1 +
> include/uapi/linux/mptcp.h |  74 +++++++++
> net/mptcp/options.c        |   2 +-
> net/mptcp/pm.c             |  24 ++-
> net/mptcp/pm_netlink.c     | 310 ++++++++++++++++++++++++++++++++++++-
> net/mptcp/protocol.c       |  72 ++++-----
> net/mptcp/protocol.h       |  20 +--
> net/mptcp/subflow.c        |  27 +++-
> net/netlink/genetlink.c    |  32 ++++
> 9 files changed, 491 insertions(+), 71 deletions(-)
>
>
> base-commit: c3ff3b02e99c691197a05556ef45f5c3dd2ed3d6
> -- 
> 2.30.1
>
>

--
Mat Martineau
Intel
