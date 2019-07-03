Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFBF5E7A2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfGCPTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:19:54 -0400
Received: from mail-qt1-f172.google.com ([209.85.160.172]:42058 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCPTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:19:54 -0400
Received: by mail-qt1-f172.google.com with SMTP id h18so1558741qtm.9
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 08:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=w2s2iSpX3LwSAFagkb60z4QHyvrVU3W/v24sOkaE1UE=;
        b=PgOr1JzTUVuWFtP9S8KBA1SAZrBs/s5/DIskf+v45YNXU64ODQDk4glPQ31ViWapDh
         RMUQ2f5B6y+PyzXA2vFSpOPex26W9jOcKf8WRb7XeKxZV7iaHWrkA9PBHiAjczxot3vz
         pIpeeiBVlMneUkUq/NwuncHn+e+TxrdG2tzvedSw8jAqRpIoRPT1xT7xQYuAQ3pdxRVZ
         PP73zNvpiCsILuV8SqXyTOPBGwPbu/cUl+RaL4IJvfPiEZV3ABMOIOvR0zZmPPZxF1Ow
         POcrto44xF7EpmWgRWWfMvLEi2iDYryQuKu39C0F2w7Ty6d5WvHje7K+alyLImlXFEUo
         g4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w2s2iSpX3LwSAFagkb60z4QHyvrVU3W/v24sOkaE1UE=;
        b=FkqjIrgow6t8ocNzAYBlPvK+/6xP2GUsF/JAyMgDydT9iJOe/JcZ5c1v9PLo6wFy8t
         10Duucwz/ZYCPGHwTF7EOpMQYwu+H5k9IvhKbMThgggTmQIRL+Lg0T4x7+CImD91Ez3/
         OPrmM4qIe9EQdTgKRSwu2vyH55VPRhE+Mqe1w/RcwX9j2QRPmfsROiNzUolzPSaDAkiB
         HlKqu8OSxaZFrJKhdRqZZxu5KT0MMlL78bRmK8nM3J1QeuRBDrg+eRIey4cR9xpslDRY
         De7NCO/XmLAJPMr5/70j6N799OjIP0kqsc0SJLgkE6yzHmg0ezwsvPSHrJuChh9H4ja4
         /EKg==
X-Gm-Message-State: APjAAAWESf0XM6RHpwjDwOUhUkg6mzO4in7CGvfuUjzxfIBuCLBRfuUt
        t6Hd+tY3ultx6UVqZxdW/RefqPj2+Q==
X-Google-Smtp-Source: APXvYqwg6aROjCGpALrsjxnhmu7XYhHY0XHiCMMlmKlfwjgMg+NqJsr++qvcf/0T1eXuygwZeUKcGg==
X-Received: by 2002:a0d:d714:: with SMTP id z20mr23944880ywd.23.1562167193659;
        Wed, 03 Jul 2019 08:19:53 -0700 (PDT)
Received: from localhost.localdomain (99-149-127-125.lightspeed.rlghnc.sbcglobal.net. [99.149.127.125])
        by smtp.gmail.com with ESMTPSA id 73sm1243303ywd.88.2019.07.03.08.19.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 08:19:52 -0700 (PDT)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, nikolay@cumulusnetworks.com, dsahern@gmail.com,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net-next 0/3] net: Multipath hashing on inner L3 
Date:   Wed,  3 Jul 2019 11:19:31 -0400
Message-Id: <20190703151934.9567-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series extends commit 363887a2cdfe ("ipv4: Support multipath
hashing on inner IP pkts for GRE tunnel") to include support when the
outer L3 is IPv6 and to consider the case where the inner L3 is
different version from the outer L3, such as IPv6 over GRE over IPv4 or
vice versa. It also includes kselftest scripts to test the use cases.

Stephen Suryaputra (3):
  ipv4: Multipath hashing on inner L3 needs to consider inner IPv6 pkts
  ipv6: Support multipath hashing on inner IP pkts
  selftests: forwarding: Test multipath hashing on inner IP pkts for GRE
    tunnel

 Documentation/networking/ip-sysctl.txt        |   1 +
 net/ipv4/route.c                              |  21 +-
 net/ipv6/route.c                              |  36 +++
 .../net/forwarding/gre_inner_v4_multipath.sh  | 305 +++++++++++++++++
 .../net/forwarding/gre_inner_v6_multipath.sh  | 306 ++++++++++++++++++
 .../forwarding/ip6gre_inner_v4_multipath.sh   | 304 +++++++++++++++++
 .../forwarding/ip6gre_inner_v6_multipath.sh   | 305 +++++++++++++++++
 7 files changed, 1274 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/gre_inner_v4_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/gre_inner_v6_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_inner_v4_multipath.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_inner_v6_multipath.sh

-- 
2.17.1

