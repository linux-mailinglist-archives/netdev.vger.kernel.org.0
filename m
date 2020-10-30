Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7092A0A05
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 16:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgJ3PhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgJ3PhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 11:37:12 -0400
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35247C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 08:37:12 -0700 (PDT)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CN5yl28rnz12cc;
        Fri, 30 Oct 2020 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1604072223;
        bh=j4NYs9Jl6xgkNi0+LQhpNE5IV9k30c3Bw/mkwJWZ+2E=;
        h=From:To:Cc:Subject:Date:From;
        b=Npk5xjWT1c6jf9wXK7Xc5cSrjgSGTfOAFhAoOWUgKVBpgS5La3DCOV5OaXut3BCni
         R12JkEhRXtUL0wFJzjqBYYjH7XSMwqlujhuixXKXlWSEYff8iFGlDjYrpIfOxIo4Hs
         XgHDKCa2tTnuMyMgyc7/Z6SgBaAzUBPs026ISvR4=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CN5yl0BM3z12cb;
        Fri, 30 Oct 2020 15:37:02 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, keescook@chromium.org,
        Francis Laniel <laniel_francis@privacyrequired.com>
Subject: [PATCH v4 0/3] Fix inefficiences and rename nla_strlcpy
Date:   Fri, 30 Oct 2020 16:36:44 +0100
Message-Id: <20201030153647.4408-1-laniel_francis@privacyrequired.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Francis Laniel <laniel_francis@privacyrequired.com>

Hi.


I hope your relatives and yourselves are fine.

This patch set answers to first three issues listed in:
https://github.com/KSPP/linux/issues/110

To sum up, the first patch fixes an inefficiency where some bytes in dst were
written twice, one with 0 the other with src content.
The second one modifies nla_strlcpy to return the same value as strscpy,
i.e. number of bytes written or -E2BIG if src was truncated.
The third rename nla_strlcpy to nla_strscpy.

Unfortunately, I did not find how to create struct nlattr objects so I tested
my modifications on simple char* and withing GDB with tc to get to
tcf_proto_check_kind.
This is why I tagged this patch set as RFC.

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

