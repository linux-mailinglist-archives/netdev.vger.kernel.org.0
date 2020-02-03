Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F33A1500F9
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 05:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgBCEbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 23:31:24 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34567 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgBCEbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 23:31:22 -0500
Received: by mail-pg1-f195.google.com with SMTP id j4so7109792pgi.1;
        Sun, 02 Feb 2020 20:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcAvEpV9ilFN43nto1Kxy9AQ4yLOQOiqzoFpl1MjHJQ=;
        b=KkYbMac3keYH02HXhQ4qiJWYxKSEAit1Zy/yViPbAGtv5+KoQjTPDcigdfQDztf0Yp
         jxyB9C4hCtIUzFuXyEsJwhNUVRcVCy7UJveClvO/oKQYoP3ZVL+NYkxg1HOquHxUBemj
         NDIipRxgrsMjmV2W4Ly5ZJbJGNgJGcTeTLsmcm/0bXnpio3AlWLyYZHsw9b1EN3Mh4GY
         LEmjEayKBHHvQ4FDhnv1dSbPbDuYwfvpeWxZBYGN7JtlrZry6Sf0L6MFwJj/aUtTOjyi
         QVcf8e5sDunMD638OaVrYHQwb/DLOP5Y3+5adXn6vFThChe7g3eZFI/5y0qBq7k/wU8K
         7CgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcAvEpV9ilFN43nto1Kxy9AQ4yLOQOiqzoFpl1MjHJQ=;
        b=OkZef3CZBDeR08+a7r/+WSp/eg6aIS0XDui4PMvbX9qSw+NaD7Y58tmFKuIanJKqoX
         FWHUCQRiYRMYvI9eBYGSDjpaVXUCKnq/uTAWMYu9QI8Z3Gj+D+ex96roRz9xmMFUuZ9g
         d/NuxQ5EGTJVXZQwceVrES3caMXNwxDXMTvtJdzfoh/mtJLpLGXbLWTYqUWJlXaMu7YO
         +2Po+4Mr1MDqQ8RTNhaD8EVKsgirhTnf32/dPIXOfFHs/uNPBJ7jv8JrPUq9LL5LTVep
         S4C5YAqZ8nzHoMdau+llT0UFUwcV56xxdcS61B+knBtxUWPTaQE3R6bicSfhFF6wdWOp
         Mb8w==
X-Gm-Message-State: APjAAAWZiZUklG55Hqbk2YzLi/vPpp2zbwMEDtu3m+8OIMmCZ757L6X5
        R6Rg2OnMuIOrousyDa7PYHs/I1o/5FM=
X-Google-Smtp-Source: APXvYqwTwrxltSEeEfWFGEFYdfRXcxsVMfAsPFpvxPV0z+bKwMofG0gcPjWT3SFpgAhiAupjJhHfeA==
X-Received: by 2002:a62:4ecc:: with SMTP id c195mr23247816pfb.158.1580704281071;
        Sun, 02 Feb 2020 20:31:21 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id z29sm17823374pgc.21.2020.02.02.20.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 20:31:20 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [Patch nf v2 3/3] xt_hashlimit: limit the max size of hashtable
Date:   Sun,  2 Feb 2020 20:30:53 -0800
Message-Id: <20200203043053.19192-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
References: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user-specified hashtable size is unbound, this could
easily lead to an OOM or a hung task as we hold the global
mutex while allocating and initializing the new hashtable.

Add a max value to cap both cfg->size and cfg->max, as
suggested by Florian.

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 06e59f9d9f62..60c023630d14 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -837,6 +837,8 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return hashlimit_mt_common(skb, par, hinfo, &info->cfg, 3);
 }
 
+#define HASHLIMIT_MAX_SIZE 1048576
+
 static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 				     struct xt_hashlimit_htable **hinfo,
 				     struct hashlimit_cfg3 *cfg,
@@ -847,6 +849,14 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
 
 	if (cfg->gc_interval == 0 || cfg->expire == 0)
 		return -EINVAL;
+	if (cfg->size > HASHLIMIT_MAX_SIZE) {
+		cfg->size = HASHLIMIT_MAX_SIZE;
+		pr_info_ratelimited("size too large, truncated to %u\n", cfg->size);
+	}
+	if (cfg->max > HASHLIMIT_MAX_SIZE) {
+		cfg->max = HASHLIMIT_MAX_SIZE;
+		pr_info_ratelimited("max too large, truncated to %u\n", cfg->max);
+	}
 	if (par->family == NFPROTO_IPV4) {
 		if (cfg->srcmask > 32 || cfg->dstmask > 32)
 			return -EINVAL;
-- 
2.21.1

