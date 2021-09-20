Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CFC410EA2
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 05:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbhITDLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 23:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbhITDKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 23:10:47 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A389AC0613D3;
        Sun, 19 Sep 2021 20:09:08 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y8so14895790pfa.7;
        Sun, 19 Sep 2021 20:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pttii/mW6L03BPJ/XcL96bSG4P+EhN6sWLdnr6WQgkE=;
        b=P4RlnyNPwzpZpZLby8HCaQ2PZhLGLJ2R1Knb/HkWBzC7jD5FLopSZpZjalnWM39Kyu
         9ozyF5y50LxMa3klP88pHGQnk28Of9hFqPR3ybqnerjf3he4UK9PcW2WLAbQIzEADsWo
         meoOGJvONfeERU2L4G9CqoaVWa0OjARayHULiRSFitV3kPezXAQ5gkFMzxQufclqXLqY
         1982TL9Xn4l4ZipyrX73VpWHXh7ihz1KB6URnMcNbhdIr19RgqOJl9NpLTlNfICFzpOT
         ZtbTcKsN/9jvkLfwXnpfxthcOl9eSoi413NxF4I6gq67VN7wwoIqo3zNFb2DLbNlRfNh
         85XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pttii/mW6L03BPJ/XcL96bSG4P+EhN6sWLdnr6WQgkE=;
        b=Ee3avpJfTfA/LEgWcUNVlm5Pl8s1ewzVOmNwRbEyBWbVT+d3zGrKCtslk9hJq/cVDZ
         aspOn3GKtvTFUzC/QXbAE8Wg+rPV3oVl4UpvcXkevAJ8R+lYZgTxLF+9PwrZ844Wacym
         FjojI3hLbvsvYffcABZwWsRPg7JNBK8CWD335IBA/Pxf7IvTjxqVV3PozRvbXfLSCHBQ
         NKsY8L/d8QhI0crhPexfsumrGLN1GVIQz0iECt6eiDEKPXQrLNdk7ea0Oy9L5cwW88sV
         FY8JZXaWTLzYyBAe24rrs6CGC6krsyvtyX3AFRym7msqv7RJmTUss/dKK5o9PLe2Hy65
         27gw==
X-Gm-Message-State: AOAM531rK4wUs9mGejIOelx6ZXFpYgIe7AFoMCckIgOOWlI/vKpTCUKf
        wYSPHSXTVUYd+mRVDLIRjazHaOIsmzVtkVa9
X-Google-Smtp-Source: ABdhPJylUqG7PdDwj6HinmG82rymQeeRmMboPG01+2R63sr/3W81JeAWc73OmldOQwfdqpAs/GGwQw==
X-Received: by 2002:a63:4b4c:: with SMTP id k12mr21259895pgl.172.1632107347993;
        Sun, 19 Sep 2021 20:09:07 -0700 (PDT)
Received: from skynet-linux.local ([106.201.127.154])
        by smtp.googlemail.com with ESMTPSA id l11sm16295065pjg.22.2021.09.19.20.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Sep 2021 20:09:07 -0700 (PDT)
From:   Sireesh Kodali <sireeshkodali1@gmail.com>
To:     phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     Vladimir Lypak <vladimir.lypak@gmail.com>,
        Sireesh Kodali <sireeshkodali1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC PATCH 06/17] net: ipa: Add timeout for ipa_cmd_pipeline_clear_wait
Date:   Mon, 20 Sep 2021 08:38:00 +0530
Message-Id: <20210920030811.57273-7-sireeshkodali1@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920030811.57273-1-sireeshkodali1@gmail.com>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Lypak <vladimir.lypak@gmail.com>

Sometimes the pipeline clear fails, and when it does, having a hang in
kernel is ugly. The timeout gives us a nice error message. Note that
this shouldn't actually hang, ever. It only hangs if there is a mistake
in the config, and the timeout is only useful when debugging.

Signed-off-by: Vladimir Lypak <vladimir.lypak@gmail.com>
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
---
 drivers/net/ipa/ipa_cmd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 3db9e94e484f..0bdbc331fa78 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -658,7 +658,10 @@ u32 ipa_cmd_pipeline_clear_count(void)
 
 void ipa_cmd_pipeline_clear_wait(struct ipa *ipa)
 {
-	wait_for_completion(&ipa->completion);
+	unsigned long timeout_jiffies = msecs_to_jiffies(1000);
+
+	if (!wait_for_completion_timeout(&ipa->completion, timeout_jiffies))
+		dev_err(&ipa->pdev->dev, "%s time out\n", __func__);
 }
 
 void ipa_cmd_pipeline_clear(struct ipa *ipa)
-- 
2.33.0

