Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CB229C808
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 20:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760007AbgJ0TAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 15:00:49 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:40979 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371354AbgJ0TAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 15:00:07 -0400
Received: by mail-wr1-f51.google.com with SMTP id s9so3112814wro.8
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 12:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kDUiHW1MfcT0hQvQpNHHUdUqPUEuNLL0EOKagikppV4=;
        b=zozL3O4fhwV+eInXCTSiOV/1/3ZJZr/1Mg1iWR7NTjUN5J+d5vk3gAwc+U3YrN/JmL
         Nhvk7NI8SSSHjVUTaI0DLZvyWMmcrjiXBevmcrvUMl8LQ3Gesx/uqHwRDI+QgBxFEBTN
         poDsOAM1SO96mRkJ5ebtAX0uXFP1Eeo7HcPOQOWKb74Y1cmIAVFsE+CKTSYu1pV4hZ4j
         s3hL6JxUBxjYvkXCeajLJe1axdZJH2aFRlCKx3IfVwbvgBopxKu6jvbM5Ymv90s0ZO2+
         0AYkOfhQoCvkSJhVWGZ8ftbIQf8JTRNKWkufCgsxGzg031FjnlgFUQBY/Us1col8I+qp
         F/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kDUiHW1MfcT0hQvQpNHHUdUqPUEuNLL0EOKagikppV4=;
        b=dy2VB0axjxGBuc0LWc0aQfsGvt816YAaIwktl5y3gipN5yarLJchbAWJ/1Uqn4aBmo
         vNb57nq2xvHJ62fyN/ps/O6Oej/762hWjS4/S/kDFFtFjby7BDWOv8l+cdjUtz3OqIN6
         yDGvegjrzSMForhfOoQFnGjquggLrAvqrh/pD//XgVl2wsIBbmNxlDdgF5Eoex1128jv
         OfMh2PSp6mBP2oHb/plRZpkABICV41LiqyV75GCTIYLYWZeYbYEkoffZ120Aoz838cAs
         KdgTBFMzKAX47/0f6cFJxZSz9VtaLd74wr5ddNR1N9G7H90zClsLc/wDc+1TBR13bWQs
         PPnQ==
X-Gm-Message-State: AOAM532FxsHdWF9YGuuJY0l0bISCuQ1wmEb/kTQjxr264rbdKWnv1+bh
        qGAHYzY2OrMf1WPlkmCPZUD7aHLUVmwPrsqM
X-Google-Smtp-Source: ABdhPJyJ6A+tYawPoWsuF/hnWiKAJbeMENBKvV8iueGQAYqw4SxPi6PBuksOWw/1HX+Akf06ZSEtLQ==
X-Received: by 2002:adf:9027:: with SMTP id h36mr4416494wrh.163.1603825204749;
        Tue, 27 Oct 2020 12:00:04 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x6sm3219803wmb.17.2020.10.27.12.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 12:00:03 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 00/16] selftests: net: bridge: add tests for IGMPv3
Date:   Tue, 27 Oct 2020 20:59:18 +0200
Message-Id: <20201027185934.227040-1-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set adds tests for the bridge's new IGMPv3 support. The tests use
precooked packets which are sent via mausezahn and the resulting state
after each test is checked for proper X,Y sets, (*,G) source list, source
list entry timers, (S,G) existence and flags, packet forwarding and
blocking, exclude group expiration and (*,G) auto-add. The first 3 patches
prepare the existing IGMPv2 tests, then patch 4 adds new helpers which are
used throughout the rest of the v3 tests.
The following new tests are added:
 - base case: IGMPv3 report 239.10.10.10 is_include (A)
 - include -> allow report
 - include -> is_include report
 - include -> is_exclude report
 - include -> to_exclude report
 - exclude -> allow report
 - exclude -> is_include report
 - exclude -> is_exclude report
 - exclude -> to_exclude report
 - include -> block report
 - exclude -> block report
 - exclude timeout (move to include + entry deletion)
 - S,G port entry automatic add to a *,G,exclude port

The variable names and set notation are the same as per RFC 3376,
for more information check RFC 3376 sections 4.2.15 and 6.4.1.
MLDv2 tests will be added by a separate patch-set.

Thanks,
 Nik

Nikolay Aleksandrov (16):
  selftests: net: bridge: rename current igmp tests to igmpv2
  selftests: net: bridge: igmp: add support for packet source address
  selftests: net: bridge: igmp: check for specific udp ip protocol
  selftests: net: bridge: igmp: add IGMPv3 entries' state helpers
  selftests: net: bridge: add tests for igmpv3 is_include and inc ->
    allow reports
  selftests: net: bridge: add test for igmpv3 inc -> is_include report
  selftests: net: bridge: add test for igmpv3 inc -> is_exclude report
  selftests: net: bridge: add test for igmpv3 inc -> to_exclude report
  selftests: net: bridge: add test for igmpv3 exc -> allow report
  selftests: net: bridge: add test for igmpv3 exc -> is_include report
  selftests: net: bridge: add test for igmpv3 exc -> is_exclude report
  selftests: net: bridge: add test for igmpv3 exc -> to_exclude report
  selftests: net: bridge: add test for igmpv3 inc -> block report
  selftests: net: bridge: add test for igmpv3 exc -> block report
  selftests: net: bridge: add test for igmpv3 exclude timeout
  selftests: net: bridge: add test for igmpv3 *,g auto-add

 .../selftests/net/forwarding/bridge_igmp.sh   | 532 +++++++++++++++++-
 1 file changed, 520 insertions(+), 12 deletions(-)

-- 
2.25.4

