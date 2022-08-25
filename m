Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B945A0AFA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239116AbiHYIGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237349AbiHYIGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:06:10 -0400
Received: from mail-ej1-x64a.google.com (mail-ej1-x64a.google.com [IPv6:2a00:1450:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1A3419B8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:06:06 -0700 (PDT)
Received: by mail-ej1-x64a.google.com with SMTP id gs35-20020a1709072d2300b00730e14fd76eso5977851ejc.15
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=VFoAUZmQSNIybQQWm64jI2jatoCnpAOO4OmYIlm443c=;
        b=lzySq90VxMrFPmXh2/dwioCs6B1SegwMh8h1SsTmX7oweHtHklTxf6cwglcV4JsI+q
         VQC5BAJbGLcbZlMbIuVfyPf1a/w9tjTHHFYSXkfTGdb81NG6cFzdicSzVrqWOu4ct5Cr
         tS1OEbijc7gx0NIrKZ+d+6ZzS44EIfPEpJFHNlm3e3/omWOc7eJZzgTW82ei7qHLkqcl
         pnGB9aB8V3x4fcFHTtLFdrGZIW/vqnTzm8ewyDHTe25uVu7KRIs9dhRkJxQmrsSb/1dZ
         N1MaVqAYSovM9cPAzvU/zUeG09EBBO/tkF2xDo7TLbKz9daOtij6z9ao/usZR5B/ZfHj
         TC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=VFoAUZmQSNIybQQWm64jI2jatoCnpAOO4OmYIlm443c=;
        b=xY1yIKDmyg5E8BH82e5wJNhY/wMO0nMRtWMtMHJC7wIs/J5TGxwoZtaLrsGDkduUmy
         3g4cf/Y934kNBpIPNwxGNVx9+Bkm+lES7RIPjwzeSNUBoGdyfa4bXC9MRJO0AldXLTsv
         Cn+WHAFMI5/8sDteo9sZBQsxSYQSoLCj570+y1eT3p4WKeBnuX/tKaF+AX2mV36AP5lu
         hogivElW8CN2Xfn6bMEMRkPlOwyHwHk+G6uavj5YV9muZ/zFUjN/gWGH6RzF3NVXxVpW
         b1S+mxShpEg6JCqNlPNagMbLQbXGpDZQ8og0DK/eg3reGpuPK1x4DOc8otPqFLpvzaJo
         a3sQ==
X-Gm-Message-State: ACgBeo3NNfvM3ko96a6L1BON0K50d2IfNKQDckaKLkXX+RwbtDR4wUNJ
        F0s+8AJKxqTfmqt3+WSlCWvEtpKwW44=
X-Google-Smtp-Source: AA6agR6UVFnHcCE6dkRKJ4LXnHFEmWj1dGMEp2KQOHR3+b1DqMPbPRnGL1Du8uuOqH6LOnmqmBgSyVciqtM=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:9c:201:4984:837b:f1f1:a6a1])
 (user=glider job=sendgmr) by 2002:a05:6402:2756:b0:443:4a6d:f05a with SMTP id
 z22-20020a056402275600b004434a6df05amr2178605edd.396.1661414765037; Thu, 25
 Aug 2022 01:06:05 -0700 (PDT)
Date:   Thu, 25 Aug 2022 10:05:55 +0200
Message-Id: <20220825080555.3643572-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Subject: [PATCH] ath9k: fix an uninit value use in ath9k_htc_rx_msg()
From:   Alexander Potapenko <glider@google.com>
To:     glider@google.com
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath9k_htc_rx_msg() assumes skb->data contains a full
`struct htc_frame_hdr`, thus it needs a call to pskb_may_pull()
to ensure there is enough data.

This fixes a long-standing issue reported by KMSAN:

  BUG: KMSAN: uninit-value in ath9k_htc_rx_msg+0x544/0x980 drivers/net/wireless/ath/ath9k/htc_hst.c:417
   ath9k_htc_rx_msg+0x544/0x980 drivers/net/wireless/ath/ath9k/htc_hst.c:417
   ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:653 [inline]
   ath9k_hif_usb_rx_cb+0x196a/0x1f10 drivers/net/wireless/ath/ath9k/hif_usb.c:686
   __usb_hcd_giveback_urb+0x522/0x740 drivers/usb/core/hcd.c:1670
   usb_hcd_giveback_urb+0x150/0x620 drivers/usb/core/hcd.c:1747
   dummy_timer+0xd3f/0x4f20 drivers/usb/gadget/udc/dummy_hcd.c:1988
   call_timer_fn+0x43/0x480 kernel/time/timer.c:1474
   expire_timers+0x272/0x610 kernel/time/timer.c:1519
   __run_timers+0x5bc/0x8c0 kernel/time/timer.c:1790
  ...

  Uninit was created at:
  ...
   __alloc_skb+0x34a/0xd70 net/core/skbuff.c:426
   __netdev_alloc_skb+0x126/0x780 net/core/skbuff.c:494
   __dev_alloc_skb include/linux/skbuff.h:3264 [inline]
   ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:635 [inline]
   ath9k_hif_usb_rx_cb+0xe7b/0x1f10 drivers/net/wireless/ath/ath9k/hif_usb.c:686
   __usb_hcd_giveback_urb+0x522/0x740 drivers/usb/core/hcd.c:1670
  ...

Reported-by: syzbot+2ca247c2d60c7023de7f@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: Alexander Potapenko <glider@google.com>
---
 drivers/net/wireless/ath/ath9k/htc_hst.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 994ec48b2f669..83a1d2fba2218 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -408,7 +408,8 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 	struct htc_endpoint *endpoint;
 	__be16 *msg_id;
 
-	if (!htc_handle || !skb)
+	if (!htc_handle || !skb ||
+	    !pskb_may_pull(skb, sizeof(struct htc_frame_hdr)))
 		return;
 
 	htc_hdr = (struct htc_frame_hdr *) skb->data;
-- 
2.37.2.672.g94769d06f0-goog

