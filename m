Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D35E522A1A
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 04:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiEKCxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 22:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241832AbiEKCxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 22:53:20 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5E52497F
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 19:53:05 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j14so579101plx.3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 19:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sa6iliEUhHDKiJ4d5VKYWANmjzvcVks6FAQCBioSqwo=;
        b=iLg1sZkLeKPM2kWZK1dOBgkVtvIv9fskmkv+uRa3VrGM/iSiUFxz9myhwDCq/lYtMQ
         uqYJxL/zrLKanqkbFe33nehGm6l5DZ8mvHCYyk8RO7ro9VrUdoxqMHW1qj/9L4C/sZR+
         79n1lE2VsyCc+x3k5bTSQqe4BWZOIwuScBssM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sa6iliEUhHDKiJ4d5VKYWANmjzvcVks6FAQCBioSqwo=;
        b=t09C5E160V7W4QMPivibgxZ1l+HHnu0dLgmD2Fy5tEejjXasyPzZiyFbLuB1fjwo5T
         UNDSBXXZfVuRRgvDttiieNDeJhf+F12kIQ1wKJgu+P3Yx4RQETuwHsXywwW7M4mGM1Ro
         RckuuyrJcdwJ+KAyVCMlXpQUxIDfucEVZDCT0cxa9cXuZXo98OVOgyLQ14gowkw7lYB0
         76NUozQTmwRfyvIMXtDpzY5mty5ym7ETRX0aYso3TOaPNwqhHuZE5BWOPXy1UiZ2C9OB
         sYlQdAsINKMAWBhkEjqrlcfI2lKYSCNp2AX8qyYTzR5KzyD1U1XniPCv6HWPFAL1KAxB
         zINg==
X-Gm-Message-State: AOAM5304zXgcuFNFla9gGbxZFK5JmqeK0jxgSa584zml9V/sKcN5QURu
        sx1cDIcdDRbhqy29dcGcfUyV5g==
X-Google-Smtp-Source: ABdhPJx1c1/TGylCkNI+72RCfr609NArcRVaQDmF+ypY51TnbvIezVGQVIwy6NL0mcbSprU53CJYrg==
X-Received: by 2002:a17:902:d4c2:b0:15e:abd0:926f with SMTP id o2-20020a170902d4c200b0015eabd0926fmr23646480plg.129.1652237585369;
        Tue, 10 May 2022 19:53:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902968900b0015e8d4eb1d7sm363503plp.33.2022.05.10.19.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 19:53:05 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH] fortify: Provide a memcpy trap door for sharp corners
Date:   Tue, 10 May 2022 19:53:01 -0700
Message-Id: <20220511025301.3636666-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4296; h=from:subject; bh=zskFoaXURO/IVylo7b2S5LXUxKy16zZKQmnvSBayKxA=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBieyUMQ7ji1ylNdh9eL1qcvtxDkFAlxq4iz5ETfoxb d7pbo8iJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnslDAAKCRCJcvTf3G3AJnjwD/ 4vfLAWnR6lv2s6quyKFRlqqPX6DLgsFQO/0o6PWTm5WPdSp+jXJqvlubxLwxyUfRZUbAjVMOhXxrZz KnVhdajFWHnLc9B7YN9txp8Hh+eKcnC/OHn7yNU8hpZKQniQmkPh4D9/b1vwGodxeF6+u63TcnX8Z+ zZKjmoKETwoY1YykOIEE1Xqg8ox/oT52kP9u1N092vsWV6YXGrtSUQzsEqal/HToEvS6eW+ZUTi8i3 EyzzxjYtTSltgVY3Et9AqCO9Uo+0Ik7Go0rzqSNgnp0GS8xpKOFXb2g124++75uNB7utcfKmGn5yfR Wb4rd1+trzcYq7kxQp1xPZHqXXLV9UzeTqzToIVwDOwsWyKRmNdmsX9hDkiNiCn+7N9X+l9/gIbMm2 +RjZ/MRfPPTNuGmpliyix25Smdz53NXN1FrhronUFYEKnf1WpUEwTEvF4O42vsCTekwqIrgGXCLurf S/7d3fS4v4Bg8cA+5Qh+Uk0+ZqrTXgUP6OaDMkTICNXHTUGS80cHN7CrFE6q1UO+tsNQ/Fsge8taJS gm+Kiyli7VLSzYhXC0sKHxbB0JH0xP5894RSoW/K/PoLq+kRq7B1YseAHyV0Qfk5+iriQajxk+fnBQ egtZMtFQH8mxnRG8Q/Oo/X9lppUulkGrhJw92Vl2hjcQ77wy6/uvc14JCVXA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we continue to narrow the scope of what the FORTIFY memcpy() will
accept and build alternative APIs that give the compiler appropriate
visibility into more complex memcpy scenarios, there is a need for
"unfortified" memcpy use in rare cases where combinations of compiler
behaviors, source code layout, etc, result in cases where the stricter
memcpy checks need to be bypassed until appropriate solutions can be
developed (i.e. fix compiler bugs, code refactoring, new API, etc). The
intention is for this to be used only if there's no other reasonable
solution, for its use to include a justification that can be used
to assess future solutions, and for it to be temporary.

