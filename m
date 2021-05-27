Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907DD393019
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 15:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhE0NvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 09:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236531AbhE0NvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 09:51:06 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A031C061574;
        Thu, 27 May 2021 06:49:33 -0700 (PDT)
Received: from localhost ([127.0.0.1] helo=bute.mt.lv)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lmGO2-0000FE-Vn; Thu, 27 May 2021 16:49:23 +0300
MIME-Version: 1.0
Date:   Thu, 27 May 2021 16:49:22 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     chris.snook@gmail.com, davem@davemloft.net, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] atl1c: add 4 RX/TX queue support for Mikrotik
 10/25G NIC
In-Reply-To: <20210526181609.1416c4eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210526075830.2959145-1-gatis@mikrotik.com>
 <20210526181609.1416c4eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <d2651c5f20d072f99e66f9e1df3956f0@mikrotik.com>
X-Sender: gatis@mikrotik.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-05-27 04:16, Jakub Kicinski wrote:
>> +/**
>> + * atl1c_clean_rx - NAPI Rx polling callback
>> + * @napi: napi info
>> + * @budget: limit of packets to clean
>> + */
>> +static int atl1c_clean_rx(struct napi_struct *napi, int budget)
>>  {
>> +	struct atl1c_rrd_ring *rrd_ring =
>> +		container_of(napi, struct atl1c_rrd_ring, napi);
>> +	struct atl1c_adapter *adapter = rrd_ring->adapter;
>> +	int work_done = 0;
>> +	unsigned long flags;
>>  	u16 rfd_num, rfd_index;
>> -	u16 count = 0;
>>  	u16 length;
>>  	struct pci_dev *pdev = adapter->pdev;
>>  	struct net_device *netdev  = adapter->netdev;
>> -	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
>> -	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
>> +	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[rrd_ring->num];
>>  	struct sk_buff *skb;
>>  	struct atl1c_recv_ret_status *rrs;
>>  	struct atl1c_buffer *buffer_info;
>> 
>> +	/* Keep link state information with original netdev */
>> +	if (!netif_carrier_ok(adapter->netdev))
>> +		goto quit_polling;
> 
> Interesting, I see you only move this code, but why does this driver
> stop reading packets when link goes down? Surely there may be packets
> already on the ring which Linux should process?

Jakub, I do not know what possible HW quirks this check might be
covering up, so I left it there. If you feel it is safe to remove
I can do a separate patch for that. I think it is fine for the
HW I work with, but that is far from everything this driver supports.

Thank you for reviewing this!
