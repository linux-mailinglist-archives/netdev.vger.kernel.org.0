Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708DB2CFAAD
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 09:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgLEIqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 03:46:31 -0500
Received: from m12-12.163.com ([220.181.12.12]:53680 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgLEIp6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 03:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Message-ID:Date:MIME-Version; bh=lo0fQ
        H/9l/nq7ES+mbfSWt9riSontKVcAaw594W7Qtc=; b=GllMevohO5vBMvmnoD30N
        z0la5JuURXuSq7Q6DOQOBXUq/NoOe/Lib6LSnOyYWsrRm86WwzkItiGjTMrhar1Z
        Lw03YSpfMcocxdr0FivUYkQtNej/yLJ3e85fG5jtT+gjnT9Ga4oMsX1+AlTANSUO
        pnst0TPCDdej6BCcz+bMh4=
Received: from [10.8.0.186] (unknown [36.111.140.26])
        by smtp8 (Coremail) with SMTP id DMCowAAHBfoxPctfGZvdFQ--.24759S2;
        Sat, 05 Dec 2020 15:56:35 +0800 (CST)
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH net v2] mptcp: print new line in mptcp_seq_show() if mptcp
 isn't in use
To:     Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        pabeni@redhat.com, davem@davemloft.net
Message-ID: <142e2fd9-58d9-bb13-fb75-951cccc2331e@163.com>
Date:   Sat, 5 Dec 2020 15:56:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DMCowAAHBfoxPctfGZvdFQ--.24759S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr1rXw4DGw4DWF17Cw13XFb_yoWDtFg_Ga
        9rXr97Kw45Xr1UGrs8GF4rJFyFkrWak3saqFn7tay3GwnxJ3W29ry09wn3Gr18Gws0vF98
        ur40yrsFvr1IkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5Q18PUUUUU==
X-Originating-IP: [36.111.140.26]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbBSRPxkFaD86nNzgAAs3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

When do cat /proc/net/netstat, the output isn't append with a new line, it looks like this:
[root@localhost ~]# cat /proc/net/netstat
...
MPTcpExt: 0 0 0 0 0 0 0 0 0 0 0 0 0[root@localhost ~]#

This is because in mptcp_seq_show(), if mptcp isn't in use, net->mib.mptcp_statistics is NULL,
so it just puts all 0 after "MPTcpExt:", and return, forgot the '\n'.

After this patch:

[root@localhost ~]# cat /proc/net/netstat
...
MPTcpExt: 0 0 0 0 0 0 0 0 0 0 0 0 0
[root@localhost ~]#

Fixes: fc518953bc9c8d7d ("mptcp: add and use MIB counter infrastructure")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Acked-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/mib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 84d1194..b921cbd 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -67,6 +67,7 @@ void mptcp_seq_show(struct seq_file *seq)
 		for (i = 0; mptcp_snmp_list[i].name; i++)
 			seq_puts(seq, " 0");

+		seq_putc(seq, '\n');
 		return;
 	}

-- 
1.8.3.1

