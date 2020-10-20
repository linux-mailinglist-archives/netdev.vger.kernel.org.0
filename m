Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7076E294498
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438688AbgJTVd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438683AbgJTVdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 17:33:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB8DE22244;
        Tue, 20 Oct 2020 21:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603229634;
        bh=ePn/A2CyQ0H27JB9wMQ+e2sUzCTGJ38k7Ta2sc0v4og=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ljKp+tcNlkXt8obUJf9KN3SJYMRM0s4naOeRdVaO0iE9tU3jHKVGLkpVojFw+Oc1U
         YLOKxcGVZbD4R1qI0N/qlRaAkOvqBeOxt8vnddonrib7m72k8f7QSWS5ZdNdhKot0l
         8OwT5gVdkdjB91f2CNE1NuMzffh54EnWf436lTFU=
Date:   Tue, 20 Oct 2020 14:33:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] ibmvnic: save changed mac address to
 adapter->mac_addr
Message-ID: <20201020143352.04cee401@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <456A40F4-7C46-4147-A22E-8B09209FD13A@linux.vnet.ibm.com>
References: <20201016045715.26768-1-ljp@linux.ibm.com>
        <20201019171152.6592e0c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <456A40F4-7C46-4147-A22E-8B09209FD13A@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 16:18:04 -0500 Lijun Pan wrote:
> > On Oct 19, 2020, at 7:11 PM, Jakub Kicinski <kuba@kernel.org> wrote:
> > 
> > On Thu, 15 Oct 2020 23:57:15 -0500 Lijun Pan wrote:  
> >> After mac address change request completes successfully, the new mac
> >> address need to be saved to adapter->mac_addr as well as
> >> netdev->dev_addr. Otherwise, adapter->mac_addr still holds old
> >> data.  
> > 
> > Do you observe this in practice? Can you show us which path in
> > particular you see this happen on?
> > 
> > AFAICS ibmvnic_set_mac() copies the new MAC addr into adapter->mac_addr
> > before making a request.
> > 
> > If anything is wrong here is that it does so regardless if MAC addr 
> > is valid.
> 
> Yes, I ran some internal test to check the mac address in adapter->mac_addr, and
> it is the old data. If you run ifconfig command to change mac addr, the netdev->dev_addr
> is changed afterwards, and if you run ifocnfig again, it will show the new mac addr. However,
> since we did not check adapter->mac_addr in this use case, this bug was not exposed.
> 
> This vnic driver is little bit different than other physical NIC driver. All the control paths
> are negotaited with VIOS server, and data paths are through DMA mapping.
> 
> __ibmvnic_set_mac copies the new mac addr to crq by
> 	ether_addr_copy(&crq.change_mac_addr.mac_addr[0], dev_addr);
> and then send the change request by
> 	rc = ibmvnic_send_crq(adapter, &crq);
> Now adapter->mac_addr still has the old data.
> 
> When the request is handled by VIOS server, an interrupt is triggered, and 
> handle_change_mac_rsp is called. 
> Now it is time to copy the new mac to netdev->dev_addr, and adatper->mac_addr.
> 	ether_addr_copy(netdev->dev_addr,
> 			&crq->change_mac_addr_rsp.mac_addr[0]);
> It missed the copy for adapter->mac_addr, which is what I add in this patch.
> +	ether_addr_copy(adapter->mac_addr,
> +			&crq->change_mac_addr_rsp.mac_addr[0]);

Please read my reply carefully.

What's the call path that leads to the address being wrong? If you set
the address via ifconfig it will call ibmvnic_set_mac() of the driver.
ibmvnic_set_mac() does the copy.

But it doesn't validate the address, which it should.
