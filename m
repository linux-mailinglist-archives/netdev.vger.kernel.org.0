Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BF72B19BD
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 12:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgKMLOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 06:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgKMLNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 06:13:13 -0500
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAC0C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 03:13:13 -0800 (PST)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4CXbQK10XNz12Vl;
        Fri, 13 Nov 2020 11:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1605265913;
        bh=DVCw3AOuOJ588nHp3qo8FnNDgBvPpzmhwU8Id2izUtQ=;
        h=From:To:Cc:Subject:Date:From;
        b=a0+hW5aYUcFIfRN104mQ6dIh1lmMlXsbRhVPZ4Y95QU/ns228ARUzb3LyymGlC13h
         0W0Pn/7BLPVnPzgJnVA5JOKXceT2OqvOnfllPfHaxqERLzdeDnsJ6YkQ4Ewv4ZB9g/
         6FTJAFLRbOuyreLEREQd1+HPUQLIMM0UVlwqltXY=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CXbQJ69Byz12W4;
        Fri, 13 Nov 2020 11:11:52 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     linux-hardening@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, keescook@chromium.org,
        Francis Laniel <laniel_francis@privacyrequired.com>
Subject: [PATCH v5 0/3] Fix inefficiences and rename nla_strlcpy
Date:   Fri, 13 Nov 2020 12:11:30 +0100
Message-Id: <20201113111133.15011-1-laniel_francis@privacyrequired.com>
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

