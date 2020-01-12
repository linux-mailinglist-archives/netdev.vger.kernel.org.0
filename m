Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B01138494
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 03:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731991AbgALChQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 21:37:16 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:38083 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731985AbgALChP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 21:37:15 -0500
Received: by mail-il1-f193.google.com with SMTP id f5so5027542ilq.5;
        Sat, 11 Jan 2020 18:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=I++qOGIiNcg90Q+eACsnB9l0fti70rH2JLo9BsRMgxU=;
        b=JrYLt/EuWRLHzu51xBiO9AciJQr0RqgHHSb4iXthrtyEx26sCrBkzBuYJrywMtFOOd
         Sl+sbdlJz2cOEuk9nqiNy14Zfplb4lZcg6v3cpbTmtuy9bp5pX2y7bO0GdeZVwpl5txx
         ICeeFsW33MKiMETOJvq0YhXK7mzRG29MCvBkVGxP+ajt7uUjc5wVKqb5/bpe3Wed8yM0
         ChvfCoYtxL/4TJI2fd9QEBppQL6pNfz9HJayrFil6mDkrbPOUG9HgrF9rRulxVxgHvI8
         VcWn/9OaBI7U6kWdLGeuhLDUuS0rpBab4Okh5tQkeA5dMoYTM8luCbItcu+Cbjt0lFjf
         TGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=I++qOGIiNcg90Q+eACsnB9l0fti70rH2JLo9BsRMgxU=;
        b=W8LKVvtkFDtyZ/h0uGB3UNgfSGcEvkuYAGWo1LlTobj5sz5Dbux/kUR7QPCgbGkPnH
         Vh46H/zfRXjirCO4V64fsNgepR+wZ77UoDJ1+VvtlSa3CumwWzLyBSysVgcCYi14j4WT
         nzaAB7mJ0+L6mBAoskYQ12zzn4i1VTi3TvOolfKinO4TQSWmEsUKUWhZDrwmhhtzSJjA
         CbwGOtcd5XPNlfuyhmmw4jbsC/pHR5fpuz4b5sBAbq9BYzYeJEvq1l2ErQz7xJ0wE+5/
         ZWWV3RJXfH3nmfR+33d2tDnbsJx3XxgvEf0E6Oboem1XhQy3Qv2xmCr825caJbyO3Bgp
         xkSQ==
X-Gm-Message-State: APjAAAW5jSXNPjWE79AlqTe3r1oMO9Yj95bQVOAwbCW0T85QWkUnEVh6
        UuSuEs/Dz+B/DhSSnmvECx4=
X-Google-Smtp-Source: APXvYqyy32RnyQgxbbE7HRax2MDbDw/9y5XyRHf4bQeDr5HfJjIUWNoq311KbALRH9rI8IgzgtRfaA==
X-Received: by 2002:a05:6e02:f0f:: with SMTP id x15mr8826184ilj.298.1578796635047;
        Sat, 11 Jan 2020 18:37:15 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 137sm1652798iou.41.2020.01.11.18.37.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jan 2020 18:37:14 -0800 (PST)
Subject: [bpf-next PATCH v2 0/2] xdp devmap improvements cleanup
From:   John Fastabend <john.fastabend@gmail.com>
To:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        toshiaki.makita1@gmail.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Sat, 11 Jan 2020 18:36:59 -0800
Message-ID: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Couple cleanup patches to recently posted series[0] from Bjorn to
cleanup and optimize the devmap usage. Patches have commit ids
the cleanup applies to.

Toshiaki, noted that virtio_net depends on rcu_lock being held
when calling xdp flush routines. This is specific to virtio_net
dereferencing xdp program to determine if xdp is enabled or not.
More typical pattern is to look at a flag set by the driver, at
least in the case of real hardware drivers. veth has a similar
requirement where it derferences the peer netdev priv structure
requiring the rcu_read_lock. I believe its better to put the
rcu_read_lock()/unlock() pair where its actually used in the
driver. FWIW in other xdp paths we expect driver writers to
place rcu_read_lock/unlock pairs where they are needed as well
so this keeps that expectation. Also it improves readability
making it obvious why the rcu_read_lock and unlock pair is
needed. In the virtio case we can probably do some further
cleanup and remove it altogether if we want. For more details
see patch 2/2.

[0] https://www.spinics.net/lists/netdev/msg620639.html

v2: Place rcu_read_{un}lock pair in virtio_net and veth drivers
    so we don't break this requirement when removing rcu read
    lock from devmap.

---

John Fastabend (2):
      bpf: xdp, update devmap comments to reflect napi/rcu usage
      bpf: xdp, remove no longer required rcu_read_{un}lock()


 drivers/net/veth.c       |    6 +++++-
 drivers/net/virtio_net.c |    8 ++++++--
 kernel/bpf/devmap.c      |   26 ++++++++++++++------------
 3 files changed, 25 insertions(+), 15 deletions(-)

--
Signature
