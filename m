Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C265CC1E64
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbfI3JsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:48:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39972 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730033AbfI3JsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:48:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so11935321wmj.5
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p4lgqQje4EBzZCisTQ5kwgkJTWm0D9L/zyJz0Qy9kZQ=;
        b=DxeMlKwfHIX3jcBVd+/TJbF7yJ+yx/DrBThpBca9sNvc1BCqn1HkqtCLBu2rfDKL9o
         mHQ/ZFNnSBBmXpWmyHx2ItBiw8RDfp9uJIBg/ynbttjhh37dbxS1LgTjpjFV+fdRA7/c
         XT3HudVLeAs9k3dx1B/H15WFmu0eaXh+E8TZZGvEKGXlfHrCZ4c3pbxdXanNCQHA2Uar
         qUDYOdl2gAS8C+Ir5UKpvC/qD7k1+meqYEunsJG6DtywmZiBd6FpYnu+QJxBp9E2EZ2J
         7RZ6s1jOXZsKtKrA/2TbaX6ZBABdKW8kuCMDPsqVYeAuF/KvbnPPVdpnYurlNqVhgPjG
         N00Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p4lgqQje4EBzZCisTQ5kwgkJTWm0D9L/zyJz0Qy9kZQ=;
        b=rYHFD+tMeIUd2pVG3JWbbbG4aCakoaIor5T8e7zml1Ncaxo0TcnXba8R5dSscYT4KP
         gTWoxQV2yAZ15rEoKa3FBTU/EWjAWqMRkQkzSyvGUBu9NKtoSjm1yv/Nh9ULJOPKNazC
         /78NFMy0piCd1LWFaXHEZFzs0CnPOG85T4sUKWoxa+O0SEJeMkPnq/l2T1g4rZ4FWcwd
         nxPi5uZlW2KkOex1GxoBsDxDFm4s2Hl/+Wdn/b1NC8tnhVFzGiVAWGQAM9WGRK5rtXNb
         uZxQyePQbhWh7XYD/cCvNPnCFNFBThKdmtI/eTVgyCeDgzd1YOQHMZ48w8TM5qXdHGxt
         HBXQ==
X-Gm-Message-State: APjAAAUQSv4CcB3kTY2k8AksnPom004kYjtOZPprIJQ2bj/0D2PSGfiV
        2evM4tDzlA7LRnNCw5k9M4h1J7ha/8w=
X-Google-Smtp-Source: APXvYqwkl1rcS30rm/oYHbSH4AGs7wlEtoMUwqgLY1YFXk2EPufzPKl/Swl7COd0b/Or3xdLiEVuuw==
X-Received: by 2002:a1c:4108:: with SMTP id o8mr17367925wma.129.1569836902669;
        Mon, 30 Sep 2019 02:48:22 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id k24sm26234594wmi.1.2019.09.30.02.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:48:22 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 1/7] net: procfs: use index hashlist instead of name hashlist
Date:   Mon, 30 Sep 2019 11:48:14 +0200
Message-Id: <20190930094820.11281-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Name hashlist is going to be used for more than just dev->name, so use
rather index hashlist for iteration over net_device instances.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/net-procfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 36347933ec3a..6bbd06f7dc7d 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -20,8 +20,8 @@ static inline struct net_device *dev_from_same_bucket(struct seq_file *seq, loff
 	struct hlist_head *h;
 	unsigned int count = 0, offset = get_offset(*pos);
 
-	h = &net->dev_name_head[get_bucket(*pos)];
-	hlist_for_each_entry_rcu(dev, h, name_hlist) {
+	h = &net->dev_index_head[get_bucket(*pos)];
+	hlist_for_each_entry_rcu(dev, h, index_hlist) {
 		if (++count == offset)
 			return dev;
 	}
-- 
2.21.0

