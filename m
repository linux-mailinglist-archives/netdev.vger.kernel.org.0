Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA7C1BDD6B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD2NWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:22:39 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:41219 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgD2NWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:22:38 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MX0TX-1jeNXf3ezh-00XOTF; Wed, 29 Apr 2020 15:22:19 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: fix unused variable warning
Date:   Wed, 29 Apr 2020 15:21:58 +0200
Message-Id: <20200429132217.1294289-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:k6j41FIj2faIYb1V2o45AU4BeXYULe0A6NNw/gEHZfrMqS+6wWa
 zeMYE2q6u8v9mvAMcQe09B7794JwIqn+rJBYoheUrpzqwUsJkAXtm+OPzixA/ExODVC3sFW
 2nHyVTgydxLXD+7+cpTZScrRhtZLF//M0BqxygT6TaSgRfVQFzD3TU84O/iwQl6G44bHyUa
 BoR2Vb76MqzHLzraxxHjg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UpKmluTH6t8=:r/mpxD8wj06UmrUf/UsYwm
 S3EivIH3Evud01Pby5PJ9M/XAu8DVN/QXs9NXaYt4U03c/wgEw8vuJwkX6mwsGpVtfDd4X4Il
 Dg+jXEd2XWPfxbRuiEARnqmrIeoFmg8jH5D2Vd9Fp53UsHGcftx7XjJ4wBHPqHbqtjEe+Uv6Y
 1rlur/VwjMrJpvubxUN29jFXGckWPxr6QLZA5pFgrFPlUjSJQN/o2UoUm3eGEqkxt3kVtzRKk
 mU76LYF7J9RKlqLvXRcpyF45PV9+UiUYwYzJ/ugSLG10UP2GnZ9uvFtIubKemLqoditKRO1yS
 lkG046QQOLwovt5sjiWETIWWNOBUTG/NoxleVVXIrNwS63kTopSATy3PQbgLxey4Vrejo8cDo
 Zf0bfYeIseFAHluPFA91oEn4yDEL6KW2QlA2N2EcNgjGL0F6lcxcyaZhf5h1cvin5web2KCUi
 b2yZVaCmJ2Q0072ACgu4vVmiVOs7iGt6XjTXNp3N+31gcxXs9QzDoBRr0hVeIsMndlhIDTHwZ
 3RIY5aCRVInGwGIKsbpT7iAwkU2OQWBw1U2bhA5DvZ4aQAWirDtz5aXEG7hkil9RUJs/lKZ11
 fq9EdJJy8cy3x/gP/vgdbuYRferhBQI9gCPnEQS1Mk+5sMorxn7+jpIIR99Sdfh3J2An1tUGc
 RMeoF+4/Fba3Goxl6E3esJF3bdnFkrYjmN5IfXv9PfIUHEdchGP8Ki5Pm1E1XPEAm25BsjVYx
 ggecvHHtUSsgL+hbzot0lB3/cVv8N0INpd6uyH6qZP85ytAvfJDjovxrZvhMrdDdN+TOiXkwj
 k/GxYYEgVJ4y34xRUbjiyEjmccV2pGIuCcxCGa31FV5jJE/5hA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hiding the only using of bpf_link_type_strs[] in an #ifdef causes
an unused-variable warning:

kernel/bpf/syscall.c:2280:20: error: 'bpf_link_type_strs' defined but not used [-Werror=unused-variable]
 2280 | static const char *bpf_link_type_strs[] = {

Move the definition into the same #ifdef.

Fixes: f2e10bff16a0 ("bpf: Add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 3cea7602de78..5e86d8749e6e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2274,6 +2274,7 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+#ifdef CONFIG_PROC_FS
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
 #define BPF_MAP_TYPE(_id, _ops)
 #define BPF_LINK_TYPE(_id, _name) [_id] = #_name,
@@ -2285,7 +2286,6 @@ static const char *bpf_link_type_strs[] = {
 #undef BPF_MAP_TYPE
 #undef BPF_LINK_TYPE
 
-#ifdef CONFIG_PROC_FS
 static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_link *link = filp->private_data;
-- 
2.26.0

