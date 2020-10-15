Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8428328FB40
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 00:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731753AbgJOWff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 18:35:35 -0400
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:53364 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731532AbgJOWfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 18:35:34 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 3B82A18224D67;
        Thu, 15 Oct 2020 22:35:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1543:1593:1594:1605:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3872:4321:4605:5007:7903:8957:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12555:12679:12740:12760:12895:13095:13255:13439:14659:14721:21080:21099:21433:21451:21627:21740:21966:21990:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: brain28_400fe9827218
X-Filterd-Recvd-Size: 5035
Received: from XPS-9350 (unknown [172.58.35.12])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Thu, 15 Oct 2020 22:35:30 +0000 (UTC)
Message-ID: <cb5dce0a645418d1cbab93448a15d8c3109d9990.camel@perches.com>
Subject: Re: [PATCH] [PATCH] [v3] wireless: Initial driver submission for
 pureLiFi STA devices
From:   Joe Perches <joe@perches.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Date:   Thu, 15 Oct 2020 15:35:26 -0700
In-Reply-To: <20201014061934.22586-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
         <20201014061934.22586-1-srini.raju@purelifi.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-14 at 11:49 +0530, Srinivasan Raju wrote:
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.

trivia: netdev_<level> might be better than dev_<level>.

> diff --git a/drivers/net/wireless/purelifi/chip.c b/drivers/net/wireless/purelifi/chip.c
[]
> +int purelifi_chip_switch_radio(struct purelifi_chip *chip, u32 value)
> +{
> +	int r;
> +
> +	r = usb_write_req((const u8 *)&value, sizeof(value), USB_REQ_POWER_WR);
> +	if (r)
> +		dev_err(purelifi_chip_dev(chip), "%s r=%d", __func__, r);

missing '\n' termination.

[]

> > +int purelifi_chip_set_rate(struct purelifi_chip *chip, u8 rate)
> +{
> +	int r;
> +	static struct purelifi_chip *chip_p;
> +
> +	if (chip)
> +		chip_p = chip;
> +	if (!chip_p)
> +		return -EINVAL;
> +
> +	r = usb_write_req((const u8 *)&rate, sizeof(rate), USB_REQ_RATE_WR);
> +	if (r)
> +		dev_err(purelifi_chip_dev(chip), "set rate failed r=%d", r);

same missing newline, etc

It might also be better to use a consistent error message like

		dev_err(purelifi_chip_dev(chip), "%s: failed, r=%d\n", r);

for both.

> diff --git a/drivers/net/wireless/purelifi/mac.c b/drivers/net/wireless/purelifi/mac.c
[]
> +static const struct ieee80211_rate purelifi_rates[] = {
> +	{ .bitrate = 10,
> +		.hw_value = PURELIFI_CCK_RATE_1M, },

[]

> +	{ .bitrate = 60,
> +		.hw_value = PURELIFI_OFDM_RATE_6M,
> +		.flags = 0 },

Seems odd to set .flags to 0 for only some of the entries.
Perhaps more readable to always leave it off if unset.

> +	{ .bitrate = 90,
> +		.hw_value = PURELIFI_OFDM_RATE_9M,
> +		.flags = 0 },
> +	{ .bitrate = 120,
> +		.hw_value = PURELIFI_OFDM_RATE_12M,
> +		.flags = 0 },
> +	{ .bitrate = 180,
> +		.hw_value = PURELIFI_OFDM_RATE_18M,
> +		.flags = 0 },
> +	{ .bitrate = 240,
> +		.hw_value = PURELIFI_OFDM_RATE_24M,
> +		.flags = 0 },
> +	{ .bitrate = 360,
> +		.hw_value = PURELIFI_OFDM_RATE_36M,
> +		.flags = 0 },
> +	{ .bitrate = 480,
> +		.hw_value = PURELIFI_OFDM_RATE_48M,
> +		.flags = 0 },
> +	{ .bitrate = 540,
> +		.hw_value = PURELIFI_OFDM_RATE_54M,
> +		.flags = 0 },
> +};

[]
> +int purelifi_mac_init_hw(struct ieee80211_hw *hw)
> +{
> +	int r;
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct purelifi_chip *chip = &mac->chip;
> +
> +	r = purelifi_chip_init_hw(chip);
> +	if (r) {
> +		dev_warn(purelifi_mac_dev(mac), "init hw failed. (%d)\n", r);
> +		goto out;
> +	}
> +
> +	dev_dbg(purelifi_mac_dev(mac), "irq_disabled %d", irqs_disabled());

missing newline

> +static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
> +		      struct ieee80211_rx_status *stats)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	struct sk_buff *skb;
> +	struct sk_buff_head *q;
> +	unsigned long flags;
> +	int found = 0;
> +	int i, position = 0;
> +
> +	if (!ieee80211_is_ack(rx_hdr->frame_control))
> +		return 0;
> +	dev_info(purelifi_mac_dev(mac), "%s::ACK Received", __func__);

missing newline

> +static int purelifi_op_add_interface(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif)
> +{
> +	struct purelifi_mac *mac = purelifi_hw_mac(hw);
> +	static const char * const iftype80211[] = {
> +		[NL80211_IFTYPE_STATION]	= "Station",
> +		[NL80211_IFTYPE_ADHOC]		= "Adhoc"
> +	};
> +
> +	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
> +		return -EOPNOTSUPP;
> +
> +	if (vif->type == NL80211_IFTYPE_ADHOC ||
> +	    vif->type == NL80211_IFTYPE_STATION) {
> +		dev_info(purelifi_mac_dev(mac), "%s %s\n", __func__,
> +			 iftype80211[vif->type]);
> +		mac->type = vif->type;
> +		mac->vif = vif;
> +	} else {
> +		dev_info(purelifi_mac_dev(mac), "unsupported iftype");

etc...


