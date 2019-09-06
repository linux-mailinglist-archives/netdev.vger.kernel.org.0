Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC589ABBE5
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387911AbfIFPLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:11:34 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:60621 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfIFPLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:11:34 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MpDa5-1iVMm21VU7-00qmuU; Fri, 06 Sep 2019 17:11:25 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Feras Daoud <ferasda@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>, Qian Cai <cai@lca.pw>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: reduce stack usage in FW tracer
Date:   Fri,  6 Sep 2019 17:11:16 +0200
Message-Id: <20190906151123.1088455-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:p/b8Nl+a8dcOBXe1E3zEBq4jgiU9iqZOcICuoVMvko8jH0U4ryo
 FeR6Q+0c1vFSlpCFpWhwUSHP5Li2ZMgA2Klua6mVw68Z5Zcfnc1az5h+1qXOAk0xALJ53XG
 h4sI7EmaaRERYBnBrNJzSaKMDw5civlTahWbDF3P+hM9NjqgalSlPwKZ8FW7Y7ixhwuntGt
 lRyvkrcRvkOThH77r5nTg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+SyaHs2zKCE=:FWX7FWPQbNudZ9Cz9qFnPg
 Fs53G8kwE94rvxELM3px1JcfUxQ/T4jLokQZo3lwKyL9WRYGqYhdHklF826KN0DTpBwLQfmTL
 ZqD86Su8i2y2Z5fUniTOK3C4qKDPEzHuQgK9kcifrdrILQ0nbIjfZVahyfRJYH5+Z6nQ6qg9P
 W6kkw8COj9cTmCn5mDXVNZDk+Nep7+KZy49DSLiDAoy0+O3cuB6x47k7YwgrR0Z/VQEfFnMMH
 kMHeJDZPYSMrsHx25JOX2eJW6jdEOuvY+XWD93QjfK0POa22sgfgNzPEJr3njRGG+6p19iHgh
 WOhcYYPk2oadqUlbyvRbtmrc0rYtMhPpBgPX2MndGZndS1jQbMw9QJxy5gPKISd3odlIiG872
 pXSuhMki2Rq8ufRvjE1c/2McMT6zbX3d8NNlMqCY+1hFBUIw7BNYdYaDkgLFFFmwPxysSpRdk
 qoeSlgC2w1zcqwn28yMoccOihwRnAE4tleAIjplz84I/43c8QwEetomB/qwD1pxxrYbc+tNt2
 n0zbjxmoFJfG5baeTr6cTvvnIBAcdCcPO+4l5JPt8DYQvQ6V3E7+acMsgAz3YFzFyT6iAv0Vl
 0jVMtognsqRNePtAjZMQVAtvqfWNNsZoYIaDOgp5fHahwAivQrQkuemwOasukqgAMX9GO4JXi
 89ytPfAnoq6wr+NgAIc97qaQmCG7cRlmypofPkqoNp3/x0KHhXtoqB/pQ9ziee2/tyZQUIJj5
 57G/C17D/Pdc43BkugGMwW0hRaXsJoBMhCZ7eohEHGF7y58GdZAf3/fAw+hHdWyRnYocwj5zj
 DGpBksL6TcusCqZ3FqmMbIShtjlihFhYrXYNRk2IOfJBIt2fIA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's generally not ok to put a 512 byte buffer on the stack, as kernel
stack is a scarce resource:

drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c:660:13: error: stack frame size of 1032 bytes in function 'mlx5_fw_tracer_handle_traces' [-Werror,-Wframe-larger-than=]

This is done in a context that is allowed to sleep, so using
dynamic allocation is ok as well. I'm not too worried about
runtime overhead, as this already contains an snprintf() and
other expensive functions.

Fixes: 70dd6fdb8987 ("net/mlx5: FW tracer, parse traces and kernel tracing support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 2011eaf15cc5..d81e78060f9f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -557,16 +557,16 @@ static void mlx5_tracer_print_trace(struct tracer_string_format *str_frmt,
 				    struct mlx5_core_dev *dev,
 				    u64 trace_timestamp)
 {
-	char	tmp[512];
-
-	snprintf(tmp, sizeof(tmp), str_frmt->string,
-		 str_frmt->params[0],
-		 str_frmt->params[1],
-		 str_frmt->params[2],
-		 str_frmt->params[3],
-		 str_frmt->params[4],
-		 str_frmt->params[5],
-		 str_frmt->params[6]);
+	char *tmp = kasprintf(GFP_KERNEL, str_frmt->string,
+			      str_frmt->params[0],
+			      str_frmt->params[1],
+			      str_frmt->params[2],
+			      str_frmt->params[3],
+			      str_frmt->params[4],
+			      str_frmt->params[5],
+			      str_frmt->params[6]);
+	if (!tmp)
+		return;
 
 	trace_mlx5_fw(dev->tracer, trace_timestamp, str_frmt->lost,
 		      str_frmt->event_id, tmp);
@@ -576,6 +576,7 @@ static void mlx5_tracer_print_trace(struct tracer_string_format *str_frmt,
 
 	/* remove it from hash */
 	mlx5_tracer_clean_message(str_frmt);
+	kfree(tmp);
 }
 
 static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
-- 
2.20.0

