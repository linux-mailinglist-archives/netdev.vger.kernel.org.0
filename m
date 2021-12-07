Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AC946B1B4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhLGEFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbhLGEFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:05:45 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B63C061359
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:02:15 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id m25so13057693qtq.13
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 20:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=esY9Fo+mTFaNHsky8gYT9I2Vgb9OlmdOWP4kESY2sIE=;
        b=mNdgPX9xxePYSYlYrYwBRQLScy4P6Fvz7t63+Ij13p+/gv8gyhf1MK5QjCd6tZ2UZ4
         DjyXPh/RN+2AACoSDn9oJVubSZjlAxVHZnNPCRDAkG52X2exeEOrZokVW93hIBLB9wDR
         OQZ1TSNEjMk0buWOtaoXZ4fy6ntNwKa14B0tmoUX2Cg3fftsfQU6fAFUzCOJqymrLXXI
         TPDlxMLUwL1+fYRKxgYMuoInssjEdW1LJj3JQcQmcYhRl4ohbyzoULKfZgsIOPLXqH9Q
         +2pGhEUXEQD+mvGPxUFFWKZki8eaCjATsy5d80mSG2wq0Uh3Fgde1ANQO0Ls+78Ucy68
         Ruww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=esY9Fo+mTFaNHsky8gYT9I2Vgb9OlmdOWP4kESY2sIE=;
        b=eJ0lm34qs4+uqpkitpcdoRdXplRLGP5qXaobaxzQbZ3ypBI/4PMGhKkpU7hxA9K8cZ
         fQq3WgxURrsyNLuZ0Smn3YDA3dEe5Rc9dQS/A+uZOHkdzg1LsGP11ik1RtD5EX5xgWb8
         1ysWjZCmea6IYkC8/W3/ajvrLeNZDQa4nvAclXUm5508gOuJwE3jSBOK+6vSDK46eJut
         Eztozk5YYua0NB4ZhFLWI+Dhm7RFgdDhwQsDad/oFiPxyXAROFXlz0E0bOPk/ibesvwy
         ByU9YrWo5C5fpkACdGpnHfetk3rO6UZJJg/iNvlwEPkkWSZkp9wa1ddLkGpj/ogZUqoM
         4Iug==
X-Gm-Message-State: AOAM533/eI32Os0AN+RpU4MUnzd4TNMZaF37hMdmF8R1hxw7XqE35bIf
        FfUg0/YbHmbL7x6icjYiEizoryzvimcJ7A==
X-Google-Smtp-Source: ABdhPJyMS2vz3XNFdLQiSHwExup3UsYsheq9WeZeOMfOi7hkEpP1LwzlRmlAbyLjaMFWoeJSyok8yA==
X-Received: by 2002:a05:622a:92:: with SMTP id o18mr45314092qtw.570.1638849734459;
        Mon, 06 Dec 2021 20:02:14 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 14sm8526393qtx.84.2021.12.06.20.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 20:02:14 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 4/5] net: track in6_dev refcnt with obj_cnt
Date:   Mon,  6 Dec 2021 23:02:07 -0500
Message-Id: <47a018589c90c00026bef584ce4fa9356cdd973f.1638849511.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1638849511.git.lucien.xin@gmail.com>
References: <cover.1638849511.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two types are added into obj_cnt to count in6_dev_hold/get and in6_dev_put,
and all it does is put obj_cnt_track_by_dev() into these two functions.

