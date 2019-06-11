Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E7A3C26B
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391084AbfFKEku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:40:50 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:39595 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387997AbfFKEkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:40:49 -0400
Received: by mail-qt1-f171.google.com with SMTP id i34so13003114qta.6
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pedKJv+y0h9YwH8l6r68ZaJ51HyYS8CLS/ZfqDVvEI8=;
        b=DAlIjSQy1QlPoP+EhgD27qDB7VzyMIb7pZzecIbCMa6ViOZy2Hca/tcurvSIAWe18j
         7BeWGeNmynLMy/hhrUWnE2yRLkKmj/9Uzoqk+iYL1m/59kumvnOuWXR/Arvw4IofApWV
         tnUHujdW9CJrSX3u+38bcqVbOv4PiL2W7OjzkO8HE189SlHg/DuQxZXma/U6mbXfeREB
         Ms14d6/vaEZhGH5QYyHFzZWse65tgQwRu2hP9p6b6mEJ8hZG2SCreStiM4L8m+9WUFIb
         FklLafGU+2pOyFCpCbQZpiQ6HfYOiroR21cEVQueoxaQ9b5Z0rlz+RBmocCg4B4RpyLs
         Fxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pedKJv+y0h9YwH8l6r68ZaJ51HyYS8CLS/ZfqDVvEI8=;
        b=QJLoGpNVMcpCW0sj3eeALXpcAcdCLTZ1PnFLXoAJTqRk3Hxrj3UAunTLi852SnUxWx
         b8bGm+xzBFaYt6TurG/YbF9aisJ/x5KgKvBAEIpiOwovJX0TBwSELDZhCfXE81lhliKJ
         FhYZLsbW6k3gvzYeP68RIGn35FBpXhrLIzYJFX9NBeyy3QhXChbP/M3nursPET2zfIzG
         E5Gq4DsH294D28phzc4dihA2REQW1F1YyzHMcoIpEINMA6mApbkG/nfR3G+dVU09EelG
         vQ0OmR+a78/Y240ICKXx4ivPu2u0T+Pus6I8BqK2lcwKJThk2VV0tarpfNiDBIaLAkqz
         oTPw==
X-Gm-Message-State: APjAAAV8jwmwtgVZibpymGqD/2E14uTJ631Ysw9UKGyRwAKNuw7awJNG
        n7zC6gwB6aZRVZpputs9xKIEMw==
X-Google-Smtp-Source: APXvYqzAhsu6W12GKhI46VEoyWTFSc9ydge5HVfW3POkNU+3HfCC2sSz9qkbsZEZP7vsQSdGRjL09w==
X-Received: by 2002:a0c:d4f4:: with SMTP id y49mr32522115qvh.238.1560228048789;
        Mon, 10 Jun 2019 21:40:48 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.40.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:40:48 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 00/12] tls: add support for kernel-driven resync and nfp RX offload
Date:   Mon, 10 Jun 2019 21:39:58 -0700
Message-Id: <20190611044010.29161-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series adds TLS RX offload for NFP and completes the offload
by providing resync strategies.  When TLS data stream looses segments
or experiences reorder NIC can no longer perform in line offload.
Resyncs provide information about placement of records in the
stream so that offload can resume.

Existing TLS resync mechanisms are not a great fit for the NFP.
In particular the TX resync is hard to implement for packet-centric
NICs.  This patchset adds an ability to perform TX resync in a way
similar to the way initial sync is done - by calling down to the
driver when new record is created after driver indicated sync had
been lost.

Similarly on the RX side, we try to wait for a gap in the stream
and send record information for the next record.  This works very
well for RPC workloads which are the primary focus at this time.

Dirk van der Merwe (2):
  nfp: tls: set skb decrypted flag
  nfp: tls: implement RX TLS resync

Jakub Kicinski (10):
  net/tls: simplify seq calculation in handle_device_resync()
  net/tls: pass record number as a byte array
  net/tls: rename handle_device_resync()
  net/tls: add kernel-driven TLS RX resync
  nfp: rename nfp_ccm_mbox_alloc()
  nfp: add async version of mailbox communication
  nfp: tls: enable TLS RX offload
  net/tls: generalize the resync callback
  net/tls: add kernel-driven resync mechanism for TX
  nfp: tls: make use of kernel-driven TX resync

 Documentation/networking/tls-offload.rst      |  54 +++++-
 .../mellanox/mlx5/core/en_accel/tls.c         |  10 +-
 drivers/net/ethernet/netronome/nfp/ccm.h      |  10 +-
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 179 ++++++++++++++++--
 .../ethernet/netronome/nfp/crypto/crypto.h    |   6 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |  73 ++++++-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  20 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  57 +++++-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  18 +-
 include/net/tls.h                             |  63 +++++-
 net/tls/tls_device.c                          | 140 ++++++++++++--
 net/tls/tls_sw.c                              |   9 +-
 12 files changed, 566 insertions(+), 73 deletions(-)

-- 
2.21.0

