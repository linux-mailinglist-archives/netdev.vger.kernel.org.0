Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A11F6539
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 12:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgFKKBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 06:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgFKKBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 06:01:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11EBC08C5C1;
        Thu, 11 Jun 2020 03:01:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id v24so2145889plo.6;
        Thu, 11 Jun 2020 03:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=hDcJLQph3XEDbqRIioZiQfkn61SbO41SN1rr45lJWyU=;
        b=sgeBjL7AljP1Pm5YNHqOcaY5kTJdalizz4L7U25FzemzsMt5QR8hQ5bkYmVqEYLA04
         GLBNSCNKLKVpHpqzcWe8utWPVwopNTKj8Fs6mhRndKR5t2XUtiilw9+nXxhEiUaPGcH7
         G0UnoyDSHyYx/FonVIS0TZ7kWvL5IVyh/oFV1q3eh5rvIPzFTih03lKOLdszSHOuZgaO
         B5pt2ECbqKJ6PtcbEDwRTo9hgY/YnLOCuwVImNUA4x2Z007jmAwejXWfqxRGKV2Hl1wb
         UygYK/0gNrcnr812aBxsaBsbzbhsPPSFL6Aj+5oR1wDKDTUOx/S84T1tC1JjAw+/RihC
         M37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=hDcJLQph3XEDbqRIioZiQfkn61SbO41SN1rr45lJWyU=;
        b=tYajahjJvrI0FI+8pYA6SyJJ8RRwTwQEvadtU7TrY2fIeBlrwk/amSYiso/t7rRirC
         0db5IuFXvIUF+criMTZyXiOWze3T1cvafgAxChmFNDrKos+OoRCd7SaHTMXQ7OXy/Zol
         geGNHNinDbZyODmKo+YXvMt55XuQNSC/CsxI2z1AY0NybTvvoj1QawViA6LTgVxDjakW
         HrUQpkrFTdrXftjw8QzqqkViubE9tlHfIsImJCkets9scXu8//WP9EgiPl/54NVVQ4qw
         5rUVmnRP2AKXaRrKhltRCEYYxZ/VO/bd8J+BHuW7sZUKTUKwHEZU3+OqY+R2HLV9qw+7
         M29g==
X-Gm-Message-State: AOAM530Zr1SaM5nX59wdsWTScaNcfN2/cA/8j4M5rWOE0oEvO8rczqY0
        1vWh55tw7RsYogTgXPFwsyg=
X-Google-Smtp-Source: ABdhPJxU0SQz8NIee5cCWrgG7up+DPKvI6JOVpwxmjVrNc51nGci49w4SkPeXgbboq5Qr9Rb9mVpgA==
X-Received: by 2002:a17:90a:7c4e:: with SMTP id e14mr7705366pjl.52.1591869708163;
        Thu, 11 Jun 2020 03:01:48 -0700 (PDT)
Received: from VM_111_229_centos ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id q68sm2438721pjc.30.2020.06.11.03.01.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jun 2020 03:01:47 -0700 (PDT)
Date:   Thu, 11 Jun 2020 18:01:35 +0800
From:   YangYuxi <yx.atom1@gmail.com>
To:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, yx.atom1@gmail.com
Subject: [PATCH] ipvs: avoid drop first packet to reuse conntrack
Message-ID: <20200611100135.GA19243@VM_111_229_centos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 'commit f719e3754ee2 ("ipvs: drop first packet to
redirect conntrack")', when a new TCP connection meet
the conditions that need reschedule, the first syn packet
is dropped, this cause one second latency for the new
connection, more discussion about this problem can easy
search from google, such as:

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

