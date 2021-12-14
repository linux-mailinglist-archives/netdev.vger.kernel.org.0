Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4FA4743E8
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhLNNxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:53:46 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56873 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhLNNxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:53:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0V-dK6r3_1639490018;
Received: from VM20210331-25.tbsite.net(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0V-dK6r3_1639490018)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Dec 2021 21:53:43 +0800
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org
Cc:     cuibixuan@linux.alibaba.com, bfields@fieldses.org,
        chuck.lever@oracle.com, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com, davem@davemloft.net, kuba@kernel.org,
        pete.wl@alibaba-inc.com, wenan.mwa@alibaba-inc.com,
        xiaoh.peixh@alibaba-inc.com, weipu.zy@alibaba-inc.com
Subject: [PATCH -next] SUNRPC: Clean XPRT_CONGESTED of xprt->state when rpc task is killed
Date:   Tue, 14 Dec 2021 21:53:37 +0800
Message-Id: <1639490018-128451-1-git-send-email-cuibixuan@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a problem with nfs hang on my machine, Steps to reproduce:

1.
echo "options sunrpc tcp_slot_table_entries=2" >> /etc/modprobe.d/sunrpc.conf
echo "options sunrpc tcp_max_slot_table_entries=2" >>  /etc/modprobe.d/sunrpc.conf
and remount nfsv3: sudo mount -t nfs -o vers=3,nolock,proto=tcp 127.0.0.1:/root/nfs_server/ /root/nfs_client/

2.Run case
# cat case.sh 
while true
do
    ls &
done &

while true
do
    killall ls
done &

[root@cuibixuan nfs_client]# cd /root/nfs_client/; sh case.sh

3. Run 'killall sh' to kill case after waiting 10 seconds

4. The nfs hang and xprt->state is 0x212(XPRT_CONGESTED):
[root@cuibixuan sunrpc]# cat /sys/kernel/debug/sunrpc/rpc_xprt/4/info 
netid: tcp
addr:  127.0.0.1
port:  2049
state: 0x212

[root@cuibixuan sunrpc]# cat /sys/kernel/debug/sunrpc/rpc_clnt/4/tasks 
  155 0080    -11 0x4 0x0        0 rpc_default_ops [sunrpc] nfsv3 GETATTR a:call_reserveresult [sunrpc] q:xprt_backlog
15418 0080    -11 0x4 0x0        0 rpc_default_ops [sunrpc] nfsv3 GETATTR a:call_reserveresult [sunrpc] q:xprt_backlog

5. Enable ftrace
 # echo 1 > /sys/kernel/debug/tracing/events/sunrpc/enable
 # cat /sys/kernel/debug/tracing/trace
	      ...
              ls-18792 [001] ....   668.541062: rpc_task_run_action: task:28885@4 flags=0080 state=0005 status=0 action=call_start [sunrpc]
              ls-18792 [001] ....   668.541063: rpc_request: task:28885@4 nfsv3 GETATTR (sync)
              ls-18792 [001] ....   668.541063: rpc_task_run_action: task:28885@4 flags=0080 state=0005 status=0 action=call_reserve [sunrpc]
              ls-18792 [001] ....   668.541065: rpc_task_sleep: task:28885@4 flags=0080 state=0005 status=-11 timeout=0 queue=xprt_backlog
              ls-18792 [000] ....   670.815066: rpc_task_wakeup: task:28885@4 flags=0180 state=0006 status=-512 timeout=0 queue=xprt_backlog
              ls-18792 [000] ....   670.815069: rpc_task_run_action: task:28885@4 flags=0180 state=0005 status=-512 action=rpc_exit_task [sunrpc]
              ls-18846 [001] ....   682.302970: rpc_task_begin: task:28886@4 flags=0080 state=0004 status=0 action=          (null)
              ls-18846 [001] ....   682.302972: rpc_task_run_action: task:28886@4 flags=0080 state=0005 status=0 action=call_start [sunrpc]
              ls-18846 [001] ....   682.302973: rpc_request: task:28886@4 nfsv3 GETATTR (sync)
              ls-18846 [001] ....   682.302973: rpc_task_run_action: task:28886@4 flags=0080 state=0005 status=0 action=call_reserve [sunrpc]
              ls-18846 [001] ....   682.302974: rpc_task_sleep: task:28886@4 flags=0080 state=0005 status=-11 timeout=0 queue=xprt_backlog
              ls-18846 [000] ....   684.690924: rpc_task_wakeup: task:28886@4 flags=0180 state=0006 status=-512 timeout=0 queue=xprt_backlog
              ls-18846 [000] ....   684.690928: rpc_task_run_action: task:28886@4 flags=0180 state=0005 status=-512 action=rpc_exit_task [sunrpc]

The kernel version of my machine is 4.19.91, and it can be fixed with
the following patch (in v4.19):

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 793f595..2656048 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1358,6 +1358,7 @@ void xprt_release(struct rpc_task *task)
        if (req == NULL) {
                if (task->tk_client) {
                        xprt = task->tk_xprt;
+                       xprt_wake_up_backlog(xprt);
                        if (xprt->snd_task == task)
                                xprt_release_write(xprt, task);
                }

I checked the -next code, there should be the same problem.

Bixuan Cui (1):
  SUNRPC: Clean XPRT_CONGESTED of xprt->state when rpc task is killed

 net/sunrpc/xprt.c | 1 +
 1 file changed, 1 insertion(+)

-- 
1.8.3.1

