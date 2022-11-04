Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A583961A2A8
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKDUs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKDUs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:48:57 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3B3B484
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:48:56 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id lf15so3557944qvb.9
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 13:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XGHhxLgiqGNOfJBoEWhQBQmN8L2fNC42fpgAjpLMLjI=;
        b=FI9mDi1kGV9e6YcLO+J6YF53zeci7uu6JDNWKwz9ob+L7X1vXhOXD54zPQAFDVqe46
         h+g8M8aapq2sACgbgjrdUW9I209wvnRx1DPloaUDs2LugTqAe3K/CE4eU29aATWcIk0s
         j14gx/CgsCJoYelCrKsSJVXekZp0wc3W/sbMFBsIXMkU/tJX00IzMVLnaA2OFRL9g+jf
         Rmy9oLnAxKoAE/MYamBAh2c2L3kujfw2wIfycSZ9VTfmbdB0LfByi7tYLklj5cbQpc0T
         daT32d3MhJi0iUPZVosx0isT5zxkUynLIPWZAhJJ6qXI53q+FpVOUWoOmz/hTScuyz3P
         fHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XGHhxLgiqGNOfJBoEWhQBQmN8L2fNC42fpgAjpLMLjI=;
        b=C6oBAQc76Pm4KmHqQX3eN1adSp/57SUU90rsUEyOMe3GrKgZRd0vf/bnOZSNlpU6np
         TMeMPP7YTs0TPe+J2HFvQafCf4zQU9y4QVPIIJ5yalsONJw7IiBX4SchfooaNhKp0XQ0
         +dB6M323ZaxjikcN7Hbjbwn4C81ibvbNh7CL9hAC2HMxWPJXBGzoZ8JzkrN+R88hNB5z
         yg20VMSd25Cx5ofyu4popg8wzUYhSzfoNwG6KSFDx0jQulZakJVtwYmjxX5vlX92u9PA
         71Zzib1JnneEFNhIMzrkSkqJXty7tdVjkAfHRuLSL8jGJ8dAzXlI0RTdibhL9MWOpAHD
         yFmg==
X-Gm-Message-State: ACrzQf3m2ZicZShAxepA3RHndd8D09f5OJrOREgQUKdKWLwsOHmNry3a
        YNW32+CR1N/pWhBwrNvcQKbQFLHx/TLciQ==
X-Google-Smtp-Source: AMsMyM4L/CCFdMuTsIxady0/YuGCFo+r3Tm7LDCT7yNWulZX4AlW7H5JWNQugOIA/m+Zp3KNwaA0GQ==
X-Received: by 2002:ad4:5c8c:0:b0:4b9:fe5:e7a8 with SMTP id o12-20020ad45c8c000000b004b90fe5e7a8mr33744690qvh.99.1667594935131;
        Fri, 04 Nov 2022 13:48:55 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cq10-20020a05622a424a00b00397e97baa96sm285932qtb.0.2022.11.04.13.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:48:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH net] tipc: fix the msg->req tlv len check in tipc_nl_compat_name_table_dump_header
Date:   Fri,  4 Nov 2022 16:48:53 -0400
Message-Id: <ccd6a7ea801b15aec092c3b532a883b4c5708695.1667594933.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up for commit 974cb0e3e7c9 ("tipc: fix uninit-value
in tipc_nl_compat_name_table_dump") where it should have type casted
sizeof(..) to int to work when TLV_GET_DATA_LEN() returns a negative
value.

syzbot reported a call trace because of it:

  BUG: KMSAN: uninit-value in ...
   tipc_nl_compat_name_table_dump+0x841/0xea0 net/tipc/netlink_compat.c:934
   __tipc_nl_compat_dumpit+0xab2/0x1320 net/tipc/netlink_compat.c:238
   tipc_nl_compat_dumpit+0x991/0xb50 net/tipc/netlink_compat.c:321
   tipc_nl_compat_recv+0xb6e/0x1640 net/tipc/netlink_compat.c:1324
   genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
   genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
   genl_rcv_msg+0x103f/0x1260 net/netlink/genetlink.c:792
   netlink_rcv_skb+0x3a5/0x6c0 net/netlink/af_netlink.c:2501
   genl_rcv+0x3c/0x50 net/netlink/genetlink.c:803
   netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
   netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
   netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
   sock_sendmsg_nosec net/socket.c:714 [inline]
   sock_sendmsg net/socket.c:734 [inline]

Reported-by: syzbot+e5dbaaa238680ce206ea@syzkaller.appspotmail.com
Fixes: 974cb0e3e7c9 ("tipc: fix uninit-value in tipc_nl_compat_name_table_dump")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/netlink_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index fc68733673ba..dfea27a906f2 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -880,7 +880,7 @@ static int tipc_nl_compat_name_table_dump_header(struct tipc_nl_compat_msg *msg)
 	};
 
 	ntq = (struct tipc_name_table_query *)TLV_DATA(msg->req);
-	if (TLV_GET_DATA_LEN(msg->req) < sizeof(struct tipc_name_table_query))
+	if (TLV_GET_DATA_LEN(msg->req) < (int)sizeof(struct tipc_name_table_query))
 		return -EINVAL;
 
 	depth = ntohl(ntq->depth);
-- 
2.31.1

