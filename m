Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D355166D3
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 19:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353602AbiEASBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 14:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350782AbiEASBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 14:01:53 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C582D1C92B;
        Sun,  1 May 2022 10:58:27 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id q14so16098123ljc.12;
        Sun, 01 May 2022 10:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PQ28r/sJ00cyxoRjyUaEhNXcL1dZ/UZxKIjBAZepudc=;
        b=b/zoNI2l8mTLwKYqcCEplXa1OATYN2k/ReqCBkPTqIDDe2pSD081pfREF37Rj8CaQB
         ppUCH7alsbl7FWFR/a+QLX/qhMSdxGGkpOqKWjrUJnIRP6zE1jgDq4pY2lueIYyF6r4m
         AEh6KkEfI9pqSnbLgHT1zlDuatktqxYEYxx2vR0PocsdS8ShgFKqFn0lDkqwhBYj36o7
         TkZan6/KTtR/803oCIb+mJwAbxAB8qn/eSw0kdZJ4ax8xQsxd6agaCZbnuCQ53V4V7If
         OaMM4pNMOx3mPVQ78t6StxevGw1VIEhlEUkBTAaE0e+KVO2KzouS4TbyHQ1soHc6gef8
         WNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PQ28r/sJ00cyxoRjyUaEhNXcL1dZ/UZxKIjBAZepudc=;
        b=1OAc5hcv55JGq21xkxvCHwp4q6gdPdRppx+tL6vsisXhjl5ngIoUwCzIj+RBDTjEnt
         MsF4S+46EEfF4t03WJqZyLYEk9mj9qYTiIxNu4Rr5c0cbIv3xVDW9X4zekaU6Xh+qd1X
         ODfKDh1+yX5rgH5GdjoXGe9GigesPqVeP8kKxsOPKLM+CxCHV1wcstBSuq6R0YIY8MXm
         SWBePGy8M0112Ia6pYIGfcOWeM8Ve9sa145qJvTL9CJ1oJmLdAlMXHi2yGaYdBfzLk2s
         zbRw6tnpHoNCjYY3Nsh/AzIPtQtisip5jMhkF3SYUjjLtXftJem75VH9rO5sI29SH6TD
         liPg==
X-Gm-Message-State: AOAM532g5DnA7JDXfC0SWtgpfVbFYVWw4agGWlw94jRNBYYBGsR3pAkj
        3AiTCUReGIqRNzh1L2X4sV0t0z5uvK8=
X-Google-Smtp-Source: ABdhPJy5w/6APyJiBx8XE6ovZCAKYSReF3Af83vYCYu6cC2wHdtkWCR4rO2oCroQRhro5k7BRa4AxQ==
X-Received: by 2002:a2e:9c0c:0:b0:24e:e2e0:f61e with SMTP id s12-20020a2e9c0c000000b0024ee2e0f61emr6250687lji.75.1651427906037;
        Sun, 01 May 2022 10:58:26 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id u20-20020ac243d4000000b0047255d21143sm494706lfl.114.2022.05.01.10.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 10:58:25 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] usb: cdc-wdm: fix reading stuck on device close
Date:   Sun,  1 May 2022 20:58:28 +0300
Message-Id: <20220501175828.8185-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cdc-wdm tracks whether a response reading request is in-progress and
blocks the next request from being sent until the previous request is
completed. As soon as last user closes the cdc-wdm device file, the
driver cancels any ongoing requests, resets the pending response
counter, but leaves the response reading in-progress flag
(WDM_RESPONDING) untouched.

So if the user closes the device file during the response receive
request is being performed, no more data will be obtained from the
modem. The request will be cancelled, effectively preventing the
WDM_RESPONDING flag from being reseted. Keeping the flag set will
prevent a new response receive request from being sent, permanently
blocking the read path. The read path will staying blocked until the
module will be reloaded or till the modem will be re-attached.

This stuck has been observed with a Huawei E3372 modem attached to an
OpenWrt router and using the comgt utility to set up a network
connection.

Fix this issue by clearing the WDM_RESPONDING flag on the device file
close.

Without this fix, the device reading stuck can be easily reproduced in a
few connection establishing attempts. With this fix, a load test for
modem connection re-establishing worked for several hours without any
issues.

Fixes: 922a5eadd5a3 ("usb: cdc-wdm: Fix race between autosuspend and
reading from the device")
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---

Technically, cdc-wdm belongs to the USB subsystem even though it serves
WWAN devices. I think this fix should be applied (backported) to LTS
versions too. So I targeted it to the 'net' tree, but send it to both
lists to get a feedback. Greg, Jakub, what is the best tree for this
fix?

---
 drivers/usb/class/cdc-wdm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 7f2c83f299d3..eebe782380fb 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -774,6 +774,7 @@ static int wdm_release(struct inode *inode, struct file *file)
 			poison_urbs(desc);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
+			clear_bit(WDM_RESPONDING, &desc->flags);
 			spin_unlock_irq(&desc->iuspin);
 			desc->manage_power(desc->intf, 0);
 			unpoison_urbs(desc);
-- 
2.35.1

