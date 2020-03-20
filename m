Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB16F18CC66
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 12:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgCTLKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 07:10:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34330 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgCTLKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 07:10:07 -0400
Received: by mail-pg1-f196.google.com with SMTP id t3so2929002pgn.1;
        Fri, 20 Mar 2020 04:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8DC0Aw490tAtEteDyenp5f58iML9PsV1SemgO6pMc4k=;
        b=id84JLVQrc1pByXQ0kRoTprdf6KnYiB0t8lk6sCBFM9RdBrAOUPfbvVMzV9qiaL87i
         Wvp0xRICCAcPHoCFnMV8StTu3kzu2Ft7+QZOs/hvVTDp5jVlpx8UGbuABCSV+viP2YNC
         mRkOrLWy6XA1ndOvPPBf3ObeCBzPs4nSgMonij7C0tCECY+ai9NEJSlOfTAmCYY7HowQ
         ypNdhiNr1c38NknrwPv2fPDaonMx/BfmL48kL+8o3LrdM6Fc0w3969as+h8J+OwPzxsa
         HnPzBg+fibzVhbE8FTsCvmqAH8+x9IkWTNoFBL3QbbE2qNdzuWnBsNsWef+oiodFcD1e
         9u1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8DC0Aw490tAtEteDyenp5f58iML9PsV1SemgO6pMc4k=;
        b=om4pd303E0mgA1BPEs76WWotfJpBWkwFrcgK7xyoelHDpjpVsJ2JZw0iMmcVq+nlJu
         +gCQI0PDrbgb6amHrjhs9kn1X3mcFtZPz8BVbIJWey2KfHnzBU6Bkn1sHEci1H2ehHru
         B9JEfMx1ttJoBBAXdlpmb4pylRxHYqwLP10CuUzURjEvkglvkBziDWWzyH5A2EKClFj1
         kGGZdYH0gJEjLaqtss/zLf1mBTONyD9NE5J7NYOhqzaoSUq7N06mbnneuvSRkDmh0PQV
         b/Rg2ucj3kuxpBUJYECCS+81X7bQZasOcyzrDY0WDlNR6iwvCcmNhYcPA/CufCaVhYom
         WYGg==
X-Gm-Message-State: ANhLgQ2JKfDZxtRw9RH0SYH4wXJrpfiueMatf5FKmY6fOp0nBKxqSXiY
        83Gpc0F5nk/aUdPacOWjQIwcU/TOHCkWlg==
X-Google-Smtp-Source: ADFU+vuVlMHmABpQyheyAcx3cY1cUhb6lfIhNDQ0xBjDWcqim11OoGyYbBSUhx+SgoDYa54pUcjH7w==
X-Received: by 2002:a62:d144:: with SMTP id t4mr1396205pfl.10.1584702605420;
        Fri, 20 Mar 2020 04:10:05 -0700 (PDT)
Received: from localhost ([161.117.239.120])
        by smtp.gmail.com with ESMTPSA id u9sm5202984pfn.116.2020.03.20.04.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Mar 2020 04:10:04 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     marcelo.leitner@gmail.com, davem@davemloft.net
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH v3] sctp: fix refcount bug in sctp_wfree
Date:   Fri, 20 Mar 2020 19:09:59 +0800
Message-Id: <20200320110959.2114-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do accounting for skb's real sk.
In some case skb->sk != asoc->base.sk:

for the trouble SKB, it was in outq->transmitted queue

sctp_outq_sack
	sctp_check_transmitted
		SKB was moved to outq->sack
	then throw away the sack queue
		SKB was deleted from outq->sack
(but the datamsg held SKB at sctp_datamsg_to_asoc
So, sctp_wfree was not called to destroy SKB)

then migrate happened

	sctp_for_each_tx_datachunk(
	sctp_clear_owner_w);
	sctp_assoc_migrate();
	sctp_for_each_tx_datachunk(
	sctp_set_owner_w);
SKB was not in the outq, and was not changed to newsk

finally

__sctp_outq_teardown
	sctp_chunk_put (for another skb)
		sctp_datamsg_put
			__kfree_skb(msg->frag_list)
				sctp_wfree (for SKB)
this case in sctp_wfree SKB->sk was oldsk.

It looks only trouble here so handling it in sctp_wfree is enough.

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc440606..5f5c28b30e25 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9080,7 +9080,7 @@ static void sctp_wfree(struct sk_buff *skb)
 {
 	struct sctp_chunk *chunk = skb_shinfo(skb)->destructor_arg;
 	struct sctp_association *asoc = chunk->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = skb->sk;
 
 	sk_mem_uncharge(sk, skb->truesize);
 	sk->sk_wmem_queued -= skb->truesize + sizeof(struct sctp_chunk);
@@ -9109,7 +9109,7 @@ static void sctp_wfree(struct sk_buff *skb)
 	}
 
 	sock_wfree(skb);
-	sctp_wake_up_waiters(sk, asoc);
+	sctp_wake_up_waiters(asoc->base.sk, asoc);
 
 	sctp_association_put(asoc);
 }
-- 
2.17.1

