Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1785F9861
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 08:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiJJGb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 02:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiJJGbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 02:31:55 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C881418E05
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 23:31:51 -0700 (PDT)
X-QQ-mid: Yeas54t1665383494t498t11980
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20220929093424.2104246-1-jiawenwu@trustnetic.com> <20220929093424.2104246-3-jiawenwu@trustnetic.com> <YzXL1WoOwUnU93Lq@lunn.ch>
In-Reply-To: <YzXL1WoOwUnU93Lq@lunn.ch>
Subject: RE: [PATCH net-next v3 2/3] net: txgbe: Reset hardware
Date:   Mon, 10 Oct 2022 14:31:33 +0800
Message-ID: <00f601d8dc71$f0ded460$d29c7d20$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFGz/tyg7e+EkGDFw8tCHUpsPOTggGWvgXhAfnsFSGvDreiIA==
Content-Language: zh-cn
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

On Friday, September 30, 2022 12:46 AM, Andrew Lunn wrote:
> On Thu, Sep 29, 2022 at 05:34:23PM +0800, Jiawen Wu wrote:
> > Reset and initialize the hardware by configuring the MAC layer.
> >
> > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> > ---
> >  drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 160 ++++++++++++++++++
> >  drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   2 +
> >  drivers/net/ethernet/wangxun/libwx/wx_type.h  | 144 ++++++++++++++++
> >  drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
> >  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   5 +-
> >  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  86 ++++++++++
> >  drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   9 +
> >  .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  21 +++
> >  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  11 +-
> >  9 files changed, 432 insertions(+), 9 deletions(-)  create mode
> > 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
> >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
> >
> > diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> > b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> > index fed51c2f3071..76f88cfb2476 100644
> > --- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> > +++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
> > @@ -7,6 +7,21 @@
> >  #include "wx_type.h"
> >  #include "wx_hw.h"
> >
> > +static void wx_intr_disable(struct wx_hw *wxhw, u64 qmask) {
> > +	u32 mask;
> > +
> > +	mask = (qmask & 0xFFFFFFFF);
> > +	if (mask)
> > +		wr32(wxhw, WX_PX_IMS(0), mask);
> > +
> > +	if (wxhw->mac.type == wx_mac_sp) {
> > +		mask = (qmask >> 32);
> > +		if (mask)
> > +			wr32(wxhw, WX_PX_IMS(1), mask);
> > +	}
> > +}
> > +
> >  /* cmd_addr is used for some special command:
> >   * 1. to be sector address, when implemented erase sector command
> >   * 2. to be flash address when implemented read, write flash address
> > @@ -56,6 +71,151 @@ int wx_check_flash_load(struct wx_hw *hw, u32
> > check_bit)  }  EXPORT_SYMBOL(wx_check_flash_load);
> >
> > +static void wx_disable_rx(struct wx_hw *wxhw) {
> > +	u32 pfdtxgswc;
> > +	u32 rxctrl;
> > +
> > +	rxctrl = rd32(wxhw, WX_RDB_PB_CTL);
> > +	if (rxctrl & WX_RDB_PB_CTL_RXEN) {
> > +		pfdtxgswc = rd32(wxhw, WX_PSR_CTL);
> > +		if (pfdtxgswc & WX_PSR_CTL_SW_EN) {
> > +			pfdtxgswc &= ~WX_PSR_CTL_SW_EN;
> > +			wr32(wxhw, WX_PSR_CTL, pfdtxgswc);
> > +			wxhw->mac.set_lben = true;
> > +		} else {
> > +			wxhw->mac.set_lben = false;
> > +		}
> > +		rxctrl &= ~WX_RDB_PB_CTL_RXEN;
> > +		wr32(wxhw, WX_RDB_PB_CTL, rxctrl);
> > +
> > +		if (!(((wxhw->subsystem_device_id & WX_NCSI_MASK) == WX_NCSI_SUP) ||
> > +		      ((wxhw->subsystem_device_id & WX_WOL_MASK) == WX_WOL_SUP))) {
> > +			/* disable mac receiver */
> > +			wr32m(wxhw, WX_MAC_RX_CFG,
> > +			      WX_MAC_RX_CFG_RE, 0);
> > +		}
> > +	}
> > +}
> > +
> > +/**
> > + *  wx_disable_pcie_master - Disable PCI-express master access
> > + *  @wxhw: pointer to hardware structure
> > + *
> > + *  Disables PCI-Express master access and verifies there are no
> > +pending
> > + *  requests.
> > + **/
> > +static int wx_disable_pcie_master(struct wx_hw *wxhw) {
> > +	int status = 0;
> > +	u32 val;
> > +
> > +	/* Always set this bit to ensure any future transactions are blocked */
> > +	pci_clear_master(wxhw->pdev);
> > +
> > +	/* Exit if master requests are blocked */
> > +	if (!(rd32(wxhw, WX_PX_TRANSACTION_PENDING)))
> > +		return 0;
> > +
> > +	/* Poll for master request bit to clear */
> > +	status = read_poll_timeout(rd32, val, !val, 100, WX_PCI_MASTER_DISABLE_TIMEOUT,
> > +				   false, wxhw, WX_PX_TRANSACTION_PENDING);
> > +	if (status < 0)
> > +		wx_err(wxhw, "PCIe transaction pending bit did not clear.\n");
> > +
> > +	return status;
> > +}
> > +
> > +/**
> > + *  wx_stop_adapter - Generic stop Tx/Rx units
> > + *  @hw: pointer to hardware structure
> > + *
> > + *  Sets the adapter_stopped flag within wx_hw struct. Clears
> > +interrupts,
> > + *  disables transmit and receive units. The adapter_stopped flag is
> > +used by
> > + *  the shared code and drivers to determine if the adapter is in a
> > +stopped
> > + *  state and should not touch the hardware.
> > + **/
> > +int wx_stop_adapter(struct wx_hw *wxhw) {
> > +	u16 i;
> > +
> > +	/* Set the adapter_stopped flag so other driver functions stop touching
> > +	 * the hardware
> > +	 */
> > +	wxhw->adapter_stopped = true;
> > +
> > +	/* Disable the receive unit */
> > +	wx_disable_rx(wxhw);
> > +
> > +	/* Set interrupt mask to stop interrupts from being generated */
> > +	wx_intr_disable(wxhw, WX_INTR_ALL);
> > +
> > +	/* Clear any pending interrupts, flush previous writes */
> > +	wr32(wxhw, WX_PX_MISC_IC, 0xffffffff);
> > +	wr32(wxhw, WX_BME_CTL, 0x3);
> > +
> > +	/* Disable the transmit unit.  Each queue must be disabled. */
> > +	for (i = 0; i < wxhw->mac.max_tx_queues; i++) {
> > +		wr32m(wxhw, WX_PX_TR_CFG(i),
> > +		      WX_PX_TR_CFG_SWFLSH | WX_PX_TR_CFG_ENABLE,
> > +		      WX_PX_TR_CFG_SWFLSH);
> > +	}
> > +
> > +	/* Disable the receive unit by stopping each queue */
> > +	for (i = 0; i < wxhw->mac.max_rx_queues; i++) {
> > +		wr32m(wxhw, WX_PX_RR_CFG(i),
> > +		      WX_PX_RR_CFG_RR_EN, 0);
> > +	}
> > +
> > +	/* flush all queues disables */
> > +	WX_WRITE_FLUSH(wxhw);
> 
> Please don't hide memory barriers like this. Memory barriers are hard, so you want them in plain
view, so
> you can understand them.
> 
> > +/* flush PCI read and write */
> > +#define WX_WRITE_FLUSH(H) rd32(H, WX_MIS_PWR)
> 
> I don't think you actually need to do anything here. rd32 is using
> readl():
> 
> static inline u32 readl(const volatile void __iomem *addr) {
> 	u32 val;
> 
> 	__io_br();
> 	val = __le32_to_cpu((__le32 __force)__raw_readl(addr));
> 	__io_ar(val);
> 	return val;
> }
> 
> So you have an IO barrier before and a read barrier afterwards.  So all i think you need is a
mb(), not a
> full rd32().
> 
>    Andrew
> 

I think we need a readl(), because there are problems that sometimes IO is not synchronized with
flushing memory on some domestic cpu platforms.
It can become a serious problem, causing register error configurations.


