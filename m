Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5062272C5
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfEVXNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:13:10 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43797 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEVXNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:13:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn7so1764906plb.10
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BnfH7ykn0YKnII4PtBfe+J9O1Tc7yEGe3nwprRsNhl0=;
        b=NU9pHyB8wmbyaHDM69mjSXZuU/BgmDhJHQ5lJMuU+APpKL30O8Rj2xBwBpt/5O9iGz
         BuvCPzRis7pP+qTVNbIVegblLyLLc76tehfdgnutIh8BC9VmMf1U1wRazdaeD6zZLMIS
         1g7huo7/2CYdTvZxM6TBNFh38WlTUpDvEqcf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BnfH7ykn0YKnII4PtBfe+J9O1Tc7yEGe3nwprRsNhl0=;
        b=OK4EUtInPEBD0UszUY0HMuj6CxCpKvbC4BoQhStXqKYb9hxR6nfShC5AceU3+4k3c4
         O8dKXqiFlCmLfmyYvE2CJx4EOMdesogzBAuEFUsnLFhe4UUJWOKXSjnLBoAadOf20QXu
         bj2lYwGOWuH6KQchySpayG4fwREB5kGoHqtIhWPyCuiLp9hwoZvyrU5K1ZjsARB0MhHj
         yMhAy3ilxL1jZ/mw7KDQNT0SIrExDWGFJIRyASbStAvxkstAOY9WoZpp4iRLqU8pz3lL
         xvIXAoAt55XAvKOJ6qsAVKwWb5Wv/3qT86BADZ+++gOpcI+VwEiOZVt3WuMzer2tQxD2
         Ht8Q==
X-Gm-Message-State: APjAAAXKyuq3T/d1CRmpjj2sFTu2ExdSOJNPa6Mze2F9QWo0VYygcCLj
        rz28gCHWzhpT3rZ3DP/7AgNz+g==
X-Google-Smtp-Source: APXvYqw2kFiDME1B3GV4SUyOb9UacxaBjiR9SmBJwLa1WKNu9xtLVKsEhpJfg+Cs+2dciI5LCaarzQ==
X-Received: by 2002:a17:902:c85:: with SMTP id 5mr19409625plt.172.1558566789235;
        Wed, 22 May 2019 16:13:09 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q20sm27750419pgq.66.2019.05.22.16.13.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 16:13:08 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/4] bnxt_en: Fix aggregation buffer leak under OOM condition.
Date:   Wed, 22 May 2019 19:12:54 -0400
Message-Id: <1558566777-23429-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
References: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For every RX packet, the driver replenishes all buffers used for that
packet and puts them back into the RX ring and RX aggregation ring.
In one code path where the RX packet has one RX buffer and one or more
aggregation buffers, we missed recycling the aggregation buffer(s) if
we are unable to allocate a new SKB buffer.  This leads to the
aggregation ring slowly running out of buffers over time.  Fix it
by properly recycling the aggregation buffers.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Reported-by: Rakesh Hemnani <rhemnani@fb.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8314c00..21f6826 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1642,6 +1642,8 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, dma_addr);
 		bnxt_reuse_rx_data(rxr, cons, data);
 		if (!skb) {
+			if (agg_bufs)
+				bnxt_reuse_rx_agg_bufs(cpr, cp_cons, agg_bufs);
 			rc = -ENOMEM;
 			goto next_rx;
 		}
-- 
2.5.1

