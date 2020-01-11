Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C50A138258
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 17:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgAKQRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 11:17:35 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35719 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730132AbgAKQRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 11:17:35 -0500
Received: by mail-pj1-f68.google.com with SMTP id s7so2342863pjc.0;
        Sat, 11 Jan 2020 08:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3qsxOxyzUIJo5Og0LE2wha3b+zrq9Ey3zvbNrPmhSgU=;
        b=kmHxnnMIsPzGPPrne740ibD3VVsHeNhrALbjeolSo2zcwa/Ul3KR7/D5cW/SLljLpk
         /r6w0vcEzhuq8v6JNtUVz5cIYgP1RsjwYT22fhyHFCFu3Mnzh6BZWqdQ0+elnbNknqNr
         0pS/PY35vk8rcSKhREsTHIg/AKBIgkVetzc6Ug9xxlHwn0ciwotjRFwPSyto7yGhCnXk
         fvB/0F845AhJWlQI+RlspdJ5rd+lgqK76xxt364imICRgIV5dIcPpm/higFhiDwL613J
         05GQNbLbOwzIMfm4VIY9K+l6DtWFtUggBaNhOu9MJA6D37yZxwQYQI17TVygkbIs6MBH
         JK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3qsxOxyzUIJo5Og0LE2wha3b+zrq9Ey3zvbNrPmhSgU=;
        b=Hm/Ebtykf1LsY9Phzjffeox+wZdFUDNTl3VbcXe5wclF4JYwX8OohGGRlKSZ7poHq6
         BRl3UdM70iC7DYC8pWeRJ7fQtky4tZ/3aRDk+imudfomvK5H5EywEGjdL2uOp5Es4LxC
         UwJmkmMfJLgHLprTrFOWDPFwtmOQ4zKEgxjMsTXTYdtVTyPFe5HYiR7O5+MLHakoii1+
         Cx3j+4Apzd+D18rQcDPV3RNo5u3QrbKR4V4QFw/GB+t147qwL+4Dz2LTl4mlwFjVyOnB
         /MAOm8QHPv46w7Ed2RpM7ArSl0zAfRksZX5gOsWLl7Tju2kgwKfiG/ooI//czcARhmdt
         9WbQ==
X-Gm-Message-State: APjAAAWx+4HXFBeuaUqDy6EgmpQHocsiUdeWZIoVpOIZivxFaLzrD2Nl
        7Mgu7b7JS9q9gyDyDudb6fU=
X-Google-Smtp-Source: APXvYqyhd7ku4jAYhfVHIzjTZ5bnm6nlWCK35xbkdmXy/0bTa0aKjf/6lg7Vcsn5OusKiXIvxznxyQ==
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr11261502pls.92.1578759454360;
        Sat, 11 Jan 2020 08:17:34 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.172])
        by smtp.gmail.com with ESMTPSA id j17sm7346835pfa.28.2020.01.11.08.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jan 2020 08:17:33 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, allison@lohutok.net,
        saurav.girepunje@gmail.com, tglx@linutronix.de, will@kernel.org
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] b43: Fix possible a data race in b43_op_tx()
Date:   Sun, 12 Jan 2020 00:14:55 +0800
Message-Id: <20200111161455.26587-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions b43_op_tx() and b43_tx_work() may be concurrently executed.

In b43_tx_work(), the variable wl->tx_queue_stopped[queue_num] is
accessed with holding a mutex lock wl->mutex. But in b43_op_tx(), the
identical variable wl->tx_queue_stopped[skb->queue_mapping] is accessed
without holding this mutex lock. Thus, a possible data race may occur.

To fix this data race, in b43_op_tx(), the variable 
wl->tx_queue_stopped[skb->queue_mapping] is accessed with holding the 
mutex lock wl->mutex.

This data race is found by the runtime testing of our tool DILP-2.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/broadcom/b43/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 39da1a4c30ac..adedb38f50f2 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -3625,6 +3625,11 @@ static void b43_op_tx(struct ieee80211_hw *hw,
 		      struct sk_buff *skb)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
+	bool stopped;
+
+	mutex_lock(&wl->mutex);
+	stopped = wl->tx_queue_stopped[skb->queue_mapping];
+	mutex_unlock(&wl->mutex);
 
 	if (unlikely(skb->len < 2 + 2 + 6)) {
 		/* Too short, this can't be a valid frame. */
@@ -3634,7 +3639,7 @@ static void b43_op_tx(struct ieee80211_hw *hw,
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 
 	skb_queue_tail(&wl->tx_queue[skb->queue_mapping], skb);
-	if (!wl->tx_queue_stopped[skb->queue_mapping]) {
+	if (!stopped) {
 		ieee80211_queue_work(wl->hw, &wl->tx_work);
 	} else {
 		ieee80211_stop_queue(wl->hw, skb->queue_mapping);
-- 
2.17.1

