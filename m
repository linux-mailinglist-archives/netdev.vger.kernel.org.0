Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3352AF710
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgKKRAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgKKRAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 12:00:09 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B379C0613D1;
        Wed, 11 Nov 2020 09:00:09 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id f38so1808143pgm.2;
        Wed, 11 Nov 2020 09:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c94lztZhO2eT008D4pkLhU43B72yvq0WPJWvKsO0hew=;
        b=MOh286pQVrJTTVD8HcoPhcqT8q2yYoTL3bit4sDU9Mx5LKGgm5C8Ug8g0J6cNTUac2
         tsuqG1uOT1cVJaLGmgl9TCVBn9lAkM/KOgQS3/MGhJg7aCfJ5Q1kicPjfxOtMzP73kOy
         C69ar9hvwULSb6x6X2ojXTxGVhtRrXKoA4jCbGcFId4odlcU0lSSjOtUBQIM2VUanjlL
         FtkxvSMiY5DThI3jgfnZaVl7jd/sJnnfnsz6z9PGheLKZJse9vdUc/uJAopZ2VaBYjk5
         +Ni8MPJ/tXGN3WLucmZRebzS2Q6ifsk3YQVvbd/lG7mZXTm7MOrg1bQOp1qG6UZ/WLlp
         ltbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c94lztZhO2eT008D4pkLhU43B72yvq0WPJWvKsO0hew=;
        b=CbO7ABR5B/ijLxgv8KYYrm2mYYAAhkS+0XaryWb0URctid45nxVV7AujcwajO+7JEe
         BoYk3P71whzPzXZQiIstYEvsPqRWvO6uKyvIkwOhgoYT4s5O4XYHIN15qfDO4FV+5Qbd
         qm9bqTcIjm6+lSD4lmzn5AeRao08h474svqKfWoDMYgR5aLrcbWHBLeHm5/2TROLP6q9
         +oxrfxhmEW1/v+bLwF+ddPsgRdpWngPDMC+ADNgb7yWAd4qrkMr+kH9YzmIeN8m8DLda
         knRUVVGrmzcdGkwDNROiBYssQJXToHU8Yt4xeIWO7wywoXwi1/EouI2cRyAdVnAgxsdd
         GapA==
X-Gm-Message-State: AOAM532HfTWyHBZebWn+dV9Jl31lFm4eU9N2IRNjubpMYzfWxMznvnXz
        DexoCeUl4i3XSui+rX8lLgs=
X-Google-Smtp-Source: ABdhPJwfkvk/d3fU+yUTkhmcjaJx1E8XyqQCovjkXeem1RMt/jK/7gE1oAMERAynWBom8fmf3hQFlg==
X-Received: by 2002:a62:1d83:0:b029:160:b9b1:470a with SMTP id d125-20020a621d830000b0290160b9b1470amr24129648pfd.32.1605114008894;
        Wed, 11 Nov 2020 09:00:08 -0800 (PST)
Received: from localhost.localdomain ([45.118.167.196])
        by smtp.googlemail.com with ESMTPSA id h5sm3074114pfn.12.2020.11.11.09.00.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 09:00:08 -0800 (PST)
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     saeed@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com, anmol.karan123@gmail.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Subject: [Linux-kernel-mentees] [PATCH v4 net] rose: Fix Null pointer dereference in rose_send_frame()
Date:   Wed, 11 Nov 2020 22:29:54 +0530
Message-Id: <20201111165954.14743-1-anmol.karan123@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201110194518.GA97719@Thinkpad>
References: <20201110194518.GA97719@Thinkpad>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rose_send_frame() dereferences `neigh->dev` when called from
rose_transmit_clear_request(), and the first occurrence of the
`neigh` is in rose_loopback_timer() as `rose_loopback_neigh`,
and it is initialized in rose_add_loopback_neigh() as NULL.
i.e when `rose_loopback_neigh` used in rose_loopback_timer()
its `->dev` was still NULL and rose_loopback_timer() was calling
rose_rx_call_request() without checking for NULL.

- net/rose/rose_link.c
This bug seems to get triggered in this line:

rose_call = (ax25_address *)neigh->dev->dev_addr;

Fix it by adding NULL checking for `rose_loopback_neigh->dev`
in rose_loopback_timer().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Tested-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
---
Changes in v4:
	- Free `dev`(on dev_hold()), when neigh->dev is NULL. (Suggested-by: Jakub Kicinski <kuba@kernel.org>)
Changes in v3:
        - Corrected checkpatch warnings and errors (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
        - Added "Fixes:" tag (Suggested-by: Saeed Mahameed <saeed@kernel.org>)
Changes in v2:
        - Added NULL check in rose_loopback_timer() (Suggested-by: Greg KH <gregkh@linuxfoundation.org>)

 net/rose/rose_loopback.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
index 7b094275ea8b..6a71b6947d92 100644
--- a/net/rose/rose_loopback.c
+++ b/net/rose/rose_loopback.c
@@ -96,10 +96,12 @@ static void rose_loopback_timer(struct timer_list *unused)
 		}

 		if (frametype == ROSE_CALL_REQUEST) {
-			if ((dev = rose_dev_get(dest)) != NULL) {
+			dev = rose_dev_get(dest);
+			if (rose_loopback_neigh->dev && dev) {
 				if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
 					kfree_skb(skb);
 			} else {
+				dev_put(dev);
 				kfree_skb(skb);
 			}
 		} else {
--
2.29.2
