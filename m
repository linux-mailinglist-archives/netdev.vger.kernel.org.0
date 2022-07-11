Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372945703D8
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiGKNHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiGKNHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:07:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F212E6AB;
        Mon, 11 Jul 2022 06:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B79DB80EE5;
        Mon, 11 Jul 2022 13:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1BFC34115;
        Mon, 11 Jul 2022 13:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657544861;
        bh=KSVdsk0NC94AFJ7bwZTkH/uOWzU/O4IXdwEJf7+JQRM=;
        h=From:To:Cc:Subject:Date:From;
        b=LwtVCWnFJ5qNCmvJ3MuDYWA0XulRjmnaTSBRNLMBGbyRHArvy0eTmKpPJsTky61CB
         WPKNH2IzcClJ8JfJ/yYwEnUFIErWoDpWNSXUPTGUdES3+ZZvgAlN+O2RtCBBRJ3F0o
         FYUh2d1+MoMqpdNKw0F+b+vFD+CgVJntB62C2KftadQU5dH0J3sOkru8F4WngeDhrk
         uIpRmvHjLnQNhkuYE8zDQsjhx7UgJDloIRXJMhB3F/JGOHSEW6nIDeI/0dQnW8eWiC
         yKT8wTEr9bOHgMdFaaMqGmr+csxxLhNfBorSFZQ4tJn9hiFE6GjLY8QuM6u190R5IC
         swvAO72IDnwMQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Geliang Tang <geliang.tang@suse.com>, mptcp@lists.linux.dev
Subject: [PATCH bpf-next] mptcp: Add struct mptcp_sock definition when CONFIG_MPTCP is disabled
Date:   Mon, 11 Jul 2022 15:07:31 +0200
Message-Id: <20220711130731.3231188-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The btf_sock_ids array needs struct mptcp_sock BTF ID for
the bpf_skc_to_mptcp_sock helper.

When CONFIG_MPTCP is disabled, the 'struct mptcp_sock' is not
defined and resolve_btfids will complain with:

  BTFIDS  vmlinux
WARN: resolve_btfids: unresolved symbol mptcp_sock

Adding empty difinition for struct mptcp_sock when CONFIG_MPTCP
is disabled.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/net/mptcp.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index ac9cf7271d46..25741a52c666 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -59,6 +59,10 @@ struct mptcp_addr_info {
 	};
 };
 
+#if !IS_ENABLED(CONFIG_MPTCP)
+struct mptcp_sock { };
+#endif
+
 struct mptcp_out_options {
 #if IS_ENABLED(CONFIG_MPTCP)
 	u16 suboptions;
-- 
2.35.3

