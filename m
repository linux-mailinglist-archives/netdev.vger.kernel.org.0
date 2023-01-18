Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E978672949
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 21:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjARU32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 15:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjARU31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 15:29:27 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8025DC0A
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:29:26 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g23so200479plq.12
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 12:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y8SspAPfkyjpo8sc8kHtR2b6FK9e6JUk9ZrRa3juDFE=;
        b=f8rHo6PO4YO5TdnLBaE4J6q8/eQpi+BGKzSxfubcJh9QNGVWzsHzRWPXSgxj5N4Kf3
         GX2EQVjBJjHaSu9WVwhJ3vT9nD2AfDKI/DmbCUsyAq3T3EYUtZaeCWiJAlqYRNkechJa
         Tygs5lx2A69GxGBDZDA/W9G7NDGE8I5JLs6jXJYt7o5uNXrUeotsOy7aIjQlMnniw/h7
         A/SS+mzACZG656qV6nSDglIaJ8aHNVGQqNgbCDOQN6yRDtohqgODdJy6mKVe7v5YK2cz
         JJmcsSEc0iA5+obrcFQWa31ko9Y+WHOeQt50EuaF0WBdu9U6z132iMQfrCG+5W2lZBh7
         4fsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y8SspAPfkyjpo8sc8kHtR2b6FK9e6JUk9ZrRa3juDFE=;
        b=2zoObLb3QifULuwuYozgWqSo5NPpaO+CFA7CXg987BrRnZGnXHM2ib5qvTqd1fwM3d
         KjLGQOP4UHRzQjvEqRky4+0PXsgbyXX8hEaCrz7Q+BjSku+rOzQxUcN2zS6LZJw7ppWn
         9p/oGPjvy6wVmm/jNe4w96/IVXajD0GNDJNUr/155x/vzVD4rGviLtQlq9rbCoXT/uAk
         Y/1ulvXR5S0D5FMwr1/M4UQlsNUTVWLDZ7PGDqf0U/ZcMzOALlR1dRIWXTfDUqvw4hiW
         rMQZZ/lmDF0PkGLHeAUHUnqr0ERk482EIzI69Ra0GsMxsWReK+w2beb5chi2Xkr0P1aD
         HSuA==
X-Gm-Message-State: AFqh2kpHmh86/DDd+ja2DRSKlXhUY5nTnAOsuabxjVZ9SH+spU28ETHk
        71ShcY4j/7oHzx4ASMJ2zkfK5A==
X-Google-Smtp-Source: AMrXdXsJLK+EISYnk3NuapK9nUhIvsuTriY5KbmYTlcP0MQIsy0J7HnRgxhC/s4nRTR+zxmjrFzfdg==
X-Received: by 2002:a17:90a:468d:b0:229:983:f3f9 with SMTP id z13-20020a17090a468d00b002290983f3f9mr25342454pjf.40.1674073765683;
        Wed, 18 Jan 2023 12:29:25 -0800 (PST)
Received: from [127.0.1.1] (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090a3b4d00b002132f3e71c6sm1724948pjf.52.2023.01.18.12.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:29:25 -0800 (PST)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 18 Jan 2023 12:27:40 -0800
Subject: [PATCH RFC 2/3] selftests/bpf: add vsock to vmtest.sh
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230118-support-vsock-sockmap-connectible-v1-2-d47e6294827b@bytedance.com>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
X-Mailer: b4 0.11.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability to use vsock in the vmtest.sh script and
the test kernel config.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 tools/testing/selftests/bpf/config.x86_64 | 4 ++++
 tools/testing/selftests/bpf/vmtest.sh     | 1 +
 2 files changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/config.x86_64 b/tools/testing/selftests/bpf/config.x86_64
index dd97d61d325ca..db5e6b9a91711 100644
--- a/tools/testing/selftests/bpf/config.x86_64
+++ b/tools/testing/selftests/bpf/config.x86_64
@@ -234,7 +234,11 @@ CONFIG_VIRTIO_BLK=y
 CONFIG_VIRTIO_CONSOLE=y
 CONFIG_VIRTIO_NET=y
 CONFIG_VIRTIO_PCI=y
+CONFIG_VIRTIO_VSOCKETS=y
+CONFIG_VIRTIO_VSOCKETS_COMMON=y
 CONFIG_VLAN_8021Q=y
+CONFIG_VSOCKETS=y
+CONFIG_VSOCKETS_LOOPBACK=y
 CONFIG_X86_ACPI_CPUFREQ=y
 CONFIG_X86_CPUID=y
 CONFIG_X86_MSR=y
diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index 316a56d680f25..aad27ffd4ec68 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -250,6 +250,7 @@ EOF
 		-enable-kvm \
 		-m 4G \
 		-drive file="${rootfs_img}",format=raw,index=1,media=disk,if=virtio,cache=none \
+		-device vhost-vsock-pci,guest-cid=1234 \
 		-kernel "${kernel_bzimage}" \
 		-append "root=/dev/vda rw console=${QEMU_CONSOLE}"
 }

-- 
2.30.2
