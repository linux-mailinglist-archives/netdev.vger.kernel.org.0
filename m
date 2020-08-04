Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACBB23B7E5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHDJjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 05:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgHDJjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:39:43 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD79C06174A;
        Tue,  4 Aug 2020 02:39:43 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so21818997pgf.0;
        Tue, 04 Aug 2020 02:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVM8DPgIzaCBPlmdMpwhgrG6jaxJmkvPn7CWbb/dTlA=;
        b=ZSzidZsFNsMMcg+cnTYShgZHrAbKJaPoiT7zCW38D6fUKoVYti7+S11nWF1L/y22/K
         5O7K9aLgn3BSCNFjxZTFrEzTrHmTJHSk8gTaXqXQ1FPLgTWo8DxJUfWESFwARo9lxQ1T
         uDtL8eOVZcusQBHPWuCd/buOUyrenWARwMZil8qP9aqxHbE+T60lvxWB30PgrSVhno7G
         CsShOmJJbW+kIOifBJ7v998dwBRt5blF45VskwRTPMGoYvlvMHMSdbZ750T3Qcpx0/BU
         AKRhsxk14RqUJ0pPO/A05gRWr1+za0kHkGbvc1SmWvfe1N9Vy0q6lS7LzINrAZDgCtrK
         RUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lVM8DPgIzaCBPlmdMpwhgrG6jaxJmkvPn7CWbb/dTlA=;
        b=pA/5rbRlqsrMyXYG1Rq5JJj2tPcPBYztrTnE3/VaODl0k1mJmJRy+Q0Kf/dZ5+++LK
         edpEbGvHWMFZ3ZNS5XiJ4fLFN0AtE/6HfOzIrMpWUc8Fhg/+qmf5AJFhs2BsjI1xQgOs
         S3UBEIxf03QpoutBxOgrdO6uYzZowDw5+dRkC95HtpKCaMaJtcBnnhZYmB/NvGrvqkV0
         uQMACXSIs1O4QaNsGrYie8SHEpBIIoYgQjTKP468uD6Narl/6bvHwxsQIb6URQOM5nqH
         v5hfKwpKRMk5r4XNpqL+CMhRzIR0ZGolcyv0vNUKxGuNcQ8meQfmpMX78RIzPaLieRAB
         ZF8A==
X-Gm-Message-State: AOAM5319tNchlbNkcdq9+0zfQePFwAiEmUnzyfTjZVmMnboyWRDeDO2R
        ELu0rEwZJUN+tlTz22RPam8h8vgMKXX5Iw==
X-Google-Smtp-Source: ABdhPJwEx8K2nBJam5PzEaCRjHbdokQrFW8yhQuhwwD2yzjx1fHT5E4IzG/zJp8W+PCj2IQgjapvhw==
X-Received: by 2002:a62:2c48:: with SMTP id s69mr19348795pfs.63.1596533982563;
        Tue, 04 Aug 2020 02:39:42 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id f3sm3514155pfj.206.2020.08.04.02.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 02:39:41 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Bluetooth: Initialize the TX queue lock when creating struct l2cap_chan in 6LOWPAN
Date:   Tue,  4 Aug 2020 17:39:37 +0800
Message-Id: <20200804093937.772961-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When L2CAP channel is destroyed by hci_unregister_dev, it will
acquire the spin lock of the (struct l2cap_chan *)->tx_q list to
delete all the buffers. But sometimes when hci_unregister_dev is
being called, this lock may have not bee initialized. Initialize
the TX queue lock when creating struct l2cap_chan in 6LOWPAN to fix
this problem.

Reported-by: syzbot+fadfba6a911f6bf71842@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=fadfba6a911f6bf71842
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index bb55d92691b0..713c618a73df 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -651,6 +651,7 @@ static struct l2cap_chan *chan_create(void)
 
 	l2cap_chan_set_defaults(chan);
 
+	skb_queue_head_init(&chan->tx_q);
 	chan->chan_type = L2CAP_CHAN_CONN_ORIENTED;
 	chan->mode = L2CAP_MODE_LE_FLOWCTL;
 	chan->imtu = 1280;
-- 
2.27.0

