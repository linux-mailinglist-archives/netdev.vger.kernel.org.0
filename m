Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E83E37514
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbfFFNYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:24:18 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42200 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFNYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:24:17 -0400
Received: by mail-ed1-f66.google.com with SMTP id z25so3294710edq.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 06:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZLOnqOQOn7yVGMMSF2Nh8xUeM9eyb4HUL/9Xvzm3css=;
        b=QxMPNqcWqOQ6KPwwpAxhS9EXmQ1ZJRa+zfXUQSTy0RU4OkkJYPhEBInsjehdCaR9zR
         xbmSvh4Hnjf2ujvzGUHA/hnUiG/NyuRSePmNBUD1QJJ7Ry919PLk/CLIiWJ2saNvjbdb
         sJztQTFbHemKLezUbbhsxybk6UG5d6WiyBhKBoBKuly3Qh4AfC8zgemqQoI4t+HCY4nI
         EMs54va576mh0FUSGeyqx5N360yx+qKMbzmiBUuY0NKF5VR1F/2Erq4W+pBT84w1N86R
         rSoW0ArWpxTqrCMZerXMYPhz427+dnSvz5piltTD50bz60mH917fbMxaz60xPOkfUJXh
         p0Tg==
X-Gm-Message-State: APjAAAUv1PeYzJLfKVGIMmNrafjVK4pZ6P3jroHkCwjGajQ+x4dHy9u3
        FKQxRLQBje3Uy0re4FqeOCqnloygOw8=
X-Google-Smtp-Source: APXvYqySDst7LtBMFWXNdEWxZbgPljIpOf6zrSu7mJ45QSyI66kU3uH8816YFJml6TqeSaweghcmmg==
X-Received: by 2002:a50:cac9:: with SMTP id f9mr19484545edi.51.1559827456074;
        Thu, 06 Jun 2019 06:24:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id w21sm334887eja.74.2019.06.06.06.24.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 06:24:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B1688181CC3; Thu,  6 Jun 2019 15:24:14 +0200 (CEST)
Subject: [PATCH net-next v2 2/2] devmap: Allow map lookups from eBPF
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Date:   Thu, 06 Jun 2019 15:24:14 +0200
Message-ID: <155982745466.30088.16226777266948206538.stgit@alrua-x1>
In-Reply-To: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
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
index 5ae7cce5ef16..0e6875a462ef 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -99,6 +99,11 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
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
index 5c2cb5bd84ce..7128a9821481 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2893,12 +2893,9 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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

