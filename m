Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E78E128D90
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 12:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfLVLZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 06:25:19 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35870 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfLVLZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 06:25:18 -0500
Received: by mail-pf1-f193.google.com with SMTP id x184so7731819pfb.3
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 03:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tj0PUv3dvIdNOrGgmj5kPI4hutmid5dD4m/Z8s+z6dE=;
        b=E+MzzF4fRS1ymePFpGTvqY9PKk1kW7lF+BRGzkYLe//13e2lvs+RhvqZmCeHoYcM27
         Y0WNA/sIMNQDFW+NMZ3zsxxXQggEILHBAXv1c5eJrm9UWkg/ijHf3oo6vzVIeEJiXIOa
         hpdOmDgX+WYXK1mXuJfukCr6tNB/icRwu28cg99oqUhP5CPIebyuJnncu+DRJ+aNNOCK
         7NBR0GvOfT0PF48zbXpBRxp+p3F8Xz/3xqbVW2xeBQhiOWQxZuzaL6ysdTqP4Y1PEiwG
         3bej3O3h9f1HMALnuhO0fH5k5H53Crq4EhYkguKteVUQQ0FBUQlyIMGfQQhFQCHKqu+c
         CvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tj0PUv3dvIdNOrGgmj5kPI4hutmid5dD4m/Z8s+z6dE=;
        b=NjduPCe2eNwKuhQu+uS+5Z29frahkPczWyJh32GI+kOixLjacuej2UWzE0m/P4cLBs
         a3x/TqImimIxdk7j5p61kOCNj4q5+J1yehD15w5oKpP+xuakFM5JK+kR/pUbUTrxx0M7
         mhAaSPoOgpb7mQ0eTeSrDivPMNWMG4c+DuK9LNmGJNJlNSMkclx2LtYVbBFr56JfAs0/
         HR+RZE3qsyd7+CQMP+ixqvRBAnZpQ8h9CnmvC9ni+YuzspQqqR3XwjbNXJmjXdPhHacs
         NuqkVc8VwM4SP9+Qy9Nkp84LzmwWR9rsr2KcOt8n3f2zVh6HhfOCB+K5rfKZRh654YKg
         RIEQ==
X-Gm-Message-State: APjAAAXXTKbiFTFMAGvYdMYcgJN/DMAaZOk/kK+n9u6YvUiNUDUPuway
        u8IxXjUbVIA3lEqkM5RrcS0=
X-Google-Smtp-Source: APXvYqyiHqnG0ZPh3QNUhBGMkxyUnBBw1wmnayJ0msJsJrRrmGvyoon5eRKpubsSJXgrEDt4bVB2eQ==
X-Received: by 2002:a62:1857:: with SMTP id 84mr27058682pfy.257.1577013917839;
        Sun, 22 Dec 2019 03:25:17 -0800 (PST)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id e4sm9454632pfa.44.2019.12.22.03.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 03:25:16 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, arvid.brodin@alten.se,
        jakub.kicinski@netronome.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/6] hsr: fix several bugs in hsr module
Date:   Sun, 22 Dec 2019 11:24:58 +0000
Message-Id: <20191222112458.2859-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. The first patch fixes debugfs warning when it's opened when hsr module
is being removed. debugfs file is opened, it tries to hold .owner module,
but it would print warning messages if it couldn't hold .owner module.
In order to avoid the warning message, this patch makes hsr module does
not set .owner. Unsetting .owner is safe because these are protected by
inode_lock().

2. The second patch fixes wrong error handling of hsr_dev_finalize()
a) hsr_dev_finalize() calls debugfs_create_{dir/file} to create debugfs.
it checks NULL pointer but debugfs don't return NULL so it's wrong code.
b) hsr_dev_finalize() calls register_netdevice(). so if it fails after
register_netdevice(), it should call unregister_netdevice().
But it doesn't.
c) debugfs doesn't affect any actual logic of hsr module.
So, the failure of creating of debugfs could be ignored.

3. The third patch adds hsr root debugfs directory.
When hsr interface is created, it creates debugfs directory in
/sys/kernel/debug/<interface name>.
It's a little bit faulty path because if an interface is the same with
another directory name in the same path, it will fail. If hsr root
directory is existing, the possibility of failure of creating debugfs
file will be reduced.

4. The fourth patch adds debugfs rename routine.
debugfs directory name is the same with hsr interface name.
So hsr interface name is changed, debugfs directory name should be
changed too.

5. The fifth patch fixes a race condition in node list add and del.
hsr nodes are protected by RCU and there is no write side lock.
But node insertions and deletions could be being operated concurrently.
So write side locking is needed.

6. The Sixth patch resets network header
Tap routine is enabled, below message will be printed.

[  175.852292][    C3] protocol 88fb is buggy, dev veth0

hsr module doesn't set network header for supervision frame.
But tap routine validates network header.
If network header wasn't set, it resets and warns about it.

Taehee Yoo (6):
  hsr: avoid debugfs warning message when module is remove
  hsr: fix error handling routine in hsr_dev_finalize()
  hsr: add hsr root debugfs directory
  hsr: rename debugfs file when interface name is changed
  hsr: fix a race condition in node list insertion and deletion
  hsr: reset network header when supervision frame is created

 net/hsr/hsr_debugfs.c  | 52 +++++++++++++++++++++++-------
 net/hsr/hsr_device.c   | 28 +++++++++-------
 net/hsr/hsr_framereg.c | 73 ++++++++++++++++++++++++++----------------
 net/hsr/hsr_framereg.h |  6 ++--
 net/hsr/hsr_main.c     |  6 +++-
 net/hsr/hsr_main.h     | 22 +++++++++----
 net/hsr/hsr_netlink.c  |  1 +
 7 files changed, 125 insertions(+), 63 deletions(-)

-- 
2.17.1

