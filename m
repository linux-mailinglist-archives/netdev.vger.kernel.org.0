Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1C613AC9
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 16:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfEDOwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 10:52:33 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55241 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfEDOwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 10:52:33 -0400
Received: from fsav107.sakura.ne.jp (fsav107.sakura.ne.jp [27.133.134.234])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x44EqVHa064400;
        Sat, 4 May 2019 23:52:31 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav107.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav107.sakura.ne.jp);
 Sat, 04 May 2019 23:52:31 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav107.sakura.ne.jp)
Received: from [192.168.1.8] (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x44EqVPX064396
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NO);
        Sat, 4 May 2019 23:52:31 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: [PATCH] ipv4: Delete uncached routes upon unregistration of loopback
 device.
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>,
        ddstreet@ieee.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <0000000000007d22100573d66078@google.com>
 <alpine.LFD.2.20.1808201527230.2758@ja.home.ssi.bg>
 <4684eef5-ea50-2965-86a0-492b8b1e4f52@I-love.SAKURA.ne.jp>
 <9d430543-33c3-0d9b-dc77-3a179a8e3919@I-love.SAKURA.ne.jp>
 <920ebaf1-ee87-0dbb-6805-660c1cbce3d0@I-love.SAKURA.ne.jp>
 <cc054b5c-4e95-8d30-d4bf-9c85f7e20092@gmail.com>
 <15b353e9-49a2-f08b-dc45-2e9bad3abfe2@i-love.sakura.ne.jp>
 <057735f0-4475-7a7b-815f-034b1095fa6c@gmail.com>
 <6e57bc11-1603-0898-dfd4-0f091901b422@i-love.sakura.ne.jp>
 <f71dd5cd-c040-c8d6-ab4b-df97dea23341@gmail.com>
 <d56b7989-8ac6-36be-0d0b-43251e1a2907@gmail.com>
 <117fcc49-d389-c389-918f-86ccaef82e51@i-love.sakura.ne.jp>
 <70be7d61-a6fe-e703-978a-d17f544efb44@gmail.com>
 <40199494-8eb7-d861-2e3b-6e20fcebc0dc@i-love.sakura.ne.jp>
Message-ID: <519ea12b-4c24-9e8e-c5eb-ca02c9c7d264@i-love.sakura.ne.jp>
Date:   Sat, 4 May 2019 23:52:31 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <40199494-8eb7-d861-2e3b-6e20fcebc0dc@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is hitting infinite loop when a loopback device in a namespace is
unregistered [1]. This is because rt_flush_dev() is moving the refcount of
"any device to unregister" to "a loopback device in that namespace" but
nobody can drop the refcount moved from non loopback devices when the
loopback device in that namespace is unregistered.

This behavior was introduced by commit caacf05e5ad1abf0 ("ipv4: Properly
purge netdev references on uncached routes.") but there is no description
why we have to temporarily move the refcount to "a loopback device in that
namespace" and why it is safe to do so, for rt_flush_dev() becomes a no-op
when "a loopback device in that namespace" is about to be unregistered.

Since I don't know the reason, this patch breaks the infinite loop by
deleting the uncached route (which eventually drops the refcount via
dst_destroy()) when "a loopback device in that namespace" is unregistered
rather than when "non-loopback devices in that namespace" is unregistered.

[1] https://syzkaller.appspot.com/bug?id=bae9a2236bfede42cf3d219e6bf6740c583568a4

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+30209ea299c09d8785c9@syzkaller.appspotmail.com>
---
 net/ipv4/route.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6fdf1c195d8e..7e865c11d4f3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1522,15 +1522,21 @@ void rt_flush_dev(struct net_device *dev)
 {
 	struct net *net = dev_net(dev);
 	struct rtable *rt;
+	struct rtable *tmp;
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul = &per_cpu(rt_uncached_list, cpu);
 
 		spin_lock_bh(&ul->lock);
-		list_for_each_entry(rt, &ul->head, rt_uncached) {
+		list_for_each_entry_safe(rt, tmp, &ul->head, rt_uncached) {
 			if (rt->dst.dev != dev)
 				continue;
+			if (dev == net->loopback_dev) {
+				list_del_init(&rt->rt_uncached);
+				ip_rt_put(rt);
+				continue;
+			}
 			rt->dst.dev = net->loopback_dev;
 			dev_hold(rt->dst.dev);
 			dev_put(dev);
-- 
2.17.1


