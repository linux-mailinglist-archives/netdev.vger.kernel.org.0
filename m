Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA6747FB0A
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 09:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhL0Ibh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 03:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhL0Ibh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 03:31:37 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F7BC06173E;
        Mon, 27 Dec 2021 00:31:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v16so12917150pjn.1;
        Mon, 27 Dec 2021 00:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rbgsHophdEOuD8rdPsWfvcnl/Y/41s9/BVnXbagiOUQ=;
        b=ITmdv861TcHzMi4pcq2c9CrAAhr6713oDv0ckivmZDBgikmDU5CEypLQ+CgSh6K321
         d7KAk20vVwjG4vw5hUGMRAO/6ho7aP257xGDiRCGb5dcNvG24/R+tqDWVWUa6jtsDDGf
         MhGZnum5D3iXtDCDK/kWraIma+Z/0K/vQx9vhGUawrCu8y+q3NqRdlXiHnEUxofK8O2g
         MoSh9L+H8Sfw4z+9BrqGewrK/E0B55erv5YnlgK9zoxazW5Wac0ZgGvbTnrK+/FNYCZI
         QRcRbZDiXIq+IOEnyj6jhdFywlge8tTWbgeKYx1sAjU5ALED9l5p32et0Ix31DmhyJ2h
         pg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rbgsHophdEOuD8rdPsWfvcnl/Y/41s9/BVnXbagiOUQ=;
        b=gh5hdjE/KIiOHM6z1u4rWtxcWvlX6UjjE3gsEp62RpuuPr/32DBmHN2pT02oJ3moSG
         82ngIoXX9NHkGdKvvKEkWYLOEOMOVMMFwWoNLOXbF5QN15OW6gX4wAQzA++wnYyDRpC2
         mXbnwGTNMIQUIgHHUZIX0x+0OMi+uPJa/P+JF+mAWkR52q5DTwE8qCWShxUuapoo0qnX
         hhxrHB+/SBdDSVmLKIIkXtp/rSayZiMhuirQSWdiSQeYOd0WReDYJWulhtb2Y1aZnqfB
         1smIE9HHfFzTyJVvQKsS3RL7WtB01FjlSLxQ+X4cUGInSBXrvWq0ya8yA8/FU4EXJrc2
         XDgA==
X-Gm-Message-State: AOAM530GT2RMAxSbyz/1ylB+6BZjzDTjvI3eQNEPnNaTbF1h7rQz4CmU
        J9fI4hBCr0n9+myVgmu1gli6PcteYGOzw6mlOb8=
X-Google-Smtp-Source: ABdhPJwH2WDDxEuTrrMZddHUdYj1ufuMXNrYNNbMitBd8S8x0Qajtd9NbSbBqsfl5cKWGQkccIUjSQ==
X-Received: by 2002:a17:902:a404:b0:148:b897:c658 with SMTP id p4-20020a170902a40400b00148b897c658mr16235438plq.71.1640593896526;
        Mon, 27 Dec 2021 00:31:36 -0800 (PST)
Received: from ubuntu-hirsute.. ([61.16.102.69])
        by smtp.gmail.com with ESMTPSA id r10sm16139145pff.120.2021.12.27.00.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 00:31:36 -0800 (PST)
From:   yangxingwu <xingwu.yang@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, yangxingwu <xingwu.yang@gmail.com>
Subject: [PATCH] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon, 27 Dec 2021 16:29:51 +0800
Message-Id: <20211227082951.844543-1-xingwu.yang@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ cat /pro/net/udp

before:

  sl  local_address rem_address   st tx_queue rx_queue tr tm->when
26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000

after:

   sl  local_address rem_address   st tx_queue rx_queue tr tm->when
26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15c6b450b8db..0cd6b857e7ec 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3075,7 +3075,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
 {
 	seq_setwidth(seq, 127);
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "  sl  local_address rem_address   st tx_queue "
+		seq_puts(seq, "   sl  local_address rem_address   st tx_queue "
 			   "rx_queue tr tm->when retrnsmt   uid  timeout "
 			   "inode ref pointer drops");
 	else {
-- 
2.30.2