Example usage included, based on analysis and discussion from:
https://lore.kernel.org/netdev/CANn89iLS_2cshtuXPyNUGDPaic=sJiYfvTb_wNLgWrZRyBxZ_g@mail.gmail.com

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Coco Li <lixiaoyan@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c |  8 +++++++-
 include/linux/fortify-string.h                  | 16 ++++++++++++++++
 include/linux/string.h                          |  4 ++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 2dc48406cd08..5855d8f9c509 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -386,7 +386,13 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			stats->added_vlan_packets++;
 		} else {
 			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs);
-			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
+			unsafe_memcpy(eseg->inline_hdr.start, skb->data, attr->ihs,
+				/* This copy has been bounds-checked earlier in
+				 * mlx5i_sq_calc_wqe_attr() and intentionally
+				 * crosses a flex array boundary. Since it is
+				 * performance sensitive, splitting the copy is
+				 * undesirable.
+				 */);
 		}
 		dseg += wqe_attr->ds_cnt_inl;
 	} else if (skb_vlan_tag_present(skb)) {
diff --git a/include/linux/fortify-string.h b/include/linux/fortify-string.h
index 295637a66c46..3b401fa0f374 100644
--- a/include/linux/fortify-string.h
+++ b/include/linux/fortify-string.h
@@ -52,6 +52,22 @@ extern char *__underlying_strncpy(char *p, const char *q, __kernel_size_t size)
 #define __underlying_strncpy	__builtin_strncpy
 #endif
 
+/**
+ * unsafe_memcpy - memcpy implementation with no FORTIFY bounds checking
+ *
+ * @dst: Destination memory address to write to
+ * @src: Source memory address to read from
+ * @bytes: How many bytes to write to @dst from @src
+ * @justification: Free-form text or comment describing why the use is needed
+ *
+ * This should be used for corner cases where the compiler cannot do the
+ * right thing, or during transitions between APIs, etc. It should be used
+ * very rarely, and includes a place for justification detailing where bounds
+ * checking has happened, and why existing solutions cannot be employed.
+ */
+#define unsafe_memcpy(dst, src, bytes, justification)		\
+	__underlying_memcpy(dst, src, bytes)
+
 /*
  * Clang's use of __builtin_object_size() within inlines needs hinting via
  * __pass_object_size(). The preference is to only ever use type 1 (member
diff --git a/include/linux/string.h b/include/linux/string.h
index b6572aeca2f5..61ec7e4f6311 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -252,6 +252,10 @@ static inline const char *kbasename(const char *path)
 #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
 #include <linux/fortify-string.h>
 #endif
+#ifndef unsafe_memcpy
+#define unsafe_memcpy(dst, src, bytes, justification)		\
+	memcpy(dst, src, bytes)
+#endif
 
 void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
 		    int pad);
-- 
2.32.0

