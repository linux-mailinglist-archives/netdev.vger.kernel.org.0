Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1691A3D805A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhG0VBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbhG0VAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:00:37 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9237FC0619DF
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n10so8216plf.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ZANtB/5paOTL9rrQ/OEPNR1JGy+0L6nD4QX9CL0F7k=;
        b=mvsqmz2pOJhJ9OaX3L4K7kVGDAStkUtWNLy5iZu/K7AftRRNcUovN+y+miaZbg89tO
         Uthw8swwf1XqEL18bb1TQESLDee214WGoNCauwBep7bAKX+Je3IIRQ3judpMqtgucXOA
         K1pL1usRDZBmpoaR3SWjPg28m7oIJmlVwMC7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ZANtB/5paOTL9rrQ/OEPNR1JGy+0L6nD4QX9CL0F7k=;
        b=qJxEISjcS71F67JSTO8EBKOap+rwvnETLKeGwbhqD6nQl7Rj4wtcArWTwY8wBjAOU6
         ywO9a6amfQ+HKpDo2fpeSRKfn0yPRqTDW/yFmDhBbkTI2OakdhaaExDAH8q6sGkVGvRf
         9SQf57UUACbp3CgaFQxBpC1JQAlHhsShMQWMj+j3ddhLArN0Ah3P50LwLgRE1C8jtmC5
         SwfRlO0VsSnyg+oxGEw8iw5V3gtPNcmFkLdftFT6x4vE/z/ELq5ifzNbYKpsrZUPKLLF
         IaZ4DjoXaGEejcylPaipwjba5FUy6bSXvQ+GmiW9NtsKG/kYa3ATMfD1Q+JrcYe7vWmK
         AlyA==
X-Gm-Message-State: AOAM5306/heKmhIErWxMYYpNQ7dPmLIDR6NAc202RcszuM1y3J3Ca58b
        T/yCJeGN5qO5d8T+LJtqVln1NQ==
X-Google-Smtp-Source: ABdhPJyN+3oVzlz/x2hymJ7L4QZLicuTyBl7Z4sZvtU0JhXwk/ln4AMFcNTkrea6rrnY7PtxDktjSw==
X-Received: by 2002:a17:90a:d251:: with SMTP id o17mr1322871pjw.200.1627419555206;
        Tue, 27 Jul 2021 13:59:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o134sm4623683pfg.62.2021.07.27.13.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 47/64] btrfs: Use memset_after() to clear end of struct
Date:   Tue, 27 Jul 2021 13:58:38 -0700
Message-Id: <20210727205855.411487-48-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=992; h=from:subject; bh=x7ocbS42SjohNmNf+jZzB+Ex+GPw48UesaUcGwh3RlU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOKwywaxTW0OzsQGL01qHorKOsTwNUavfO4aV7/ 4MvZRoyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzigAKCRCJcvTf3G3AJjfPD/ 4mFAUDF6T1seKtO/RA+qdlnriVg5ZRjAEH4H/h8DVsqaNsbNjkXXBxy4IGulp+GUR4SdYtq0qxTEGi dzjW0oiJ4wsB27VOGaHIXnH3D72eToay+7FKJsbTmxYF7qq7gMrBtZQ1lKPJOINEfDXC/GPs4PjHFt erSiS4lXcv7ZSR327qucJFy3X6rUI1vW/mu4I34D4vBVDPz7h/U/kTrFIpqQYU5qc8uY/8yajU/JNs mQ1m36vmx9AipRbk9NySHUPM6/19rIlM3mPS80ucsisVgDP46b0pgtm7X6nxCi9z/OaNCqCtQ+53mA 0TEThqquZzBXubfk3PRoVuwATx/orxB1j62Wns1xX49CmkH6puRyfHwmBSmk7CiM4Sk1wpqm9jnpGt 4DEdfYKvvTV5Mz5v4rooDk17qFI5QfRMISRbIJsWf42ioVfoojhOqA1vWlKc/ndypF47wowasPUGyj OXB4t+t9iIqUUqNtvyQSbgC16g4aG2X6ikTW6WjRC9vOt7wyZSNVoZoXQPD/ZmSRZZpvbQKkN2G4yN Vjn4IFYhXwNdyA0oK5yI/r1Q+WXeC+pvl6zO/L8B/K6xmBwrE0dWZNELGC+dpZM2lHGRXavr/S7tV7 OmHAQOFKQhK7/G9WgHJLShkAumxIBKLFh22qDqffVoP8zhUM+GH0rhbl7Mpw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Use memset_after() so memset() doesn't get confused about writing
beyond the destination member that is intended to be the starting point
of zeroing through the end of the struct.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/btrfs/root-tree.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 702dc5441f03..ec9e78f65fca 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -39,10 +39,7 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 		need_reset = 1;
 	}
 	if (need_reset) {
-		memset(&item->generation_v2, 0,
-			sizeof(*item) - offsetof(struct btrfs_root_item,
-					generation_v2));
-
+		memset_after(item, 0, level);
 		generate_random_guid(item->uuid);
 	}
 }
-- 
2.30.2

