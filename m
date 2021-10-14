Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C524842CFC5
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 03:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhJNBDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 21:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJNBDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 21:03:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 624DB61175;
        Thu, 14 Oct 2021 01:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634173272;
        bh=YiGocq2ZvSgn0npzYDaosIe5Ts+WasrJDtPiAWS7vI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iA800c2KPZ2v9W8IVp8CYnjP5cpqxwyhCHkR6+W/Mu4Tpi2CdoF2Ket0rEIVcwajb
         33XDBo7DXJMZcz3mG4+8iT1kPRICZtl+Mu3fc/v3S9Fiii1FQZ8XgDTmnOEy8cPTvR
         IwX7HSlPOvyLPr61XHDF+rRWR69ShLaEw8fzmlhx67BsicXQWlqH4esRkSeCUIc04N
         l3SvVkRU5XZktv0VKmyBUp5G3OKe1zCd3ZqX3uZFnSv3q6TjAu3JgNCo0qYhgcEaOK
         EpcijtlLXBj6VNgUd88HKL1gqnY03ggy8+93Q2btVWUdLs/lJrCLvY4NEfA2nB7C+z
         pFRfXsSyTnZAQ==
Date:   Wed, 13 Oct 2021 18:01:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     linux-nfc@lists.01.org, krzysztof.kozlowski@canonical.com,
        davem@davemloft.net, bongsu.jeon@samsung.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] NFC: NULL out conn_info reference when conn is closed
Message-ID: <20211013180111.611dac91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013043052.16379-1-linma@zju.edu.cn>
References: <20211013043052.16379-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 12:30:52 +0800 Lin Ma wrote:
> The nci_core_conn_close_rsp_packet() function will release the conn_info
> with given conn_id. However, this reference of this object may still held
> by other places like ndev->rf_conn_info in routine:
> .. -> nci_recv_frame()
>      -> nci_rx_work()
>        -> nci_rsp_packet()
>          -> nci_rf_disc_rsp_packet()
>            -> devm_kzalloc()  
>               ndev->rf_conn_info = conn_info;
> 
> or ndev->hci_dev->conn_info in routine:
> .. -> nci_recv_frame()
>      -> nci_rx_work()
>        -> nci_rsp_packet()
>          -> nci_core_conn_create_rsp_packet()
>            -> devm_kzalloc()  
>               ndev->hci_dev->conn_info = conn_info;
> 
> If these two places are not NULL out, potential UAF can be exploited by
> the attacker when emulating an UART NFC device. This patch compares the
> deallocating object with the two places and writes NULL to prevent that.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>

This doesn't apply, looks like we already have half of this patch in
the networking fixes tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=1b1499a817c90fd1ce9453a2c98d2a01cca0e775

Please rebase on top of that and resend. Add a Fixes tag while at it.
