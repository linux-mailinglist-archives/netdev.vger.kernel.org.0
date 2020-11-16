Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9E02B4E5A
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388034AbgKPRpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387773AbgKPRo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:44:59 -0500
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A984CC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 09:44:59 -0800 (PST)
Received: by mail-ua1-x943.google.com with SMTP id h26so5607945uan.10
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 09:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WZQz2b5v/sf6FchNy6tKc9e7B0GkUbrM/P4Jgv59+zg=;
        b=qBJBryxDNFcXCMyykmk+gXb4EjKZyjXQy7D6gluwUEUPXGCNWlFB4Mmj1lwqsJRD67
         vCKznDVcaNbHUFmec2Eb0wBbb4Qx36xcinm43Obm860Hb1FgfMhrSewuLOfyCpsdPg8/
         81AVS9zVyUaWkqa7vzdqp2dBsmqTLnbcI53q+mIRvC9l8O36VdWzwAD/lKTpAjKg+bca
         IZ0jpJfPREKZGg3M4w8a31dRgi3rXsGZkDHc+mf8TI+QPWduqt5AKOJ8CD3Zifa/UklF
         Oe9G68y+u1i4edSgaRCNsMjq8M8WsreJ2nE8joYJ2cwS4psmqAlBtGLm1oKrupAv60v6
         VvNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WZQz2b5v/sf6FchNy6tKc9e7B0GkUbrM/P4Jgv59+zg=;
        b=hpJdaHCJSF3nZvF3UO3a/BNUZwfVNRrDZ8bLaNbE+qamTwG4sA9EF96/BgCosSXc3V
         2eDY2krNayhvEQwTY8axs0SHfJMapnt2jfHt4ef0fqriV0D9ahGWqH9jhJDAUbaXHvcb
         Jj25dyVUS0H1HD6SDKv1Zk3bnZHmFwtQdI2Jz5GOU/V/UAYxl25H3hB6LOA7Z80dqRPZ
         Utck4DeVjfgr2VBOOnBvPRNIwhK6KFYipNXiiqJcHATUv8L5JZUglfZPNVGzr0k3ujZb
         hOpQqKZjwt/rEbgqSK9C8LP9WMgug7/Ki6sRl5F9MEg6ESnDL+ITD0WpoF1UqAqPNjkY
         y2cQ==
X-Gm-Message-State: AOAM5314WLNOY4M4IRmVwA1tShH0H+MWAyP2e/rd4qG39fLukIEtzCst
        E4mvUA1rWQyGL0MJafTPbUWtSjmWvp18jw==
X-Google-Smtp-Source: ABdhPJwhfa/i6TGc+5aZJkN9jMohK6fFypmMvW+YR2iGDvjTcdVXdjkIqJPzVAl08W2o+czJ2VIVPA==
X-Received: by 2002:ab0:3774:: with SMTP id o20mr6987481uat.67.1605548698919;
        Mon, 16 Nov 2020 09:44:58 -0800 (PST)
Received: from sharpelletti.c.googlers.com.com (182.71.196.35.bc.googleusercontent.com. [35.196.71.182])
        by smtp.gmail.com with ESMTPSA id w128sm2226403vka.30.2020.11.16.09.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 09:44:58 -0800 (PST)
From:   Ryan Sharpelletti <sharpelletti.kdev@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Ryan Sharpelletti <sharpelletti@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: [PATCH net] tcp: only postpone PROBE_RTT if RTT is < current min_rtt estimate
Date:   Mon, 16 Nov 2020 17:44:13 +0000
Message-Id: <20201116174412.1433277-1-sharpelletti.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryan Sharpelletti <sharpelletti@google.com>

During loss recovery, retransmitted packets are forced to use TCP
timestamps to calculate the RTT samples, which have a millisecond
granularity. BBR is designed using a microsecond granularity. As a
result, multiple RTT samples could be truncated to the same RTT value
during loss recovery. This is problematic, as BBR will not enter
PROBE_RTT if the RTT sample is <= the current min_rtt sample, meaning
that if there are persistent losses, PROBE_RTT will constantly be
pushed off and potentially never re-entered. This patch makes sure
that BBR enters PROBE_RTT by checking if RTT sample is < the current
min_rtt sample, rather than <=.

The Netflix transport/TCP team discovered this bug in the Linux TCP
BBR code during lab tests.

Fixes: 0f8782ea1497 ("tcp_bbr: add BBR congestion control")
Signed-off-by: Ryan Sharpelletti <sharpelletti@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
---
 net/ipv4/tcp_bbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index 6c4d79baff26..6ea3dc2e4219 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -945,7 +945,7 @@ static void bbr_update_min_rtt(struct sock *sk, const struct rate_sample *rs)
 	filter_expired = after(tcp_jiffies32,
 			       bbr->min_rtt_stamp + bbr_min_rtt_win_sec * HZ);
 	if (rs->rtt_us >= 0 &&
-	    (rs->rtt_us <= bbr->min_rtt_us ||
+	    (rs->rtt_us < bbr->min_rtt_us ||
 	     (filter_expired && !rs->is_ack_delayed))) {
 		bbr->min_rtt_us = rs->rtt_us;
 		bbr->min_rtt_stamp = tcp_jiffies32;
-- 
2.29.2.299.gdc1121823c-goog

