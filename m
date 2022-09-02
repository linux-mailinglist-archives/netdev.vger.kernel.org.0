Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C757C5AABB8
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 11:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbiIBJrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 05:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIBJrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 05:47:03 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1E1C6965
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 02:47:02 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id n17so1593157wrm.4
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 02:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date;
        bh=+l1Xr+0Z0mOUoPyNq6K9ZPyL+4bv81oIhNt9jZTE08A=;
        b=Udl0RIy+0uWxsbcYJNOsWTwRxiu1pZtvEbCP1sieUXFqbQWzzj/Lb2GZtJ63RSrVwV
         JTeiW3+oYW0pxGQTlHLvmgd5y4uEyYbCw7vkFHVzl7g3LhDgBFp31JTptsYgC7qnXOQw
         2bZ/VqujXHpT/0ADpKTJtnFRaYcxAoNuHHWDGu1SU+JSO+HyPKIQYzbnDhDUDAtBhVNS
         Re4YxVo+58M+asW0OjyQV1ekTnZdanvieH8R6x3dRItmjWg+gtGDxufuhF0CkMSesxkr
         Fo8IkUlJmzG1LVKWs9/D+cupcRRmmUqKCXKm99C/0LlwFoU40+g50Dj54O72siMIDf9i
         0khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date;
        bh=+l1Xr+0Z0mOUoPyNq6K9ZPyL+4bv81oIhNt9jZTE08A=;
        b=2bgZGp0kkxqLam0Ec+AbiELX4RFRDK02fBxbeNsC4QlpqDwryAYk9zDNTn4nji/kjo
         UQQLZem0h0i9BNjyYK4L8BAHzON/JNm2jKzc6+R7zuhlwliq8NwyJK9o7xoFIezhCKWk
         wIExGbKJ+kApQQSdMgmgAMWutsbrZewfT5MZd4fF+LL+ToCoxVr+lTjILWy6v0fxhHYH
         Tyu8vexvOvtvz1BzJh0XLwrjTEPPdqIiy0FRMO5elFuUWo2rjsHonGTpRo7LpTtch2hu
         v1ByA+x+qkPgzuzU1WgnEoakH92ME/OD5giG3jhwuUGOq5AXn515xSI7Arvcvg6cgwoS
         WuSw==
X-Gm-Message-State: ACgBeo1M4/w3rRoXpN8DES1zqEoUWQuX76ortC6xVQvdrmlNKOyeco7z
        d74/Gs3X6AAGS9D2KTnwm0myY39dcuvTjw==
X-Google-Smtp-Source: AA6agR5SImGHzkzvMoAIJKGvjJgTvi8MnAt4HOWdWuSS6X27gUPPW0YvhYJ+RfR0wkLEETHMtw9lWQ==
X-Received: by 2002:adf:e845:0:b0:226:d461:9cf1 with SMTP id d5-20020adfe845000000b00226d4619cf1mr15255591wrn.136.1662112020365;
        Fri, 02 Sep 2022 02:47:00 -0700 (PDT)
Received: from localhost.localdomain ([2a00:79e1:abc:1113:5a49:8afe:d853:893])
        by smtp.gmail.com with ESMTPSA id c1-20020a5d4141000000b002258413c310sm1084889wrq.88.2022.09.02.02.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 02:47:00 -0700 (PDT)
Sender: David Lebrun <target0x@gmail.com>
From:   David Lebrun <dav.lebrun@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Lebrun <dav.lebrun@gmail.com>, edumazet@google.com,
        Lucas Leong <wmliang.tw@gmail.com>,
        David Lebrun <dlebrun@google.com>
Subject: [PATCH net] ipv6: sr: fix out-of-bounds read when setting HMAC data.
Date:   Fri,  2 Sep 2022 10:45:06 +0100
Message-Id: <20220902094506.89156-1-dav.lebrun@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Lebrun <dlebrun@google.com>

