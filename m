Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66B52871EB
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgJHJt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgJHJt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:49:58 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D60C061755;
        Thu,  8 Oct 2020 02:49:58 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 7so3810835pgm.11;
        Thu, 08 Oct 2020 02:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=ccnTdRi301/TdXAApcTfL39DiVa+OmKFQ/8+9UDuAeU=;
        b=CwwMaLDXlQDIPgkCCSE5DGBmA08149Qmw8ypvNRq+0GVsbzUxVxN38K632z4xEu84X
         9AmDjy/14yeotECYm3bSzuwOhBMnOirW46nhHaGieTUxkR72nQhFGM+tP+LgzPfMqzGE
         CJozn1wKvK8VMJ2mLDWic/JK9Z/FDpjhaopIbPAmg8KgEwd/zNUoY0GjUvVSC1RoaY/n
         bcuY72bFjfvb8YC1aPhJNVX/kDFJNIWgHyR64Ys1u/VkTxy8j2iVnnxnzFraRwtI75jW
         eYR83+WGpGp9zXLQnLzclHNk+be2yK/jTwHlHvqilhNWw4LPQMMcp0CnWeWxbQq6NlBv
         6Zmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=ccnTdRi301/TdXAApcTfL39DiVa+OmKFQ/8+9UDuAeU=;
        b=SSO+IgQyFhgZsC63B/RBiByZIIw+iyfKQw3GkcCJc5v9/yTS34DwblaTG2b0/2cMET
         34dLxG9gQWXGspcbphRZiH2/kNHEW4iKYFrtMwF3JO6eA0AhWR8sM2diqUAczBARttFs
         EYsA/Wvpa/yWa5+etXLrre0S7q7Ji7gPgHBjt5ALMb/zy73x0p/gB6i3RlXnWXucTDy9
         Ho8CETbTvL1en7ird2XU0mo3/YwkmpAs4mSjnFR8LKj/WTecO9Uk95YBct4wxzLIQyeE
         qkgwkZzQ42PWPqrT/ALvF8fAO0FI7DPuqOnZ6E4JUx43ssgfrVtvW7Hig4+NBloALI6G
         eOdw==
X-Gm-Message-State: AOAM530938wj1Vfnma9np2jIIHd+JejM9afZzXXzPRm3I18jeETOtlGi
        6KYeQMjbb57va2Dv5OuuCSn/r1ShJ5Y=
X-Google-Smtp-Source: ABdhPJxBazcIs7wzMgTLEWikewpcizbM2KE4uXwChCeV6kDT60ppFSGuIpuYhDKcYjacOHOGJyoumw==
X-Received: by 2002:a17:90b:50a:: with SMTP id r10mr3010722pjz.231.1602150597916;
        Thu, 08 Oct 2020 02:49:57 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id fv13sm6407198pjb.50.2020.10.08.02.49.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:49:57 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 12/17] sctp: call sk_setup_caps in sctp_packet_transmit instead
Date:   Thu,  8 Oct 2020 17:48:08 +0800
Message-Id: <ad362276ba90a8af3178f19aba15a7e67107652f.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <483d9eec159b22172fe04dacd58d7f88dfc2f301.1602150362.git.lucien.xin@gmail.com>
 <17cab00046ea7fe36c8383925a4fc3fbc028c511.1602150362.git.lucien.xin@gmail.com>
 <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <baba90f09cbb5de03a6216c9f6308d0e4fb2f3c1.1602150362.git.lucien.xin@gmail.com>
 <bcb5453d0f8abd3d499c8af467340ade1698af11.1602150362.git.lucien.xin@gmail.com>
 <bdbd57b89b92716d17fecce1f658c60cca261bee.1602150362.git.lucien.xin@gmail.com>
 <92d28810a72dee9d0d49e7433b65027cb52de191.1602150362.git.lucien.xin@gmail.com>
 <1128490426bfb52572ba338e7a631658da49f34c.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sk_setup_caps() was originally called in Commit 90017accff61 ("sctp:
Add GSO support"), as:

  "We have to refresh this in case we are xmiting to more than one
   transport at a time"

This actually happens in the loop of sctp_outq_flush_transports(),
and it shouldn't be tied to gso, so move it out of gso part and
before sctp_packet_pack().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 1441eaf..fb16500 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -508,12 +508,6 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 					sizeof(struct inet6_skb_parm)));
 		skb_shinfo(head)->gso_segs = pkt_count;
 		skb_shinfo(head)->gso_size = GSO_BY_FRAGS;
-		rcu_read_lock();
-		if (skb_dst(head) != tp->dst) {
-			dst_hold(tp->dst);
-			sk_setup_caps(sk, tp->dst);
-		}
-		rcu_read_unlock();
 		goto chksum;
 	}
 
@@ -593,6 +587,13 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	}
 	skb_dst_set(head, dst);
 
+	rcu_read_lock();
+	if (__sk_dst_get(sk) != tp->dst) {
+		dst_hold(tp->dst);
+		sk_setup_caps(sk, tp->dst);
+	}
+	rcu_read_unlock();
+
 	/* pack up chunks */
 	pkt_count = sctp_packet_pack(packet, head, gso, gfp);
 	if (!pkt_count) {
-- 
2.1.0

