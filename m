Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC118640FF2
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 22:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiLBVY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 16:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbiLBVY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 16:24:27 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDE8ED6BA
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 13:24:25 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w129so6046056pfb.5
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 13:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=12aQYv6pNDlz3kqQzWKO2uUnIoYw8k+CG7RR/rv2kas=;
        b=T74PGYDhKiQHFX1rUbRIOiCv4vz6iGaOnC7K9ErdB1BzmUXvCH/1kx1QXL4c6ieoZX
         21PDT5faUpOfudcVt38fnDW7vDITh8I2bKWFIbpNHm1D2uypViY1q6E/jYtk4TBq/3X+
         1NhpdIBX6KQwlDjZbZZFFud2SzjQaT2z58vqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=12aQYv6pNDlz3kqQzWKO2uUnIoYw8k+CG7RR/rv2kas=;
        b=Oiy8YkDNK/Ee0pI0/JWTzhzueeKQncJY/GSBAsGXLFhO4F+lXOVmf4NMA2rwORuuGd
         li+bbyvTYUdzE4H/mW5Nflujo7GCwMCdO37RxajzSPsn3AblLC+cyEs+8fHgsg2dNylj
         SyfcUIBbtjr7NZM0m+wNnVYktmknCAzOMtzn8F+AKGM8RTsN3Yh0nXdJnSJ+DQzVvGtS
         DwL3KBH3dD+lscBnNVhW631ymNf24FJIcNZ3a82YZvDu6vcpuX0dFm1KqT0YnYHwwUCq
         PBy4ksQkvEIovejyTn85OYjlJJqXl006qrCBcOE0TcvTuOc1almZwLAmuPioYT9pY3Vk
         WX8w==
X-Gm-Message-State: ANoB5pml0L5cA/MJ/b2c2VMV44yMB7dLjITFhSnlm7XM0QS0u6hgFvys
        kBrAKUWr4AeJjBJKFTsA290fUA==
X-Google-Smtp-Source: AA0mqf5lWrRZyB1rb6+beDappO2/uB53e2Y3KK87lKvgcg9P19h3aBTnySuTNFkeNbXD7PlGLuieIQ==
X-Received: by 2002:aa7:9416:0:b0:575:518e:dc11 with SMTP id x22-20020aa79416000000b00575518edc11mr23821532pfo.86.1670016264915;
        Fri, 02 Dec 2022 13:24:24 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i29-20020a056a00005d00b0056b6c7a17c6sm5695671pfk.12.2022.12.02.13.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 13:24:24 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc:     Kees Cook <keescook@chromium.org>, Joel Stanley <joel@jms.id.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] net/ncsi: Silence runtime memcpy() false positive warning
Date:   Fri,  2 Dec 2022 13:24:22 -0800
Message-Id: <20221202212418.never.837-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1371; h=from:subject:message-id; bh=2sUnLG3FFN8pFif3YWCnaOEtrm0LjtacXGcVGEiw/+Y=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjim0FA4ytswXqmWp1hRMca/r2avtZHR15euW2n+B3 jQs7mISJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY4ptBQAKCRCJcvTf3G3AJpzCD/ 9E+a3vKrpcpU0BDeu4dr57dQgQ9SeaSG2Ag/XejMzr19dmuMerdXl6P1NqOmAWo7UYt/D4qId4z3Hp X7E/W5FiDu3uI/Bt2w1ibs7eZ0HcN5Uvu059rx1xAkoiryxEICiHyrHuXyCL622b3Dph3tyPjFTpbJ vl7cDe374WWh8g1Drj90IaHF7ZNq7ZpzJU+EL+/DseIcncBX5KMoNH8bcOqnKCfLhp0Rn+cRE2oOWP GocayW8y41PU4VijiPtVY+NPP86UOKTvko6/5mIlOudbLFUm39KlmXEkdxAHiZUK5wg0OJ56uXnSv0 8OMxyQoFPjmZe7Pw/UErnIxW/ReOejRN6mVzDFV8r12CXTwzSqfFGgzUfep1o6HVoRKSrun+eA9dxR +6iRUGEp0uDIFIDHPJoZvmMC3VGzvxT6krGxWgMOYB8bNUOTjkNkp6iheICNV4sk8OUCoIJzSKZYDY g5STXOgCghnpRCfC4jGxQsSAxRsqlurLMP2ej83Q0ExoR+U1E7dCG/vnxQMrZnb33q2vGyWUwuVdoS ujQgFyXD1gqgQmeBE2BlbEuLkCeLHJLT5gAypd9TnZ6aVe8SQ6d5sHFPQbc4ZAO0MrgPo2Yv3l0t1d VREmX/tud/ODKGuWxensvuZM9kgb3XFccEt8oeVwHZiFZ4L9xCx+yJ9Vhopg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memcpy() in ncsi_cmd_handler_oem deserializes nca->data into a
flexible array structure that overlapping with non-flex-array members
(mfr_id) intentionally. Since the mem_to_flex() API is not finished,
temporarily silence this warning, since it is a false positive, using
unsafe_memcpy().

Reported-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/netdev/CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com/
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ncsi/ncsi-cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
index dda8b76b7798..fd2236ee9a79 100644
--- a/net/ncsi/ncsi-cmd.c
+++ b/net/ncsi/ncsi-cmd.c
@@ -228,7 +228,8 @@ static int ncsi_cmd_handler_oem(struct sk_buff *skb,
 	len += max(payload, padding_bytes);
 
 	cmd = skb_put_zero(skb, len);
-	memcpy(&cmd->mfr_id, nca->data, nca->payload);
+	unsafe_memcpy(&cmd->mfr_id, nca->data, nca->payload,
+		      /* skb allocated with enough to load the payload */);
 	ncsi_cmd_build_header(&cmd->cmd.common, nca);
 
 	return 0;
-- 
2.34.1

