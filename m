Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD103F1C39
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239619AbhHSPIQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Aug 2021 11:08:16 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:34178 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbhHSPIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:08:15 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id 7E93ECED16;
        Thu, 19 Aug 2021 17:07:37 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v3] Bluetooth: Fix return value in hci_dev_do_close()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210817064411.2378-1-l4stpr0gr4m@gmail.com>
Date:   Thu, 19 Aug 2021 17:07:37 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tedd Ho-Jeong An <tedd.an@intel.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C0D6D79E-7325-4A7C-9153-FB35A88DD9CB@holtmann.org>
References: <20210817064411.2378-1-l4stpr0gr4m@gmail.com>
To:     Kangmin Park <l4stpr0gr4m@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kangmin,

> hci_error_reset() return without calling hci_dev_do_open() when
> hci_dev_do_close() return error value which is not 0.
> 
> Also, hci_dev_close() return hci_dev_do_close() function's return
> value.
> 
> But, hci_dev_do_close() return always 0 even if hdev->shutdown
> return error value. So, fix hci_dev_do_close() to save and return
> the return value of the hdev->shutdown when it is called.
> 
> Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
> ---
> net/bluetooth/hci_core.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 8622da2d9395..84afc0d693a8 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1718,6 +1718,7 @@ static void hci_pend_le_actions_clear(struct hci_dev *hdev)
> int hci_dev_do_close(struct hci_dev *hdev)
> {
> 	bool auto_off;
> +	int ret = 0;
> 
> 	BT_DBG("%s %p", hdev->name, hdev);
> 
> @@ -1732,13 +1733,13 @@ int hci_dev_do_close(struct hci_dev *hdev)
> 	    test_bit(HCI_UP, &hdev->flags)) {
> 		/* Execute vendor specific shutdown routine */
> 		if (hdev->shutdown)
> -			hdev->shutdown(hdev);
> +			ret = hdev->shutdown(hdev);
> 	}
> 
> 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
> 		cancel_delayed_work_sync(&hdev->cmd_timer);
> 		hci_req_sync_unlock(hdev);
> -		return 0;
> +		return ret;
> 	}
> 
> 	hci_leds_update_powered(hdev, false);
> @@ -1845,7 +1846,7 @@ int hci_dev_do_close(struct hci_dev *hdev)
> 	hci_req_sync_unlock(hdev);
> 
> 	hci_dev_put(hdev);
> -	return 0;
> +	return ret;
> }

actually use variable name err instead of ret since that is more consistent in this code.

Regards

Marcel

