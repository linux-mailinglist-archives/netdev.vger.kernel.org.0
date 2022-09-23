Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DDB5E8004
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiIWQk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiIWQkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:40:25 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DBE6EF39;
        Fri, 23 Sep 2022 09:40:24 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so325127wmq.1;
        Fri, 23 Sep 2022 09:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=uIbjcfAGyfInoLm/OvWITyB0RrSdYYX1RircUBZVOuM=;
        b=CKI/w9qlPppvR3tyBdHeNFUn52RNE+MeZLNbpK6WQHJMNQ7f3vkWFTdLCCcM+xWq3t
         88EF5j5pTqPAB2s3p0pS1p4UUk241RhmRK9VMkOzQijAnB5okJgircXsRKhYPwGleM3N
         de//MuiWg86ofbLfaub6s67iv1uESid4nF14NOWOT5jY3SBRpR7/H12eiO/oxBSXm0/P
         ILfCI77hYYZ+7YxxAz7yP8DxSO8h0V/lXa2Gih0fct6VL2AJNREKCz2Xt1ycpc+sJE2Y
         VHG/A+GqTB4qZ5Cxq9oyDzh1hyfFvfD0o3F+uWIc7yGHB2I5tBiyMFhHzB0o6nFg5XwE
         pLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=uIbjcfAGyfInoLm/OvWITyB0RrSdYYX1RircUBZVOuM=;
        b=qJccivxZjxfKy/wceBh3cYl68xnIAmR3uLmMNgESmAoNl1NTnqILfQHPiXkoMGq1pK
         reykr0iFQBxVSKvbaqmFxrwZt9b39kAwrDwSWVTBkbjQNyp7vCn9Jz8YESO/PFk/BoJv
         /7djyyppuCySbDzHKvScr1sKEWyI5Sf16FWro4usXyEy6Cqw6FDvt7u1px2EBhmoTu0F
         lnqAGDu+UHYhTkYqOr72cpKVjZfNBaRJFUR9NTqbDMKjKn3O9KBD9kVKLhy0+CvYNgCL
         i/AkEx5CrbEMYWCkls4Wlm0JdLgYfEOcV0PvQ+vGU3X1zna+2pYdl4uAiGJI2juCPqW+
         HbtA==
X-Gm-Message-State: ACrzQf1RdAV4y2Pt3K7InrYWTqXU91+23M0DzjyjpNe6IHhG3ggGjk5G
        ogOxUu+K3nedctWwpBmBwWMVdqEDkJ8=
X-Google-Smtp-Source: AMsMyM4CW6l8pZR3BmCcj39hcl6rGI9MDfbfk8pAVz7vOj4J8jOaapYhvNsZhT0FZMIxSSMOhL5SAw==
X-Received: by 2002:a05:600c:3d86:b0:3b4:b65f:a393 with SMTP id bi6-20020a05600c3d8600b003b4b65fa393mr6744885wmb.0.1663951223070;
        Fri, 23 Sep 2022 09:40:23 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id x13-20020a5d60cd000000b0022af6c93340sm7717399wrt.17.2022.09.23.09.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:40:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 1/4] net: introduce struct ubuf_info_msgzc
Date:   Fri, 23 Sep 2022 17:39:01 +0100
Message-Id: <641bb6844e67e639a9403b8eab96c3fa34659e2a.1663892211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663892211.git.asml.silence@gmail.com>
References: <cover.1663892211.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're going to split struct ubuf_info and leave there only
mandatory fields. Users are free to extend it. Add struct
ubuf_info_msgzc, which will be an extended version for MSG_ZEROCOPY and
some other users. It duplicates of struct ubuf_info for now and will be
removed in a couple of patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f15d5b62539b..fd7dcb977fdf 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -554,7 +554,28 @@ struct ubuf_info {
 	} mmp;
 };
 
+struct ubuf_info_msgzc {
+	struct ubuf_info ubuf;
+
+	union {
+		struct {
+			unsigned long desc;
+			void *ctx;
+		};
+		struct {
+			u32 id;
+			u16 len;
+			u16 zerocopy:1;
+			u32 bytelen;
+		};
+	};
+
+	struct mmpin mmp;
+};
+
 #define skb_uarg(SKB)	((struct ubuf_info *)(skb_shinfo(SKB)->destructor_arg))
+#define uarg_to_msgzc(ubuf_ptr)	container_of((ubuf_ptr), struct ubuf_info_msgzc, \
+					     ubuf)
 
 int mm_account_pinned_pages(struct mmpin *mmp, size_t size);
 void mm_unaccount_pinned_pages(struct mmpin *mmp);
-- 
2.37.2

