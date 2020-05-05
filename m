Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F561C582C
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgEEOH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:07:56 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:58365 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgEEOHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:07:55 -0400
Received: from localhost.localdomain ([149.172.19.189]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MSckp-1jgbDd2wEj-00SzC5; Tue, 05 May 2020 16:07:36 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] sysctl: fix unused function warning
Date:   Tue,  5 May 2020 16:07:12 +0200
Message-Id: <20200505140734.503701-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:3d2w6o/Pc8jpk4E6dFIe0waqDAGYBBiltl8xwm05XKzTS/tzFZH
 wM6QVpdygqilv5m8jqAn3iINx2PgvGXlxHuWdgc3WYmVK+DjVlu6JrioYarRNKH4YSW7KJJ
 C08I0iaqQgH7+7baXtogmFSLh3g5rXUY6/Py3//z6OKPKQguuo7h1VPzjNv4FvAv5tdOzrG
 uINB2ZeUA65BUR3MOCzqA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0zfdxagVU88=:2Xvisr/NI7pfy32yIaUe6f
 EL6r4Zlig/Jg5SKrt1MSpeVIdiE3TSlDhFdNnjOZRdEkujHAODLH15mLqxQlGIQktnFgqWODs
 qmhUC9/w7EH+1R40FCXvTNgEOis6kpL7Hlzj4Ccd34BlgxPEDo9BbircvahNBUrqOc9liaWDx
 ynJ4etVdetVqJPGxO8O1SynFEKxgi1VZcR8lYRi2zRX3Hfvk5SL8wgKW3bNuBJ3/uW+RDeMTK
 tuTIEqqM0LHi5tBxUfMWEzWxjKZi/sC/VFrnUaSyCBF/40D1kdoYzyu1f0647fuMkX3ai/liX
 pLI1X15gvDRxdMC4dXi4GAtrElqOvkkjcRltQbcnBuz/Imm7vWp6lLuQ4D5mq7d2FUS292SGf
 gTpHYknOQz/iXDomucdqmEu15plsNzhT7ObUpQnqhd+0dC+slV3t8mI3t7ky027D287+gspqG
 DfcmWDNogN/OFRGPFvGicrnNTo99MDxFe1QfOa60W1XKoy1UnQd8j92OXMinLptq7OuOgxvcg
 dbfWKG8zgztfKUlAjA/qOsyrBIxKRCxS+iXcV9OTMrsJxZ6YxVxdTJZ0JMTKk+t/3eOd+qQeI
 V4cCDBX17dA+FB6varE0Y9p4iAGIdPbYeCjsf8U40Xlir8gHtZW4Z/BMwfxt+HS5h0Fttp9Vw
 NReSAkSju1reIuUiWqn3ZCPZrcHNhstfKoy0Pu9NCj9jPEIAyIaxmrnztfSRLNk7ATzha7oJJ
 QjIATrubtNYJPYP+Vq/9gh4GilQPXrUrj7TZpWAXwwjH/hQLkwnPwdqTFDWj3eBqNMEUBvBxA
 7fQL8CAM9kgnfQWFKss6pdCGY/uPAzMyvk4DeHJay9AqRlbTvo=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The newly added bpf_stats_handler function has the wrong #ifdef
check around it, leading to an unused-function warning when
CONFIG_SYSCTL is disabled:

kernel/sysctl.c:205:12: error: unused function 'bpf_stats_handler' [-Werror,-Wunused-function]
static int bpf_stats_handler(struct ctl_table *table, int write,

Fix the check to match the reference.

Fixes: d46edd671a14 ("bpf: Sharing bpf runtime stats with BPF_ENABLE_STATS")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 86ed5dd29a61..3b0cecf57e79 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -201,7 +201,7 @@ static int max_extfrag_threshold = 1000;
 
 #endif /* CONFIG_SYSCTL */
 
-#ifdef CONFIG_BPF_SYSCALL
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_SYSCTL)
 static int bpf_stats_handler(struct ctl_table *table, int write,
 			     void __user *buffer, size_t *lenp,
 			     loff_t *ppos)
-- 
2.26.0

