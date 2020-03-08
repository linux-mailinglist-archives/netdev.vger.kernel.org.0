Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5774817D29A
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 09:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgCHISm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Mar 2020 04:18:42 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:35823 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgCHISm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 04:18:42 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 29982CED15;
        Sun,  8 Mar 2020 09:28:08 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH] bluetooth/rfcomm: fix ODEBUG bug in rfcomm_dev_ioctl
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1583589488-22450-1-git-send-email-hqjagain@gmail.com>
Date:   Sun, 8 Mar 2020 09:18:39 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <449B4F83-8BCD-413C-823B-C7A5554801FB@holtmann.org>
References: <1583589488-22450-1-git-send-email-hqjagain@gmail.com>
To:     Qiujun Huang <hqjagain@gmail.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Qiujun,

> Needn't call 'rfcomm_dlc_put' here, because 'rfcomm_dlc_exists' didn't
> increase dlc->refcnt.
> 
> Reported-by: syzbot+4496e82090657320efc6@syzkaller.appspotmail.com
> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> ---
> net/bluetooth/rfcomm/tty.c | 1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
> index 0c7d31c..ea2a1df0 100644
> --- a/net/bluetooth/rfcomm/tty.c
> +++ b/net/bluetooth/rfcomm/tty.c
> @@ -414,7 +414,6 @@ static int __rfcomm_create_dev(struct sock *sk, void __user *arg)
> 		if (IS_ERR(dlc))
> 			return PTR_ERR(dlc);
> 		else if (dlc) {
> -			rfcomm_dlc_put(dlc);
> 			return -EBUSY;
> 		}
> 		dlc = rfcomm_dlc_alloc(GFP_KERNEL);

Please see the proposed change from Hillf.

It is better to not bother with the else if here since the if statement will already leave the function.

	if (dlc)
		return -EBUSY;

Regards

Marcel

