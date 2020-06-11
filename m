Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C8F1F64BD
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 11:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgFKJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 05:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgFKJ3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 05:29:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87F2C03E96F;
        Thu, 11 Jun 2020 02:28:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ne5so2008162pjb.5;
        Thu, 11 Jun 2020 02:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=fmkKfLlPm1SX8BMYeiTAVz52U85xymHRgcogEW45OFc=;
        b=eRXeRYytRbgk0t8K5ew0ycWqsjAnG0y0GuRz4voxnDk4ItqDoBcSDcTiOeC0Bo9QlM
         Qv7yhKisJa/xIQEpoeD2+B4k0uHNmUdJ/2AtTd2GQBUZ0gpXDVQ8Uuym1e/Yuk30LFof
         N5DRfMhNPJMX7op+kU8nhlAsiY6/HXmb1FtwVkfSsRQfkTqKEVBnRKPEINA0QnTNi02H
         uoZMpI3gyUlz2m2Ipe+/BvqhGVb/i7EW5qdfp8v2/jw1HclCr0lCIbWZX2xN9JdyDhtB
         BKR1dAF7smAkJ5a97O1cjFwdHTIliPTbNiOTUEPdGX/F7iCujV4YRyWa63sylKSWGnUD
         wXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=fmkKfLlPm1SX8BMYeiTAVz52U85xymHRgcogEW45OFc=;
        b=PwgBrNVMFyrRL9s/L+kzOUyQJjDf37nTe+zVhERvSrF0wJsW3y6+OK1woXCeog8lLO
         +Jjh5JP/YYKLgPYNE/F3K2W3OowK8YxcBR4M95DDnIqCNdrmnrObIPTgHgBGeO8E0/Gy
         E27YCfOTvDrrUXVi4hpSRP9eROzjXzJfQCxjLVDT8RHx+FuxIJnbaiDUq0ca24kaHjXp
         0Ch/7A5RtOkXE/HhKVahbytxuL8cazd9c8D3BpvZECP/MJZD7g78JHSxxzBoZn/2u1cN
         xrJ6cjcOcDDrmad44STbrcMH/+t8hcUWPBLHVggU/tCUMeEkbc92yxADmmMljq2uQQ5D
         T8PA==
X-Gm-Message-State: AOAM533aEwFufzBqkPOvh14w4NAft6OPaptSQb4Ck+kj4lU98NNJyEv6
        3tP0edhA+YofXSsWiBIVSoE=
X-Google-Smtp-Source: ABdhPJxUfyCZRv95siBqF+GWljsyDpJWO9UkWkgntK1Sc2lcQIOOux2Qc0v9NZQlXLS20tTFJe3ERQ==
X-Received: by 2002:a17:902:7281:: with SMTP id d1mr6720583pll.78.1591867739214;
        Thu, 11 Jun 2020 02:28:59 -0700 (PDT)
Received: from VM_111_229_centos ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id h4sm2090858pjq.55.2020.06.11.02.28.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 02:28:58 -0700 (PDT)
Date:   Thu, 11 Jun 2020 17:28:49 +0800
From:   YangYuxi <yx.atom1@gmail.com>
To:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, yx.atom1@gmail.com
Subject: [PATCH] ipvs: avoid drop first packet to reuse conntrack
Message-ID: <20200611092849.GA13977@VM_111_229_centos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit f719e3754ee ("ipvs: drop first packet
to redirect conntrack"), when a new TCP connection
meet the conditions that need reschedule, the first
syn packet is dropped, this cause one second latency
for the new connection, more discussion about this
problem can easy seach from google, such as:

1)One second connection delay in masque
https://marc.info/?t=151683118100004&r=1&w=2

2)IPVS low throughput #70747
https://github.com/kubernetes/kubernetes/issues/70747

3)Apache Bench can fill up ipvs service proxy in seconds #544
https://github.com/cloudnativelabs/kube-router/issues/544

4)Additional 1s latency in `host -> service IP -> pod`
https://github.com/kubernetes/kubernetes/issues/90854

The root cause is when the old session is expired, the
conntrack related to the session is dropped by
ip_vs_conn_drop_conntrack. The code is as follows:
```
static void ip_vs_conn_expire(struct timer_list *t)
{
...

                if ((cp->flags & IP_VS_CONN_F_NFCT) &&
                    !(cp->flags & IP_VS_CONN_F_ONE_PACKET)) {
                        /* Do not access conntracks during subsys cleanup
                         * because nf_conntrack_find_get can not be used after
                         * conntrack cleanup for the net.
                         */
                        smp_rmb();
                        if (ipvs->enable)
                                ip_vs_conn_drop_conntrack(cp);
                }
...
}
```
As the code show, only if the condition  (cp->flags & IP_VS_CONN_F_NFCT)
is true, ip_vs_conn_drop_conntrack will be called.
So we solve this bug by following steps:
1) erase the IP_VS_CONN_F_NFCT flag (it is safely because no packets will
   use the old session)
2) call ip_vs_conn_expire_now to release the old session, then the related
   conntrack will not be dropped
3) then ipvs unnecessary to drop the first syn packet,
   it just continue to pass the syn packet to the next process,
   create a new ipvs session, and the new session will related to
   the old conntrack(which is reopened by conntrack as a new one),
   the next whole things is just as normal as that the old session
   isn't used to exist.

This patch has been verified on our thousands of kubernets node servers on Tencent Inc.
Signed-off-by: YangYuxi <yx.atom1@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index aa6a603a2425..2f750145172f 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2086,11 +2086,11 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		}
 
 		if (resched) {
+			if (uses_ct)
+				cp->flags &= ~IP_VS_CONN_F_NFCT;
 			if (!atomic_read(&cp->n_control))
 				ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
-			if (uses_ct)
-				return NF_DROP;
 			cp = NULL;
 		}
 	}
-- 
1.8.3.1

