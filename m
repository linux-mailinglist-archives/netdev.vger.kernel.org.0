Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164F32E2F68
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 00:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgLZXpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 18:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgLZXpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 18:45:51 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7BCC061757
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 15:45:11 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id q25so6278248otn.10
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 15:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lk0phBs3X5rgsqgQ6uEzk6TdNuxFjdz7cjiUAWnLWts=;
        b=gdfiqRhwjRW+QMRFVlUarh838kSrhvR0H9NhKbk8V29k7UozleYawt0f3lChF3laoF
         mXJllWmRfAKf467eBFcCDxjQz4hVAbtFL4ucsATC8T9M96crKryBU4cPygh+8JRMGuXt
         jz7l7n8vJOskXzrrTCMJpRKv1KBsT6dB2Ga3qkeflnbRhNyLUXvwEPsQUX3ej51EkWlO
         zMjN+TMMKz6vjBa7gmEYFXUShRdIp21/g5nJMaxh7qzyve0ainqRxGhYWfldFww6DFqo
         EWMc0VBvLC4hQgY/ns25cjOU/MGaNUOS5PgggBj2FTo0nYpFC7M/MziJ7w8OwfCbEADK
         UOIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lk0phBs3X5rgsqgQ6uEzk6TdNuxFjdz7cjiUAWnLWts=;
        b=OR9iD08N1hGawicQzqplc4RX0TovqSVAG3oGMUO81Cq91eT55fhv3viO4H01lEMawF
         b7Lpegp7csIyXIbsiINtmcr0Bt4ioFm8YAp3LAEA62YDixTZa4vDcpGZflPQsdirsOog
         zFb00syjSlbg5J5K3Xpk4/ReCbnzSqQHQ4yd8Sav+zdeayL2qOT3uQpvIsi/ma94p5s+
         sLUGRekZ25w4SDXoRBNhLDqR3FgLee+QcnUJyGEYD0c/ogTlQt/3CYlmoJeqm24LSESv
         QRprmuwsfPobNBCz+UzCNTDlvhMMHoTSEUex4SS9YLwKTvRCK/mse1PPjQW2wkZOwrqj
         2FRg==
X-Gm-Message-State: AOAM531u79Q+ySapkSw93l3jVWwo8uaqDS44iuLsbPCm3vJlZKyvWB2r
        1FQlVt2Jq6p0qFx7pxFhJqGesZA/O+reZg==
X-Google-Smtp-Source: ABdhPJwQtpFSM/PrSeMqs1uYNKuM4rBONyDKPc0EzBTP3jG9dd15SyKxxq2fEkmlZAi+0V5yOBi3vw==
X-Received: by 2002:a9d:3d06:: with SMTP id a6mr27952972otc.368.1609026309623;
        Sat, 26 Dec 2020 15:45:09 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id v3sm8356597oth.80.2020.12.26.15.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 15:45:08 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+f583ce3d4ddf9836b27a@syzkaller.appspotmail.com,
        William Tu <u9012063@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [Patch net] erspan: fix version 1 check in gre_parse_header()
Date:   Sat, 26 Dec 2020 15:44:53 -0800
Message-Id: <20201226234453.905884-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Both version 0 and version 1 use ETH_P_ERSPAN, but version 0 does not
have an erspan header. So the check in gre_parse_header() is wrong,
we have to distinguish version 1 from version 0.

We can just check the gre header length like is_erspan_type1().

Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
Reported-by: syzbot+f583ce3d4ddf9836b27a@syzkaller.appspotmail.com
Cc: William Tu <u9012063@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/gre_demux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index 66fdbfe5447c..5d1e6fe9d838 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -128,7 +128,7 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 	 * to 0 and sets the configured key in the
 	 * inner erspan header field
 	 */
-	if (greh->protocol == htons(ETH_P_ERSPAN) ||
+	if ((greh->protocol == htons(ETH_P_ERSPAN) && hdr_len != 4) ||
 	    greh->protocol == htons(ETH_P_ERSPAN2)) {
 		struct erspan_base_hdr *ershdr;
 
-- 
2.25.1

