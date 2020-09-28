Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CB427AD80
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 14:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgI1MHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 08:07:24 -0400
Received: from smtprelay0176.hostedemail.com ([216.40.44.176]:45882 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726328AbgI1MHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 08:07:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 4551A18045D13;
        Mon, 28 Sep 2020 12:07:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:599:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3873:4050:4120:4321:5007:6119:7875:8568:8957:10004:10848:11026:11232:11473:11657:11658:11914:12043:12294:12296:12297:12438:12555:12740:12760:12895:12986:13439:14659:21080:21324:21433:21451:21627:21740:21810:21939:21966:21987:21990:30054:30070:30080:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: drug88_35125ab27181
X-Filterd-Recvd-Size: 9135
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Mon, 28 Sep 2020 12:07:20 +0000 (UTC)
Message-ID: <c75638782a5a4bc141008c6c3dcec4fd1567da79.camel@perches.com>
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
From:   Joe Perches <joe@perches.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Mon, 28 Sep 2020 05:07:19 -0700
In-Reply-To: <20200928102008.32568-1-srini.raju@purelifi.com>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
         <20200928102008.32568-1-srini.raju@purelifi.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-28 at 15:49 +0530, Srinivasan Raju wrote:
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices, which provide lightweight, highspeed secure and
> fully networked wireless communications via light.

trivial notes:

> diff --git a/drivers/net/wireless/purelifi/chip.c b/drivers/net/wireless/purelifi/chip.c
[]
> +static void print_chip_info(struct purelifi_chip *chip)
> +{
> +	u8 *addr = purelifi_mac_get_perm_addr(purelifi_chip_to_mac(chip));
> +	struct usb_device *udev = interface_to_usbdev(chip->usb.intf);
> +
> +	pr_info("purelifi chip %04hx:%04hx v%04hx  %02x-%02x-%02x %s\n",

You don't need to use %04hx for u16's
any more than you need to use %02hhx for u8's.

	pr_info("purelifi chip %04x:%04x v%04x  %02x-%02x-%02x %s\n",

> +		le16_to_cpu(udev->descriptor.idVendor),
> +		le16_to_cpu(udev->descriptor.idProduct),
> +		le16_to_cpu(udev->descriptor.bcdDevice),
> +		addr[0], addr[1], addr[2],
> +		speed(udev->speed));
> +}
> 

> +static inline void purelifi_mc_add_addr(struct purelifi_mc_hash *hash,
> +					u8 *addr
> +					)

Can you use normal close parenthesis locations?

> diff --git a/drivers/net/wireless/purelifi/def.h b/drivers/net/wireless/purelifi/def.h
> new file mode 100644
> index 000000000000..295dfb45b568
> --- /dev/null
> +++ b/drivers/net/wireless/purelifi/def.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _PURELIFI_DEF_H
> +#define _PURELIFI_DEF_H
> +
> +#include <linux/kernel.h>
> +#include <linux/stringify.h>
> +#include <linux/device.h>
> +
> +typedef u16 __nocast purelifi_addr_t;
> +
> +#define dev_printk_f(level, dev, fmt, args...) \
> +	dev_printk(level, dev, "%s() " fmt, __func__, ##args)

If you _really_w want __func__ output you could use

#define dev_fmt "%s(): " fmt, __func__

> +
> +#ifdef DEBUG
> +#  define dev_dbg_f(dev, fmt, args...) \
> +	  dev_printk_f(KERN_DEBUG, dev, fmt, ## args)
> +#  define dev_dbg_f_limit(dev, fmt, args...) do { \
> +	if (net_ratelimit()) \
> +		dev_printk_f(KERN_DEBUG, dev, fmt, ## args); \
> +} while (0)
> +#  define dev_dbg_f_cond(dev, cond, fmt, args...) ({ \
> +	bool __cond = !!(cond); \
> +	if (unlikely(__cond)) \
> +		dev_printk_f(KERN_DEBUG, dev, fmt, ## args); \
> +})
> +#else
> +#  define dev_dbg_f(dev, fmt, args...)  (void)(dev)

	no_printk

> +#  define dev_dbg_f_limit(dev, fmt, args...) (void)(dev)
> +#  define dev_dbg_f_cond(dev, cond, fmt, args...) (void)(dev)
> +#endif /* DEBUG */
> 
[]
> +++ b/drivers/net/wireless/purelifi/log.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _PURELIFI_LOG
> +#define _PURELIFI_LOG
> +
> +#ifdef PL_DEBUG
> +#define pl_dev_info(dev, fmt, arg...) dev_info(dev, fmt, ##arg)
> +#define pl_dev_warn(dev, fmt, arg...) dev_warn(dev, fmt, ##arg)
> +#define  pl_dev_err(dev, fmt, arg...) dev_err(dev, fmt, ##arg)

Seems completely pointless.
Debugging output should be at KERN_DEBUG

> +#else
> +#define pl_dev_info(dev, fmt, arg...) (void)(dev)
> +#define pl_dev_warn(dev, fmt, arg...) (void)(dev)
> +#define  pl_dev_err(dev, fmt, arg...) (void)(dev)
> +#endif
> +#endif
> diff --git a/drivers/net/wireless/purelifi/mac.c b/drivers/net/wireless/purelifi/mac.c
[]
> +int purelifi_mac_init_hw(struct ieee80211_hw *hw)
> +{
> +	int r;
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_chip *chip = &mac->chip;
> +
> +	r = purelifi_chip_init_hw(chip);
> +	if (r) {
> +		pl_dev_warn(purelifi_mac_dev(mac), "%s::purelifi_chip_init_hw	failed. (%d)\n",
> +			    __func__, r);

Odd double colon with odd spacing too.

> +		goto out;
> +	}
> +	PURELIFI_ASSERT(!irqs_disabled());
> +
> +	r = regulatory_hint(hw->wiphy, "CA");
> +out:
> +	return r;
> +}
> +
> +void purelifi_mac_release(struct purelifi_mac *mac)
> +{
> +	purelifi_chip_release(&mac->chip);
> +	lockdep_assert_held(&mac->lock);
> +}
> +
> +int purelifi_op_start(struct ieee80211_hw *hw)
> +{
> +	regulatory_hint(hw->wiphy, "EU");
> +	purelifi_hw_mac(hw)->chip.usb.initialized = 1;
> +	return 0;
> +}
> +
> +void purelifi_op_stop(struct ieee80211_hw *hw)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_chip *chip = &mac->chip;
> +	struct sk_buff *skb;
> +	struct sk_buff_head *ack_wait_queue = &mac->ack_wait_queue;
> +
> +	pl_dev_info(purelifi_mac_dev(mac), "%s", __func__);

Unnecessary as ftrace works well

[]

> +static int fill_ctrlset(struct purelifi_mac *mac, struct sk_buff *skb)
> +{
> +	unsigned int frag_len = skb->len;
> +	unsigned int tmp;
> +	struct purelifi_ctrlset *cs;
> +
> +	if (skb_headroom(skb) >= sizeof(struct purelifi_ctrlset)) {
> +		cs = (struct purelifi_ctrlset *)skb_push(skb,
> +				sizeof(struct purelifi_ctrlset));
> +	} else {
> +		pl_dev_info(purelifi_mac_dev(mac), "Not enough hroom(1)\n");
> +		return 1;
> +	}

Reverse the test please

	if (skb_headroom(skb) < sizeof(struct purelifi_ctrlset)) {
		pl_dev_info(purelifi_mac_dev(mac), "Not enough hroom(1)\n");
		return 1;
	}

	cs = (struct purelifi_ctrlset *)skb_push(skb, sizeof(struct purelifi_ctrlset));

> +
> +	cs->id = USB_REQ_DATA_TX;
> +	cs->payload_len_nw = frag_len;
> +	cs->len = cs->payload_len_nw + sizeof(struct purelifi_ctrlset)
> +		- sizeof(cs->id) - sizeof(cs->len);

[]

> +	/*check if 32 bit aligned */
> +	tmp = skb->len & 3;
> +	if (tmp) {
> +		if (skb_tailroom(skb) >= (3 - tmp)) {
> +			skb_put(skb, 4 - tmp);
> +		} else {
> +			if (skb_headroom(skb) >= 4 - tmp) {
> +				u8 len;
> +				u8 *src_pt;
> +				u8 *dest_pt;
> +
> +				len = skb->len;
> +				src_pt = skb->data;
> +				dest_pt = skb_push(skb, 4 - tmp);
> +				memcpy(dest_pt, src_pt, len);
> +			} else {
> +				return 1;

and reverse the test here and use and unindent

> +			}
> +		}
> +		cs->len +=  4 - tmp;
> +	}
> +
> +	//check if not multiple of 512
> +	tmp = skb->len & 0x1ff;
> +	if (!tmp) {
> +		if (skb_tailroom(skb) >= 4) {
> +			skb_put(skb, 4);
> +		} else {
> +			if (skb_headroom(skb) >= 4) {
> +				u8 len = skb->len;
> +				u8 *src_pt = skb->data;
> +				u8 *dest_pt = skb_push(skb, 4);
> +
> +				memcpy(dest_pt, src_pt, len);
> +			} else {
> +				/* should never happen b/c
> +				 * sufficient headroom was reserved
> +				 */
> +				return 1;
> +			}
> +		}
> +

and here

[]

> +static int purelifi_op_add_interface(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +
> +	pl_dev_info(purelifi_mac_dev(mac), "%s\n", __func__);
> +
> +	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
> +		return -EOPNOTSUPP;
> +
> +	switch (vif->type) {
> +	case NL80211_IFTYPE_MONITOR:
> +		pl_dev_info(purelifi_mac_dev(mac),
> +			    "%s::NL80211_IFTYPE_MONITOR\n",
> +				__func__);
> +		break;
> +	case NL80211_IFTYPE_MESH_POINT:
> +		pl_dev_info(purelifi_mac_dev(mac),
> +			    "%s::NL80211_IFTYPE_MESH_POINT\n",
> +				__func__);
> +		break;
> +	case NL80211_IFTYPE_STATION:
> +		pl_dev_info(purelifi_mac_dev(mac),
> +			    "%s::NL80211_IFTYPE_STATION\n",
> +				__func__);
> +		break;
> +	case NL80211_IFTYPE_ADHOC:
> +		pl_dev_info(purelifi_mac_dev(mac),
> +			    "%s::NL80211_IFTYPE_ADHOC\n",
> +				__func__);
> +		break;
> +	case NL80211_IFTYPE_AP:
> +		pl_dev_info(purelifi_mac_dev(mac),
> +			    "%s::vif->type=NL80211_IFTYPE_AP\n",
> +				__func__);
> +		break;

Create and use a lookup table and use a single
output

> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +	mac->type = vif->type;
> +	mac->vif = vif;
> +	return 0;
> +}
> 
[]
> +static void purelifi_get_et_stats(struct ieee80211_hw *hw,
> +				  struct ieee80211_vif *vif,
> +		struct ethtool_stats *stats, u64 *data)

odd alignment.

Didn't look at the rest

