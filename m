Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A991F7938
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 16:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgFLOAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 10:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLN77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 09:59:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB354C03E96F;
        Fri, 12 Jun 2020 06:59:58 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id n9so3792765plk.1;
        Fri, 12 Jun 2020 06:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=Hh9i/SAu/XN5uCB1Th1rOCzGyl5/Jk4Mbw10dKZ3R6E=;
        b=OoePVJ97S0dChRChmKkt7AZdBKjpcR90mt2XoX1NpjFvAFZux+NDX5hD7FdJ57lZ4r
         oep2MH3ngXJ9XRFND/XFjFIpJv5zOKnyFcsfQzFarkY4V8GpPuI4aUQOUYhHAmxlCX7n
         rbFBOlG0kJVFmEcT448PMtKFubQR9kl3W7ifFEU5NHHFMmym66azLUtF0ptySLy1Ca9F
         QStlSBMJw/7ri0fsgxObQxO0ty2TTk4AFMHi+6EEeIs1Itpub4FeRk60Ao4OJN9AtEgC
         EN9XHKhgeQLPodp+SfyJEBEwpr0hC+kNcRlohjzjdct9MMRypoXjaHLYrWrdb76WVVQ5
         36qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=Hh9i/SAu/XN5uCB1Th1rOCzGyl5/Jk4Mbw10dKZ3R6E=;
        b=C/riOQwFBwypvPgbdqav5UlZMyfjh1tYaX/zq+2V+ChJ2evCbGkSUga2K0Yq9cfCk+
         Zdt8mkcWXQG3ud8EkeBdEDN8UxpqK6FWXvbihPF292lUQA2kBd+WqOlzBzyZtnv6Ovxl
         oSP+WcMHo13LmWKzpaRZ6Alnx1amHCqAwFxTk5FcuQ7sR8v4hOswooTatrq5KSmY/+tT
         f2OZ3SaueL3WDfVS7SFz6hb8QAhTYVMjISwf4n2bljRqDMkXv2Rn61JrYkPHHnCOPV+h
         YG+I0HN0SHGVYaPor73ERcx7t5AO/aORVuPt8GvGHoYI9b4pjB88Ipx+3pitC52mdqC1
         rMDQ==
X-Gm-Message-State: AOAM531wEpSEEzcabmj959bleAyvIkRI/d/NVwIUmmp6pSmg4UL0zMzj
        puemG6jo+ULbYoTPwTviCQE=
X-Google-Smtp-Source: ABdhPJwfDq9KD/nK8GaFnN8mgVzBT+KGWvP120y7TDStKqBKe0aV2wyZB9B++KCTdz45Pn0BLffHBg==
X-Received: by 2002:a17:90a:a2d:: with SMTP id o42mr13282098pjo.101.1591970398192;
        Fri, 12 Jun 2020 06:59:58 -0700 (PDT)
Received: from VM_111_229_centos ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id j13sm6317970pfe.48.2020.06.12.06.59.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jun 2020 06:59:57 -0700 (PDT)
Date:   Fri, 12 Jun 2020 21:59:49 +0800
From:   YangYuxi <yx.atom1@gmail.com>
To:     wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, yx.atom1@gmail.com
Subject: [PATCH] ipvs: avoid drop first packet to reuse conntrack
Message-ID: <20200612135949.GA30179@VM_111_229_centos>
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
So we optimize this by following steps:
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

The above scenario has no problems except passive FTP and
connmarks (state matching (-m state)). So, ipvs can give
users the right to choose, when FTP or connmarks is not used,
they can choose a high performance one by set net.ipv4.vs.conn_reuse_old_conntrack=1,
this is necessary because most scenarios, such as kubernetes,
do not have FTP and connmarks scenarios, but are very sensitive
to TCP short link performance.

This patch has been verified on our thousands of kubernets node servers on Tencent Inc.
Signed-off-by: YangYuxi <yx.atom1@gmail.com>
---
 include/net/ip_vs.h             | 11 +++++++++++
 net/netfilter/ipvs/ip_vs_core.c | 10 ++++++++--
 net/netfilter/ipvs/ip_vs_ctl.c  |  2 ++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 83be2d93b407..052fa87d2a44 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -928,6 +928,7 @@ struct netns_ipvs {
 	int			sysctl_pmtu_disc;
 	int			sysctl_backup_only;
 	int			sysctl_conn_reuse_mode;
+	int			sysctl_conn_reuse_old_conntrack;
 	int			sysctl_schedule_icmp;
 	int			sysctl_ignore_tunneled;
 
@@ -1049,6 +1050,11 @@ static inline int sysctl_conn_reuse_mode(struct netns_ipvs *ipvs)
 	return ipvs->sysctl_conn_reuse_mode;
 }
 
+static inline int sysctl_conn_reuse_old_conntrack(struct netns_ipvs *ipvs)
+{
+	return ipvs->sysctl_conn_reuse_old_conntrack;
+}
+
 static inline int sysctl_schedule_icmp(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_schedule_icmp;
@@ -1136,6 +1142,11 @@ static inline int sysctl_conn_reuse_mode(struct netns_ipvs *ipvs)
 	return 1;
 }
 
+static inline int sysctl_conn_reuse_old_conntrack(struct netns_ipvs *ipvs)
+{
+	return 1;
+}
+
 static inline int sysctl_schedule_icmp(struct netns_ipvs *ipvs)
 {
 	return 0;
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index aa6a603a2425..0b89c872ea46 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2066,7 +2066,7 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 
 	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
 	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
-		bool uses_ct = false, resched = false;
+		bool uses_ct = false, resched = false, drop = false;
 
 		if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
 		    unlikely(!atomic_read(&cp->dest->weight))) {
@@ -2086,10 +2086,16 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
 		}
 
 		if (resched) {
+			if (uses_ct) {
+				if (likely(sysctl_conn_reuse_old_conntrack(ipvs)))
+					cp->flags &= ~IP_VS_CONN_F_NFCT;
+				else
+					drop = true;
+			}
 			if (!atomic_read(&cp->n_control))
 				ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
-			if (uses_ct)
+			if (drop)
 				return NF_DROP;
 			cp = NULL;
 		}
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 412656c34f20..eeb87994c21f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4049,7 +4049,9 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 	tbl[idx++].data = &ipvs->sysctl_pmtu_disc;
 	tbl[idx++].data = &ipvs->sysctl_backup_only;
 	ipvs->sysctl_conn_reuse_mode = 1;
+	ipvs->sysctl_conn_reuse_old_conntrack = 1;
 	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
+	tbl[idx++].data = &ipvs->sysctl_conn_reuse_old_conntrack;
 	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
 	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
 
-- 
1.8.3.1

