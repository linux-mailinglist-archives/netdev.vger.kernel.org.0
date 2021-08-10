Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C892C3E51D8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbhHJERX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhHJERW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 00:17:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED22C0613D3;
        Mon,  9 Aug 2021 21:17:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d17so19208653plr.12;
        Mon, 09 Aug 2021 21:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q4nrj3q8Waey/7IrkEtGabSQMyYHkF1rQSDCNTh8Q9w=;
        b=UpNw8UUXY9Hr5q8gB9F/+Umm8LD6F20RYlPHfn8zb7widsdkaXdQjYKKZApHYCXI6Y
         n9U3SBM7xFiVpFebhz5+90v1fo1Ek9T3DX+TeU8EssijpoE/dEmc+03ir/7lzcTkwC7u
         /35C6Dp03oSHLa9DRWkSgTpKsFH4pmv4O1ON3lj5GlgTpUHFrEfgm/IWBeozZ/yVPVLT
         MVOtU76loWsEAYL8VrmiwstVXhXPuaiVp280mcdLTqSsgYDMPNSiwUZMz8U68UJ+XCtS
         ZcrENRvfqPz5hbIJDyzviyHdP2y0uoApnVvBJkHbwr+WQecYHGllZi/yjr5YDBd4k7Zj
         glEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q4nrj3q8Waey/7IrkEtGabSQMyYHkF1rQSDCNTh8Q9w=;
        b=qubre/cGzS3iANkO3puf5sjFAKy56697WZwOkUzAaHOwErqZnkZ/AX1yxhb80oYYwk
         mOyDEicFCnNMBR1PrIfvpukn6iUnt1j773IcXipMnfcNnhsQDeXnnugqG0S+5z2PWRqI
         qJy5ol4rrNYK5YSxMl+/L3UxvOc5atBdtd1P+2bJ4rb29FJWW20QgYMSzJhGeW9fPATt
         2CpiZXTchr+wZ5QWObLU1oIEQJVs+aMghfGysPllsumLz4yMxItiRogTa2K0LK/Dge7C
         37Bhl3HXQIXGCPZI3YHoHnwX03puRb9JGo5rD9SRPj+bixXNdGvngxzKEX+/5cWLMcG3
         8jGg==
X-Gm-Message-State: AOAM530dMvHnYmPEJ15uYXso2jMUUoEDb5qbmCoyTqY6BlFrdVzRb7gZ
        om6H0jZ8D4vjUwCZk84Z3lI=
X-Google-Smtp-Source: ABdhPJxRWtB1Cs89xuEEhFINXS3HafPHK4xUJexggFUkX/NwxSNbJx6HhCvsZbqAqtBRRTKMjs8xvg==
X-Received: by 2002:a63:da0a:: with SMTP id c10mr156685pgh.255.1628569021104;
        Mon, 09 Aug 2021 21:17:01 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b8sm20132478pjo.51.2021.08.09.21.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 21:17:00 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v6 0/6] Bluetooth: fix locking and socket killing in SCO and RFCOMM
Date:   Tue, 10 Aug 2021 12:14:04 +0800
Message-Id: <20210810041410.142035-1-desmondcheongzx@gmail.com>
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

v5 -> v6:
- Removed hard tab characters from patch 2's commit message. As
suggested by the Bluez test bot.
- Removed unnecessary dedicated variables for struct delayed_work* in
sco_sock_{set,clear}_timer as suggested by Luiz Augusto von Dentz.

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
 net/bluetooth/sco.c         | 101 ++++++++++++++++++++----------------
 2 files changed, 60 insertions(+), 49 deletions(-)

-- 
2.25.1

