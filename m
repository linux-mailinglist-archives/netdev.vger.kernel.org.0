Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76DB2E00EF
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgLUTZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgLUTZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:25:51 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EBAC0613D3;
        Mon, 21 Dec 2020 11:25:11 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 4so6119814plk.5;
        Mon, 21 Dec 2020 11:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rgVexWO89fCt9Azriz+azlsgzrNkcgjEEvrNcljJLdA=;
        b=en4a1uP5UYq+sYyw/M7tm/rDX16KTnM0tAki1mPSWjtMAe8hm5lqWVbobV7VTHLpP7
         g6n5yXMEmlIwTbrv6wGU9M5KFjVny28uIuAD3kHviO8QdaEJyeDREdR2j+1HvxkzpQoW
         p6bcaVzGIfLqB0CjgA9AOn5ZHy3dB5BXe+THwXJayTntWJLIZNmk7K5nbBrJI+Ldyugi
         eB96iQld4mZqZmyRe3w+Au1jSlfJqY6csK/EKDAdBG3NGumF6JnPxoRV4587LWYTDdF9
         Eh3sZm8id0UET1OA1fMRne8ArIjW4ioAQs6umZtGaHNOL7GA9DKwnnkEkePJ+ESytY6X
         I1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rgVexWO89fCt9Azriz+azlsgzrNkcgjEEvrNcljJLdA=;
        b=ND3BKPgbgnqdU3+mSEKTmVMAerIoY48+/x2u1NVdulCrQjofNT/yZbdWpB1STWvgw6
         I8KaE4osBX84b4VlQIXTNkP48irOVKp68OdWEkr0/dGq667SxwZrrjF7MV5mqC8qk8Pw
         o+frDcvH96H5i2M6w0mKTuC+okHxYVWBn2vz03ILCrDBWORaoitTImM6/LNgUK/m75Ar
         g2XlmCUdab5EYTCKrHvIP0uCVpyqRoYCBuI3NBDW0nDWW6AyHx1lR5j/vzLr9ytaax5E
         Tj7qVSOlhv/7g/5QDy71zCH4UuPcfsrBV9pMhs3hxBgGOljIoAaPJtIVCqOJIl+bUpSk
         0glg==
X-Gm-Message-State: AOAM533RrSljJLeb/QxvgQ4cBsjTtupeen5Bfaxnz0LovCzdkbWjL4fS
        d7qboDwmbWfwj1hw43cp6Vk=
X-Google-Smtp-Source: ABdhPJw7XEmBJaWAsQtIQaFO4QlYH+q2tg3hTOh8rNcWGvLT/vtieNtt4kAhfFarECPVEoYaYMw54A==
X-Received: by 2002:a17:90a:fa18:: with SMTP id cm24mr18462825pjb.220.1608578710882;
        Mon, 21 Dec 2020 11:25:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id f29sm17592370pfk.32.2020.12.21.11.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:25:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, John Sperbeck <jsperbeck@google.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH bpf] bpf: add schedule point in htab_init_buckets()
Date:   Mon, 21 Dec 2020 11:25:06 -0800
Message-Id: <20201221192506.707584-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We noticed that with a LOCKDEP enabled kernel,
allocating a hash table with 65536 buckets would
use more than 60ms.

htab_init_buckets() runs from process context,
it is safe to schedule to avoid latency spikes.

Fixes: c50eb518e262 ("bpf: Use separate lockdep class for each hashtab")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-By: John Sperbeck <jsperbeck@google.com>
Cc: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/hashtab.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 7e848200cd268a0f9ed063f0b641d3c355787013..c1ac7f964bc997925fd427f5192168829d812e5d 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -152,6 +152,7 @@ static void htab_init_buckets(struct bpf_htab *htab)
 			lockdep_set_class(&htab->buckets[i].lock,
 					  &htab->lockdep_key);
 		}
+		cond_resched();
 	}
 }
 
-- 
2.29.2.729.g45daf8777d-goog

