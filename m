Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83146167C0A
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgBUL2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:28:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727830AbgBUL2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:28:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582284524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=leGu2vftUGPfPVaePqQJmsHbI2GoxR4hxMsr03GFDDo=;
        b=L0No1NMUH9CXR/ma94DUDVVGvBpmuk0OnyCWKuugVW4eKQsIEviAglHM9tLtDYJ4ZKRLJp
        JPh0Ps9EhskdB3MnkWUeJSRLjt14NVir2TL7vLsmQ/usef7LsfprUYcMiCFRkHop/MHJ5E
        xQvGb6RaoNxoBmR3dNuCbsdxQ5C519w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-WzGCrXm_MSOocVxjdUe6lw-1; Fri, 21 Feb 2020 06:28:43 -0500
X-MC-Unique: WzGCrXm_MSOocVxjdUe6lw-1
Received: by mail-wm1-f69.google.com with SMTP id u11so492011wmb.4
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 03:28:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=leGu2vftUGPfPVaePqQJmsHbI2GoxR4hxMsr03GFDDo=;
        b=TBKRXd7FynkDNtuXV6CCXtWuDmdQiB5td9lSA0AyvGnPYhlup3LShHytAaCNsY0PCU
         AXGxyaVBdqas2Xn2PO1ZsM7Q+s31m4g4sAQaG6PMJYly4pH+tD7fzaQh8hPyxt8xtNQz
         9DyIa8Cd/iv1o9E/ikIePItg94AT6MgsYJF2/3dJd5ePr/K6I/sjOdhHOqDIVQxARapW
         OMoARMwcuvN7uen7TGwa8apjQQ8yM1o45416Zr1pf9wDf+/fFyMmYUL8v2DkhMSN0kvJ
         8VsMBQCJxwIOr+i0qITiPu3vfe3Y406EBsb9t7mDwGLlKSpem0l5se3ANisOEPPu6+cl
         p1OQ==
X-Gm-Message-State: APjAAAWsXRTGU8l/WeElK+HbuxrjJ/ROfaHopJ9agWcRjuRpBkNJA8N6
        HsvPAxEaj2Dy8LHvs9n8hvFNTI8Ep0ivqEXy5eiQMH+N1cVn4cl18mBwiweQ2sYQKowossGohY/
        XT2sgaxXoD524nEfo
X-Received: by 2002:a5d:538e:: with SMTP id d14mr50171469wrv.358.1582284521807;
        Fri, 21 Feb 2020 03:28:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqxpigxZVCabTqXi0Dp83mSJlYtrChLQUry58+gL+r8n8CHFpPJ+m2ty2tYlWkrhlbzsM2FfGA==
X-Received: by 2002:a5d:538e:: with SMTP id d14mr50171449wrv.358.1582284521543;
        Fri, 21 Feb 2020 03:28:41 -0800 (PST)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a26sm3408087wmm.18.2020.02.21.03.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 03:28:41 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] ipv4: ensure rcu_read_lock() in cipso_v4_error()
Date:   Fri, 21 Feb 2020 12:28:38 +0100
Message-Id: <20200221112838.11324-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in
ipv4_link_failure()"), __ip_options_compile() must be called under rcu
protection.

Fixes: 3da1ed7ac398 ("net: avoid use IPCB in cipso_v4_error")
Suggested-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/ipv4/cipso_ipv4.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 376882215919..0bd10a1f477f 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1724,6 +1724,7 @@ void cipso_v4_error(struct sk_buff *skb, int error, u32 gateway)
 {
 	unsigned char optbuf[sizeof(struct ip_options) + 40];
 	struct ip_options *opt = (struct ip_options *)optbuf;
+	int res;
 
 	if (ip_hdr(skb)->protocol == IPPROTO_ICMP || error != -EACCES)
 		return;
@@ -1735,7 +1736,11 @@ void cipso_v4_error(struct sk_buff *skb, int error, u32 gateway)
 
 	memset(opt, 0, sizeof(struct ip_options));
 	opt->optlen = ip_hdr(skb)->ihl*4 - sizeof(struct iphdr);
-	if (__ip_options_compile(dev_net(skb->dev), opt, skb, NULL))
+	rcu_read_lock();
+	res = __ip_options_compile(dev_net(skb->dev), opt, skb, NULL);
+	rcu_read_unlock();
+
+	if (res)
 		return;
 
 	if (gateway)
-- 
2.24.1

