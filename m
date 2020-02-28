Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950DA173EF7
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgB1SBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:01:01 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35049 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1SBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:01:01 -0500
Received: by mail-pf1-f196.google.com with SMTP id i19so2099246pfa.2
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 10:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8X/4s9GyLmWx112j3K8JJPsv4rz/J3NykmvsiKtuVuA=;
        b=skzrCPLBtadLV8EUr0rQat/+JfInLW55z1RPbns1tcvmQQrC91+fdsALuh8sUXhMgb
         MjiXBqniWn+a2+jtYmPxFmWo0B6SXDtS548qE3Zz1+Ax2JrsVxql3NOZSClcJ5MieajD
         51kO0wil204Wrv53JRHaC+p12lG1PicPhDsR3otpCkrcklhkt/EJ2JBvOpMELaYbzExB
         a4IdUYkV1AFYCawDN6Bcib2xk41NNB8qjnEWDzK7qrdwY5o/C7lY84haxWC/BK8lE5Ca
         AWwm+r3NizKWzEO3sKoEtSXcCKHv9DvnaCIZt+I4Ecmhe2DqfbDf6VaaH7ePrXNrETc/
         Jd7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8X/4s9GyLmWx112j3K8JJPsv4rz/J3NykmvsiKtuVuA=;
        b=KPdRy99E4GWio6o4e4WnqmBczZFZC7xuYBOJYNs5I5ZjoxfBqgHLvbmve2RdBL+hMi
         q0xVg6+oiXJgm3+8THPORRu4C2rQcc3/TH8FgSI8TFkOYT3FkFnRTtdvaX7rpVbnCnbP
         DRzSxL3hW5HvKQGL09etB3ng4sTUW4oywWd+H3l0QS4KRsIYk/fONCyLTkQGb7C1WgA0
         krOa6s6dKgS9EgCgKPoxsi+QQ66IrXTXBypEFVmZSOUHlgWmTTL9z133ZosGUghxjtbl
         RczmcOO/u8BOJuxayFViUEOoV+XBFfsJrlZnHZw1vY3W32yMbjLUujnGevgZDEjO7xhD
         yueA==
X-Gm-Message-State: APjAAAV7tzgzGwPvsOD8cpjBKhn5iIt0kzy8cigvhKA2Yn27nzXYX21c
        yvqKp4LRPeoVwwz2RLlBHAMo2OrgZf4=
X-Google-Smtp-Source: APXvYqzMiDt2YrAQTs3boScOt9bnWZ9Qcqk+sKnp8AwgTF8fFAadJUOxE3kv3+sp4EuZaGQnJLnBFQ==
X-Received: by 2002:a62:1709:: with SMTP id 9mr5679886pfx.196.1582912859807;
        Fri, 28 Feb 2020 10:00:59 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id w195sm7977496pfd.65.2020.02.28.10.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:00:58 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 0/5] hsr: several code cleanup for hsr module
Date:   Fri, 28 Feb 2020 18:00:46 +0000
Message-Id: <20200228180046.27511-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to clean up hsr module code.

1. The first patch is to use debugfs_remove_recursive().
If it uses debugfs_remove_recursive() instead of debugfs_remove(),
hsr_priv() doesn't need to have "node_tbl_file" pointer variable.

2. The second patch is to use extack error message.
If HSR uses the extack instead of netdev_info(), users can get
error messages immediately without any checking the kernel message.

3. The third patch is to use netdev_err() instead of WARN_ONCE().
When a packet is being sent, hsr_addr_subst_dest() is called and
it tries to find the node with the ethernet destination address.
If it couldn't find a node, it warns with WARN_ONCE().
But, using WARN_ONCE() is a little bit overdoing.
So, in this patch, netdev_err() is used instead.

4. The fourth patch is to remove unnecessary rcu_read_{lock/unlock}().
There are some rcu_read_{lock/unlock}() in hsr module and some of
them are unnecessary. In this patch,
these unnecessary rcu_read_{lock/unlock}() will be removed.

5. The fifth patch is to use upper/lower device infrastructure.
netdev_upper_dev_link() is useful to manage lower/upper interfaces.
And this function internally validates looping, maximum depth.
If hsr module uses upper/lower device infrastructure,
it can prevent these above problems.

Taehee Yoo (5):
  hsr: use debugfs_remove_recursive() instead of debugfs_remove()
  hsr: use extack error message instead of netdev_info
  hsr: use netdev_err() instead of WARN_ONCE()
  hsr: remove unnecessary rcu_read_lock() in hsr module
  hsr: use upper/lower device infrastructure

 net/hsr/hsr_debugfs.c  |  5 +---
 net/hsr/hsr_device.c   | 64 +++++++++++++++++++++---------------------
 net/hsr/hsr_device.h   |  3 +-
 net/hsr/hsr_framereg.c |  3 +-
 net/hsr/hsr_main.c     |  3 +-
 net/hsr/hsr_main.h     |  1 -
 net/hsr/hsr_netlink.c  | 49 ++++++++++++++++----------------
 net/hsr/hsr_slave.c    | 58 ++++++++++++++++++++------------------
 net/hsr/hsr_slave.h    |  2 +-
 9 files changed, 94 insertions(+), 94 deletions(-)

-- 
2.17.1

