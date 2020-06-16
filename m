Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD15B1FA932
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 08:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgFPGyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 02:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFPGya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 02:54:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1008FC05BD43;
        Mon, 15 Jun 2020 23:54:30 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h22so1101404pjf.1;
        Mon, 15 Jun 2020 23:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=NEdJpkUGB2M0ZFXDWJp7ZD5zy/GYvN+9GDD0rxh6Bew=;
        b=kSyfXBKoptmUt7kGGlsQ9z9oFh/v07Q65GLrVzKLvBB4jVPvCLQ1DHjA6jFgUrnIRH
         znUfKnRFhQWZV0ZSyygNBjMajQn9AG3EG70sgjih7T0JQAsMdTUtl3yvDdycx3O9CazT
         CWq1nEnzCdbnP1Zro1POMhkgSXUDWBpMk19bW2/SCs5D99phGXuRx1oRLry4grb7kPco
         9n/3JP7mNwO2WFWfYSq/EncTX2jyRDAdpWc8m81O7J+dEsRNLgb9VwNZxauKwe6x0cOV
         b+ETOzmVvHuX5ncE1oaxfFQIDihXuxhvTv6indZJ5kcbQtK7eMmJqJowTDrOF9SRRriB
         O2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=NEdJpkUGB2M0ZFXDWJp7ZD5zy/GYvN+9GDD0rxh6Bew=;
        b=AFXZ6yh2Ylt7TMpUPSjczgedlmHwn0fNh0LSrMf4wPTKHX5hM6ipPOrkNAGQuzurf9
         oAc36xtR3kp+BylMtzOsgfI9BZ0+owVL59CzLQKfnfcsp8fT3SNsWzr+0nhUDp8ztFRP
         Xjw2DHE3Yx1twpIv1TuXSGdN8y+vj9jysurTcWADDAwOtyCoVdQUKQbA1Imv1YZ+c2mq
         bj0FQHqQpFc+bYqMYfmbo6jikMTBnz7gaQfvCEWMarCiJDy9yXHDTVX3SHHWOguwwTkO
         ms0hggXpFpDeCJHzWXe5PCFGzCHr/ASEcG1dCXoPD57cK0uh0X9FB/w6biKLRnp2+Xmq
         cY6A==
X-Gm-Message-State: AOAM5312dpyt+bJFN/mIqIwicjsmiMaa9glYCH4o/gysJvkucIYGUpOc
        kzxTAaqxFNu9xdUHnY1TvRc=
X-Google-Smtp-Source: ABdhPJzX3FKDXy5dRw9R1aLIwn8/y8Bxq069uokajv3sH8i+8A9Q88NppKT59ShWp6h3hUO2kd14Qw==
X-Received: by 2002:a17:90a:a08d:: with SMTP id r13mr1381780pjp.96.1592290469647;
        Mon, 15 Jun 2020 23:54:29 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id s98sm1433283pjb.33.2020.06.15.23.54.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 23:54:28 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] mptcp: add MP_FAIL suboption handling
Date:   Tue, 16 Jun 2020 14:47:37 +0800
Message-Id: <9bb5cb494f4ac53845f2d233409073d8e71d0e4f.1592289629.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1592289629.git.geliangtang@gmail.com>
References: <cover.1592289629.git.geliangtang@gmail.com>
In-Reply-To: <f86a2f6f241b7f7a49fec17b3428ae5a0fadc93e.1592289629.git.geliangtang@gmail.com>
References: <cover.1592289629.git.geliangtang@gmail.com> <f86a2f6f241b7f7a49fec17b3428ae5a0fadc93e.1592289629.git.geliangtang@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add handling for sending and receiving MP_FAIL suboption.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c  | 18 ++++++++++++++++++
 net/mptcp/protocol.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index cc3039f0ac43..82b3d7c566b4 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -288,6 +288,15 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		pr_debug("MP_PRIO: backup=%d", mp_opt->backup);
 		break;
 
+	case MPTCPOPT_MP_FAIL:
+		if (opsize != TCPOLEN_MPTCP_FAIL)
+			break;
+
+		ptr += 2;
+		mp_opt->data_seq = get_unaligned_be64(ptr);
+		pr_debug("MP_FAIL: data_seq=%lld", mp_opt->data_seq);
+		break;
+
 	default:
 		break;
 	}
@@ -975,6 +984,15 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 				      opts->backup, 0);
 	}
 
+	if (OPTION_MPTCP_FAIL & opts->suboptions) {
+		struct mptcp_ext *mpext = &opts->ext_copy;
+
+		*ptr++ = mptcp_option(MPTCPOPT_MP_FAIL,
+				      TCPOLEN_MPTCP_FAIL,
+				      0, 0);
+		put_unaligned_be64(mpext->data_seq, ptr);
+	}
+
 	if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
 		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
 				      TCPOLEN_MPTCP_MPJ_SYN,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 623c9a1c4343..e6ae0a73716b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -24,6 +24,7 @@
 #define OPTION_MPTCP_ADD_ADDR6	BIT(7)
 #define OPTION_MPTCP_RM_ADDR	BIT(8)
 #define OPTION_MPTCP_PRIO	BIT(9)
+#define OPTION_MPTCP_FAIL	BIT(10)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
@@ -60,6 +61,7 @@
 #define TCPOLEN_MPTCP_PORT_LEN		2
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
 #define TCPOLEN_MPTCP_PRIO		3
+#define TCPOLEN_MPTCP_FAIL		12
 
 /* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
-- 
2.17.1

