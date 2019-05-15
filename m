Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3846C1E9B9
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 10:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfEOIDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 04:03:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34369 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 04:03:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id n19so961214pfa.1
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 01:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6hYdHjehFwjl6mT9hBF4ilJjlsMNZyT9XZ7cYC35dJw=;
        b=aEJD8XWILIgnqy4M/ppXSt3oDB9L0XAkr4TDl+ozD/tSwJAC68wv0r8ZLh+ZMLhSDU
         bANSxJi5TwoSXjPwai4p6RcHwoWF5FjmFx1k3jcHRAnacMbGK25PmEqrPwglSj4kgApD
         jiix4UxfWHXBLoXQmQQaxbAjjJj3/+RJgosVixZfLNPK16tjvmw+o8ikBnwKhjLVsDB1
         WDPS4AkJQ8dDSFKgw9HanaC8IYzcvFgYE5Y+uLuzf5e6TjsIQUF60lOF9Fpg3fMIb4+n
         zuWnOvMNn56Kt44XBUqJ/Bw14kuxuk9w8wjvT4MabPZr71HOO87fVbfpxdgno5CtvBq3
         5s6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6hYdHjehFwjl6mT9hBF4ilJjlsMNZyT9XZ7cYC35dJw=;
        b=O6EGkzmolbpuu1bp6ZOMGaHsXFGsql6BTi8glpROxVgubsjxYa7Uj0PO6Ev+GvTbje
         vscGVzCNKE45CewiRXxtkWnf8ib35MyoqigDRUuqPW8W/5jvPqms6U2W8M4H8lH7Tjbo
         41AyYrhd+uWOZN0H/jroBvhdrsjchUUMb8qOrYeJgajno6Cl9FhU7Tzyd6oAbWggxLba
         4vEld5U9DiCtJnnTJXSFsz+eC/Iq7+19bBHLiI3yMDpdhlhy1Ssb5/FP7Vs4NKRlkPQL
         kr64lkhrKGouvg6J5LhL+NXWehlByeq1irPo0Wuok+BpW3g1Jq7XgKVJD9hY5gx67gW7
         1FQg==
X-Gm-Message-State: APjAAAWU1SmKLuC4R44h78rh/pOJXxOa+IG7p5X0O44za1D61X50PaUp
        vkzdKEBrd90zLAIkzacJWXJIEQ==
X-Google-Smtp-Source: APXvYqwjvqJGo9u3Dw8W9IZiQ7+T4X8MwEUDsmzOL60+gD3ZVoNm1xMKnX25jp0Xq2Hg0RN/BPjLDA==
X-Received: by 2002:aa7:8d98:: with SMTP id i24mr46239548pfr.8.1557907408709;
        Wed, 15 May 2019 01:03:28 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 37sm3104572pgn.21.2019.05.15.01.03.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 01:03:27 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: [RFC 2/2] netvsc: unshare skb in VF rx handler
Date:   Wed, 15 May 2019 01:03:19 -0700
Message-Id: <20190515080319.15514-3-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190515080319.15514-1-sthemmin@microsoft.com>
References: <20190515080319.15514-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netvsc VF skb handler should make sure that skb is not
shared. Similar logic already exists in bonding and team device
drivers.

This does not happen in practice because the mlx device
driver does not return shared skb's.

Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index bb0fc1869bde..eb666908b0fa 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2001,6 +2001,12 @@ static rx_handler_result_t netvsc_vf_handle_frame(struct sk_buff **pskb)
 		 = this_cpu_ptr(ndev_ctx->vf_stats);
 	struct bpf_prog *xdp_prog;
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return RX_HANDLER_CONSUMED;
+
+	*pskb = skb;
+
 	skb->dev = ndev;
 
 	xdp_prog = rcu_dereference(ndev->xdp_prog);
-- 
2.20.1

