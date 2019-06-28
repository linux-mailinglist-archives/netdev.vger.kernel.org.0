Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72359701
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 11:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfF1JMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 05:12:47 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34014 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfF1JMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 05:12:41 -0400
Received: by mail-ed1-f66.google.com with SMTP id s49so10077949edb.1
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 02:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=xUkl3qHWD8xZmbOfiby5T9gO2zLEB0xX30U5WvG9/RM=;
        b=O+RfylBIsu1+E4Ni4yqP3dSq8ZAJs12Vgc3ewHBBDeqvPVvyqLPi7pKsoi3lPOx2cL
         Dp4pt2y8CjAA+z4mlz+eV+VgutTlmrHo72f3uj2KMvcP3mvoiANVYY48Q/nBpYrFiVku
         2c801lo+V1iytHW/lJpGyLFOtw5/nJuegs2Nou78UbQaN9U49PjNa9YsID1VfC3MF2WJ
         us/gvZ5UukF/e4NQ2eKd8X0Dq6BF08rO8RjjxOa9XCeyNik3h3FmopsP0UEYwCckt8pO
         vq7B/aQozHwWkZlRgZCBWB64l5i9edM2MVCxwb5+2oQAO/YlLRCjk/Oqe5DsDRp/MCAQ
         VnEw==
X-Gm-Message-State: APjAAAWDK15PUhRHZGOKQDpeKFDUk6KHjTw2q9Yt/d9pkMyqEw292+z+
        mlE/bWWJtzzQ1u56qrhffedE2Q==
X-Google-Smtp-Source: APXvYqyHNIZDMclQVQNPtoo01Z8Cta0RUUa/ARGAIVTlKlLwGoL3q+9hgKDtMSs99Phwxo6UaJ3OFw==
X-Received: by 2002:a17:906:7541:: with SMTP id a1mr7539338ejn.50.1561713159861;
        Fri, 28 Jun 2019 02:12:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id r44sm511414edd.20.2019.06.28.02.12.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:12:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1225D181CC7; Fri, 28 Jun 2019 11:12:35 +0200 (CEST)
Subject: [PATCH bpf-next v6 5/5] devmap: Allow map lookups from eBPF
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Fri, 28 Jun 2019 11:12:35 +0200
Message-ID: <156171315501.9468.6602722652840352230.stgit@alrua-x1>
In-Reply-To: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
References: <156171315462.9468.3367572649463706996.stgit@alrua-x1>
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
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/devmap.c   |    5 +++++
 kernel/bpf/verifier.c |    7 ++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a4dddc867cbf..d83cf8ccc872 100644
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

