Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4208B52030F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239330AbiEIRBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239444AbiEIRBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:01:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29211E010E
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 09:57:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id fv2so13690675pjb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 09:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gECE3xEP7jHNIcR16cw0a4r66b5ac6b60792aY0sxeo=;
        b=LIocaOLsDg8cf6KQOUKXKo2u+3ht2F4SNMSsvjtwcw2xG2rNqoRwLzj9W3mY0U4Zob
         UD95+RMOHEGnYWfUpzqpqkjH2sm1bPWv/n3nnbjwtKfn/bVXIhYvWGEHZnQFO7NYPbnz
         BysdTFozAKV8/7QdXNTh/TISCfCd1kYWeg/Dkduutta98cU0/Fi1SYJyJu9Kpp7zJAcE
         F045Zb1ooakQD1yu7hb1FOZldAi+nl13fNxiGDPsxpKSN7DJPCdsfucV8ck2czzSlZ9M
         KIgFrciw0ryYlYkWkplBaTm9eBB/+vEsDyAPhjk438ly/AHfrCTxpt1FSPc14ubbMiDE
         Hb5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gECE3xEP7jHNIcR16cw0a4r66b5ac6b60792aY0sxeo=;
        b=Ej0JF5uuTTMhWFo5Vjp0WDugLEh7nR68YSJzw+DdxZDjNm3ErhgOxiBnFs53SHWl5S
         iuvdmHIcCcRyOUdhAO9Emispud/xD3yXMmhwjVowrA0NJkl3yeuwAbKYGaVIpHnjf5/2
         C2qMGdptwwvGk6bWQpGhKreyv2/rg/39vKWFbDpKKrrbm59Y9KITVAzgxwEpPvGEVJ1/
         h9nefRxTAUGuyhYDBQPy1kuh6rvlgbkv8iQp+hBeevx+TYoNA0pVFCVeVv/dR8uwE2nd
         LG4LE3dQ3ouPj4CcvQSnZlys9xvJ8gUYV+PODQkUnJhi62a3TVGNWWvwOeet0tyro1sw
         MiEQ==
X-Gm-Message-State: AOAM532TNNjF6+WUtUVUlMdNsRcBoUy7L7IBZ/4RhTvBvMM1LBOf6oY9
        B02EOfm1ubwlztywpPSncP4=
X-Google-Smtp-Source: ABdhPJwjc3f1C5LqpaDUycPvX5lg9DEc4zSJybBLcPDlF/7rB9II+8cVBXq6uN8kwyPd66bRoQ6NZw==
X-Received: by 2002:a17:90a:8b91:b0:1be:db25:eecd with SMTP id z17-20020a17090a8b9100b001bedb25eecdmr18922699pjn.10.1652115439513;
        Mon, 09 May 2022 09:57:19 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id c4-20020a624e04000000b0050dc76281c0sm8894176pfb.154.2022.05.09.09.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 09:57:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: warn if transport header was not set
Date:   Mon,  9 May 2022 09:57:16 -0700
Message-Id: <20220509165716.745111-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Make sure skb_transport_header() and skb_transport_offset() uses
are not fooled if the transport header has not been set.

This change will likely expose existing bugs in linux networking stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d58669d6cb91aa30edc70d59a0a7e9d4e2298842..043c59fa0bd6d921f2d2e211348929681bfce186 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2804,6 +2804,7 @@ static inline bool skb_transport_header_was_set(const struct sk_buff *skb)
 
 static inline unsigned char *skb_transport_header(const struct sk_buff *skb)
 {
+	WARN_ON_ONCE(!skb_transport_header_was_set(skb));
 	return skb->head + skb->transport_header;
 }
 
-- 
2.36.0.512.ge40c2bad7a-goog

