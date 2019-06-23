Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB0C4F982
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 04:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfFWCRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 22:17:47 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43185 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfFWCRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 22:17:46 -0400
Received: by mail-ed1-f67.google.com with SMTP id e3so15904508edr.10
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 19:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Dfn1lKEpj8iv27TQWSdz4HZzVtlIFBNXPE7robGPWzU=;
        b=Ucr6eE0CDnu2uGCmGfK3Lxxd8jAY0WxQCG7pVMaG+eAhXWnIM/1/VhK4sRplBwe0QR
         owa6eu9ZbHhWwoDR9yVcw7VkBeJ7pBGEsiQglnrM9LVswlRM0hT1cdjcZbOzUriabWrC
         FAvK3waKb4mO3CHwe5+8o19cY/a10C1AKo+1RPHKZFbRrGWJWUQEe39AGYHTW03HN/cA
         Wr4BjJfbJybJYCcQgKccmT2F583ORfEyD4h4HMIG9jzqXtEg5VVJmvgfyb26zwT3x7Hu
         Ykht7csMbvWIWNCPE/fzbXxzN6SOGoHKUjbcX3s7tKlxR0FQYxNgb1sdq7+UT4OHholt
         ZKyw==
X-Gm-Message-State: APjAAAWL5JrsntgcG2GGJnZiUnavl4oF8XijajUOA3enp2CUJDMgNQoN
        ybq7K7BDcKLywzeAMKRCPHTmV5I9yk0=
X-Google-Smtp-Source: APXvYqwepJv7dhdWlVFg9PIikeS0kIvQM7/Cl88+Ro6autzecHIhFFNienk7ohcWj/hlWxHnSNiv1Q==
X-Received: by 2002:a50:c351:: with SMTP id q17mr24486290edb.264.1561256264690;
        Sat, 22 Jun 2019 19:17:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id h10sm2363934eda.85.2019.06.22.19.17.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 22 Jun 2019 19:17:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BB74D181CF0; Sat, 22 Jun 2019 22:17:41 -0400 (EDT)
Subject: [PATCH bpf-next v5 3/3] devmap: Allow map lookups from eBPF
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Sat, 22 Jun 2019 22:17:41 -0400
Message-ID: <156125626158.5209.14261186257358121509.stgit@alrua-x1>
In-Reply-To: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

We don't currently allow lookups into a devmap from eBPF, because the map
lookup returns a pointer directly to the dev->ifindex, which shouldn't be
modifiable from eBPF.

However, being able to do lookups in devmaps is useful to know (e.g.)
whether forwarding to a specific interface is enabled. Currently, programs
work around this by keeping a shadow map of another type which indicates
whether a map index is valid.

Since we now have a flag to make maps read-only from the eBPF side, we can
simply lift the lookup restriction if we make sure this flag is always set.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/devmap.c   |    5 +++++
 kernel/bpf/verifier.c |    7 ++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 59113bb108c7..f75d992d466d 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -89,6 +89,11 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
 	    attr->value_size != 4 || attr->map_flags & ~DEV_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
 
+	/* Lookup returns a pointer straight to dev->ifindex, so make sure the
+	 * verifier prevents writes from the BPF side
+	 */
+	attr->map_flags |= BPF_F_RDONLY_PROG;
+
 	dtab = kzalloc(sizeof(*dtab), GFP_USER);
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0e079b2298f8..51c327ee7d3f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3407,12 +3407,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (func_id != BPF_FUNC_get_local_storage)
 			goto error;
 		break;
-	/* devmap returns a pointer to a live net_device ifindex that we cannot
-	 * allow to be modified from bpf side. So do not allow lookup elements
-	 * for now.
-	 */
 	case BPF_MAP_TYPE_DEVMAP:
-		if (func_id != BPF_FUNC_redirect_map)
+		if (func_id != BPF_FUNC_redirect_map &&
+		    func_id != BPF_FUNC_map_lookup_elem)
 			goto error;
 		break;
 	/* Restrict bpf side of cpumap and xskmap, open when use-cases

