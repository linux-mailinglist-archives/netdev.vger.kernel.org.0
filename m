Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5963DFFC9
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbhHDLDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbhHDLDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 07:03:51 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7073EC061799;
        Wed,  4 Aug 2021 04:03:38 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a20so2655854plm.0;
        Wed, 04 Aug 2021 04:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jwMjX9uKOX34bxHroGHlO+KGwPb8TW7nGHLpbS6oqzs=;
        b=aWH8FPQcF8fQhUjm6O6pl9YL1byqoTvc6uU8AhtNMeTd3lIAGuZ25KPl6MaM9FpcYg
         AK72GH7TbKLvTXOMi4bnhw6zIlMm8Kx6ogrRfFOc+nwM+/I6c665iHHH+STgum4xFhUC
         pN6hTal3G3Fj1RZKfX4RW3kuk7DfkGgnS/rgwqjyfxmqwX1JXbkFHYfoaCpN+nJP4oNk
         d4g39isClzgBy70grsZ4r3rizQnGgZOhAh+6BFUus/Q5ACrgoYviYj1glJEeQmpuzml9
         UVE4iAb3aY2t88ryjV6Mqvn44EzuXlMttt9Nn9fMW68uxyHNpxw+vhQTDkcNvxz20pfa
         AP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jwMjX9uKOX34bxHroGHlO+KGwPb8TW7nGHLpbS6oqzs=;
        b=cC0mVDB/hLu8oT5S/vl3MkBc988krMQMq1fWGzUKMDREI8Ru7u5EcP31nhyrn2A3V5
         PeQ0/N1Lg1m9Wl6zRasSNtjAel0G/M9vGGRhJdwEdwsGWbfOsAHlIS1OrY65fKEup4J0
         2z9K26SKGnNzOBtaKRu8M0kgU1eOAO/sBWfGbNFBFws7u/RoF+3erwJltkAd2R6gFlqY
         OnSCpL334Z7kAX6JqbT1xcskxCFrWnst+hRk27jDKPBNwmTAL7X9i+7OMJRblc6Rg72D
         z1Y/uwbLPYhD5xw0brul25sB0GKvgzApAX9EthbTf2G8vksTAr5zAIqqtMF3dt7Szc3d
         54ew==
X-Gm-Message-State: AOAM5336K0LrctiY017/xaOfAzG5vqsZ/n6gVNRXy6K2ogJUxeLiddR5
        0Bf8LHdtIWCcgfCOPSNiRjONYvB0s0chEiyHGg0=
X-Google-Smtp-Source: ABdhPJxkL6C5JVgPh+WmVxXS7CD5vAKQHOzGQMgYJ68HC5d8vmswPnC0kPLsa24Tquu4MnmcgF4YGA==
X-Received: by 2002:aa7:804f:0:b029:334:4951:da88 with SMTP id y15-20020aa7804f0000b02903344951da88mr26922729pfm.29.1628075017777;
        Wed, 04 Aug 2021 04:03:37 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id k4sm2206147pjs.55.2021.08.04.04.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:03:37 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v5 0/6] Bluetooth: fix locking and socket killing in SCO and RFCOMM
Date:   Wed,  4 Aug 2021 19:03:02 +0800
Message-Id: <20210804110308.910744-1-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

