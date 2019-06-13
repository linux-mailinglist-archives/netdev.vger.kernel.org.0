Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 662E443B96
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730250AbfFMPaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:30:09 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46823 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728833AbfFMLRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 07:17:25 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so7303071edr.13
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 04:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yfTJgJnSi8sErjmJq1NccETIfiApIYqqUsYmDF8Tess=;
        b=lSy38j6zeQEm5Rl70ftHHUixohIbG19XwaE1JxJ06/y6fMaUFiUD9wi5Xyj317hV7l
         jcG1acs5gCFNntbwr1k3kLDmob64Y1ZYf6qk+oYcCPP4C0PualJq2m6sTJ2A07qCmzx2
         GivYkzUiCA3LhArAe+uK4qjL/InYGPWIa2fl/IImP72C+vzenIuDTtyyWje/MC1RZRRr
         XchlqeCSXazB4XkRtQMHPoEdC1HJ9sj2mOBx1Y8doRY39VS9QZxgG4PDvOTYCvuu8OLH
         NpSVxZcCse0ilW89E1+TCXX77JguR3MOHuxyHJgjY0YPZgpIJGaYCdY3bu3bUcK2Dx7e
         t83w==
X-Gm-Message-State: APjAAAX+DmQYVJNXxRdRwooEl/LnMP2QKz/mK+a2pfWyU/R27aXNX3nK
        Si0FCfZ2kxS61lRwWgJt4wllsQ==
X-Google-Smtp-Source: APXvYqzL9U+v+RQWrRNZypKvsYL73LtbjDZZKefRJrTKAa4xALzW6K8LjYt5y8NdcsM4SftDqi46YQ==
X-Received: by 2002:a17:906:3102:: with SMTP id 2mr76343493ejx.304.1560424643632;
        Thu, 13 Jun 2019 04:17:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y11sm501558ejb.54.2019.06.13.04.17.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 04:17:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ABCE0181CC8; Thu, 13 Jun 2019 13:17:21 +0200 (CEST)
Subject: [PATCH bpf-next v4 3/3] devmap: Allow map lookups from eBPF
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Date:   Thu, 13 Jun 2019 13:17:21 +0200
Message-ID: <156042464164.25684.10124291261871041128.stgit@alrua-x1>
In-Reply-To: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
References: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
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
index 5cb04a198139..09a5bac310b6 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -98,6 +98,11 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
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

