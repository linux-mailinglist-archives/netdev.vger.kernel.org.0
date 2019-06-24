Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B557B5101A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbfFXPPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:15:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42689 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbfFXPPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:15:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id x17so14313590wrl.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 08:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eFxQtHNbklTzw4atrPuWVjwLgcK262Tq+j/R05zASXc=;
        b=obh+VF8IM7N5j8IieOGVJVFJSkgrzPxF5ikbL4rtqdOpV9RTgeVjGz5yyhG2fgMKjS
         tE84AkueBme8UkmJpBeo8m0H+EM9SEj5Zr/rLiyz7njodO9QyaoiwZqoy4fg367sDHgU
         Gv0CjTui0Sw0oNAZtVSRAyZ4nmaO0Niq4YbubHEHQ0Y+h+7l50zjiJUfrGzCRZlOQPSz
         b1WfDodNo3mHK8utXAbdbtt5NoOpsNRBzRwfP02QFyg3rmcC+t++pfbuA2yJYnZCwNGe
         NUxYr009GtT9U6mBcJiI8xBLIEcDW1lJKwzFPWM+mlkIb5OmhQQw93iFmhAXbkI7tk7s
         M67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eFxQtHNbklTzw4atrPuWVjwLgcK262Tq+j/R05zASXc=;
        b=caE6dJyg48mweHAYFb4SMMRmCap5FP+Pg/35Hjc8LrLZS5Byh/wrUef/WVpb6dgKFW
         wBdJzWZtjBvtYgRW67jhgergRj2no2/VeLOYPBoYbYGrOZPAyVdtG++kcKuaxNn73uIU
         P3TUbryxlIGuzoPzoAVr6WOA659jwvlvuNQpL2bOxj3n11N1CjgL80CNYC53z85bl5rh
         vagz7aOsaLVvrqG82O7lWkGrxyw8KXeC0SHztUB/zPS9IMoFx8QT11/z6963mf/DeLHM
         Lx5yYeO/VUO/oJhF+9YKqmkOLdBG5vBIJmT9dGZYOVRxG/iT1Uq8fuHklBIBt2zzwXXP
         OuAw==
X-Gm-Message-State: APjAAAXfGT4hhCerlsvGuy6LbRAdLHCMZOUiBfM7QGV2A0FUuVFAL0BC
        WDa/IXM8xjIEq+2AbnbL5yQ=
X-Google-Smtp-Source: APXvYqxcLTkVmXxrQrGZJDVgflmNm/q8JcmkEO5b5Braskzszw0GQEUFG0UsEs7HsiQWfMyj01Lk7Q==
X-Received: by 2002:adf:9e89:: with SMTP id a9mr3851503wrf.78.1561389335903;
        Mon, 24 Jun 2019 08:15:35 -0700 (PDT)
Received: from eyal-ubuntu.mshome.net ([176.230.77.167])
        by smtp.gmail.com with ESMTPSA id e21sm19818196wra.27.2019.06.24.08.15.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 08:15:35 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH iproute2] tc: adjust xtables_match and xtables_target to changes in recent iptables
Date:   Mon, 24 Jun 2019 18:14:57 +0300
Message-Id: <20190624151457.30151-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iptables commit 933400b37d09 ("nft: xtables: add the infrastructure to translate from iptables to nft")
added an additional member to struct xtables_match and struct xtables_target.

This change is available for libxtables12 and up.
Add these members conditionally to support both newer and older versions.

Fixes: dd29621578d2 ("tc: add em_ipt ematch for calling xtables matches from tc matching context")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 include/xtables.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/xtables.h b/include/xtables.h
index b48c3166..583619f4 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -206,6 +206,24 @@ enum xtables_ext_flags {
 	XTABLES_EXT_ALIAS = 1 << 0,
 };
 
+#if XTABLES_VERSION_CODE >= 12
+struct xt_xlate;
+
+struct xt_xlate_mt_params {
+	const void			*ip;
+	const struct xt_entry_match	*match;
+	int				numeric;
+	bool				escape_quotes;
+};
+
+struct xt_xlate_tg_params {
+	const void			*ip;
+	const struct xt_entry_target	*target;
+	int				numeric;
+	bool				escape_quotes;
+};
+#endif
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -270,6 +288,12 @@ struct xtables_match
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+#if XTABLES_VERSION_CODE >= 12
+	/* Translate iptables to nft */
+	int (*xlate)(struct xt_xlate *xl,
+		     const struct xt_xlate_mt_params *params);
+#endif
+
 	/* Size of per-extension instance extra "global" scratch space */
 	size_t udata_size;
 
@@ -347,6 +371,12 @@ struct xtables_target
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+#if XTABLES_VERSION_CODE >= 12
+	/* Translate iptables to nft */
+	int (*xlate)(struct xt_xlate *xl,
+		     const struct xt_xlate_tg_params *params);
+#endif
+
 	size_t udata_size;
 
 	/* Ignore these men behind the curtain: */
-- 
2.17.1

