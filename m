Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7946E138275
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 17:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbgAKQgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 11:36:51 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:54642 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729957AbgAKQgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 11:36:51 -0500
Received: by mail-pj1-f67.google.com with SMTP id kx11so2276044pjb.4
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 08:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PpWhW35FqvTNezrLah1zKPGu8SoyEHq69bN6haEitTI=;
        b=aZJbPkRBNNYogOY8yGXzK2ftsZYvAvbK9uHmS2utdR4/PdRT8dtQ9+ijBxwyF2JOvN
         EdwPiKoHaGC1CYPLdxhRwYoWawQlgppfZJANUbiBm/lj4y1aCZKgvpFfbBUdUPSUXKL7
         c+rktPwk9r8UU4CNx8b1HHmlS6b7r4ydb8CWJ0AiSD8MOeKOt2HSvaq2BsDTz4IBAk9I
         5Cl1/4cqMgtFjUoSWZXoLM63ORVC1AK4WEOj44aTzSWQqhuXkvDhqNaaoPkvqyBtt4AK
         C6oe5mKzqoSijcJRW12ppGwlCWd2ny/K1lwQIwItWbVzlMtnhu6x8ZdJE1iVPTCzt6Vf
         fuUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PpWhW35FqvTNezrLah1zKPGu8SoyEHq69bN6haEitTI=;
        b=TP60LFJzFimEphKP2WuB4caluwmtwVOUnlFtXn4YEPwBE09U2RZjjTBEkYHdKtbSfh
         SDgK8SVSUxdImYrWlG44SAVlCXRMttewMfBtftkMIfRlpwena2VhLrbh7eeY9CXjYHSq
         KCUciDiA+/u0K6eOhYZSeKwTrUOPJWFJmq4YjQRsSDEFal+hrKxis57od7JyL8WlU2R0
         puyh15tvXEnyJssrk4FE07bPKa2Pga9gY/kAUjA3K8JMjPq7sLN5ShE+WBOeNyCRRVG2
         s37/cS+gJWVVsUT+AU2pBDwaNdUEmypTTzpZhxXDaxwq4DM5Bk/6AkLAHxg7EEOkFIUO
         n2ug==
X-Gm-Message-State: APjAAAVxd50PfW1xFzeAH77gCMMCQ5/QKAHI4O95WYUUPPkhWg4RfBRZ
        lmRprKXU/bz3PbKsqDuq87zX2vc9
X-Google-Smtp-Source: APXvYqxW9l8qsSaAMFlRzo0z1FqoYuuekufJOc3RiG8HHL1f7Y+BPyjg3C8luYoJPH+sD3A9P/osJw==
X-Received: by 2002:a17:902:a407:: with SMTP id p7mr11093411plq.4.1578760610566;
        Sat, 11 Jan 2020 08:36:50 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id u1sm7076399pfn.133.2020.01.11.08.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 08:36:49 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/5] netdevsim: fix a several bugs in netdevsim module
Date:   Sat, 11 Jan 2020 16:36:34 +0000
Message-Id: <20200111163634.4008-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes several bugs in netdevsim module.

1. The first patch fixes a race condition in netdevsim module.
netdevsim operation is called by sysfs and these operations use netdevsim
global resource but there is only a lock for protect list, not the whole
resource. So, panic occurs.

2. The second patch fixes stack-out-of-bound in nsim_dev_debugfs_init().
nsim_dev_debugfs_init() provides only 16bytes for name pointer.
But, there are some case the name length is over 16bytes.
So, stack-out-of-bound occurs.

3. The third patch avoid debugfs warning message.
When module is being removed, it couldn't be held by try_module_get().
debugfs's open function internally tries to hold file_operation->owner
if .owner is set.
If holding owner operation is failed, it prints a warning message.

4. The fourth patch uses IS_ERR instead of IS_ERR_OR_NULL.
debugfs_create_{dir/file} doesn't return NULL.
So, IS_ERR() is more correct.

5. The fifth patch avoids kmalloc warning.
When too large memory allocation is requested by user-space, kmalloc
internally prints warning message.
That warning message is not necessary.
In order to avoid that, it adds __GFP_NOWARN.

Taehee Yoo (5):
  netdevsim: fix a race condition in netdevsim operations
  netdevsim: fix stack-out-of-bounds in nsim_dev_debugfs_init()
  netdevsim: avoid debugfs warning message when module is remove
  netdevsim: use IS_ERR instead of IS_ERR_OR_NULL for debugfs
  netdevsim: use __GFP_NOWARN to avoid memalloc warning

 drivers/net/netdevsim/bpf.c       | 21 +++++++---
 drivers/net/netdevsim/bus.c       | 66 ++++++++++++++++++++++++-------
 drivers/net/netdevsim/dev.c       | 38 +++++++++++++-----
 drivers/net/netdevsim/health.c    |  6 +--
 drivers/net/netdevsim/ipsec.c     |  1 -
 drivers/net/netdevsim/netdevsim.h |  2 +
 6 files changed, 100 insertions(+), 34 deletions(-)

-- 
2.17.1