Here is an example to track the refcnt of a in6_dev which is attached
on a netdev named dummy0:

  # sysctl -w obj_cnt.control="clear" # clear the old result

  # sysctl -w obj_cnt.type=0x30    # enable in6_dev_hold/put track
  # sysctl -w obj_cnt.name=dummy0  # count in6_dev_hold/put(in6_dev)
  # sysctl -w obj_cnt.nr_entries=4 # save 4 frames' call trace

  # ip link add dummy0 type dummy
  # ip link set dummy0 up
  # ip addr add 2020::1/64 dev dummy0
  # ip link set dummy0 down
  # ip link del dummy0

  # sysctl -w obj_cnt.control="scan"  # print the new result
  # dmesg
  OBJ_CNT: obj_cnt_dump: obj: ffff8a1e17906000, type: in6_dev_put, cnt: 1,:
       ipv6_mc_down+0x11e/0x1a0
       addrconf_ifdown+0x53c/0x670
       addrconf_notify+0xb8/0x940
       raw_notifier_call_chain+0x41/0x50
  OBJ_CNT: obj_cnt_dump: obj: ffff8a1e17906000, type: in6_dev_put, cnt: 1,:
       ma_put+0x4f/0xb0
       ipv6_mc_destroy_dev+0x150/0x180
       addrconf_ifdown+0x478/0x670
       addrconf_notify+0xb8/0x940
  ...
  OBJ_CNT: obj_cnt_dump: obj: ffff8a1e17906000, type: in6_dev_hold, cnt: 2,:
       fib6_nh_init+0x6b4/0x8f0
       ip6_route_info_create+0x4f2/0x670
       ip6_route_add+0x18/0x90
       addrconf_prefix_route.isra.50+0x100/0x150
  OBJ_CNT: obj_cnt_dump: obj: ffff8a1e17906000, type: in6_dev_hold, cnt: 2,:
       fib6_nh_init+0x6b4/0x8f0
       ip6_route_info_create+0x4f2/0x670
       addrconf_f6i_alloc+0xe3/0x130
       ipv6_add_addr+0x16a/0x740
  ...

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/obj_cnt.h | 2 ++
 include/net/addrconf.h  | 7 ++++++-
 lib/obj_cnt.c           | 4 +++-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/obj_cnt.h b/include/linux/obj_cnt.h
index ae4c12beb876..f014b2e613d9 100644
--- a/include/linux/obj_cnt.h
+++ b/include/linux/obj_cnt.h
@@ -7,6 +7,8 @@ enum {
 	OBJ_CNT_DEV_PUT,
 	OBJ_CNT_DST_HOLD,
 	OBJ_CNT_DST_PUT,
+	OBJ_CNT_IN6_DEV_HOLD,
+	OBJ_CNT_IN6_DEV_PUT,
 	OBJ_CNT_TYPE_MAX
 };
 
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 78ea3e332688..370a96b57dbd 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -357,8 +357,10 @@ static inline struct inet6_dev *in6_dev_get(const struct net_device *dev)
 
 	rcu_read_lock();
 	idev = rcu_dereference(dev->ip6_ptr);
-	if (idev)
+	if (idev) {
+		obj_cnt_track_by_dev(idev, idev->dev, OBJ_CNT_IN6_DEV_HOLD);
 		refcount_inc(&idev->refcnt);
+	}
 	rcu_read_unlock();
 	return idev;
 }
@@ -374,6 +376,7 @@ void in6_dev_finish_destroy(struct inet6_dev *idev);
 
 static inline void in6_dev_put(struct inet6_dev *idev)
 {
+	obj_cnt_track_by_dev(idev, idev->dev, OBJ_CNT_IN6_DEV_PUT);
 	if (refcount_dec_and_test(&idev->refcnt))
 		in6_dev_finish_destroy(idev);
 }
@@ -390,11 +393,13 @@ static inline void in6_dev_put_clear(struct inet6_dev **pidev)
 
 static inline void __in6_dev_put(struct inet6_dev *idev)
 {
+	obj_cnt_track_by_dev(idev, idev->dev, OBJ_CNT_IN6_DEV_PUT);
 	refcount_dec(&idev->refcnt);
 }
 
 static inline void in6_dev_hold(struct inet6_dev *idev)
 {
+	obj_cnt_track_by_dev(idev, idev->dev, OBJ_CNT_IN6_DEV_HOLD);
 	refcount_inc(&idev->refcnt);
 }
 
diff --git a/lib/obj_cnt.c b/lib/obj_cnt.c
index 648adc135080..8756efc005ed 100644
--- a/lib/obj_cnt.c
+++ b/lib/obj_cnt.c
@@ -18,7 +18,9 @@ static char *obj_cnt_str[OBJ_CNT_TYPE_MAX] = {
 	"dev_hold",
 	"dev_put",
 	"dst_hold",
-	"dst_put"
+	"dst_put",
+	"in6_dev_hold",
+	"in6_dev_put"
 };
 
 struct obj_cnt {
-- 
2.27.0

