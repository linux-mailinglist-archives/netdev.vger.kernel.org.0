Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8A445CAB0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242709AbhKXRO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349541AbhKXROY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 12:14:24 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F42C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:11:14 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id bu11so2289504qvb.0
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 09:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Vfrj2SnVlWvnBYwm3pYtP3SbPZdfXlnI21Bodg7/Hg=;
        b=pQKgnLOdRzBHEeesEgNar5zDI1mac8ln/4u03dFSBwfyDphTacfZtOEiVUPrOsg/Sy
         1ak99Sgh61Z6kwRkReSHyrmeguOq9fAoOa1Txas9W34pwmCY2dUkXvSya0X1oxwtvH48
         zHWAUWRaxkZfBlX3BmGNYJotSRYsAy7rR0N8VAVKSR4KBNiN5UQX2Y9CPTJ6pq0lY4Ld
         ldCMTeqiF/wy9q9Dq627MwFCAozLRBak0CkLgglEyOrdr51bFS6SvCGuDgA7VumUu7SI
         SsL2YjLtqkU1CB1iF4ANR/v/2kbO3GQ91l/ip07vIzje0DOTu1sZBGzwVE3ff5NmHqrK
         oN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Vfrj2SnVlWvnBYwm3pYtP3SbPZdfXlnI21Bodg7/Hg=;
        b=8NkPHt32fkNNFX6NYaGWWexcn2/BOMHjet0Lc/5BVCof9IES+haeBk2T7+vl9zi7ji
         mheqUB3WEOsbxhxRI1niVhpDYjq70wtLZeijucR+LgShq9fIGLRG/9wIBuw3NepaiWO4
         GAJUpGchDaWrQ83+KyYCsfhARH6lFnvZCMX/fvF7V7xgZZZaWPpxWW1Q6g9lTARtpjsi
         beEcpgb3WGbl9kz6KsmgZ2iwakRFWfl1tCu6o++ABhGtJs/ZxcZzdwGl6vh/VM763n+v
         jXbc4VYjU8fvjVn/5YhBzcLpCZLLF7jQymPc8ZPwhxyjXd9tp+amuiJ4UDVfEZ8yhDq8
         5PVQ==
X-Gm-Message-State: AOAM532ioeYmlQkR2TLMnlWtQDhHfymT+3iUAAtT1awN538Y2I8LJCb5
        H2vek96sV5bB33AZ/RrstzW8OGak4ePSrA==
X-Google-Smtp-Source: ABdhPJxBo0YjmcGf08qEPVXStLCMocLsWPFf8YJ2fI9L+4nW1+dcgpqPL5ajWG27eeLqxWNOU06nig==
X-Received: by 2002:a05:6214:411d:: with SMTP id kc29mr9204931qvb.22.1637773873673;
        Wed, 24 Nov 2021 09:11:13 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bi6sm146182qkb.29.2021.11.24.09.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 09:11:13 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Tuong Lien <tuong.t.lien@dektech.com.au>, davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net-next] tipc: delete the unlikely branch in tipc_aead_encrypt
Date:   Wed, 24 Nov 2021 12:11:12 -0500
Message-Id: <47a478da0b6095b76e3cbe7a75cbd25d9da1df9a.1637773872.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a skb comes to tipc_aead_encrypt(), it's always linear. The
unlikely check 'skb_cloned(skb) && tailen <= skb_tailroom(skb)'
can completely be taken care of in skb_cow_data() by the code
in branch "if (!skb_has_frag_list())".

Also, remove the 'TODO:' annotation, as the pages in skbs are not
writable, see more on commit 3cf4375a0904 ("tipc: do not write
skb_shinfo frags when doing decrytion").

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/crypto.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index b4d9419a015b..81116312b753 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -761,21 +761,10 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 			 skb_tailroom(skb), tailen);
 	}
 
-	if (unlikely(!skb_cloned(skb) && tailen <= skb_tailroom(skb))) {
-		nsg = 1;
-		trailer = skb;
-	} else {
-		/* TODO: We could avoid skb_cow_data() if skb has no frag_list
-		 * e.g. by skb_fill_page_desc() to add another page to the skb
-		 * with the wanted tailen... However, page skbs look not often,
-		 * so take it easy now!
-		 * Cloned skbs e.g. from link_xmit() seems no choice though :(
-		 */
-		nsg = skb_cow_data(skb, tailen, &trailer);
-		if (unlikely(nsg < 0)) {
-			pr_err("TX: skb_cow_data() returned %d\n", nsg);
-			return nsg;
-		}
+	nsg = skb_cow_data(skb, tailen, &trailer);
+	if (unlikely(nsg < 0)) {
+		pr_err("TX: skb_cow_data() returned %d\n", nsg);
+		return nsg;
 	}
 
 	pskb_put(skb, trailer, tailen);
-- 
2.27.0

