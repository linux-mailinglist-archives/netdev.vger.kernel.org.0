Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E403A20CD
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhFIXbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:31:19 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:42747 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhFIXbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:31:05 -0400
Received: by mail-pf1-f173.google.com with SMTP id s14so31056pfd.9
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 16:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XAzb3VkfUYxU1teKArHCgpj6NOb9ejMO6tAx0JjUIoQ=;
        b=O88kABLyJToxtXQQFFjKPeMLrJ6YesZtMujpSNeGlQr4FiygAaEUmju5bI0djjtyMO
         fmcAoWXx+PQjavZKTMLpBmCljJ1id5ISpmeoUMvTwVllZ38QED5U5oIuNgaW/8FJouyL
         OiLP0c9ZxGG9OOuD6Jj5yFH8xh1WJo4xhhiJnI4Ewx6elUoDWibQFNeKjkHo6Q41BgVZ
         6OhFZ6U33EpgC9MKiUFgd9OVoT0548QMf4OzuoRrZcGp5QgdYh/+iS6Pzfu0KaDlqjjv
         FBKDBtgmajPmIt/ZcOzKSapooa1CDhL0tp2kafx6jHLIeKGMC1KlffQdYwljAhBcx5Rl
         UFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XAzb3VkfUYxU1teKArHCgpj6NOb9ejMO6tAx0JjUIoQ=;
        b=A6Xd2w7UDL8YirEezpONkTMgFEBt6ThGyvMgPcjGQ+cSvwrI4VX3cp+utGFk0JtCNW
         0voX/bAfxNAZrL5gAuA9nLQ6JCeoHOmhTRi4ztuzipUxncg0Z9LWD17f5zCLRlkGiTWO
         5PESBDN0ntqV7tGaD/6pfk/RBy1SDdbE1LxI4/HKxrvzEU7N2yH/W6j4BwnUpjV7VSEL
         uvQxsKtRDj0s2dvyF3l+Jh7JAWmkphiownCJge9TiyPu9gdwo+NbVgs8RtG9z8tXsIQ5
         5M/uAmrIFfQy7zdqpaIApdjOYPUcOINgv4DtCbCFaueko3fEw5fawYsFc02/WGnLci8e
         158A==
X-Gm-Message-State: AOAM531vmwFxj9/ddLsNCCuwQ6MdRum2a3aFXT6n12CbcFCbZpPf9O0Y
        suvhfGFpvGvpTFi9eEFImXIjLQ==
X-Google-Smtp-Source: ABdhPJxf83Qcv5sMhiGgL1PwI1FYFWMLIxV5hrXF/xSHNmKBquW4gmSwSNNe2aOfHo5UenCXytSasw==
X-Received: by 2002:a63:de02:: with SMTP id f2mr2100758pgg.32.1623281273711;
        Wed, 09 Jun 2021 16:27:53 -0700 (PDT)
Received: from n124-121-013.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id k1sm526783pfa.30.2021.06.09.16.27.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jun 2021 16:27:53 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v1 6/6] virtio/vsock: add sysfs for rx buf len for dgram
Date:   Wed,  9 Jun 2021 23:24:58 +0000
Message-Id: <20210609232501.171257-7-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210609232501.171257-1-jiang.wang@bytedance.com>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make rx buf len configurable via sysfs

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
---
 net/vmw_vsock/virtio_transport.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index cf47aadb0c34..2e4dd9c48472 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -29,6 +29,14 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
 static struct virtio_vsock *the_virtio_vsock_dgram;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
 
+static int rx_buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
+static struct kobject *kobj_ref;
+static ssize_t  sysfs_show(struct kobject *kobj,
+			struct kobj_attribute *attr, char *buf);
+static ssize_t  sysfs_store(struct kobject *kobj,
+			struct kobj_attribute *attr, const char *buf, size_t count);
+static struct kobj_attribute rxbuf_attr = __ATTR(rx_buf_value, 0660, sysfs_show, sysfs_store);
+
 struct virtio_vsock {
 	struct virtio_device *vdev;
 	struct virtqueue **vqs;
@@ -360,7 +368,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 
 static void virtio_vsock_rx_fill(struct virtio_vsock *vsock, bool is_dgram)
 {
-	int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
+	int buf_len = rx_buf_len;
 	struct virtio_vsock_pkt *pkt;
 	struct scatterlist hdr, buf, *sgs[2];
 	struct virtqueue *vq;
@@ -1003,6 +1011,22 @@ static struct virtio_driver virtio_vsock_driver = {
 	.remove = virtio_vsock_remove,
 };
 
+static ssize_t sysfs_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d", rx_buf_len);
+}
+
+static ssize_t sysfs_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	if (kstrtou32(buf, 0, &rx_buf_len) < 0)
+		return -EINVAL;
+	if (rx_buf_len < 1024)
+		rx_buf_len = 1024;
+	return count;
+}
+
 static int __init virtio_vsock_init(void)
 {
 	int ret;
@@ -1020,8 +1044,17 @@ static int __init virtio_vsock_init(void)
 	if (ret)
 		goto out_vci;
 
-	return 0;
+	kobj_ref = kobject_create_and_add("vsock", kernel_kobj);
 
+	/*Creating sysfs file for etx_value*/
+	ret = sysfs_create_file(kobj_ref, &rxbuf_attr.attr);
+	if (ret)
+		goto out_sysfs;
+
+	return 0;
+out_sysfs:
+	kobject_put(kobj_ref);
+	sysfs_remove_file(kernel_kobj, &rxbuf_attr.attr);
 out_vci:
 	vsock_core_unregister(&virtio_transport.transport);
 out_wq:
-- 
2.11.0

