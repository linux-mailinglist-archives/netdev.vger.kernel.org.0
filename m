Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6564BB5FE
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 10:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbiBRJ4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 04:56:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiBRJ4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 04:56:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D966474;
        Fri, 18 Feb 2022 01:56:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso8003575pjh.5;
        Fri, 18 Feb 2022 01:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qwkURTc3mVsmS0YKMRnLl7jTAZ2rVdZJklRZiSwmcp0=;
        b=AsqTmn+969pdSiMz/GFCPWU8X5b9fRiAsFNJPy4qgimVMRBew9NrrDuBqjwkJr7VbT
         VPr/Tx4WVie9RORZtNldVJhggr7sdA6/iJDf9aKp+vxm4LrtQHVDj7N4OIp5fxiuQMdo
         aqX/qJC6DR5+oGXA39SGe60Dsu9vnGYoK1/NZsbP9MPosU6G9CQqDIgDxU7JpLlLvkq/
         b8uhRY8bK3kB+FLfRGpMI9zWOSN3xBlNeFTay0N+wX9/WPClZDckLiyrDCuERuHrsVF+
         KcLOm4Ei818qrtZiXezQYA61+I2QzTZHuL+T0VVc/041cOYxKYhccP7fjJ/NQ6UEf2zN
         uKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qwkURTc3mVsmS0YKMRnLl7jTAZ2rVdZJklRZiSwmcp0=;
        b=3G8Zr9oJ8UeRo03hvl/qV/UxeMwtGS4ouon6w8Y4TaiAAk90WvQZShLxBP27FLgGbV
         cWr3B+zJ/zckIrGgGFUfrdgc/iySPOujndwIM13GM+d5b7UiuCbji3HR1vndLb//9Ytb
         7LVI9cXhiDkYMoMIqw+SZ8Xv1YmO/RegVZDIygcIGAZLUFMt8NxI4OmhYomBdfF+hQQu
         CTL6X38WnElja9oqUzGV6CyYNPFg/F8kKpQ54Z+d4VNj07om6FjeKJvCTNH1fbjCJ+5o
         deHSDOrmtzFY6BDE5zEEm5P2C6sFFgFu6Wi+Zq8056It4Gzf7SdzNHLy5j5vLKI4VCdI
         6qig==
X-Gm-Message-State: AOAM530vVBjGuQ9cGe+vw5WEdLjPMefOAe0PQFyG62I+sJbg0p1hqvsG
        lTH4bdMZWFxZaeX1UDhKqKE=
X-Google-Smtp-Source: ABdhPJx6mFozKohOhJDg8NUeo/iz2JWVC1MeGIGLsXSm4L3ASmVY3mEFL+5cAmXoBA4v/raDni3wsg==
X-Received: by 2002:a17:903:1107:b0:14d:80cb:da8 with SMTP id n7-20020a170903110700b0014d80cb0da8mr6623836plh.62.1645178187017;
        Fri, 18 Feb 2022 01:56:27 -0800 (PST)
Received: from vultr.guest ([149.248.7.47])
        by smtp.gmail.com with ESMTPSA id t22sm2750430pfg.92.2022.02.18.01.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 01:56:26 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 2/3] bpf: set attached cgroup name in attach_name
Date:   Fri, 18 Feb 2022 09:56:11 +0000
Message-Id: <20220218095612.52082-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220218095612.52082-1-laoar.shao@gmail.com>
References: <20220218095612.52082-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the cgroup path when a bpf prog is attached to a cgroup, and unset
it when the bpf prog is detached.

Below is the result after this change,
$ cat progs.debug
  id name             attached
   5 dump_bpf_map     bpf_iter_bpf_map
   7 dump_bpf_prog    bpf_iter_bpf_prog
  17 bpf_sockmap      cgroup:/
  19 bpf_redir_proxy

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/bpf/cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 43eb3501721b..ebd87e54f2d0 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -440,6 +440,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	struct bpf_cgroup_storage *storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	struct bpf_cgroup_storage *new_storage[MAX_BPF_CGROUP_STORAGE_TYPE] = {};
 	enum cgroup_bpf_attach_type atype;
+	char cgrp_path[64] = "cgroup:";
 	struct bpf_prog_list *pl;
 	struct list_head *progs;
 	int err;
@@ -508,6 +509,11 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
 	else
 		static_branch_inc(&cgroup_bpf_enabled_key[atype]);
 	bpf_cgroup_storages_link(new_storage, cgrp, type);
+
+	cgroup_name(cgrp, cgrp_path + strlen("cgroup:"), 64);
+	cgrp_path[63] = '\0';
+	prog->aux->attach_name = kstrdup(cgrp_path, GFP_KERNEL);
+
 	return 0;
 
 cleanup:
@@ -735,6 +741,8 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	if (old_prog)
 		bpf_prog_put(old_prog);
 	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
+	kfree(prog->aux->attach_name);
+
 	return 0;
 
 cleanup:
-- 
2.17.1

