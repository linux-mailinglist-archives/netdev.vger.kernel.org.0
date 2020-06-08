Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E391F13F0
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 09:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgFHHu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 03:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbgFHHu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 03:50:27 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E12BC08C5C3;
        Mon,  8 Jun 2020 00:50:27 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g12so6331498pll.10;
        Mon, 08 Jun 2020 00:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2SDRj47TIcQ+035B16btGw9JgX2PM2llyh7Bt5PSkAc=;
        b=DUE6CJCsfV5lsZLqnhTbnZDKE9RBia8ts1BhzxXxhw+a1UkiUPXZLy19H2pR94RUcM
         uG+MVQZLRf2EX32EG2f9SpPw1zV2ry00QqqBwZVgyOh0Bs7+yoXr5X2rMF29tVx5YcOT
         qsMSkjdtQ8WlrtoUHesigIw1z0369tx3DAO926ePhki++fENTKzkoif4UGS8InZpGkOV
         QyiiiXl+o/u64Te+wUdR3lAC4k2Bsqn5AXhjlaS9WyPwYWXrNl7Q8dlxOnlQESFU+6nE
         1sxO8drQ2hArhsPukiRAAQyTXzyAZrhebRKvf2fNqGV0HgF1zD44/vpK3xE5BVwKXeB1
         eHYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2SDRj47TIcQ+035B16btGw9JgX2PM2llyh7Bt5PSkAc=;
        b=dxvFtjJGHKB37wnaCVsxXXLtsVjfBM5a4WovFb+f0keND8GexsalAqR1V27CljnEm5
         ol9Q1NXwfO0W60PHWXVXvLvjFDBKse/mLzaOSKWymUgqLrSDhn81srjtSbux2ysvgjPF
         pqlOEcRw9wV0Puqx/lFDXeOZH/16bIqyy79IkVtqneB4xDsy1UGgfpKhT6cwNAED+Ca9
         mHnyFo2PESsU67+AqFtjl6SmTnZ5eQnmbh5QmLo08H0yt9kIHbZiDUl61Q/PTIyKUQrn
         GpUpqZVzCs+R0LxFKaLY9pPZGh35482aKYuL4n02FWVuZUS6RvEr6g4801LXUzM0uA19
         h1xQ==
X-Gm-Message-State: AOAM533poA8atKAvOEyY+hEt25xR7On6ngzlsZgSEnmFS6pKe4BohbcO
        8hUYq2DxiCpkE51cuJMysjY=
X-Google-Smtp-Source: ABdhPJytUiIPyg5kOU+0HRELBYRudcnNwniblNnTPkhtuxqfHCsX+FHVu0AiRGI0AYx7rp6tgJL8Tw==
X-Received: by 2002:a17:902:7297:: with SMTP id d23mr2919873pll.35.1591602626706;
        Mon, 08 Jun 2020 00:50:26 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id c9sm5698333pfr.72.2020.06.08.00.50.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2020 00:50:25 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mptcp: bugfix for RM_ADDR option parsing
Date:   Mon,  8 Jun 2020 15:48:10 +0800
Message-Id: <904e4ae90b94d679d9877d3c48bd277cb9b39f5f.1591601587.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In MPTCPOPT_RM_ADDR option parsing, the pointer "ptr" pointed to the
"Subtype" octet, the pointer "ptr+1" pointed to the "Address ID" octet:

  +-------+-------+---------------+
  |Subtype|(resvd)|   Address ID  |
  +-------+-------+---------------+
  |               |
 ptr            ptr+1

We should set mp_opt->rm_id to the value of "ptr+1", not "ptr". This patch
will fix this bug.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 01f1f4cf4902..490b92534afc 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -273,6 +273,8 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		if (opsize != TCPOLEN_MPTCP_RM_ADDR_BASE)
 			break;
 
+		ptr++;
+
 		mp_opt->rm_addr = 1;
 		mp_opt->rm_id = *ptr++;
 		pr_debug("RM_ADDR: id=%d", mp_opt->rm_id);
-- 
2.17.1

