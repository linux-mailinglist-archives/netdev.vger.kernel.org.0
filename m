Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9042714A612
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbgA0O3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:29:49 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43009 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0O3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 09:29:49 -0500
Received: by mail-pf1-f193.google.com with SMTP id s1so4387378pfh.10
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 06:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=c/YtHuV2sg/11a3oIvgboYjFAgxY5sw3qrK4nshZaA4=;
        b=FobeaGSNwVZMtehRkFxgRaqNS68eZgUiJ9mxzBzfoL1h4GaihaYjg7NUN+XLIYztBM
         4AmL7KDKk4fmSvl/TJ9dxM84OHRrJCCQO1lYsxB77ft8TAIsvEwRNCzsRN6eD3Y6Rvlh
         LqcXGnayQyQVG6VWyzrIIXokxm5vr5jyQruCvhyMGJWe2eSVGrMqaYnjIU4wNCkwR9ou
         KGn9V51TIhrH8RWoSczlii+58DACUVfrWPvze73hF6UqBW9on/FERO/ruxCeV0ow2lwo
         +Jy8uRj3+WdsyIHV2eKY7eoRXTYoF54vBukRrhcEwSdj1dQA5egXgZP9Nzg3hdJ3Q6dF
         CcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=c/YtHuV2sg/11a3oIvgboYjFAgxY5sw3qrK4nshZaA4=;
        b=VhStpMvut/kn634acgkieCdSPBytm9gfiU07mQRVe6rYi4FUmXgtTGXv0/PcJsomOk
         ZBOmyLO/BJK/+kthfMyCnONfM48KEGl9QYGqFxS1F8tqy5feeqAu+BMocU4W3V45QS6X
         ttp8Jt6z9OpCQ71LfeBjHFesN5FvCufgnq/A/YFahoy+8L02swLoo6r2qRpW6Wcl4y6q
         daTY/WsPwxuQZkzWuWDug1OUFrD0M4OFrwxykrK47F81uGWWZEeZ6+dpvlwqdUYWoK5n
         0s9oT05OvLMd9HBxFg8RMNRe0v6SAdPvJv215uhXCvdt6xHhxcWh7CUQ0TFpm3uyDMGP
         Kvzw==
X-Gm-Message-State: APjAAAXwQ1Wbc3doCLqM9xuq9ZvanIn6siDedtPC+wl3CxNMe9SJZncJ
        4JFUIZwMVH22X28co+6XCff9+jnq
X-Google-Smtp-Source: APXvYqza1Vo2VgiFbqsYqGKZ1ecs2/lHA/6ND4shgr1Msx7y+sDGXwdKUhAL2PdH7jm4ClBUbYv5Kw==
X-Received: by 2002:a62:64d8:: with SMTP id y207mr9446247pfb.208.1580135388686;
        Mon, 27 Jan 2020 06:29:48 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id y197sm16937841pfc.79.2020.01.27.06.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 06:29:47 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 0/6] netdevsim: fix a several bugs in netdevsim module
Date:   Mon, 27 Jan 2020 14:29:41 +0000
Message-Id: <20200127142941.1092-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes several bugs in netdevsim module.

1. The first patch fixes a race condition in basic operation of
netdevsim module.
netdevsim operation is called by sysfs and these operations use netdevsim
global resource but there is only a lock for protect list, not the whole
resource. So, panic occurs.

2. The second patch fixes another race condition.
The main problem is a race condition in {new/del}_port() and devlin reload
function.
These functions would allocate and remove resources. So these functions
should not be executed concurrently.

3. The third patch fixes stack-out-of-bound in nsim_dev_debugfs_init().
nsim_dev_debugfs_init() provides only 16bytes for name pointer.
But, there are some case the name length is over 16bytes.
So, stack-out-of-bound occurs.

4. The fourth patch uses IS_ERR instead of IS_ERR_OR_NULL.
debugfs_create_{dir/file} doesn't return NULL.
So, IS_ERR() is more correct.

5. The fifth patch avoids kmalloc warning.
When too large memory allocation is requested by user-space, kmalloc
internally prints warning message.
That warning message is not necessary.
In order to avoid that, it adds __GFP_NOWARN.

6. The last patch removes an unused sdev.c file

Change log:
v1 -> v2:
 - Splits a fixing race condition patch into two patches.
 - Fix incorrect Fixes tags.
 - Update comments
 - Fix use-after-free
 - Add a new patch, which removes an unused sdev.c file.
 - Remove a patch, which tries to avoid debugfs warning.

Taehee Yoo (6):
  netdevsim: fix race conditions in netdevsim operations
  netdevsim: disable devlink reload when resources are being used
  netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
  netdevsim: use IS_ERR instead of IS_ERR_OR_NULL for debugfs
  netdevsim: use __GFP_NOWARN to avoid memalloc warning
  netdevsim: remove unused sdev code

 drivers/net/netdevsim/bpf.c       | 10 +++--
 drivers/net/netdevsim/bus.c       | 56 +++++++++++++++++++++----
 drivers/net/netdevsim/dev.c       | 32 ++++++++++----
 drivers/net/netdevsim/health.c    |  6 +--
 drivers/net/netdevsim/netdevsim.h |  5 +++
 drivers/net/netdevsim/sdev.c      | 69 -------------------------------
 6 files changed, 84 insertions(+), 94 deletions(-)
 delete mode 100644 drivers/net/netdevsim/sdev.c

-- 
2.17.1

