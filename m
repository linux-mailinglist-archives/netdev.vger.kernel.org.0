Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FE22B36F3
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 18:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgKORI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 12:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgKORI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 12:08:28 -0500
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF56BC0613D1;
        Sun, 15 Nov 2020 09:08:28 -0800 (PST)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CYzDn52DKz1179;
        Sun, 15 Nov 2020 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605460105;
        bh=DVCw3AOuOJ588nHp3qo8FnNDgBvPpzmhwU8Id2izUtQ=;
        h=From:To:Cc:Subject:Date:From;
        b=QoA7TR+CAMCmcp4DKyn9tXNzLzme2rywfXgwh+GHQLZcHTdBHSkdq5qNdAsba+noR
         tJf6imAR2mIa8323vBuY/CK2s2oj7cs3FmTQAEBw7uAIbYRFAqOSIKwixd8/CCtR3C
         3JVOpJlFzNZs8LEHs7y5YXcv1xf+854Qws8mfwH0=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CYzDn38hhz115B;
        Sun, 15 Nov 2020 17:08:25 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, keescook@chromium.org,
        Francis Laniel <laniel_francis@privacyrequired.com>
Subject: [RESEND,net-next,PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Date:   Sun, 15 Nov 2020 18:08:03 +0100
Message-Id: <20201115170806.3578-1-laniel_francis@privacyrequired.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Francis Laniel <laniel_francis@privacyrequired.com>

Hi.


I hope you are all fine and the same for your relatives.

This patch set answers to first three issues listed in:
https://github.com/KSPP/linux/issues/110

To sum up, the patch contributions are the following:
1. the first patch fixes an inefficiency where some bytes in dst were written
twice, one with 0 the other with src content.
2. The second one modifies nla_strlcpy to return the same value as strscpy,
i.e. number of bytes written or -E2BIG if src was truncated.
It also modifies code that calls nla_strlcpy and checks for its return value.
3. The third renames nla_strlcpy to nla_strscpy.

Unfortunately, I did not find how to create struct nlattr objects so I tested
my modifications on simple char* and with GDB using tc to get to
tcf_proto_check_kind.

If you see any way to improve the code or have any remark, feel free to comment.


Best regards and take care of yourselves.

Francis Laniel (3):
  Fix unefficient call to memset before memcpu in nla_strlcpy.
  Modify return value of nla_strlcpy to match that of strscpy.
  treewide: rename nla_strlcpy to nla_strscpy.

 drivers/infiniband/core/nldev.c            | 10 +++---
 drivers/net/can/vxcan.c                    |  4 +--
 drivers/net/veth.c                         |  4 +--
 include/linux/genl_magic_struct.h          |  2 +-
 include/net/netlink.h                      |  4 +--
 include/net/pkt_cls.h                      |  2 +-
 kernel/taskstats.c                         |  2 +-
 lib/nlattr.c                               | 42 ++++++++++++++--------
 net/core/fib_rules.c                       |  4 +--
 net/core/rtnetlink.c                       | 12 +++----
 net/decnet/dn_dev.c                        |  2 +-
 net/ieee802154/nl-mac.c                    |  2 +-
 net/ipv4/devinet.c                         |  2 +-
 net/ipv4/fib_semantics.c                   |  2 +-
 net/ipv4/metrics.c                         |  2 +-
 net/netfilter/ipset/ip_set_hash_netiface.c |  4 +--
 net/netfilter/nf_tables_api.c              |  6 ++--
 net/netfilter/nfnetlink_acct.c             |  2 +-
 net/netfilter/nfnetlink_cthelper.c         |  4 +--
 net/netfilter/nft_ct.c                     |  2 +-
 net/netfilter/nft_log.c                    |  2 +-
 net/netlabel/netlabel_mgmt.c               |  2 +-
 net/nfc/netlink.c                          |  2 +-
 net/sched/act_api.c                        |  2 +-
 net/sched/act_ipt.c                        |  2 +-
 net/sched/act_simple.c                     |  4 +--
 net/sched/cls_api.c                        |  2 +-
 net/sched/sch_api.c                        |  2 +-
 net/tipc/netlink_compat.c                  |  2 +-
 29 files changed, 73 insertions(+), 61 deletions(-)

-- 
2.20.1

