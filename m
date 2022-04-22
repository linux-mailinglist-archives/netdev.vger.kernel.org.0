Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E6250B40C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446014AbiDVJbs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Apr 2022 05:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiDVJbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:31:47 -0400
X-Greylist: delayed 518 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Apr 2022 02:28:54 PDT
Received: from mail.holtmann.org (coyote.holtmann.net [212.227.132.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7292A506D3;
        Fri, 22 Apr 2022 02:28:54 -0700 (PDT)
Received: from smtpclient.apple (p4fefc32f.dip0.t-ipconnect.de [79.239.195.47])
        by mail.holtmann.org (Postfix) with ESMTPSA id 25550CECD5;
        Fri, 22 Apr 2022 11:20:15 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [RFC PATCH] Bluetooth: core: Allow bind HCI socket user channel
 when HCI is UP.
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20220412120945.28862-1-vasyl.vavrychuk@opensynergy.com>
Date:   Fri, 22 Apr 2022 11:20:14 +0200
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        BlueZ <linux-bluetooth@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <9EA1D51C-D316-49CF-A7F8-765C58C18880@holtmann.org>
References: <20220412120945.28862-1-vasyl.vavrychuk@opensynergy.com>
To:     Vasyl Vavrychuk <vvavrychuk@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vasyl,

> This is needed for user-space to ensure that HCI init scheduled from
> hci_register_dev is completed.
> 
> Function hci_register_dev queues power_on workqueue which will run
> hci_power_on > hci_dev_do_open. Function hci_dev_do_open sets HCI_INIT
> for some time.
> 
> It is not allowed to bind to HCI socket user channel when HCI_INIT is
> set. As result, bind might fail when user-space program is run early
> enough during boot.
> 
> Now, user-space program can first issue HCIDEVUP ioctl to ensure HCI
> init scheduled at hci_register_dev was completed.
> 
> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> ---
> net/bluetooth/hci_sock.c | 4 +---
> 1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
> index 33b3c0ffc339..c98de809f856 100644
> --- a/net/bluetooth/hci_sock.c
> +++ b/net/bluetooth/hci_sock.c
> @@ -1194,9 +1194,7 @@ static int hci_sock_bind(struct socket *sock, struct sockaddr *addr,
> 
> 		if (test_bit(HCI_INIT, &hdev->flags) ||
> 		    hci_dev_test_flag(hdev, HCI_SETUP) ||
> -		    hci_dev_test_flag(hdev, HCI_CONFIG) ||
> -		    (!hci_dev_test_flag(hdev, HCI_AUTO_OFF) &&
> -		     test_bit(HCI_UP, &hdev->flags))) {
> +		    hci_dev_test_flag(hdev, HCI_CONFIG)) {
> 			err = -EBUSY;
> 			hci_dev_put(hdev);
> 			goto done;

I am not following the reasoning here. It is true that the device has to run init before you can do something with it. From mgmt interface your device will only be announced when it is really ready.

Regards

Marcel

