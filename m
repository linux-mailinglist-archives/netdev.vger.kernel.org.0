Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375A53A4935
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhFKTHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhFKTHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:07:40 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98150C0617AF
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:05:41 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k16so32221444ios.10
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/jVit4TfeNDu88eet7u+n4Bhl+hbIMEgmGetJirKXBQ=;
        b=SxAmQQBIRMHKhPLOsI0TqLLq2DVGGXb7zMz+g+RrSjMc//413L1V+JpSoaQ/alwqWa
         DrSqkgWxpMIeRHuMC4lyPxYGMe3uRp4z7MVjGml+KRKsPbSkABSKMY59UbM5rxndMsEB
         ZBmxDau3E4HwPVYJsOYGAlAGh04dGGHhIx9AwoZKD5/kQuoFAUU3U+ZYGq8ELsgQ2Ctc
         1kdg+K/GbQBJnbQ0vy5PSCX/kKB2CsEn4hGR+qGTJcn9zqxVjLlLaSII4WVSNuh67Ue1
         J4gIqJQ20udivZRb+ZrudwvAAUajgd9vAaZF961u+O3fmv71RZlzFFKW4zcuxXKTGu24
         6A+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/jVit4TfeNDu88eet7u+n4Bhl+hbIMEgmGetJirKXBQ=;
        b=jt8QbavDDbUfePfP4LqHpodrbJj6WimqTn1XIN6yflsWCfTYO0hCAlJdHgeHgxwmvm
         08L/wI91eqqOfZxsBqMfPzsBxWpgrbSl+jZJkjAyFHBpvLxMe7kFXmRYBIYKICl8CbmR
         +SUFLtnCW7cAFE6KZxaIb7fbSLcWcIFRMSox87rTrtgNAHfcyUPp95HXKvX0JZ4dxWUG
         mowIS82P082g6tfBAOkzCDdx9WN2SNh0/rdBIiKht/dl5FIrfluSOHWW7TXghLWomcql
         jvkg9NDV+FyIxfmDmNxos/0XpG/aHzoNjBNUJM+yqn4eIHksadkySyu59HDiOLKs15IV
         BI3A==
X-Gm-Message-State: AOAM531hg5+XnzLzZqrMMpGPRbS2PdALAwdB5wn6sZJj4SnbuEeHZ7SO
        J6uii2pX1jVS2NOZ1yT7rfKXSQ==
X-Google-Smtp-Source: ABdhPJxMlAhzYa6xOdzTfJTi6eVbpuXeuwR4Vg3FOloJ8w7B27TweMRnABSzT1+dJdiijhWAdQsPHw==
X-Received: by 2002:a6b:d115:: with SMTP id l21mr4395513iob.130.1623438341006;
        Fri, 11 Jun 2021 12:05:41 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] net: qualcomm: rmnet: avoid unnecessary byte-swapping
Date:   Fri, 11 Jun 2021 14:05:28 -0500
Message-Id: <20210611190529.3085813-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611190529.3085813-1-elder@linaro.org>
References: <20210611190529.3085813-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Internet checksums are used for IPv4 header checksum, as well as TCP
segment and UDP datagram checksums.  Such a checksum represents the
negated sum of adjacent pairs of bytes, using ones' complement
arithmetic.

One property of the Internet checkum is byte order independence [1].
Specifically, the sum of byte-swapped pairs is equal to the result
of byte swapping the sum of those same pairs when not byte-swapped.

So for example if a, b, c, d, y, and z are hexadecimal digits, and
PLUS represents ones' complement addition:
    If:		ab PLUS cd = yz
    Then:	ba PLUS dc = zy

For this reason, there is no need to swap the order of bytes in the
checksum value held in a message header, nor the one in the QMAPv4
trailer, in order to operate on them.

In other words, we can determine whether the hardware-computed
checksum matches the one in the message header without any byte
swaps.

(This patch leaves in place all existing type casts.)

[1] https://tools.ietf.org/html/rfc1071

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 4f93355e9a93a..39f198d7595bd 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -78,15 +78,15 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 	 * trailer checksum.  Therefore the checksum in the trailer is
 	 * just the checksum computed over the IP payload.
 	 */
-	ip_payload_csum = (__force __sum16)~ntohs(csum_trailer->csum_value);
+	ip_payload_csum = (__force __sum16)~csum_trailer->csum_value;
 
 	pseudo_csum = ~csum_tcpudp_magic(ip4h->saddr, ip4h->daddr,
 					 ntohs(ip4h->tot_len) - ip4h->ihl * 4,
 					 ip4h->protocol, 0);
-	addend = (__force __be16)ntohs((__force __be16)pseudo_csum);
+	addend = (__force __be16)pseudo_csum;
 	pseudo_csum = csum16_add(ip_payload_csum, addend);
 
-	addend = (__force __be16)ntohs((__force __be16)*csum_field);
+	addend = (__force __be16)*csum_field;
 	csum_temp = ~csum16_sub(pseudo_csum, addend);
 	csum_value_final = (__force u16)csum_temp;
 
@@ -105,7 +105,7 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 		}
 	}
 
-	if (csum_value_final == ntohs((__force __be16)*csum_field)) {
+	if (csum_value_final == (__force u16)*csum_field) {
 		priv->stats.csum_ok++;
 		return 0;
 	} else {
-- 
2.27.0

