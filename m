Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4460116051
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 05:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfLHElr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 23:41:47 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34481 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfLHElr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 23:41:47 -0500
Received: by mail-pj1-f68.google.com with SMTP id j11so3309689pjs.1;
        Sat, 07 Dec 2019 20:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sAiAePc+IImK4Xt+HGGVXsrD6sWMzfEbVUIXwOMAyqI=;
        b=emwbodgQhH+rxC3GizMrFtVw3QMgdNaQljMTjD2RZH/WYlzw63lDyl4b5xmtZNDrz2
         DGAnjK8as6TDLDQ2M9gHAdlRLC9qvU4E9i5stVCBLiIdrUFjOyl51ZWB7Fdav7IS8hau
         KJdt2DoVB8XcskOokW9z80xpzJ0xaCcjBL1DSXVrgCdLi3WiYqJST+cefmf/6cwuy0hW
         YweYIiGq1JtYV3yYv4s/dV3ZiI3X7vpI07r01rOUlV07w+Qnm2reSbC/jXlQnhzYHMiB
         QmGQfScilY+PbsMhj0PbpnN7FQ4GzTIq873krJjqukXekVUP6GvMgElARIZRurZnEW0C
         /y7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sAiAePc+IImK4Xt+HGGVXsrD6sWMzfEbVUIXwOMAyqI=;
        b=EePE+S8KTYCTQcs9Urk4QJ/svJtOW6nzP25Me/4zyVqX+6Vp1E5tEOj7g06EgtNYVk
         Y39U/8qQc4Z3Z6oBOvqUZUvSaSVDN49kbApCONSpu03I2OZpItJQJItrR1qeSdhW1SmS
         U3grrdTVkkpBN0EjEMKcwtlVnCcV/KzLyOCii03ruPs6389B8FyuWLyY0aubuRfb0pl0
         tbSz9htCutznB8VrJ9oPnADrVyRE4fodRsKdl6L3D4JLCiyBU26046uhWpFkbvZdqP/8
         JG6AdX4YmNn7kdZYHBO27YINRmniXHmTgY6blw/D0OeIHmtFhWXO+gEeo8xF/NI4f3t1
         DL2Q==
X-Gm-Message-State: APjAAAW5byzr3cZuVpobVebI+3ylnOVmA7SMZTcHsfryxQfjbe/+3wwr
        sc325tA40MKHj3yNiHJ53GkjB2f9
X-Google-Smtp-Source: APXvYqwvfE4dFkS1yqQX+D9h1R9y9fE9o6PVTgF9DZmIRq1hmMMvrS7XLti6rAhwW695vByDMQnLow==
X-Received: by 2002:a17:90a:2469:: with SMTP id h96mr25232688pje.121.1575780106083;
        Sat, 07 Dec 2019 20:41:46 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p17sm20610219pfn.31.2019.12.07.20.41.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Dec 2019 20:41:45 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 0/7] netfilter: nft_tunnel: reinforce key opts support
Date:   Sun,  8 Dec 2019 12:41:30 +0800
Message-Id: <cover.1575779993.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset improves quite a few places to make vxlan/erspan
opts in nft_tunnel work with userspace nftables/libnftnl, and
also keep consistent with the support for vxlan/erspan opts in
act_tunnel_key, cls_flower and ip_tunnel_core.

Meanwhile, add support for geneve opts in nft_tunnel. One patch
for nftables and one for libnftnl will be posted here for the
testing. With them, nft_tunnel can be set and used by:

  # nft add table ip filter
  # nft add chain ip filter input { type filter hook input priority 0 \; }
  # nft add tunnel filter vxlan_01 { type vxlan\; id 2\; \
    ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
    sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
    opts \"ffff\"\; }
  # nft add tunnel filter erspan_01 { type erspan\; id 2\; \
    ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
    sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
    opts \"1:1:0:0\"\; }
  # nft add tunnel filter erspan_02 { type erspan\; id 2\; \
    ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
    sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
    opts \"2:0:1:1\"\; }
  # nft add tunnel filter geneve_01 { type geneve\; id 2\; \
    ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
    sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
    opts \"1:1:1212121234567890\"\; }
  # nft add tunnel filter geneve_02 { type geneve\; id 2\; \
    ip saddr 192.168.1.1\; ip daddr 192.168.1.2\; \
    sport 9000\; dport 9001\; dscp 1234\; ttl 64\; flags 1\; \
    opts \"1:1:34567890,2:2:12121212,3:3:1212121234567890\"\; }
  # nft list tunnels table filter
  # nft add rule filter input ip protocol udp tunnel name geneve_02
  # nft add rule filter input meta l4proto udp tunnel id 2 drop
  # nft add rule filter input meta l4proto udp tunnel path 0 drop
  # nft list chain filter input -a

Xin Long (7):
  netfilter: nft_tunnel: parse ERSPAN_VERSION attr as u8
  netfilter: nft_tunnel: parse VXLAN_GBP attr as u32 in nft_tunnel
  netfilter: nft_tunnel: no need to call htons() when dumping ports
  netfilter: nft_tunnel: also dump ERSPAN_VERSION
  netfilter: nft_tunnel: also dump OPTS_ERSPAN/VXLAN
  netfilter: nft_tunnel: add the missing nla_nest_cancel()
  netfilter: nft_tunnel: add support for geneve opts

 include/uapi/linux/netfilter/nf_tables.h |  10 ++
 net/netfilter/nft_tunnel.c               | 170 +++++++++++++++++++++++++------
 2 files changed, 151 insertions(+), 29 deletions(-)

-- 
2.1.0

