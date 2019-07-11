Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA47653FC
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 11:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfGKJko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 05:40:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43477 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728325AbfGKJkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 05:40:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so5494125wru.10;
        Thu, 11 Jul 2019 02:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1LhwbybOGre7jhb9MoBzIWHJmyAAMUo2nsbdJ6LEPDI=;
        b=p68Tx2INzL2LCfeAo+Ah/ECT1Y6fkuWczzZAZNiwWbKsPklZ5GEJoJRDU6gdjypsNy
         LEh5h6d9ROyQShNx+m6H6EdoVtd2pvuIcN5umVsD64YZCK2i2Cqhv019NfwCNfbLnthp
         E5azYG7Ud02+C7621L0dy+0w0NB/evjMkruljxfbkEXIzDJqBFw/Ib0oiJDYhCMXucXe
         k5//NzhzdH7MmPhSiQ0s1GeLXlWCtD1isO7ahU6WVgGWBHjDC6+ZUoj7MQhNpeUtFgpU
         xF9dQ2bMP3mgOEi6mpjJyeeTcAzRxzUItIx6ESzpZCm6dTdULB6RPjJ4Z4VBD0LmhCJ1
         X8ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1LhwbybOGre7jhb9MoBzIWHJmyAAMUo2nsbdJ6LEPDI=;
        b=ZHZzXGNw3hz6zl76rHF1ts1ucSxqjkwSdEWJ9aVux0rFoYCUdoEUUAlUQSlbXdXiek
         TXHOUCnY7qk+BJAV72Mb53pBVLJX6mIgqqiN5lBW+1bmW4oT3qW0G8PI47B0vwkPvJuG
         65vkIluNwDGh4aTmrLjWjRl2s62WAome7eZdrAaP3i/kR7uVEyGwg8B1VQfT/8IjPdWg
         Q2qAmAm1YynLmc5ZY5ZwGGxIpROAFH/sKNlsgVPULQ7Ilm5a+gt2Wz+jcZNfDn0VIACD
         H8iffJzCHH2AmXsnTn1FcPh8Qwj1y7gGpcEopmYbWZIlDMLEDVnqd1iv3oz5t7ag8g9X
         77CQ==
X-Gm-Message-State: APjAAAWmKDBF6YMHdKdh+71ctUg6AL8ym9lxj3UaLu+6h3yxhOUtUjdQ
        AJ6tm8bqaechNaXS1LSbitU=
X-Google-Smtp-Source: APXvYqyV/tQeJFgCQZnuwWh2X7e5VUP2qfLJEzcAR283FEg7rszD4Y2qfxkGMupe+sfEy1sNjigoPw==
X-Received: by 2002:adf:efd2:: with SMTP id i18mr3932710wrp.145.1562838039741;
        Thu, 11 Jul 2019 02:40:39 -0700 (PDT)
Received: from gmail.com (net-5-95-187-49.cust.vodafonedsl.it. [5.95.187.49])
        by smtp.gmail.com with ESMTPSA id j10sm5005385wrw.96.2019.07.11.02.40.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 02:40:39 -0700 (PDT)
From:   Paolo Pisati <p.pisati@gmail.com>
To:     --to=Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] bpf: bpf_csum_diff: fold the checksum before returning the value
Date:   Thu, 11 Jul 2019 11:40:36 +0200
Message-Id: <1562838037-1884-2-git-send-email-p.pisati@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562838037-1884-1-git-send-email-p.pisati@gmail.com>
References: <20190710231439.GD32439@tassilo.jf.intel.com>
 <1562838037-1884-1-git-send-email-p.pisati@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>

With this change, bpf_csum_diff behave homogeneously among different
checksum calculation code / csum_partial() (tested on x86-64, arm64 and
arm).

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f615e42cf4ef..8db7f58f1ea1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -1990,7 +1990,7 @@ BPF_CALL_5(bpf_csum_diff, __be32 *, from, u32, from_size,
 	for (i = 0; i <   to_size / sizeof(__be32); i++, j++)
 		sp->diff[j] = to[i];
 
-	return csum_partial(sp->diff, diff_size, seed);
+	return csum_fold(csum_partial(sp->diff, diff_size, seed));
 }
 
 static const struct bpf_func_proto bpf_csum_diff_proto = {
-- 
2.17.1

