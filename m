Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB4B46E432
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 09:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhLIIcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbhLIIcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 03:32:31 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93172C061746;
        Thu,  9 Dec 2021 00:28:58 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 8so4767678pfo.4;
        Thu, 09 Dec 2021 00:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vxr3shVG7qN/DbBNTNRxI1Vzvo0/YokyiEU01gJT4zY=;
        b=h8gKmrQgq3UN1DWUasdTXd35dn7wsBYe8wPxSW6Kv8CE0RqqQhINbRG5c9EamfhsNX
         jEJK2/UZ5FTxDNSihvoMC5OA+doeevnrtHZfFVBgHzssyGrw8XkXaZUUTfAchgzCp5wv
         oIRF4DHe0rvLypnUsQhG0kPvzXIogwPuQUIXDA58Irv3O3krQm0DJq94iA4AQkvzGhve
         XGf0mthWInB8ES0LMxdT7sLpJUw0U5tDPNX9mpnlDA3r65959JO4pmEmQoroDO4e3bxE
         UqsQCZJJDpp6sG0J2fEG7nCSqI+w0osFUNwD3ygyJkBUeDSmDz3yOUH82bS18KWensza
         DjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vxr3shVG7qN/DbBNTNRxI1Vzvo0/YokyiEU01gJT4zY=;
        b=sI/01HSuSs9ZYtpPByUI8mUTPYkdDJdd2G6brhbXidiCE05Dm1CYE0krrTFOacJA5J
         KCiej4qHf9+yV9pJ52PIkL57qPXzIC99OQ8ILIQYd1TTB83YQoFPIh8df1hiuE6+OT28
         GX15pZKTqISkg5geZBI341OGcDu1G72ljWS0E9xeF4sqh156a6Ydc6UCRRsGIh8+zo1r
         z/YAyY/DL1cyYMGr2DhmW7d2HnWPmkWf3uZYYgs3S5Tr8cRwUo2iGFMbZDpYHzmOd3m1
         GFSYbALtrRgf1itm1sERZu5PqTcTbvI4EH7kaYL57suPZxEHkGVzo/ZyluzoNQBRySzv
         Z8Qg==
X-Gm-Message-State: AOAM5306alm0WZOGYgNHIRwPboi24kXluW1yozcSpV+BLUHsJAsEv53U
        4LiUV6I6WLm2dDpHsLjZTWtRVUKCyboZrnC9qHJ7wg==
X-Google-Smtp-Source: ABdhPJyZLaQygmzR8Vq4P7ybZyNwRMoNJZ3CxGBnItfpFfMAMOqX6rQrAmGIi7vWINTl2oFnNz3Evw==
X-Received: by 2002:a63:7907:: with SMTP id u7mr30531097pgc.465.1639038538170;
        Thu, 09 Dec 2021 00:28:58 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id pj12sm8674294pjb.51.2021.12.09.00.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 00:28:57 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     courmisch@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net] Phonet: refcount leak in pep_sock_accep
Date:   Thu,  9 Dec 2021 16:28:39 +0800
Message-Id: <20211209082839.33985-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
invoked in subsequent failure branches(pep_accept_conn() != 0).

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/phonet/pep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index a1525916885a..b4f90afb0638 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -868,6 +868,7 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;
-- 
2.25.1

