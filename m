Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2322E2F86
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 01:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgL0AvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 19:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgL0AvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 19:51:12 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10664C0613C1
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 16:50:32 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id l200so8052822oig.9
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 16:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JmP+FWCZQ6cmR//zlQVCP8VJACTGtEBiFu+BCvSXSIg=;
        b=OrUifs6392NWAODr63BWiVgUeIb6c5ea7XmVWsbzVnA9siaKQyILAsFennTOSniHtL
         l4PcaIN2u2UpZbc75rSJvCItIGVg0Yqsi0wbZ1q7UZrqt6/rjxnrzjBXIuRp2Gij9vwy
         Ip5HYCAj6yhmQKvVAvpgXQVRuFJKlGbEqDtE/qxPmyxHDugo37ULZ9M0eiZR/GiwFI3k
         aZ0YRtbFXkdwZ2prVrfcuIHyFV64TjLe3iy+5vAW1IchZNU0Wo1lFp+PcUrEV76BXgwN
         N6AFMw74TQnNKPoa6WLe59s6Gx/rsL1j4KERmNm6a0rEqsnx4J6gfmQ4jas5/ayqY23r
         YFcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JmP+FWCZQ6cmR//zlQVCP8VJACTGtEBiFu+BCvSXSIg=;
        b=GYXfBLhIXtbR+cOFMA7yJI1B46c+XhjP8qqb9Bk+9BQDiJ+Ug+gr3tnO4hMdaAeXh5
         fbUFPjlOelIi8iB2Bu9B6abchkiwp7oTInZtW5XUpeYBOy+qemPPSpqsHVFQsrcC/OmH
         qFoyUIsgoiqmLzkTIrvmmLD5bqqTMNEJZYk1Cm9UF4CqthfbLlhynrqitiqY7gY29GHY
         RGrQcuWPeP98w/hRibIfoz8pO/HKPeNgps4QJUy1XS1CbXvCjYGyX4zQTS8ge4w98vbJ
         RcVsQObrW00bHWSRukUOexmxDxFi408h7R/pIKK7f1ijrTWvX/J0kr41dbI1XMcFjTDR
         yNPA==
X-Gm-Message-State: AOAM530fzby6nnqmpxHJ91yq+nXF7J4A/OWG97e/xdDOdJh+8LlBlTTH
        QsVkZBSgl+oyS4aF2lZmiPjFIGR1LBFkcA==
X-Google-Smtp-Source: ABdhPJz/2Y7d6j7mFZbYqPmqTuT0lf1+nGUc2g6GKfh7I3FTzWZo0wkf43z9ES/Ov/m8h/b0cDv62g==
X-Received: by 2002:aca:c30b:: with SMTP id t11mr8795918oif.61.1609030231204;
        Sat, 26 Dec 2020 16:50:31 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id j9sm3831064ooq.1.2020.12.26.16.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 16:50:30 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [Patch net] af_key: relax availability checks for skb size calculation
Date:   Sat, 26 Dec 2020 16:50:20 -0800
Message-Id: <20201227005021.907852-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

xfrm_probe_algs() probes kernel crypto modules and changes the
availability of struct xfrm_algo_desc. But there is a small window
where ealg->available and aalg->available get changed between
count_ah_combs()/count_esp_combs() and dump_ah_combs()/dump_esp_combs(),
in this case we may allocate a smaller skb but later put a larger
amount of data and trigger the panic in skb_put().

Fix this by relaxing the checks when counting the size, that is,
skipping the test of ->available. We may waste some memory for a few
of sizeof(struct sadb_comb), but it is still much better than a panic.

Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/key/af_key.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index c12dbc51ef5f..ef9b4ac03e7b 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2902,7 +2902,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2920,7 +2920,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2931,7 +2931,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg) && aalg->available)
+			if (aalg_tmpl_set(t, aalg))
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.25.1

