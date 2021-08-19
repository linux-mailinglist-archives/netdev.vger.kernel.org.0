Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD8E3F1C2D
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 17:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238681AbhHSPGU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Aug 2021 11:06:20 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:44635 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238292AbhHSPGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 11:06:19 -0400
Received: from smtpclient.apple (p5b3d23f8.dip0.t-ipconnect.de [91.61.35.248])
        by mail.holtmann.org (Postfix) with ESMTPSA id E45AECED16;
        Thu, 19 Aug 2021 17:05:41 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH] Bluetooth: add timeout sanity check to hci_inquiry
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210817103108.1160-1-paskripkin@gmail.com>
Date:   Thu, 19 Aug 2021 17:05:41 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <0038C6D9-DEAF-4CB2-874C-00F6CEFCF26C@holtmann.org>
References: <20210817103108.1160-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

> Syzbot hit "task hung" bug in hci_req_sync(). The problem was in
> unreasonable huge inquiry timeout passed from userspace.
> Fix it by adding sanity check for timeout value and add constant to
> hsi_sock.h to inform userspace, that hci_inquiry_req::length field has
> maximum possible value.
> 
> Since hci_inquiry() is the only user of hci_req_sync() with user
> controlled timeout value, it makes sense to check timeout value in
> hci_inquiry() and don't touch hci_req_sync().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-and-tested-by: syzbot+be2baed593ea56c6a84c@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Hi, Bluetooth maintainers/reviewers!
> 
> I believe, 60 seconds will be more than enough for inquiry request. I've
> searched for examples on the internet and maximum ir.length I found was 
> 8. Maybe, we have users, which need more than 60 seconds... I look forward
> to receiving your views on this value.
> 
> ---
> include/net/bluetooth/hci_sock.h | 1 +
> net/bluetooth/hci_core.c         | 5 +++++
> 2 files changed, 6 insertions(+)
> 
> diff --git a/include/net/bluetooth/hci_sock.h b/include/net/bluetooth/hci_sock.h
> index 9949870f7d78..1cd63d4da00b 100644
> --- a/include/net/bluetooth/hci_sock.h
> +++ b/include/net/bluetooth/hci_sock.h
> @@ -168,6 +168,7 @@ struct hci_inquiry_req {
> 	__u16 dev_id;
> 	__u16 flags;
> 	__u8  lap[3];
> +#define HCI_INQUIRY_MAX_TIMEOUT		30
> 	__u8  length;
> 	__u8  num_rsp;
> };
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index e1a545c8a69f..104babf67351 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -1343,6 +1343,11 @@ int hci_inquiry(void __user *arg)
> 		goto done;
> 	}
> 

	/* Restrict maximum inquiry length to 60 seconds */
	if (ir.length > 60) {
		..
	}

> +	if (ir.length > HCI_INQUIRY_MAX_TIMEOUT) {
> +		err = -EINVAL;
> +		goto done;
> +	}
> +

I found this easier to read than adding anything define somewhere else. And since this is a legacy interface that is no longer used by bluetoothd, this should be fine. We will start to deprecate this eventually.

And I prefer 1 minute max time here. Just to be safe.

Regards

Marcel

