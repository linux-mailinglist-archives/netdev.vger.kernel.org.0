Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B064BAB8
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 18:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbiLMROo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 12:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbiLMROm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 12:14:42 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FA6D11E;
        Tue, 13 Dec 2022 09:14:41 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id 1so6021684lfz.4;
        Tue, 13 Dec 2022 09:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ShqzOYw9CTrQG80APThrcA9ZR189RHfBmK2AcE3YXP8=;
        b=JxA3KmNK35szjBBUByLal17A0FbCxzcqofjBf+uM6nv+XLGYinzDArtPX+8hC8cQpE
         vlxHaAKjqRlzcs6sFkPobj4VwjxIz0tnLJ3oYgC+fOL1AjNYhTxBdQTRTTx+Ab107VJA
         UZ2PzT2RIu/f+GcTJd670CbihwwUyWLYDJQCry2Z1evNCm7l1xKDUfhP3QYq7jmHOB7O
         rThlshfL1xpXbaA2CZGhtXd6w4oIKAu4P2w8CJELyxfjrAXBQgpBh7yiMF/cpYG4MXbG
         TwoKVxk71nkTr4V7H9GlIxEW92XK6FSJylPLsMIIDUzetz4OGOxvtRTxjasWO26WJqx/
         WsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ShqzOYw9CTrQG80APThrcA9ZR189RHfBmK2AcE3YXP8=;
        b=R+6WH1KfEe0mWeztOg/1BIt8brqfXfqXNpZVEXj9jVhz7I3TjU1gQ7U2BEPXkH85VZ
         nABYp0m6U+ZWJKRiaI9fsbm5bj29rx7Z0qzbImlTqwJyGeUzq1POBC7LeRIwp1NTpJ7U
         W4673RvHLxCWeD8mQ4ylV1KpPoKe9LsG7NBLMO1AoEPimySTrYNh00k5jBghD7LJVOBZ
         /M7qCrxT2ogAL8mdBuj8uLwJXny5cM6RiVkuOiYLKQu78UbqEALvzHX/zxMJRiMCcKGQ
         0fShNBJBfyihlbu956j7PuK9dzFTJCvKA0TS9Rbnn1q9VadSJyVq7I+miladqOvvY0T/
         yvwg==
X-Gm-Message-State: ANoB5pnR+jOzJgCVeuQdTTmcYLBLkF2NSWgESpcK9SAQoRVdD7U3XXgv
        C+jS2aaxm8mJYXrW0WgpapBtKjG/JXZxq2Cblw==
X-Google-Smtp-Source: AA0mqf7+TK47LFZIJKhvzbdAU9vOoLQfGZHFr3/k0sb53fqlpg43oLLPILn5kGReDkcHH1K9hwESHKXGuyfl8Y11Z10=
X-Received: by 2002:a05:6512:3b20:b0:4b4:d3aa:8f8c with SMTP id
 f32-20020a0565123b2000b004b4d3aa8f8cmr27004428lfv.94.1670951679752; Tue, 13
 Dec 2022 09:14:39 -0800 (PST)
MIME-Version: 1.0
From:   "Seija K." <doremylover123@gmail.com>
Date:   Tue, 13 Dec 2022 12:14:28 -0500
Message-ID: <CAA42iKz_+MobnyyGi_7vQMwyqmK9=A9w3vWYa8QFVwwUzfrTAw@mail.gmail.com>
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

When a packet larger than MTU arrives in Linux from the modem,
it is discarded with -EOVERFLOW error (Babble error).

This is seen on USB3.0 and USB2.0 buses.

This is because the MRU (Max Receive Size) is not a separate entity
from the MTU (Max Transmit Size),
and the received packets can be larger than those transmitted.

Following the babble error, there was an endless supply of zero-length URBs,
which are rejected with -EPROTO (increasing the rx input error counter
each time).

This is only seen on USB3.0.
These continue to come ad infinitum until the modem is shut down.

There appears to be a bug in the core USB handling code in Linux
that doesn't deal well with network MTUs smaller than 1500 bytes.

By default, the dev->hard_mtu (the real MTU)
is in lockstep with dev->rx_urb_size (essentially an MRU),
and the latter is causing trouble.

This has nothing to do with the modems,
as the issue can be reproduced by getting a USB-Ethernet dongle,
setting the MTU to 1430, and pinging with size greater than 1406.

Signed-off-by: Seija Kijin <doremylover123@gmail.com>
Co-Authored-By: TarAldarion <gildeap@tcd.ie>

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 554d4e2a84a4..39db53a74b5a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -842,6 +842,13 @@ static int qmi_wwan_bind(struct usbnet *dev,
struct usb_interface *intf)
}
dev->net->netdev_ops = &qmi_wwan_netdev_ops;
dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
+ /* LTE Networks don't always respect their own MTU on receive side;
+ * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
+ * far-end network. Make the receive buffer large enough to accommodate
+ * them, and add four bytes so MTU does not equal MRU on network
+ * with 1500 MTU otherwise usbnet_change_mtu() will change both.
+ */
+ dev->rx_urb_size = ETH_DATA_LEN + 4;
err:
return status;
}
