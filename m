Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F21386BF9
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244796AbhEQVJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233139AbhEQVJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:09:52 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134C6C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:35 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id s10-20020a05620a030ab02902e061a1661fso5657060qkm.12
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SHEphX70FFXDULDqKrDqdIKpPAQ4Kr5G7efBlVFNENo=;
        b=TSaL1luJ5WIRPDq7gs3VQKe63H7nt/Em702qROBcZfwwaS0BhQcJDJx3CFz1S55HQi
         G07xpd6sFKZLyPtZolUGcM8FMPGFJXpMPj+6+JVFuXfGTx4noUgkhIMKLSIe7W1Too3a
         kFBuBMJp2WuL+r8vMFGSzRh6j6EgPWyLMyVBr//SkHdH9NeLV3VY54kd8uQ+16gzU9b6
         gJHcWmgsUsKluXkkCzpD/Ojdo/DA42uUD11nmPbYSTbQAvDHyNi6ppmNDyfDza/mMsNF
         O2DVOSrHheEsvhWYewQbhK7wj/CX1UhU7/rVRqMuKrB84qgtE4gtx50+x2aRkagiz0bC
         LpIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SHEphX70FFXDULDqKrDqdIKpPAQ4Kr5G7efBlVFNENo=;
        b=WRz/T0cDoXtia1R/W9VLMbKAGqSIrSm0cO2EWrAe/Wd5UuPko1NlLIM2UnhNgHzVyL
         JLtpnxJR5E2A7aHfLxIuXzrzGU9UwGwb2SX5CMCvH1fVhNj2BD+fpve9uYqHq9A4kTCN
         z2FjSV9cDU3eRmz8AQlCAmOftiVXg7hk7pyVFOB8q5/URWzRILLrlsAqD7KK8bEgmZTg
         ETJTMFEzBZDPLuTbQiaAqu+XvRQDPNyCjPSJmgOKT6N4ws8o/Iz5ngm8Y/egKWjJ1c2e
         2QWiIxxwaZLyVYqPvbCYDluzrGPfmtzN+tsjh2QSa3Kw0vxPWiX/vI2897UAePJMp2FG
         2eQQ==
X-Gm-Message-State: AOAM531AWyrZTn2EWuJTrAbDiqtWVFGmGcF1Pjoe2SDw84AxYrg8mWL9
        1rAxpQk8Zoyem4Jbu2hHhBp4e9FsxqaAPfuOpFpckac49PC0gxSqAHtzZWeSe7HE6dQoA6pRKyH
        ofSEcrA2j8Z+ilNOL8peQ50MCBGOO/Kh36TknDZtn9TpiAo+tjKdyLEqWM42OrQ/pbIokHrZB
X-Google-Smtp-Source: ABdhPJzs1DHfE3x9xri52KBO7+C9tQ7FfI+ndaHXybN3CpWJS1KZz9xENxgrr6nEScs1z2pIo0EqqxtcTk0es6Uz
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:ba72:1464:177a:c6d4])
 (user=awogbemila job=sendgmr) by 2002:a05:6214:20c4:: with SMTP id
 4mr2090979qve.38.1621285714085; Mon, 17 May 2021 14:08:34 -0700 (PDT)
Date:   Mon, 17 May 2021 14:08:12 -0700
In-Reply-To: <20210517210815.3751286-1-awogbemila@google.com>
Message-Id: <20210517210815.3751286-3-awogbemila@google.com>
Mime-Version: 1.0
References: <20210517210815.3751286-1-awogbemila@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH net 2/5] gve: Update mgmt_msix_idx if num_ntfy changes
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we do not get the expected number of vectors from
pci_enable_msix_range, we update priv->num_ntfy_blks but not
priv->mgmt_msix_idx. This patch fixes this so that priv->mgmt_msix_idx
is updated accordingly.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/ethernet/google/gve/gve_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 7302498c6df3..64192942ca53 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -220,6 +220,7 @@ static int gve_alloc_notify_blocks(struct gve_priv *priv)
 		int vecs_left = new_num_ntfy_blks % 2;
 
 		priv->num_ntfy_blks = new_num_ntfy_blks;
+		priv->mgmt_msix_idx = priv->num_ntfy_blks;
 		priv->tx_cfg.max_queues = min_t(int, priv->tx_cfg.max_queues,
 						vecs_per_type);
 		priv->rx_cfg.max_queues = min_t(int, priv->rx_cfg.max_queues,
-- 
2.31.1.751.gd2f1c929bd-goog

