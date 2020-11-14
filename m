Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843DD2B3179
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgKNXqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:46:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgKNXqd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 18:46:33 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CDE022314;
        Sat, 14 Nov 2020 23:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605397593;
        bh=KgCggMZ2pkwFlvuPeBB0qobWPyJuaZLSJfGsePi/4A0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j0b3+MQX4DZsIlJl7wz1U86GsRqR75Poq70I2zdXzIxCLseJs2AKUVMVYGEy2aQKg
         e0nDHnSaLxZbXwk5sLNeyGDffIwkiL8rvVEL0/Bj1boSblfvO7OvHL0Vo8qdy3KIHZ
         h0BS2g3rMyLafNwYx6vUM83ToIGWvu0Qr8oYogL0=
Date:   Sat, 14 Nov 2020 15:46:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dnbanerg@us.ibm.com, brking@linux.vnet.ibm.com, pradeep@us.ibm.com,
        drt@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        ljp@linux.vnet.ibm.com, cforno12@linux.ibm.com,
        ricklind@linux.ibm.com
Subject: Re: [PATCH net-next 04/12] ibmvnic: Introduce xmit_more support
 using batched subCRQ hcalls
Message-ID: <20201114154632.55e87b1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605208207-1896-5-git-send-email-tlfalcon@linux.ibm.com>
References: <1605208207-1896-1-git-send-email-tlfalcon@linux.ibm.com>
        <1605208207-1896-5-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 13:09:59 -0600 Thomas Falcon wrote:
> Include support for the xmit_more feature utilizing the
> H_SEND_SUB_CRQ_INDIRECT hypervisor call which allows the sending
> of multiple subordinate Command Response Queue descriptors in one
> hypervisor call via a DMA-mapped buffer. This update reduces hypervisor
> calls and thus hypervisor call overhead per TX descriptor.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

The common bug with xmit_more is not flushing the already queued
notifications when there is a drop. Any time you drop a skb you need 
to check it's not an skb that was the end of an xmit_more train and 
if so flush notifications (or just always flush on error).

Looking at the driver e.g. this starting goto:

        if (ibmvnic_xmit_workarounds(skb, netdev)) {                            
                tx_dropped++;                                                   
                tx_send_failed++;                                               
                ret = NETDEV_TX_OK;                                             
                goto out;                                                       
        }  

Does not seem to hit any flush on its way out AFAICS.
