Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227E3315B91
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhBJArb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhBJApW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:45:22 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99547C0617A7
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 16:42:35 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id e4so283365ote.5
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 16:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ZnFgpWZW/pibsdLxTLSbnISeByhzyHarQxXUqXKzeg=;
        b=hItZCUkUv3hVP0EKFKWGCHiq7LK6jTKvkwxQLRTVv+G2duyo63PGIc8YpI3DXE6v6Q
         93/TWf1dv1X8blaa5DeXeJ06ryE89D1TQkJDMHeu8+4PcwShh/BskEUrk4FnAjGukA1/
         b6mCu9NEcGcDsOJPB1nb3PYD86+w1ds5Zeedg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ZnFgpWZW/pibsdLxTLSbnISeByhzyHarQxXUqXKzeg=;
        b=NwL/1rES0wBhck3d7JhWddAqKZif+9lbJOrxcUBBtE1Bg+9JSYA7Nz1R5X19o6+AwH
         ud5IgUzdibKam48/s3kYgELBDZ13vgNPVTsDMciOb9OhxP6mrByikFN/tgrqeZdNFdZU
         SUYd6zVc9BJUgpGgsRNoeXt3g49z5bApixykxu1GtRcatTrhAdfMm+GpbHZt7mWW0V8J
         tmUKLbU2/VzAT6xVf+tUTcBJ+9EEn6Q3gcVaMfXc+BDB/QwX6wr+Rtlw+MYKpUHRyKTv
         6Lge2HySRiOb3jAfbvjX9ze12KU/jcOLOxxOwfIC0iwVgOPRAzSQ+nzky8WKrRoaTTvV
         fQow==
X-Gm-Message-State: AOAM531f9BjggwF663TmfmPeUhUBqQA9ZhG++9okY1Kicq3HH0WMJgTN
        5wIFRrUJ2ZBsR/D+2PdfoK3HrA==
X-Google-Smtp-Source: ABdhPJweKOk0U05wNNP7z8KOUn9C3PAmUn3jmo0QzHPBvGkR1giuIk30fNASdJrHyDRZtCLGpIiDCQ==
X-Received: by 2002:a9d:4e2:: with SMTP id 89mr259973otm.140.1612917755107;
        Tue, 09 Feb 2021 16:42:35 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s123sm103060oos.3.2021.02.09.16.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:42:34 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ath10k: change ath10k_offchan_tx_work() peer present msg to a warn
Date:   Tue,  9 Feb 2021 17:42:24 -0700
Message-Id: <3b1f71272d56ee1d7f567fbce13bdb56cc06d342.1612915444.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1612915444.git.skhan@linuxfoundation.org>
References: <cover.1612915444.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on the comment block in this function and the FIXME for this, peer
being present for the offchannel tx is unlikely. Peer is deleted once tx
is complete. Change peer present msg to a warn to detect this condition.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index e815aab412d7..53f92945006f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3954,9 +3954,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 		spin_unlock_bh(&ar->data_lock);
 
 		if (peer)
-			/* FIXME: should this use ath10k_warn()? */
-			ath10k_dbg(ar, ATH10K_DBG_MAC, "peer %pM on vdev %d already present\n",
-				   peer_addr, vdev_id);
+			ath10k_warn(ar, "peer %pM on vdev %d already present\n",
+				    peer_addr, vdev_id);
 
 		if (!peer) {
 			ret = ath10k_peer_create(ar, NULL, NULL, vdev_id,
-- 
2.27.0

