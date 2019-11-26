Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2121109BD6
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfKZKJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:23 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37074 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbfKZKJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:21 -0500
Received: by mail-pg1-f194.google.com with SMTP id b10so8756297pgd.4;
        Tue, 26 Nov 2019 02:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=svo/DJZyqQpUo02aclcCc0QABc66WKSHZ6zQKD7a+Ow=;
        b=fru48dzlPmxdsRDObkYQrHO7JapBQH3c9E855CQRNtWbayYXM0dPryQmi5/whFOlpS
         GH/fVBCqvL0AWAPenfff2xRlbHbJeyN0FRY1MhHhuPk2ZlwRT9JdOfr9u4eKWjej1HTC
         q8G8loaTXtCX8EcOlrVw8hLTEh4GJrvM6aVuqV67oJNuisl5NmKblB7E+689x4Qa7LIa
         4SQq9JNWkXDoaqj5RJYNpcE68Ha/YC5zbmY6IAUN1+QQ+4kJDzhyh+LTm5ZfOUaLxAhM
         sWkA++CI/tDwSaPETlK0YUOCfMRpR+0Q+b9L8Xpbo+zpd9pTLP+X50M8f7aw4NZ0ZvnG
         QC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=svo/DJZyqQpUo02aclcCc0QABc66WKSHZ6zQKD7a+Ow=;
        b=nwb2W9BvkVhZ9X0MOfqyGcHkYYjKx/N90VDG1PHT1cHSPOktrdA3SpMP8uWL4UMdEx
         MPqDm6akNZe2eAaW5jADgjrCPMTfQx+zbsf/0zBXLkYyRSj/CidQjWPS4533W4GP42TN
         3sK2rt4p5Cj3tagGA3JqkSElN/FxvfAM2995QnjDkCwm+CA2erOIgtYgxfCtECdlWbpp
         5sOPWSPEBhXNd/u3bohA73EjNDRJ7DWRSK04Y8ZJkTQe7Dk+774iKAJGNZWvnT6higBs
         JpE4iUSfHX4xk6wfZx1uh6Iq3gHPhHRdolAWG3I2BSExlkoBtcsjCn2gAmbH3PmMTijU
         cCgQ==
X-Gm-Message-State: APjAAAUNFXiNjtd1TJx8RcJUf8EvM7dPqi0oF+qe3m7OTwSJRaIDfPd+
        f3Dxu+OnmI5698Me2Yhud5A=
X-Google-Smtp-Source: APXvYqx1KJySu2VSUlGFNdx7ooxLmUOdCiiNdkl+RVxrLvkON5zLWT+2U/MjtFSUA7MS5Y/R8paLmg==
X-Received: by 2002:a63:ff26:: with SMTP id k38mr39206249pgi.128.1574762960938;
        Tue, 26 Nov 2019 02:09:20 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:20 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC net-next 10/18] tun: handle XDP_TX action of offloaded program
Date:   Tue, 26 Nov 2019 19:07:36 +0900
Message-Id: <20191126100744.5083-11-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When offloaded program returns XDP_TX, we need to inject the packet in
Rx path of tun. This patch injects such packets in Rx path using
tun_xdp_one.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8d6cdd3e5139..084ca95358fe 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2249,7 +2249,13 @@ static u32 tun_do_xdp_offload(struct tun_struct *tun, struct tun_file *tfile,
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
2.20.1

