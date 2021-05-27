Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2331393605
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 21:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbhE0TOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 15:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbhE0TOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 15:14:15 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70292C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 12:12:41 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id k4so1807864qkd.0
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 12:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Icx80J0jK+NMp7ykdWHeBIKaWKfxn1uiw7i2uaTmpic=;
        b=VRaHHgmDtYXLKs8J2DoqPB2w60H3j+rSgvz9ioOW/ZIl5Fs3PZTD9IHVKgjRZ7ewyS
         GYkjHgMUjxloyEF3ku2QItPG4PDN85qW8/bJbLJy++l5HFMVD9FwgyC2D2QUdJsfLupC
         P5Q6AlYaNvORoAt5rBFtYzYKhbxA7De8FqujMXAAfm8HAnXBftiEylr7Qud7dwQX+rIU
         5zrsuhq5GuDOU7KntsPQBv0zJn+jnBa1evGNxl4TbqnryhHwP9yTUZCNves7+Z5q7ymM
         uypGoi8Fttm4rj/XEqVpcwCg3FBpV82FtCbj2fJUmG5YmScxvkTNIFSfCU7b7+v7Wny2
         PGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Icx80J0jK+NMp7ykdWHeBIKaWKfxn1uiw7i2uaTmpic=;
        b=hKf6xKO43aQyyIixvzaZHoOfyo+4qBmz/NLEkqcU7FTkIAk8xfmp34NUckiQoUS4c/
         nBLwXw8j0JsgEmu50KkNCqH+Fknt2qN4V3uZsMgnJHuUM+lLZknXIdSB0tEu+RGXxDCd
         GyVAHdkD6QU62hNpuMhsI3vvsH6lyoLcbSNWRwsFXFWi1EdZlTenEDjjeghX6/zdTC8/
         MdkyiWtB9aKHi7g/hFDll6ud9XgeR0v/vMJ6DdMRRYzzsjnnuPy94JE6R4CCfv1AHsjG
         Cab6sC+upbK8YqcX4t/LEsrEUx1sqL2xpSsnhMFJUkt0I27C6vLzZYHoGM9cHe+75Rqf
         svaQ==
X-Gm-Message-State: AOAM530hezk9nx3emS8CJ2ZSp6UAvX19wRHeuUJNE9JocxKUcgDA4OHZ
        BY9y6njRzab2T8XkxzqAVGsXkhn8ns6tCA==
X-Google-Smtp-Source: ABdhPJxAp3GxF/MvjXiFv7lSCli6bmUCd0wXWT0wGlmmAbwaqPgDnVZIqQuZYPCoeRyScf4JAUWGoA==
X-Received: by 2002:a05:620a:2291:: with SMTP id o17mr21916qkh.150.1622142760296;
        Thu, 27 May 2021 12:12:40 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id g5sm2123516qtm.2.2021.05.27.12.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 12:12:39 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] udp: fix the len check in udp_lib_getsockopt
Date:   Thu, 27 May 2021 15:12:39 -0400
Message-Id: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when calling UDP's getsockopt, it only makes sure 'len'
is not less than 0, then copys 'len' bytes back to usespace while
all data is 'int' type there.

If userspace sets 'len' with a value N (N < sizeof(int)), it will
only copy N bytes of the data to userspace with no error returned,
which doesn't seem right. Like in Chen Yi's case where N is 0, it
called getsockopt and got an incorrect value but with no error
returned.

The patch is to fix the len check and make sure it's not less than
sizeof(int). Otherwise, '-EINVAL' is returned, as it does in other
protocols like SCTP/TIPC.

Reported-by: Chen Yi <yiche@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/udp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15f5504adf5b..90de2ac70ea9 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2762,11 +2762,11 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
-	len = min_t(unsigned int, len, sizeof(int));
-
-	if (len < 0)
+	if (len < sizeof(int))
 		return -EINVAL;
 
+	len = sizeof(int);
+
 	switch (optname) {
 	case UDP_CORK:
 		val = up->corkflag;
-- 
2.27.0

