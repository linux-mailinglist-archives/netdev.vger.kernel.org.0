Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF5C4AF4AA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiBIPCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:02:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbiBIPCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:02:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BE75C0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 07:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644418970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iyN5oXAdR+1KgWlXLwn4IxXizXoaPkpGjMVEu9vunXY=;
        b=bZ5VHC34v5Ro63LCvXEnoSZU/oFknJv2XugW1zTuu/2OLWw5sNVZiK4WYLJ3O3O6FKOndy
        AeDkybFStuuCqi47ZzaZZO2B/vS5SdMxag796TFuatuqolVdnxDgTwBYs79S+6diHx+0JZ
        v5aDnxGj4DRDR7yZ5ylqxng5xjdk24o=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-p-ptU-ziPkqpuxK7S5EgBQ-1; Wed, 09 Feb 2022 10:02:49 -0500
X-MC-Unique: p-ptU-ziPkqpuxK7S5EgBQ-1
Received: by mail-qt1-f197.google.com with SMTP id a9-20020aed2789000000b002d78436cc47so1892722qtd.12
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 07:02:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iyN5oXAdR+1KgWlXLwn4IxXizXoaPkpGjMVEu9vunXY=;
        b=hWw6n+9xBRugTsJ9J9IV0lZYDDnHIKiU9XJhGtdXAQgGH/0HCHeCMmPK+c7bXBxCQA
         Ono0BC4JoUSqmFcPvnqze4ED3YnpTkqSnYuNRLrtLl7Q9X3lOtD6vUGS3vfvtZQNUo1f
         r4aAPRhlNpsEVX58EeL3FghRRAu0vovBIyTUp4W2XTUOknyqTiizZntMuA9Xaqy9ikan
         J9deVh4WXb0ffFXKyXgcBMfqDeHgOMQ9z2ANWjRuY3lZ4B0zAF/LhzgKl0a5HjxLPc3Q
         8ZRHTZRi6TGzp/e64w8S8e3hZChwyNlV727Z8MTn6Ak6hQpKYoLoWKFtAlhnL2Z1x98x
         pKLg==
X-Gm-Message-State: AOAM533R9s1JwwWsE2yTbuc/dAjBioh4hrvZ/ZqDqJvV/22TvVXUucxv
        Ml5Iwzp4Z09PZXYSfnHECXlK5Yj3Jv8YZXwSQAGQ4avliU+e7l6MJyUAHxBqIqRo2b5PS/6QmpO
        plN6eCPD/FaYYkrrs
X-Received: by 2002:a37:a3d2:: with SMTP id m201mr1296711qke.207.1644418968451;
        Wed, 09 Feb 2022 07:02:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCdq/55Q1gZ9pOKmf595RR79TBJCs1r4SD6oyvo1ypUkS9q2jEpetqKV7Sf7jGQj28+QPAQA==
X-Received: by 2002:a37:a3d2:: with SMTP id m201mr1296691qke.207.1644418968172;
        Wed, 09 Feb 2022 07:02:48 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id 22sm9418260qtw.75.2022.02.09.07.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 07:02:47 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, alobakin@pm.me,
        edumazet@google.com, pabeni@redhat.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] skbuff: cleanup double word in comment
Date:   Wed,  9 Feb 2022 07:02:42 -0800
Message-Id: <20220209150242.2292183-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Remove the second 'to'.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0118f0afaa4fc..9d0388bed0c1d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -681,7 +681,7 @@ static void skb_release_data(struct sk_buff *skb)
 	 * while trying to recycle fragments on __skb_frag_unref() we need
 	 * to make one SKB responsible for triggering the recycle path.
 	 * So disable the recycling bit if an SKB is cloned and we have
-	 * additional references to to the fragmented part of the SKB.
+	 * additional references to the fragmented part of the SKB.
 	 * Eventually the last SKB will have the recycling bit set and it's
 	 * dataref set to 0, which will trigger the recycling
 	 */
-- 
2.26.3

