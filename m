Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A5394D4A
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 18:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhE2Q7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 12:59:08 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:56766 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhE2Q7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 12:59:08 -0400
Received: from localhost (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 9BA4FAAD459;
        Sat, 29 May 2021 18:57:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1622307449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=acZCODMVIfo7hE7GQKxy20Z7jTwbvcULRej4Ycy93LA=;
        b=R6ExW1Y8KNlbX12BtZMz/P8UuKMBlltds3x6YlD0EAjB90yumXF0ZEqSYFDfKWX3W/X7wA
        iy4wFHX0xxMphpkJ8kWP3vgbU8XNMUEwzMIekbfNJa8m3d3nrRXZSGF6zjt4+eVIkpNnAU
        suGgy+z+i8yzSot0Ys72x8NWWMA5DNE=
Date:   Sat, 29 May 2021 18:57:28 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>
Subject: Divide error in minstrel_ht_get_tp_avg()
Message-ID: <20210529165728.bskaozwtmwxnvucx@spock.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

The following woe happened on my home router running as a Wi-Fi AP with
MT7612:

```
[16592.157962] divide error: 0000 [#1] PREEMPT SMP PTI
[16592.163169] CPU: 2 PID: 683 Comm: mt76-tx phy0 Tainted: G         C        5.12.0-pf4 #1
[16592.171745] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./J3710-ITX, BIOS P1.50 04/16/2018
[16592.182155] RIP: 0010:minstrel_ht_get_tp_avg+0xb1/0x100 [mac80211]
[16592.188795] Code: 04 00 00 00 7f 1c 31 c9 81 fa f1 49 02 00 0f 9c c1 8d 0c cd 08 00 00 00 eb 08 8b 47 30 b9 01 00 00 00 69 c0 e8 03 00 00 31 d2 <f7> f1 ba 66 0e 00 00 39 d6 0f 4f f2 49 63 d1 48 8d 0c 52 48 8d 0c
[16592.208796] RSP: 0018:ffffb6a601293be8 EFLAGS: 00010246
[16592.214292] RAX: 000000000001a5e0 RBX: ffff9c658ee95170 RCX: 0000000000000000
[16592.222054] RDX: 0000000000000000 RSI: 0000000000000585 RDI: ffff9c658ee94000
[16592.229620] RBP: 0000000000000006 R08: 0000000000000006 R09: 0000000000000012
[16592.237254] R10: 0000000000000007 R11: 0000000000000000 R12: ffff9c658ee94000
[16592.244828] R13: 0000000000000012 R14: ffff9c658ee9534c R15: 0000000000000585
[16592.252635] FS:  0000000000000000(0000) GS:ffff9c66f8500000(0000) knlGS:0000000000000000
[16592.261086] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16592.267326] CR2: 0000555d81abe7b8 CR3: 0000000116c10000 CR4: 00000000001006e0
[16592.274904] Call Trace:
[16592.277549]  minstrel_ht_update_stats+0x1fe/0x1320 [mac80211]
[16592.283730]  minstrel_ht_tx_status+0x67f/0x710 [mac80211]
[16592.289442]  rate_control_tx_status+0x6e/0xb0 [mac80211]
[16592.295267]  ieee80211_tx_status_ext+0x22e/0xb00 [mac80211]
[16592.311290]  ieee80211_tx_status+0x7d/0xa0 [mac80211]
[16592.316714]  mt76_tx_status_unlock+0x83/0xa0 [mt76]
[16592.321999]  mt76x02_send_tx_status+0x1b7/0x400 [mt76x02_lib]
[16592.334516]  mt76x02_tx_worker+0x8f/0xd0 [mt76x02_lib]
[16592.340091]  __mt76_worker_fn+0x78/0xb0 [mt76]
[16592.345067]  kthread+0x183/0x1b0
[16592.353378]  ret_from_fork+0x22/0x30
```

`faddr2line` says it is this:

```
 430 int
 431 minstrel_ht_get_tp_avg(struct minstrel_ht_sta *mi, int group, int rate,
 432                int prob_avg)
 433 {
…
 435     unsigned int ampdu_len = 1;
…
 441     if (minstrel_ht_is_legacy_group(group))
…
 443     else
 444         ampdu_len = minstrel_ht_avg_ampdu_len(mi);
…
 446     nsecs = 1000 * overhead / ampdu_len;
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

So, it seems `minstrel_ht_avg_ampdu_len()` can return 0, which is not
really legitimate.

Looking at `minstrel_ht_avg_ampdu_len()`, I see the following:

```
16:#define MINSTREL_SCALE  12
…
18:#define MINSTREL_TRUNC(val) ((val) >> MINSTREL_SCALE)
```

```
 401 static unsigned int
 402 minstrel_ht_avg_ampdu_len(struct minstrel_ht_sta *mi)
 403 {
…
 406     if (mi->avg_ampdu_len)
 407         return MINSTREL_TRUNC(mi->avg_ampdu_len);
```

So, likely, `mi->avg_ampdu_len` is non-zero, but it's too small, hence
right bitshift makes it zero.

Should there be some protection against such a situation?

Felix, could you maybe check this? Looks like you were the last one to
overhaul that part of code.

Thanks!

-- 
  Oleksandr Natalenko (post-factum)
