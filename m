Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5C44DE989
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbiCSRcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbiCSRcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:03 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA39745506;
        Sat, 19 Mar 2022 10:30:41 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id o23so7348920pgk.13;
        Sat, 19 Mar 2022 10:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DaQ7tIpYP0FN+ysFq8lKyeNWnVlaqiQkKqC0wh+aN8U=;
        b=gIIgdf3++Eq+4vAKrm3Bmzg6y37nT58dS7sKmznA/0Z0he8n3pQlzCSRFAZMUFkFUA
         a27Yi/AC9krchK6+tcCHfx+fOHarQKIpX/4zr3dJjpv/4iG8fDQcXDV2w1ehhqEfpzwz
         Tv2WW1/NT238AIev0argguYbMWsJVobYGPInR2KvXuJ8TVOe87qHdUckLRmNXaDEjJp7
         p46jaVoNgeVwj5kXnrBpCbh3Gmc5lVNo78u8b/t18KVBwcqEQrclITzz5vOht+Ru1GNc
         tQ2vtQsBFanMpYrxzVmrMViPI4TSIiqZJI5migoLRX6ngj+g6DHtyXKYGTYF1wiYqb9/
         TbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DaQ7tIpYP0FN+ysFq8lKyeNWnVlaqiQkKqC0wh+aN8U=;
        b=znoPK8vllSaTYi6VaUSeWwXjxm1ZEincK+XnOWnnWV9A+B6xuzZU6T8m+MLkjX5zJf
         El5oIEEUGJdKPV/rnNw6h6Nhq6/EMbx3KE1AMMWQSRd8g9J1bJhSmXreVKN2Vczakona
         nRg4njX4T/8soN8eIKm82FV3ARDi869c2ru6Z+mKIOdNDQaikLDnpy1NyMoqI4tRBLcO
         t4+E8bZMSfvixWxMCSH7yYCY+gmlN7GSs2iW2RGCp+6s/MZYFctT46kmMtznh0mBQrne
         BxvfD+Vo2HKRpmHhhMNW1F5yxstipFw00SMc+T//W7vEh8d+OLtnmn6bRN8ot0rxndzG
         sTOA==
X-Gm-Message-State: AOAM5322iDhWIughPAiMvn/m/he2Ohrn9AYf5DM4oZKyU4zKbXhxnBYh
        wmxCD1AkkKjQVm3e/J5GmEo=
X-Google-Smtp-Source: ABdhPJzJfpVsPFMvRvZxlinLbP2ikPf+r/4KhMLR5qGL9f8tBztSFPKGq/Oaa6WjOipKpgwMZJ0XWQ==
X-Received: by 2002:a63:ef4f:0:b0:375:6898:f6b8 with SMTP id c15-20020a63ef4f000000b003756898f6b8mr12183943pgk.59.1647711041349;
        Sat, 19 Mar 2022 10:30:41 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:41 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 01/14] bpf: Introduce no charge flag for bpf map
Date:   Sat, 19 Mar 2022 17:30:23 +0000
Message-Id: <20220319173036.23352-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220319173036.23352-1-laoar.shao@gmail.com>
References: <20220319173036.23352-1-laoar.shao@gmail.com>
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

A new map flag BPF_F_NO_CHARGE is introduced in bpf_attr, with which we
can choose not to charge map memory while account it to root memcg only.
At the map creation time, we can get the no charge flag from struct
bpf_attr directly, while for other paths we can get it from struct
bpf_map.

The usecase of this flag is that sometimes we may create bpf maps with a
process running in a container (with memcg) but these maps are targeted
to the whole system, so we don't want to charge these memory into this
container. That will be good for memory resource management for this
container, as these shared bpf maps are always pinned which should
belong to the system rather than this container. That can also help
to make the charging behavior consistent, for example, if we charge the
pinned memory into this container, after the contianer restarts these
memory will not belong to it any more.

Two helpers are introduced for followup usage.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h            | 15 ++++++++++++++-
 include/uapi/linux/bpf.h       |  3 +++
 kernel/bpf/syscall.c           |  1 +
 tools/include/uapi/linux/bpf.h |  3 +++
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 88449fbbe063..07c6603a6c81 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -184,7 +184,8 @@ struct bpf_map {
 	char name[BPF_OBJ_NAME_LEN];
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
-	/* 14 bytes hole */
+	bool no_charge; /* Don't charge to memcg */
+	/* 13 bytes hole */
 
 	/* The 3rd and 4th cacheline with misc members to avoid false sharing
 	 * particularly with refcounting.
@@ -207,6 +208,18 @@ struct bpf_map {
 	} owner;
 };
 
+static inline gfp_t
+map_flags_no_charge(gfp_t flags, union bpf_attr *attr)
+{
+	return flags |= (attr->map_flags & BPF_F_NO_CHARGE) ? 0 : __GFP_ACCOUNT;
+}
+
+static inline gfp_t
+bpf_flags_no_charge(gfp_t flags, bool no_charge)
+{
+	return flags |= no_charge ? 0 : __GFP_ACCOUNT;
+}
+
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
 {
 	return map->spin_lock_off >= 0;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 7604e7d5438f..e2dba6cdd88d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1225,6 +1225,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Don't charge memory to memcg */
+	BPF_F_NO_CHARGE		= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index cdaa1152436a..029f04588b1a 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -368,6 +368,7 @@ void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr)
 	map->map_flags = bpf_map_flags_retain_permanent(attr->map_flags);
 	map->numa_node = bpf_map_attr_numa_node(attr);
 	map->map_extra = attr->map_extra;
+	map->no_charge = attr->map_flags & BPF_F_NO_CHARGE;
 }
 
 static int bpf_map_alloc_id(struct bpf_map *map)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7604e7d5438f..e2dba6cdd88d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1225,6 +1225,9 @@ enum {
 
 /* Create a map that is suitable to be an inner map with dynamic max entries */
 	BPF_F_INNER_MAP		= (1U << 12),
+
+/* Don't charge memory to memcg */
+	BPF_F_NO_CHARGE		= (1U << 13),
 };
 
 /* Flags for BPF_PROG_QUERY. */
-- 
2.17.1

