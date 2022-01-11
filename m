Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E659148A6C1
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 05:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347756AbiAKEVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 23:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbiAKEVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 23:21:12 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F70C06173F;
        Mon, 10 Jan 2022 20:21:12 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id p14so15264601plf.3;
        Mon, 10 Jan 2022 20:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UvMY/BpPHYLYCpXHLFkn3wGD0r030IMs3mS/Z9JjkxE=;
        b=B4huMDPf/I5XDFsWvuSzqemyC/KmP1kbRmHZg++C6oVqbp5JbmVAzQgwpvPHI2R75a
         eFndp8C17Wl5PflRaDCVZxWcEbqa5+6UBaNvURPDfheA6K3ribm3QBuU6IOQsF33gvfv
         CjqRwLCo8SxPYN+3PU9wnp1g8XQZT7e3InZz01HdorpXlY2u1ZmABwxOTI3afAnpZwat
         i9vhYGqNVJ8YqfUT5BX0bjwabLXthH/pG1n69kGxdrzJ/ttwuvaMK9HnkU1t1NJ+JTqA
         QeE/kZSdavrTfUBIMdC4YD/raQ0rjw+M3FbXDOLoz/5nwzR2M6KdOEqNP0tSb1lZ4ktK
         ruYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UvMY/BpPHYLYCpXHLFkn3wGD0r030IMs3mS/Z9JjkxE=;
        b=ggOt4VYDlempqy5eehPcGASosJwhweSa72POebmjpnIyhv7hdGsTf1JHaXur0FKupa
         usKmbzkQp0IjUxvHx89EHw3YeQtlJ3SnjU+OAYsv2JvDI8uCrPMOt3nte61LJNfHMsKq
         1u3LQ1kHsoPHhGpf7Y1B94bKMOwoE/pX3rIdCP6oiFJ9F7Kumjob+4fn8mdQOzxlmTsu
         6lkER4MZfMftBMCb1UmuME7/FWAuqHmMAgVWGyMG6Mw5FidVqNDW5FXo2+2oNm79QhgN
         oCdQc/OewoGWL6QAdTZ5AdcCiBAW1FpkckE1jq0r9kNCrgcaTcWXw3BhIZFDILejykYY
         xhsA==
X-Gm-Message-State: AOAM533bLX61WYnmX+brsh21D5NvtPR1hhi8fblInclWCjIGZ4ApBWvL
        fGbnRbLASgduwnuaHWwwnko=
X-Google-Smtp-Source: ABdhPJyDr6Fn1C47Iap8ZBIHs4/z1kc6JXdQiRuNiVOxnKKraI7K5S7M44p+tPjlcF0xZ5fXCGK7BA==
X-Received: by 2002:a17:902:6ac1:b0:149:7087:7b8a with SMTP id i1-20020a1709026ac100b0014970877b8amr2900110plt.174.1641874872357;
        Mon, 10 Jan 2022 20:21:12 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id f7sm1062943pfe.210.2022.01.10.20.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 20:21:12 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net] ax25: use after free in ax25_connect
Date:   Tue, 11 Jan 2022 12:20:48 +0800
Message-Id: <20220111042048.43532-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_to_ax25(sk) needs to be called after lock_sock(sk) to avoid UAF
caused by a race condition.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/ax25/af_ax25.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index cfca99e295b8..c5d62420a2a8 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1127,7 +1127,7 @@ static int __must_check ax25_connect(struct socket *sock,
 	struct sockaddr *uaddr, int addr_len, int flags)
 {
 	struct sock *sk = sock->sk;
-	ax25_cb *ax25 = sk_to_ax25(sk), *ax25t;
+	ax25_cb *ax25, *ax25t;
 	struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 *)uaddr;
 	ax25_digi *digi = NULL;
 	int ct = 0, err = 0;
@@ -1155,6 +1155,8 @@ static int __must_check ax25_connect(struct socket *sock,
 
 	lock_sock(sk);
 
+	ax25 = sk_to_ax25(sk);
+
 	/* deal with restarts */
 	if (sock->state == SS_CONNECTING) {
 		switch (sk->sk_state) {
-- 
2.25.1

