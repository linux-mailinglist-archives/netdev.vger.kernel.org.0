Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0662C6D7D
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbgK0XAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgK0W7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 17:59:53 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B7FE22228;
        Fri, 27 Nov 2020 22:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606517992;
        bh=iAMO4Q1K8r3gx4it3rsr3oAHGdjVLjmNlKR8qqpc/10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wRXJaOIK5uu8N7jmlbOvzDOYs83RUCzYdf1RJKaoUa1vyLiwdKvcnhlN13l2f3dUu
         UWiNFZiXymOLzpAvv2z3zK3pAeIs/HrAnypn/ubpA64oBD/j6ZjQbkOhKfiA3jFELV
         YoWrmvRGbzjeUZsJfuR8vgWtx+VNzoxZSL/RGKl4=
Date:   Fri, 27 Nov 2020 14:59:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Runzhe Wang <xia1@linux.alibaba.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC:Fix Warning: Comparison to bool
Message-ID: <20201127145951.703183d0@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1606374942-1570157-1-git-send-email-xia1@linux.alibaba.com>
References: <1606374942-1570157-1-git-send-email-xia1@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 15:15:42 +0800 Runzhe Wang wrote:
> This patch uses the shdlc->rnr variable as a judgment condition of
> statement, rather than compares with bool.
> 
> Signed-off-by: Runzhe Wang <xia1@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>

"Fix Warning" sounds like you're addressing a real compiler warning,
please use a more suitable subject if the warning in question is from
your own tool. Like "nfc: refactor unnecessary comparison to bool".

> diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
> index 0eb4ddc..f178a42 100644
> --- a/net/nfc/hci/llc_shdlc.c
> +++ b/net/nfc/hci/llc_shdlc.c
> @@ -319,7 +319,7 @@ static void llc_shdlc_rcv_s_frame(struct llc_shdlc *shdlc,
>  	switch (s_frame_type) {
>  	case S_FRAME_RR:
>  		llc_shdlc_rcv_ack(shdlc, nr);
> -		if (shdlc->rnr == true) {	/* see SHDLC 10.7.7 */
> +		if (shdlc->rnr) {	/* see SHDLC 10.7.7 */

rnr is a bool, this is perfectly legal, there are also comparisons to
false which you don't fix, and nobody has touched this driver in 8
years so polishing this code is not exactly worth the effort.

I'm not applying this patch, sorry.

>  			shdlc->rnr = false;
>  			if (shdlc->send_q.qlen == 0) {
>  				skb = llc_shdlc_alloc_skb(shdlc, 0);

