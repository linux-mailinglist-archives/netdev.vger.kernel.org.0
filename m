Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F083667E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfFEVMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45580 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfFEVMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:02 -0400
Received: by mail-qt1-f193.google.com with SMTP id j19so190477qtr.12
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PiPUwQBiiBLaeqopflKy8AtnwiOp0QGdS6L93wrKjtw=;
        b=fnH/cFtArJwcIQB8cFxExOTlUsrgwHs9ff3SkBQO4HCKGnWcYa+w/e0WY31s0ZIIkK
         dlxkfohk0MmE7DcJq3JqRGvJGx0qi8yXbGWWNfFWBs4SbdB3dYapX02MKXY8CoviDiG4
         3jiK6zBOpXagVYeaBVd7ph5LZVdATqbn7Zt4CjmUBBml8w6SA4JFuJom8oHTZ777/x0t
         R4Ilzh5frqI6jS06uHHfF6EKiuM1iXCG/0w3hqK1kpHSc6Q8iLqYmOZDIytrxdDnnkvs
         jcig+Te7w8PI0hBygGShSDZ3bbz6nPIl9aoE/1now0GQ5i4ISfgVl9Hx8RinWe9P1XNE
         frZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PiPUwQBiiBLaeqopflKy8AtnwiOp0QGdS6L93wrKjtw=;
        b=duMZbYR51y/ejEH3pTzEEHT53p1DaYk9OjiKyg1Q5RAkMwe6FhRpQL5Mx/VZCRv+5r
         fCRi/ipRMMKvVAskUL4SCaPtcBLHL1s6/oOqeL1cQ0dpuC44qEcVHv1rdyO9c4DSRdDN
         urO1GL1D/m5Gg0U2eyPjptvxDsNCcuvZD4P42cAOdHWlopd/pi48O7NlTrTq4+UOjCLI
         GVE1FB6elg6DKLAQR8unHz/MWxjqpB1J5N9DQWoYAqofhsqbCzgDXx0PhaH8CRFInu7A
         h0S6k7QjY9A2AN5ovIqJNY2DSNelB5ggErQEuxu39YJc4IXwX4YxK/rW/ERCFWkzGDvu
         4I6g==
X-Gm-Message-State: APjAAAXbHzoHvjWg2DpX2ut9J5iDaGBRvUHxx4zvXH+vlP8wuJC6yrng
        1SUHzX3JU0EUdS0cWJz1bimuYlULbXQ=
X-Google-Smtp-Source: APXvYqxX+J1BdTUNTjzQ4Fa3qCUAObzENn0ian1DD6jGQQigEb9Jr9NMY6k8ig3Jli4rtmo0aLyGQA==
X-Received: by 2002:ac8:2fa8:: with SMTP id l37mr35818694qta.358.1559769121241;
        Wed, 05 Jun 2019 14:12:01 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.11.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:00 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 00/13] nfp: tls: add basic TX offload
Date:   Wed,  5 Jun 2019 14:11:30 -0700
Message-Id: <20190605211143.29689-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series adds initial TLS offload support to the nfp driver.
Only TX side is added for now.  We need minor adjustments to
the core tls code:
 - expose the per-skb fallback helper;
 - grow the driver context slightly;
 - add a helper to get to the driver state more easily.
We only support TX offload for now, and only if all packets
keep coming in order.  For retransmissions we use the
aforementioned software fallback, and in case there are
local drops we completely give up on given TCP stream.

This will obviously be improved soon, this patch set is the
minimal, functional yet easily reviewable chunk.

Dirk van der Merwe (3):
  net/tls: export TLS per skb encryption
  nfp: tls: add datapath support for TLS TX
  nfp: tls: add/delete TLS TX connections

Jakub Kicinski (10):
  nfp: count all failed TX attempts as errors
  nfp: make bar_lock a semaphore
  nfp: parse the mailbox cmsg TLV
  nfp: add support for sending control messages via mailbox
  nfp: parse crypto opcode TLV
  nfp: add tls init code
  nfp: prepare for more TX metadata prepend
  net/tls: split the TLS_DRIVER_STATE_SIZE and bump TX to 16 bytes
  net/tls: simplify driver context retrieval
  nfp: tls: add basic statistics

 drivers/net/ethernet/netronome/Kconfig        |   1 +
 drivers/net/ethernet/netronome/nfp/Makefile   |   6 +
 drivers/net/ethernet/netronome/nfp/ccm.c      |   3 -
 drivers/net/ethernet/netronome/nfp/ccm.h      |  48 +-
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c | 591 ++++++++++++++++++
 .../ethernet/netronome/nfp/crypto/crypto.h    |  23 +
 .../net/ethernet/netronome/nfp/crypto/fw.h    |  82 +++
 .../net/ethernet/netronome/nfp/crypto/tls.c   | 429 +++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  48 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 147 ++++-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.c |  15 +
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  21 +
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  16 +-
 include/net/tls.h                             |  32 +-
 net/tls/tls_device_fallback.c                 |   6 +
 15 files changed, 1421 insertions(+), 47 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/ccm_mbox.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/crypto.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/fw.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/tls.c

-- 
2.21.0

