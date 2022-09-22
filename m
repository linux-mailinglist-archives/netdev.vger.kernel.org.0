Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA8C5E5F28
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiIVJ7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIVJ7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:59:19 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5293110E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:59:16 -0700 (PDT)
X-QQ-mid: Yeas43t1663840736t598t22871
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com> <20220830070454.146211-4-jiawenwu@trustnetic.com> <Yw6zNh+TTGyfBzSV@lunn.ch>
In-Reply-To: <Yw6zNh+TTGyfBzSV@lunn.ch>
Subject: RE: [PATCH net-next v2 03/16] net: txgbe: Set MAC address and register netdev
Date:   Thu, 22 Sep 2022 17:58:55 +0800
Message-ID: <016a01d8ce69$ed6a6350$c83f29f0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQFxw3HAOMjs+mp0EMv9zR33VUwRMQDhNqTTAkICjBCuoC5moA==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, August 31, 2022 9:03 AM, Andrew Lunn wrote:
> > +struct txgbe_ring {
> > +	u8 reg_idx;
> > +} ____cacheline_internodealigned_in_smp;
> 
> Am i right in thinking that is one byte actually takes up one L3 cache
line?
> 
> >  struct txgbe_adapter {
> >  	u8 __iomem *io_addr;    /* Mainly for iounmap use */
> > @@ -18,11 +35,33 @@ struct txgbe_adapter {
> >  	struct net_device *netdev;
> >  	struct pci_dev *pdev;
> >
> > +	/* Tx fast path data */
> > +	int num_tx_queues;
> > +
> > +	/* TX */
> > +	struct txgbe_ring *tx_ring[TXGBE_MAX_TX_QUEUES]
> > +____cacheline_aligned_in_smp;
> > +
> 
> I assume this causes tx_ring to be aligned to a cache line. Have you use
pahole
> to see how much space you are wasting? Can some of the other members be
> moved around to reduce the waste? Generally, try to arrange everything for
RX
> on one cache line, everything for TX on another cache line.
> 

More members will be added to 'struct txgbe_ring', but this current patch
only adds one byte 'reg_idx'.
I will postpone it until the actual need to add.

> > +void txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
> > +		   u32 enable_addr)
> > +{
> > +	u32 rar_entries = hw->mac.num_rar_entries;
> > +	u32 rar_low, rar_high;
> > +
> > +	/* Make sure we are using a valid rar index range */
> > +	if (index >= rar_entries) {
> > +		txgbe_info(hw, "RAR index %d is out of range.\n", index);
> > +		return;
> > +	}
> > +
> > +	/* select the MAC address */
> > +	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, index);
> > +
> > +	/* setup VMDq pool mapping */
> > +	wr32(hw, TXGBE_PSR_MAC_SWC_VM_L, pools & 0xFFFFFFFF);
> > +	wr32(hw, TXGBE_PSR_MAC_SWC_VM_H, pools >> 32);
> > +
> > +	/* HW expects these in little endian so we reverse the byte
> > +	 * order from network order (big endian) to little endian
> 
> And what happens when the machine is already little endian?
> 

It is not evaluated here, so it doesn't matter what the machine's byte order
is.


