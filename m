Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAC253BB8C
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiFBP3P convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 2 Jun 2022 11:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiFBP3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:29:13 -0400
X-Greylist: delayed 267 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Jun 2022 08:29:11 PDT
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA30F13C1F6;
        Thu,  2 Jun 2022 08:29:09 -0700 (PDT)
Received: from smtpclient.apple (p4ff9fc30.dip0.t-ipconnect.de [79.249.252.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id 31877CED1B;
        Thu,  2 Jun 2022 17:29:08 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] Bluetooth: Collect kcov coverage from hci_rx_work
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220517094532.2729049-1-poprdi@google.com>
Date:   Thu, 2 Jun 2022 17:29:07 +0200
Cc:     theflow@google.com, Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <16B0E861-298D-4038-A38E-E41C3046EE9C@holtmann.org>
References: <20220517094532.2729049-1-poprdi@google.com>
To:     Tamas Koczka <poprdi@google.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tamas,

> Annotate hci_rx_work() with kcov_remote_start() and kcov_remote_stop()
> calls, so remote KCOV coverage is collected while processing the rx_q
> queue which is the main incoming Bluetooth packet queue.
> 
> Coverage is associated with the thread which created the packet skb.
> 
> Signed-off-by: Tamas Koczka <poprdi@google.com>
> ---
> net/bluetooth/hci_core.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 45c2dd2e1590..703722031b8d 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -29,6 +29,7 @@
> #include <linux/rfkill.h>
> #include <linux/debugfs.h>
> #include <linux/crypto.h>
> +#include <linux/kcov.h>
> #include <linux/property.h>
> #include <linux/suspend.h>
> #include <linux/wait.h>
> @@ -3780,7 +3781,9 @@ static void hci_rx_work(struct work_struct *work)
> 
> 	BT_DBG("%s", hdev->name);
> 
> -	while ((skb = skb_dequeue(&hdev->rx_q))) {
> +	for (; (skb = skb_dequeue(&hdev->rx_q)); kcov_remote_stop()) {
> +		kcov_remote_start_common(skb_get_kcov_handle(skb));
> +
> 		/* Send copy to monitor */
> 		hci_send_to_monitor(hdev, skb);

patch looks good, but do you mind adding a comment above on why this is done. I asked, because next time around I look at this code I have forgotten all about it. Thanks.

Regards

Marcel

