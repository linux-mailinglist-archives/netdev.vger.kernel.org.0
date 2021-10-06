Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87505423609
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 04:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237290AbhJFCok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 22:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237292AbhJFCoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 22:44:22 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231AEC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 19:42:30 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d10-20020a621d0a000000b0044ca56b97f5so251309pfd.2
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 19:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KHghRzm+vDwpKNdyfewWzgu1PA842NWtY3+BlaiG7a4=;
        b=cqkzvJNI9Ix6bhIhMqjh5zcxwbBDRfeXTl51q66U48L1z52CLFBVAk1MS+KEdEYYwK
         5xOypGaAFW9Rqhn66IbPIqrJkY5Fl2SfS/65l7Dm80EkySR1EgM6s2qOHI6e/fMKpiKF
         0ZDzXciVfFOQCUpeed2qQap4ITLyZIA9xe4miewG1YbQjXxAjBghjqKR5TMFRGtrG72f
         tuKvQz4ld1ddvIvX80MhxjK/f+uXrWwB5awbqrZ3ZdlbomDW3NlQCOVz1/PJZgzHLWAe
         5/sM5xbGbQMJTYf06fgUbu1NlMHS4tyPuLPbUeHSgQtzNnMtmc79pd8wjG97Ro37/k9K
         eOaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KHghRzm+vDwpKNdyfewWzgu1PA842NWtY3+BlaiG7a4=;
        b=IlAwqLEazpBPya733Pl0KxYxM0DK5JlRdzA2rInZbBn24C072yipYoI2X6gaEp1EG1
         MGj5hl+P0ZxEgF2fUePdRkxscRS9YZUk+QEHkjUQCpFesGSfBIHisOFvm7GYOSTYqGe3
         Cj5aLVMtkt0/37i6m1CAIPw6iTusGWzKNHS61rn4B+P2bON/OxHrXcAxhA/bjzoDHNVj
         fjpMyf0tdj2tYdwPcvXpkT2HERrkchKC7p7hC5WHmpfYFLwsqCuOKLLMEIRE1chEIaWI
         hlc38YxwEWH/5jYDPU0WU281r7WkFMDx5H8ntYffOgqQSqXY3GH3ESsVOJdfyVx73yDc
         CKpQ==
X-Gm-Message-State: AOAM532pmmfQ+z9N3qHq9oSr9XLYMLIHqPUyfmP68+gehSjLqyVA6M/U
        697AeWM5lwTfcYdZhZ9XW6J7l7snSAik3eEsBIT9bt/5GUSjZBZxvLPE76y9DxmHTjai76Ir+oQ
        lALZOVpzVX1CuMkBStJxfhB57k0cu1S/7Pr9x0JNYoIZDWSvFLfGhIQKdh1WByxtwI2M=
X-Google-Smtp-Source: ABdhPJxwtbq09l756Bh3R0fDXmjMfs4oWNAgYIwl36AVFP9/3WyDv25dp6Tbt6M8+HrSaCdFLMVe8+RNIAShsg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:6a19:24ee:a05:add5])
 (user=jeroendb job=sendgmr) by 2002:a62:7bd5:0:b0:44c:72f5:5da4 with SMTP id
 w204-20020a627bd5000000b0044c72f55da4mr9992677pfc.48.1633488149400; Tue, 05
 Oct 2021 19:42:29 -0700 (PDT)
Date:   Tue,  5 Oct 2021 19:42:21 -0700
In-Reply-To: <20211006024221.1301628-1-jeroendb@google.com>
Message-Id: <20211006024221.1301628-3-jeroendb@google.com>
Mime-Version: 1.0
References: <20211006024221.1301628-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net v2 3/3] gve: Properly handle errors in gve_assign_qpl
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Ignored errors would result in crash.

Fixes: ede3fcf5ec67f ("gve: Add support for raw addressing to the rx path")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index bb8261368250..94941d4e4744 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -104,8 +104,14 @@ static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
 	if (!rx->data.page_info)
 		return -ENOMEM;
 
-	if (!rx->data.raw_addressing)
+	if (!rx->data.raw_addressing) {
 		rx->data.qpl = gve_assign_rx_qpl(priv);
+		if (!rx->data.qpl) {
+			kvfree(rx->data.page_info);
+			rx->data.page_info = NULL;
+			return -ENOMEM;
+		}
+	}
 	for (i = 0; i < slots; i++) {
 		if (!rx->data.raw_addressing) {
 			struct page *page = rx->data.qpl->pages[i];
-- 
2.33.0.800.g4c38ced690-goog

v2: Removed empty line between Fixes and other tags.
