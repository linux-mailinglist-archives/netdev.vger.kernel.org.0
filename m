Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED3262E55
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfGICxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:46 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39202 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfGICxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:45 -0400
Received: by mail-qk1-f196.google.com with SMTP id w190so2442243qkc.6
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3leJazLQ6xxFSqu+uCajqEHxUXQp0UcYOozbbeB1fI4=;
        b=yxKCBeuj2n9eqs03sxEDqGnAU82a8lWMmvYBj13daqmlzxppCFqeZK+WAl+SKSBraJ
         f7OIJ1Y5i1Z7V2EkGVo6+2lC+9hLcwsMNdm8gcn4cWMh4TgD8xE4Xt/VYQYj2bxjraOG
         mqLy/nL67Z0W0xNUAP5vl0TQQPihog9YHzsksZbywo2gCHBcnU2O6K+a3QY6z4z8pUMw
         8q5Uoqc4cbZgLj+dYJI1F+gMyhUied4AtrFrRNjvmyCVJErV3GK7SbM3MAwFQEmx+xGH
         bJyIcW/dFspksfcbLgt228Xx4YUKS+paxA0t2SLfaEVqmSUl0eYmy2/A//tsXguOkLCV
         sH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3leJazLQ6xxFSqu+uCajqEHxUXQp0UcYOozbbeB1fI4=;
        b=OmX3+H+TnA6fTSHq6jwEDSUvpVt8Me4hJzfeZiXJydrjpQftUaUktVTr8H3WaG2jc4
         1evMP+yRRJBh7XveMvAq1LX17+lrAJR9T7K4OaGsaAvBHsGofwjRiJ8mhX9bRkzHvg/s
         j+A4D21WXWDfdPWiQyfn5RWzIoao8NWj+P0JFhNyuTr1oJuVdOvx2GLMB0PPhXrOLmN2
         nUa3LgxtkNSjieEritgqO7ef3Dbw7pDWmCiOMAkHB+5E7xAluvKZAwViesJ1WjLq0mbj
         NOXLsrJ8e9EcHjSc4N48criOD0eLGB6zSoOUKw/HhZS6rJtW5HcVjBm7AhlrhVD7qfeX
         mx6Q==
X-Gm-Message-State: APjAAAXeXKbjvB/w69Sw4DgaeQVDuEyLy/Q9guWScg20i64lwdx6mc0t
        4ZyDuzALTXw+CEkqnuR3ChCpbA==
X-Google-Smtp-Source: APXvYqwdMgbU5NRwIEkLJYzaZTKrJaaf6moZy2k2cGiUTD6R6/KR0jer4go2ndGGjOwzF11b0pOUYg==
X-Received: by 2002:a37:624b:: with SMTP id w72mr17703959qkb.368.1562640824578;
        Mon, 08 Jul 2019 19:53:44 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:43 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 00/11] nfp: tls: fixes for initial TLS support
Date:   Mon,  8 Jul 2019 19:53:07 -0700
Message-Id: <20190709025318.5534-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series brings various fixes to nfp tls offload recently added
to net-next.

First 4 patches revolve around device mailbox communication, trying
to make it more reliable. Next patch fixes statistical counter.
Patch 6 improves the TX resync if device communication failed.
Patch 7 makes sure we remove keys from memory after talking to FW.
Patch 8 adds missing tls context initialization, we fill in the
context information from various places based on the configuration
and looks like we missed the init in the case of where TX is
offloaded, but RX wasn't initialized yet. Patches 9 and 10 make
the nfp driver undo TLS state changes if we need to drop the
frame (e.g. due to DMA mapping error).

Last but not least TLS fallback should not adjust socket memory
after skb_orphan_partial(). This code will go away once we forbid
orphaning of skbs in need of crypto, but that's "real" -next
material, so lets do a quick fix.

Dirk van der Merwe (2):
  nfp: ccm: increase message limits
  net/tls: don't clear TX resync flag on error

Jakub Kicinski (9):
  nfp: tls: ignore queue limits for delete commands
  nfp: tls: move setting ipver_vlan to a helper
  nfp: tls: use unique connection ids instead of 4-tuple for TX
  nfp: tls: count TSO segments separately for the TLS offload
  nfp: tls: don't leave key material in freed FW cmsg skbs
  net/tls: add missing prot info init
  nfp: tls: avoid one of the ifdefs for TLS
  nfp: tls: undo TLS sequence tracking when dropping the frame
  net/tls: fix socket wmem accounting on fallback with netem

 .../mellanox/mlx5/core/en_accel/tls.c         |  8 +-
 drivers/net/ethernet/netronome/nfp/ccm.h      |  4 +
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 31 ++++---
 .../net/ethernet/netronome/nfp/crypto/fw.h    |  2 +
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 93 +++++++++++++------
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  3 +
 .../ethernet/netronome/nfp/nfp_net_common.c   | 32 ++++++-
 include/net/tls.h                             |  6 +-
 net/tls/tls_device.c                          | 10 +-
 net/tls/tls_device_fallback.c                 |  4 +
 10 files changed, 143 insertions(+), 50 deletions(-)

-- 
2.21.0

