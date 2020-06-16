Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11DD1FA943
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 08:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgFPG4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 02:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgFPG4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 02:56:45 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21713C05BD43;
        Mon, 15 Jun 2020 23:56:45 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b5so7826581pgm.8;
        Mon, 15 Jun 2020 23:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=EpclztQoSZuLTORvxhGdyCDozRw7mptagvqwSet+jsg=;
        b=XUEzt9tLli3fnpnTh82Goidp6aJDVsFkLZYmxzv/3IVSl/0ocpBf0/5ci6KaIU4/9T
         NIPyCiWWfFzNCb/0YzqW8a2vBxpZ6o+aRBFbaR66Yji+AqMpcImyo3enPrGqMiAFm5UB
         Hat8dsNTqp+u+/kgFh/dIjPK7K8P9hM+n9UCScvF9MVUQVhMJH+R/8laIvSKgS77xDZu
         s5RIHh+k0+I3fuX74WiXY4KV67MdKvEL1rljnprEdGJ9GltGy/7qHHiBjeRjCJhrR5EG
         MYh+Rm2NoIfHpb/NEskDb8/V+qWXaP2pw0rWJqNc2Yvz6c10FvNoyBihIfcHXXWdje7d
         2Oew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=EpclztQoSZuLTORvxhGdyCDozRw7mptagvqwSet+jsg=;
        b=XOJsq4NhmNfYmr1mxTvXvP1N9nsIlMp8L0gB8l7VSLke/o2uYPYAKEThUkBBunY7F9
         dx0XpJ9c6XQuQjqi19Bz7Su5MeXRyIqUJ/kl0pPMz9ySQEt6S784wQWOGVsjOT+73Pzd
         HklyngiTAn5YJvExiv+tLfy9pHp2DfNQ4y6V3U5xMcRQ+Bq2LwM92Jh5dQ1YJ31MxDTs
         vrbCS70qtizc/hAZ70s5wTGs3elaJz5fsEfrACgnMTswaHut5/l2SB/lF4+9hOrS3UIr
         idlOfZoGXBYTkzMZlc1gUwm6vwd7SS/Ag+H+EkJbDWglGOzxY3D7AtdR+mqNEANdpfBo
         3zZQ==
X-Gm-Message-State: AOAM5337Vqu4f/Bj7zI+EA9Lo8Ij5DaI7k2af2QY8Dw+7+yFMofP638I
        hz08CMdQ3nigBuiSK7eS+6E=
X-Google-Smtp-Source: ABdhPJwp4gC7X35Bu222jWLJr9AernqCnX2nLSNyc70nx3p/mPBszh6cUzWj/tgDHsuBne1BDDuAfQ==
X-Received: by 2002:a63:4a65:: with SMTP id j37mr1018218pgl.114.1592290604763;
        Mon, 15 Jun 2020 23:56:44 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id z9sm1360534pjr.39.2020.06.15.23.56.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2020 23:56:44 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] mptcp: add MP_FASTCLOSE suboption handling
Date:   Tue, 16 Jun 2020 14:47:38 +0800
Message-Id: <6f0156a5c3304ce50521306a57e2483406f4d122.1592289629.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1592289629.git.geliangtang@gmail.com>
References: <cover.1592289629.git.geliangtang@gmail.com>
In-Reply-To: <9bb5cb494f4ac53845f2d233409073d8e71d0e4f.1592289629.git.geliangtang@gmail.com>
References: <cover.1592289629.git.geliangtang@gmail.com> <f86a2f6f241b7f7a49fec17b3428ae5a0fadc93e.1592289629.git.geliangtang@gmail.com> <9bb5cb494f4ac53845f2d233409073d8e71d0e4f.1592289629.git.geliangtang@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add handling for sending and receiving MP_FASTCLOSE suboption.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c  | 16 ++++++++++++++++
 net/mptcp/protocol.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 82b3d7c566b4..a99b3989fec1 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -297,6 +297,15 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		pr_debug("MP_FAIL: data_seq=%lld", mp_opt->data_seq);
 		break;
 
+	case MPTCPOPT_MP_FASTCLOSE:
+		if (opsize != TCPOLEN_MPTCP_FASTCLOSE)
+			break;
+
+		ptr += 2;
+		mp_opt->rcvr_key = get_unaligned_be64(ptr);
+		pr_debug("MP_FASTCLOSE: rcvr_key=%lld", mp_opt->rcvr_key);
+		break;
+
 	default:
 		break;
 	}
@@ -993,6 +1002,13 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		put_unaligned_be64(mpext->data_seq, ptr);
 	}
 
+	if (OPTION_MPTCP_FASTCLOSE & opts->suboptions) {
+		*ptr++ = mptcp_option(MPTCPOPT_MP_FASTCLOSE,
+				      TCPOLEN_MPTCP_FASTCLOSE,
+				      0, 0);
+		put_unaligned_be64(opts->rcvr_key, ptr);
+	}
+
 	if (OPTION_MPTCP_MPJ_SYN & opts->suboptions) {
 		*ptr++ = mptcp_option(MPTCPOPT_MP_JOIN,
 				      TCPOLEN_MPTCP_MPJ_SYN,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e6ae0a73716b..a8faab61e7af 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -25,6 +25,7 @@
 #define OPTION_MPTCP_RM_ADDR	BIT(8)
 #define OPTION_MPTCP_PRIO	BIT(9)
 #define OPTION_MPTCP_FAIL	BIT(10)
+#define OPTION_MPTCP_FASTCLOSE	BIT(11)
 
 /* MPTCP option subtypes */
 #define MPTCPOPT_MP_CAPABLE	0
@@ -62,6 +63,7 @@
 #define TCPOLEN_MPTCP_RM_ADDR_BASE	4
 #define TCPOLEN_MPTCP_PRIO		3
 #define TCPOLEN_MPTCP_FAIL		12
+#define TCPOLEN_MPTCP_FASTCLOSE		12
 
 /* MPTCP MP_JOIN flags */
 #define MPTCPOPT_BACKUP		BIT(0)
-- 
2.17.1

