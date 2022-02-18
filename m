Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4084BB5FC
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 10:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbiBRJ4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 04:56:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiBRJ4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 04:56:44 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744496366;
        Fri, 18 Feb 2022 01:56:28 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id om7so8088844pjb.5;
        Fri, 18 Feb 2022 01:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W/khSlDMF8Z5nH/DIhbMkSDcNIElSCZv9aSrQuDBt2A=;
        b=HZnNKMMLbNCdDgqAoAeFC/a0LMfKTWEqPHm035xs8Wu9ydkR3DYgM10Taqtxcif5WI
         B/HZRgzvUHZWrUav1NOhbbhEoaejkhV8OHkyucnJLk7/j6bgkaLpDUbn8cQdBagGRBG9
         8jbmAXWnJSf1bH2ayU3orWi0mLFUaDQXZaOnY2njg5rUF/A1z/TUMa94DeynGs3VfbkO
         DTnBzs1Rq/HGihQOPOetMWv5/hR3iP34WAhkrCOaO+GLtuKPrzCdOWwdf8m3kDgK1paZ
         HbZ/q9NfAluCB8+EuuPKYMpq4MTRrcg5rj7aIPAOdskP//O29BqVDJDagygbkeE/LaxB
         +vLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W/khSlDMF8Z5nH/DIhbMkSDcNIElSCZv9aSrQuDBt2A=;
        b=WvetYxscVbakZ1l91lJpNyGRPHrJy5DLCxdTDDqQX+j92p+KCKOhdAAmLpTpv5jRsB
         pOVfgkiFcLB/6zKCXtIl8GFu5FsNF+8xwN9jIbskvx9iR/Vx7yxMXMcBgnFOxKcMQFcX
         JMi46iCgPMu0LcAWmMr55E40VefZ6B1O28+/nxi0Fia5rFNv+XyEY5mQUXlVQl48IObz
         2Wit/WUpfOfBII1N9FG1GOZLT8E982pf33DTfPnOlBxqaL2hxDtuC2mGfr08QHRIXDS7
         Kq+C43Xdaim2nYjFTxw476S+t6QA/m+C3QSHFyRqHF7AZvFk1Lfq7K/fFHm3JIF4sGHR
         XWKg==
X-Gm-Message-State: AOAM531QcQVCOTqtdfj6IAkrK73RMVA/6xYlQtE72OZ7oQi/EWE14QI1
        oZj2TzdyqoEZ7rywdT8ntkc=
X-Google-Smtp-Source: ABdhPJx35PopsR04KZtG+0aBxiWPHIEc7aqYu5utofVRYYKTbArMnAPOhmhMNL4dLpqZ0BUYFmqHUw==
X-Received: by 2002:a17:902:7c0e:b0:14d:9791:39f8 with SMTP id x14-20020a1709027c0e00b0014d979139f8mr6786807pll.23.1645178188040;
        Fri, 18 Feb 2022 01:56:28 -0800 (PST)
Received: from vultr.guest ([149.248.7.47])
        by smtp.gmail.com with ESMTPSA id t22sm2750430pfg.92.2022.02.18.01.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 01:56:27 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH RFC 3/3] bpf: set attached sockmap id in attach_name
Date:   Fri, 18 Feb 2022 09:56:12 +0000
Message-Id: <20220218095612.52082-4-laoar.shao@gmail.com>
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

Set the attached name when a bpf prog is attached to a sockmap, and
unset it when the bpf prog is detached.

Below is the result after this change,
$ cat progs.debug
  id name             attached
   5 dump_bpf_map     bpf_iter_bpf_map
   7 dump_bpf_prog    bpf_iter_bpf_prog
  17 bpf_sockmap      cgroup:/
  19 bpf_redir_proxy  sockmap:9

$ cat maps.debug
  id name             max_entries
   3 iterator.rodata      1
   9 ltcp_map         65535

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 net/core/sock_map.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index f39ef79ced67..ce8d0bbba6cc 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1411,6 +1411,7 @@ static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 {
 	struct sk_psock_progs *progs = sock_map_progs(map);
 	struct bpf_prog **pprog;
+	char sockmap_info[16];
 
 	if (!progs)
 		return -EOPNOTSUPP;
@@ -1438,8 +1439,13 @@ static int sock_map_prog_update(struct bpf_map *map, struct bpf_prog *prog,
 		return -EOPNOTSUPP;
 	}
 
-	if (old)
+	if (old) {
+		kfree(prog->aux->attach_name);
 		return psock_replace_prog(pprog, prog, old);
+	}
+
+	snprintf(sockmap_info, 16, "sockmap:%d", map->id);
+	prog->aux->attach_name = kstrdup(sockmap_info, GFP_KERNEL);
 
 	psock_set_prog(pprog, prog);
 	return 0;
-- 
2.17.1

