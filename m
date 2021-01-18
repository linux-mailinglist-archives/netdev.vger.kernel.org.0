Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6312FA28E
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 15:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392685AbhAROHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 09:07:14 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1508 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392680AbhAROGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 09:06:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600595d10000>; Mon, 18 Jan 2021 06:06:09 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 14:06:06 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.org>
Subject: [PATCH net-next 0/3] nexthop: More fine-grained policies for netlink message validation
Date:   Mon, 18 Jan 2021 15:05:22 +0100
Message-ID: <cover.1610978306.git.petrm@nvidia.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610978769; bh=YiXpGIg7h1HnqallO872AkmJ+cJ0tdvPuyZJd+X5vKU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=cdO4JWSzATjWcb+G3nZNG5LF2jTU346jYFDcuk+dydVUR77/LSuTnxXXOppiMUKPk
         +zLWFVNoPxFQMWC+00HBT6apSyfBBKHTSTLSct1iOa28WhDmrd40nj07K1dZCu2WtL
         ifnvzoT+WM62NBTdZVEzStxCB1JuwYQJKoPI3aZr70mxovNWnAKN3L311MTiHa1hT9
         spfn3QVxReqlqoFGRL+nFHoWu6E2nxZ4B9SfQkMlDtyzv2vmHvivaGeNiOFIxVYyte
         8nwUX+DsnJhgrGSj4qdmEmQ2eotCqYsYJVUS+Gv5JLzx/vjEZ/qYzygPsudw1MON/g
         nvwXSrOM1Utog==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.org>

There is currently one policy that covers all attributes for next hop
object management. Actual validation is then done in code, which makes it
unobvious which attributes are acceptable when, and indeed that everything
is rejected as necessary.

In this series, split rtm_nh_policy to several policies that cover various
aspects of the next hop object configuration, and instead of open-coding
the validation, defer to nlmsg_parse(). This should make extending the next
hop code simpler as well, which will be relevant in near future for
resilient hashing implementation.

This was tested by running tools/testing/selftests/net/fib_nexthops.sh.
Additionally iproute2 was tweaked to issue "nexthop list id" as an
RTM_GETNEXTHOP dump request, instead of a straight get to test that
unexpected attributes are indeed rejected.

In patch #1, convert attribute validation in nh_valid_get_del_req().

In patch #2, convert nh_valid_dump_req().

In patch #3, rtm_nh_policy is cleaned up and renamed to rtm_nh_policy_new,
because after the above two patches, that is the only context that it is
used in.

Petr Machata (3):
  nexthop: Use a dedicated policy for nh_valid_get_del_req()
  nexthop: Use a dedicated policy for nh_valid_dump_req()
  nexthop: Specialize rtm_nh_policy

 net/ipv4/nexthop.c | 85 +++++++++++++++++-----------------------------
 1 file changed, 32 insertions(+), 53 deletions(-)

--=20
2.26.2

