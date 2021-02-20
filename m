Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337003202AC
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 02:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhBTBpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 20:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhBTBpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 20:45:19 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC92C061574
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 17:44:38 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id o20so4405754qtx.22
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 17:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=hn2CQD6BUgAQQsSLf9FEJTtiGN4Malv7b602IHtNzvo=;
        b=GP2db0HAhm3r06Y0ZmkztEmoSNcB4k5YlqaE5Km8IpzhA7igdmkHdb9Eq7mudIsK/s
         oil9XfacL6IPJK8fgpvDG7u4VQLSJuCCi/97jPaer+49YQMz4Fs5CiHug+ZHqzvvbOue
         cz++Sqyodue8qRPF34YtY5E1Qml/kpy5DekrLN/ft1l1GOhmcdsWscH8UduaQhMeVLDn
         PC8awaH7T/uOouQa4cAqOluhAe9raye/43xQ7yDkHckXjG1ffKXMjfIn0B93+YqubSrD
         FRczaMZ9M/fmsHf3erpr50Qs9l74rvRNtidN+10FIuLh3Vy5E7ETfHDYMY91DDRsdjPN
         Cpbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=hn2CQD6BUgAQQsSLf9FEJTtiGN4Malv7b602IHtNzvo=;
        b=TuRCAUA8RovIYnazrwjdwnIVHWLOE7/LTZ4siYKOHpwL/BRvjSN83V6/sbgYpggldk
         FjvOF3gVvQrSEY4vrYoM0/K9KnVWV4wnnLfoylKHa564xUhPMpSDtyqZBb8BGimZJCFy
         bWu6OZZUV4GHZTJlSg6bq7cJJG3BUz6srdFs8oZtW0Mwr5CLrVxFPb3BN9Dtqr3G4Y1t
         V6cXOH/JwsotYF0RbYlt3CBgkF1tKOkZYze3YgadkpTcqLl92qXJU2ESn7F9ZanjLYhG
         z0vEeMKXicv0SuTLR4tbZ37yMN7w0sr3mFUnEH9+E6flGKJnNhTzl0xOsv4KtfTVn5pr
         0H8Q==
X-Gm-Message-State: AOAM533WZmBTAOQIsAwS/qFUhM93/FzM5vUD0lgwzR9aKFlkz1YrdP+W
        hKiQNzndixJ9ci+uR2y7nANFM5M/wDg=
X-Google-Smtp-Source: ABdhPJxHo7Leagucq0TVXeJRD7o7Q0n2wljTsKhd+QypmYkruA6XMEDVIhy3NFU+4itYCrh/62jB/5cd0eQ=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:9433:f9ff:6bb7:ac32])
 (user=weiwan job=sendgmr) by 2002:ad4:4d83:: with SMTP id cv3mr11793768qvb.16.1613785478131;
 Fri, 19 Feb 2021 17:44:38 -0800 (PST)
Date:   Fri, 19 Feb 2021 17:44:34 -0800
Message-Id: <20210220014436.3556492-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH net v2 0/2] virtio-net: suppress bad irq warning for tx napi
From:   Wei Wang <weiwan@google.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the implementation of napi-tx in virtio driver, we clean tx
descriptors from rx napi handler, for the purpose of reducing tx
complete interrupts. But this could introduce a race where tx complete
interrupt has been raised, but the handler found there is no work to do
because we have done the work in the previous rx interrupt handler.
This could lead to the following warning msg:
[ 3588.010778] irq 38: nobody cared (try booting with the
"irqpoll" option)
[ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
5.3.0-19-generic #20~18.04.2-Ubuntu
[ 3588.017940] Call Trace:
[ 3588.017942]  <IRQ>
[ 3588.017951]  dump_stack+0x63/0x85
[ 3588.017953]  __report_bad_irq+0x35/0xc0
[ 3588.017955]  note_interrupt+0x24b/0x2a0
[ 3588.017956]  handle_irq_event_percpu+0x54/0x80
[ 3588.017957]  handle_irq_event+0x3b/0x60
[ 3588.017958]  handle_edge_irq+0x83/0x1a0
[ 3588.017961]  handle_irq+0x20/0x30
[ 3588.017964]  do_IRQ+0x50/0xe0
[ 3588.017966]  common_interrupt+0xf/0xf
[ 3588.017966]  </IRQ>
[ 3588.017989] handlers:
[ 3588.020374] [<000000001b9f1da8>] vring_interrupt
[ 3588.025099] Disabling IRQ #38

This patch series contains 2 patches. The first one adds a new param to
struct vring_virtqueue to control if we want to suppress the bad irq
warning. And the second patch in virtio-net sets it for tx virtqueues if
napi-tx is enabled.

Wei Wang (2):
  virtio: add a new parameter in struct virtqueue
  virtio-net: suppress bad irq warning for tx napi

 drivers/net/virtio_net.c     | 19 ++++++++++++++-----
 drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
 include/linux/virtio.h       |  2 ++
 3 files changed, 32 insertions(+), 5 deletions(-)

-- 
2.30.0.617.g56c4b15f3c-goog

