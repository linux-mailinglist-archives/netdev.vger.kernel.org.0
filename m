Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FF32A3258
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgKBRyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgKBRyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:54:10 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792FEC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 09:54:10 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id o11so4508216ioo.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 09:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kjh9WgiqBVSUAvLs7toC2QhJpUJCRR5iDChKKMxmY5I=;
        b=CcTmczI+e6uTjpaawiLSYDUqp792Sn7sA/r9gm1izHUo647K3CHwxKtZ085XolY3Es
         isR+3a6NY7BHH2N8YHguNM0TtOB+RzUDNQw7hOsayZX3NWrMoDSLHg1DEYfn4bCzGiN1
         WY9cI6XjWBQx/G86WAzj3ElFRQxsKf5oOdeL/H8fB6qQKUjeXnyd2X+a2ibeqvC/mspT
         1o1Y1S0HigSf5Nw+0pZWJQW6Don39xIe8k3LZuJDuMSn5U4Pv+45MvAqx2HhvBCw1rNQ
         ntXjA9A5RoPPyiTXiyd0fIVP2otB6JPyTilObR/cSmzKGsdrcWKstqwKSzn8/gEiiaFl
         0ZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kjh9WgiqBVSUAvLs7toC2QhJpUJCRR5iDChKKMxmY5I=;
        b=W6ju+NAUOCA1uknOiaIdCbvk4FT+sq6PlcpshRvMOYRbr/aSAoUKqvFei4VKMMhUJ+
         +6c6kJYoBtgksnLeo5SU+xH/xY0yd+CPIdY0ciRypesrpbKQyHf1uA2pwARESmOIX3wx
         QrQ3b+b+Q7DCSAUH6V3JTdfU8EeJIKtffDirRPd927sRrjtfXqsKizwbP09BgqoErYeG
         KH/+1JPtXAzc7BV8yVojP3gOfBrTSZlzbKIc4Soy2ypOkOLWZmjnvC9wVptkVZwTpgr1
         WsXW/2MhwwSyP6EIOwI5Uzh6mBnxWeYNOHVqPBqeXLK5n0sFFBoQeFYF89M+RVvE27M6
         SYVg==
X-Gm-Message-State: AOAM532v8WO6JCwYiT10FVc+p54/EVmTHMpkTojReeYUYl7dcdLBgE8D
        0XS/JtbWjuX6+bbw034f0af+7g==
X-Google-Smtp-Source: ABdhPJzTN5SMSgrGOauj/u3STIPdZbm9FGQeb35n0CNSWxpjGZXtBAuaqh+gU+T3wPw1e0gm0KfPkA==
X-Received: by 2002:a02:c817:: with SMTP id p23mr12650309jao.138.1604339649852;
        Mon, 02 Nov 2020 09:54:09 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r4sm11089591ilj.43.2020.11.02.09.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:54:09 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: use version in gsi_channel_reset()
Date:   Mon,  2 Nov 2020 11:53:58 -0600
Message-Id: <20201102175400.6282-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201102175400.6282-1-elder@linaro.org>
References: <20201102175400.6282-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A quirk of IPA v3.5.1 requires a channel reset on an RX channel to
be performed twice.  Use the IPA version in gsi_channel_reset()
rather than the passed-in legacy flag to determine that.

This is actually a bug fix, because this double reset is supposed
to occur independent of whether we're enabling the doorbell engine.
Now they will be independent.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index eae8ed83c1004..729ef712a10fd 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -840,7 +840,7 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool legacy)
 
 	gsi_channel_reset_command(channel);
 	/* Due to a hardware quirk we may need to reset RX channels twice. */
-	if (legacy && !channel->toward_ipa)
+	if (gsi->version == IPA_VERSION_3_5_1 && !channel->toward_ipa)
 		gsi_channel_reset_command(channel);
 
 	gsi_channel_program(channel, legacy);
-- 
2.20.1

