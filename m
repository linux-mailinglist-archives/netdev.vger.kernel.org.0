Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F125C3E1057
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239629AbhHEIcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239572AbhHEIcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:32:12 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B46C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 01:31:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z11so7180629edb.11
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 01:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmHPk02ecFhhLFxeJX7p5e9amiKU0ZRM+eqQQmDy/pE=;
        b=kguRDLeRsmg0kGdl+ZWTy6seL2aHvT9ZWRaF10F/WQW6w78MYeuwO2vWlGwuAsZada
         BKELLtfd7IiQc+DGwQ8JXXC8saSwI8VTE21x7oWzC+43a30Z2qhUOJRV6BfeGeneW030
         +TPgvGfU2tNNwn9L7ut91IIZAt/Em8ZTS/U8sX9AGk2CpHXNclZg0XE4I4e5ys6BP9Iy
         /Hj9AyeJLAw5gzkf2hqz2XmafU9jN2eOtH87ODe184FGyLBDPffxREJMt1MO4Lui7tTf
         ZX+/+2jebvLsIcOCLtyHF55ypFsS0cD3VJ2Ia1D9/ew0a4TBAlO6g2QNi9j/45N2qpM6
         o34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmHPk02ecFhhLFxeJX7p5e9amiKU0ZRM+eqQQmDy/pE=;
        b=jwa2SCAxROb2bne8xCpqmpGSrnnUrQCeuMMj4Nfp1OwA+VI/9Zbh6i/aWWln3sRc1z
         +3O/xrnSl+k2pwJEz6dqi0Wn511S3SU0yi24xSQS9pcJdLET89tnHYSLv0DEfLFITBHZ
         Iwe+D7gI690mlTj8zLs4LAEwrIk32mkYGgXfy0aLP8LZvtHio9ZpB1B7SY1cqOUNhEsM
         eqngVLjV4QnQKr9u7lJCfL0Ktoxlxh3yy+nYyb+2H01vn/BzWJm2TET04cdEqNwF4ygv
         J13NGWjVGWXPUc7IAtZtpPbM2q3EyZPkK0Q7daJ6wT5sdZ245To4/7Xg2pdBLLy7NSnR
         GYyw==
X-Gm-Message-State: AOAM532vBZjeX3IBz1hhoEWvW8j0EatmCDevUdTWxEjU62qAxEUOsCuw
        sbRgyI2LrxjkNjFeAhHAln3RlbCowD+Mxi2f
X-Google-Smtp-Source: ABdhPJyz5M3ujufHhNf1vUJAjHsCKvV8fK+Q3UjRQVGf/0qcyzy7/iZWa0TVm324nQyAof78TVNcfA==
X-Received: by 2002:a50:ff19:: with SMTP id a25mr4859173edu.311.1628152317234;
        Thu, 05 Aug 2021 01:31:57 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bm1sm1471611ejb.38.2021.08.05.01.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 01:31:56 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, arnd@arndb.de, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 2/3] net: bridge: fix ioctl old_deviceless bridge argument
Date:   Thu,  5 Aug 2021 11:29:02 +0300
Message-Id: <20210805082903.711396-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805082903.711396-1-razor@blackwall.org>
References: <20210805082903.711396-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Commit ad2f99aedf8f ("net: bridge: move bridge ioctls out of .ndo_do_ioctl")
changed the source of the argument copy in bridge's old_deviceless() from
args[1] (user ptr to device name) to uarg (ptr to ioctl arguments) causing
wrong device name to be used.

Example (broken, bridge exists but is up):
$ brctl delbr bridge
bridge bridge doesn't exist; can't delete it

Example (working):
$ brctl delbr bridge
bridge bridge is still up; can't delete it

Fixes: ad2f99aedf8f ("net: bridge: move bridge ioctls out of .ndo_do_ioctl")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index 2f848de3e755..793b0db9d9a3 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -351,7 +351,7 @@ static int old_deviceless(struct net *net, void __user *uarg)
 		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 			return -EPERM;
 
-		if (copy_from_user(buf, uarg, IFNAMSIZ))
+		if (copy_from_user(buf, (void __user *)args[1], IFNAMSIZ))
 			return -EFAULT;
 
 		buf[IFNAMSIZ-1] = 0;
-- 
2.31.1

