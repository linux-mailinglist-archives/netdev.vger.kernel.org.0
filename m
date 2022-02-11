Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE884B254C
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349871AbiBKML5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:11:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349867AbiBKMLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:11:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E48D5A;
        Fri, 11 Feb 2022 04:11:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id om7so7899357pjb.5;
        Fri, 11 Feb 2022 04:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yy9scMf4Ui56NpjyKDEB4Jg/xmcpa20rCXr5oBLCc18=;
        b=p9zT758bIKEwIEdy2skqBXu4Sbf2IDLjoOEa0OK6bSumy757PNzGCiqqNfX44YGrWh
         VxmfdzFW9BgZJ00s997g+GxTQ8ouNMgXwltB4l0H27r3i62yok1YS46mTQXbmz6LXUFb
         AUygNN9T4msE8rc0XnVhvT449D71/vr7ruroQzqM5sQZdxGQ3LlsBUI3/AOo8y0PyyRL
         mVey6HHPHOYF1b9GCtqG4awPkDgkSI2WKv3XiDTSmimzXUFxk7BliMoE0MNcO4dafuBz
         a/g0NHig8woGlyFA0ZjthQy3DAG0/vSeSW77jtA5JDV9sKqFzDGCAJp89kNB04pcB9LH
         U2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yy9scMf4Ui56NpjyKDEB4Jg/xmcpa20rCXr5oBLCc18=;
        b=uZ9cpY+oi6PMAucrBpmvosxfo+4U0sH/dX4r7UX42X/saF/qwc+e1SSBfIl6mnPmvi
         NGpdwflb81qkOz68QMIZd0q/3uhuBFKjP8TgLk5iy4tFUw5yYIScFZCiL6JcMCc2/CMd
         TgQaGXKmAJ/x/J2daJqVFP1kLKLrz/xBURtj+yXSa4EMl9HiCjG+p8NYOjofwAiul+bc
         AVFIoEJsLvJrypFWVxvTJhEwv7j3F+0dXAJOvSdQghfEo4/XGAGe3pUYgVqyN0bSocUU
         nh+j7OG8YFsOoJQ+wY1zK36GmHVTLEUyAJqbUtnMJVUgmx9gisohquRVtuXroM0dDWXy
         +/CA==
X-Gm-Message-State: AOAM532YbHf3nTsRcNNf2fCYvXY+SN40w6Vo6JIv4nFb6rsIugi5EvAK
        ncBfeLBIx8TStsHpauTrpqA=
X-Google-Smtp-Source: ABdhPJyHRhSfDAvWkRzq26SisKk9JGuYvCRkCaM4Tc8EmEs5lzEFoiclkN6xyFNLTiTHn2IqIW3iJA==
X-Received: by 2002:a17:902:a418:: with SMTP id p24mr1322542plq.171.1644581514840;
        Fri, 11 Feb 2022 04:11:54 -0800 (PST)
Received: from vultr.guest ([149.248.7.47])
        by smtp.gmail.com with ESMTPSA id il18sm5558913pjb.27.2022.02.11.04.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 04:11:54 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 2/4] bpf: Add pin_name into struct bpf_map
Date:   Fri, 11 Feb 2022 12:11:43 +0000
Message-Id: <20220211121145.35237-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220211121145.35237-1-laoar.shao@gmail.com>
References: <20220211121145.35237-1-laoar.shao@gmail.com>
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

A new member pin_name is added into struct bpf_map, which will set when
the map is pinned and cleared when the pinned file is removed.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h | 1 +
 kernel/bpf/inode.c  | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9cf8055..220de69 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -182,6 +182,7 @@ struct bpf_map {
 	struct mem_cgroup *memcg;
 #endif
 	char name[BPF_OBJ_NAME_LEN];
+	char pin_name[BPF_PIN_NAME_LEN];
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
 	/* 14 bytes hole */
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index f1a8811..586adef 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -440,6 +440,7 @@ static int bpf_obj_do_pin(const char __user *pathname, void *raw,
 	struct bpf_prog_aux *aux;
 	struct bpf_prog *prog;
 	struct dentry *dentry;
+	struct bpf_map *map;
 	struct inode *dir;
 	struct path path;
 	umode_t mode;
@@ -470,6 +471,9 @@ static int bpf_obj_do_pin(const char __user *pathname, void *raw,
 		ret = vfs_mkobj(dentry, mode, bpf_mkprog, raw);
 		break;
 	case BPF_TYPE_MAP:
+		map = raw;
+		(void) strncpy_from_user(map->pin_name, pathname, BPF_PIN_NAME_LEN);
+		map->pin_name[BPF_PIN_NAME_LEN - 1] = '\0';
 		ret = vfs_mkobj(dentry, mode, bpf_mkmap, raw);
 		break;
 	case BPF_TYPE_LINK:
@@ -619,6 +623,7 @@ static void bpf_free_inode(struct inode *inode)
 {
 	struct bpf_prog_aux *aux;
 	struct bpf_prog *prog;
+	struct bpf_map *map;
 	enum bpf_type type;
 
 	if (S_ISLNK(inode->i_mode))
@@ -630,6 +635,10 @@ static void bpf_free_inode(struct inode *inode)
 			aux = prog->aux;
 			aux->pin_name[0] = '\0';
 			break;
+		case BPF_TYPE_MAP:
+			map = inode->i_private;
+			map->pin_name[0] = '\0';
+			break;
 		default:
 			break;
 		}
-- 
1.8.3.1

