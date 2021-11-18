Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEE945642F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhKRUdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhKRUdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 15:33:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A73C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:30:21 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id d64so4444691pgc.7
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 12:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iu7U35TLsSX6gA69t+3VJK/DHYP3v2WkEHmDvw5qjGo=;
        b=Oz7anz2rJ42T1oV7T6o4alhUei5UNKjjSsAWaqFKjILKgCjFAH98uxcKIZdojsylA7
         oP/HbD1DOieg9KPfQJwuLLZVc6/AOgmPMKDb/+75mfJcaKTYnMjvEpV9+NnJMrxUEViK
         yYFc4VkMLlkmexi5tcLNOXGS4624S9oJiWjic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iu7U35TLsSX6gA69t+3VJK/DHYP3v2WkEHmDvw5qjGo=;
        b=o+0Ykr/US/R2LyibTXELBI2191rHTC9/N9m40L9DA4VY/T6zpNCBdNfHa3MmKU8NxF
         yjWMTLIw2V0ATxMouw2EyAzAJbV1TL4+F4dC0vY/XFp+E1yHnC8oZ4b9f395X5sUKM8S
         hptKlb3V6JOS2EPnQuN5ErZrGO4LrG7ZfsvwV7bvuuRN2DDtzL2ltAD5gUlzvlQGUHEI
         pUBo2I09ntivSEJ3r8MqkNceFCNFMn7lvJsE8hJIw7GAaAmyHtMiLzKTWzonkJEQ5ZqN
         ghIdN7vwLL7d+EfoJ0StqBMJr3AHxR4myEUzAqyc146fu/gS3xWDjENcjVrPTqlwt9/t
         AS/A==
X-Gm-Message-State: AOAM530yCCQoQIFEVYIB4TSqRy9jb2rK2/v274yshaQRhbN93YLlqFMt
        SpP9vKohfg1x7x8s5Xt8dItSyA==
X-Google-Smtp-Source: ABdhPJwBLwTMtsGbZvSVYwVsbT0lUiJKofe81XSZqHxg2FZ1ltbh91iXmFOSVysPaoKl6EDYkRyM6A==
X-Received: by 2002:a05:6a00:13a4:b0:49f:add2:3c83 with SMTP id t36-20020a056a0013a400b0049fadd23c83mr17283853pfg.28.1637267421227;
        Thu, 18 Nov 2021 12:30:21 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id oc10sm9932941pjb.26.2021.11.18.12.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 12:30:20 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net: dccp: Use memset_startat() for TP zeroing
Date:   Thu, 18 Nov 2021 12:30:19 -0800
Message-Id: <20211118203019.1286474-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=956; h=from:subject; bh=tL6Zd8mHif0zgpnxOE5SiGN4U+GuNNxpaAv5++LURlc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlrfakwyr07L6bDqrWWfqR7Vt6SJluCb6DznklYrj I8TnpuSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZa32gAKCRCJcvTf3G3AJosXD/ 9ooZFwhPpDQbbhdeEOYfd9RUIBmboebLiEgB0L/dTPwju5kUUPaFL9JLkQbEacliDC0bi8F+sj/UHD Dcnud5ljv5lgexma98YxJnna1UfFtrIXCs+X22Zlz1bMQlVDk0FC+bpFFCwXqn/epchgEFxJYLp6Yu HU4ptDP/pXVzpzhT2zgRqPadCLanixeoquzAR9mz4sKpN5bF5SCy1sZe77xzbYVHH1uXPkQ5OSL9DY VJBiFIbzgTAuuJMyO712Qq1HjnWgPSm8wXAOudC9ebdVhtE5MQ0plUTjivdNAsFWtR6jFZj8SzAD/X r1BZeO8mPiSCeCzSagoyy+dbdmjG5atshC/brAuGi0+FliQrvXGGl9EiW3I4kqGRQrH96H2uXRewNA MOtFkZuMQyv2WsQsQxJ/WQwqAXM29m2Zc7q+w/tPZZjSgyKWiKsXHauQhTuQteybHWJEl7qUxBNJHd O52k6Y+vM/Wr6oFwAnrjDmh6MxIoK5uHpFu9U7zUB2GNXKPL7v8mz0Vb7I16T9sZYOSj+Up4T+uxxe sRH4lVwTyvbwyCWtTSleibIirJXToi74NqY6p6LvQUjJjDhrlBp/Mt7knFs3MAdpFYJBgLySAzt+to F/vkn6qiuDeem6sqtYNJ4+Krf2pJ6tHaZWsWjpzq8Ah0Z8wL8u2m/DTlya2Q==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_startat() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/dccp/trace.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dccp/trace.h b/net/dccp/trace.h
index 5062421beee9..5a43b3508c7f 100644
--- a/net/dccp/trace.h
+++ b/net/dccp/trace.h
@@ -60,9 +60,7 @@ TRACE_EVENT(dccp_probe,
 			__entry->tx_t_ipi = hc->tx_t_ipi;
 		} else {
 			__entry->tx_s = 0;
-			memset(&__entry->tx_rtt, 0, (void *)&__entry->tx_t_ipi -
-			       (void *)&__entry->tx_rtt +
-			       sizeof(__entry->tx_t_ipi));
+			memset_startat(__entry, 0, tx_rtt);
 		}
 	),
 
-- 
2.30.2

