Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D79053BCBF
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbiFBQrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237186AbiFBQrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:47:00 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A842E002
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:46:57 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x21-20020a056a000bd500b005188ce4a068so2988607pfu.17
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 09:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TgjRCVHJNyPNYzKikXPzFw2J/LU8nswSlEqjqarztV8=;
        b=PE7MPc6cmH5MazFKJTU+COMQ9TpQO8bw53oBPGsv3J0JGY0JiPeVug3nPNJ8fxDUKc
         balqCApa63MPAan6oUedg99QMOIc+HXYQhUj4Z6rE4a+1yj97Sat3ODWaq57C38NGKts
         fh0RYdelZCoubs8Fv+tqDmQZYr1wHmUnZXD8FxWCX1nojhI/BqjFyuWbYeLgZ1c/AR7a
         2Pg2gPfuIUH4fT2HOVFTNRRpB4nxKpsaCwyVtSqxWjmc2reoRap34iug3g1/1WEVChLz
         +OkMJIpoyPHEJ9wwD/nCExZBk+Rn233e6atK8AC5OBfC3aBSXLSTa618BcD7g8hD2R7/
         FN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TgjRCVHJNyPNYzKikXPzFw2J/LU8nswSlEqjqarztV8=;
        b=dNi3fWv8EnAqaR/iWr++zB9cdVdi1RjkgTUsL2UyYJaaVckKV3tRVrHD6D2E4TzJcm
         f2/S7ioVGuRCEgZkzcqC4A3D8XhuypwPSoNPd+Ji6rZRjBcAWHfCxxWm1Y9GLUJzspIO
         ORvHOs4dvNwlNNuM28eBupHaZngRIBuTLNCPIH3lcivC+ygKDj1RXwyaSxPjUgN668k9
         BQbMpyXNs8hRshcTOIx5WsOSUBToM3b5ff46BDmc/YWdblIRm5/ArxNtjntnuyFdTA4/
         NOIomybzwOXsUapMbkPITtlK0XBf1T6GjU++a2+3uM5d0fnWPa3gHT6ovNrhv3J8KHty
         zwQQ==
X-Gm-Message-State: AOAM530xfcoHP9gaIgRGl5VXKU1RBze+hPlAmG0ix4siDtq5V5uazKnh
        N3Aajt0Gulq0Xig+um2Uudn7ykane3vxS8Oroobk/w==
X-Google-Smtp-Source: ABdhPJwacuZRb8TtwzjrWrpHRc700EOrULP+CuhSgAaVQ1fhLQhxxLOKLbFjI1xMAfdXsmmnG01hsPQBEOAhOT56PZlHsg==
X-Received: from abps.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:9b4])
 (user=abhishekpandit job=sendgmr) by 2002:a62:d40c:0:b0:51b:bc02:703b with
 SMTP id a12-20020a62d40c000000b0051bbc02703bmr5866640pfh.65.1654188416434;
 Thu, 02 Jun 2022 09:46:56 -0700 (PDT)
Date:   Thu,  2 Jun 2022 09:46:49 -0700
Message-Id: <20220602094645.1.I7d191480c15b45a237b927e26aa26ba806409efb@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 1/2] Bluetooth: Fix index added after unregister
From:   Abhishek Pandit-Subedi <abhishekpandit@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

When a userchannel socket is released, we should check whether the hdev
is already unregistered before sending out an IndexAdded.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
This happened when the firmware crashed or the controller was lost for
some other reason.

For testing, I emualated this using:
echo 0 > $(readlink -f /sys/class/bluetooth/hci0)/../../authorized

   = Close Index: F8:E4:E3:D9:9E:45                     [hci0] 682.178794
    @ MGMT Event: Index Removed (0x0005) plen 0 {0x0002} [hci0] 682.178809
    @ MGMT Event: Index Removed (0x0005) plen 0 {0x0001} [hci0] 682.178809
    = Delete Index: F8:E4:E3:D9:9E:45                    [hci0] 682.178821
    @ USER Close: bt_stack_manage               {0x0003} [hci0] 682.397653
    @ MGMT Event: Index Added (0x0004) plen 0   {0x0002} [hci0] 682.397667
    @ MGMT Event: Index Added (0x0004) plen 0   {0x0001} [hci0] 682.397667
    @ MGMT Close: bt_stack_manage               {0x0002} 682.397793
    @ MGMT Open: bt_stack_manage (privileged) version 1.14     {0x0003} 682.437223
    @ MGMT Command: Read Controller Index List (0x0003) plen 0 {0x0003} 682.437230
    @ MGMT Event: Command Complete (0x0001) plen 5             {0x0003} 682.437232
          Read Controller Index List (0x0003) plen 2
            Status: Success (0x00)
            Controllers: 0

Tested on ChromeOS kernel and compiled with allmodconfig on
bluetooth-next.

 net/bluetooth/hci_sock.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 189e3115c8c6..bd8358b44aa4 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -869,7 +869,8 @@ static int hci_sock_release(struct socket *sock)
 
 	hdev = hci_pi(sk)->hdev;
 	if (hdev) {
-		if (hci_pi(sk)->channel == HCI_CHANNEL_USER) {
+		if (hci_pi(sk)->channel == HCI_CHANNEL_USER &&
+		    !hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
 			/* When releasing a user channel exclusive access,
 			 * call hci_dev_do_close directly instead of calling
 			 * hci_dev_close to ensure the exclusive access will
@@ -878,6 +879,11 @@ static int hci_sock_release(struct socket *sock)
 			 * The checking of HCI_AUTO_OFF is not needed in this
 			 * case since it will have been cleared already when
 			 * opening the user channel.
+			 *
+			 * Make sure to also check that we haven't already
+			 * unregistered since all the cleanup will have already
+			 * been complete and hdev will get released when we put
+			 * below.
 			 */
 			hci_dev_do_close(hdev);
 			hci_dev_clear_flag(hdev, HCI_USER_CHANNEL);
-- 
2.36.1.255.ge46751e96f-goog

