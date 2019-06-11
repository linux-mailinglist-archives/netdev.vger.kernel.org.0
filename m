Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C0B3D12F
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391782AbfFKPoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:44:04 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34633 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391768AbfFKPoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:44:04 -0400
Received: by mail-ed1-f68.google.com with SMTP id c26so20815713edt.1
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 08:44:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tIFdrPQclIllmAlJRGBLfGQJCyPZfDYDV/gF2nBZUBo=;
        b=S8NkVjtOXY0rINOHyNlOqS6yGS9ks4CXy+DXaFV2rM5cAU6lpvWBgfnPFGd2r1qNUz
         Bsjmur4a38NHfhzH/xtIEIF0R7UacNn+N4PMahYy2d+5NhnSF73syXvaKs0QLBIenscy
         c7J/8KbrjRLHQBqfElU2ROyH0tkvCe+Q4lBM9xmoBwgtibxgc0sODIBf3kxjy0lcrpjG
         AR3OzaOEyH8ns8LKlhZjPwmqLWwkvzm3rw4r83YfL+9GEAfGxru8OdQSV6Ixhck4CjRm
         erjFuLZ+FzXhILfEmyNVqRK6DDKOoE7fMvtbh+T/cRwDKEhkSPkkImsa/lnragIIWanI
         NIYQ==
X-Gm-Message-State: APjAAAXBFYb+7GD8PpT29McriwXOgsSg848vaQAuLcJJBrpLSHS5jSrb
        A6X3AGf3MlzyRMI0QZXca0GXcw==
X-Google-Smtp-Source: APXvYqxX/6tZM8Ct7ysechjjJ2EL7jivaeDwhhG4BIo/21Orx+FjbdTy8l324gi9wqTEzdSZ6e3QXw==
X-Received: by 2002:a17:906:cccd:: with SMTP id ot13mr17096085ejb.37.1560267842465;
        Tue, 11 Jun 2019 08:44:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id r23sm1913586ejj.75.2019.06.11.08.44.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 08:44:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3A87D181CC8; Tue, 11 Jun 2019 17:44:00 +0200 (CEST)
Subject: [PATCH bpf-next v3 3/3] devmap: Allow map lookups from eBPF
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Tue, 11 Jun 2019 17:44:00 +0200
Message-ID: <156026784018.26748.12066708200377212358.stgit@alrua-x1>
In-Reply-To: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
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
index c945518225f3..83c77f43030d 100644
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

