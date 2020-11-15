Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A62B31B2
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 01:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgKOAyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 19:54:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgKOAyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 19:54:40 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A36324137;
        Sun, 15 Nov 2020 00:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605401680;
        bh=BzNPY5ArKKzdVkAmLBXa/GcHAqXCwExVC3u5T2aNl+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SG/vLb7EKBTgUmJCOLNtq+x349261N7VF6+Nfb1kLGnWyg8eN/SWJrjqVh9HlbpjG
         9umGGrBP+s1BTW2moeW1bPIIYSee64DaHPfKjOOnc8Ico6AI1VWbLJGDZBxSRPvsqu
         TzZUThCC5b/JxDIDhqofAhYHCkfF+Li7pumnpvSw=
Date:   Sat, 14 Nov 2020 16:54:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Shi <alex.shi@linux.alibaba.com>
Cc:     linux-nfc@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net/nfc/nic: refined function nci_hci_resp_received
Message-ID: <20201114165439.7e87c72b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605239517-49707-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1605239517-49707-1-git-send-email-alex.shi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You had a typo in the subject nic -> nci. But really nfc: would be
enough.

On Fri, 13 Nov 2020 11:51:57 +0800 Alex Shi wrote:
> We don't use the parameter result actually, so better to remove it and
> skip a gcc warning for unused variable.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>

Let's CC the nfc list.

nfc folks any reason the list is not mentioned under NFC SUBSYSTEM?

> diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
> index c18e76d6d8ba..6b275a387a92 100644
> --- a/net/nfc/nci/hci.c
> +++ b/net/nfc/nci/hci.c
> @@ -363,16 +363,13 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
>  }
>  
>  static void nci_hci_resp_received(struct nci_dev *ndev, u8 pipe,
> -				  u8 result, struct sk_buff *skb)
> +				  struct sk_buff *skb)
>  {
>  	struct nci_conn_info    *conn_info;
> -	u8 status = result;
>  
>  	conn_info = ndev->hci_dev->conn_info;
> -	if (!conn_info) {
> -		status = NCI_STATUS_REJECTED;
> +	if (!conn_info)
>  		goto exit;
> -	}
>  
>  	conn_info->rx_skb = skb;
>  

LGTM based on the fact that commit d8cd37ed2fc8 ("NFC: nci: Fix improper
management of HCI return code") started seemingly intentionally ignoring 
the status.

Applied, thanks!
