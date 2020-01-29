Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEFE114C54D
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 05:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgA2Emq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 Jan 2020 23:42:46 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:33780 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgA2Emq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 23:42:46 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 2ADDDCEC82;
        Wed, 29 Jan 2020 05:52:04 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [RFC PATCH v2 1/4] Bluetooth: Add mgmt op set_wake_capable
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200127175842.RFC.v2.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
Date:   Wed, 29 Jan 2020 05:42:43 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8C3B4FA7-3A59-4E0C-B609-B6278470F46E@holtmann.org>
References: <20200128015848.226966-1-abhishekpandit@chromium.org>
 <20200127175842.RFC.v2.1.I797e2f4cb824299043e771f3ab9cef86ee09f4db@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek.

> When the system is suspended, only some connected Bluetooth devices
> cause user input that should wake the system (mostly HID devices). Add
> a list to keep track of devices that can wake the system and add
> a management API to let userspace tell the kernel whether a device is
> wake capable or not.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v2: None
> 
> include/net/bluetooth/hci_core.h |  1 +
> include/net/bluetooth/mgmt.h     |  7 ++++++
> net/bluetooth/hci_core.c         |  1 +
> net/bluetooth/mgmt.c             | 40 ++++++++++++++++++++++++++++++++
> 4 files changed, 49 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index 89ecf0a80aa1..ce4bebcb0265 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -394,6 +394,7 @@ struct hci_dev {
> 	struct list_head	mgmt_pending;
> 	struct list_head	blacklist;
> 	struct list_head	whitelist;
> +	struct list_head	wakeable;

I have the feeling that using a separate list is making this more complicated for us than it needs to be. I think in parts this comes through the fact that BR/EDR devices are handled via the whitelist list and for LE devices we are using the conn params “framework”.

So maybe it is actually better to store in wakeable list just the BR/EDR devices. And ensure that wakeable is a subset of the whitelist list. And for LE we store it in the conn params lists.

At some point, I think we need to merge whitelist and wakeable list for BR/EDR into a proper structure that can hold this information and maybe also revamp the inquiry cache we are using.

I will comment on the rest when I go through the LE whitelist update patch (and yes, I realize or variable whitelist for BR/EDR is confusing).

Regards

Marcel