The SRv6 layer allows defining HMAC data that can later be used to sign IPv6
Segment Routing Headers. This configuration is realised via netlink through
four attributes: SEG6_ATTR_HMACKEYID, SEG6_ATTR_SECRET, SEG6_ATTR_SECRETLEN and
SEG6_ATTR_ALGID. Because the SECRETLEN attribute is decoupled from the actual
length of the SECRET attribute, it is possible to provide invalid combinations
(e.g., secret = "", secretlen = 64). This case is not checked in the code and
with an appropriately crafted netlink message, an out-of-bounds read of up
to 64 bytes (max secret length) can occur past the skb end pointer and into
skb_shared_info:

Breakpoint 1, seg6_genl_sethmac (skb=<optimized out>, info=<optimized out>) at net/ipv6/seg6.c:208
208		memcpy(hinfo->secret, secret, slen);
(gdb) bt
 #0  seg6_genl_sethmac (skb=<optimized out>, info=<optimized out>) at net/ipv6/seg6.c:208
 #1  0xffffffff81e012e9 in genl_family_rcv_msg_doit (skb=skb@entry=0xffff88800b1f9f00, nlh=nlh@entry=0xffff88800b1b7600,
    extack=extack@entry=0xffffc90000ba7af0, ops=ops@entry=0xffffc90000ba7a80, hdrlen=4, net=0xffffffff84237580 <init_net>, family=<optimized out>,
    family=<optimized out>) at net/netlink/genetlink.c:731
 #2  0xffffffff81e01435 in genl_family_rcv_msg (extack=0xffffc90000ba7af0, nlh=0xffff88800b1b7600, skb=0xffff88800b1f9f00,
    family=0xffffffff82fef6c0 <seg6_genl_family>) at net/netlink/genetlink.c:775
 #3  genl_rcv_msg (skb=0xffff88800b1f9f00, nlh=0xffff88800b1b7600, extack=0xffffc90000ba7af0) at net/netlink/genetlink.c:792
 #4  0xffffffff81dfffc3 in netlink_rcv_skb (skb=skb@entry=0xffff88800b1f9f00, cb=cb@entry=0xffffffff81e01350 <genl_rcv_msg>)
    at net/netlink/af_netlink.c:2501
 #5  0xffffffff81e00919 in genl_rcv (skb=0xffff88800b1f9f00) at net/netlink/genetlink.c:803
 #6  0xffffffff81dff6ae in netlink_unicast_kernel (ssk=0xffff888010eec800, skb=0xffff88800b1f9f00, sk=0xffff888004aed000)
    at net/netlink/af_netlink.c:1319
 #7  netlink_unicast (ssk=ssk@entry=0xffff888010eec800, skb=skb@entry=0xffff88800b1f9f00, portid=portid@entry=0, nonblock=<optimized out>)
    at net/netlink/af_netlink.c:1345
 #8  0xffffffff81dff9a4 in netlink_sendmsg (sock=<optimized out>, msg=0xffffc90000ba7e48, len=<optimized out>) at net/netlink/af_netlink.c:1921
...
(gdb) p/x ((struct sk_buff *)0xffff88800b1f9f00)->head + ((struct sk_buff *)0xffff88800b1f9f00)->end
$1 = 0xffff88800b1b76c0
(gdb) p/x secret
$2 = 0xffff88800b1b76c0
(gdb) p slen
$3 = 64 '@'

The OOB data can then be read back from userspace by dumping HMAC state. This
commit fixes this by ensuring SECRETLEN cannot exceed the actual length of
SECRET.

Reported-by: Lucas Leong <wmliang.tw@gmail.com>
Tested: verified that EINVAL is correctly returned when secretlen > len(secret)
Fixes: 4f4853dc1c9c1 ("ipv6: sr: implement API to control SR HMAC structure")
Signed-off-by: David Lebrun <dlebrun@google.com>
---
 net/ipv6/seg6.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 5421cc7c935f..29346a6eec9f 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -191,6 +191,11 @@ static int seg6_genl_sethmac(struct sk_buff *skb, struct genl_info *info)
 		goto out_unlock;
 	}
 
+	if (slen > nla_len(info->attrs[SEG6_ATTR_SECRET])) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+
 	if (hinfo) {
 		err = seg6_hmac_info_del(net, hmackeyid);
 		if (err)
-- 
2.25.1

