Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7EF2512406
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiD0UpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiD0UpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:45:05 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739DC15805
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 13:41:52 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d15so2597800plh.2
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 13:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fcFqcWGHIUmpVEHU0uDFezBhADPZulgFXAo5qDYT4F8=;
        b=okIQHDuQv+bifFjdzLVgX/jFABWF8vqiqDqknarn1j1u+gimjSF/5BI0jCww4Qgnz9
         RgFVu+Rr2+j1Rz9WXjDiwbP7Hn0qep5UpM2sqiseEYOgzH2iL473r768XGzLIf8HvriB
         3dSwEnyzJdKZ9SeV3e9+D447anh1DLkOAIgwwl9YCYIgNOaqDT1ih/fRgbkFwBR26azA
         0mt6XvqRJTK0X03nw/AugXNlspz1fo271CRSh3H02pFS4ttIXm09QHfzNewhztGJqOR0
         sWFbkWSxkqa/xY0HpQ0oPcr81Z+5kqArAh+BK8p/4+BpG9el+IuCrzGazO6C++/kTnk4
         n9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fcFqcWGHIUmpVEHU0uDFezBhADPZulgFXAo5qDYT4F8=;
        b=lANUmGNfVC36C4ih2Bw5RqQXrn568+Ha+tnVT0TWyNrONcqVySyxeLF6xL15M1EoIU
         7glo0BOZT0adjm3SvrJgRfwhBrxawD1VLaToF+j+uSoCdaiL5KRBICUpmi4zoslsaM+O
         uW3gsqTGXHzlNHAxmRVUqq7SETDna/x6XMVAKkmc3A3GJUP87F9eM/abikcS3c7uCVhR
         YDKKDbi9kuTds6qTKzgdmVgbHjW0+NFBBPP7YaNQDPwAqB4sp5rTTpXVw5GQ+7DKwvK/
         yHhfXqCKxCueDHjxGb4zqyplv+lo/CVcsH1CyIkM4IESYPHx7ttGUpeA9+57BhOsRrHM
         0jLQ==
X-Gm-Message-State: AOAM531NLAoEI8AGokpiCjs5yPprs1A9v8eOu/yiaLAsc6jvM4XOwaiN
        3uT2CDsMdwlj9FpjJwWZzpM=
X-Google-Smtp-Source: ABdhPJzI+fFX+0EtRo4VMyAiWb0BDGHryiEZB0DQuF0O6U5T4VByj2UI7XrZcmKhftjxqpNPOj77Kg==
X-Received: by 2002:a17:902:7e06:b0:159:6c1:ea2b with SMTP id b6-20020a1709027e0600b0015906c1ea2bmr29961012plm.105.1651092111856;
        Wed, 27 Apr 2022 13:41:51 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4601:fb6:af20:af2b])
        by smtp.gmail.com with ESMTPSA id f16-20020a056a00239000b004fa7103e13csm21491855pfc.41.2022.04.27.13.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 13:41:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] net: make sure net_rx_action() calls skb_defer_free_flush()
Date:   Wed, 27 Apr 2022 13:41:47 -0700
Message-Id: <20220427204147.1310161-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
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

From: Eric Dumazet <edumazet@google.com>

I missed a stray return; in net_rx_action(), which very well
is taken whenever trigger_rx_softirq() has been called on
a cpu that is no longer receiving network packets,
or receiving too few of them.

Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Ido Schimmel <idosch@nvidia.com>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 611bd719706412723561c27753150b27e1dc4e7a..e09cd202fc579dfe2313243e20def8044aafafa2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6617,7 +6617,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 
 		if (list_empty(&list)) {
 			if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
-				return;
+				goto end;
 			break;
 		}
 
@@ -6644,6 +6644,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 
 	net_rps_action_and_irq_enable(sd);
+end:
 	skb_defer_free_flush(sd);
 }
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

