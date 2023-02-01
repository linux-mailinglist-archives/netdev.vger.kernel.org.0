Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF25B685E7B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 05:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjBAEam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 23:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjBAEal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 23:30:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D83C11655;
        Tue, 31 Jan 2023 20:30:40 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 7so6685490pgh.7;
        Tue, 31 Jan 2023 20:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QhmRQh7eGRD4E8NFgtgI0rUXrNELSf240bb2M/M0oZA=;
        b=JuIp9hpOqQIDNT1wOM3MmsUKQJ3pqtNCY0ekEQGNX5i9w0KZaVqS2iGJvY06mm/LAn
         qt7z7d4yRGSHb7fS2Z5MAvN0rIwkK7UjWR2ZOOO9IQRk1INW2H+JDVnvODCelFUs1lyy
         kaw9OxfhFfj/CE0V4Lz8JMoaDJdWjO2YKVXx74XjUMqecU92FewAftJyR4ETCW2QHeI8
         g+JZAdPaa8zUVJFrmFT7IrdY75Y5fsChXI+q/AbaFX12jmuCP9iASEL+NowKSedSdQ/f
         HRWp+US2LuAPscs1Oja3pVTzkebThyitcGIVDVSSgEje+xsJ1RnLJ1Mn4MXpBiCFnhiE
         0WPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QhmRQh7eGRD4E8NFgtgI0rUXrNELSf240bb2M/M0oZA=;
        b=1JrwUlRklwdz355Kihf3rh5Uk0RirFQk+5HY2ChvoLnRd4+/7N9vFEA4kqgdW/Do8e
         zQUcdM/NjeUjk09IiKzOTcBqdUT8dPywqMTxCgmjIQXbrEsewjkcwpjYqi61dAfNIGUb
         nv2I9ZoVwMvcc++RhbRKeS7frNkDuB/urxooh6ziSiwF6ycdIHcRQerjYNaBNmXB6bCg
         OIm0dU1EMBKDHw9/KRxwUNnRJVwRri1DyV/HPSEuIShJ4+1i7As6QzorYJkcgE4gQNMu
         uAAtJghT/Q4wth66C7amvZ+NUY6mk/t8QruE0KFowJgNahbfku4fI462fltfwPTv7de/
         8fsQ==
X-Gm-Message-State: AO0yUKURlf0yrT2ffABARjOmJD0xULhbotm/fl+biuhd67PzlebdojjU
        xzMS/l8JHuLs/CQo7mWcwJx1gpynhIaVrg==
X-Google-Smtp-Source: AK7set8HcRP1PB44MnW2FWI+532Tm70mZEFd1YX94kUZmEAjQk8Jdu9kZDqWAOTz06bxfgsR7q2gJg==
X-Received: by 2002:a05:6a00:1495:b0:592:3bf3:f557 with SMTP id v21-20020a056a00149500b005923bf3f557mr1467119pfu.22.1675225839692;
        Tue, 31 Jan 2023 20:30:39 -0800 (PST)
Received: from dell.roblox.local ([50.232.73.154])
        by smtp.gmail.com with ESMTPSA id b5-20020a056a000cc500b0056be1581126sm1434021pfv.143.2023.01.31.20.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 20:30:39 -0800 (PST)
From:   Wenhua Zhao <whzhao@gmail.com>
Cc:     Wenhua Zhao <whzhao@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/socket: set socket inode times to current_time
Date:   Tue, 31 Jan 2023 20:30:19 -0800
Message-Id: <20230201043019.592994-1-whzhao@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Socket creation time are sometimes useful but not available becasue the
socket inode times are not set when initializing the inode.  This patch
sets the socket inode times to current_time().

Before the fix, the socket inode times are at epoch, for example:

    $ stat -L /proc/383/fd/3
      File: /proc/383/fd/3
      Size: 0               Blocks: 0          IO Block: 4096   socket
    Device: 0,8     Inode: 15996       Links: 1
    Access: (0777/srwxrwxrwx)  Uid: ( 1000/    arch)   Gid: ( 1000/    arch)
    Access: 1970-01-01 00:00:00.000000000 +0000
    Modify: 1970-01-01 00:00:00.000000000 +0000
    Change: 1970-01-01 00:00:00.000000000 +0000

After the fix, the inode times are the socket creation time:

    $ stat -L /proc/254/fd/3
      File: /proc/254/fd/3
      Size: 0               Blocks: 0          IO Block: 4096   socket
    Device: 0,7     Inode: 13170       Links: 1
    Access: (0777/srwxrwxrwx)  Uid: ( 1000/    arch)   Gid: ( 1000/    arch)
    Access: 2023-02-01 03:27:50.094731201 +0000
    Modify: 2023-02-01 03:27:50.094731201 +0000
    Change: 2023-02-01 03:27:50.094731201 +0000

Signed-off-by: Wenhua Zhao <whzhao@gmail.com>
---
 net/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/socket.c b/net/socket.c
index 888cd618a968..c656c9599a92 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -635,6 +635,7 @@ struct socket *sock_alloc(void)
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
 	inode->i_op = &sockfs_inode_ops;
+	inode->i_mtime = inode->i_atime = inode->i_ctime = current_time(inode);
 
 	return sock;
 }
-- 
2.39.1

