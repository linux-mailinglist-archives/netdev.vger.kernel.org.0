Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CC72940F4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 18:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395026AbgJTQ5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 12:57:12 -0400
Received: from devianza.investici.org ([198.167.222.108]:38637 "EHLO
        devianza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389316AbgJTQ5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 12:57:11 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2020 12:57:11 EDT
Received: from mx2.investici.org (unknown [127.0.0.1])
        by devianza.investici.org (Postfix) with ESMTP id 4CG00d03jqz6vKZ;
        Tue, 20 Oct 2020 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1603212449;
        bh=+aIkg35DbjRXubheAk2uHZ96TIMg/Oac32Ru/dFGc/o=;
        h=From:To:Cc:Subject:Date:From;
        b=szjTLAiYnpDjPAqpjblQ04HP/DVpE7ApTYd6t7QtHEFQwSQhF1f8GzAzKxRGlxBpK
         86pZ87u7SmVvuDM83qi4IYOgihbJMXUSwhIuKvctwW57gh8xcPGmYChKEys0IK3EWi
         lWA19/tvy6XNJ1pmRd4EtSIvWaBIivUI+Ua8l81w=
Received: from [198.167.222.108] (mx2.investici.org [198.167.222.108]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CG00c4xg1z6vKY;
        Tue, 20 Oct 2020 16:47:28 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Francis Laniel <laniel_francis@privacyrequired.com>
Subject: [RFC][PATCH v3 0/3] Fix inefficiences and rename nla_strlcpy
Date:   Tue, 20 Oct 2020 18:47:04 +0200
Message-Id: <20201020164707.30402-1-laniel_francis@privacyrequired.com>
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

The name nla_strscpy should be discussed and agreed to find a representative
name (nla_strscpy_pad, nla_strcpy, nla_strzcpy, etc.).

Unfortunately, I did not find how to create struct nlattr objects so I tested
my modifications on simple char* and withing GDB with tc to get to
tcf_proto_check_kind.
This is why I tagged this patch set as RFC.

If you see any way to improve the code or have any remark, feel free to comment.


Best regards.

Francis Laniel (3):
  Fix unefficient call to memset before memcpu in nla_strlcpy.
  Modify return value of nla_strlcpy to match that of strscpy.
  Rename nla_strlcpy to nla_strscpy.

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

