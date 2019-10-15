Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D262FD7F10
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729774AbfJOSbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:31:31 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:34772 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfJOSba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:31:30 -0400
Received: by mail-vk1-f202.google.com with SMTP id b11so5633441vkn.1
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CmKa1agNJrPbYf7wPjFa61AdTdkKzngqPFR94jGBSQo=;
        b=lGBifvcuX1cVexaA5gZeOPCnRsCalHgm2qQisbsa0dHr3aedYyrsUnNUBHWZoNeTRD
         WQYNEKanf5y+qnqLraviO6anBsvYHr1pkVVAD1o0Rg/lbky8a+e+VhbWrhdp1z4i0fn0
         NqOcPc5nFQYY+4DoccufQTECeEHuJMUknxF0OBdJK45KLs1btsCRZ46L15pEnT1Vyx5u
         aGNsukzP+FMvxatv2FyNJ+BU0JFm0a72aswjLKcyMMTIZOd8us3QRvRSvi60RY9gJqEg
         lDrQmJZ69noIRgmZhydKG3X2uXYyj5Onc01FCkaQkvBnojPcAMAPvtj5ULC/+b1L2BM2
         UnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CmKa1agNJrPbYf7wPjFa61AdTdkKzngqPFR94jGBSQo=;
        b=p2PdtZSB6Vxvz5eTc3n8E26B/U/niFTyz35ik9N8kgQ5Axlq0mTV3OIG8p3lepTdnb
         mOJ4WDrb5tPU3BQnBCNRgZOpq81pXxR4CccW2azviFcWKzY9W7lqlITZYjt9sgfzt8p0
         fuwIbGa1pLJlaeapFNDFFqphOpHxodDdI4VmhrNqNx1l4ZPwG00Bax5tsKPGvYyE9BF/
         aOOO25FHz9iFQxzegrZ48i4UQRyjm7Bt1/xk4LFAqU2YWi12cd1PAx8VbKYl+z00yD5b
         CXFPPswg/zB8cpJd7KGsTXMwG2xkXwt9aJ85asCauMxVyWB785IYlmwrddfrl3yfF0xV
         SZzw==
X-Gm-Message-State: APjAAAWdOYb3USSdCYUr2bF509fO4jf4J+cYHnLo5VElOFAYEOVmpZxl
        z/2UXEGxB5boGyFgcWn/Xo6LDdTK7ZjCDy2eFb5hNZE4UU7xbSRAAIdyGYzGCExtJBAd/GER5cY
        ufrohL4crjGk+Z8lSrvET7iE6pmqQv83wOcrK5Lav0Dr+aUOMLK5o+A==
X-Google-Smtp-Source: APXvYqwFHz820XERQXeDopog7LjIac4wUp2RN27ZKfNOfcZumQKKktikhSc5kB/vwR++lltOP6L5znU=
X-Received: by 2002:a1f:b658:: with SMTP id g85mr19707472vkf.52.1571164288130;
 Tue, 15 Oct 2019 11:31:28 -0700 (PDT)
Date:   Tue, 15 Oct 2019 11:31:24 -0700
Message-Id: <20191015183125.124413-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH bpf-next 1/2] bpf: allow __sk_buff tstamp in BPF_PROG_TEST_RUN
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's useful for implementing EDT related tests (set tstamp, run the
test, see how the tstamp is changed or observe some other parameter).

Note that bpf_ktime_get_ns() helper is using monotonic clock, so for
the BPF programs that compare tstamp against it, tstamp should be
derived from clock_gettime(CLOCK_MONOTONIC, ...).

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/bpf/test_run.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 1153bbcdff72..0be4497cb832 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -218,10 +218,18 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 
 	if (!range_is_zero(__skb, offsetof(struct __sk_buff, cb) +
 			   FIELD_SIZEOF(struct __sk_buff, cb),
+			   offsetof(struct __sk_buff, tstamp)))
+		return -EINVAL;
+
+	/* tstamp is allowed */
+
+	if (!range_is_zero(__skb, offsetof(struct __sk_buff, tstamp) +
+			   FIELD_SIZEOF(struct __sk_buff, tstamp),
 			   sizeof(struct __sk_buff)))
 		return -EINVAL;
 
 	skb->priority = __skb->priority;
+	skb->tstamp = __skb->tstamp;
 	memcpy(&cb->data, __skb->cb, QDISC_CB_PRIV_LEN);
 
 	return 0;
@@ -235,6 +243,7 @@ static void convert_skb_to___skb(struct sk_buff *skb, struct __sk_buff *__skb)
 		return;
 
 	__skb->priority = skb->priority;
+	__skb->tstamp = skb->tstamp;
 	memcpy(__skb->cb, &cb->data, QDISC_CB_PRIV_LEN);
 }
 
-- 
2.23.0.700.g56cf767bdb-goog

