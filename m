Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A9480B65
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfHDPKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46027 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726190AbfHDPK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so2981223wre.12
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TJZCFi6SWGuL941FTbm8PAdV1InyCLO80UmCo8oiYsY=;
        b=koC4RGQdg5eoK/PpI4npTbdhRC/tL9lb9Ca5Fl3EP5i+PMLTP/3tQ/joBlxno4/Moq
         TgG2mZDAPcnRXcaHQeG48+0JatO/Z0bFjtx6wTBcinGLMH/a53XrsthpjSYCPD+u2YOS
         M1P6Jyrcx3zIM/Ey59w37krFnQj+wQ/yAmnP1MyYk+OduBs5Jfwm2ct3AjllU3F15DzP
         5kSaTS249nh3nyUEJMDDJeXdxcZqO5sBRLtG9ngJl4SfUInrN/IJJlG6o0yQs2gkBA2/
         2Tli5XSTgvAv/BMN6RMMFX8Kfh2sT992K+dY7KLJA6umqnDftBjlepPSBjvKc0ghlu8w
         7MmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TJZCFi6SWGuL941FTbm8PAdV1InyCLO80UmCo8oiYsY=;
        b=Es6uxQVvHz5z6GLSceqGvpR4S80najmSxwaJ3bsYfY2cwtvBAMlBUSt3zCbq337RUE
         Kd+RIxMEXXiTJMp95Qf6F2soR0KehIM3oAJ8SwU+DppE3YI3beE6cs9HXTYl8gmMhXef
         +YvBK3FC/aE412wbNjjfbMcfM2fnYsYjo0B2BgRFrd2lk5aydTdYsxvG/j9M3RjjAeSn
         gvaYZ5KrSOy1J27k3buiWvTf76D+kSaUKeHl/6zNU6d/Iiy/tUljAOqOK6J31hibwlVp
         9fbNd4vbuEQMmgRm1v9CEn3w/FoxkcjTvxrQSnQwCxYZVRAITBYn8rciVJ5Xc/LIk/S/
         Rw1Q==
X-Gm-Message-State: APjAAAW0Jbp06L1uCzp3GQLwOKhgf5kHNUBWyFkjpcPrZWS/eTZSPCIp
        NiSclqlEhsmIuTYbFCW1fJ7KOM7PB6I=
X-Google-Smtp-Source: APXvYqxgAdbVPOVBOEDPJv1FoQRbcUzLeKMu4NRD3BJ+gT6dENdcsHa2odhtexeu4ZN4Q2XqyjLYZQ==
X-Received: by 2002:adf:f601:: with SMTP id t1mr61201347wrp.337.1564931426722;
        Sun, 04 Aug 2019 08:10:26 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:26 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 03/10] net: tc_act: add helpers to detect ingress mirred actions
Date:   Sun,  4 Aug 2019 16:09:05 +0100
Message-Id: <1564931351-1036-4-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC mirred actions can send to egress or ingress on a given netdev. Helpers
exist to detect actions that are mirred to egress. Extend the header file
to include helpers to detect ingress mirred actions.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/tc_act/tc_mirred.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/net/tc_act/tc_mirred.h b/include/net/tc_act/tc_mirred.h
index c757585..1cace4c 100644
--- a/include/net/tc_act/tc_mirred.h
+++ b/include/net/tc_act/tc_mirred.h
@@ -32,6 +32,24 @@ static inline bool is_tcf_mirred_egress_mirror(const struct tc_action *a)
 	return false;
 }
 
+static inline bool is_tcf_mirred_ingress_redirect(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_MIRRED)
+		return to_mirred(a)->tcfm_eaction == TCA_INGRESS_REDIR;
+#endif
+	return false;
+}
+
+static inline bool is_tcf_mirred_ingress_mirror(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_MIRRED)
+		return to_mirred(a)->tcfm_eaction == TCA_INGRESS_MIRROR;
+#endif
+	return false;
+}
+
 static inline struct net_device *tcf_mirred_dev(const struct tc_action *a)
 {
 	return rtnl_dereference(to_mirred(a)->tcfm_dev);
-- 
2.7.4

