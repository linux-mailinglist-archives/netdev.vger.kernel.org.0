Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A7BF22CF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbfKFXra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:47:30 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43160 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfKFXr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:47:29 -0500
Received: by mail-pf1-f194.google.com with SMTP id 3so458141pfb.10;
        Wed, 06 Nov 2019 15:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IITHycz/tKeCtcoGS9oSqQaaGm3H0ejbd50X22z8NiA=;
        b=QBM+UW+9MI+uREWzRjPCDMTdRcJ1Qg9A1mV9chE5KjhqRQK8ZTlnzavCFuKjvmApo0
         dLMC9dCKtbzlyt2F0etYRl9F6hMMAl2ZWhnqk+1qjKTziWxKwfA9tYuxgHLUtNXUaQFY
         OAtGyQlApB2naKonvaurwkRT8u5RsF2+hJd6dXgnsZvq4NSYZPju1+8F+8zPDs9+pZ+J
         S2gwQtppNc/DtmGJz6rSAq4SJ5J4LjD/1ZNAluTfXjvV++shwxekEoJIQcMKzFiTHlL7
         BPRzlUZ8gf1gO6+TvpexhzXi4VNnhOwwrCMQwpY24IymcCjHxGV2MjWegPyqB5uBNd1g
         xyIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IITHycz/tKeCtcoGS9oSqQaaGm3H0ejbd50X22z8NiA=;
        b=Ke9gYUfGogLpJdxKDkjkDe8Tix2vovfNghwn58tkOhQ39XH8H81gg5EdAUcl1i/aI/
         bOMLDCDTTEBSAjGyRfVOYPR+SfBCAaBQvrWVZ/PIQcph+ulvAxQAP1vllYkx3D+nqU4q
         z/NpP7FfBC3HpjZ9ddFj5OmchDJl+j348GHDQJYOhetorqGqixCH/ra+vU1DnnSFOrmi
         9jrR9UidkNrrCkQIeXWFspp15s7fc2R7dXQiaVolVXxm0z9Nw7UyNTZNeXT5lTgKZIJy
         KQNU1kqmUPInBdovxNhC8SyNx3PUYnESY7Ta+lG/UinU8MiB79OyFQfhHgoIp1fY0RDr
         +rdA==
X-Gm-Message-State: APjAAAXaEO+vQu/K7QHizu35e+gP9JZY+dPnibjQNUsIPbBrNeTx0Ml0
        +QcA5Bt+qMWR4IRN9eJDFsZ76g2d
X-Google-Smtp-Source: APXvYqxUKtpDTnctikFB0dQsxG/rxh3cI4BqhqNcmERqcbnbqreW4bT2lTMAT4Iu/13iDxCfITTTBQ==
X-Received: by 2002:a63:ed17:: with SMTP id d23mr620290pgi.125.1573084049060;
        Wed, 06 Nov 2019 15:47:29 -0800 (PST)
Received: from aw-bldr-10.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id y26sm104198pfo.76.2019.11.06.15.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 15:47:28 -0800 (PST)
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: [PATCH] ath10k: Handle "invalid" BDFs for msm8998 devices
Date:   Wed,  6 Nov 2019 15:47:12 -0800
Message-Id: <20191106234712.2380-1-jeffrey.l.hugo@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the BDF download QMI message has the end field set to 1, it signals
the end of the transfer, and triggers the firmware to do a CRC check.  The
BDFs for msm8998 devices fail this check, yet the firmware is happy to
still use the BDF.  It appears that this error is not caught by the
downstream drive by concidence, therefore there are production devices
in the field where this issue needs to be handled otherwise we cannot
support wifi on them.  So, attempt to detect this scenario as best we can
and treat it as non-fatal.

Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index eb618a2652db..5ff8cfc93778 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -265,10 +265,13 @@ static int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
 			goto out;
 
 		if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
-			ath10k_err(ar, "failed to download board data file: %d\n",
-				   resp.resp.error);
-			ret = -EINVAL;
-			goto out;
+			if (!(req->end == 1 &&
+			      resp.resp.result == QMI_ERR_MALFORMED_MSG_V01)) {
+				ath10k_err(ar, "failed to download board data file: %d\n",
+					   resp.resp.error);
+				ret = -EINVAL;
+				goto out;
+			}
 		}
 
 		remaining -= req->data_len;
-- 
2.17.1

