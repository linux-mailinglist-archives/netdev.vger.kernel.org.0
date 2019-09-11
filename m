Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3514AF950
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 11:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfIKJpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 05:45:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33806 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfIKJpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 05:45:13 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so11272228pgc.1;
        Wed, 11 Sep 2019 02:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xohSRI3/IN3LcNp/shyymPBhjiQ0ndNIrEZv77qi1n8=;
        b=eNFrYSBTzqFYv6+obW49UrPBUKl9KYM0Rdo2ufzGT7FnHxVylhb0D+BvmoELZdjrif
         jh08AbIoPqz+O0YbqIVuK4JjIlS0h72or+DMIicDzRslV8q3aaM91zdtFlz4MSoLA+4p
         LK9+lPOwgKA/FkZhEhjXMTcsBMQEJSQJK+eO2Zxq64FYec+KgdDkUh005o4f4vRM2BAZ
         wU7xsSkMLH0HEp1Lng201XZ9Ty1KN3sWXpmAPUyb/sp7nU6UMiLqd1irw9Kp5MUTmL1R
         Nou+WTCCysSsKDQhbOvQgeLb581nZaYAm+eHMK2zvPl61DFZQ8ygJB32ISzxreCNuQWJ
         BNpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xohSRI3/IN3LcNp/shyymPBhjiQ0ndNIrEZv77qi1n8=;
        b=D9IGC0FRB4D7PydYQg3YMUNzIQ1CHaEoBDrngch67Jg2jDbo0SF0TDozFib5F5nzpH
         evBcZixpI0Yv3XsjhzI++ehv3JTyNuojV3jSqBdL1Yl6Qp+K5QsE4QM4Bo3nnUH9+/w6
         iEpHrvAX5K4tfaBmFY/YqQBtd2EPoPQl3f8Mn17UKeM/xV/L8TJGdadbzUW9GHQijawv
         Db43ATuvhFyCeKsl7Ltkr6qeSjYv53031UqICnwdxoz/Sz5GhiNp9OK7eI50x5rmBg4w
         GgeLsMVGeDMXCv4VevHL7gyiJzxWuclzBTL1j7GZ7daac7ffNuhbeWtieyk2Td2jQfL1
         SpFw==
X-Gm-Message-State: APjAAAXryAXQHS4c0D37HTxZ7cpheRi9tNkoaOm8Yf9YG1XLpBU2Noqt
        iJxAWKQur2BTml1U6Q81sqs=
X-Google-Smtp-Source: APXvYqzGG3hxVk92CVHl/gupHPvrti067E/3fRB1vNM3dLv8dfmiJoRkfg1nqwCDmIS3eHu8cM88EQ==
X-Received: by 2002:aa7:9303:: with SMTP id 3mr42022142pfj.29.1568195112978;
        Wed, 11 Sep 2019 02:45:12 -0700 (PDT)
Received: from VM_67_169_centos.localdomain ([129.226.133.242])
        by smtp.gmail.com with ESMTPSA id m13sm20987739pgn.57.2019.09.11.02.45.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 02:45:12 -0700 (PDT)
From:   ">" <duanery.duan@gmail.com>
X-Google-Original-From: yongduan@tencent.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lidongchen@tencent.com, yongduan <yongduan@tencent.com>,
        ruippan <ruippan@tencent.com>
Subject: [PATCH] vhost: make sure log_num < in_num
Date:   Wed, 11 Sep 2019 17:44:24 +0800
Message-Id: <1568195064-18037-1-git-send-email-yongduan@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yongduan <yongduan@tencent.com>

The code assumes log_num < in_num everywhere, and that is true as long as
in_num is incremented by descriptor iov count, and log_num by 1. However
this breaks if there's a zero sized descriptor.

As a result, if a malicious guest creates a vring desc with desc.len = 0,
it may cause the host kernel to crash by overflowing the log array. This
bug can be triggered during the VM migration.

There's no need to log when desc.len = 0, so just don't increment log_num
in this case.

Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
Reviewed-by: Lidong Chen <lidongchen@tencent.com>
Signed-off-by: ruippan <ruippan@tencent.com>
Signed-off-by: yongduan <yongduan@tencent.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
---
 drivers/vhost/vhost.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5dc174a..36ca2cf 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2178,7 +2178,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
 		/* If this is an input descriptor, increment that count. */
 		if (access == VHOST_ACCESS_WO) {
 			*in_num += ret;
-			if (unlikely(log)) {
+			if (unlikely(log && ret)) {
 				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
 				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
 				++*log_num;
@@ -2319,7 +2319,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			/* If this is an input descriptor,
 			 * increment that count. */
 			*in_num += ret;
-			if (unlikely(log)) {
+			if (unlikely(log && ret)) {
 				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
 				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
 				++*log_num;
-- 
1.8.3.1

