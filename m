Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21019379EBF
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 06:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhEKEoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 00:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbhEKEob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 00:44:31 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A658C0613ED
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:43:25 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso501910wmh.0
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 21:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C9XpXxYtaOMpWOUjJ4wuUSOsoeZftgUi9oWw6L6+6PY=;
        b=i8N263f+uXxe91WLuxJx5RvGTcU+LOlIZILGfgaQzBDs6R/OaZ26o9Jduve+32BvM0
         SBW5jvdKVYeAZmZN2gJYZTbusqcxDTTC15Lpii1SMDeN7urjfzM0n4B6AIEXRELudkAm
         ONRljjTtiItJ/VZma2gKCNrnXZ4b4XK0kHPXfxOYFa5/HwbafB07Xt0fVqX7vfPtpn9d
         fMPog8BUQcwL0WZCqE/LfaVSMRv8ythODRvoqifUAjufxR7YfIiFvybGHoR/pVpoGsAj
         zjKpR1k5AeoLdOJ3xV/+lVo6WQMDN+ca4vpe7dLYnfXjH5BFwWj+7ZyGtcbGLngURzZD
         Vi9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9XpXxYtaOMpWOUjJ4wuUSOsoeZftgUi9oWw6L6+6PY=;
        b=AEtWv1KrYNofJwGNY9DUxHTl5nykzp/EVjuLH7aEk7FIPHPybtAk8zzdxrU2Y16eJB
         FOdiqLWIQ/+cRJbaRv5JBt0ISA/jN6EmDXy0Kr4Seu6T1J33kr9MM3R7HlYv85Cpn/rg
         ibVwc6jFKn3fQcUGYHUzhUN26CF1c+Ii/t3B3xVyZzy9D77pARjf/cl/LTLHX78APrvG
         2N9dOWyR0/OJTuAJfwujJL/YJiPF87xaOswKUXoyPjhcfCmRmy9l/AnE1jCP+C/+LDjc
         TlWkT5fB6sEHiYoQOoeBeCgh20+Ii989siTMyuxoeZ0INs4mZzWiofxTuw9vuQ68qDmZ
         A/uw==
X-Gm-Message-State: AOAM530rL4/9OfuoH72SQTmGeIHelgpm5lKX4YXW6Hmd6Q2ZMV+xQ6w0
        NlzYTT4URVRNN0e6RdyYVwXEfw==
X-Google-Smtp-Source: ABdhPJyQk9PXGY/kEfZFu3FcsyaZ0+l7hvZVvgX/jf5mBiF4QiF5aERcUZgxITkN4JxfM3z5J6nLRg==
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr3023530wmh.102.1620708202793;
        Mon, 10 May 2021 21:43:22 -0700 (PDT)
Received: from f1.Home (bzq-79-180-42-161.red.bezeqint.net. [79.180.42.161])
        by smtp.gmail.com with ESMTPSA id a9sm22360520wmj.1.2021.05.10.21.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 21:43:22 -0700 (PDT)
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
To:     davem@davemloft.net, kuba@kernel.org, mst@redhat.com,
        jasowang@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     yan@daynix.com
Subject: [PATCH 2/4] virtio-net: add support of UDP segmentation (USO) on the host
Date:   Tue, 11 May 2021 07:42:51 +0300
Message-Id: <20210511044253.469034-3-yuri.benditovich@daynix.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210511044253.469034-1-yuri.benditovich@daynix.com>
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Large UDP packet provided by the guest with GSO type set to
VIRTIO_NET_HDR_GSO_UDP_L4 will be divided to several UDP
packets according to the gso_size field.

Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
---
 include/linux/virtio_net.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index b465f8f3e554..4ecf9a1ca912 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -51,6 +51,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			ip_proto = IPPROTO_UDP;
 			thlen = sizeof(struct udphdr);
 			break;
+		case VIRTIO_NET_HDR_GSO_UDP_L4:
+			gso_type = SKB_GSO_UDP_L4;
+			ip_proto = IPPROTO_UDP;
+			thlen = sizeof(struct udphdr);
+			break;
 		default:
 			return -EINVAL;
 		}
-- 
2.26.3

