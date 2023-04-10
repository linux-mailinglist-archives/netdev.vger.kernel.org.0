Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1CA6DCBC6
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDJTnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDJTne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:43:34 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0F61997;
        Mon, 10 Apr 2023 12:43:34 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id cj22so6634239qtb.3;
        Mon, 10 Apr 2023 12:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681155812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EL3MSEYEBRAcOqjx/HoU1JvoJjuRAdGJd1gyq9lekp8=;
        b=jpPwAtW0F3oM7mXYn/OZkvV3FGt1zx2A3j1qV1ktHahvr+9llty0GbP5oHL2yJ8Szk
         h+qwSUDr88peep5Ilbpei9g1FN/U0tgAUhonJR3GdB8sCue+sN2OAJAGX/ghvP4qhIQJ
         tNTGwslOfAQm2VtnC6IL64nn5RPQzIuJ1MQsawEP8jnL3fyk/WbaV4mSnTcJOUXJw+KG
         W9mMfHRlgaokaUvf440hhDsgy8Yn7Qya7XsbuywJU7JCU0oNYZ9IzGxjrQOWzpSN/mAv
         RRyda+/aU08EB+WjwKdz5YyqOWzPE44baUvSz3PzG7EsjTpQflVIe7CdHaHDkId+9RRf
         Baig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681155812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EL3MSEYEBRAcOqjx/HoU1JvoJjuRAdGJd1gyq9lekp8=;
        b=cfCm9K0ZiZCj+F+RYoH8OmZsSezyMwGfv7hmz4tq+0oi2ICEANZYYbHGB+ChL+p/fo
         6HWaRuYtqAorlc194+07+e4LzWPRUlCS9e5P7lGbLmw6ryr2alkEjx2Q9AoI6alJrtze
         6gjRXMW5R/8NJCD/LQzvPfTkOl8UQmt/WjEfvcDYWj6JF05lN52sJBfcFeCT/jsykVu/
         MmDkDe4V4OWp9uG3bmuhU68KkpNSVAf2+KmB77Kl6jNr4TeaikShmHADCmzq3CQ/+LXF
         hwer1inaKq2C+addGcjI1EuMX39RQK6gZk+KyyH6vGsoyOxShBjTa1H9dk10uO41Sl+e
         3cgQ==
X-Gm-Message-State: AAQBX9e0hAyXhoWHmlNIj+BAURbC/zWiKgdtw4y4UR8YI5gpmZUYTho5
        2SHdnJ52IrOgtCBeskmiArrJfW7XZCFFPQ==
X-Google-Smtp-Source: AKy350a/MYATw11TpcP/5AxT35Mk11xdExjsCK0Wg0tS99yw946FC4sxguRNBTkh5HXLl8EvF4x6bw==
X-Received: by 2002:a05:622a:60c:b0:3b3:7d5:a752 with SMTP id z12-20020a05622a060c00b003b307d5a752mr229877qta.50.1681155812668;
        Mon, 10 Apr 2023 12:43:32 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c64-20020a379a43000000b0074a0a47a1f3sm3506329qke.5.2023.04.10.12.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 12:43:32 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: fix a potential overflow in sctp_ifwdtsn_skip
Date:   Mon, 10 Apr 2023 15:43:30 -0400
Message-Id: <2a71bffcd80b4f2c61fac6d344bb2f11c8fd74f7.1681155810.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when traversing ifwdtsn skips with _sctp_walk_ifwdtsn, it only
checks the pos against the end of the chunk. However, the data left for
the last pos may be < sizeof(struct sctp_ifwdtsn_skip), and dereference
it as struct sctp_ifwdtsn_skip may cause coverflow.

This patch fixes it by checking the pos against "the end of the chunk -
sizeof(struct sctp_ifwdtsn_skip)" in sctp_ifwdtsn_skip, similar to
sctp_fwdtsn_skip.

Fixes: 0fc2ea922c8a ("sctp: implement validate_ftsn for sctp_stream_interleave")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/stream_interleave.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 94727feb07b3..b046b11200c9 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1154,7 +1154,8 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
 
 #define _sctp_walk_ifwdtsn(pos, chunk, end) \
 	for (pos = chunk->subh.ifwdtsn_hdr->skip; \
-	     (void *)pos < (void *)chunk->subh.ifwdtsn_hdr->skip + (end); pos++)
+	     (void *)pos <= (void *)chunk->subh.ifwdtsn_hdr->skip + (end) - \
+			    sizeof(struct sctp_ifwdtsn_skip); pos++)
 
 #define sctp_walk_ifwdtsn(pos, ch) \
 	_sctp_walk_ifwdtsn((pos), (ch), ntohs((ch)->chunk_hdr->length) - \
-- 
2.39.1

