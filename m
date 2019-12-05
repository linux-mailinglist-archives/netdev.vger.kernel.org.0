Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014E111469D
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 19:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbfLESKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 13:10:20 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:40055 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfLESKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 13:10:19 -0500
Received: by mail-pj1-f74.google.com with SMTP id x16so2169385pjq.7
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 10:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=P4I/nkpJOW8JK0ykr0uuzKPWgJV+N45iGkD0NoNPq9M=;
        b=JVVoZz9AJZBnnpxZKI3HCgcGKm4wbrH5K97s/DmJ9yntEejBPlYzAs7bVUhtXXOTsZ
         WBIKE5DFCKqfYBK2KI6mVQu+pUKlXUskr/30t/aVem+NzyvBk8neVJQqV0Q95aVor6Br
         1ep9cW8jBJ+Ergyo1TWeeQk8nBVPkHxS1BG84JYHjgPFk2D6EKpln5YgnhbmYRpYYFTh
         Kr5c5TYYUTy0gUbXVFJDTVh1HfMkL0UUufUsoR24kOn6IrXSbONnk7QCSho9okQMl9dx
         tTcQO7ZRz31JjcNLxOKK0KsV6/Eiwp70DMICtzYMxKKaJraPJicbsH9SqbZeRjd/VVV5
         Sv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=P4I/nkpJOW8JK0ykr0uuzKPWgJV+N45iGkD0NoNPq9M=;
        b=i0sF+fXR1XE4l0PA+u29vmzDEhnHS4smctIfzgB5aKCNrNXma6SSYZIpvPqaFYEwUz
         oBICgdpk72+33fjGdT3gGDdICpCqk8kSdpmDVTsENTp6afG1v/qOOB66NzkjadU0f4cs
         FzoIZR9VXbB59jpJfSPVXEMkZ5Wo+9WaVJUvgzKK/uBaFs7Nn1BgyN8psQgg32KD1201
         YQ0umNDiySpesvmKTDhKOikRgBqOh5oFxdhs/Gdly5Y8re/gHdDF6FtFbsYdhYTq+p98
         THXodEH2SLwbeVqikqSW6vDK0rSAk1VGYHlfAipRMdqxCk0WFysWPWKqjzP3+qvspG8h
         lQgQ==
X-Gm-Message-State: APjAAAV3K4gO6CLPMD50OBNf+CLbN2kAXULtAE8d/w8q4luuq7Adz7/I
        r53jVNB40hkgDX95VayweA3ZdnF4vNnDHA==
X-Google-Smtp-Source: APXvYqw6dcBMVAyHvIIRs/mZaG86BTahC+Pmw1TZO1skKyqtfFx+PwIw+gV1S0t/os6e2cCvflhvHomkzZxGeQ==
X-Received: by 2002:a65:4587:: with SMTP id o7mr10605418pgq.303.1575569419102;
 Thu, 05 Dec 2019 10:10:19 -0800 (PST)
Date:   Thu,  5 Dec 2019 10:10:15 -0800
Message-Id: <20191205181015.169651-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH net] tcp: md5: fix potential overestimation of TCP option space
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Back in 2008, Adam Langley fixed the corner case of packets for flows
having all of the following options : MD5 TS SACK

Since MD5 needs 20 bytes, and TS needs 12 bytes, no sack block
can be cooked from the remaining 8 bytes.

tcp_established_options() correctly sets opts->num_sack_blocks
to zero, but returns 36 instead of 32.

This means TCP cooks packets with 4 extra bytes at the end
of options, containing unitialized bytes.

Fixes: 33ad798c924b ("tcp: options clean up")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/tcp_output.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index be6d22b8190fa375074062032105879270af4be5..b184f03d743715ef4b2d166ceae651529be77953 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -755,8 +755,9 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 			min_t(unsigned int, eff_sacks,
 			      (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
 			      TCPOLEN_SACK_PERBLOCK);
-		size += TCPOLEN_SACK_BASE_ALIGNED +
-			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
+		if (likely(opts->num_sack_blocks))
+			size += TCPOLEN_SACK_BASE_ALIGNED +
+				opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
 	}
 
 	return size;
-- 
2.24.0.393.g34dc348eaf-goog

