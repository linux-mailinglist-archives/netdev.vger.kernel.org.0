Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30F7305173
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbhA0EbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231416AbhA0C7m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 21:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19E45206B7;
        Wed, 27 Jan 2021 02:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611713961;
        bh=Dgt6Q0rBvjMRRWLM/57Hr4zqt72CAGa7/vrh66YG02Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oCm2tbCF0sZf49aKB54AiY4czMFP6Ggjs1arltwmSS739Z+ok0umdzB9HRqFhpX5T
         uD6fX4qWcHP+VOjfqU9XoOqLG7/0e2J62Eqil0jbvaGlscmNzs3C6Yls8lH38c695K
         oAnVtRZR/C0RAPzKEbqI+CJEvh6RhwTWImMD9GpgHCuBoO2e9qYNiBrZhKBQxkV2T1
         JBEbK++OWv+e3l/HLi73A04MJ81v4gNx/tN7odKzfKiq84zKCSO4ROJaK4t5q0gSXT
         VSnGwylJq0jCR4z0dWR6TRQyMoV5scg3C1TxyUm3wLo+OJquH09qrfc20MRl2KNT3T
         rJXlkhn69ca0w==
Date:   Tue, 26 Jan 2021 18:19:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     liaichun <liaichun@huawei.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] bonding: fix send_peer_notif data truncation
Message-ID: <20210126181920.403dfc6a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e27dd20165a14d99bc2b406061e60bcd@huawei.com>
References: <e27dd20165a14d99bc2b406061e60bcd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jan 2021 11:52:01 +0000 liaichun wrote:
> send_peer_notif is u8, the value of this parameter is obtained from u8*int, the data may be truncated.
>  And in practice, more than u8(256)  characters are used.

New line before Fixes

> Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
> 

no new line after Fixes

> Signed-off-by: Aichun Li <liaichun@huawei.com>

Please CC these folks on v2:

BONDING DRIVER
M:	Jay Vosburgh <j.vosburgh@gmail.com>
M:	Veaceslav Falico <vfalico@gmail.com>
M:	Andy Gospodarek <andy@greyhouse.net>

> diff --git a/include/net/bonding.h b/include/net/bonding.h index 0960d9af7b8e..65394566d556 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -215,7 +215,7 @@ struct bonding {
>  	 */
>  	spinlock_t mode_lock;
>  	spinlock_t stats_lock;
> -	u8	 send_peer_notif;
> +	u64	 send_peer_notif;
>  	u8       igmp_retrans;
>  #ifdef CONFIG_PROC_FS
>  	struct   proc_dir_entry *proc_entry;

This breaks 32bit builds, as the value is used in divisions.

Please fix and resend.
