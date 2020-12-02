Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403992CCA09
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387742AbgLBWzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387665AbgLBWzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:55:13 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01577C061A4B
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 14:53:59 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id b10so2202803pfo.4
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 14:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tTNYrn4xDC+1b8MnNoT1J4xKmUKcP9Eh5NPYTUnTJa0=;
        b=pSWrKgeM4a2J7yDfcP1bJLvRANonp9ZNkbwuyL/a1ZVoJgMyb/F0FtVGrGUqbwv5iA
         vSdzqObjg22WvidLN0C/1tUEC8tz+hn1A4i2l7bdM2ncRGswL1tSaSvNZxfMUylTDfmF
         56hFJjpoHe/LTZbXxsYK9mAGxNvI8XC/2GYLSSrtFXlrxXgB540FWhQFUzfbuQxHk10i
         42K0i3+5zMhVbif+n6xPB05KpO7SLeyY1qTYBpJrQf/37+OchdUv5JhPYucyXHH7S2q4
         fJ5ImHDUky/2neI0oAWuU07iqHAIXtemMEIBdH72rUkzUbjdNQSBgsC0Xi7Gx5p4lEfE
         Tvrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tTNYrn4xDC+1b8MnNoT1J4xKmUKcP9Eh5NPYTUnTJa0=;
        b=HTeDNcogpwqzf0B1I4JTlsMtJU6zOwtG4/Cy7MblUvPL6nc2nnOpwUuD5fa693dXBD
         NkW2Q2XVD+fWQdZ0km6Bcd3MovCfCVwwS0FYCTUopAc+sJKSKD7FS9MuUd0gfGPs8OCJ
         lwotUoybwzgsWOhh/sL0Ou/+tQ1k5V8XUzyLoJ5CKxmwU6Add0wpeu6i4ID3KcMF9VfB
         mu0l/b3w3nY5Ll94ZSL0W4yC7YTlrIkcWyt2wIsJxPudHaJDL9nmgJHdKJmCWx5Fjbb0
         +LZFDtYTE+YN0bWK7T2Fm6E+ElfbKbaB0SsvDQHA2bRfl1FdiITmjEkvdOV0npnT1RT/
         8PnQ==
X-Gm-Message-State: AOAM531t3q97FZBByQ9I5Lf4GPTk1HTS9fV77EnXdDdJYshbFuIqdt4g
        NWz/13O4gOeioMAMX20VImQ=
X-Google-Smtp-Source: ABdhPJwvorPz2AGpeYt4WLp/V45wbXvCzd1VnVGY+5PV3OoxTeEUGQir2ljh82B3OMU3hqfFCzjgrw==
X-Received: by 2002:a62:88c3:0:b029:18c:3203:efb7 with SMTP id l186-20020a6288c30000b029018c3203efb7mr426484pfd.33.1606949638634;
        Wed, 02 Dec 2020 14:53:58 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id i3sm39962pjs.34.2020.12.02.14.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:53:58 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next v3 5/8] net-zerocopy: Fast return if inq < PAGE_SIZE
Date:   Wed,  2 Dec 2020 14:53:46 -0800
Message-Id: <20201202225349.935284-6-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
References: <20201202225349.935284-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Sometimes, we may call tcp receive zerocopy when inq is 0,
or inq < PAGE_SIZE, in which case we cannot remap pages. In this case,
simply return the appropriate hint for regular copying without taking
mmap_sem.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>

---
 net/ipv4/tcp.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4bdd4a358588..b2f24a5ec230 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1889,6 +1889,14 @@ static int tcp_zerocopy_receive(struct sock *sk,
 
 	sock_rps_record_flow(sk);
 
+	if (inq < PAGE_SIZE) {
+		zc->length = 0;
+		zc->recv_skip_hint = inq;
+		if (!inq && sock_flag(sk, SOCK_DONE))
+			return -EIO;
+		return 0;
+	}
+
 	mmap_read_lock(current->mm);
 
 	vma = find_vma(current->mm, address);
-- 
2.29.2.576.ga3fc446d84-goog

