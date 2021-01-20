Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D54B2FD701
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbhATRZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:25:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12372 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732822AbhATPpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 10:45:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60084fea0007>; Wed, 20 Jan 2021 07:44:42 -0800
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 15:44:39 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 0/3] nexthop: More fine-grained policies for netlink message validation
Date:   Wed, 20 Jan 2021 16:44:09 +0100
Message-ID: <cover.1611156111.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611157482; bh=yEch7dwQcWr8n3UTXK8Xq9dN9Igadj62UP9GOVe2huA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=Bt+OENDjnezbvROy0D9iec4S/uFwN0QF2MxF4a56aFRVj5p7LzAgBig0afqIIhb5q
         fuHs37a1tWJjYOk1kJz3lAaz6vWkyxHSlfmrxDme/J2Gy0S5RRuB1nufB0H2uT+iJV
         bkme7fuNe9j0dyr9Wb16JQskVrqBpVTIXAv+NFX/7af7xmaXz/XVKJhP90Yv8QNSmV
         CTbQb9gdk9fvxIddXYiZGy9ETGev3/A16b5SP4PbqrWYKmD63rXlcypGLJSIkoXgfr
         UqtMu/UnCN2LIsG1TPS8Rfs9GdVezGcW6imTKi3RcCqeL0J1LMr+IZ45SanShMVGlZ
         Gh3/Uk5J7po6g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

v2:
- Patches #1, #2 and #3:
    - Do not specify size of the policy array. Use ARRAY_SIZE instead
      of NHA_MAX
- Patch #2:
    - Convert manual setting of true to nla_get_flag().

Petr Machata (3):
  nexthop: Use a dedicated policy for nh_valid_get_del_req()
  nexthop: Use a dedicated policy for nh_valid_dump_req()
  nexthop: Specialize rtm_nh_policy

 net/ipv4/nexthop.c | 105 +++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 62 deletions(-)

--=20
2.26.2

