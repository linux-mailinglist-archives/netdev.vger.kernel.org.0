Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6086612DF
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 21:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfGFT6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 15:58:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39863 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfGFT6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 15:58:08 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so12714568wma.4
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 12:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=b7JNN8cSSBwQae63d+OF2M+PqQpecg3GPYfgJbWD2+E=;
        b=Eusxhw3jkd3KDTAkGe55YNwq5vD3tYLvinmq8Auuy3QGQjd9Vgl5OAdPpl7mBG4rEN
         yYX41dvMqTYcLR6k5tWqDv5GzM8EpC+4lg3FbphTUhfZC9wAYUAYjF2wIRnDoEsRSNv3
         WLCBBLga6YTuLhwQlMMeBE2U/cov86G6cy50lpcDZL7bBPVJko0m7q0LeNgIEFAwIGAl
         d+YSEHibTHmn/SYfSE3XSAFIPe0tA4Ks2QnPWzv9ue1G59AfVyHzlpFKMl170uKR2vJc
         QWnXJNuIAGy+iXq1BGw4BIyJOOzWsDbROFdQGtXr0c6k4v+wlpKrmbzJ4zDuksYHjHoW
         oHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=b7JNN8cSSBwQae63d+OF2M+PqQpecg3GPYfgJbWD2+E=;
        b=QbDEgUignWEgnKAamV+a9JvZ5L6GJzLBwdfX10TE0JK1cyRuCPCjWORYobBoiU72y7
         x7oRw6BPq9CPj7B6wFSU/KO7kfomyBqpWZdfWTLLBQ7kufGbiBWOo9ywNs0oAfkQ1hvJ
         /FWl1Y3WEl6ii3zmBcFUza4obrFPdiT5tPxQ3Trh5h5wyV8Fr7nzwC3X44JnsDwXIAha
         /9dQc0aovEsIFZUvpAcc1/Gd1Nxjkt6nLCtrgXVXRNsDnUp1fUQUX+JBMDlTx1bfTAKj
         N7WvVQxMXBPRtD33ZC4jZ/LLmTTHrs7+NEkYCa/HtcIfaGCKdrSJhe7X9ukgfzBBsdPx
         rVnQ==
X-Gm-Message-State: APjAAAUzghaCrhwrsUZ+WdjFPO7k7sHk+bt5ovbSizLjjgebbiyM2YMR
        P7J9Ww/jRcfsJ6vWR8waQTzsNC40wwpq0fucbwvurYpP
X-Google-Smtp-Source: APXvYqx/wtWFyuVBq+FlF/q497O9goebvqfYYEUpqUTtqxU1j8I83xc7fgkZgTnLcn+fwJhBGqnI3UlB7z1NgM3/Aus=
X-Received: by 2002:a1c:f102:: with SMTP id p2mr8616096wmh.126.1562443085780;
 Sat, 06 Jul 2019 12:58:05 -0700 (PDT)
MIME-Version: 1.0
From:   Ujjal Roy <royujjal@gmail.com>
Date:   Sun, 7 Jul 2019 01:27:54 +0530
Message-ID: <CAE2MWk=X0x_y7q7jejog_iWpd965J8NXs1ffOVV5pjSUVrQ=cg@mail.gmail.com>
Subject: [PATCH] net, skbuff: Handle devmap managed page when skb->head_frag
 is true
To:     Kernel <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When head_frag is true we have page in the SKB head. So, for devm
managed page we need to inform the device driver through callback.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
---
 net/core/skbuff.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c8cd99c3603f..0d303e694efa 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -582,10 +582,16 @@ static void skb_free_head(struct sk_buff *skb)
{
unsigned char *head = skb->head;

- if (skb->head_frag)
+ if (skb->head_frag) {
+ struct page *page = virt_to_head_page(head);
+
+ if (put_devmap_managed_page(page))
+ return;
+
  skb_free_frag(head);
- else
+ } else {
  kfree(head);
+ }
 }

 static void skb_release_data(struct sk_buff *skb)
-- 
2.11.0
