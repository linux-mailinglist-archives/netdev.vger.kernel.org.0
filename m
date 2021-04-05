Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5743E3545C9
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 19:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhDERDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 13:03:25 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:57021 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233095AbhDERDY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 13:03:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617642198; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=d+v3PqBqmobTpf4UPrjE7XKvG2o6TTpsv6c3K4j1hbo=; b=htEX8nlAPAC2TAPZhb0y3ydZiqkBdyfe+IdxdPs9fHqLgSL9fIGBut5pg8B+ur8rY7SjhbRS
 llie6a/BxOOQUinzSjHjCKffaLu3o7/REQcBuiOHOalI8SWeyzuBiT7JuYQUuXT+E8vjJGzD
 1D3Ew95LPiZxd46fGy5crdiw7iA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 606b42c59a9ff96d958402d4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 05 Apr 2021 17:03:01
 GMT
Sender: manojbm=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B5D1CC43465; Mon,  5 Apr 2021 17:03:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from manojbm-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: manojbm)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C837EC433ED;
        Mon,  5 Apr 2021 17:02:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C837EC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=manojbm@codeaurora.org
From:   Manoj Basapathi <manojbm@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     jgarzik@pobox.com, avem@davemloft.net, shemminger@vyatta.com,
        linville@tuxdriver.com, mkubecek@suse.cz, kuba@kernel.org,
        bpf@iogearbox.net, dsahern@gmail.com, kubakici@wp.pl,
        sharathv@qti.qualcomm.com, ssaha@qti.qualcomm.com,
        vidulak@qti.qualcomm.com, manojbm@qti.qualcomm.com,
        subashab@quicinc.com, rpavan@qti.qualcomm.com,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Sauvik Saha <ssaha@codeaurora.org>
Subject: [PATCH] tcp: Reset tcp connections in SYN-SENT state
Date:   Mon,  5 Apr 2021 22:32:42 +0530
Message-Id: <20210405170242.830-1-manojbm@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Userspace sends tcp connection (sock) destroy on network switch
i.e switching the default network of the device between multiple
networks(Cellular/Wifi/Ethernet).

Kernel though doesn't send reset for the connections in SYN-SENT state
and these connections continue to remain.
Even as per RFC 793, there is no hard rule to not send RST on ABORT in
this state.

Modify tcp_abort and tcp_disconnect behavior to send RST for connections
in syn-sent state to avoid lingering connections on network switch.

Signed-off-by: Manoj Basapathi <manojbm@codeaurora.org>
Signed-off-by: Sauvik Saha <ssaha@codeaurora.org>
---
 net/ipv4/tcp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e14fd0c50c10..627a472161fb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2888,7 +2888,7 @@ static inline bool tcp_need_reset(int state)
 {
 	return (1 << state) &
 	       (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT | TCPF_FIN_WAIT1 |
-		TCPF_FIN_WAIT2 | TCPF_SYN_RECV);
+		TCPF_FIN_WAIT2 | TCPF_SYN_RECV | TCPF_SYN_SENT);
 }
 
 static void tcp_rtx_queue_purge(struct sock *sk)
@@ -2954,8 +2954,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 		 */
 		tcp_send_active_reset(sk, gfp_any());
 		sk->sk_err = ECONNRESET;
-	} else if (old_state == TCP_SYN_SENT)
-		sk->sk_err = ECONNRESET;
+	}
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
-- 
2.29.0

