Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4DE2A9ED2
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 22:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgKFVEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 16:04:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbgKFVEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 16:04:30 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B8B2087E;
        Fri,  6 Nov 2020 21:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604696669;
        bh=9ixnt+Fdr/ysIEkQIJWSwlXkjcUJXvNSmNtHjsiEvhE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KFTHiXojtHgyof51PtRWCwBIRcqkJ1S5Phui0j1JLOLZBxMx9HmFYeI/5gMMBWsex
         M1ZDm8to6GsjbAV8O9qJrgK/fj+NIBURT3UjpSq0oIcxcuHEiVF4ikFxFNt3TjXbGh
         E17KJbrxv5tFIDQVMGAUmX9a+ESyjLPd/kFKIWgc=
Message-ID: <b97dc3f0843cc2b7d7674dbd467ad5ba40824ba3.camel@kernel.org>
Subject: Re: [Linux-kernel-mentees] [PATCH v2 net] rose: Fix Null pointer
 dereference in rose_send_frame()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Anmol Karn <anmol.karan123@gmail.com>, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com
Date:   Fri, 06 Nov 2020 13:04:27 -0800
In-Reply-To: <20201105155600.9711-1-anmol.karan123@gmail.com>
References: <20201105155600.9711-1-anmol.karan123@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 21:26 +0530, Anmol Karn wrote:
> rose_send_frame() dereferences `neigh->dev` when called from
> rose_transmit_clear_request(), and the first occurance of the `neigh`
> is in rose_loopback_timer() as `rose_loopback_neigh`, and it is
> initialized
> in rose_add_loopback_neigh() as NULL. i.e when `rose_loopback_neigh`
> used in 
> rose_loopback_timer() its `->dev` was still NULL and
> rose_loopback_timer() 
> was calling rose_rx_call_request() without checking for NULL.
> 
> - net/rose/rose_link.c
> This bug seems to get triggered in this line:
> 
> rose_call = (ax25_address *)neigh->dev->dev_addr;
> 
> Fix it by adding NULL checking for `rose_loopback_neigh->dev` in
> rose_loopback_timer(). 
> 
> Reported-and-tested-by: 
> syzbot+a1c743815982d9496393@syzkaller.appspotmail.com 
> Link: 
> https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3
>  
> Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>

missing proper fixes tag.

> ---
>  net/rose/rose_loopback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
> index 7b094275ea8b..cd7774cb1d07 100644
> --- a/net/rose/rose_loopback.c
> +++ b/net/rose/rose_loopback.c
> @@ -96,7 +96,7 @@ static void rose_loopback_timer(struct timer_list
> *unused)
>  		}
>  
>  		if (frametype == ROSE_CALL_REQUEST) {
> -			if ((dev = rose_dev_get(dest)) != NULL) {
> +			if (rose_loopback_neigh->dev && (dev =
> rose_dev_get(dest)) != NULL) {
>  				if (rose_rx_call_request(skb, dev,
> rose_loopback_neigh, lci_o) == 0)
>  					kfree_skb(skb);
>  			} else {

check patch is not happy:

WARNING:TYPO_SPELLING: 'occurance' may be misspelled - perhaps
'occurrence'?
#7: 
rose_transmit_clear_request(), and the first occurance of the `neigh`

ERROR:ASSIGN_IN_IF: do not use assignment in if condition
#36: FILE: net/rose/rose_loopback.c:99:
+                       if (rose_loopback_neigh->dev && (dev =
rose_dev_get(dest)) != NULL) {

total: 1 errors, 1 warnings, 0 checks, 8 lines checked


