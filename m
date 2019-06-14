Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EB345758
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfFNIUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:20:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38124 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfFNIUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:20:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id a186so976193pfa.5;
        Fri, 14 Jun 2019 01:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NpCxj9FcXnz9ZeL717BMMIHVMfwWmqjUQFeorp7LQqw=;
        b=MhRkPIYJjLIHjySiagHfnKAExWNBYElBP2jLEE5fTrlOysSIFjCt9g0gJ1dMZx/nXO
         s03MImGvldn0vnXcsaf8dEaUqKXSB4m3x+DueiDgHAoFa3ePMLaam7+pmjNLSJ5Awh7x
         rmUtFzJ7Zl0M0SCTTEz8d8ZlSUGnoJefeKJp1gapSAexBzQbXNpS+4C2jcV72C9rmKLH
         QJYEgh8EVmJ6SHVQ4KElz5hw03tgSqCGB/4gviLjOREFHz1h6TjRnRv3J/51fimSXZ1f
         Am1TbrXiY4f282ihYt6cXeyBHD9hNhhWjwGvUQ50iD4m0NR6E87XxLdpe6lJjFO9TzbB
         QsFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NpCxj9FcXnz9ZeL717BMMIHVMfwWmqjUQFeorp7LQqw=;
        b=LD4eKdezqr8Trkh6Yh0Q/mP6Z5ZlTlPCLXDAuoXxDC4kTeDI0EmWwvJq9YLTxqdAEy
         iXy+bm0AO+QDRfxq7l0S/elL+JJZhvhDjKP7Yic+dx9EcTBAAzV+mfkmAnhJidgNr4DD
         ToqMLnfJeKTFQrMdiiMNzMiXaIm3ZTMhYq1SwBOC+zc4L87J6ZHm15TQBAc5424iwDXg
         Y3eV+kTnNQ9/2SJz9ZZXMMNggvE9s249GgVMR9cGVClnY1JSdQf5OTJ10JQDqQt1s45Q
         hbrKrot3dGWnq0kHlEXfOwL1xe0BYD5EbzwSPe5BajSFdjiByEwrtKAYi/Cd9/4p9hws
         GDTQ==
X-Gm-Message-State: APjAAAVVpzMoZevKTsatXqGVcuwRDHXqcFbnb5EmIC2d18NBF4gdMGLj
        jiAlqUmog15yxYLSk6+p2S0=
X-Google-Smtp-Source: APXvYqwCWiSYEHEhz7eHwJEhiPtR0bPC1xiSV3JkKEIwNH+XGQt6bZ6kVNst7EuyRQOHMctzI6T/8Q==
X-Received: by 2002:a17:90a:628a:: with SMTP id d10mr9754676pjj.7.1560500430507;
        Fri, 14 Jun 2019 01:20:30 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id t18sm3352343pgm.69.2019.06.14.01.20.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:20:29 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf 1/3] devmap: Fix premature entry free on destroying map
Date:   Fri, 14 Jun 2019 17:20:13 +0900
Message-Id: <20190614082015.23336-2-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_map_free() waits for flush_needed bitmap to be empty in order to
ensure all flush operations have completed before freeing its entries.
However the corresponding clear_bit() was called before using the
entries, so the entries could be used after free.

All access to the entries needs to be done before clearing the bit.
It seems commit a5e2da6e9787 ("bpf: netdev is never null in
__dev_map_flush") accidentally changed the clear_bit() and memory access
order.

Note that the problem happens only in __dev_map_flush(), not in
dev_map_flush_old(). dev_map_flush_old() is called only after nulling
out the corresponding netdev_map entry, so dev_map_free() never frees
the entry thus no such race happens there.

Fixes: a5e2da6e9787 ("bpf: netdev is never null in __dev_map_flush")
Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 kernel/bpf/devmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 1e525d7..e001fb1 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -291,10 +291,10 @@ void __dev_map_flush(struct bpf_map *map)
 		if (unlikely(!dev))
 			continue;
 
-		__clear_bit(bit, bitmap);
-
 		bq = this_cpu_ptr(dev->bulkq);
 		bq_xmit_all(dev, bq, XDP_XMIT_FLUSH, true);
+
+		__clear_bit(bit, bitmap);
 	}
 }
 
-- 
1.8.3.1

