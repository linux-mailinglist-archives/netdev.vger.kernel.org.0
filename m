Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F239330D6
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfFCNTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:19:19 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43578 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFCNTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:19:17 -0400
Received: by mail-lj1-f194.google.com with SMTP id 16so2575828ljv.10
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 06:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/C1LT1bx3g7WPx/wKiHahB+UY59S2DI+l7zWgRA5mDU=;
        b=n5DYoJfo1fWUEjlq+bJ8mx76Y6mIqLD1a9es8GAd/O2Vs52MUrskIgT3VnKyYJDGv4
         9Auk+V956RIBnngMPo+qG7EJewtzLYeFAeJu9jqCBDHHsMnjhEN/XiHHNj58qDLYP5MS
         bCVLYVH55wcRGfK3hy1hNZDLyGEXaFrtXNRNOqfvPIQLEj/JgU4uWX5Dxv1p7xw3b5RN
         Szv0PRKsytBEi/XPHMPDZzNUPgQIwfcOFnQgiJLYgYr/EpTC3UuMPo1CASSqLQCKMQnd
         m9cmWrQjl+5O+zu+YH/AO0nVjwetI+dXtPgMqI5FeeUjK+f6pYusoSZ2pxkSBBYgCQTH
         ZrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/C1LT1bx3g7WPx/wKiHahB+UY59S2DI+l7zWgRA5mDU=;
        b=S0gaO30FdZ5gM/CAWf1UiRYXaK+Kf+zcTpI6BkuBJCw+d71zKZhlXVRWFh+3XZJxMS
         V4oquFzas8b38m7EU2ykzFziWbSQ2sA9DlY2xm8UCl6ks38/TUxgkUUTuQbhtbIF0oJH
         NUeMCBsgT9EN/Y9XhR2dN3EfIdymYL8lvHM74uVxoofDg/0cdvEdPWR+zAHs4ezMMmB4
         Ec+rPA81TloDCNMoF5rQlasND9sEXQut4M9RBa/r4hHF0ihS+8i5gM8WQQCql+zAOwgu
         k2eW3npGptBwg8/5cy1T0NKyIPKEr65xLLTgA+DtJrF1rF36Kns8tNgBqw4ZyFT2JAgW
         85GA==
X-Gm-Message-State: APjAAAXJUHUztGBAFzwDDkPFsGU6kPJpCb369bwh0uEglQscRF6xloJ3
        No2DQQB03FnfXuqJCdjnVe0=
X-Google-Smtp-Source: APXvYqyl27RsMHsn8uAd4WywLvEDh6D6FtEIJxrmY2VjfLbm2cNjed+ATHwQDYltvkrWsWhf4cKLTQ==
X-Received: by 2002:a2e:3a1a:: with SMTP id h26mr13749921lja.156.1559567956088;
        Mon, 03 Jun 2019 06:19:16 -0700 (PDT)
Received: from localhost.localdomain (host-185-93-94-143.ip-point.pl. [185.93.94.143])
        by smtp.gmail.com with ESMTPSA id 20sm577808ljf.21.2019.06.03.06.19.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 03 Jun 2019 06:19:15 -0700 (PDT)
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
X-Google-Original-From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com
Subject: [RFC PATCH bpf-next 2/4] libbpf: check for channels.max_{t,r}x in xsk_get_max_queues
Date:   Mon,  3 Jun 2019 15:19:05 +0200
Message-Id: <20190603131907.13395-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.16.1
In-Reply-To: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When it comes down to ethtool's get channels API, various drivers are
reporting the queue count in two ways - they are setting max_combined or
max_tx/max_rx fields. When creating the eBPF maps for xsk socket, this
API is used so that we have an entries in maps per each queue.
In case where driver (mlx4, ice) reports queues in max_tx/max_rx, we end
up with eBPF maps with single entries, so it's not possible to attach an
AF_XDP socket onto queue other than 0 - xsk_set_bpf_maps() would try to
call bpf_map_update_elem() with key set to xsk->queue_id.

To fix this, let's look for channels.max_{t,r}x as well in
xsk_get_max_queues.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/lib/bpf/xsk.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 57dda1389870..514ab3fb06f4 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -339,21 +339,23 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 	ifr.ifr_data = (void *)&channels;
 	strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
 	err = ioctl(fd, SIOCETHTOOL, &ifr);
-	if (err && errno != EOPNOTSUPP) {
-		ret = -errno;
-		goto out;
-	}
+	close(fd);
+
+	if (err && errno != EOPNOTSUPP)
+		return -errno;
 
-	if (channels.max_combined == 0 || errno == EOPNOTSUPP)
+	if (channels.max_combined)
+		ret = channels.max_combined;
+	else if (channels.max_rx && channels.max_tx)
+		ret = min(channels.max_rx, channels.max_tx);
+	else if (channels.max_combined == 0 || errno == EOPNOTSUPP)
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
 		ret = 1;
 	else
-		ret = channels.max_combined;
+		ret = -1;
 
-out:
-	close(fd);
 	return ret;
 }
 
-- 
2.16.1

