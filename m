Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F207411FADE
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 20:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfLOTyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 14:54:55 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:41283 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfLOTyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 14:54:55 -0500
Received: by mail-pg1-f202.google.com with SMTP id r30so3534427pgm.8
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 11:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1aTXxWUQSHKZxIObfpRrS1Mlca/etyjnnsBSZyl/F1g=;
        b=hDXDe4nBBMOH4dgB6SsUP9GABXWVqM6SCuXsHUjnu73Ox201hTh2Lxg+imuNwbi/bY
         FhXtkr95x0VkxBuy7LkYn8KJJT0ab5X70ApjsnCAVcInP88dNqW5AgA6Ro9XIO+lfSAo
         rVgLFXizVQJYjVghML7yMf6u7aKhX4Cm1ZYB5QpaTkJdK8DDPoF/5iDIWnR93HDUD6mX
         EgratHj7WncFUlQ4YmWAY/oFpzKe286sp30LeXlHBwAxm94Bhldce9HYxiz8WDaI4VpX
         72bomHdVpSK3Z17mNeRxB8izazFGgetPAbJpXKOmty+B7ZqDmuL9lm6Yz/vuu5P4Qsnl
         +vBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1aTXxWUQSHKZxIObfpRrS1Mlca/etyjnnsBSZyl/F1g=;
        b=NTG9+q222U/ptclxw6JpBVXF+7QhFrhRoWL3YYtHqecrsPJQCEpVw2Y1IJpHG8o4iI
         9SQexNkkKL6vA/fE1jTyj+PuP8SfFlFeTIcLt5bLmVydbK5i6HpKUObbdQfdVBrsrgYO
         DFAgKne9dpuNGPRp89LnTxkVZtmLu6w5DL9UWl1AJUqIvv/zNO+oiDnIZ92tUBTgb+Vk
         A+lr5X2FSqIPPUsxbdNMOnW6yDUpZuZhr4g8C2CqGgvZZolM3nH1YjCijtO4wTN/LWs6
         dADB9KlhHmgrvVSj7c9rJ7yEt/OR9Zc//XV1m5qJmuL8rokH2yrGkTGyqHcqb2fk+kvT
         AiUw==
X-Gm-Message-State: APjAAAXXUYODEbXgdzrl4371ew0zmxMQLQDcKS+z0c7XLuayNBlrT8FZ
        LemSO1rV1ZdVzJfJaYd4riE2d/lqV40XEA==
X-Google-Smtp-Source: APXvYqxeQPVdcx+bUXwB/bveIojGbKfcLPXej/iqkpLX71Mwas+ehKjQhOTeHoI88/HEw/23TNBxvQkpKczv6w==
X-Received: by 2002:a63:5203:: with SMTP id g3mr13255529pgb.377.1576439694386;
 Sun, 15 Dec 2019 11:54:54 -0800 (PST)
Date:   Sun, 15 Dec 2019 11:54:51 -0800
Message-Id: <20191215195451.180553-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net-next v2] tcp: Set rcv zerocopy hint correctly if skb last
 frag is < PAGE_SIZE
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

At present, if the last frag of paged data in a skb has < PAGE_SIZE
data, we compute the recv_skip_hint as being equal to the size of that
frag and the entire next skb.

Instead, just return the runt frag size as the hint.

recv_skip_hint is used by the application to skip over
bytes that can not be mmaped, so returning a too big
chunk is pessimistic and forces more bytes to be copied.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
v2: added more info in the changelog (Jakub)

 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 09e2cae929565a438b298ab6c0df3e2c263e7a11..93fe77c5b02d631ce0f0742f107c570a81d139fe 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1778,6 +1778,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	while (length + PAGE_SIZE <= zc->length) {
 		if (zc->recv_skip_hint < PAGE_SIZE) {
 			if (skb) {
+				if (zc->recv_skip_hint > 0)
+					break;
 				skb = skb->next;
 				offset = seq - TCP_SKB_CB(skb)->seq;
 			} else {
-- 
2.24.1.735.g03f4e72817-goog

