Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EF7380FE7
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 20:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhENSlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 14:41:50 -0400
Received: from mail-ed1-f52.google.com ([209.85.208.52]:39825 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbhENSlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 14:41:50 -0400
Received: by mail-ed1-f52.google.com with SMTP id h16so1363592edr.6;
        Fri, 14 May 2021 11:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y4MTLt5TFZRdEBttrmfCcK1QF/TJDQ6Lo2hOuLadKIY=;
        b=GoacduemQ/+y4JnpILwBtZg0yJyHSLXxW2CKgafxfo7l8KndU5tVU3Q5+UTVeXii6I
         J6au3OZix4r+HjzD3iQs5S/sNj+HaOOTg0qQN9FCUh0opN1R8jTfhsKnsoEvpR3wGReU
         bMacm7vvLIZ5FmcLnD7SbWJo8DFCuEUyn6cvr1l/InWZFQrha2yo/2Mn2DUa9nwEwZiF
         vnNkQSEj2YNGOB0UgQ41GtjnZ8M6UbNYjiy7KqTPpycSIv+FFkrA9sLTUW5QzvrHf6Ab
         LK2X5BO+1btHxpj8zVowbudIAQtmyD9WySmBQ4jxAvIC13hbmCcmGpC5U+rrH4AMYZrQ
         CDbA==
X-Gm-Message-State: AOAM532qfd2l4Ibt1wenDG/WPVwVZWWr1w5f9DWZIX/zVYugcZS3JHEp
        mUhW32tv5oUXIk5hJ25v8yHD0azBl+xrXZWB
X-Google-Smtp-Source: ABdhPJztVPeeFds+ovfXgi5hiN0AM5Kzib6Wesqh/ef775Q8o65ykbVOOjTXi8FRmrOvM5b3sV8Pyw==
X-Received: by 2002:aa7:de99:: with SMTP id j25mr36955284edv.91.1621017637149;
        Fri, 14 May 2021 11:40:37 -0700 (PDT)
Received: from turbo.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id dj17sm5081505edb.7.2021.05.14.11.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 11:40:36 -0700 (PDT)
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
Subject: [PATCH net-next 1/3] stmmac: use XDP helpers
Date:   Fri, 14 May 2021 20:39:52 +0200
Message-Id: <20210514183954.7129-2-mcroce@linux.microsoft.com>
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

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 345b4c6d1fd4..bf9fe25fed69 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5167,12 +5167,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			dma_sync_single_for_cpu(priv->device, buf->addr,
 						buf1_len, dma_dir);
 
-			xdp.data = page_address(buf->page) + buf->page_offset;
-			xdp.data_end = xdp.data + buf1_len;
-			xdp.data_hard_start = page_address(buf->page);
-			xdp_set_data_meta_invalid(&xdp);
-			xdp.frame_sz = buf_sz;
-			xdp.rxq = &rx_q->xdp_rxq;
+			xdp_init_buff(&xdp, buf_sz, &rx_q->xdp_rxq);
+			xdp_prepare_buff(&xdp, page_address(buf->page),
+					 buf->page_offset, buf1_len, false);
 
 			pre_len = xdp.data_end - xdp.data_hard_start -
 				  buf->page_offset;
-- 
2.31.1

