Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2438A1F16F4
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 12:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgFHKuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 06:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729310AbgFHKuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 06:50:08 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609F2C08C5C3;
        Mon,  8 Jun 2020 03:50:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id v24so6506231plo.6;
        Mon, 08 Jun 2020 03:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NUd8A6vcpiLm3Fha7fxltwZ2oWSxMEZrVjYYnaHST5Y=;
        b=Z47IlzAy8zUjnEOmvVwz/YjfhEhWL91Yty/f2I8YlXBpa88Q9oEo+qUmfD2rOIyjHA
         Ic8GrMABy2ZHgEDQYvbsuvhPAPSIxJhZl54mSgRNKDfyRl6JM6Q0CVlxj72AGkI/98e2
         nyiCuGUoF/WzHuflKDJzqZvLo2voqVnPddWShFehzuozeoMQT469uSBfIBL1Z/qmBDq1
         502TJt38bK04jHKBDXxxB1l/B9FJqNyWpgV3WRfnqCFkvQxxPlLMRNjz6WOiOHFBrfpi
         XXk53WW/4tpodJ5V/HOUb3EK+A1Zogleq3HgkviRzNctMpQLzFpYdCj+muiZCYpAs1ib
         OtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NUd8A6vcpiLm3Fha7fxltwZ2oWSxMEZrVjYYnaHST5Y=;
        b=cXICLmUt+JS60xwZlOVvgcwqrnVAWNvS6dHSZdj18/K1LOHWq53CMrqmcKzmHmh16G
         kZAn5azZaPfVON2Aj5IlEq7g0d+kz14ohm4I5SlPhKTiYzJb6t4qzP6N6g/9Xd7FLoUW
         W/P/kR7T5RuBSZ3hds9hIAFAKtC1w+/V6NmkNi5v6u5SEV08a1PuPsowKLWsbkmHYcAh
         8EK6s/bKPzUZLysJWGkaQ6GyhDBY2J5pCFAWoqUBisVrl588pm0XTKWoqglm0YI0sI9N
         /diXRyqrzgfSad8T02HzmotnSjK4Yt0rKkXFZEae0RifIGXT55cEZGPrt44snNrcTyh2
         LgOw==
X-Gm-Message-State: AOAM531kgyxilpYluyoP7DZ5hXkl48xUhnhfJXe1HAYiXIwK1TVr4Gke
        jd9Z/ziHO9dVGzK0J2X3H1A=
X-Google-Smtp-Source: ABdhPJwH25TOm/mEYVKU6qSJi3ieHiz8AkVsZWZ9rifRyIACYvlgRiNZn2C0Ix/YWTzb6vK6cwW2LA==
X-Received: by 2002:a17:90a:2686:: with SMTP id m6mr16696003pje.11.1591613407856;
        Mon, 08 Jun 2020 03:50:07 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id 145sm7043277pfa.53.2020.06.08.03.50.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2020 03:50:06 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] mptcp: bugfix for RM_ADDR option parsing
Date:   Mon,  8 Jun 2020 18:47:54 +0800
Message-Id: <5ec9759a19d4eba5f7f9006354da2cfeb39fa839.1591612830.git.geliangtang@gmail.com>
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

Fixes: 3df523ab582c ("mptcp: Add ADD_ADDR handling")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 Changes in v2:
  - Add "-net" subject and "Fixes" tag as Matt suggested.
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

