Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4B32AA7D8
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgKGUNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:13:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGUNR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 15:13:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85B7520885;
        Sat,  7 Nov 2020 20:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604779996;
        bh=PRrCSN/QphS1mxQzbXPEO/rMCZwBHU9ZNIw7eRU3hwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RJvcYgbAdjN4X6TtHtSwgp3VsSczTfMAVxvX3hl+QUmeYJyyUHsEk/TMFreTIknxn
         iwZ28fjpdwRDDijweaCxWWItFBqI868kDuhjFSVDU6KRZVrjCBuqvMKhfPUTC2FQOQ
         gmy7/nJFSGKgM2b70wQTBVVKdQyvKIGB1d26R2JI=
Date:   Sat, 7 Nov 2020 12:13:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] r8169: fix potential skb double free in an error
 path
Message-ID: <20201107121315.4d4068bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f7e68191-acff-9ded-4263-c016428a8762@gmail.com>
References: <f7e68191-acff-9ded-4263-c016428a8762@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 15:28:42 +0100 Heiner Kallweit wrote:
> The caller of rtl8169_tso_csum_v2() frees the skb if false is returned.
> eth_skb_pad() internally frees the skb on error what would result in a
> double free. Therefore use __skb_put_padto() directly and instruct it
> to not free the skb on error.
> 
> Fixes: 25e992a4603c ("r8169: rename r8169.c to r8169_main.c")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> The Fixes tag refers to the change from which on the patch applies.
> However it will apply with a little fuzz only on versions up to 5.9.

I think we've been over this, please provide real fixes tags, pointing
to where bugs were introduced. I swapped the tag for:

Fixes: b423e9ae49d7 ("r8169: fix offloaded tx checksum for small packets.")

and applied, thanks.
