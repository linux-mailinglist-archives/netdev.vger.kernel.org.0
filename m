Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A745D3320B4
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhCIIe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhCIIeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:34:10 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC38C06174A;
        Tue,  9 Mar 2021 00:34:10 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id jx13so512576pjb.1;
        Tue, 09 Mar 2021 00:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0udWe8ynS2LQ3Z9brM2kJfwKliNWHIH3eedjVkH+PL4=;
        b=HGGufbT2tkjinPvm77HkEY8Rc+9Na3CMeEzZvTuEo74fy25JasDKJlFe7Ib8j94eR0
         B3c4Qa7Hufc7kb96xJEu7B3m2QGvyz0aSbop9CxNlLMqIdmVDmmQnHcJQTymE6xsItVM
         O2rsnUnT3BNWf2+TpLQxls2QToPmhza/57BNENMxWN7MbeTd3A38KXvs6qdNVSrSqlm5
         qClLeUDvE83ix8ZZ17CWw9ika7fIpn9bpa52OhgNyfXVhONaPpZOZDHWoLXzhaGS4eYy
         54EGfEe81/kb7cT7Yo4NXJTZzoh2hUyiv8LIpGJKXH/WWPGKeGzaGbaYKK1FctCuwIh4
         YRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0udWe8ynS2LQ3Z9brM2kJfwKliNWHIH3eedjVkH+PL4=;
        b=kAzibUU7Ap4n/9FP0ubo4qHm9pn+Y9/rrv45XOHl0+i4XiWbiAZm9+L332YsXWrxdS
         QyinAXND86w+vHnJGdMYzVC28naoKKdMY/j3OcS5fDRS5wASrkOuQyGORKAfYLjH2IR+
         sA5LCboj+3f9s+W9Ed0v4tjOVdjLU508WTiBofEla/9DbPfPrSyZswkuLmBuPALiWIiQ
         FJ+e8PlFjY0Y+fRx+0bjYzIuydDt0nJd6NWBlAmQWqvcVU9PA9+wCI5tB2Rgr3ccRp5V
         t5FMp1LD1U8PoeW3rN/48PH/u8YlPhf7Gic5IehkeODxZ2CNfrPuv6C4judv9fDz5FqW
         HvoA==
X-Gm-Message-State: AOAM532tILG1Ze2EXe46SWCnOlhL93q8ADqlihMFum+Oe5hlOruc8SmP
        qNW31Uxo1g/XaDS2yLR70FE=
X-Google-Smtp-Source: ABdhPJxdopcocaCthDvgDSwdrlWROd/2GnlJJ05rS+tTivJy4v35klwfVWfu+AvzfjZIEiq+zLswLg==
X-Received: by 2002:a17:902:d64a:b029:e6:30a6:64e3 with SMTP id y10-20020a170902d64ab02900e630a664e3mr7309933plh.28.1615278849695;
        Tue, 09 Mar 2021 00:34:09 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.97])
        by smtp.gmail.com with ESMTPSA id f3sm12429003pfe.25.2021.03.09.00.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 00:34:09 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, marcelo.leitner@gmail.com, mkubecek@suse.cz,
        jbi.octave@gmail.com, yangyingliang@huawei.com,
        0x7f454c46@gmail.com, rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: netlink: fix error return code of netlink_proto_init()
Date:   Tue,  9 Mar 2021 00:33:56 -0800
Message-Id: <20210309083356.24083-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kcalloc() returns NULL to nl_table, no error return code of
netlink_proto_init() is assigned.
To fix this bug, err is assigned with -ENOMEM in this case.

Fixes: fab2caf62ed0 ("[NETLINK]: Call panic if nl_table allocation fails")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/netlink/af_netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index dd488938447f..9ab66cfb1037 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2880,8 +2880,10 @@ static int __init netlink_proto_init(void)
 	BUILD_BUG_ON(sizeof(struct netlink_skb_parms) > sizeof_field(struct sk_buff, cb));
 
 	nl_table = kcalloc(MAX_LINKS, sizeof(*nl_table), GFP_KERNEL);
-	if (!nl_table)
+	if (!nl_table) {
+		err = -ENOMEM;
 		goto panic;
+	}
 
 	for (i = 0; i < MAX_LINKS; i++) {
 		if (rhashtable_init(&nl_table[i].hash,
-- 
2.17.1

