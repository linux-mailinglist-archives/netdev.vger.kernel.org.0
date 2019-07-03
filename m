Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5B65E1E8
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfGCKU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:20:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45380 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGCKU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 06:20:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id r1so1018536pfq.12;
        Wed, 03 Jul 2019 03:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JSXFORvWIxH8plnKtE8S95v6Fa7oKL7tWeFc2WXlLLA=;
        b=J6wr78MMn1baGGtuSpzes/kCt3oYwuhVVgfMqUxJ7r5HHV8KV4AEIuA9Fvu9Em0pRd
         kuf4YWI6eFiXnIqnZ8LZr0/z8LxbDOYrSSoDt5qV7Qas25g7FZmmfP/E6UtYaovO4zfx
         QlKxKSydHi6yU7QLomzJx4QuHFVEjCjMym8hGEG28I7ZFUifKIbA/gqAabOtC24qFxQg
         nm7mvOSqfCsS45EHUJt3qkbTgBEzr2XK3zxCgMIrXdDwDtxHBk8Y3XxUqqV9IpQFFaZN
         GEVvdLEmvLiGQT2GMZQ6fjW4mwvLzvFX6/XJ2RSsKhY9DRIpQJyC1QQCKhf2tqn+gIyb
         nr7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JSXFORvWIxH8plnKtE8S95v6Fa7oKL7tWeFc2WXlLLA=;
        b=aYIP04NK4g5voRxT3A4KUI8jr4QxjK3gU34sHkkZ6y7gR/kK8pk8pdrdzBCJGAbzV5
         WzQG4xQJkhhxya9Nd/Debn2nZ73PyI/IEJ0wb2rSdC0eGEGBa0FZvPXY8BbPlM48srig
         azATwNLHnR5X7sNaruFtVSFEwusInj6c4j5LOspAmDVvqG9Osi3w8EuzuovzSHBHNP+J
         H/OilS+zvfLhpJQv5jXyGpWqMyWGL2e2DyN4Fs75CJiyXig1S/xj65yZY+ZmeR4fXEkW
         rp60IZoTzPZc1hzjrqowrZD26bLKUybzGdLAUPiRJPwD1L+FH0hkXN6sh6tn4lvXmiSr
         2prA==
X-Gm-Message-State: APjAAAW44MN9S7qrl7nIR8JwWfAGr33QTQ2Z5WfUgko0FwOl0DWO6qms
        9Y8axhnXANHFi1F8d7St6uC0O5hb
X-Google-Smtp-Source: APXvYqyZHNWDpVk8sQFfJPda0eBRVozA+U5VSCYqSwYI1x5KQOcBsE0MnaN1CmUpu+zXB9TRAHRvvw==
X-Received: by 2002:a17:90a:ac13:: with SMTP id o19mr11782452pjq.143.1562149228070;
        Wed, 03 Jul 2019 03:20:28 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u5sm1705440pgp.19.2019.07.03.03.20.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 03:20:27 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: count data bundling sack chunk for outctrlchunks
Date:   Wed,  3 Jul 2019 18:20:20 +0800
Message-Id: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now all ctrl chunks are counted for asoc stats.octrlchunks and net
SCTP_MIB_OUTCTRLCHUNKS either after queuing up or bundling, other
than the chunk maked and bundled in sctp_packet_bundle_sack, which
caused 'outctrlchunks' not consistent with 'inctrlchunks' in peer.

This issue exists since very beginning, here to fix it by increasing
both net SCTP_MIB_OUTCTRLCHUNKS and asoc stats.octrlchunks when sack
chunk is maked and bundled in sctp_packet_bundle_sack.

Reported-by: Ja Ram Jeon <jajeon@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index e0c2747..dbda7e7 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -282,6 +282,9 @@ static enum sctp_xmit sctp_packet_bundle_sack(struct sctp_packet *pkt,
 					sctp_chunk_free(sack);
 					goto out;
 				}
+				SCTP_INC_STATS(sock_net(asoc->base.sk),
+					       SCTP_MIB_OUTCTRLCHUNKS);
+				asoc->stats.octrlchunks++;
 				asoc->peer.sack_needed = 0;
 				if (del_timer(timer))
 					sctp_association_put(asoc);
-- 
2.1.0

