Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13FB146784
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 13:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgAWMFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 07:05:52 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43306 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgAWMFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 07:05:52 -0500
Received: by mail-pf1-f195.google.com with SMTP id x6so1438447pfo.10;
        Thu, 23 Jan 2020 04:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CqY9YB2wAiI/Wp57Yy4bkMwCyRsVGvnd5+giEA8fZSk=;
        b=pkl7+p+1Dr0758k+BCjkzs4ph/iqSiSuLUHgd/o8DCTfZPM1Xa0HUXTPlF7BDRUC4P
         MO4SZ7wblivWzi/UgguYV0RSwHelwC6Zs71MY4RsjjHDBGvvoQhXHyaEgn3xwGmx6Laj
         HSZTs/TaoMqLoG5tkLHtAMM7whbKuvEhl+iIABEFWkuknY9qMLd5eVd9EQQirj5kv3wY
         k0tAGHXKlzbNIHNO8YMEGWfzfvvmwVZ/Q1SNJUOi1DQoOUpWDXQoXDq7DslZcDbhSPZm
         F7dm1bZzKHYKG+rMTiRTxHzo+avb44OE8E1qsbFsN+44v22bINxc/DUSfnS4obhHPd5H
         A2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CqY9YB2wAiI/Wp57Yy4bkMwCyRsVGvnd5+giEA8fZSk=;
        b=JJhDjdkaFYdAzX28DVAVRms45BYMQ61kgrfFALli2HyDOb40IAolF810Rr5dk7hCUI
         xhsCy03alWg9q0N/0+dO+a5yzjdw3b5K1w1sBW07rnmuSi8sMeBwIiipb2uqQF2Wcp5w
         FbwcbyuqDsBQ6csWoQ/t/zHR8QWm07Mmc6WgjGuSQ77rlu6BllE+UW4+d9gRrXfSnrr9
         ShEdbruddKJugkdsgGpRj38zzUS9cMNRX9Hn4gVywri7HqvQcMA9g26ar49JUxX1VJId
         HAYkX+XPhU8oveULLwWO3VZqPIJ4fLWl3pI7CiHb/cSwpPvM/FjqWuKwj1PHln7r8XZN
         zhEg==
X-Gm-Message-State: APjAAAWUaEBq+vTE1qfNj0OVisgtoiyLvsvLagHyeQrsKkMO48p2FNU4
        CD7KOBOFAX3NEdv+RLq+lXQ=
X-Google-Smtp-Source: APXvYqyyH5J0GupMgirTs+5mSj6AqYDWZ14SFy5qG7Ze2gsIZwMDdoS6reaTPzuQVkr8hVKTy8aekw==
X-Received: by 2002:a63:e954:: with SMTP id q20mr3792032pgj.204.1579781151245;
        Thu, 23 Jan 2020 04:05:51 -0800 (PST)
Received: from localhost.localdomain ([103.211.17.138])
        by smtp.googlemail.com with ESMTPSA id x18sm2643381pfr.26.2020.01.23.04.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 04:05:50 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH] bpf: devmap: Pass lockdep expression to RCU lists
Date:   Thu, 23 Jan 2020 17:34:38 +0530
Message-Id: <20200123120437.26506-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

head is traversed using hlist_for_each_entry_rcu outside an
RCU read-side critical section but under the protection
of dtab->index_lock.

Hence, add corresponding lockdep expression to silence false-positive
lockdep warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 kernel/bpf/devmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 3d3d61b5985b..b4b6b77f309c 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -293,7 +293,8 @@ struct bpf_dtab_netdev *__dev_map_hash_lookup_elem(struct bpf_map *map, u32 key)
 	struct hlist_head *head = dev_map_index_hash(dtab, key);
 	struct bpf_dtab_netdev *dev;
 
-	hlist_for_each_entry_rcu(dev, head, index_hlist)
+	hlist_for_each_entry_rcu(dev, head, index_hlist,
+				 lockdep_is_held(&dtab->index_lock))
 		if (dev->idx == key)
 			return dev;
 
-- 
2.24.1

