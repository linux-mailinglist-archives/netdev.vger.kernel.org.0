Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327CF3DD6FA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhHBNYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbhHBNYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:24:38 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F05C06175F;
        Mon,  2 Aug 2021 06:24:28 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m19so10424345wms.0;
        Mon, 02 Aug 2021 06:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r6VD1/MvCByyDBh3eD7A4b/2BBf18YnD+OBDx/y19hw=;
        b=UyKFcVz804Q2ppFOal/On85bZoWxxUyz1jS/e1+luJKke5AilKwGaKBtoht6KkxRcU
         8VPW7EevKVC4/HIloHb2F/lyQVsVSAjcrNKg48iCrCvdPiIY8Da3oZo3ZEo+FIIxDXt5
         kHb48f9mv9VEa7SFwjubwJkRfceAFmIabbypgs3m7BlMKu/GuTNiV90ciCHpq4+yIgE/
         dzNF59jQUDBLNjwLKJiH8vIyBitXuzjZykrRWkECBZKun1IN3D4lX+ufDAN4zTVLxmKW
         yRZV97OlqNixxpyDEA3vnCddCeYPEf9xKQncMEDvCharVWm1jlVPoRrKdxZQv/tCi5gr
         8+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r6VD1/MvCByyDBh3eD7A4b/2BBf18YnD+OBDx/y19hw=;
        b=aVl6LP/oIclF/l20xnjwyou1mhxH7DOU9s9nJbmTY2Pbi/mBl7zhzcAeCjW9NylHnj
         asrHo31otLspXpNJNoOcZvgcl3gSiQCAIfYWNM0/V+SDTRTG6/TbBtK/dDVcv65VSzMD
         d9Y5F3WjwwqZ6iMOzyPRWjY++vwF3+MgNku1f9MvEi26grUa7r73ybpThJAaN6jGDWO/
         Gg3UMNOUaMB2nE3J53t0bq92Q/6nc263wAChVrvK6Kag3Yg0oExlLPRufReh3ErBMzae
         CZA5duqFnxy6TvXYf2HDMr3eBL+PvRTgih+ZAc6gD7VHmuziQOny4XXQLrh8QxB6EUWf
         qvjA==
X-Gm-Message-State: AOAM5317Oqvo4OPBzNR7C08JCLT7/pJPnTyLLaogM7Ll5w5vFY0d2aA+
        I51ZFid6iscXHTNBsanIkzEl1cjFfROo
X-Google-Smtp-Source: ABdhPJy/Tb+c6nc6wiqtXwPiJD9dUVUYg6jbdMSNln6xnNuSYOq1zraoFX0L3GdsC5EQYJWIo/qCzA==
X-Received: by 2002:a05:600c:c9:: with SMTP id u9mr16891517wmm.146.1627910666560;
        Mon, 02 Aug 2021 06:24:26 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id o28sm11731404wra.71.2021.08.02.06.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:24:25 -0700 (PDT)
From:   joamaki@gmail.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Subject: [PATCH bpf-next v4 0/6] XDP bonding support
Date:   Wed, 28 Jul 2021 23:43:44 +0000
Message-Id: <20210728234350.28796-1-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210609135537.1460244-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces XDP support to the bonding driver.

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
of cache misses were caused by the shared rr_tx_counter. Fix for this
has been already merged into net-next. The statistics were collected 
using "sar -n dev -u 1 10".

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

Patch 1 prepares bond_xmit_hash for hashing xdp_buff's.
Patch 2 adds hooks to implement redirection after bpf prog run.
Patch 3 implements the hooks in the bonding driver. 
Patch 4 modifies devmap to properly handle EXCLUDE_INGRESS with a slave device.
Patch 5 fixes an issue related to recent cleanup of rcu_read_lock in XDP context.
Patch 6 adds tests

v3->v4:
- Add back the test suite, while removing the vmtest.sh modifications to kernel
  config new that CONFIG_BONDING=y is set. Discussed with Magnus Karlsson that 
  it makes sense right now to not reuse the code from xdpceiver.c for testing 
  XDP bonding.

v2->v3:
- Address Jay's comment to properly exclude upper devices with EXCLUDE_INGRESS
  when there are deeper nesting involved. Now all upper devices are excluded.
- Refuse to enslave devices that already have XDP programs loaded and refuse to
  load XDP programs to slave devices. Earlier one could have a XDP program loaded
  and after enslaving and loading another program onto the bond device the xdp_state
  of the enslaved device would be pointing at an old program.
- Adapt netdev_lower_get_next_private_rcu so it can be called in the XDP context.

v1->v2:
- Split up into smaller easier to review patches and address cosmetic 
  review comments.
- Drop the INDIRECT_CALL optimization as it showed little improvement in tests.
- Drop the rr_tx_counter patch as that has already been merged into net-next.
- Separate the test suite into another patch set. This will follow later once a
  patch set from Magnus Karlsson is merged and provides test utilities that can
  be reused for XDP bonding tests. v2 contains no major functional changes and
  was tested with the test suite included in v1.
  (https://lore.kernel.org/bpf/202106221509.kwNvAAZg-lkp@intel.com/T/#m464146d47299125d5868a08affd6d6ce526dfad1)

---


