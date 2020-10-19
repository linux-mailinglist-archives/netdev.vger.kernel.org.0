Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D0E2925B2
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgJSKXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgJSKXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 06:23:36 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91325C0613CE;
        Mon, 19 Oct 2020 03:23:36 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id az3so5078335pjb.4;
        Mon, 19 Oct 2020 03:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P0flTqUoEjKLeLDMZs+dS7yc4MgogmCTQyr8rixnXj0=;
        b=P+9k91Juxx5OQo3QZiAyTFX70ff6RZuhza0H8vN34XMetuT+qq4mvhl1j+wYQqRrtf
         9MJ/bGNwMIYk86hmmcgWHxzBqrOA2LYLj+fcdKmUACLH3mj7fHYRMF42TcfI06H0RCey
         yiObDDoEPAhr/hXPO/mrfbACtPb7CdFvkisdv55IGQYezBA5Rha+KCuHdCi30DpFkn2p
         ZaTUmd1WaeabIXJYuU42Hs8WHWsHzLBNwlYx4IOzLxMQyw6wDstl7C78stUeeAQr+jXl
         NvTM5EDErHtSVp1wULWdwPsnTczI55BlHsn2yfqUhlXO7eiOQ1+yjCwGKoDT0Vu92jfa
         ZFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P0flTqUoEjKLeLDMZs+dS7yc4MgogmCTQyr8rixnXj0=;
        b=NCwA8morDPe16dVVPdB+Kx8znjjDgrqOmN0FODwMQAZChM1cF1MneJ/i9hsS16ZUJy
         66ThiZZWTybbsWnsHHaZdryleTkCaTuvAvZZhKNvPLcYcZ5qZ1lgZy29xqAtm1hIrMyP
         22uspsTSJ2EeV3CWAZwgO/B+Wc7663Mq82fRvJkycpICiNoG0yLeh8wMASXsSWSd1Ywr
         gPrWh+VcYD0+iVK/N1Mnb66NpghxZODKvgBvt4/JoBRwIe1/9kIdTv4KltPfVhV8r77n
         axF/8ztx5Ui0LmGEGPaZ+4OOUOSge3AcFZCy55NkIzgQ+0mX6R2lsX9L+MS2JCdqKsbQ
         m0XA==
X-Gm-Message-State: AOAM532fxdr2RpXsj499hNnTzKlvtruSCYQ/NZcsfoITzCnCijUHhrJV
        vIoJLPI1LjFrAzXbO3j/GAs=
X-Google-Smtp-Source: ABdhPJx+eAKIxU8KiIJIzRVU3BlR1jWSx2idEXblfWRh7ZAE3wozC/JawTKt2zX2bVCo4tvkLCdG1w==
X-Received: by 2002:a17:90b:19c4:: with SMTP id nm4mr15865447pjb.133.1603103016239;
        Mon, 19 Oct 2020 03:23:36 -0700 (PDT)
Received: from localhost ([2400:8800:300:11c:6776:f262:d64f:e94d])
        by smtp.gmail.com with ESMTPSA id n7sm2439894pgk.70.2020.10.19.03.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 03:23:35 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 2/2] mptcp: move mptcp_options_received's port initialization
Date:   Mon, 19 Oct 2020 18:23:16 +0800
Message-Id: <0371a529baaaa4796406e4335afb91ef210fa813.1603102503.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <3ae4089622f9933c18f474e6ee954f39a40bfec3.1603102503.git.geliangtang@gmail.com>
References: <cover.1603102503.git.geliangtang@gmail.com> <3ae4089622f9933c18f474e6ee954f39a40bfec3.1603102503.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moved mptcp_options_received's port initialization from
mptcp_parse_option to mptcp_get_options, put it together with the other
fields initializations of mptcp_options_received.

Fixes: 3df523ab582c5 ("mptcp: Add ADD_ADDR handling")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 1ff3469938b6..a044dd43411d 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -241,7 +241,6 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 		}
 
 		mp_opt->add_addr = 1;
-		mp_opt->port = 0;
 		mp_opt->addr_id = *ptr++;
 		pr_debug("ADD_ADDR: id=%d, echo=%d", mp_opt->addr_id, mp_opt->echo);
 		if (mp_opt->family == MPTCP_ADDR_IPVERSION_4) {
@@ -298,6 +297,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 	mp_opt->mp_join = 0;
 	mp_opt->add_addr = 0;
 	mp_opt->ahmac = 0;
+	mp_opt->port = 0;
 	mp_opt->rm_addr = 0;
 	mp_opt->dss = 0;
 
-- 
2.26.2

