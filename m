Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87F23B2E9E
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhFXMLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:11:07 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:48535 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229448AbhFXMLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:11:05 -0400
X-UUID: 9d6e04b807e64a3da003119c7e3ea53a-20210624
X-UUID: 9d6e04b807e64a3da003119c7e3ea53a-20210624
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1175979880; Thu, 24 Jun 2021 20:08:41 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Jun 2021 20:08:39 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Jun 2021 20:08:38 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <bpf@vger.kernel.org>,
        <wsd_upstream@mediatek.com>, <chao.song@mediatek.com>,
        <kuohong.wang@mediatek.com>, Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
Date:   Thu, 24 Jun 2021 19:53:49 +0800
Message-ID: <20210624115349.2264-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <YNNv1AxDNBdPcQ1U@kroah.com>
References: <YNNv1AxDNBdPcQ1U@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-23 at 19:31 +0200, Greg KH wrote:
On Wed, Jun 23, 2021 at 07:34:52PM +0800, Rocco Yue wrote:
>> +static int ccmni_open(struct net_device *ccmni_dev)
>> +{
>> +	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
>> +
>> +	netif_tx_start_all_queues(ccmni_dev);
>> +	netif_carrier_on(ccmni_dev);
>> +
>> +	if (atomic_inc_return(&ccmni->usage) > 1) {
>> +		atomic_dec(&ccmni->usage);
>> +		netdev_err(ccmni_dev, "dev already open\n");
>> +		return -EINVAL;
> 
> You only check this _AFTER_ starting up?  If so, why even check a count
> at all?  Why does it matter as it's not keeping anything from working
> here.
> 

Thanks for your review.
Looking back at this code block, it does have some ploblems,
ccmni->usage hasn't been used to protect some resources or do
some specific things in the current code, I will delete them.

> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int ccmni_close(struct net_device *ccmni_dev)
>> +{
>> +	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
>> +
>> +	atomic_dec(&ccmni->usage);
>> +	netif_tx_disable(ccmni_dev);
>> +
>> +	return 0;
>> +}
>> +
>> +static netdev_tx_t
>> +ccmni_start_xmit(struct sk_buff *skb, struct net_device *ccmni_dev)
>> +{
>> +	struct ccmni_inst *ccmni = NULL;
>> +
>> +	if (unlikely(!ccmni_hook_ready))
>> +		goto tx_ok;
>> +
>> +	if (!skb || !ccmni_dev)
>> +		goto tx_ok;
>> +
>> +	ccmni = netdev_priv(ccmni_dev);
>> +
>> +	/* some process can modify ccmni_dev->mtu */
>> +	if (skb->len > ccmni_dev->mtu) {
>> +		netdev_err(ccmni_dev, "xmit fail: len(0x%x) > MTU(0x%x, 0x%x)",
>> +			   skb->len, CCMNI_MTU, ccmni_dev->mtu);
>> +		goto tx_ok;
>> +	}
>> +
>> +	/* hardware driver send packet will return a negative value
>> +	 * ask the Linux netdevice to stop the tx queue
>> +	 */
>> +	if ((s_ccmni_ctlb->xmit_pkt(ccmni->index, skb, 0)) < 0)
>> +		return NETDEV_TX_BUSY;
>> +
>> +	return NETDEV_TX_OK;
>> +tx_ok:
>> +	dev_kfree_skb(skb);
>> +	ccmni_dev->stats.tx_dropped++;
>> +	return NETDEV_TX_OK;
>> +}
>> +
>> +static int ccmni_change_mtu(struct net_device *ccmni_dev, int new_mtu)
>> +{
>> +	if (new_mtu < 0 || new_mtu > CCMNI_MTU)
>> +		return -EINVAL;
>> +
>> +	if (unlikely(!ccmni_dev))
>> +		return -EINVAL;
>> +
>> +	ccmni_dev->mtu = new_mtu;
>> +	return 0;
>> +}
>> +
>> +static void ccmni_tx_timeout(struct net_device *ccmni_dev, unsigned int txqueue)
>> +{
>> +	struct ccmni_inst *ccmni = netdev_priv(ccmni_dev);
>> +
>> +	ccmni_dev->stats.tx_errors++;
>> +	if (atomic_read(&ccmni->usage) > 0)
>> +		netif_tx_wake_all_queues(ccmni_dev);
> 
> Why does it matter what the reference count is?  What happens if it
> drops _RIGHT_ after testing for it?
> 
> Anytime you do an atomic_read() call, it's almost always a sign that the
> logic is not correct.
> 
> Again, why have this reference count at all?  What is it protecting?
> 

The jedgment of ccmni->usage here is to ensure that the ccmnix interface
is already up when do wake up tx queue behavior.

Then I re-read the kernel code, I think my previous ider should be
wrong. the reason is that before calling ccmni_tx_timeout(), it
will check whether the dev exist or not, for example, it will be
checked in dev_watchdog().

I can delete this code.

>> +/* exposed API
>> + * receive incoming datagrams from the Modem and push them to the
>> + * kernel networking system
>> + */
>> +int ccmni_rx_push(unsigned int ccmni_idx, struct sk_buff *skb)
> 
> Ah, so this driver doesn't really do anything on its own, as there is no
> modem driver for it.
> 
> So without a modem driver, it will never be used?  Please submit the
> modem driver at the same time, otherwise it's impossible to review this
> correctly.
> 

without MTK ap ccci driver (modem driver), ccmni_rx_push() and
ccmni_hif_hook() are not be used.

Both of them are exported as symbols because MTK ap ccci driver
will be complied to the ccci.ko file.

In current codes, I implementated the basic functionality of ccmni,
such as open, close, xmit packet, rcv packet. And my original 
intention was that I can gradually complete some of the more
functions of ccmni on this basis, such as sw-gro, napi, or meet the
requirement of high throughput performance.

In addition, the code of MTK's modem driver is a bit complicated,
because this part has more than 30,000 lines of code and contains
more than 10 modules. We are completeing the upload of this huge
code step by step. Our original intention was to upload the ccmni
driver that directly interacts with the kernel first, and then
complete the code from ccmni to the bottom layer one by one from
top to bottom. We expect the completion period to be about 1 year.

> +++ b/drivers/net/ethernet/mediatek/ccmni/ccmni.h
> 
> Why do you have a .h file for a single .c file?  that shouldn't be
> needed.

I add a .h file to facilitate subsequent code expansion. If it's
not appropriate to do this here, I can add the content of .h into
.c file.

Thanks,
Rocco

