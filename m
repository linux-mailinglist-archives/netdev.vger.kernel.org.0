Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C8A14F8FA
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 17:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgBAQmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 11:42:44 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34374 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbgBAQmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 11:42:44 -0500
Received: by mail-pl1-f195.google.com with SMTP id j7so4067575plt.1
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 08:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1JnwfnRzwB8Oz97qS2h/DAq9+z2qFDHgax7Xsg5j8eo=;
        b=TtKngVPHUN33AuB3k9+JdF090MMaatK5KBJs7RpwtZMX5HF3nJl+BWjsL+agxgpCzg
         6djFhklknfae/x5HEk3PaoWA9YOtOB50KW5Zn4Cuo7gsNOMOeTKXCvpaRw37v0zMDxVU
         UJuQ0w8ASnM9NogLbRRv6kz8Hntcunq01OD9XVkEQdnLodkQU5Ny5gyjK4+DeyVM4HJH
         eCVNPBHilVjv1+mn35UXKIK6u+uP4A3b3So27Q+JDPiD34znrF4Abv/EopvwvfowS7kf
         UkNCdDrmSYSzqcKVGCLD23zlokuxy0hoQdbjM/lz5ASX6Zjwlqy1jWBS/Ugs7wV0//c4
         HZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1JnwfnRzwB8Oz97qS2h/DAq9+z2qFDHgax7Xsg5j8eo=;
        b=EJnLhpu3kZGzgAPizwiKyjQagpPfuj05TqUO6rSLROK/bFyu0vfIJZM1yJZId3FeBS
         tmiqxTc8lwJjhgkLEotYjYR9ZeORTNgynF9D/4DTGJiJLcHsjwqTTFj1SZ5QTR4bKMY3
         cUd3oZ2pCdcCc6HmDGfCuUxOHw9Vxec6QcBZXbUcKacC0QDnNuS7cuRmaOoTX+BR1fDT
         OLsFeP0j5/OSXcXYTjrqnddmOVTQZ5nBAYKCG71LdBrj8i6DiOZY5Ra0smFIg/x3lHTi
         YLMc0JnRgWEPT72ruQ02ZQCBT/p9SKVEYEEg3hBD98HMi1IWADN5xqyeEuw76kh8PuyR
         Akwg==
X-Gm-Message-State: APjAAAVIqUZnmgSybhV+SyJ4FURRH7ZC7hd0WWwcZlwX651aam9WpxWL
        ygRAHRJ1nfXMRqU6uPAPlzo=
X-Google-Smtp-Source: APXvYqxht+5K8jWRQEcmizRzcajhtuDOjSTLnPkiyOaDdaBzpvoRdQh4Btdcg+jZlYeCdNNgtcFCtQ==
X-Received: by 2002:a17:902:7d8c:: with SMTP id a12mr15791759plm.47.1580575363630;
        Sat, 01 Feb 2020 08:42:43 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s6sm3360602pgq.29.2020.02.01.08.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 08:42:42 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 0/7] netdevsim: fix several bugs in netdevsim module
Date:   Sat,  1 Feb 2020 16:42:35 +0000
Message-Id: <20200201164235.9749-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes several bugs in netdevsim module.

1. The first patch fixes using uninitialized resources
This patch fixes two similar problems, which is to use uninitialized
resources.
a) In the current code, {new/del}_device_store() use resource,
they are initialized by __init().
But, these functions could be called before __init() is finished.
So, accessing uninitialized data could occur and it eventually makes panic.
b) In the current code, {new/del}_port_store() uses resource,
they are initialized by new_device_store().
But thes functions could be called before new_device_store() is finished.

2. The second patch fixes another race condition.
The main problem is a race condition in {new/del}_port() and devlink reload
function.
These functions would allocate and remove resources. So these functions
should not be executed concurrently.

3. The third patch fixes a panic in nsim_dev_take_snapshot_write().
nsim_dev_take_snapshot_write() uses nsim_dev and nsim_dev->dummy_region.
But these data could be removed by both reload routine and
del_device_store(). And these functions could be executed concurrently.

4. The fourth patch fixes stack-out-of-bound in nsim_dev_debugfs_init().
nsim_dev_debugfs_init() provides only 16bytes for name pointer.
But, there are some case the name length is over 16bytes.
So, stack-out-of-bound occurs.

5. The fifth patch uses IS_ERR instead of IS_ERR_OR_NULL.
debugfs_create_{dir/file} doesn't return NULL.
So, IS_ERR() is more correct.

6. The sixth patch avoids kmalloc warning.
When too large memory allocation is requested by user-space, kmalloc
internally prints warning message.
That warning message is not necessary.
In order to avoid that, it adds __GFP_NOWARN.

7. The last patch removes an unused sdev.c file

Change log:

v2 -> v3:
 - Use smp_load_acquire() and smp_store_release() for flag variables.
 - Change variable names.
 - Fix deadlock in second patch.
 - Update lock variable comment.
 - Add new patch for fixing panic in snapshot_write().
 - Include Reviewed-by tags.
 - Update some log messages and comment.

v1 -> v2: 
 - Splits a fixing race condition patch into two patches.
 - Fix incorrect Fixes tags.
 - Update comments
 - Fix use-after-free
 - Add a new patch, which removes an unused sdev.c file.
 - Remove a patch, which tries to avoid debugfs warning.

Taehee Yoo (7):
  netdevsim: fix using uninitialized resources
  netdevsim: disable devlink reload when resources are being used
  netdevsim: fix panic in nsim_dev_take_snapshot_write()
  netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
  netdevsim: use IS_ERR instead of IS_ERR_OR_NULL for debugfs
  netdevsim: use __GFP_NOWARN to avoid memalloc warning
  netdevsim: remove unused sdev code

 drivers/net/netdevsim/bpf.c       | 10 +++--
 drivers/net/netdevsim/bus.c       | 64 ++++++++++++++++++++++++++--
 drivers/net/netdevsim/dev.c       | 31 +++++++++-----
 drivers/net/netdevsim/health.c    |  6 +--
 drivers/net/netdevsim/netdevsim.h |  4 ++
 drivers/net/netdevsim/sdev.c      | 69 -------------------------------
 6 files changed, 93 insertions(+), 91 deletions(-)
 delete mode 100644 drivers/net/netdevsim/sdev.c

-- 
2.17.1

