Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367065F1DD1
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 18:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiJAQov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 12:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJAQot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 12:44:49 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE832AE8;
        Sat,  1 Oct 2022 09:44:46 -0700 (PDT)
Received: from fsav414.sakura.ne.jp (fsav414.sakura.ne.jp [133.242.250.113])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 291Ghjft022075;
        Sun, 2 Oct 2022 01:43:45 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav414.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp);
 Sun, 02 Oct 2022 01:43:45 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav414.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 291GhiQc022071
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 2 Oct 2022 01:43:45 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <5e89b653-3fc6-25c5-324b-1b15909c0183@I-love.SAKURA.ne.jp>
Date:   Sun, 2 Oct 2022 01:43:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: [PATCH] net/ieee802154: reject zero-sized raw_sendmsg()
Content-Language: en-US
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, linux-wpan@vger.kernel.org
References: <000000000000ac3b8305e4a6b766@google.com>
Cc:     syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <000000000000ac3b8305e4a6b766@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is hitting skb_assert_len() warning at raw_sendmsg() for ieee802154
socket. What commit dc633700f00f726e ("net/af_packet: check len when
min_header_len equals to 0") does also applies to ieee802154 socket.

Link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4
Reported-by: syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
Fixes: fd1894224407c484 ("bpf: Don't redirect packets with invalid pkt_len")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
I checked that reproducer no longer hits skb_assert_len() warning, but
what return value should we use? Is -EDESTADDRREQ better than -EINVAL?

 net/ieee802154/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 7889e1ef7fad..cbd0e2ac4ffe 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -251,6 +251,9 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		return -EOPNOTSUPP;
 	}
 
+	if (!size)
+		return -EINVAL;
+
 	lock_sock(sk);
 	if (!sk->sk_bound_dev_if)
 		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
-- 
2.34.1

