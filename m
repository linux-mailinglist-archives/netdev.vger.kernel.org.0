Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAFC5109BCE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfKZKJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40466 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfKZKJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:09 -0500
Received: by mail-pg1-f195.google.com with SMTP id e17so8744173pgd.7;
        Tue, 26 Nov 2019 02:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o7wWeRbc+tNqQMSjrOB4Aqcs6TIYjdNZ6xF+Z6+tUq0=;
        b=T0I1EGJ6YTSRSu/Y4XLTUBBYnqBS9LwqseER/BjzdXl8Q7YQ6BBhOS6hWPwJ+Fampz
         P7EI5RxePE3I3u7Y94Tky0n+nFE78T2UBuBrF7foiUu5ODFJMPS7xZL9Attd9J/fv2xk
         YC0mrtwZW0lEhmUYXkLjAnrzjGf0MLJJzOGH6wypDpR4PUbQQZUzKRmWBcG+SeZ9cW79
         sSdTVoF36tW8MK07iZfRmuRxtHw8eS3BBMGKOv/L1m+aD66CZK50R2dRXBlpOSt96TbP
         YzvoGyvxaN5aONyAay/kSX0/Rb7Ga8eSzdNDD3OD5e5IZ1t55ny2HbvmNcgnnY5mr39+
         5zeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o7wWeRbc+tNqQMSjrOB4Aqcs6TIYjdNZ6xF+Z6+tUq0=;
        b=FEg0XJiyyQqIHsbT7FmgULPkXQPIu7pnXJrHus82fHrBIsAZkefbvddCiY0mV7cvl7
         DxhqV+Nb9FqFnvTXs9Q1u8wH7+4Yd8dvh7UHFuAjMyNGX+BwsK4FmKku2g6wR7e6eD/E
         D02sd3InkOyPOYe0Ln/d8QL9FYv6pt4natI3j3ItA7A66bAOE7LvbvCIOvwpcpjREj9s
         1hB9whgmBtGBc2LS7wCUVCOrD7rEpE33TCMQlQDE7Lg9ygPqUzIQaXIdas5GqvTs6XiQ
         s24DTxnz2vKwEU6iHKaxI8BBK4OhMoXoHtW5MNtvYefyY1Y7zkvws39SLI3b4n/Yj8zM
         6n/Q==
X-Gm-Message-State: APjAAAVEKBSRncaZNTtocJZwtwvReqxxj2KJ5IOX1oM3Ov+UE+zqyucI
        1DcCew78vbcKj2WOH0Mbg10=
X-Google-Smtp-Source: APXvYqwfaVLiFIs0iXc/+SHQsi0c/jFNHsDcCU5mOA5Ky5UmlUqcVt7e8bS0r/y9o05pZ3I6c6EV8A==
X-Received: by 2002:a65:4342:: with SMTP id k2mr38951684pgq.63.1574762949130;
        Tue, 26 Nov 2019 02:09:09 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:08 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 07/18] tun: set offloaded xdp program
Date:   Tue, 26 Nov 2019 19:07:33 +0900
Message-Id: <20191126100744.5083-8-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

This patch introduces an ioctl way to set an offloaded XDP program
to tun driver. This ioctl will be used by qemu to offload XDP program
from virtio_net in the guest.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c           | 19 ++++++++++++++-----
 include/uapi/linux/if_tun.h |  1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d078b4659897..ecb49101b0b5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -241,6 +241,7 @@ struct tun_struct {
 	struct bpf_prog __rcu *xdp_prog;
 	struct tun_prog __rcu *steering_prog;
 	struct tun_prog __rcu *filter_prog;
+	struct tun_prog __rcu *offloaded_xdp_prog;
 	struct ethtool_link_ksettings link_ksettings;
 };
 
@@ -2256,7 +2257,7 @@ static void tun_prog_free(struct rcu_head *rcu)
 {
 	struct tun_prog *prog = container_of(rcu, struct tun_prog, rcu);
 
-	bpf_prog_destroy(prog->prog);
+	bpf_prog_put(prog->prog);
 	kfree(prog);
 }
 
@@ -2301,6 +2302,7 @@ static void tun_free_netdev(struct net_device *dev)
 	security_tun_dev_free_security(tun->security);
 	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
 	__tun_set_ebpf(tun, &tun->filter_prog, NULL);
+	__tun_set_ebpf(tun, &tun->offloaded_xdp_prog, NULL);
 }
 
 static void tun_setup(struct net_device *dev)
@@ -3036,7 +3038,7 @@ static int tun_set_queue(struct file *file, struct ifreq *ifr)
 }
 
 static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog **prog_p,
-			void __user *data)
+			void __user *data, int type)
 {
 	struct bpf_prog *prog;
 	int fd;
@@ -3047,7 +3049,7 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog **prog_p,
 	if (fd == -1) {
 		prog = NULL;
 	} else {
-		prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
+		prog = bpf_prog_get_type(fd, type);
 		if (IS_ERR(prog))
 			return PTR_ERR(prog);
 	}
@@ -3345,11 +3347,18 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	case TUNSETSTEERINGEBPF:
-		ret = tun_set_ebpf(tun, &tun->steering_prog, argp);
+		ret = tun_set_ebpf(tun, &tun->steering_prog, argp,
+				   BPF_PROG_TYPE_SOCKET_FILTER);
 		break;
 
 	case TUNSETFILTEREBPF:
-		ret = tun_set_ebpf(tun, &tun->filter_prog, argp);
+		ret = tun_set_ebpf(tun, &tun->filter_prog, argp,
+				   BPF_PROG_TYPE_SOCKET_FILTER);
+		break;
+
+	case TUNSETOFFLOADEDXDP:
+		ret = tun_set_ebpf(tun, &tun->offloaded_xdp_prog, argp,
+				   BPF_PROG_TYPE_XDP);
 		break;
 
 	case TUNSETCARRIER:
diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 454ae31b93c7..21dbd8db2401 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -61,6 +61,7 @@
 #define TUNSETFILTEREBPF _IOR('T', 225, int)
 #define TUNSETCARRIER _IOW('T', 226, int)
 #define TUNGETDEVNETNS _IO('T', 227)
+#define TUNSETOFFLOADEDXDP _IOW('T', 228, int)
 
 /* TUNSETIFF ifr flags */
 #define IFF_TUN		0x0001
-- 
2.20.1

