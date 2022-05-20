Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F952E10D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343928AbiETASq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343924AbiETASo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C68954B9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 17:18:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A031CB82948
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 00:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D13AC385B8;
        Fri, 20 May 2022 00:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653005920;
        bh=d2dvxVqaKtpA03ai3zC3jeHjcNU5xow9vtRVpWEMCA4=;
        h=From:To:Cc:Subject:Date:From;
        b=grASGCBdMsqYHzQOpzeFoiIG+6EOBx5V9YimVVyotG0rwfevmrx4aUq7eJdT8szeZ
         2m0R8j9edJ7LD3MZm9xKw8Rw/k8nqTye4gV5xGc5nKuQZkLwAwHg1SQUp99F5PkgmC
         GYfvvgdkZzvNH8WsK6mVg3ZQEpHHRrztwSW3/XDuIWLe832K9NeCXXLxeN79W+k8UA
         P7jq6LTXe+lJAG7CPFnQdid6Q/WM4RMwTlDbexg3ViLrs2KigsrZKKBnkWbAvA+EDh
         c2h2Ujqv80tQV7slc/kxi0RRsHhjLJMbmQ0ImaYaCDXBdliz4Urz6EqqljqLm5Mzro
         166AzFqo7WaTQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v5 resend 0/2] Add a bhash2 table hashed by port + address
Date:   Thu, 19 May 2022 17:18:32 -0700
Message-Id: <20220520001834.2247810-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joanne Koong says:

This patchset proposes adding a bhash2 table that hashes by port and address.
The motivation behind bhash2 is to expedite bind requests in situations where
the port has many sockets in its bhash table entry, which makes checking bind
conflicts costly especially given that we acquire the table entry spinlock
while doing so, which can cause softirq cpu lockups and can prevent new tcp
connections.

We ran into this problem at Meta where the traffic team binds a large number
of IPs to port 443 and the bind() call took a significant amount of time
which led to cpu softirq lockups, which caused packet drops and other failures
on the machine

The patches are as follows:
1/2 - Adds a second bhash table (bhash2) hashed by port and address
2/2 - Adds a test for timing how long an additional bind request takes when
the bhash entry is populated

When experimentally testing this on a local server for ~24k sockets bound to
the port, the results seen were:

ipv4:
before - 0.002317 seconds
with bhash2 - 0.000018 seconds

ipv6:
before - 0.002431 seconds
with bhash2 - 0.000021 seconds

v4 -> v5:
v4:
https://lore.kernel.org/netdev/20220512205041.1208962-1-joannelkoong@gmail.com/

* Remove "inline" in check_bind2_bucket_match function
* Add line breaks to limit lengths to 80 columns
* Rebase to master and fix merge conflict

v3 -> v4:
v3:
https://lore.kernel.org/netdev/20220511000424.2223932-1-joannelkoong@gmail.com/

* Fix the fix for the dccp bhash2 allocation

v2 -> v3:
v2:
https://lore.kernel.org/netdev/20220510005316.3967597-1-joannelkoong@gmail.com/

* Fix bhash2 allocation error handling for dccp
* Rebase onto net-next/master

v1 -> v2:
v1:
https://lore.kernel.org/netdev/20220421221449.1817041-1-joannelkoong@gmail.com/

* Attached test for timing bind request

Joanne Koong (2):
  net: Add a second bind table hashed by port and address
  selftests: Add test for timing a bind request to a port with a
    populated bhash entry

 include/net/inet_connection_sock.h            |   3 +
 include/net/inet_hashtables.h                 |  68 ++++-
 include/net/sock.h                            |  14 +
 net/dccp/proto.c                              |  33 ++-
 net/ipv4/inet_connection_sock.c               | 247 +++++++++++++-----
 net/ipv4/inet_hashtables.c                    | 193 +++++++++++++-
 net/ipv4/tcp.c                                |  14 +-
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 tools/testing/selftests/net/bind_bhash_test.c | 119 +++++++++
 10 files changed, 611 insertions(+), 83 deletions(-)
 create mode 100644 tools/testing/selftests/net/bind_bhash_test.c

-- 
2.34.3

