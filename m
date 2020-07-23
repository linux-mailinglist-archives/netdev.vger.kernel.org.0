Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041AC22A3F6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgGWA6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWA6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:58:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAC0C0619DC;
        Wed, 22 Jul 2020 17:58:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF40B126ABECD;
        Wed, 22 Jul 2020 17:41:45 -0700 (PDT)
Date:   Wed, 22 Jul 2020 17:58:30 -0700 (PDT)
Message-Id: <20200722.175830.616952267325554952.davem@davemloft.net>
To:     srirakr2@cisco.com
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, mbumgard@cisco.com, ugm@cisco.com,
        nimm@cisco.com, xe-linux-external@cisco.com, kuba@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] hv_netvsc: add support for vlans in AF_PACKET mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722153845.79946-1-srirakr2@cisco.com>
References: <20200722153845.79946-1-srirakr2@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 17:41:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram Krishnan <srirakr2@cisco.com>
Date: Wed, 22 Jul 2020 21:08:44 +0530

> Vlan tagged packets are getting dropped when used with DPDK that uses
> the AF_PACKET interface on a hyperV guest.
> 
> The packet layer uses the tpacket interface to communicate the vlans
> information to the upper layers. On Rx path, these drivers can read the
> vlan info from the tpacket header but on the Tx path, this information
> is still within the packet frame and requires the paravirtual drivers to
> push this back into the NDIS header which is then used by the host OS to
> form the packet.
> 
> This transition from the packet frame to NDIS header is currently missing
> hence causing the host OS to drop the all vlan tagged packets sent by
> the drivers that use AF_PACKET (ETH_P_ALL) such as DPDK.
> 
> Here is an overview of the changes in the vlan header in the packet path:
> 
> The RX path (userspace handles everything):
>   1. RX VLAN packet is stripped by HOST OS and placed in NDIS header
>   2. Guest Kernel RX hv_netvsc packets and moves VLAN info from NDIS
>      header into kernel SKB
>   3. Kernel shares packets with user space application with PACKET_MMAP.
>      The SKB VLAN info is copied to tpacket layer and indication set
>      TP_STATUS_VLAN_VALID.
>   4. The user space application will re-insert the VLAN info into the frame
> 
> The TX path:
>   1. The user space application has the VLAN info in the frame.
>   2. Guest kernel gets packets from the application with PACKET_MMAP.
>   3. The kernel later sends the frame to the hv_netvsc driver. The only way
>      to send VLANs is when the SKB is setup & the VLAN is stripped from the
>      frame.
>   4. TX VLAN is re-inserted by HOST OS based on the NDIS header. If it sees
>      a VLAN in the frame the packet is dropped.
> 
> Cc: xe-linux-external@cisco.com
> Cc: Sriram Krishnan <srirakr2@cisco.com>
> Signed-off-by: Sriram Krishnan <srirakr2@cisco.com>

Applied to net-next, thank you.
