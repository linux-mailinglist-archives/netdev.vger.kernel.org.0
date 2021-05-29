Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71A2394AB3
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 08:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhE2GHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 02:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhE2GHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 02:07:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EAFC061574;
        Fri, 28 May 2021 23:05:33 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso3694249pjb.5;
        Fri, 28 May 2021 23:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dj+sVpS2uayKHiIJ1N88jZYGI1O1BdFKfgWRCDtgcRw=;
        b=oBmxC+MnK9tUUJJeZJufxG9NHq6kIQQY6R/LuZVLQ1FItodhfhciBM8szGm+onRt+V
         sJuT9r/hTu+8FGSjHRwM4W23A/aKAPgxuEnjWPC9Ys4gpC8ZjJfKVcowoY0qkiFXiqwe
         YHtdljdCNhQAllPwxV5IvA8r/4QYgzFFJ7X9Wm+XC5cMQtQgKRnOUXCv4JfmRTCMVpSj
         qaddp1VvIN9DKDGkuzDb18YknshlgbUS5EykGhN11mQ/Gh+XK/Weoz2ESOl7bhzLJ2Kn
         kVsglDU/IcTpy8YPCxwOfZIlmvkjKMyOs37r0ILDIIMYBd2n2vuy0Va40IcmbZZJaIX1
         oJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dj+sVpS2uayKHiIJ1N88jZYGI1O1BdFKfgWRCDtgcRw=;
        b=H2BajBvPSc2we4zKO69pzUc7BfgLV13Zl5eMWsoyGZeharnJR+qF7O9ov3LNUZ4ryt
         uvdZ8rqmDsoBWnM1U/6bKVMKGLGh2MP4QO5jcBM4FWwsiWsJH07XJhSoRYIGqLqNPViy
         M8PdHrs8Y2fmWwn5A/LhAWvxlTnhaakuK+8K89AClgccxjauloIjlhOhp1nz12cHhN2p
         paT1bBi0R8WadlflWiz1+b2Vd6qT+8fYdUW+D+zpg+J9LH3IapCElskzIOA04XVm6+Xt
         86+AKzq2YuJ5HTGwkVhkk377IsLF6nE8PuNrt4ca8MFeVTzjUFvcTzicagbflMDZIV4U
         WBjQ==
X-Gm-Message-State: AOAM530VrVzsRUvq9SOg/xdwklCf2YxQVAEC4Mclv7WzNUD32U+zndwt
        FCAYMYA2utaum23XO0jD0UA=
X-Google-Smtp-Source: ABdhPJzJk51CMG+RbBrsd/wxt+xHRmOmoRQjW/Qa/nDEtITWWRgyGAkJkaAnPaWE3UlY/yzLqkCysg==
X-Received: by 2002:a17:90a:d482:: with SMTP id s2mr8407870pju.230.1622268332834;
        Fri, 28 May 2021 23:05:32 -0700 (PDT)
Received: from vultr.guest ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id u4sm5841520pgl.43.2021.05.28.23.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 23:05:32 -0700 (PDT)
From:   Changbin Du <changbin.du@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kici nski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] net: fix oops in socket ioctl cmd SIOCGSKNS when NET_NS is disabled
Date:   Sat, 29 May 2021 14:05:26 +0800
Message-Id: <20210529060526.422987-1-changbin.du@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When NET_NS is not enabled, socket ioctl cmd SIOCGSKNS should do nothing
but acknowledge userspace it is not supported. Otherwise, kernel would
panic wherever nsfs trys to access ns->ops since the proc_ns_operations
is not implemented in this case.

[7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[7.670268] pgd = 32b54000
[7.670544] [00000010] *pgd=00000000
[7.671861] Internal error: Oops: 5 [#1] SMP ARM
[7.672315] Modules linked in:
[7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
[7.673309] Hardware name: Generic DT based system
[7.673642] PC is at nsfs_evict+0x24/0x30
[7.674486] LR is at clear_inode+0x20/0x9c

Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: <stable@vger.kernel.org> # v4.9
---
 net/socket.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/socket.c b/net/socket.c
index 27e3e7d53f8e..644b46112d35 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			mutex_unlock(&vlan_ioctl_mutex);
 			break;
 		case SIOCGSKNS:
+#ifdef CONFIG_NET_NS
 			err = -EPERM;
 			if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 				break;
 
 			err = open_related_ns(&net->ns, get_net_ns);
+#else
+			err = -ENOTSUPP;
+#endif
 			break;
 		case SIOCGSTAMP_OLD:
 		case SIOCGSTAMPNS_OLD:
-- 
2.27.0

