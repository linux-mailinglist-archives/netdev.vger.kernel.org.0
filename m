Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7427EB3537
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730575AbfIPHLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:11:04 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34487 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfIPHLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:11:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id d3so16533325plr.1
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=HpgMDO0y8NpLHlBoc1zHHS1hRFJIEnkYLrJIX17Y0cA=;
        b=XA54LdLaWtugni1x9Gq4ZDaxwgbnEiJB4DYykZHdqfIWDgKvBii1C/6h3N6y6R3Wbg
         +X/gabYRHQS4UtTrNalgg5zYK0aCP4DAz2jPNKPMXtXVSutn7TLFaXly652mopR7XEQ+
         0umWo8LPi03NpRfLNAGQFBdN+JFIr2bTBQiRI6hNDAWk3CVohb7xRPWXxdlwh9wxVr2G
         Jatx0dpuDINRR2g5SWPWz8mMyzUMaAXsV5EwaEnBG/hjXKHDKhIvcV852XC/PDK9gMdw
         Sfimwvj6OA8FHGeax+XxlaoPGosXR4j/CVVyEtxeVNLTdnRtH8NyFhXXRqOFBWpVaeNI
         jtPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=HpgMDO0y8NpLHlBoc1zHHS1hRFJIEnkYLrJIX17Y0cA=;
        b=biRCFDsmh3KQDx6y7hbSJtaGcxrp0okJblDU0kvE5hwSrwe2W3RbhjzbsCxZblk4Fa
         J3ZwxsYN9NDP+PdcbzGsITlc/xQ1OnDjHIfWpxbrNRvOnirLjYiy7RgwtEVJ2yMu7t/b
         qw7VVClYN9VOdsmj4k8oR9rUVMacs7oIr/rg/O9ezTGitS6lMMv7Gcs4BVKUDDB0HWuy
         AGqVpBR6MbLRVrll7wuPwd7dwJ6rJF8evB5kLvX3YQbT1j61YejZ1w6IDKc/ck5UhGOy
         Ke6RsUjLxtzMlDIPvGXsOCOJidbzzEimKVJDHjQXNGa/T2CpD/l0mIbPB7YbwSSlu2vv
         d6sA==
X-Gm-Message-State: APjAAAWQQUPumyrlOMVtR7TJBwmBTiVq5Uo8HlIdl8ddJ8RVkECkECLj
        E5mI/U7v7DQ5IUeLzSH5cMO9bo6uDIQ=
X-Google-Smtp-Source: APXvYqyQ2IrVC5wfa1V1wBvfF9GrRcCF0J3i3RBBjFt1v35fl/21cKL0p3lBjl5QdAfglo80nR+FPQ==
X-Received: by 2002:a17:902:b691:: with SMTP id c17mr62388966pls.265.1568617862173;
        Mon, 16 Sep 2019 00:11:02 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p68sm66045774pfp.9.2019.09.16.00.11.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 00:11:01 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCH net-next 4/6] vxlan: check tun_info options_len properly
Date:   Mon, 16 Sep 2019 15:10:18 +0800
Message-Id: <7d552d01b82edf9523288030dc03f467aee92912.1568617721.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <25b60ddb9a54413e20d5a55e9e03454c82e4561d.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
 <ec8435ca550a364b793bd8f307d6c2751931e684.1568617721.git.lucien.xin@gmail.com>
 <c8ce746cdbfe59ef332997e1ad87e88af49aac5b.1568617721.git.lucien.xin@gmail.com>
 <25b60ddb9a54413e20d5a55e9e03454c82e4561d.1568617721.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1568617721.git.lucien.xin@gmail.com>
References: <cover.1568617721.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to improve the tun_info options_len by dropping
the skb when TUNNEL_VXLAN_OPT is set but options_len is less
than vxlan_metadata. This can void a potential out-of-bounds
access on ip_tun_info.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/vxlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3d9bcc9..e0787286 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2487,9 +2487,11 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
 		dst_cache = &info->dst_cache;
-		if (info->options_len &&
-		    info->key.tun_flags & TUNNEL_VXLAN_OPT)
+		if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
+			if (info->options_len < sizeof(*md))
+				goto drop;
 			md = ip_tunnel_info_opts(info);
+		}
 		ttl = info->key.ttl;
 		tos = info->key.tos;
 		label = info->key.label;
-- 
2.1.0

