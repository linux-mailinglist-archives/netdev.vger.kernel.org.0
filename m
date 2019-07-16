Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8126B0B1
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 22:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388797AbfGPU6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 16:58:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40092 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbfGPU6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 16:58:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so10027298pgj.7
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 13:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kl9yNljOWc7+nq5LzihsD/npOAxJjIk2+RGu+am0yhM=;
        b=p8XA6XZaIYXhE6iE7dGRR7CSvmYkcMtG0Bh8Z+uZfwG+QySeQpcRihpz3YPwBZ0Iao
         HInyXjmom9O9ipAk1HaL93n/HDEvztKeQ8XyYRZY+p5JrCpIGZlNusjVFTFcQ+CM0yFP
         x7k7V4B5c4XCAFmpU3ELu41Kw/eBDVAyB09OvPaiK4MC/2BtMqFfDpJSlXvfby9EsU/l
         7dgacFKrC/JGFTPIOqUtUZ27miSKt8eMK+ykKhryBAxf+MP1d8hwAtr15eZTUydksdwR
         1riwBzllOfrt8UcIBbOCaKk6yD2DVVr8x+ZipUuYddTnTqk7Ce4uJwShpb9JBdBWwr9B
         PIkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Kl9yNljOWc7+nq5LzihsD/npOAxJjIk2+RGu+am0yhM=;
        b=RBpic+V5LSON54Ggp1TlQehuD4I/qnZbzUxX8Lb8McQHBUIIt0oR/WBClWUP793ze3
         X82y6av27td2NWwSWnVHYMbOZov/qU7wKNMsgrNgLRXxIh4xejJ2a+oZ01rOnHItGbNP
         tYDWUiyJvqLSS30IsLATxe25bQcxuRWDIM5IvDDEf3UqcobB4HyFdTqv9QOvZ9ACwTzv
         00y26aqDT7hD+ZPDZM1zISNLrLKBl3DwHzwJW1ovmjylzk5IaL5v6B+eFKB/+20rkOKE
         IOisGFWF65UAOw33JcA7/gkiQCas6WdBnAEsrrPIVvAH6yfcfCx27npihFHT0Yciehb6
         OrXA==
X-Gm-Message-State: APjAAAVuRG7/SgfcAE4vPWb/9zg34iObe8J9vHwbDcBeanNZ/991f76U
        AqOw9EKy7oCIKJvVe3+kHCJm5MZFYwk=
X-Google-Smtp-Source: APXvYqzzmVrk4C2Fvzd97Xgf9dior7eobZTmvDVUvE9OmWRFwaPNoLcbFhDN6Ly0ksAMiYG4bygZJQ==
X-Received: by 2002:a63:ce01:: with SMTP id y1mr33140401pgf.389.1563310702928;
        Tue, 16 Jul 2019 13:58:22 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id a1sm18746125pfc.97.2019.07.16.13.58.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 13:58:22 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Julian Anastasov <ja@ssi.bg>,
        David Ahern <dsahern@gmail.com>
Subject: [Patch net v2 1/2] fib: relax source validation check for loopback packets
Date:   Tue, 16 Jul 2019 13:58:03 -0700
Message-Id: <20190716205804.19775-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a rare case where we redirect local packets from veth to lo,
these packets fail to pass the source validation when rp_filter
is turned on, as the tracing shows:

  <...>-311708 [040] ..s1 7951180.957825: fib_table_lookup: table 254 oif 0 iif 1 src 10.53.180.130 dst 10.53.180.130 tos 0 scope 0 flags 0
  <...>-311708 [040] ..s1 7951180.957826: fib_table_lookup_nh: nexthop dev eth0 oif 4 src 10.53.180.130

So, the fib table lookup returns eth0 as the nexthop even though
the packets are local and should be routed to loopback nonetheless,
but they can't pass the dev match check in fib_info_nh_uses_dev()
without this patch.

It should be safe to relax this check for this special case, as
normally packets coming out of loopback device still have skb_dst
so they won't even hit this slow path.

Cc: Julian Anastasov <ja@ssi.bg>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/fib_frontend.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 317339cd7f03..e8bc939b56dd 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -388,6 +388,11 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
 	fib_combine_itag(itag, &res);
 
 	dev_match = fib_info_nh_uses_dev(res.fi, dev);
+	/* This is not common, loopback packets retain skb_dst so normally they
+	 * would not even hit this slow path.
+	 */
+	dev_match = dev_match || (res.type == RTN_LOCAL &&
+				  dev == net->loopback_dev);
 	if (dev_match) {
 		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
 		return ret;
-- 
2.21.0

