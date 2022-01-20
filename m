Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23E3494AA8
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 10:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358659AbiATJZQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jan 2022 04:25:16 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:57829 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241888AbiATJZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 04:25:12 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 85D0320000F;
        Thu, 20 Jan 2022 09:25:07 +0000 (UTC)
Date:   Thu, 20 Jan 2022 10:25:06 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>
Subject: Re: [wpan-next 5/9] net: ieee802154: ca8210: Stop leaking skb's
Message-ID: <20220120102506.04d5ffb7@xps13>
In-Reply-To: <202201201557.38baVRVX-lkp@intel.com>
References: <20220120003645.308498-6-miquel.raynal@bootlin.com>
        <202201201557.38baVRVX-lkp@intel.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


lkp@intel.com wrote on Thu, 20 Jan 2022 15:31:39 +0800:

> Hi Miquel,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v5.16 next-20220120]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Miquel-Raynal/ieee802154-A-bunch-of-fixes/20220120-083906
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 1d1df41c5a33359a00e919d54eaebfb789711fdc
> config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220120/202201201557.38baVRVX-lkp@intel.com/config)
> compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project f7b7138a62648f4019c55e4671682af1f851f295)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/77d3026b30aff560ef269d03aecc09f8c46a9173
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Miquel-Raynal/ieee802154-A-bunch-of-fixes/20220120-083906
>         git checkout 77d3026b30aff560ef269d03aecc09f8c46a9173
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/ieee802154/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
> >> drivers/net/ieee802154/ca8210.c:1775:22: error: use of undeclared identifier 'atusb'  
>                            dev_kfree_skb_any(atusb->tx_skb);
>                                              ^
>    1 error generated.
> 
> 
> vim +/atusb +1775 drivers/net/ieee802154/ca8210.c
> 
>   1737	
>   1738	/**
>   1739	 * ca8210_async_xmit_complete() - Called to announce that an asynchronous
>   1740	 *                                transmission has finished
>   1741	 * @hw:          ieee802154_hw of ca8210 that has finished exchange
>   1742	 * @msduhandle:  Identifier of transmission that has completed
>   1743	 * @status:      Returned 802.15.4 status code of the transmission
>   1744	 *
>   1745	 * Return: 0 or linux error code
>   1746	 */
>   1747	static int ca8210_async_xmit_complete(
>   1748		struct ieee802154_hw  *hw,
>   1749		u8                     msduhandle,
>   1750		u8                     status)
>   1751	{
>   1752		struct ca8210_priv *priv = hw->priv;
>   1753	
>   1754		if (priv->nextmsduhandle != msduhandle) {
>   1755			dev_err(
>   1756				&priv->spi->dev,
>   1757				"Unexpected msdu_handle on data confirm, Expected %d, got %d\n",
>   1758				priv->nextmsduhandle,
>   1759				msduhandle
>   1760			);
>   1761			return -EIO;
>   1762		}
>   1763	
>   1764		priv->async_tx_pending = false;
>   1765		priv->nextmsduhandle++;
>   1766	
>   1767		if (status) {
>   1768			dev_err(
>   1769				&priv->spi->dev,
>   1770				"Link transmission unsuccessful, status = %d\n",
>   1771				status
>   1772			);
>   1773			if (status != MAC_TRANSACTION_OVERFLOW) {
>   1774				ieee802154_wake_queue(priv->hw);
> > 1775				dev_kfree_skb_any(atusb->tx_skb);  

Looks like I messed with the configuration and this driver was not
compile-tested anymore. I'll fix this.

>   1776				return 0;
>   1777			}
>   1778		}
>   1779		ieee802154_xmit_complete(priv->hw, priv->tx_skb, true);
>   1780	
>   1781		return 0;
>   1782	}
>   1783	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


Thanks,
Miquèl
