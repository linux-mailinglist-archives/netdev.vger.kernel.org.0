Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD152653D2
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 11:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbfGKJb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 05:31:59 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37801 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727595AbfGKJb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 05:31:58 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so4975587wme.2;
        Thu, 11 Jul 2019 02:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1LhwbybOGre7jhb9MoBzIWHJmyAAMUo2nsbdJ6LEPDI=;
        b=jsS6iEzOtytBoOqSAZ5cOraY7/ePo0CkCqLcB/EWr/cfw1pzSS+7ubDAGGZ/xbdxWf
         XYVAKpylTAqSDxl7yOA+TVAwOh2HawvpiJ9MlPmJuQbpCj4GLR5dt4Azjiro58A91oGF
         lfUXEGJA51Gx0dGK7TG7sbo4VAr2hq+CrIOmA8Ps4JlWrBY6sike0VZ1oNGWtfl1Qi1E
         hcl4D0gmfLQO7PxOW72X1JmaF4IAIM3KSTGQ/rjUy7Eyh6w7yDv//RyWLjtVcrh5DC2R
         hQQ5NMJI8KeDogbPLXGqJC2WK+mvLt20F6k1nVGfVhwK+JTYUhFJkLPdkBp55f1XK1x9
         41jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1LhwbybOGre7jhb9MoBzIWHJmyAAMUo2nsbdJ6LEPDI=;
        b=hRzAp6cTwLSxLQWzLsJunKKEwpzi7yIODrTR5gLEsj7SXpQcdsfV5RWWYyNPkyTtks
         OiM19R2TtjGqCRmyo1qNKuuJUe8otq30YDn3qBP8c6OU6vtUWlNiayMNr3sWOCjC0OLE
         ph/WnL/JyKn0G8m+mLHYhfsoWsviK2gaoHcszBXDaz+H9tf2RlD3HT2LgO37XkcA3Dpg
         LhZmb0Ju45yI71lgnok1JcHiYqZJwaH1C/4g2Ch6UvMpF9RYEoAtsFLD2akr3kVJEge8
         q90DlUA27rcipR6eTWo53Ljv5L6SzigHGOqf37VkHnJEOJ5v/tW9n3K1PlLc/OHTfTEy
         udaw==
X-Gm-Message-State: APjAAAWWe7ccSIXQDRW8TRCv2Ew3hayEZNGIqgUMLKW58f8eQaYBZvl8
        GKw8OJgrrf0t+sLDmpvXHk0=
X-Google-Smtp-Source: APXvYqyf1KBCXWmcs4e9KK6grFxCC8E+4DCtk19VvviFmeqXyjCavihr8fWs6O3L/pEGYK8ii+HVZw==
X-Received: by 2002:a1c:305:: with SMTP id 5mr3306664wmd.101.1562837516292;
        Thu, 11 Jul 2019 02:31:56 -0700 (PDT)
Received: from gmail.com (net-5-95-187-49.cust.vodafonedsl.it. [5.95.187.49])
        by smtp.gmail.com with ESMTPSA id y6sm4997438wmd.16.2019.07.11.02.31.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 02:31:55 -0700 (PDT)
From:   Paolo Pisati <p.pisati@gmail.com>
To:     --in-reply-to= <20190710231439.GD32439@tassilo.jf.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
Date:   Thu, 11 Jul 2019 11:31:52 +0200
Message-Id: <1562837513-745-2-git-send-email-p.pisati@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562837513-745-1-git-send-email-p.pisati@gmail.com>
References: <1562837513-745-1-git-send-email-p.pisati@gmail.com>
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

