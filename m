Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F495A742C
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 04:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiHaCzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 22:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiHaCzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 22:55:07 -0400
X-Greylist: delayed 71361 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Aug 2022 19:55:04 PDT
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9521EC45
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 19:55:02 -0700 (PDT)
X-QQ-mid: Yeas51t1661914481t752t47340
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00000000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com> <20220830070454.146211-3-jiawenwu@trustnetic.com> <Yw6tsmufKFoHzu4M@lunn.ch>
In-Reply-To: <Yw6tsmufKFoHzu4M@lunn.ch>
Subject: RE: [PATCH net-next v2 02/16] net: txgbe: Reset hardware
Date:   Wed, 31 Aug 2022 10:54:40 +0800
Message-ID: <025801d8bce5$0423b010$0c6b1030$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQFxw3HAOMjs+mp0EMv9zR33VUwRMQEn5THcAgyKsS2ufJZ4YA==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, August 31, 2022 8:39 AM, Andrew Lunn wrote:
> n Tue, Aug 30, 2022 at 03:04:40PM +0800, Jiawen Wu wrote:
> >  /* struct txgbe_mac_operations */
> > +static int txgbe_stop_adapter_dummy(struct txgbe_hw *TUP0) {
> > +	return -EPERM;
> 
> This is a bit of an odd error code. -EOPNOTSUPP would be more normal.
> 
> I do wonder what all this dummy stuff is for...
> 

Okay, I just think that this way I don't need to determine whether the
function pointer is NULL every time it is called.

> > +/**
> > + *  txgbe_stop_adapter - Generic stop Tx/Rx units
> > + *  @hw: pointer to hardware structure
> > + *
> > + *  Sets the adapter_stopped flag within txgbe_hw struct. Clears
> > +interrupts,
> > + *  disables transmit and receive units. The adapter_stopped flag is
> > +used by
> > + *  the shared code and drivers to determine if the adapter is in a
> > +stopped
> > + *  state and should not touch the hardware.
> > + **/
> > +int txgbe_stop_adapter(struct txgbe_hw *hw) {
> > +	u16 i;
> > +
> > +	/* Set the adapter_stopped flag so other driver functions stop
touching
> > +	 * the hardware
> > +	 */
> > +	hw->adapter_stopped = true;
> > +
> > +	/* Disable the receive unit */
> > +	hw->mac.ops.disable_rx(hw);
> > +
> > +	/* Set interrupt mask to stop interrupts from being generated */
> > +	txgbe_intr_disable(hw, TXGBE_INTR_ALL);
> > +
> > +	/* Clear any pending interrupts, flush previous writes */
> > +	wr32(hw, TXGBE_PX_MISC_IC, 0xffffffff);
> > +	wr32(hw, TXGBE_BME_CTL, 0x3);
> > +
> > +	/* Disable the transmit unit.  Each queue must be disabled. */
> > +	for (i = 0; i < hw->mac.max_tx_queues; i++) {
> > +		wr32m(hw, TXGBE_PX_TR_CFG(i),
> > +		      TXGBE_PX_TR_CFG_SWFLSH | TXGBE_PX_TR_CFG_ENABLE,
> > +		      TXGBE_PX_TR_CFG_SWFLSH);
> > +	}
> > +
> > +	/* Disable the receive unit by stopping each queue */
> > +	for (i = 0; i < hw->mac.max_rx_queues; i++) {
> > +		wr32m(hw, TXGBE_PX_RR_CFG(i),
> > +		      TXGBE_PX_RR_CFG_RR_EN, 0);
> > +	}
> > +
> > +	/* flush all queues disables */
> > +	TXGBE_WRITE_FLUSH(hw);
> > +
> > +	/* Prevent the PCI-E bus from hanging by disabling PCI-E master
> > +	 * access and verify no pending requests
> > +	 */
> > +	return txgbe_disable_pcie_master(hw);
> 
> Interesting. You use it here....
> 
> > +}
> > +
> > +/**
> > + *  txgbe_disable_pcie_master - Disable PCI-express master access
> > + *  @hw: pointer to hardware structure
> > + *
> > + *  Disables PCI-Express master access and verifies there are no
> > +pending
> > + *  requests. TXGBE_ERR_MASTER_REQUESTS_PENDING is returned if
> master
> > +disable
> > + *  bit hasn't caused the master requests to be disabled, else 0
> > + *  is returned signifying master requests disabled.
> > + **/
> > +int txgbe_disable_pcie_master(struct txgbe_hw *hw) {
> > +	struct txgbe_adapter *adapter = container_of(hw, struct
txgbe_adapter,
> hw);
> > +	int status = 0;
> > +	u32 val;
> 
> But define it here, afterwards. Wrong order. Swap this around, and remove
the
> forward reference. And should this also be static? Is it used in any other
object
> file?
> 
> Because you have it in the wrong order, the compiler cannot easily inline
it. The
> optimised won't do as good a job as if it had seen it first before it was
also used.
> Also, because it is not static, the compiler needs to keep a copy around
for the
> linker to use with another object file.
> 
> So....
> 
> Define functions before you use them.
> 
> Make them static if possible.
> 
> Header files should only contain definitions of functions which are used
> between object files, not within an object file.
> 

There are indeed a lot of order errors in the code, I'll try to fix it.
When making the patch, I cut out every piece of functionality from the full
driver.
So there are some functions called later in other files, which currently
seems like a silly design.


