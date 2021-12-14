Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A57474DFF
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhLNWnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhLNWnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:43:05 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F59C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:05 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id y9so5304050pgj.5
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 14:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=N+oezn23FqCF7+wZkUykJ3V4a162jZF/zUHUhsCfZRU=;
        b=KpPcBh2RnsbA2dcGTv3r6LpdRBLeBD8xUkkkJJsJCZs9xnzEvzEgg+vB5Dw5mZvqvx
         VLmp6z1HXvQaURERNwACfUBvWD2dLZSUAqMZFKev37rxteb7vbxfvPEcf4BzbPnTy6uk
         r/UFWLpKq5LfTIEsQcCoCIDfScwEipp+tl7I8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=N+oezn23FqCF7+wZkUykJ3V4a162jZF/zUHUhsCfZRU=;
        b=SceOYOuxnL7TArPtOUgaXTPtb6KDIGkXUnZQBv3Ysq/T3c7lIrheGxlCC2ztNg4vYI
         gZUvaFizuHhb8cP5fNhvgdKscHtYegolYUtydBFFtw4a4rCg2sidbHXklaE0B0TDh/2k
         lqBT8mGyQU2zQ9z0LLYqrtg3Gp0Dj5e12FbVH/9dgJKBPOoIL/pKUjA6l0GvI4qSI8ih
         wwAimzBx6IGauBMCtKbZqMUizJ6DOcctPn5aYFEPY9sbAY3+IB8KwqD6wHkhI+qUDT2l
         tT7ZBh1fodr+4lIkzfjWNn63C56rqPcZvNejjVHZu/u8DsIN17nzv5rSV20Zp452ebCd
         giEw==
X-Gm-Message-State: AOAM5323Y0KB8BJPUZYgaSDngchqtxzIVL5aNccMrCZifJPfkQZQW81p
        dFjy9JgTSXDnt3eZMIX7u3tM3g==
X-Google-Smtp-Source: ABdhPJzQv55PTvMvauoIuOmL29JJv/TQliKMqZVyOLP8I95W9BNStO4ksrbBxpcJnKgxILAJTHu57g==
X-Received: by 2002:a63:b95a:: with SMTP id v26mr5391174pgo.460.1639521785010;
        Tue, 14 Dec 2021 14:43:05 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id mg12sm3448012pjb.10.2021.12.14.14.43.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 14:43:04 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [net-queue PATCH 0/5] i40e: stat counter updates and additions
Date:   Tue, 14 Dec 2021 14:42:05 -0800
Message-Id: <1639521730-57226-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings:

This patch set makes several updates to the i40e driver stats collection
and reporting code to help users of i40e get a better sense of how the
driver is performing and interacting with the rest of the kernel.

These patches include some new stats (like waived and busy) which were
inspired by other drivers that track stats using the same nomenclature.

The new stats and an existing stat, rx_reuse, are now accessible with
ethtool to make harvesting this data more convenient for users.

Joe Damato (5):
  i40e: Remove rx page reuse double count.
  i40e: Aggregate and export RX page reuse stat.
  i40e: Add a stat tracking new RX page allocations.
  i40e: Add a stat for tracking pages waived.
  i40e: Add a stat for tracking busy rx pages.

 drivers/net/ethernet/intel/i40e/i40e.h         |  4 ++++
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |  4 ++++
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 14 +++++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 25 ++++++++++++++++++-------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |  3 +++
 5 files changed, 42 insertions(+), 8 deletions(-)

-- 
2.7.4

