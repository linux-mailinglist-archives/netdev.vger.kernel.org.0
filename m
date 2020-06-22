Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EB020423B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 22:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgFVUyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 16:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbgFVUx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 16:53:58 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF08C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 13:53:58 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g10so894681wmh.4
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 13:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=w+W3SsiOx44tXPIa/9SZTi1zhjwviQ+ZEjsSIDBfsfk=;
        b=H6YV/SkTyuiJQx4LidQ4bs/UcMTxo5GhyG7uItBFTi/R/bjvG8NaONzeoT8PU3VRNh
         Zh4YX+HFWfCPxnz5FpDgOMCrQpm/yOf57wh3CHJfYB3H89Iqm5fBliLOG0ESrtsvBLqi
         ot4MUDcVwXRLnmZ05VIc5suF9ZBUEQKeTFQeU2eOf724rz/JlftW5Dzdbt1VBBfDDwvW
         GR2d0crtGUE5mxx966eTXMUloDM35XLeKzsvKksmraD1DYWZpbOeikLf/EAxBr7rEvFH
         8PhZ9ZgFUFhkd1szND0rGWQumlZ2to6l12oed3s9lofXyAMsyUdHzF4MBUjLRS21q7iX
         ERbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=w+W3SsiOx44tXPIa/9SZTi1zhjwviQ+ZEjsSIDBfsfk=;
        b=r+DcFRYKTgMYBDdipAFVqI4Fwmd8C5VuU64fSoPKXZMCs9kWPdRIW4WC/MQ+I73u/Q
         MgGkZ7cdVcBcGsh3Fgj4TozUhEzFx1TQhyAt3PI7mUVdtrD/O+cyEhMB6WokcwEfwVwL
         wNFv5xaNSD2jlf99PUW86IPvvUxhocTkq4LvhCMUOfWy0Zg+uZAGRhXT3tlmflcyzIed
         XtV7/AqSQuFsIDOoDMvorPFpWDPUXLYDlADfxLQcBtOgUMnwMhIh0foCpg9lm052wfAf
         rYr+AvNsriWQnvNJa1gwbEl+af9q0B0AcWYsjFQ06w7D1EtguP0njGwHdz0rYqhoLQtk
         V7dQ==
X-Gm-Message-State: AOAM531cGeQkMrIQKG0h/+k3DV4iz4EUV13PENbEzrw0z8JJECGyh7MM
        Z24bCagPHuzKUeQQaE2JAzbFDjFmno63mA==
X-Google-Smtp-Source: ABdhPJwF/Y+eayErgUWBro0wqzyRagQPvHniM2KZPBhKygp0Gwxyr5BL24c3tlP+OyrV9jKEUUXA2w==
X-Received: by 2002:a7b:c5c1:: with SMTP id n1mr19524269wmk.21.1592859236710;
        Mon, 22 Jun 2020 13:53:56 -0700 (PDT)
Received: from tws ([2a02:8071:21c1:4200:5089:20ae:4811:8fc])
        by smtp.gmail.com with ESMTPSA id l14sm2417020wrn.18.2020.06.22.13.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 13:53:56 -0700 (PDT)
Date:   Mon, 22 Jun 2020 22:53:55 +0200
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Subject: [PATCH] IPv6: Fix CPU contention on FIB6 GC
Message-ID: <20200622205355.GA869719@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When fib6_run_gc is called with parameter force=true the spinlock in
/net/ipv6/ip6_fib.c:2310 can lock all CPUs in softirq when
net.ipv6.route.max_size is exceeded (seen this multiple times).
One sotirq/CPU get's the lock. All others spin to get it. It takes
substantial time until all are done. Effectively it's a DOS vector.

As the splinlock is only enforcing that there is at most one GC running
at a time, it should IMHO be safe to use force=false here resulting
in spin_trylock_bh instead of spin_lock_bh, thus avoiding the lock
contention.

Finding a locked spinlock means some GC is going on already so it is
save to just skip another execution of the GC.

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 82cbb46a2a4f..7e6fbaf43549 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3205,7 +3205,7 @@ static int ip6_dst_gc(struct dst_ops *ops)
 		goto out;
 
 	net->ipv6.ip6_rt_gc_expire++;
-	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
+	fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, false);
 	entries = dst_entries_get_slow(ops);
 	if (entries < ops->gc_thresh)
 		net->ipv6.ip6_rt_gc_expire = rt_gc_timeout>>1;
-- 
2.25.1

