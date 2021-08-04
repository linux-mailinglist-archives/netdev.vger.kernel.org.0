Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08303E04B3
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbhHDPso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhHDPsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:48:42 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AEEC0613D5;
        Wed,  4 Aug 2021 08:48:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id a20so3513006plm.0;
        Wed, 04 Aug 2021 08:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uVR++srqzKEza84ydvF70klwPUW2q5Z+fc6h5nNUeDg=;
        b=BYWKWBBOHSR/q8Uy3UaPYy/sQ9tzQdEo4/S2QQOHlt9zrb7a9UT1xin+7kdUX4fJgK
         CD/gmsb57b8iY0xid1jg+27JYiSPWIqkmKUj/RF+MsX8u2SWsgfkpWlB0yYsgs5hF6RD
         kin6iRb/iIAXKXTbi5Du/MoR4sjspc/uz9AukKHusuOfgKyGlWAB+rxzg5+b6EID5iXa
         qRmCwwiq+tqVkqhI3O7ZWI+G/IVhkr3y8upHltX1bX0gPhmO2CH3R3fH5nnTKcSPZWU5
         Bqz1vgNJDFjlUGRZNE4oyZiAqs0sJYymGnhTW1VeA2bUyOFGtQzlcdvEEcPvKuBLNjpk
         3G4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uVR++srqzKEza84ydvF70klwPUW2q5Z+fc6h5nNUeDg=;
        b=uKyYxTOQ/W2EOPN6Jkn3Alhj/llA32IV6n2A0J9FB5YqpeGAObEndBJWXRwOgxaYyS
         DFTIaEe/tY1NMEDHggakbSRDkMGRhw3ejzUJ6Eo+Y7D9WLCnaInz4wU/Ru7BvuUK/odJ
         4dT5n3fvoHnT1cc5K6PVAkRK2m3KOjnzG5bdAqSc1zjNKWx0OFqc9/4R9bgq2UhsBl1a
         d3iHtq3Y0gYJcUzy0ov8r97gCQ+2ZFHW1m9rXoETAAQh7eHep+BSzAVAkkDKDQ/tN0hJ
         1d5b/YDyr6Vj0M9IjirSr6dEOIbiX5e0NwNHnn0YBHpeYSlXkk1a8TAcs3Q3Vpl+UY2F
         72Zg==
X-Gm-Message-State: AOAM530MVvVT6eeqFOIUDwMW2ioAqwcepywo0JB+qqfFJKVadtdW/x2d
        oJ8CFY/bhwEILlsochF9c3c=
X-Google-Smtp-Source: ABdhPJz1ZiBXE1dBU67RCm2FBYwTbdo5gF6c/WDoBiwc/NjeTHlH4M6mxtO41aiH3+6suNYGFGGK+A==
X-Received: by 2002:a17:90a:2ec6:: with SMTP id h6mr10206833pjs.9.1628092108733;
        Wed, 04 Aug 2021 08:48:28 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b15sm4007274pgj.60.2021.08.04.08.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:48:28 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RESEND PATCH v5 0/6] Bluetooth: fix locking and socket killing in SCO and RFCOMM
Date:   Wed,  4 Aug 2021 23:47:06 +0800
Message-Id: <20210804154712.929986-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apologies, resending because I botched the previous cover-letter and
linux-bluetooth was left out of the cc. Just noticed when the
bluez.test.bot didn't respond. Please reply to this series rather than
the one sent previously.

Hi,

This patch series started out as a fix for "inconsistent lock state in
sco_sock_timeout" reported by Syzbot [1].

Patch 1 is sufficient to fix this error. This was also confirmed by the
reproducer for "BUG: corrupted list in kobject_add_internal (3)" [2]
which consistently hits the inconsistent lock state error.

However, while testing the proposed fix, the reproducer for [1] would
randomly return a human-unreadable error [3]. After further
investigation, this bug seems to be caused by an unrelated error with
forking [4].

While trying to fix the mysterious error, additional fixes were added,
such as switching to lock_sock and serializing _{set,clear}_timer.

Additionally, as the reproducer kept hitting the oom-killer, a fix for
SCO socket killing was also added.

The reproducer for [1] was robust enough to catch errors with these
additional fixes, hence all the patches in this series were squashed then
tested with the reproducer for [1].

Overall, this series makes the following changes:

- Patch 1: Schedule SCO sock timeouts with delayed_work to avoid
inconsistent lock usage (removes SOFTIRQs from SCO)

- Patch 2: Avoid a circular dependency between hci_dev_lock and
lock_sock (enables the switch to lock_sock)

- Patch 3: Switch to lock_sock in SCO now that SOFTIRQs and potential
deadlocks are removed

- Patch 4: Serialize calls to sco_sock_{set,clear}_timer

- Patch 5: Switch to lock_sock in RFCOMM

- Patch 6: fix SCO socket killing

v4 -> v5:
- Renamed the delayed_work variable, moved checks for sco_pi(sk)->conn
into sco_sock_{clear,set}_timer, as suggested by Luiz Augusto von Dentz
and Marcel Holtmann.
- Added check for conn->sk in sco_sock_timeout, accompanied by a
sock_hold to avoid UAF errors.
- Added check to flush work items before freeing conn.
- Avoid a circular dependency between hci_dev_lock and lock_sock.
- Switch to lock_sock in SCO, as suggested by Marcel Holtmann.
- Serial calls to sco_sock_{set,clear}_timer.
- Switch to lock_sock in RFCOMM, as suggested by Marcel Holtmann.
- Add a fix for SCO socket killing.

v3 -> v4:
- Switch to using delayed_work to schedule SCO sock timeouts instead
of using local_bh_disable. As suggested by Luiz Augusto von Dentz.

v2 -> v3:
- Split SCO and RFCOMM code changes, as suggested by Luiz Augusto von
Dentz.
- Simplify local bh disabling in SCO by using local_bh_disable/enable
inside sco_chan_del since local_bh_disable/enable pairs are reentrant.

v1 -> v2:
- Instead of pulling out the clean-up code out from sco_chan_del and
using it directly in sco_conn_del, disable local softirqs for relevant
sections.
- Disable local softirqs more thoroughly for instances of
bh_lock_sock/bh_lock_sock_nested in the bluetooth subsystem.
Specifically, the calls in af_bluetooth.c and rfcomm/sock.c are now made
with local softirqs disabled as well.

Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]

Link: https://syzkaller.appspot.com/bug?extid=66264bf2fd0476be7e6c [2]

Link: https://syzkaller.appspot.com/text?tag=CrashReport&x=172d819a300000 [3]

Link: https://syzkaller.appspot.com/bug?id=e1bf7ba90d8dafcf318666192aba1cfd65507377 [4]

Best wishes,
Desmond

Desmond Cheong Zhi Xi (6):
  Bluetooth: schedule SCO timeouts with delayed_work
  Bluetooth: avoid circular locks in sco_sock_connect
  Bluetooth: switch to lock_sock in SCO
  Bluetooth: serialize calls to sco_sock_{set,clear}_timer
  Bluetooth: switch to lock_sock in RFCOMM
  Bluetooth: fix repeated calls to sco_sock_kill

 net/bluetooth/rfcomm/sock.c |   8 +--
 net/bluetooth/sco.c         | 107 +++++++++++++++++++++---------------
 2 files changed, 66 insertions(+), 49 deletions(-)

-- 
2.25.1

