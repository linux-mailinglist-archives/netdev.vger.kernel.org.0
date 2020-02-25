Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD5516B81C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 04:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgBYDcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 22:32:20 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39800 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgBYDcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 22:32:20 -0500
Received: by mail-pf1-f196.google.com with SMTP id 84so6437077pfy.6;
        Mon, 24 Feb 2020 19:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Pbt342k1OXmh+Pxr0Wxb2t1e7Z4oOL/0F3HAHBpB7Y=;
        b=kKKu2Er/WfLLJHimBkMyl2Ff5QWpltx4tU8wdrigPD+wLXhyddAldgn0qjNl4fzqDo
         v8WWv0dzBRfEnaF99WyEO/zsqtFyTyoeP2AOz/UEmY8pRIudYoXSWda0RUi2AzJL3Fu0
         Ijn39EvWC5VZRxpBnfu6cBGDtFhNqCeF2JmvbRB+O8vlXFyt+FVqsnm1UFOYwMjCXrfx
         zE76zREDQRzWZNA1+mPVucOkIEzYUk4U5uYHQfcr8iIhdEGjsXgxe4KO2GoKAexOMiU6
         rt92LY6vxJlskXow7Tfugt7OiEOFLHDQ26Rl8FaWdpAnOeuLp7vqYMA2zsAS7uuEmf27
         9cMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Pbt342k1OXmh+Pxr0Wxb2t1e7Z4oOL/0F3HAHBpB7Y=;
        b=mzZ9mnqXfKlsVeuCDWWEB9LGe3e9bTVSFLZuedIkUx38Y25WPgpQ6zV+lRAqF3vu9n
         VrF/G7lQmXXt5UwLNRVbrp4qO/BeVrQcuIrt/cuPA/djYy4YiY6qX2zNE/QH8t08EDxX
         qeYyKOad31/wiIE5RwP1/B/bptoGxKo5Kf1Btbt/pI35j3uaaYOYLxqFWo+zpteYBDEv
         eAePyNi/NPSRRO67H9m9LWfyJeJeBQE7UgHM2iTItpDtz7iz9XNbSy+m4Tzx7pt5Hegd
         Ci+/JlZk6JKHVDs9Wf6YXvpFSsNRQzNizbBdnxt1sESCsjP5vaO+CthiOfWNZ539BgpC
         l1UQ==
X-Gm-Message-State: APjAAAW2ixTXwE11rU8SVLNAgIP8PDV9eab4tnft6Usc4TVAsaUrgRHP
        XQI/vuifasC9LbGB5gx+OzM=
X-Google-Smtp-Source: APXvYqxbyJ3ocS64mE6VrZ8Ol9jZrPVt6k4a49HYxqhKsiIh+W0Y6DhpK7zY/GP/2Kq/6AvaTH9L/w==
X-Received: by 2002:a65:6412:: with SMTP id a18mr30009737pgv.10.1582601539703;
        Mon, 24 Feb 2020 19:32:19 -0800 (PST)
Received: from localhost.localdomain ([103.202.217.14])
        by smtp.gmail.com with ESMTPSA id u1sm14322493pfn.133.2020.02.24.19.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 19:32:19 -0800 (PST)
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
To:     jasowang@redhat.com
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        yuya.kusakabe@gmail.com
Subject: [PATCH bpf-next v6 1/2] virtio_net: keep vnet header zeroed if XDP is loaded for small buffer
Date:   Tue, 25 Feb 2020 12:32:11 +0900
Message-Id: <20200225033212.437563-1-yuya.kusakabe@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
References: <20200225033103.437305-1-yuya.kusakabe@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do not want to care about the vnet header in receive_small() if XDP
is loaded, since we can not know whether or not the packet is modified
by XDP.

Fixes: f6b10209b90d ("virtio-net: switch to use build_skb() for small buffer")
Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2fe7a3188282..f39d0218bdaa 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -735,10 +735,10 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	}
 	skb_reserve(skb, headroom - delta);
 	skb_put(skb, len);
-	if (!delta) {
+	if (!xdp_prog) {
 		buf += header_offset;
 		memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
-	} /* keep zeroed vnet hdr since packet was changed by bpf */
+	} /* keep zeroed vnet hdr since XDP is loaded */
 
 err:
 	return skb;
-- 
2.24.1

