Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEA21F3D9F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 16:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgFIOJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 10:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgFIOJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 10:09:40 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28347C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 07:09:40 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id e16so17706019qtg.0
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 07:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m/PE01wytrFMZ5EZYea6fpxQsU5jVFPnMfGnMCPJHuQ=;
        b=CChHc3z9wMihmsM2hB0S3nwfXU3Tc7SXYGjO1HiGV3jVqBpBtmm+aAdd7GmWVdwKuY
         EsQcy8YTAL4gbze5kQGHYqUN+lfqMq7iuEM1VgBjLACDNaIuYZ6EFXOeXDZkCjQ1XatU
         6Y2l8R6O6jDkfaIk/UI+ijRyeY12/9Qf+/yQS8ECc/84KOj/vbCQVjgABDb1733R/yXU
         CVlxva3liFcMv9+n6qP4atG1xkoSozgJ49gxib4vexhRZm+BLwY4cULKoZrJ97IFTH1V
         nK8na+ODtYv4ZKZV8Ong+h0Wp4IECSyPDQC5SxrZra9xAasEcLqZvMjfUMRUeJlSp9XK
         c/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m/PE01wytrFMZ5EZYea6fpxQsU5jVFPnMfGnMCPJHuQ=;
        b=Y8Uer4bNtwvbXdyCyQ+Vt9h0BfEGv8ghn1/tnZVelYycFsow1tFaEKVW/7vvJli3KD
         pxnR6zQFXda3gvt9l9Xc8n7ZAdltT+w0fqYpFWOHtk86fLHDriliKeZo6YQ38v+xRj40
         eZME7XqfjSDSWVejjYmhMaRAZrFy6E8Z6r2JEV8ug7WCggKHK6D86nOdeqBbyE4zBnqB
         MlBvamAqPwF4XOfVreIlV2PLW7w06V862MDLq5bPoo/Q6COrAdPBsO35t+dF1z/K4GZc
         2NdT3Q5kmUeysbCqccr8WARcErdRORCABOSvprxzBhdn9ElRt8be4fyLjcyjaSzarZbw
         70qQ==
X-Gm-Message-State: AOAM532mWnfWm1d2oa4gqtqDzq1Rg31aQzvd4HTarmxUp9FojTMhiRKj
        1kNK70NcL+ZvXsrZnJAcJ+X+ZbAb
X-Google-Smtp-Source: ABdhPJzN0JArAuGEteqTCWUozXo38+fdz1hp3jkFPJvJJjLgQrAPFo5NTZBnywtNSrDlcKwPuzZ6eQ==
X-Received: by 2002:ac8:3f77:: with SMTP id w52mr27947117qtk.161.1591711778419;
        Tue, 09 Jun 2020 07:09:38 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:8798:f98:652b:63f1])
        by smtp.gmail.com with ESMTPSA id u25sm10454614qtc.11.2020.06.09.07.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:09:37 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Subject: [PATCH RFC net-next 0/6] multi release pacing for UDP GSO
Date:   Tue,  9 Jun 2020 10:09:28 -0400
Message-Id: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.278.ge193c7cf3a9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

UDP segmentation offload with UDP_SEGMENT can significantly reduce the
transmission cycle cost per byte for protocols like QUIC.

Pacing offload with SO_TXTIME can improve accuracy and cycle cost of
pacing for such userspace protocols further.

But the maximum GSO size built is limited by the pacing rate. As msec
pacing interval, for many Internet clients results in at most a few
segments per datagram.

The pros and cons were captured in a recent CloudFlare article,
specifically mentioning

  "But it does not yet support specifying different times for each
  packet when GSO is used, as there is no way to define multiple
  timestamps for packets that need to be segmented (each segmented
  packet essentially ends up being sent at the same time anyway)."

  https://blog.cloudflare.com/accelerating-udp-packet-transmission-for-quic/

We have been evaluating such a mechanism for multiple release times
per UDP GSO packets. Since it sounds like it may of interest to
others, too, it may be a while before we have all the data I'd like
and it's more quiet on the list now that the merge window is open,
sharing a WIP version.

The basic approach is to specify

1. initial early release time (in nsec)
2. interval between subsequent release times (in msec)
3. number of segments to release at each release time

One implementation concern is where to store the additional two fields
in the skb. Given that msec granularity is the Internet pacing speed,
for now repurpose the two lowest 4B nibbles in skb->tstamp to hold the
interval and segment count. I'm aware that this does not win a prize
for elegance.

Patch 1 adds the socket option and basic segmentation function to
  adjust the skb->tstamp of the individual segments.

Patch 2 extends this with support for build GSO segs. Build one GSO
   segment per interval if the hardware can offload (USO) and thus
   we are segmenting only to maintain pacing rate.

Patch 3 wires the segmentation up to the FQ qdisc on enqueue, so that
   segments will be scheduled for delivery at their adjusted time.

Patch 4..6 extend existing tests to experiment with the feature

Patch 4 allows testing so_txtime across hardware (for USO)
Patch 5 extends the so_txtime test with support for gso and mr-pacing
Patch 6 extends the udpgso bench to support pacing and mr-pacing

Some known limitations:

- the aforementioned storage in skb->tstamp.

- exposing this constraint through the SO_TXTIME interface.
  it is cleaner to add new fields to the cmsg, at nsec resolution.

- the fq_enqueue path adds a branch to the hot path.
  a static branch would avoid that.

- a few udp specific assumptions in a net/core datapath.
  notably the hw_features. this can be derived from gso_type.

Willem de Bruijn (6):
  net: multiple release time SO_TXTIME
  net: build gso segs in multi release time SO_TXTIME
  net_sched: sch_fq: multiple release time support
  selftests/net: so_txtime: support txonly/rxonly modes
  selftests/net: so_txtime: add gso and multi release pacing
  selftests/net: upgso bench: add pacing with SO_TXTIME

 include/linux/netdevice.h                     |   1 +
 include/net/sock.h                            |   3 +-
 include/uapi/linux/net_tstamp.h               |   3 +-
 net/core/dev.c                                |  71 +++++++++
 net/core/sock.c                               |   4 +
 net/sched/sch_fq.c                            |  33 ++++-
 tools/testing/selftests/net/so_txtime.c       | 136 ++++++++++++++----
 tools/testing/selftests/net/so_txtime.sh      |   7 +
 .../testing/selftests/net/so_txtime_multi.sh  |  68 +++++++++
 .../selftests/net/udpgso_bench_multi.sh       |  65 +++++++++
 tools/testing/selftests/net/udpgso_bench_tx.c |  72 +++++++++-
 11 files changed, 431 insertions(+), 32 deletions(-)
 create mode 100755 tools/testing/selftests/net/so_txtime_multi.sh
 create mode 100755 tools/testing/selftests/net/udpgso_bench_multi.sh

-- 
2.27.0.278.ge193c7cf3a9-goog

