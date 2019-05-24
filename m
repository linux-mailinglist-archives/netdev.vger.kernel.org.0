Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C31C29BB6
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 18:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390210AbfEXQDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 12:03:44 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:44804 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389706AbfEXQDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 12:03:44 -0400
Received: by mail-pg1-f202.google.com with SMTP id b24so6564825pgh.11
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 09:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OHF1GBrQyCg37n+zTf7JtBh7lIA83IKUgru/zJSPRic=;
        b=agWDUwFj+uzG3SUxflCtUnaJfJd3ImXvZelYq19tknsF+UsHDce7qMAEU9BzQCs38g
         4tnSuh+WI6whWbjgkv+uLPHv/xYcLYw3C0XhKk8llLYM6aDbZ9I0X3/yQszyHoLxh8Nl
         N6WGl92YIpYSpu3AUTFXCSpH661mgHaSXZ9c/XasxCVf6pQx6e+T5gD0efl9sZk6/CTo
         KcX78WXmc4emwPVu752/fk2U0csKBzTF38u3ByCD98/G0SvMQamIKUPNcZlhbtmDcSEy
         s4Rrk5Dx36j+chU/8l0lEAJv7hIz+IjWsw1k7wKQz7XF/f/Wk1I8aCgc6Pll3Lpzd/tq
         7jzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OHF1GBrQyCg37n+zTf7JtBh7lIA83IKUgru/zJSPRic=;
        b=U9/P//ZCHp0xu0fUyjvKkdCPqrmZbBpWCxoJiwcn0HOCBjRmxgCBJP1bCnNzphFyvI
         cxlixmTDGbr5VkLCToxJHKDrw710A1GAHrofdyxGdwIl7Ks1Nwnlp5AM7q947AsWn/CI
         kFax+vtpyd80qlpF5soqYQyHMkkI3Lsjt8Gp2Ut3rpShvz0ldInIvS6HEf/au9ByrW94
         SS8+fCh0dqWBPV5tKXNiWfjxkV0VKKd/C+rtjXXOtQurLoUbHG74PuEFOq0YhU41sVF2
         f+H45oUgsaYeKg1ZgZvSWQzyLefKt9DhXjLg5lFQjrkF248rQqsAosPbj2obwpeMKgkC
         270A==
X-Gm-Message-State: APjAAAX5a+i7SzckMzEfXeUQPTKabtG26PFAgEGmCtqe+H+7IC2+7VpB
        fvNwigHoY3BkcCO1Egii/fv3PHGXTKJ1FA==
X-Google-Smtp-Source: APXvYqzOvfHUBh0rw8HkCoo2GpZytd9oMI63DY12qtrLCEejS+DqJGnVzJywYmI+AVYr/oGndJI/+LFkEr1p5w==
X-Received: by 2002:a65:4246:: with SMTP id d6mr63431231pgq.156.1558713823631;
 Fri, 24 May 2019 09:03:43 -0700 (PDT)
Date:   Fri, 24 May 2019 09:03:29 -0700
Message-Id: <20190524160340.169521-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net-next 00/11] inet: frags: avoid possible races at netns dismantle
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes a race happening on netns dismantle with
frag queues. While rhashtable_free_and_destroy() is running,
concurrent timers might run inet_frag_kill() and attempt
rhashtable_remove_fast() calls. This is not allowed by
rhashtable logic.

Since I do not want to add expensive synchronize_rcu() calls
in the netns dismantle path, I had to no longer inline
netns_frags structures, but dynamically allocate them.

The ten first patches make this preparation, so that
the last patch clearly shows the fix.

As this patch series is not exactly trivial, I chose to
target 5.3. We will backport it once soaked a bit.

Eric Dumazet (11):
  inet: rename netns_frags to fqdir
  net: rename inet_frags_exit_net() to fqdir_exit()
  net: rename struct fqdir fields
  ipv4: no longer reference init_net in ip4_frags_ns_ctl_table[]
  ipv6: no longer reference init_net in ip6_frags_ns_ctl_table[]
  netfilter: ipv6: nf_defrag: no longer reference init_net in
    nf_ct_frag6_sysctl_table
  ieee820154: 6lowpan: no longer reference init_net in
    lowpan_frags_ns_ctl_table
  net: rename inet_frags_init_net() to fdir_init()
  net: add a net pointer to struct fqdir
  net: dynamically allocate fqdir structures
  inet: frags: rework rhashtable dismantle

 include/net/inet_frag.h                 | 48 ++++++++----
 include/net/netns/ieee802154_6lowpan.h  |  2 +-
 include/net/netns/ipv4.h                |  2 +-
 include/net/netns/ipv6.h                |  4 +-
 net/ieee802154/6lowpan/reassembly.c     | 36 ++++-----
 net/ipv4/inet_fragment.c                | 98 ++++++++++++++++---------
 net/ipv4/ip_fragment.c                  | 67 +++++++----------
 net/ipv4/proc.c                         |  4 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c | 43 +++++------
 net/ipv6/proc.c                         |  4 +-
 net/ipv6/reassembly.c                   | 40 ++++------
 11 files changed, 181 insertions(+), 167 deletions(-)

-- 
2.22.0.rc1.257.g3120a18244-goog

