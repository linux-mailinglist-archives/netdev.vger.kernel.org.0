Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA0113A272
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 09:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgANIEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 03:04:16 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44039 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgANIEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 03:04:16 -0500
Received: by mail-wr1-f65.google.com with SMTP id q10so11126738wrm.11;
        Tue, 14 Jan 2020 00:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tOBb/YBX+mgFK3HoZRSSrszIJj8mOyipLOkzLeqqBos=;
        b=kjW9+tOMEv/CdrVht6LgVC8LJyOQR3+lzLqzT9j4tbzaNeDYLd6L/p8Q+86zYa0rv9
         9WNpwoXYYNoIwBYJbh8XIrOPSDn7j6UkDBBMeUkYF2qQUyd+NMTXQip7eQfsQVEUKjAr
         5LfE0MKXUpieGWQg3MMrLpZ9eRtjy5IQcT920cp5BHmML0C3iSXNJSf1bwa274ys57K6
         jG37BObm6sN3KPnzjWueGaQUScgWB/v4zjJCxFkGPmnk+7f85mmP27wdqHOpezdzyPd3
         flVw4MWmc5iB/bfbCG42lcByafJ50J9+prI3RYNS8ZinyGQ0jjASOxtIiP+bntVfSANX
         Nc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tOBb/YBX+mgFK3HoZRSSrszIJj8mOyipLOkzLeqqBos=;
        b=nalGTplKZeVkV8wYPSK3/E1GyLkS5yOTWSYl5TbKPWY2oMkm7B+Ceg6YAe4fhI+SXb
         yDjHrUqWiK8Dy2PGYPmost4fctSGr71WYMqB8gY6dKW05bary6S30tvMY4CqgDPUwrT9
         YxSfSX37Ha53Bc98tSzcgkEBK/hO4fH1PNOqPUPCPI50Y08i1SkQaaeW6n8wIkaZbvbV
         6qYB+cRmRU7FRTBlj4/I7OD1G8M/HuG3s8eEMxYFni3yqgWq2W/r6JDbIT4nQqnOemeb
         4nI+rGeaQ+7H1TS36eiDKvzebJsl4ACtAV7szVuhoKxPA9h+xU6fhW1S//k/QK0/Rby4
         xOwQ==
X-Gm-Message-State: APjAAAXU+e6YqX2vjEFTBbOxs2r5EQsDdsWjHah6GfFcvAd8cGD726Fo
        PYk0d9EQOzpwp3NyDKvi2oc=
X-Google-Smtp-Source: APXvYqzE3NCzivSoAfFEEE5KUOZc0EnalZ6I9WzQuCzL4JdGsgkSW/tFYMu6wuEhaibv1VUWpQiWtQ==
X-Received: by 2002:a05:6000:118e:: with SMTP id g14mr23195865wrx.39.1578989053563;
        Tue, 14 Jan 2020 00:04:13 -0800 (PST)
Received: from localhost.localdomain (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id p5sm17640772wrt.79.2020.01.14.00.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 00:04:12 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [net,v2] netfilter: nat: fix ICMP header corruption on ICMP errors
Date:   Tue, 14 Jan 2020 10:03:50 +0200
Message-Id: <20200114080350.4693-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
made nf_nat_icmp_reply_translation() use icmp_manip_pkt() as the l4
manipulation function for the outer packet on ICMP errors.

However, icmp_manip_pkt() assumes the packet has an 'id' field which
is not correct for all types of ICMP messages.

This is not correct for ICMP error packets, and leads to bogus bytes
being written the ICMP header, which can be wrongfully regarded as
'length' bytes by RFC 4884 compliant receivers.

Fix by assigning the 'id' field only for ICMP messages that have this
semantic.

Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Fixes: 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---
v1->v2 apply id field to all relevant ICMP messages
---
 net/netfilter/nf_nat_proto.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 0a59c14b5177..64eedc17037a 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -233,6 +233,19 @@ icmp_manip_pkt(struct sk_buff *skb,
 		return false;
 
 	hdr = (struct icmphdr *)(skb->data + hdroff);
+	switch (hdr->type) {
+	case ICMP_ECHO:
+	case ICMP_ECHOREPLY:
+	case ICMP_TIMESTAMP:
+	case ICMP_TIMESTAMPREPLY:
+	case ICMP_INFO_REQUEST:
+	case ICMP_INFO_REPLY:
+	case ICMP_ADDRESS:
+	case ICMP_ADDRESSREPLY:
+		break;
+	default:
+		return true;
+	}
 	inet_proto_csum_replace2(&hdr->checksum, skb,
 				 hdr->un.echo.id, tuple->src.u.icmp.id, false);
 	hdr->un.echo.id = tuple->src.u.icmp.id;
-- 
2.20.1

