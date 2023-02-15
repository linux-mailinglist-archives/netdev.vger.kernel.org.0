Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A735698385
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjBOSfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjBOSed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:34:33 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29BE3E090
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:09 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id s13so2388889wrw.3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGskyb7pJ6ELCDekkQO9Fpll4hie2FaxctextYDdWfk=;
        b=CvkYkGojRTF1eT48EAhOGxpKFAfJuXXxWbY2N2vR/d8PSdGwxRi0RhW/cnfkVMsAZb
         UgHEANYfWje/SIme3N1mvQJEZSkYoSwbgquxz1tXaWeUi4PNJrl9un3ZY5OMUqjUY586
         +msL/Q7rs8Wuc9bFSUsEEH7usaRTGp6bWjN/mRrqceDp5Lhr/kjq6tl1jvImVNoNV5On
         jJOLzL+XV2hTym2JzS0CDZwnAi2GDxFeZlJheO4GsR02YAiEkdHATqcmYeJUBrTiEXgX
         CXSkyvtQjYwMTZybAeuCRcwnfVb3cDKh5mVveIt6xB2uxt3QdXYVJMAIAesQ7jF4/Lz3
         rcCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGskyb7pJ6ELCDekkQO9Fpll4hie2FaxctextYDdWfk=;
        b=C1JtjIv7diKI5jDYsofyhoM8zHzexPm45ad5cmrrt3+sGPe4wJ9tjjsVXL53Ao6x0n
         iyKECEQPMWN1iv/ClLiZG+JV9YWGWC8mO8D29DDHQis8l2xCBCnaiR2J7VH3or6lScpu
         rTlkz4/glEfkrxWw257X2E50ne03xOiy8FtqM85FJVJeDLGTAeQqAdvRfPtRIDTxfT7D
         3XNULLfsp1CeEhdsIgAl7g9hN5Uww0LpCzm0QmQ2U/9xj+M4rdunqFfpRfOBDFBickBS
         amJQ+Nm31Ubd3dTo+u42SxTuEECBYXpR4D2ulYvGRl88nQ+T2A2BaxlHV+a0QlukdgEz
         eGgg==
X-Gm-Message-State: AO0yUKX9ZwD2A6lRAmCk1y3mgBxbN6+RcF7c0Sefgc+xcqlw383l5G5T
        MYqrwk/bCZxZvjeP7JfdXAQKkg==
X-Google-Smtp-Source: AK7set+zt7TRGbCDSYN9tlczhKXE0qGkcB3FKbyoZ66mwG4AUB7+4Kx8jy9YzFAjTaJOQC8rFW7NOg==
X-Received: by 2002:adf:ef91:0:b0:2c5:4d16:8d73 with SMTP id d17-20020adfef91000000b002c54d168d73mr2693168wro.40.1676486049201;
        Wed, 15 Feb 2023 10:34:09 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id s9-20020a05600c45c900b003e00c9888besm3196306wmo.30.2023.02.15.10.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 10:34:08 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>
Subject: [PATCH v4 14/21] net/tcp: Add TCP-AO SNE support
Date:   Wed, 15 Feb 2023 18:33:28 +0000
Message-Id: <20230215183335.800122-15-dima@arista.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230215183335.800122-1-dima@arista.com>
References: <20230215183335.800122-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Sequence Number Extension (SNE) extension for TCP-AO.
This is needed to protect long-living TCP-AO connections from replaying
attacks after sequence number roll-over, see RFC5925 (6.2).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_input.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 264db761153b..9f23cab1e835 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3528,9 +3528,21 @@ static inline bool tcp_may_update_window(const struct tcp_sock *tp,
 static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 {
 	u32 delta = ack - tp->snd_una;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao;
+#endif
 
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_acked += delta;
+#ifdef CONFIG_TCP_AO
+	ao = rcu_dereference_protected(tp->ao_info,
+				       lockdep_sock_is_held((struct sock *)tp));
+	if (ao) {
+		if (ack < ao->snd_sne_seq)
+			ao->snd_sne++;
+		ao->snd_sne_seq = ack;
+	}
+#endif
 	tp->snd_una = ack;
 }
 
@@ -3538,9 +3550,21 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
 {
 	u32 delta = seq - tp->rcv_nxt;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao;
+#endif
 
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_received += delta;
+#ifdef CONFIG_TCP_AO
+	ao = rcu_dereference_protected(tp->ao_info,
+				       lockdep_sock_is_held((struct sock *)tp));
+	if (ao) {
+		if (seq < ao->rcv_sne_seq)
+			ao->rcv_sne++;
+		ao->rcv_sne_seq = seq;
+	}
+#endif
 	WRITE_ONCE(tp->rcv_nxt, seq);
 }
 
@@ -6369,6 +6393,17 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 * simultaneous connect with crossed SYNs.
 		 * Particularly, it can be connect to self.
 		 */
+#ifdef CONFIG_TCP_AO
+		struct tcp_ao_info *ao;
+
+		ao = rcu_dereference_protected(tp->ao_info,
+					       lockdep_sock_is_held(sk));
+		if (ao) {
+			ao->risn = th->seq;
+			ao->rcv_sne = 0;
+			ao->rcv_sne_seq = ntohl(th->seq);
+		}
+#endif
 		tcp_set_state(sk, TCP_SYN_RECV);
 
 		if (tp->rx_opt.saw_tstamp) {
-- 
2.39.1

