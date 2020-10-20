Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A19293276
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389635AbgJTA6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgJTA6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:52 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7B1C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:52 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4CFZy24n89zKmhR;
        Tue, 20 Oct 2020 02:58:50 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ZmcorbrPMgjrIZayfJYiaBA5bEJCBbxu/j8cQOBIGw=;
        b=N9PcSRa/nwPT1BdWY+xEZh0PE7Y511UDAq4Edms7/cNPjBeAGrAVY/w2COO5a7TpJi+XWA
        ncm8mN1MedTAmRYFsDkzJ/Pyqej0YKvwxElf31m3tQk4n9n/1KlprqW2L1k9gMWjJUWYRV
        M9EJHl15YamacnRV8IGNIAxeZXF9m8A/Q0RiJL8j7DPtiOjFIJrUTSQra4Jdd/fhX6wvjX
        d05qcaZRzxDCE/V1GM1wM94XyPBKsu2KHE1Ucb9bhf9E0oVXVWbu7nP94ebvfrfi9s2cC4
        EBp+lRw+/TeGA2XNy4S/3/LpXSvbkIZqS8L5ClSu7XDElJLZqewAO6O2k2Vg4w==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id t7i6GL-sPRsp; Tue, 20 Oct 2020 02:58:47 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 04/15] lib: Add parse_flag_on_off(), set_flag()
Date:   Tue, 20 Oct 2020 02:58:12 +0200
Message-Id: <56315f7e2213456852b021997b974eff5e45174d.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.51 / 15.00 / 15.00
X-Rspamd-Queue-Id: 460CC17E7
X-Rspamd-UID: afbf8d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some iplink code makes a heavy use of code that sets or unsets a certain
flag depending on whether "on" or "off" of specified. Extract this logic
into a new function, parse_flag_on_off(). The bit that sets or clears a
flag will be useful separately, so add it to a named function, set_flag().

Signed-off-by: Petr Machata <me@pmachata.org>
---
 include/utils.h | 10 ++++++++++
 lib/utils.c     | 11 +++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index bd62cdcd7122..681110fcf8af 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -325,8 +325,18 @@ char *sprint_time64(__s64 time, char *buf);
 int do_batch(const char *name, bool force,
 	     int (*cmd)(int argc, char *argv[], void *user), void *user);
 
+static inline void set_flag(unsigned int *p_flags, unsigned int flag, bool on)
+{
+	if (on)
+		*p_flags |= flag;
+	else
+		*p_flags &= ~flag;
+}
+
 int parse_one_of(const char *msg, const char *realval, const char * const *list,
 		 size_t len, int *p_err);
 int parse_on_off(const char *msg, const char *realval, int *p_err);
+void parse_flag_on_off(const char *msg, const char *realval,
+		       unsigned int *p_flags, unsigned int flag, int *p_ret);
 
 #endif /* __UTILS_H__ */
diff --git a/lib/utils.c b/lib/utils.c
index 930877ae0f0d..fb25c64d36ff 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1763,3 +1763,14 @@ int parse_on_off(const char *msg, const char *realval, int *p_err)
 
 	return parse_one_of(msg, realval, values_on_off, ARRAY_SIZE(values_on_off), p_err);
 }
+
+void parse_flag_on_off(const char *msg, const char *realval,
+		       unsigned int *p_flags, unsigned int flag, int *p_ret)
+{
+	int on_off = parse_on_off(msg, realval, p_ret);
+
+	if (*p_ret)
+		return;
+
+	set_flag(p_flags, flag, on_off);
+}
-- 
2.25.1

