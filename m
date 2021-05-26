Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DFD391B1D
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhEZPH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:07:28 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:41321 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbhEZPH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:07:26 -0400
Received: from smtpclient.apple (p4fefc9d6.dip0.t-ipconnect.de [79.239.201.214])
        by mail.holtmann.org (Postfix) with ESMTPSA id 57059CED1B;
        Wed, 26 May 2021 17:13:46 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] Bluetooth: fix the erroneous flush_work() order
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210525114215.141988-1-gregkh@linuxfoundation.org>
Date:   Wed, 26 May 2021 17:05:50 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linma <linma@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hao Xiong <mart1n@zju.edu.cn>,
        stable <stable@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <87CD8C35-C7D2-4CF7-B9F9-266B3498DB94@holtmann.org>
References: <20210525114215.141988-1-gregkh@linuxfoundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

> From: linma <linma@zju.edu.cn>

this needs a real name, but I could fix that on git am as well.

> 
> In the cleanup routine for failed initialization of HCI device,
> the flush_work(&hdev->rx_work) need to be finished before the
> flush_work(&hdev->cmd_work). Otherwise, the hci_rx_work() can
> possibly invoke new cmd_work and cause a bug, like double free,
> in late processings.
> 
> This was assigned CVE-2021-3564.
> 
> This patch reorder the flush_work() to fix this bug.
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> Cc: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-bluetooth@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> Signed-off-by: Hao Xiong <mart1n@zju.edu.cn>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> net/bluetooth/hci_core.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index fd12f1652bdf..88aa32f44e68 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1610,8 +1610,13 @@ static int hci_dev_do_open(struct hci_dev *hdev)
> 	} else {
> 		/* Init failed, cleanup */
> 		flush_work(&hdev->tx_work);
> -		flush_work(&hdev->cmd_work);
> +		/*
> +		 * Since hci_rx_work() is possible to awake new cmd_work
> +		 * it should be flushed first to avoid unexpected call of
> +		 * hci_cmd_work()
> +		 */

So everything in net/ uses the comment coding style enforced with --strict.

Regards

Marcel

