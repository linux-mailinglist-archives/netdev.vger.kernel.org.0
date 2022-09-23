Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686615E72E9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbiIWE0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIWE0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:26:35 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4996011CB17;
        Thu, 22 Sep 2022 21:26:34 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id u28so7593254qku.2;
        Thu, 22 Sep 2022 21:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=834WTL3ucIQJn/oIPARINl5NteoQUlnwL1PFIIOV5EA=;
        b=ekfjtB1RtoCci3VW28eBT3T+4QWDhhXFAww/X7R0mJcINtSKz1jknOEHSOZL6TZtpn
         4YDldzp9p4ncC9UDs0plzFvugtwPyEnkeIETb+4Gb74tPnVZr6st8GDzlmrN/2ijPwGO
         uZU7HbwnCxpizW2JqQG9hd9gewxKkajGxlYGqJIOW145/nULQ3Bt2ITQvs62lnaRSRWp
         GNXFOhJcx0o9WKCIvslsaO9LRwpUDV5Rls7QjdVFhu/AvotuEM2qpE5BW+gSbMwEHOZE
         8UBnAE3YYOhPOAngLTVONuqGq/QrajK0+QaZGiodxx1hpv6GPcI3buJofc6m0YgzDo8F
         kCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=834WTL3ucIQJn/oIPARINl5NteoQUlnwL1PFIIOV5EA=;
        b=2CCP/Hptf9cZXPmq4CKjU78BM9saRo6eJICfcQqlZCOvArRSf3UXpaFCpuhgh97XW/
         Oe8ZgQsjjw2+jOh5Q/Fu7vhDY+2JgCESSIbz1febcoYdfNaEBBKRXsKoAqlXzFgVUC4k
         deYNPgqSPPX40R2V5ri+DzQq3GaoLYqLqOaLYi/Tiqm2bvwn9d5g712Grp3oF6iQ0AWl
         mnfaaZEyZ/zle5XllaMTJ2Y/I9jBhbplNBncg9bglOvbSvAMBJqZmD46WKo54nC/OHaH
         QK+zIvOLFp6fqrWh+4hZjoN/wkq7hDTo90RPm5aG2izDlgYOfXrhLWrUlj8EwZ23zZmZ
         IR5A==
X-Gm-Message-State: ACrzQf2bsikBDrCg62kvy0uxBKckRKz8HU+GUBX5JWpB4uHh2JMGLyho
        MBEQrpGh/1EVBkz0Cxroj+O/mm67sA==
X-Google-Smtp-Source: AMsMyM5J6wfxYVBQtz7ABJTqo1Pp9fqiQJJPKiZ/0Ejjjjd2TurjIgCjOBl0LR8+kKOQIi0iP9JmZA==
X-Received: by 2002:a37:a8ca:0:b0:6cb:c12e:e8fe with SMTP id r193-20020a37a8ca000000b006cbc12ee8femr4374918qke.311.1663907193403;
        Thu, 22 Sep 2022 21:26:33 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id o10-20020ac8698a000000b0035a6f972f84sm4304033qtq.62.2022.09.22.21.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 21:26:32 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net] usbnet: Fix memory leak in usbnet_disconnect()
Date:   Thu, 22 Sep 2022 21:25:51 -0700
Message-Id: <20220923042551.2745-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0000000000004027ca05e8d2ac0a@google.com>
References: <0000000000004027ca05e8d2ac0a@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently usbnet_disconnect() unanchors and frees all deferred URBs
using usb_scuttle_anchored_urbs(), which does not free urb->context,
causing a memory leak as reported by syzbot.

Use a usb_get_from_anchor() while loop instead, similar to what we did
in commit 19cfe912c37b ("Bluetooth: btusb: Fix memory leak in
play_deferred").  Also free urb->sg.

Reported-and-tested-by: syzbot+dcd3e13cf4472f2e0ba1@syzkaller.appspotmail.com
Fixes: 69ee472f2706 ("usbnet & cdc-ether: Autosuspend for online devices")
Fixes: 638c5115a794 ("USBNET: support DMA SG")
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi all,

I think we may have similar issues at other usb_scuttle_anchored_urbs()
call sites.  Since urb->context is (void *), should we pass a "destructor"
callback to usb_scuttle_anchored_urbs(), or replace this function with
usb_get_from_anchor() loops like this patch does?

Please advise, thanks!
Peilin Ye

 drivers/net/usb/usbnet.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index fd399a8ed973..64a9a80b2309 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1598,6 +1598,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	struct usbnet		*dev;
 	struct usb_device	*xdev;
 	struct net_device	*net;
+	struct urb		*urb;
 
 	dev = usb_get_intfdata(intf);
 	usb_set_intfdata(intf, NULL);
@@ -1614,7 +1615,11 @@ void usbnet_disconnect (struct usb_interface *intf)
 	net = dev->net;
 	unregister_netdev (net);
 
-	usb_scuttle_anchored_urbs(&dev->deferred);
+	while ((urb = usb_get_from_anchor(&dev->deferred))) {
+		dev_kfree_skb(urb->context);
+		kfree(urb->sg);
+		usb_free_urb(urb);
+	}
 
 	if (dev->driver_info->unbind)
 		dev->driver_info->unbind(dev, intf);
-- 
2.20.1

