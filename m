Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332B3440961
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 16:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhJ3OJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 10:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhJ3OJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 10:09:55 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1677BC061570
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 07:07:25 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l1so5571024pfu.5
        for <netdev@vger.kernel.org>; Sat, 30 Oct 2021 07:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jqiVotWqUwyfd65UbqJrOKuwTI6zOlZIJGMGWWOBxuU=;
        b=bxRL108hu6NBTvuEpar/eAgMohrbbrHBFVGSzd48ErsVe/o/IssxoXxl/Lzocn5tNV
         f3BFzvi/fS0JW3/x09Z6f3f8M3MBepw5xbVVGxnzZHNbJSPNeB96ItCbJvg0PqpzI9nQ
         wMoqFLRjaYbMB66kLMcZ/SsEq6krV4nAqL5U2snA+CUezdDZvSkT4xfQArZVqToxMlR8
         +Cb9XiB3ZWClFtixe6aelZxzHlFzIGwqss1agQz7EYf3fiSO6PjPJxpZSOnpkTFgCJBl
         jf2ay90pjw/xybpo4hLli/q4BOkSYcyaLZXX8cs4I1dYcER3D1ffCAoG0VTnJw00IZwz
         VW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jqiVotWqUwyfd65UbqJrOKuwTI6zOlZIJGMGWWOBxuU=;
        b=NztWApowPlKuxmbvEKZtD2jXJOOtXCpmZUvw7c8uqqTCVHh6swr92wR8ie6xQSHySQ
         3DysP1QrjLfXlOnsPaSowYnonbCpXWtZJWqxE/QgJw7IPa4t5qL9uetc8hLmAEMXpvZn
         DUm3k88gPjOAud0xYIQtFNUVddwaxZjKvjanVRnlgtNiq8NB+cIHl9BKw+yuoSusHhOl
         BntJS4JQEIXwUbyJF27q19Xat4LhGipj0xlM3mias9qppm9mLll3LYmIWdXFc5NXC+Yc
         aoWOQKI7HG1YDj2jLi3qqiH352qpKUqeRPAKGCnlJi3OFLzPlRTJuQ6Tqa1JR/FhoPEM
         pwzg==
X-Gm-Message-State: AOAM531OEJ0uQ5bjVJ69obwqahKQiGCd+f2/UZgzJNbzL8EFIdSOeLWJ
        6XQfdU64ynHn/yAkVUJcs0JHsARMVXTeZw==
X-Google-Smtp-Source: ABdhPJzAL/D/yND1FYdjwIVpXzOxcGE38WA6ezhvzlVXb4LFq/0MfZtXb6L3V920jJJIp57UC15lqQ==
X-Received: by 2002:a05:6a00:2186:b0:47c:f63:a6e9 with SMTP id h6-20020a056a00218600b0047c0f63a6e9mr17652840pfi.26.1635602844566;
        Sat, 30 Oct 2021 07:07:24 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 142sm8278942pgh.22.2021.10.30.07.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Oct 2021 07:07:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     dkirjanov@suse.de, ap420073@gmail.com
Subject: [PATCH net-next v6 0/5] amt: add initial driver for Automatic Multicast Tunneling (AMT)
Date:   Sat, 30 Oct 2021 14:07:13 +0000
Message-Id: <20211030140718.16662-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an implementation of AMT(Automatic Multicast Tunneling), RFC 7450.
https://datatracker.ietf.org/doc/html/rfc7450

This implementation supports IGMPv2, IGMPv3, MLDv1, MLDv2, and IPv4
underlay.

 Summary of RFC 7450
The purpose of this protocol is to provide multicast tunneling.
The main use-case of this protocol is to provide delivery multicast
traffic from a multicast-enabled network to sites that lack multicast
connectivity to the source network.
There are two roles in AMT protocol, Gateway, and Relay.
The main purpose of Gateway mode is to forward multicast listening
information(IGMP, MLD) to the source.
The main purpose of Relay mode is to forward multicast data to listeners.
These multicast traffics(IGMP, MLD, multicast data packets) are tunneled.

Listeners are located behind Gateway endpoint.
But gateway itself can be a listener too.
Senders are located behind Relay endpoint.

    ___________       _________       _______       ________
   |           |     |         |     |       |     |        |
   | Listeners <-----> Gateway <-----> Relay <-----> Source |
   |___________|     |_________|     |_______|     |________|
      IGMP/MLD---------(encap)----------->
         <-------------(decap)--------(encap)------Multicast Data

 Usage of AMT interface
1. Create gateway interface
ip link add amtg type amt mode gateway local 10.0.0.1 discovery 10.0.0.2 \
dev gw1_rt gateway_port 2268 relay_port 2268

2. Create Relay interface
ip link add amtr type amt mode relay local 10.0.0.2 dev relay_rt \
relay_port 2268 max_tunnels 4

v1 -> v2:
 - Eliminate sparse warnings.
   - Use bool type instead of __be16 for identifying v4/v6 protocol.

v2 -> v3:
 - Fix compile warning due to unsed variable.
 - Add missing spinlock comment.
 - Update help message of amt in Kconfig.

v3 -> v4:
 - Split patch.
 - Use CHECKSUM_NONE instead of CHECKSUM_UNNECESSARY.
 - Fix compile error.

v4 -> v5:
 - Remove unnecessary rcu_read_lock().
 - Remove unnecessary amt_change_mtu().
 - Change netlink error message.
 - Add validation for IFLA_AMT_LOCAL_IP and IFLA_AMT_DISCOVERY_IP.
 - Add comments in amt.h.
 - Add missing dev_put() in error path of amt_newlink().
 - Fix typo.
 - Add BUILD_BUG_ON() in amt_smb_cb().
 - Use macro instead of magic values.
 - Use kzalloc() instead of kmalloc().
 - Add selftest script.

v5 -> v6:
 - Reset remote_ip in amt_dev_stop().

Taehee Yoo (5):
  amt: add control plane of amt interface
  amt: add data plane of amt interface
  amt: add multicast(IGMP) report message handler
  amt: add mld report message handler
  selftests: add amt interface selftest script

 MAINTAINERS                          |    8 +
 drivers/net/Kconfig                  |   16 +
 drivers/net/Makefile                 |    1 +
 drivers/net/amt.c                    | 3294 ++++++++++++++++++++++++++
 include/net/amt.h                    |  386 +++
 include/uapi/linux/amt.h             |   62 +
 tools/testing/selftests/net/Makefile |    1 +
 tools/testing/selftests/net/amt.sh   |  284 +++
 tools/testing/selftests/net/config   |    1 +
 9 files changed, 4053 insertions(+)
 create mode 100644 drivers/net/amt.c
 create mode 100644 include/net/amt.h
 create mode 100644 include/uapi/linux/amt.h
 create mode 100644 tools/testing/selftests/net/amt.sh

-- 
2.17.1

