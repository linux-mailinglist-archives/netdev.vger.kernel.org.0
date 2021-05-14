Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E178A380FF2
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 20:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhENSm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 14:42:29 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:36488 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhENSm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 14:42:28 -0400
Received: by mail-ej1-f46.google.com with SMTP id c20so127971ejm.3;
        Fri, 14 May 2021 11:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gPu3JhIKExQczwKARwj2go99YLQAcb+tX8q8d0+CLrs=;
        b=IRhnxiNFs4rhtOcDPhilDB/M7RDi1YjJ7fRyPHpVEV0TDpsuwQud3UAKsOx8MJYmPT
         pBInW92wCHW6xfynwJR6Om+PYyaTgZC2m0WsvekjVOMamctBCOvsKDMuxqN8Ln2nzaCN
         qhEu6FbfKTt1orfjEOx/LHRz6zITZm1/jYlRXhLgEVf6klZLmTmOjrkcP+3Tw5CQswRD
         BZWrhqSegQE+J3M4MLPsZOMlLd9z+0+NgKeH7pnM+KlGxJMgKiZTgcZBPOSnviCoYWbx
         SHq8tU/f8k1XwjQ0klzouPCKPabsPL4LPXVDJx4vXNSnRyCTa/F0SU6VfmO900/VXFM7
         2CPQ==
X-Gm-Message-State: AOAM5331ZeMcroTGnlUHqukhEVO75QKvKYZxoOWEsCvBA6n0Bc5XXaSH
        fFUoP8o4A/P9ts4zpqoXiY/vC4rP82i3bg0y
X-Google-Smtp-Source: ABdhPJw/bzz+edLEyA47WDc1rrEAXftvdXlwn8/p6LzoZoO4/o+QryD11sVkSt7P+ExsEP3oTa1Mxg==
X-Received: by 2002:a17:906:6a93:: with SMTP id p19mr50865392ejr.319.1621017675225;
        Fri, 14 May 2021 11:41:15 -0700 (PDT)
Received: from turbo.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id dj17sm5081505edb.7.2021.05.14.11.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 11:41:14 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-stm32@st-md-mailman.stormreply.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next 3/3] vhost_net: use XDP helpers
Date:   Fri, 14 May 2021 20:39:54 +0200
Message-Id: <20210514183954.7129-4-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514183954.7129-1-mcroce@linux.microsoft.com>
References: <20210514183954.7129-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

Make use of the xdp_{init,prepare}_buff() helpers instead of
an open-coded version.

Also, the field xdp->rxq was never set, so pass NULL to xdp_init_buff()
to clear it.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/vhost/net.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index df82b124170e..6414bd5741b8 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -744,11 +744,9 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	if (copied != len)
 		return -EFAULT;
 
-	xdp->data_hard_start = buf;
-	xdp->data = buf + pad;
-	xdp->data_end = xdp->data + len;
+	xdp_init_buff(xdp, buflen, NULL);
+	xdp_prepare_buff(xdp, buf, pad, len, true);
 	hdr->buflen = buflen;
-	xdp->frame_sz = buflen;
 
 	--net->refcnt_bias;
 	alloc_frag->offset += buflen;
-- 
2.31.1

