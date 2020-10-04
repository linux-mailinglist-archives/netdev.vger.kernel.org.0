Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FBE282ADD
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 15:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgJDNTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 09:19:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725977AbgJDNTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 09:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601817582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=rgrRP/YTXU8zDHHZah13pYSFtC6P1oYXhuKtk3thRRw=;
        b=Yt1djlo7NasEVdIRH/81Ed78li5lUjZia+uHXWQrlQIBiWBRe/Nzazig0r1otzZNM3ztPR
        rPg4LEiP+sdw28F89i2k7vS8Qu/0B4nR+hXVC+FVXWXluYHsMJhkpVQKxvkmK6xr0NklBF
        FvPw9ldPbYbsPAKqKigaXjSwP1w4HOk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-QpyAnndaOBGr60Brwg7w0Q-1; Sun, 04 Oct 2020 09:19:41 -0400
X-MC-Unique: QpyAnndaOBGr60Brwg7w0Q-1
Received: by mail-qv1-f72.google.com with SMTP id s8so1324226qvv.18
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 06:19:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rgrRP/YTXU8zDHHZah13pYSFtC6P1oYXhuKtk3thRRw=;
        b=c4mLM1ngMykdTh1rEr62Ut5hYrw4ifJTfNIt/sCijS7iX9lRl3LX9edQUePV7//0v5
         u4Ih8cGSE05p0OHlnGBP795k63HpYs5pSjZSw+3v7zQd3vXBz82SlJoZjdkXZx0s062c
         mKiCKYm7xxKVIgx1lrJSzai84vrHBIa108pGk7cdTtuhK1994K3vv+bNNaD/u4d2wait
         b+bLGmY6D3k3CwXgEk9ONVwdHt00tIAQXGAusAmSaWly1B3Pkf4VrWVV3IjXQbOrX1OP
         9qSc53JnqPKL6ehpb+gAeBqvlVtFCd321A+K5BJYdYp3bTobg7iyks7lbS0GVrwN5hF/
         tmDQ==
X-Gm-Message-State: AOAM533ieqL/K6TepyCDiDODxhYGcv4BEPPgkfQX0kh+U7959Op9Rc53
        k8IGzxgOcosG6kIgHLFLHdDMO3Gk2TCl7FNQ3hynitzWhYVCEpwm5hFPHWZ3UjHT/qR/XbeepGb
        Ya4yflqQEewD6Hn1T
X-Received: by 2002:ac8:4410:: with SMTP id j16mr10412022qtn.305.1601817580596;
        Sun, 04 Oct 2020 06:19:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPVUB+BQ2zEs0jgpJsnX9LeCehIQzJydegR33P3TJAOehrv+31Xo/3GsZzzf3ZO8JTcvMgCg==
X-Received: by 2002:ac8:4410:: with SMTP id j16mr10411990qtn.305.1601817580275;
        Sun, 04 Oct 2020 06:19:40 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w4sm2657150qtb.0.2020.10.04.06.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 06:19:39 -0700 (PDT)
From:   trix@redhat.com
To:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, natechancellor@gmail.com, ndesaulniers@google.com,
        linville@tuxdriver.com, nishants@marvell.com, rramesh@marvell.com,
        bzhao@marvell.com, frankh@marvell.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] wireless: mwifiex: fix double free
Date:   Sun,  4 Oct 2020 06:19:31 -0700
Message-Id: <20201004131931.29782-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem:

sdio.c:2403:3: warning: Attempt to free released memory
        kfree(card->mpa_rx.buf);
        ^~~~~~~~~~~~~~~~~~~~~~~

When mwifiex_init_sdio() fails in its first call to
mwifiex_alloc_sdio_mpa_buffer, it falls back to calling it
again.  If the second alloc of mpa_tx.buf fails, the error
handler will try to free the old, previously freed mpa_rx.buf.
Reviewing the code, it looks like a second double free would
happen with mwifiex_cleanup_sdio().

So set both pointers to NULL when they are freed.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 69911c728eb1..bde9e4bbfffe 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2403,6 +2403,8 @@ static int mwifiex_alloc_sdio_mpa_buffers(struct mwifiex_adapter *adapter,
 		kfree(card->mpa_rx.buf);
 		card->mpa_tx.buf_size = 0;
 		card->mpa_rx.buf_size = 0;
+		card->mpa_tx.buf = NULL;
+		card->mpa_rx.buf = NULL;
 	}
 
 	return ret;
-- 
2.18.1

