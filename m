Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E14C20361A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgFVLrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgFVLrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:47:11 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83117C061794;
        Mon, 22 Jun 2020 04:47:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id 35so7492328ple.0;
        Mon, 22 Jun 2020 04:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LiBGF084Pp6dCZ14UkujprrgGctzNH7WtCqeXOknFI8=;
        b=uCuIUgPsr8qbzqBFVG3fkPY8Ev4mfasm1onLTS1Kaej+E0YJ/5qNW2E2u6OTXVOJ4F
         B0Yu17EAQ454OPh4D0COZ+w/U+mXm0rZCFBYgxLd/Ya54XmMdKJLUBZbY1RGLnaUQpZX
         bEHfRQIMwNl4/R7ELsH1AlFUQsB4AYrPbY0Al8YHq26SPi9MAOKh6QCtHf8FEAqhgO2s
         ib635QAlY+CL3ZXwkcQ8R0sFKg5AbSg6RoKb8ywpPs0LXV196uouDxUfDZi5IXrnpF6Y
         Wcf/Yiv7P+9XUd2v3i7VnU2qEQlbrPR2/SS0kRvAd72yP8BxNdsCxs3d3Aqx90bQ2zJj
         7sjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LiBGF084Pp6dCZ14UkujprrgGctzNH7WtCqeXOknFI8=;
        b=OIw3oqOy6MC0K7AJyty10dl0IPIO8SC1ypBxSMxcOPAqP+Vj6extEsvq5NKhP+CDqc
         LZux7Yy+OE63+tNSxMAAQsyhNujMweX31ghZ4WlagiXiAT5PeN53BdaNgOgoqlILyx9A
         7bO6pByQu40bzcoQe4UUcXtcW7uDtwM5xA/gbeKvBreDE+Re4KRTJpu8UmIoFiXbBVZO
         RxNzh7S24k4y8V8RpU5JWUOeAISyYfhsoOmGkexje5yEnRMYfAU71oJIBDUkmH0XQ23y
         IVSVj483gtikQfoFkCLB61Ym74sYk5wg4Y7155mcfWHYwuMnskINb5jnOfsJNEjCDDtN
         bu1g==
X-Gm-Message-State: AOAM5319rpE2kWyfQUWzCVKo2Bh5CpBVDDJMtFUSJh/d+X41mfZpcMIX
        gnQ0AqcC6OESzuOjBdyhLaI=
X-Google-Smtp-Source: ABdhPJy8GhbcijBg1WZAh0wJE6T5qBbkLL2oa1JLqC0YTaNAiGZlOFvFKD9dlGIpjD0/JWXAXijIHA==
X-Received: by 2002:a17:90b:3c6:: with SMTP id go6mr18540571pjb.224.1592826430099;
        Mon, 22 Jun 2020 04:47:10 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id r8sm14070896pfq.16.2020.06.22.04.47.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2020 04:47:09 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] mptcp: drop sndr_key in mptcp_syn_options
Date:   Mon, 22 Jun 2020 19:45:58 +0800
Message-Id: <60f8315d6ae7b62d175c573f75cee50f14ce988b.1592826171.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In RFC 8684, we don't need to send sndr_key in SYN package anymore, so drop
it.

Fixes: cc7972ea1932 ("mptcp: parse and emit MP_CAPABLE option according to v1 spec")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 490b92534afc..df9a51425c6f 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -336,9 +336,7 @@ bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
 	 */
 	subflow->snd_isn = TCP_SKB_CB(skb)->end_seq;
 	if (subflow->request_mptcp) {
-		pr_debug("local_key=%llu", subflow->local_key);
 		opts->suboptions = OPTION_MPTCP_MPC_SYN;
-		opts->sndr_key = subflow->local_key;
 		*size = TCPOLEN_MPTCP_MPC_SYN;
 		return true;
 	} else if (subflow->request_join) {
-- 
2.17.1

