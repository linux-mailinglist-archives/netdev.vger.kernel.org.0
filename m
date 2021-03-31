Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168AD3507E0
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbhCaUJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbhCaUJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:26 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A21C061574;
        Wed, 31 Mar 2021 13:09:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w18so23823088edc.0;
        Wed, 31 Mar 2021 13:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lBsxe6QWpE3ju/Zn+T4HTFVPluupUf6fsUZQesQX3FA=;
        b=gPpqXKjEoG8ixubkgoMm3pMWQDkQb9gsEgL+6fiz4y4HxfJaf0eX0svp9JIeCu7qQ/
         NvXkiCDZqD2pL3BKEmaBZTLJSrokeupHs15yxYWix86vyESkgzDJfWxMcW8V0Jcoqlj6
         g7CalbQ/V4HFY2EYYqGEK9iYZxMlgArcjkkONRSq4XBskA370gKNUbjywzQFO3pV38CD
         UIEwBbp5RnHPyrilaISFHQPJndj6XSEGmXrJz2VumfZnGNJIDhR6R4MhOFw1gOwkDjqP
         aeA2puyDrkeDkVHLWwNCYZucqglqGx5F6hQtsBUM7n79nZ4/JBcl02Vm1VBjdGweYB0a
         s8mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lBsxe6QWpE3ju/Zn+T4HTFVPluupUf6fsUZQesQX3FA=;
        b=Sotd6VmpxAhcZ+jxA6Fs7PnZ+I/gACF//A6KIi7NDr9CkH8IdwAHJeLbwZQs5rEKy2
         6W/wo1j/zqk5q5MjB0UWmGRnn2ansf1Qm08tZIt7OVF0bFr4MO/l/ZFz2bTF+Bxmh8dI
         IiLqwZG8Ke2HOuWpaCi2esY2lkYEceQQV/jDV9JYyaLiVsOewy+flgK09PCPwuUtsj7Q
         b8okHZdOomdKuw3/cHSX0rcatzYobj7Kj0kULTnCaYKLpZ9Pm6EZ6rwsolk7yNiDhzkM
         dy5NQnz8Hk6gy6E8mrU08RAgi5JEBpXNsw7OdQpqroHiJNWxlDX84nxsw3LVot4THNsf
         tB9Q==
X-Gm-Message-State: AOAM533BudD//faj38X1DVe5JIXABKGDmWRFJQWlYG+t8XWz47B+Uzg2
        DtosFCxAGyIyLB/IpilLcys=
X-Google-Smtp-Source: ABdhPJwayMsDzUZCWlyesqf3R+VZUrXGytWQ6rJpZWdcRefSVDaiG4i4R4nm251TRiHAgVO5Glnc2Q==
X-Received: by 2002:a05:6402:4244:: with SMTP id g4mr5893142edb.204.1617221364450;
        Wed, 31 Mar 2021 13:09:24 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:24 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 8/9] net: enetc: increase RX ring default size
Date:   Wed, 31 Mar 2021 23:08:56 +0300
Message-Id: <20210331200857.3274425-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
References: <20210331200857.3274425-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As explained in the XDP_TX patch, when receiving a burst of frames with
the XDP_TX verdict, there is a momentary dip in the number of available
RX buffers. The system will eventually recover as TX completions will
start kicking in and refilling our RX BD ring again. But until that
happens, we need to survive with as few out-of-buffer discards as
possible.

This increases the memory footprint of the driver in order to avoid
discards at 2.5Gbps line rate 64B packet sizes, the maximum speed
available for testing on 1 port on NXP LS1028A.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 864da962ae21..d0619fcbbe97 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -71,7 +71,7 @@ struct enetc_xdp_data {
 	int xdp_tx_in_flight;
 };
 
-#define ENETC_RX_RING_DEFAULT_SIZE	512
+#define ENETC_RX_RING_DEFAULT_SIZE	2048
 #define ENETC_TX_RING_DEFAULT_SIZE	256
 #define ENETC_DEFAULT_TX_WORK		(ENETC_TX_RING_DEFAULT_SIZE / 2)
 
-- 
2.25.1

