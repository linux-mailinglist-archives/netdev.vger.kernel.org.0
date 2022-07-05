Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034575676AB
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbiGESjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbiGESjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:39:15 -0400
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F721EEEF
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 11:39:02 -0700 (PDT)
Received: (wp-smtpd smtp.tlen.pl 8985 invoked from network); 5 Jul 2022 20:38:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1657046338; bh=WWwtFu5inTGYYHR/P6xpZs+1V1TpiM1KVqGs6QWQJP4=;
          h=Subject:To:Cc:From;
          b=r0ig7VGT6CmM+AW0kQSIPZOUUY77GPXcRzY9cQdeZwaExr8ASpSw++z4W5Unf3viy
           CLf5mkqTzrRMI38RuY14xKAhN68AZj60y1VKq9h0U00kTHtEGbtc9HBP8iPtJ20BPr
           9QjNzQh3HO288IrQ18p9/CLeXcx69+NezqM3jLl0=
Received: from aafi210.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.138.210])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <vasyl.vavrychuk@opensynergy.com>; 5 Jul 2022 20:38:58 +0200
Message-ID: <494b21fb-896e-5c80-ff53-b5f914663736@o2.pl>
Date:   Tue, 5 Jul 2022 20:38:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH] Bluetooth: core: Fix deadlock due to
 `cancel_work_sync(&hdev->power_on)` from hci_power_on_sync.
Content-Language: en-GB
To:     Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Max Krummenacher <max.oss.09@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        max.krummenacher@toradex.com
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220614181706.26513-1-max.oss.09@gmail.com>
 <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
In-Reply-To: <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: ea507a630c026762668487bc76baf600
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000A [IRNk]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 5.07.2022 o 14:59, Vasyl Vavrychuk pisze:
> `cancel_work_sync(&hdev->power_on)` was moved to hci_dev_close_sync in
> commit [1] to ensure that power_on work is canceled after HCI interface
> down.
>
> But, in certain cases power_on work function may call hci_dev_close_sync
> itself: hci_power_on -> hci_dev_do_close -> hci_dev_close_sync ->
> cancel_work_sync(&hdev->power_on), causing deadlock. In particular, this
> happens when device is rfkilled on boot. To avoid deadlock, move
> power_on work canceling out of hci_dev_do_close/hci_dev_close_sync.
>
> Deadlock introduced by commit [1] was reported in [2,3] as broken
> suspend. Suspend did not work because `hdev->req_lock` held as result of
> `power_on` work deadlock. In fact, other BT features were not working.
> It was not observed when testing [1] since it was verified without
> rfkill in place.
>
> NOTE: It is not needed to cancel power_on work from other places where
> hci_dev_do_close/hci_dev_close_sync is called in case:
> * Requests were serialized due to `hdev->req_workqueue`. The power_on
> work is first in that workqueue.
> * hci_rfkill_set_block which won't close device anyway until HCI_SETUP
> is on.
> * hci_sock_release which runs after hci_sock_bind which ensures
> HCI_SETUP was cleared.
>
> As result, behaviour is the same as in pre-dd06ed7 commit, except
> power_on work cancel added to hci_dev_close.
>
> [1]: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
> [2]: https://lore.kernel.org/lkml/20220614181706.26513-1-max.oss.09@gmail.com/
> [2]: https://lore.kernel.org/lkml/1236061d-95dd-c3ad-a38f-2dae7aae51ef@o2.pl/
>
> Fixes: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> Reported-by: Max Krummenacher <max.krummenacher@toradex.com>
> Reported-by: Mateusz Jonczyk <mat.jonczyk@o2.pl>

Works well: suspend (with bluetooth on and also off), hibernation, sending files, rfkill.

Thank you.

Reported-and-tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>

Greetings,

Mateusz Jończyk

