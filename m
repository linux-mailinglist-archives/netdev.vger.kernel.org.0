Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC4124136
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLRINC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:13:02 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36565 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfLRINC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:13:02 -0500
Received: by mail-pf1-f194.google.com with SMTP id x184so793298pfb.3
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VWPabDljxt1vXjPxvTW6DeG3q7p28R03/ybNt6Nl24o=;
        b=EizGMbb4I2V8eqZfVkzEG/hFo4ZwreaZMS7h4rGgiBVB/D/XM5Q79KUiYH+vylti8G
         xNEeN11EELy63WuHVNThRkG+jcR548HwsydL2GitibA7S0AyHRwxlO6dFgxkYBrIMbev
         u9mjNYnFaNMyd4/k8Dqh6xj7TSTAul8kEYUk5MilXyoPZzpzzWr73vqgORlWBBtIdDWW
         BPDVldpKgrola93jdnXgEzeEIyd/fqhGFkguEeRaOuakg6AQB4YhgzrObYzLXW8pY/1e
         AvKwQx9kQ7lMgbJlg2Y/Crp8mDtpFzFEaB/ShyeFhCJaB25nDY/0w1y7P2rwsByoTN8x
         Ialg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VWPabDljxt1vXjPxvTW6DeG3q7p28R03/ybNt6Nl24o=;
        b=dRF1dHr9DY9R0dMSRbPUXzJlpqNVLa519Pp3Czm49nWzY73/WovAlXIMbJbbiwsK/m
         cFnuNiqzUkRlaqn6dHElU1Fy5qOg6kNx3Xb0/04PMymdSKvgQhm9qLoD3q6skPRGK6zd
         B0V3lzRw/4jRcfYrgfnCnEzfKTz7gzcgNM8wPFpwTGguMSSFfjQagyTm3zUyKujEDapu
         APhPio/wbDWJkfOez0yBhSBa20ZjWPHOLYy9y36zARZoFjno5m3OzcrjR0Xuen6GR/sA
         THP6YZDLyoqEN51TSDDAoZ0trqorqDW7VmmtVOn4vOWC+DJ/3YIEdMHiT/x4nZ1kBc7S
         MlPw==
X-Gm-Message-State: APjAAAXc52fJuRggwAWxpZN7DBx4eLV0ujVtMPzu4ZUnmgisl6PN+zx5
        zJyXH2PGElVtyYX6XnS5bNo=
X-Google-Smtp-Source: APXvYqxpnxfWR8C8H0Agx+uYaS2rKKO3nJFqc98Ut78KinbsES0wGn7ETxXI3AOlMa+a+/P0dqIonA==
X-Received: by 2002:a62:1d52:: with SMTP id d79mr1665517pfd.144.1576656781385;
        Wed, 18 Dec 2019 00:13:01 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:13:00 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC net-next 13/14] tun: handle XDP_TX action of tx path XDP program
Date:   Wed, 18 Dec 2019 17:10:49 +0900
Message-Id: <20191218081050.10170-14-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the action code is XDP_TX, we need to inject the packet in
Rx path of tun. This patch injects such packets in Rx path using
tun_xdp_one.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 0701a7a80346..8e2fe0ad7955 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2266,7 +2266,13 @@ static u32 tun_do_xdp_tx(struct tun_struct *tun, struct tun_file *tfile,
 		case XDP_PASS:
 			break;
 		case XDP_TX:
-			/* fall through */
+			tpage.page = NULL;
+			tpage.count = 0;
+			tun_xdp_one(tun, tfile, &xdp, &flush, &tpage, false);
+			tun_put_page(&tpage);
+			if (flush)
+				xdp_do_flush_map();
+			break;
 		case XDP_REDIRECT:
 			/* fall through */
 		default:
-- 
2.21.0

