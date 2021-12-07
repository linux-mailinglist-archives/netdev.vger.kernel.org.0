Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A8B46B2F0
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 07:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbhLGGft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 01:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbhLGGfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 01:35:48 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA86C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 22:32:19 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso1808667pjb.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 22:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cods9WyaktA6BF6JbbixG/DZf7V5gCMolIBwnRIBsoA=;
        b=MMD41CtxbBzB9YAAnCbHieIqVxNNB7RXyBlaQGRrHSeyJzYxkZgp4SmWmDhqYNerxg
         MprUuKqQAdg87VjPx7xnn5SuRVIZ4iMi7flp+RPD7CksU6Va8ZAaqdNdm1cV5SSwSrLo
         tc/PwmOJa5JD+CExp35BTRQAXpR6U5Ek4JuVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cods9WyaktA6BF6JbbixG/DZf7V5gCMolIBwnRIBsoA=;
        b=3ynL1ry7rztprJFLGhPjZveD+tejKv1dTs8OdgnM4ReBTPZvHC3hRRshzc6QLdo48y
         On6n+TkKF8gHMFQgbQdZ35aD4iU5KQhdu9ujt46/2wBY552dOIHm8vMkNOA5tGDapTOd
         j8/CRp8QhNHxgFFlFBGX9qhyLHVxJhDjQJyVIng7CuuOWY5tRVhuJqs1o6cJe5hBQyue
         o/oM+rIW+eUMASnLbYxoPJ6DPuFcazhCcj8A41tMYdRtjCWSww4z00UwKkRQs2PD2MHR
         8lOc15Zpt2smx/oxxkhOdBb0p4xe7tLIiwkNEhyxm647wi+ggbR1nHK1L2TqeXrdZ6kW
         +8qQ==
X-Gm-Message-State: AOAM533Cthqs2jV2njdODvUtXFSl4JEaWozbxaZlcV9B+POO+sWcDbbQ
        E1QbawqM8brOd0bdaoQ33HOhsA==
X-Google-Smtp-Source: ABdhPJyp1UxglPEqmBhAA0mHlqJZn71XaypcbZcnECd4iiPFthtfrShdVlCTDQxxiafiXeZrE7GRMg==
X-Received: by 2002:a17:90b:17cc:: with SMTP id me12mr4322891pjb.179.1638858738693;
        Mon, 06 Dec 2021 22:32:18 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y6sm15487110pfi.154.2021.12.06.22.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 22:32:18 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "K. Y. Srinivasan" <kys@microsoft.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] hv_sock: Extract hvs_send_data() helper that takes only header
Date:   Mon,  6 Dec 2021 22:32:17 -0800
Message-Id: <20211207063217.2591451-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2572; h=from:subject; bh=48lY+W7yxU1t+Az6SdjP5/a959EClqgZo8+U7ONH7iw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhrv/woEdF1Rs69O+MuGiyQRAPdwunWIkJe1PXhimt WEGXogyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYa7/8AAKCRCJcvTf3G3AJoBLD/ 0ULE05fML+vI6+/LCIG9Ks4prnpoPtcUsW4eIvsa59c015zp36rvqreqIxD63DBa64rs8r4MgskEc9 WFVuih/7jWmW9P0kl6Wpb1qpRJxTTg85WPn53QptwU4zIbYVjo8u3om7OU8/ZSzD0oCDo7QRQDR8sq vu1hEZ6KZRPmdx0RguKp1+TgiUdYRDRRVcSAB977TwcutxZ3U1JNZy53y+ze3DanRCy5HW+qNFly9D ZyYFmUZxGcMNc+4v5B36dIKkRmJrHLZK5xrbUnrpxpCC/iXfR2DsJeHQVFrc7ejRYe0qjtSb2TWZlf 2Hondoefq+t1yBc0iL1SZBn8y/V9E6Qy0cWhF8zO89pX96X+hAZzEJKceL1hD/r1nNbfwlJl4I9t4F Cwu1o1EQSktmt/Cs2kUNx9HsTUiGBY3IaQ2EwDDiLHSJZRFCty/eOH7zKT1BDwNmIdUH0wytq+dma+ 1w+fUpV+dA3wpd+XqK/IgwIY5xKby/V+mUZVhz4GT+WQaRib/yeVFrVRdy3iue/rpBnsqq31xiXOdi WN3gjAK/DLqn0KCr9zObiXuiRdVbWoIVXXFsrbEOmiMZM+mC9VfVRNAIjxRfPhWoYSaEhsxfNjQViZ fPHEZ/ZDNNJ9EGqpcRzaJIuGKy++T3K+6nLXpcl7XsjqOZ7XQCiuvWaa0Wsw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building under -Warray-bounds, the compiler is especially
conservative when faced with casts from a smaller object to a larger
object. While this has found many real bugs, there are some cases that
are currently false positives (like here). With this as one of the last
few instances of the warning in the kernel before -Warray-bounds can be
enabled globally, rearrange the functions so that there is a header-only
version of hvs_send_data(). Silences this warning:

net/vmw_vsock/hyperv_transport.c: In function 'hvs_shutdown_lock_held.constprop':
net/vmw_vsock/hyperv_transport.c:231:32: warning: array subscript 'struct hvs_send_buf[0]' is partly outside array bounds of 'struct vmpipe_proto_header[1]' [-Warray-bounds]
  231 |         send_buf->hdr.pkt_type = 1;
      |         ~~~~~~~~~~~~~~~~~~~~~~~^~~
net/vmw_vsock/hyperv_transport.c:465:36: note: while referencing 'hdr'
  465 |         struct vmpipe_proto_header hdr;
      |                                    ^~~

This change results in no executable instruction differences.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/vmw_vsock/hyperv_transport.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 19189cf30a72..e111e13b6660 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -225,14 +225,20 @@ static size_t hvs_channel_writable_bytes(struct vmbus_channel *chan)
 	return round_down(ret, 8);
 }
 
+static int __hvs_send_data(struct vmbus_channel *chan,
+			   struct vmpipe_proto_header *hdr,
+			   size_t to_write)
+{
+	hdr->pkt_type = 1;
+	hdr->data_size = to_write;
+	return vmbus_sendpacket(chan, hdr, sizeof(*hdr) + to_write,
+				0, VM_PKT_DATA_INBAND, 0);
+}
+
 static int hvs_send_data(struct vmbus_channel *chan,
 			 struct hvs_send_buf *send_buf, size_t to_write)
 {
-	send_buf->hdr.pkt_type = 1;
-	send_buf->hdr.data_size = to_write;
-	return vmbus_sendpacket(chan, &send_buf->hdr,
-				sizeof(send_buf->hdr) + to_write,
-				0, VM_PKT_DATA_INBAND, 0);
+	return __hvs_send_data(chan, &send_buf->hdr, to_write);
 }
 
 static void hvs_channel_cb(void *ctx)
@@ -468,7 +474,7 @@ static void hvs_shutdown_lock_held(struct hvsock *hvs, int mode)
 		return;
 
 	/* It can't fail: see hvs_channel_writable_bytes(). */
-	(void)hvs_send_data(hvs->chan, (struct hvs_send_buf *)&hdr, 0);
+	(void)__hvs_send_data(hvs->chan, &hdr, 0);
 	hvs->fin_sent = true;
 }
 
-- 
2.30.2

