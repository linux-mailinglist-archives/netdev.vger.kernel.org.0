Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06E8CDADF
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 06:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfJGEKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 00:10:09 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38353 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfJGEKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 00:10:09 -0400
Received: by mail-qk1-f194.google.com with SMTP id u186so11377185qkc.5
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 21:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Um9IjDLXf7mu36AVuJojjGCX9zVj1fqdU8QSd2qVozw=;
        b=NY3n3wSkpC6+t2kT9GrVXWuDTyQrVZM/XfyPRI+WKhhUFb1zZGepNqoCINzryG1pI+
         E8sQEFuseDvJwwbX7IX2PTaGZICTOvhNTnzF+C4waMO3VzUuBxjGDvPIH1Ar4VPRphyi
         A2fffQj3o9bznWlv/O1C26a5hgtECRFUf5t7YbOoxMs3HebLtD98e2vuHx5Q3el3ar6c
         iZuPE2qNlmbcN6p37Alf1r1/Md4qlZhlTYdtIBzoEoeDPFpCEqlP3Xkm+cp+0wQR2ZLA
         KUmO7aca7rBvUHneGZHZMcgmbA/U4AsFclStilXtLrJUu6zk+mWDO6e3lzA29W5x+Hss
         WMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Um9IjDLXf7mu36AVuJojjGCX9zVj1fqdU8QSd2qVozw=;
        b=BDJqEO82gN3SIke/z9j9MPAdy+7mf7bHh4WC+2++bD5qGl7nJSPVp2hZOIZqmdmFMC
         pD60jDsgz0ji95vQnypOnLN6BFHKf6NskC2yrwHlfdjKb3qXXUcgNjrEi1B9vRHMImga
         XIihCqF5Em/uWDqutEDeO6LIFG9HcD43aJ4ViKeYKS/N4iyBbbBKrd52bIpP6QTbfERn
         nE9Kj+4xuFcMK5GOieG7reIwfvhmVFREVkNopYB24PXLAD1gi0rJ5oRRhsejQ+zLSJ+5
         jg9wGoZbgTPziGrSvKlNURwJaeOkb6JfIYydUVQTjKRun6TuNfTYNyVmGt4sTvZKi7lk
         0dgg==
X-Gm-Message-State: APjAAAUmWU/8ORT5baFlMIz7lD4FDeaNE04ihSImtfjeVYIfx9Hq7DDp
        p1oGhzV+q5eKQSiQntE7ZuDcew==
X-Google-Smtp-Source: APXvYqwklkOWOihRNkQW+ybXlRKZGHsuAspZ2ZOTKKIDI4eQ9KT5yT5qKmSMkfFeSy9Us1Zy3Z/HRA==
X-Received: by 2002:a37:c17:: with SMTP id 23mr21067920qkm.159.1570421404504;
        Sun, 06 Oct 2019 21:10:04 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y22sm3796058qka.59.2019.10.06.21.10.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 21:10:03 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 3/6] net/tls: make allocation failure unlikely
Date:   Sun,  6 Oct 2019 21:09:29 -0700
Message-Id: <20191007040932.26395-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191007040932.26395-1-jakub.kicinski@netronome.com>
References: <20191007040932.26395-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure GCC realizes it's unlikely that allocations will fail.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index fcf38edc07d6..23c19b8ff04e 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -452,9 +452,8 @@ static int tls_push_data(struct sock *sk,
 	max_open_record_len = TLS_MAX_PAYLOAD_SIZE +
 			      prot->prepend_size;
 	do {
-		rc = tls_do_allocation(sk, ctx, pfrag,
-				       prot->prepend_size);
-		if (rc) {
+		rc = tls_do_allocation(sk, ctx, pfrag, prot->prepend_size);
+		if (unlikely(rc)) {
 			rc = sk_stream_wait_memory(sk, &timeo);
 			if (!rc)
 				continue;
-- 
2.21.0

