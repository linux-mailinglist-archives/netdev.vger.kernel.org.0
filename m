Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A05438F8D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 08:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhJYGeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 02:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhJYGeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 02:34:14 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12237C061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 23:31:53 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j2-20020a1c2302000000b0032ca9b0a057so5336295wmj.3
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 23:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IU97dhMN03dLY/kygfW1cgxmCot70vnGBo1iGl+4lh4=;
        b=FNI2PzfYc5/fCkdNFc5k1q2TFEDI+LVvNKNAtpRtifCBPkOZbNccaFDmYgOK3ePUJa
         OJXaVW/FHqDgGt8TwIOhxpf7BdFp6hqI0f/P1YLqDtxKSgdXAlrNcw+m6SW5+GmST7tI
         B8ls7rlRg/EW9vmwlkPjandapth7uVT51YMysRe83GcaJ80GUN+tGKqE39IwiOPa4Tng
         2p2ix+/9V7/XpvhyHT12Uq1tgnM7dN92OIDjGURkjOKBVipZf68R7wFPK5kfp0i9M3v8
         1kKXNJjinB1GkJzCgpN7PGSv4jysHsJVEmifg/o6vd+wTHiqr7aCj2ZcWkh7q3mVOst3
         X/2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IU97dhMN03dLY/kygfW1cgxmCot70vnGBo1iGl+4lh4=;
        b=plLp+E+YtvIsuilBmKAyjO+2vxyXzzJDXZKAIVqX7vahKyR9Ob5pxGfd2jS4862qny
         TQL6GembIyczQLVkYa+EvQkk9ndwtZH7lA9Lar/3PUfWw8hvltytVdvNCQBeLpS2LdUP
         8Cq6l62MN+FslXgNLMuXkFSPpjw33DLx6KNvPn0VA3mKoBcyqE1bwyEH2pUWqTBZi7S9
         jUv3wnhfga8NrA0+qgyOURxHnQAYcV9o7vg7bMJ2rsVdLAKvm8fzYqP87i5rnVdUPaLl
         IIxgwv/IabWj1DNdkpnV7IHUO7uYae8JEVuORDLoVvRdkDpY+yGaXQZLY1T1Gx+nqhUK
         Imig==
X-Gm-Message-State: AOAM5310s9zVyjZb5/+FVQZXxeLg6SUazLPyBEjbdwspui9W10dBPM5j
        RRqPUa+wmqcC0ohxVy4w8nFuU5bPzzXyzA==
X-Google-Smtp-Source: ABdhPJwyPVnLlqJwaTnj1UmDPewGGTJvZuxoJfQfZOQRfxKuXykTRYx7ZlRCoGLWuMjQpGJNkRKgww==
X-Received: by 2002:a7b:cc11:: with SMTP id f17mr18142428wmh.122.1635143511527;
        Sun, 24 Oct 2021 23:31:51 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b207sm7618360wmd.3.2021.10.24.23.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 23:31:51 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH net] net-sysfs: initialize uid and gid before calling net_ns_get_ownership
Date:   Mon, 25 Oct 2021 02:31:48 -0400
Message-Id: <a1d7fda6a8e54a766fc9922e3abec8411120c3ac.1635143508.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in net_ns_get_ownership() it may not be able to set uid or gid
if make_kuid or make_kgid returns an invalid value, and an uninit-value
issue can be triggered by this.

This patch is to fix it by initializing the uid and gid before calling
net_ns_get_ownership(), as it does in kobject_get_ownership()

Fixes: e6dee9f3893c ("net-sysfs: add netdev_change_owner()")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/net-sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f6197774048b..b2e49eb7001d 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1973,9 +1973,9 @@ int netdev_register_kobject(struct net_device *ndev)
 int netdev_change_owner(struct net_device *ndev, const struct net *net_old,
 			const struct net *net_new)
 {
+	kuid_t old_uid = GLOBAL_ROOT_UID, new_uid = GLOBAL_ROOT_UID;
+	kgid_t old_gid = GLOBAL_ROOT_GID, new_gid = GLOBAL_ROOT_GID;
 	struct device *dev = &ndev->dev;
-	kuid_t old_uid, new_uid;
-	kgid_t old_gid, new_gid;
 	int error;
 
 	net_ns_get_ownership(net_old, &old_uid, &old_gid);
-- 
2.27.0

