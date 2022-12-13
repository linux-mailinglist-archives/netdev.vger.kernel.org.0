Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A8464BB3B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 18:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiLMRlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 12:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236121AbiLMRlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 12:41:07 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD0223380;
        Tue, 13 Dec 2022 09:41:05 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id z26so6113276lfu.8;
        Tue, 13 Dec 2022 09:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MHaXp0mzcSuAY+PnbsFakfY5htA6vqOLH6b5U9mLwcc=;
        b=eFJhfcBGzq8f6RGA6enz6RIwE8LfAwfADKdybqzk3CgbVYrvl01QdNWjemVZFcsE7M
         Y/MJUMX2XhFpU7lLjKx0tC+jeHa8+tQeR8GWsJ3mtZZKVjMeyk3TH3tADN6UgTeIE/re
         QnmiPbdtsP1jbBxzA6pza7vA93pzFGjZYTaEvUROCTUm2TW0+pG79wWrH/0qH7LOaebY
         uSCQvRVBUPzUdaqUzxfxodQmvWVNt587TVsZ6UPV9AVrnhlIhmPrrs+yvm8CdGDuL1Sq
         ddlWo1l4pv55OczEgyhluKwjJPXNMoT5Dk/Mho9Y4m8A4FywmYEO7/g/LwaF2iiToVlP
         lsXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MHaXp0mzcSuAY+PnbsFakfY5htA6vqOLH6b5U9mLwcc=;
        b=Q85q7rqS38xpFIS4mZdHClilcF5XgJ+2NtvoikWSw2oCLWp1vuZoGzclHnK3znZ7gg
         geONnOAhx1Cctji2Tnc/AorY//X9lI5JGz8ZnmG21Z367zYQhS2qqnNj3NVBWtX5U08f
         nfmHczANFyGQzcu/ARMlXsxYAspOTscMSAS8J/8rrsdl2kb6hIyztUb282TUuNVpZiH9
         M6GDkrHh+GBFZvKEK7Ln/rW7CYxwD/tCRG6uyTMzkMTqKtaZ0hTD7lBpNKF4ydL7/k+4
         EK0jv9sIr8RrKCJVfN78gT4+TGwzfAFWkRTzHN2y8zg9LGO9b31WAcK24CMVp6fVucEo
         qUGg==
X-Gm-Message-State: ANoB5plD4lovsuFwjw3+6/qIQfuf0+9QSku0pzEPShI90AXTRrAVl5zF
        7pW2HNlm+qqcE8m4GsxY+SxlMOPtbNFDiej+MQ==
X-Google-Smtp-Source: AA0mqf4Bt4AkLkOAt1FeVPZCQFKvprAuuHSRUV1xyeyvcISgkqdJKoJJX2eNqY43NDlO2hMXPYDO7QYCCAK7cna+Zfk=
X-Received: by 2002:a05:6512:3907:b0:4aa:cd5c:4c52 with SMTP id
 a7-20020a056512390700b004aacd5c4c52mr26090068lfu.374.1670953263883; Tue, 13
 Dec 2022 09:41:03 -0800 (PST)
MIME-Version: 1.0
From:   "Seija K." <doremylover123@gmail.com>
Date:   Tue, 13 Dec 2022 12:40:52 -0500
Message-ID: <CAA42iKxeinZ4gKfttg_K8PdRt+p-p=KjqgcbGjtxzOqn_C0F9g@mail.gmail.com>
Subject: [PATCH] net: Fix for packets being rejected in the xHCI controller's
 ring buffer
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a packet larger than MTU arrives in Linux from the modem, it is
discarded with -EOVERFLOW error (Babble error).

This is seen on USB3.0 and USB2.0 buses.

This is because the MRU (Max Receive Size) is not a separate entity
from the MTU (Max Transmit Size), and the received packets can be
larger than those transmitted.

Following the babble error, there was an endless supply of zero-length
URBs that were rejected with -EPROTO (increasing the rx input error
counter each time).

This is only seen on USB3.0. These continue to come ad infinitum until
the modem is shut down.

There appears to be a bug in the core USB handling code in Linux that
doesn't deal with network MTUs smaller than 1500 bytes well.

By default, the dev->hard_mtu (the real MTU) is in lockstep with
dev->rx_urb_size (essentially an MRU), and the latter is causing
trouble.

This has nothing to do with the modems; the issue can be reproduced by
getting a USB-Ethernet dongle, setting the MTU to 1430, and pinging
with size greater than 1406.

Signed-off-by: Seija Kijin <doremylover123@gmail.com>

Co-Authored-By: TarAldarion <gildeap@tcd.ie>
---
drivers/net/usb/qmi_wwan.c | 7 +++++++
1 file changed, 7 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 554d4e2a84a4..39db53a74b5a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -842,6 +842,13 @@ static int qmi_wwan_bind(struct usbnet *dev,
struct usb_interface *intf)
}
dev->net->netdev_ops = &qmi_wwan_netdev_ops;
dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
+ /* LTE Networks don't always respect their own MTU on the receiving side;
+ * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
+ * far-end networks. Make the receive buffer large enough to accommodate
+ * them, and add four bytes so MTU does not equal MRU on network
+ * with 1500 MTU. Otherwise, usbnet_change_mtu() will change both.
+ */
+ dev->rx_urb_size = ETH_DATA_LEN + 4;
err:
return status;
}
-- 
2.38.2
