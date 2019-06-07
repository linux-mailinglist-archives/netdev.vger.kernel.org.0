Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6B13931F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbfFGR1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:27:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38610 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728876AbfFGR1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:27:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id d18so2946666wrs.5
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 10:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ChgpTWtukHl+YjUpiPPXekhjxk1keAFEIrrLUlPyQgQ=;
        b=KIUfi/juu6xzkCPnaGw6PvRh37/H10zga59ifZJ8bsXbDDuCYi/rWMBRdfOZxC4MbP
         2Q7xMqJleQ3tkq2zJoZ+H6gM2XMMz56GSd1AxV7e7+OQCqm7S9wu85/5fDQuTtmc2gVD
         dFw1UhHVI3DBWZKwJzdenqCztyaFCnp7FFe3H0czXLaKIFAdcIHL1jdUKmNjI1eVdmVV
         ogw8Vw17yKw37Lkrfx0SHzQUfH6JOi5VEs9pR7Gm0il6V2vlm4+zt4H3P5mKWRuMdrQT
         OKdz/UiveoIGCkvAg7V7329FmygsOc4pcOhnFRYCt/AE6/IWxuyoeDTd8NRn5s65WdZy
         bzEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ChgpTWtukHl+YjUpiPPXekhjxk1keAFEIrrLUlPyQgQ=;
        b=ijiX3uIG63OMTi866JVLAMLv8T4pWhbZDUDnE+XcywMGMAamRFW34pQtaP5eko47Sb
         zpPQrEfjpab6KiTsGu64tpeqtMPK+NIxP5PD6MxbC6Sc7XKK6vgRdA/M6rQnYOgMLrMd
         z21P7z0505PCnz//LnV1q15umyVy1PEelvbc/n205hzTSgAuaXVW0LBM8ISLNU0Ohsfl
         5ZGwspy+SRGfLkI4gkJHk0sIympFWcH0LpPl7HUXKhqMDCPXYIP6Ipr0ReDfmN9EWBXa
         MLD5m/l9psjMeQdh1Q5BlpSvXwfSfto3vwkWekKPakcgXAcyR+DXZgrGUk7920HSN7eK
         13jw==
X-Gm-Message-State: APjAAAXegMYNu7Yuc8BkNUr6heWMpw9O8TbB7gNbl4/z6mMRwpm9aJAv
        QPGoLE033tlFwA==
X-Google-Smtp-Source: APXvYqwg0FQmLoacDlxCZkueQ6AYUXDnD8njCOvlj9HwHzVhxzvWmLoScZW1QZwyuDhiEi5+3wQksA==
X-Received: by 2002:adf:f003:: with SMTP id j3mr20054842wro.250.1559928419074;
        Fri, 07 Jun 2019 10:26:59 -0700 (PDT)
Received: from x-Inspiron-15-5568.fritz.box (ip-95-223-112-76.hsi16.unitymediagroup.de. [95.223.112.76])
        by smtp.gmail.com with ESMTPSA id q7sm2452556wrs.65.2019.06.07.10.26.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 10:26:58 -0700 (PDT)
From:   Sergej Benilov <sergej.benilov@googlemail.com>
To:     venza@brownhat.org, netdev@vger.kernel.org
Cc:     Sergej Benilov <sergej.benilov@googlemail.com>
Subject: [PATCH] sis900: re-enable high throughput
Date:   Fri,  7 Jun 2019 19:26:28 +0200
Message-Id: <20190607172628.31471-1-sergej.benilov@googlemail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 605ad7f184b60cfaacbc038aa6c55ee68dee3c89 "tcp: refine TSO autosizing",
the TSQ limit is computed as the smaller of
sysctl_tcp_limit_output_bytes and max(2 * skb->truesize, sk->sk_pacing_rate >> 10).
For some connections this approach sets a low limit, reducing throughput dramatically.

Add a call to skb_orphan() to sis900_start_xmit()
to speed up packets delivery from the kernel to the driver.

Test:
netperf -H remote -l -2000000 -- -s 1000000

before patch:

MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380 327680 327680    341.79      0.05

after patch:

MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to remote () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380 327680 327680    1.29       12.54

Signed-off-by: Sergej Benilov <sergej.benilov@googlemail.com>
---
 drivers/net/ethernet/sis/sis900.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
index fd812d2e..ca17b50c 100644
--- a/drivers/net/ethernet/sis/sis900.c
+++ b/drivers/net/ethernet/sis/sis900.c
@@ -1604,6 +1604,7 @@ sis900_start_xmit(struct sk_buff *skb, struct net_device *net_dev)
 	unsigned int  index_cur_tx, index_dirty_tx;
 	unsigned int  count_dirty_tx;
 
+	skb_orphan(skb);
 	spin_lock_irqsave(&sis_priv->lock, flags);
 
 	/* Calculate the next Tx descriptor entry. */
-- 
2.17.1

