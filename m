Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB4C602849
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiJRJZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJRJZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:25:38 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC0C15A08
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:25:29 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h185so12787096pgc.10
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RqxmiGcyV/mYk+QnLNTvWwmJYpQlgvRrFVxVqfYig2w=;
        b=n5v+XaUqdK0+YZuXiM/XX3batect/k3rJvwMnNLANYSL1DpJ+RImp3kOJ5HqhKUyii
         ooP8NryD/OQXpkXZhU024WM8KNVYn0QQCY47VPI0TA1PHLyy+8pGcoL/5Qz4K4HhdxgJ
         crj+l/0hqMhq2l3cDfm6MR1V8ZCaeE5z3GI3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RqxmiGcyV/mYk+QnLNTvWwmJYpQlgvRrFVxVqfYig2w=;
        b=MTo7Rqb+/hAdZK1ETPXD1xrJv9lAUjHFNikTomxN5sa3yjn5RaMl55MuuASpz6+lz8
         FSeMFm1++JPFGJzXZl7QHLtFmI2f6rvw6Q/XzGJJIymZqxslVZunDvm3dQmqqp0fubUW
         lXu4ATW1kvTMD3GN4E21AqMKp8Lcnrdoz1x/7gZywH3+G2+AACQL6dPdMhF+fbMXwjm0
         m/nHzfHDjjpjUyoyhWPmNvEtuCcvx/EGuO5NHtJ8bN35GRmRPpwF4NAZ2eiqdLsjgYXs
         tDFofbYfbKetkvtWzPcJ4qJu/os69ixQj4DJJZQch6ciaGZQW88Q0AiWIKPTCqd55XiV
         mm3g==
X-Gm-Message-State: ACrzQf2yoQDK2s9g4mK1vrnF64yo+NalK+HRiA0EysBd2+klex8RMayE
        6DUN5yopP4l9+s7KXPzf/8c5VQ==
X-Google-Smtp-Source: AMsMyM40urcw8Pb7S8ckoDST6aKu+pm+tQR6oHRoX1O+U0ftrbh4sDAM/9HRAv8LcoqmNLrOKmM3jg==
X-Received: by 2002:a05:6a00:b95:b0:565:9cbd:a7e5 with SMTP id g21-20020a056a000b9500b005659cbda7e5mr2242933pfj.74.1666085129233;
        Tue, 18 Oct 2022 02:25:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y2-20020a170902864200b001754cfb5e21sm8170513plt.96.2022.10.18.02.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 02:25:28 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Ruhl@www.outflux.net, Michael J <michael.j.ruhl@intel.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v3 2/2] igb: Proactively round up to kmalloc bucket size
Date:   Tue, 18 Oct 2022 02:25:25 -0700
Message-Id: <20221018092526.4035344-2-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018092340.never.556-kees@kernel.org>
References: <20221018092340.never.556-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1271; h=from:subject; bh=Lg7BoPA33TyF1N9Ak5ejRPt+aJUHR3UR0w6mwamzyDU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjTnEF5cGlPXkPcKPv34lox4vlIGHaJ00+4ZE1Nfh7 Om9sbOGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY05xBQAKCRCJcvTf3G3AJgc8D/ 9jBTPoFwFRkggAABohaocGh+SUXdr/tnCRtpBj1FnUDptaAqftQwbSemQKe/dNGdevoTRrcqFgYYLT QMvF6A5/qBFO7QiysDelk5iQt8J81h+leDO5DJnFZkQ2HMKCT2i0KVHUBSzzYgvAIlEalNqp3hz1Ws /BqyZq+CFVZ9jGet8Pap7DAGjauTXZyOCbjcf37mi+9pUHIX0fQB74d/oUBVh22x9s0TxbJZtcp0HQ dVAL5ulwMgSTvikjYGwzlDjdZJ3n7FWqNnXLFH+h4m8JFDZnyVq7ORhWQHzsvMton83QYopI5GTn2N ltGBC4L9wK4uPtiO4+VRw7sKkcuGPIiuXo+fA9pScZopO9vTcXbXaREhQ1bqSzmSHfQTsFR3GA2WvP lrohwfZk73id4wpmWwcibd6erFkaGn3MThfnABeNAwOV4lGFLjUWgM0gd6owrwii5bUyoMwkx1fPLQ jyQKhVIjNYs5DGv1dT4HJSiGVSBdkDZb6O+84PLYpUoDGP0QXg1K0y6nG/lJz6hkW2hPflxjO+Aefo RLXTCeTG7FcKDzuUbNugmuICL8B3oUKG/iXY7fKYbVAl/2mpUgXMe2rFw3c8NBHreGhiKQpwpC/9jN CowsdSTEpdA5snuZ++ijX40XFdZFNGUxDYGavFpVpvqBV6g3PXsyeVKWYvBg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for removing the "silently change allocation size"
users of ksize(), explicitly round up all q_vector allocations so that
allocations can be correctly compared to ksize().

Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 6256855d0f62..7a3a41dc0276 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1195,7 +1195,7 @@ static int igb_alloc_q_vector(struct igb_adapter *adapter,
 		return -ENOMEM;
 
 	ring_count = txr_count + rxr_count;
-	size = struct_size(q_vector, ring, ring_count);
+	size = kmalloc_size_roundup(struct_size(q_vector, ring, ring_count));
 
 	/* allocate q_vector and rings */
 	q_vector = adapter->q_vector[v_idx];
-- 
2.34.1

