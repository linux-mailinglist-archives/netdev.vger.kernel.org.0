Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0841C313E43
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhBHS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbhBHS4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:56:42 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B00DC06178C
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 10:56:02 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id o21so2219540qtr.3
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 10:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PvwDibSqionGUMaIW7fX8WGczOxj5MLsnicm5PTCNvk=;
        b=jep7KXYV4ExWJl47hFOg8XN6oE6fOlXD39bAUtpnSXPM/8knz03tVv28HzfACdCURm
         ZodldbPw6kYw4wVNnSNH9dGRQw7Fsmt63WunGTYYAkWw5ZfLb6EeB5YEnP9UFB6yBe1T
         UeuGE2nBIODzNYWVzIoVOMC20pC/Esh/Xf9r5wrd1BZvD6yWum71D4t+flhOOwtXhSwV
         ILo6DNSxKFLtyVCkAJoHj6i0+H8UHiPNIhnS4+WhTN+IrePN/AWgH6oJyPkwiuLABTsY
         3BOmtE9vZy/ebnCxGjSNmCNHKi2A3ttJOoIsOokLOotbJigpguowQpy2mpieCxB2o3i1
         mLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PvwDibSqionGUMaIW7fX8WGczOxj5MLsnicm5PTCNvk=;
        b=Fd27b7Y8BHQNaInGsd1xHXUijeo+seVZcB0L4607b8yvDyi8r0boP7uyYx2dT1sFr6
         On9AVW3dZSH84H1+uqQmJNmqGvNPFcpsIlk+vyu7FsC/oSp6XwRxNUqObqKtxudRCOKi
         EkwvBMAVG3b2fjP2EgPSJcQh9JzA9eYcJq6SvaQ+L36fBVB5YPJpjs0Uq8+eRG3mhJTa
         nVN4t3gP13VckrTlAqevbcj6UsX1Pql3OzrwZSq0P1zhWQ+eP6zAC1qigKjfSLRdiNJF
         qevu3yCWqfoFhvBPvLzBFm/nE8mkD1yC6IwBsniaV18JTu4Zoiv0rv7L+s6DpQS7ExoI
         P1NQ==
X-Gm-Message-State: AOAM532icx+xRA0V5sGHEJlZQ6Y0ZHg4o6Yi4R9NTG6wm7IGd/Kwqi4a
        Va1SA2M3hXK2ydiVIRmp8S0=
X-Google-Smtp-Source: ABdhPJwu2s7LwojmiLLpCb/ffJb1Imze4ED2pNvOdRx2MWtKJQearbN4K5lnq9hKZaj8YaBdFu4MZA==
X-Received: by 2002:ac8:4706:: with SMTP id f6mr13928451qtp.75.1612810561269;
        Mon, 08 Feb 2021 10:56:01 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f109:45d3:805f:3b83])
        by smtp.gmail.com with ESMTPSA id q25sm17370744qkq.32.2021.02.08.10.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 10:56:00 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        richardcochran@gmail.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC v2 0/4] virtio-net: add tx-hash, rx-tstamp, tx-tstamp and tx-time
Date:   Mon,  8 Feb 2021 13:55:54 -0500
Message-Id: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

RFCv2 for four new features to the virtio network device:

1. pass tx flow state to host, for routing + telemetry
2. pass rx tstamp to guest, for better RTT estimation
3. pass tx tstamp to guest, idem
3. pass tx delivery time to host, for accurate pacing

All would introduce an extension to the virtio spec.
Concurrently with code review I will write ballots to
https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio

These changes are to the driver side. Evaluation additionally requires
achanges to qemu and at least one back-end. I implemented preliminary
support in Linux vhost-net. Both patches available through github at

https://github.com/wdebruij/linux/tree/virtio-net-txhash-2
https://github.com/wdebruij/qemu/tree/virtio-net-txhash-2

Changes RFC -> RFCv2
  - add transmit timestamp patch
  - see individual patches for other changes

Willem de Bruijn (4):
  virtio-net: support transmit hash report
  virtio-net: support receive timestamp
  virtio-net: support transmit timestamp
  virtio-net: support future packet transmit time

 drivers/net/virtio_net.c        | 193 +++++++++++++++++++++++++++++++-
 drivers/virtio/virtio_ring.c    |   3 +-
 include/linux/virtio.h          |   1 +
 include/uapi/linux/virtio_net.h |  24 +++-
 4 files changed, 214 insertions(+), 7 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

