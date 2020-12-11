Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0109F2D7B2A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 17:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388892AbgLKQlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 11:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388328AbgLKQkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 11:40:37 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F08BC0613D6;
        Fri, 11 Dec 2020 08:39:57 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 3so9171409wmg.4;
        Fri, 11 Dec 2020 08:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EI9aPgpwN0kAn+NcuRM5T8sHf2sm3FLfwleKZ58A6vo=;
        b=geHwHLKj29aSotUtAIzbJd24cmBvYEM34f2q3QZuRwCln1T480zVpjAzyBxv7Es4sh
         J3qqt/PClvJUgbNmuKKZ2qlrf5u9BhM4DZe5bPomOshHiU/OQnuHYotmIYYyEOfjxLzh
         vLLidffBQvYS7M3X6+/aOEHpQsW4V/yoWPE92Ueu4IEOpiJiNORCwhEKSLKGsHsY9ych
         TPwjlbGH7sHa9FsVTvdmPBqCILV2b69Jz1qwgdzZ46FlpHO72jc3poL6TLZuZZUKF6q+
         klwBHi4rztXo2q0trxpu407vydMZeGNhZ5uaiFqYvWYj+GV00Q/MWyon9ceYYjDiO6Ex
         eQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EI9aPgpwN0kAn+NcuRM5T8sHf2sm3FLfwleKZ58A6vo=;
        b=eWjqtM2byw4xITlvSIvlRS1c7mdFCaBumUD1NwRLA1vJdjssBFCyQ6su7wn8Ar74hL
         2C8+8b1QH5FFhjkAPksaII97/eLTbn/g21tV7HmHKS0VTi//KdLRhFdsMdFqrZsUawvr
         B+IJrpyTae6tRehVW2nsLjmLEXzSERhxVnnukJR0CwJu2r0ZnIw7ZPaSGsdHkPYBRnuV
         vuzJTCGCldbWOF9mQUiJxwVH1c0ppaboybaEVyAAGC/DrhG4MOWoY7Sh+f59WtL1zkTl
         +QtJk1LksmZ1lGmdcMvY8T4GLB33WfKv5YEsObrk/osmTYm7uGC/K/n+tqI8Hh+/A/Lt
         tyiA==
X-Gm-Message-State: AOAM5323tT5lYTBF3O0HM01gZ6RFi7udOZn2Q6okgD7i1I1eW7+RpC0q
        fzhBEOq4oywvCh30Toll4X0=
X-Google-Smtp-Source: ABdhPJyHtiT4ldXUWVNk0fb3lJk2ON/ft0pbVeIt0RkzI0KkqccIPBu1mGzfyJWeK2f7+940fGA2Kw==
X-Received: by 2002:a1c:b082:: with SMTP id z124mr14137969wme.129.1607704796062;
        Fri, 11 Dec 2020 08:39:56 -0800 (PST)
Received: from localhost.localdomain ([77.137.145.246])
        by smtp.gmail.com with ESMTPSA id r20sm16061016wrg.66.2020.12.11.08.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 08:39:55 -0800 (PST)
From:   Yonatan Linik <yonatanlinik@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, willemb@google.com,
        john.ogness@linutronix.de, arnd@arndb.de, maowenan@huawei.com,
        colin.king@canonical.com, orcohen@paloaltonetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Yonatan Linik <yonatanlinik@gmail.com>
Subject: [PATCH 0/1] net: Fix use of proc_fs
Date:   Fri, 11 Dec 2020 18:37:48 +0200
Message-Id: <20201211163749.31956-1-yonatanlinik@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the failure of af_packet module initialization when
CONFIG_PROC_FS=n.

The commit message itself has a pretty thorough explanation.
I will just add that I made sure this fixes the problem, both by
using socket from userspace and by looking at kernel logs.

Yonatan Linik (1):
  net: Fix use of proc_fs

 net/packet/af_packet.c | 2 ++
 1 file changed, 2 insertions(+)


base-commit: bbf5c979011a099af5dc76498918ed7df445635b
-- 
2.25.1

