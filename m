Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8DD40A653
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 07:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbhINF5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 01:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240076AbhINF45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 01:56:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DAAC0613D8
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 22:55:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so1269346pjc.3
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 22:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G1r+PKn4GPi7tXv7G1Zx8y7Ad3TbADcUlxOtCJuMJ9E=;
        b=WFmQK5DvQiFqAYV8O83mKh1GmJeqLA1x0B9Xlco8l0r1opONGkdT5QuyB8bpIOp3Fi
         zKYVFf26FHs4soKGT03AZ/G9Uw6uABy33oR9dEhYkjkWLkhYXhZPtYCC+Eq48BSfp87l
         HuKXfjlhOEMy7qJhf59bxA6zimuQJkyVdQYIJK008JW8mv6ULCI7DnU8VRYh2mDZdH7C
         vjpNYsUNbD0vxnQhU+efAGEB8w969RI6U4nzw1tWg+fq3DxdcxXkZXkucXfarLeJxrvQ
         0o0fV7lYit9bRfM0qPeNWrSwymxqVMxw8ufxsQDj8Xla+g/MbAqtOB/G0AtxQdDsC+Be
         ylBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1r+PKn4GPi7tXv7G1Zx8y7Ad3TbADcUlxOtCJuMJ9E=;
        b=xymBJ49dG5WoQAkhSFQ/HP7jmGp6l5oaAE0obL7HHSDz1TKMXmckUqjsDlxc/2vhDy
         A9AG5ErLIA5k/tNimhkHuNl7Reyt7CyNxueLdP/49Yk/Mfmi0wkTk/F1Q+jwOfQ6za9Q
         +L+MuM16dcd4WBhRpUg8mF+WF9uVtoIfoH0YUMznLQJACyur7o7NytKvoLqgl2anvKeh
         4tMZtq6VR0dDoYLvggRzBcuQvh+r7A9UdcOyq7jdrcr2qAbH6+Phi+yzqaEBPN4esiH/
         5nwxDtsYCw6yXLRFt5bn9tKcx0k3zMpfVT1apnL+h7ubF6J+KgHidlzsMzxbiyM7jq+t
         qNBg==
X-Gm-Message-State: AOAM530KJnbZVs6s3ieCA7OGRTRyhXXt/KnRLBdOVge5SuCLC6UBO8Bq
        JI/gil/bNenrLu91dF5V6t9KhA==
X-Google-Smtp-Source: ABdhPJwHnmiE2l2SLtit++3MdPSftvz6R+3O0lu+TqRRVfEaMWXOAZMibzor2ZI3swNE5GqNONApug==
X-Received: by 2002:a17:90a:b794:: with SMTP id m20mr163206pjr.178.1631598939320;
        Mon, 13 Sep 2021 22:55:39 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id v14sm719432pfi.111.2021.09.13.22.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 22:55:38 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     jiangleetcode@gmail.com
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        sgarzare@redhat.com, mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.com, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v2 5/5] virtio/vsock: add sysfs for rx buf len for dgram
Date:   Tue, 14 Sep 2021 05:54:38 +0000
Message-Id: <20210914055440.3121004-6-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210914055440.3121004-1-jiang.wang@bytedance.com>
References: <20210914055440.3121004-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make rx buf len configurable via sysfs

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
---
 net/vmw_vsock/virtio_transport.c | 46 ++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 8d5bfcd79555..55216d979080 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -29,6 +29,16 @@ static struct virtio_vsock __rcu *the_virtio_vsock;
 static struct virtio_vsock *the_virtio_vsock_dgram;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
 
+static int rx_buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
+static struct kobject *kobj_ref, *kobj_ref2;
+static ssize_t  dgram_sysfs_show(struct kobject *kobj,
+				 struct kobj_attribute *attr, char *buf);
+static ssize_t  dgram_sysfs_store(struct kobject *kobj,
+				  struct kobj_attribute *attr, const char *buf,
+				  size_t count);
+static struct kobj_attribute rxbuf_attr = __ATTR(dgram_rx_buf_size, 0660, dgram_sysfs_show,
+						 dgram_sysfs_store);
+
 struct virtio_vsock {
 	struct virtio_device *vdev;
 	struct virtqueue **vqs;
@@ -362,7 +372,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 
 static void virtio_vsock_rx_fill(struct virtio_vsock *vsock, bool is_dgram)
 {
-	int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
+	int buf_len = rx_buf_len;
 	struct virtio_vsock_pkt *pkt;
 	struct scatterlist hdr, buf, *sgs[2];
 	struct virtqueue *vq;
@@ -1027,6 +1037,23 @@ static struct virtio_driver virtio_vsock_driver = {
 	.remove = virtio_vsock_remove,
 };
 
+static ssize_t dgram_sysfs_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d", rx_buf_len);
+}
+
+static ssize_t dgram_sysfs_store(struct kobject *kobj,
+				 struct kobj_attribute *attr, const char *buf,
+				 size_t count)
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
@@ -1044,8 +1071,19 @@ static int __init virtio_vsock_init(void)
 	if (ret)
 		goto out_vci;
 
-	return 0;
+	kobj_ref = kobject_create_and_add("vsock", kernel_kobj);
+	kobj_ref2 = kobject_create_and_add("virtio", kobj_ref);
+
+	/*Creating sysfs file for etx_value*/
+	ret = sysfs_create_file(kobj_ref2, &rxbuf_attr.attr);
+	if (ret)
+		goto out_sysfs;
 
+	return 0;
+out_sysfs:
+	kobject_put(kobj_ref);
+	kobject_put(kobj_ref2);
+	sysfs_remove_file(kobj_ref2, &rxbuf_attr.attr);
 out_vci:
 	vsock_core_unregister(&virtio_transport.transport);
 out_wq:
@@ -1058,6 +1096,10 @@ static void __exit virtio_vsock_exit(void)
 	unregister_virtio_driver(&virtio_vsock_driver);
 	vsock_core_unregister(&virtio_transport.transport);
 	destroy_workqueue(virtio_vsock_workqueue);
+	kobject_put(kobj_ref);
+	kobject_put(kobj_ref2);
+	sysfs_remove_file(kobj_ref2, &rxbuf_attr.attr);
+
 }
 
 module_init(virtio_vsock_init);
-- 
2.20.1

