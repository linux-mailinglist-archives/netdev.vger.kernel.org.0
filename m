Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B563A163A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhFIN6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236958AbhFIN57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:57:59 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA432C061574;
        Wed,  9 Jun 2021 06:55:54 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id a11so23730729wrt.13;
        Wed, 09 Jun 2021 06:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7t7X04vzCTHIxCa3IDNgOPzg2je9vj/B9OsZ/fIoo8w=;
        b=e9Cma61WoApKlU2hG0rjRtXXpZTR7scKTwEJmtKUKrxSQfKZieJiXnbM2IsnHaYUwp
         QdGJh+8woZpw3asy2gMSLmcOioY6IdKpcAMHflfoqpg2IrKCLB/zLs5mnOcKfMX00hUc
         Rs48i5N/ExLuCV/2uht03sxkZmz2WnenRhlFgqVnLTs41sboTPHlPJ7lwR05pX8UuBmP
         50Xbk1wKt6LZu+YUm3Ga+wBORrOWTUKFuC3vJyaSe4qzZY3oqhoLggCO/qu/PSojV/2F
         r9tdsToyJeiMxCUHWTw8pQaPBhoAIuEjWjsJSGe+GvEyUvOj2N+PIdHEpkgyi4m2LFJ/
         dTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7t7X04vzCTHIxCa3IDNgOPzg2je9vj/B9OsZ/fIoo8w=;
        b=nfHW47HnhNyUhOSLpS1mCoCFRxqv4n1HC/XDrpujJvblrpUD6+nLddCDD1+aFVag1O
         HouX/pbfxb2ChyU5NzfVOVisJyrDXEPL9GzteghyK75pyXpulkEU8vu6FYStgj/FP+gn
         IQd492yv/xvXau+Hgkv2zevWkIMovrOiZmpj5a01URa6hiRNYj7a59+J2Q3VHufgB3x0
         u5RnpASKAIUCf1yS9/pB3Xn7gyfsGZSHWdTid1TEg8rM5uKUS47DQek+tunoTG64IJTK
         0Tigmlj+BRG/RhZZHS2FFEpm4k6mu9fejGtbvw0dkfHflqO12wIDpKmBcTd/Ps76FWEd
         TIZg==
X-Gm-Message-State: AOAM530PZmonn/QxecFdxqMvBmiwA3+DsWKTT2dxwH+vU2ESEiQaKpJ8
        Tk1bg5ywmV9+F0bzg9wlLXa1VkAXk0re5S4=
X-Google-Smtp-Source: ABdhPJy7qZeb/zVTKKaU7Rr0yPUMxs+YZjMvwiNUdjXXVix4HcXMFF8M6ccirHbUd31XkU4FLsYWrg==
X-Received: by 2002:adf:e943:: with SMTP id m3mr28383979wrn.384.1623246953081;
        Wed, 09 Jun 2021 06:55:53 -0700 (PDT)
Received: from balnab.. ([37.17.237.224])
        by smtp.gmail.com with ESMTPSA id q20sm4575wrf.45.2021.06.09.06.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:55:52 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next 0/3] XDP bonding support
Date:   Wed,  9 Jun 2021 13:55:34 +0000
Message-Id: <20210609135537.1460244-1-joamaki@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces XDP support to the bonding driver.

Patch 1 contains the implementation, including support for
the recently introduced EXCLUDE_INGRESS. Patch 2 contains a
performance fix to the roundrobin mode which switches rr_tx_counter
to be per-cpu. Patch 3 contains the test suite for the implementation
using a pair of veth devices.

The vmtest.sh is modified to enable the bonding module and install
modules. The config change should probably be done in the libbpf
repository. Andrii: How would you like this done properly?

The motivation for this change is to enable use of bonding (and
802.3ad) in hairpinning L4 load-balancers such as [1] implemented with
XDP and also to transparently support bond devices for projects that
use XDP given most modern NICs have dual port adapters.  An alternative
to this approach would be to implement 802.3ad in user-space and
implement the bonding load-balancing in the XDP program itself, but
is rather a cumbersome endeavor in terms of slave device management
(e.g. by watching netlink) and requires separate programs for native
vs bond cases for the orchestrator. A native in-kernel implementation
overcomes these issues and provides more flexibility.

Below are benchmark results done on two machines with 100Gbit
Intel E810 (ice) NIC and with 32-core 3970X on sending machine, and
16-core 3950X on receiving machine. 64 byte packets were sent with
pktgen-dpdk at full rate. Two issues [2, 3] were identified with the
ice driver, so the tests were performed with iommu=off and patch [2]
applied. Additionally the bonding round robin algorithm was modified
to use per-cpu tx counters as high CPU load (50% vs 10%) and high rate
of cache misses were caused by the shared rr_tx_counter (see patch
2/3). The statistics were collected using "sar -n dev -u 1 10".

 -----------------------|  CPU  |--| rxpck/s |--| txpck/s |----
 without patch (1 dev):
   XDP_DROP:              3.15%      48.6Mpps
   XDP_TX:                3.12%      18.3Mpps     18.3Mpps
   XDP_DROP (RSS):        9.47%      116.5Mpps
   XDP_TX (RSS):          9.67%      25.3Mpps     24.2Mpps
 -----------------------
 with patch, bond (1 dev):
   XDP_DROP:              3.14%      46.7Mpps
   XDP_TX:                3.15%      13.9Mpps     13.9Mpps
   XDP_DROP (RSS):        10.33%     117.2Mpps
   XDP_TX (RSS):          10.64%     25.1Mpps     24.0Mpps
 -----------------------
 with patch, bond (2 devs):
   XDP_DROP:              6.27%      92.7Mpps
   XDP_TX:                6.26%      17.6Mpps     17.5Mpps
   XDP_DROP (RSS):       11.38%      117.2Mpps
   XDP_TX (RSS):         14.30%      28.7Mpps     27.4Mpps
 --------------------------------------------------------------

RSS: Receive Side Scaling, e.g. the packets were sent to a range of
destination IPs.

[1]: https://cilium.io/blog/2021/05/20/cilium-110#standalonelb
[2]: https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/T/#t
[3]: https://lore.kernel.org/bpf/CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com/

---

Jussi Maki (3):
  net: bonding: Add XDP support to the bonding driver
  net: bonding: Use per-cpu rr_tx_counter
  selftests/bpf: Add tests for XDP bonding

 drivers/net/bonding/bond_main.c               | 459 +++++++++++++++---
 include/linux/filter.h                        |  13 +-
 include/linux/netdevice.h                     |   5 +
 include/net/bonding.h                         |   3 +-
 kernel/bpf/devmap.c                           |  34 +-
 net/core/filter.c                             |  37 +-
 .../selftests/bpf/prog_tests/xdp_bonding.c    | 342 +++++++++++++
 tools/testing/selftests/bpf/vmtest.sh         |  30 +-
 8 files changed, 843 insertions(+), 80 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bonding.c

-- 
2.30.2

