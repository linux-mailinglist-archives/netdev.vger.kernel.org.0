Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9B9EA242
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 18:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfJ3RFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 13:05:52 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:35575 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfJ3RFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 13:05:52 -0400
Received: by mail-vk1-f202.google.com with SMTP id u23so1189598vkl.2
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 10:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5qXhL3yuVFDcZlN13d/q4oGn6Wj99du4mlgXBXo3op8=;
        b=RW+FCZfGYfzjICeO8i+aDZADu8x1KRnqIJHwC+ziR9Y432kOdw578RbqhGm/w70DW9
         jH1b61DiPYvxZVLKhaQiMFB2zb8itfKQ6gDN7m+p/CkeA1DMRsfTbLwMjKA9gh4qxJrB
         XEYNyE5o+DebtjlPjM1ghAgdhbBM09+O9uCmEqJ0rqc3C8iCxQ6OHqK+mhQSy1/srhDY
         D9luNI9WIUrw4+xbSzzz8cIAvLMWzdIUOKsHnb2ZH5pxahnTZNDQQ9GJooAlQ9zDpy0U
         zFah4doUjb2Ia2911xNHKnfh64Rkic2vl5cbIAsk2UW3ddzgIa7UyCmohhjdFE/8h2wv
         0EyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5qXhL3yuVFDcZlN13d/q4oGn6Wj99du4mlgXBXo3op8=;
        b=bDtHADiI/Dsoa/8A2Id+Ek4g2w8Ut8PWe9dHpjt4kcNNO8jgKbT6caPYm7tOf/p3pX
         cGI7M3XBS0QzW4TprGk6K6uk1R+16t/IPEHdC14mcmR9dntqRDN5IYQIhsOpVRFEK4cQ
         8oYPM7CC2B4ucKQpp6ba3dftvfEZdaPLs/nzQWzEpYNU74yUzRI//U4Lhr8C8u4+pV+h
         cTnX/HOJT7ve844XpLE5/mgFMgCzqQR81/ovynKv+9PSRpuMThBmxekh9QLdbqmC6bM1
         zRXlFx0CFewR0ccYmcoxfBJGWS3BVLre8UQVpArAE/8SJQ9Or1uvZU7mUJUZbPwAF3Sx
         2C9g==
X-Gm-Message-State: APjAAAWqzF+8hNMYiytCvqHVdNBJgysTrHIX2W54PNSR78J3O3SWAs4j
        Fxe6l1466w6jBBSJHoekbHUGbyG7XIF5vQ==
X-Google-Smtp-Source: APXvYqy346c14MTy7YMahpN1f8/cEZyi84gCJplIlQDZXRBhswmdeuwLv/bIrfwRH7++a/0ZC1yMnWXelSiZiw==
X-Received: by 2002:a1f:24c6:: with SMTP id k189mr229972vkk.32.1572455149499;
 Wed, 30 Oct 2019 10:05:49 -0700 (PDT)
Date:   Wed, 30 Oct 2019 10:05:46 -0700
Message-Id: <20191030170546.146784-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH net] tcp: increase tcp_max_syn_backlog max value
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>, Willy Tarreau <w@1wt.eu>,
        Yue Cao <ycao009@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_max_syn_backlog default value depends on memory size
and TCP ehash size. Before this patch, the max value
was 2048 [1], which is considered too small nowadays.

Increase it to 4096 to match the recent SOMAXCONN change.

[1] This is with TCP ehash size being capped to 524288 buckets.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Yue Cao <ycao009@ucr.edu>
---
 Documentation/networking/ip-sysctl.txt | 7 +++++--
 net/ipv4/tcp_ipv4.c                    | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index ffa5f8892a66ed3bfcd53903cc6badf28dfa0f50..6405f6fa756be0dac510281eff2f273b520eccea 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -408,11 +408,14 @@ tcp_max_orphans - INTEGER
 	up to ~64K of unswappable memory.
 
 tcp_max_syn_backlog - INTEGER
-	Maximal number of remembered connection requests, which have not
-	received an acknowledgment from connecting client.
+	Maximal number of remembered connection requests (SYN_RECV),
+	which have not received an acknowledgment from connecting client.
+	This is a per-listener limit.
 	The minimal value is 128 for low memory machines, and it will
 	increase in proportion to the memory of machine.
 	If server suffers from overload, try increasing this number.
+	Remember to also check /proc/sys/net/core/somaxconn
+	A SYN_RECV request socket consumes about 304 bytes of memory.
 
 tcp_max_tw_buckets - INTEGER
 	Maximal number of timewait sockets held by system simultaneously.
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index c616f0ad1fa0bcd07460142a4a86ad13d9177c84..1dd0fc12676f99508341c78d40b941abc8528072 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2679,7 +2679,7 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.tcp_death_row.sysctl_max_tw_buckets = cnt / 2;
 	net->ipv4.tcp_death_row.hashinfo = &tcp_hashinfo;
 
-	net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 256);
+	net->ipv4.sysctl_max_syn_backlog = max(128, cnt / 128);
 	net->ipv4.sysctl_tcp_sack = 1;
 	net->ipv4.sysctl_tcp_window_scaling = 1;
 	net->ipv4.sysctl_tcp_timestamps = 1;
-- 
2.24.0.rc0.303.g954a862665-goog

