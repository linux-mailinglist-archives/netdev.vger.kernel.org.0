Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CAF4553BE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242923AbhKREX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242928AbhKREXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:23:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE12261B43;
        Thu, 18 Nov 2021 04:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637209215;
        bh=vmu9dtkdCcMN1G55PjONc/pQeva4gLvNU7+H8w4RW9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VXteJ/LrtUnqhqISEeYOrq3sZSrt/mFUoyseVRTxSwFmOYz6p7RM2g2jBYl0232TD
         WV4lmSWalrh0s02FN9YSfLhDBLMx0kXe/+2q6iuxzCYo0yqLmCgK8xDEeJPea2wnAO
         bQVCyR7aH4x+RWKAbUc3WSXrf0+MKeino03wEHLkKuga5Q6hlX1JVWAtp/LUViKx6I
         nOeSGVL+8L6YSihtikcvBoOc0dZ6/NZUhGpj7BboYv7xIZRQ+cI2rF9y+IGjPv98H/
         KI9vBJbTiaquJhb8Tom0GMx6NwAU1v7yfO3MwV8542qMFTzJkvFlANMPs4REPIqe3G
         wko48R/GKUigg==
Date:   Wed, 17 Nov 2021 20:20:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, krzysztof.kozlowski@canonical.com,
        davem@davemloft.net
Subject: Re: [PATCH net v5 1/2] NFC: reorder the logic in
 nfc_{un,}register_device
Message-ID: <20211117202014.308d2700@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211116152652.19217-1-linma@zju.edu.cn>
References: <20211116152652.19217-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 23:26:52 +0800 Lin Ma wrote:
> There is a potential UAF between the unregistration routine and the NFC
> netlink operations.
> 
> The race that cause that UAF can be shown as below:
> 
>  (FREE)                      |  (USE)
> nfcmrvl_nci_unregister_dev   |  nfc_genl_dev_up
>   nci_close_device           |
>   nci_unregister_device      |    nfc_get_device
>     nfc_unregister_device    |    nfc_dev_up
>       rfkill_destory         |
>       device_del             |      rfkill_blocked
>   ...                        |    ...
> 
> The root cause for this race is concluded below:
> 1. The rfkill_blocked (USE) in nfc_dev_up is supposed to be placed after
> the device_is_registered check.
> 2. Since the netlink operations are possible just after the device_add
> in nfc_register_device, the nfc_dev_up() can happen anywhere during the
> rfkill creation process, which leads to data race.
> 
> This patch reorder these actions to permit
> 1. Once device_del is finished, the nfc_dev_up cannot dereference the
> rfkill object.
> 2. The rfkill_register need to be placed after the device_add of nfc_dev
> because the parent device need to be created first. So this patch keeps
> the order but inject device_lock to prevent the data race.

Applied.
