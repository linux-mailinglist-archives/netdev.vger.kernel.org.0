Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B420263C52
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 07:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgIJFHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 01:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgIJFHC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 01:07:02 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4780207EA;
        Thu, 10 Sep 2020 05:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599714421;
        bh=Lbn9xs8qkCiA5rfVxd87HIU11Jf2P/zukvdmNIBKwyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o1BMPBgqOfPecIA0rAE70qWdPtpP8hT+87oOV2DoyELHE4VoyuGG5Vo6u54f5uUfa
         EX1Rk+GohPhVUaTxSJZoreGFkuRW2w9da2ZKQggM6YptawuzWTjNjYCr8ByBTz9DHf
         FQyaSUL31uH7WE9aZ1wQ6HmaKBEO3pKfyjYUJUlg=
Date:   Wed, 9 Sep 2020 22:06:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: bluetooth: Fix null pointer dereference in
 hci_event_packet()
Message-ID: <20200910050659.GD828@sol.localdomain>
References: <20200910043424.19894-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910043424.19894-1-anmol.karan123@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 10:04:24AM +0530, Anmol Karn wrote:
> Prevent hci_phy_link_complete_evt() from dereferencing 'hcon->amp_mgr'
> as NULL. Fix it by adding pointer check for it.
> 
> Reported-and-tested-by: syzbot+0bef568258653cff272f@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=0bef568258653cff272f
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> ---
>  net/bluetooth/hci_event.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 4b7fc430793c..871e16804433 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -4936,6 +4936,11 @@ static void hci_phy_link_complete_evt(struct hci_dev *hdev,
>  		return;
>  	}
>  
> +	if (IS_ERR_OR_NULL(hcon->amp_mgr)) {
> +		hci_dev_unlock(hdev);
> +		return;
> +	}
> +

In patches that fix a NULL pointer dereference, please include a brief
explanation of why the pointer can be NULL, including what it means
semantically; and why the proposed change is the best fix for the problem.

Also, why IS_ERR_OR_NULL()?

- Eric
