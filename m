Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CFEC9420
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 00:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbfJBWKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 18:10:53 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40112 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfJBWKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 18:10:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so446315wmj.5
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 15:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBeTS2U2w8sXRV1i6bNHX9iNyksRjgScH9zrIaBN26c=;
        b=miBqy6qDm0H3EvmToYPvQ5BxCHfnosR4tfwQb33Sa+pQqgDmlLgmgeU44ckfxTEsaR
         9WJeIh0JHABiNO16e9n5lvlkg8EGQbilIal+y9MaxqQVKVIGNAFNqQyg1WAMEPjm1k3O
         ULanEHxUq7pn/bVPqDdKHVtKHas+QZGJBBk7plkYH621pfdrPYfxU4nmuhoAAiBH9nU/
         RRKQSKyM8bT9Hxm2d3mRf2371FRQL3J6LTKLItCZR39wAoQqhdsZFDhSiCfYewrx0L4/
         8oWL6lwWTXyek74ORIEOw0pOqHS4f+z9F4dRGYyRKzxGOUJ93mKbkAWcZbN4mQdCxJ+j
         7UeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBeTS2U2w8sXRV1i6bNHX9iNyksRjgScH9zrIaBN26c=;
        b=BPcn7yIqoYl87yoiAHw4FGHcQHvro0i1r1BKeMA4YWFvwZBuQWd+Y7EcgNvX8MiYOg
         TQRJK/BjIt8O+fiPAT7SortqHpqX3MTzYKCDbazqsqqG4iF+DOatfh5S/h0XAwWyENw4
         wByXEY3temqLROzkdpemekLWbW0e9a4zoWL5g0ctOglra0MEbz3Hz9U4wnk5gBdh4HNw
         noAh3wzlb9bs9Hop6sy0PlPZRyKPscitrZgWAP4U61oTDBUS0JT5j/8ocxvfqjCu5TvZ
         TG5lxXIyojLaOuOOgskyjADG9pIyBpXMKioBQKhyApej1tko6buGOHAEC5Gp+D7kIZjN
         NDtA==
X-Gm-Message-State: APjAAAUfBt3gJeUPaEa6OUV0rroVrUowke/onUj0pXdkt3I7mGvLD7i5
        pRi5Wt+sd8QvVP2b8anQbPHftih8
X-Google-Smtp-Source: APXvYqxN+rsZXR/79hfVeKh6k5JjMbf8eYEg/iw8Xwz0QGOWlFp6qGPvd7bST2cJB1XHwcMipfHD2g==
X-Received: by 2002:a1c:1fd3:: with SMTP id f202mr4409058wmf.18.1570054250251;
        Wed, 02 Oct 2019 15:10:50 -0700 (PDT)
Received: from pif.criteois.lan ([91.199.242.236])
        by smtp.gmail.com with ESMTPSA id h6sm707973wru.60.2019.10.02.15.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 15:10:49 -0700 (PDT)
From:   William Dauchy <wdauchy@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, William Dauchy <wdauchy@gmail.com>
Subject: [PATCH] tcp: add tsval and tsecr to TCP_INFO
Date:   Thu,  3 Oct 2019 00:10:17 +0200
Message-Id: <20191002221017.2085-1-wdauchy@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tsval and tsecr are useful in some cases to diagnose TCP issues from the
sender point of view where unexplained RTT values are seen. Getting the
the timestamps from both ends will help understand those issues more
easily.

Signed-off-by: William Dauchy <wdauchy@gmail.com>
---
 include/uapi/linux/tcp.h | 3 +++
 net/ipv4/tcp.c           | 5 ++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 81e697978e8b..fecd4d0f177c 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -276,6 +276,9 @@ struct tcp_info {
 	__u32	tcpi_snd_wnd;	     /* peer's advertised receive window after
 				      * scaling (bytes)
 				      */
+
+	__u32	tcpi_tsval;          /* Time stamp value */
+	__u32	tcpi_tsecr;          /* Time stamp echo reply */
 };
 
 /* netlink attributes types for SCM_TIMESTAMPING_OPT_STATS */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 79c325a07ba5..7d0968df99c9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3229,8 +3229,11 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_probes = icsk->icsk_probes_out;
 	info->tcpi_backoff = icsk->icsk_backoff;
 
-	if (tp->rx_opt.tstamp_ok)
+	if (tp->rx_opt.tstamp_ok) {
 		info->tcpi_options |= TCPI_OPT_TIMESTAMPS;
+		info->tcpi_tsval = tp->rx_opt.rcv_tsval;
+		info->tcpi_tsecr = tp->rx_opt.rcv_tsecr;
+	}
 	if (tcp_is_sack(tp))
 		info->tcpi_options |= TCPI_OPT_SACK;
 	if (tp->rx_opt.wscale_ok) {
-- 
2.23.0

