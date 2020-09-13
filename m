Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E71267E6D
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 09:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgIMHse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 03:48:34 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35942 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgIMHsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 03:48:30 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9362FCECC4;
        Sun, 13 Sep 2020 09:55:24 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [RESEND PATCH] bluetooth: Set ext scan response only when it
 exists
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200911153141.RESEND.1.Ib022565452fde0c02fbcf619950ef868715dd243@changeid>
Date:   Sun, 13 Sep 2020 09:48:28 +0200
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Daniel Winkler <danielwinkler@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <A3FDD177-8552-4BDD-941A-0BD8FF495AFE@holtmann.org>
References: <20200911153141.RESEND.1.Ib022565452fde0c02fbcf619950ef868715dd243@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Only set extended scan response only when it exists. Otherwise, clear
> the scan response data.
> 
> Per the core spec v5.2, Vol 4, Part E, 7.8.55
> 
> If the advertising set is non-scannable and the Host uses this command
> other than to discard existing data, the Controller shall return the
> error code Invalid HCI Command Parameters (0x12).
> 
> On WCN3991, the controller correctly responds with Invalid Parameters
> when this is sent.  That error causes __hci_req_hci_power_on to fail
> with -EINVAL and LE devices can't connect because background scanning
> isn't configured.
> 
> Here is an hci trace of where this issue occurs during power on:
> 
> < HCI Command: LE Set Extended Advertising Parameters (0x08|0x0036) plen 25
>        Handle: 0x00
>        Properties: 0x0010
>          Use legacy advertising PDUs: ADV_NONCONN_IND
>        Min advertising interval: 181.250 msec (0x0122)
>        Max advertising interval: 181.250 msec (0x0122)
>        Channel map: 37, 38, 39 (0x07)
>        Own address type: Random (0x01)
>        Peer address type: Public (0x00)
>        Peer address: 00:00:00:00:00:00 (OUI 00-00-00)
>        Filter policy: Allow Scan Request from Any, Allow Connect...
>        TX power: 127 dbm (0x7f)
>        Primary PHY: LE 1M (0x01)
>        Secondary max skip: 0x00
>        Secondary PHY: LE 1M (0x01)
>        SID: 0x00
>        Scan request notifications: Disabled (0x00)
>> HCI Event: Command Complete (0x0e) plen 5
>      LE Set Extended Advertising Parameters (0x08|0x0036) ncmd 1
>        Status: Success (0x00)
>        TX power (selected): 9 dbm (0x09)
> < HCI Command: LE Set Advertising Set Random Address (0x08|0x0035) plen 7
>        Advertising handle: 0x00
>        Advertising random address: 08:FD:55:ED:22:28 (OUI 08-FD-55)
>> HCI Event: Command Complete (0x0e) plen 4
>      LE Set Advertising Set Random Address (0x08|0x0035) ncmd
>        Status: Success (0x00)
> < HCI Command: LE Set Extended Scan Response Data (0x08|0x0038) plen 35
>        Handle: 0x00
>        Operation: Complete scan response data (0x03)
>        Fragment preference: Minimize fragmentation (0x01)
>        Data length: 0x0d
>        Name (short): Chromebook
>> HCI Event: Command Complete (0x0e) plen 4
>      LE Set Extended Scan Response Data (0x08|0x0038) ncmd 1
>        Status: Invalid HCI Command Parameters (0x12)
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Daniel Winkler <danielwinkler@google.com>
> ---
> 
> net/bluetooth/hci_request.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

