Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7350E4B059
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 05:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbfFSDHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 23:07:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38822 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfFSDHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 23:07:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AixH9ESZvfDH28I8mSEmpRr0X0vbsD2WpNmHZWsXSvo=; b=G096vJ/mvORPe5syshMT/McfRZ
        GQp7+YgCBOxqh8/3F+cgK5JMNRkAEoQwr4UecZfmws1MCx8AnFA2l2UY08LjW4wTUP2jgHHHggG7Y
        bkPv+0VdzdcqH1BxqcBzDu6koTwDzPi62OvZG1Sm9S5M2jSnXoXOT5equNJ/KCaur08M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hdQwb-000725-Ue; Wed, 19 Jun 2019 05:07:29 +0200
Date:   Wed, 19 Jun 2019 05:07:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [RFC net-next 1/5] net: stmmac: introduce IEEE 802.1Qbv
 configuration functionalities
Message-ID: <20190619030729.GA26784@lunn.ch>
References: <1560893778-6838-1-git-send-email-weifeng.voon@intel.com>
 <1560893778-6838-2-git-send-email-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560893778-6838-2-git-send-email-weifeng.voon@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 05:36:14AM +0800, Voon Weifeng wrote:

Hi Voon

> +static int est_poll_srwo(void *ioaddr)
> +{
> +	/* Poll until the EST GCL Control[SRWO] bit clears.
> +	 * Total wait = 12 x 50ms ~= 0.6s.
> +	 */
> +	unsigned int retries = 12;
> +	unsigned int value;
> +
> +	do {
> +		value = TSN_RD32(ioaddr + MTL_EST_GCL_CTRL);
> +		if (!(value & MTL_EST_GCL_CTRL_SRWO))
> +			return 0;
> +		msleep(50);
> +	} while (--retries);
> +
> +	return -ETIMEDOUT;

Maybe use one of the readx_poll_timeout() macros?

> +static int est_read_gce(void *ioaddr, unsigned int row,
> +			unsigned int *gates, unsigned int *ti_nsec,
> +			unsigned int dbgb, unsigned int dbgm)
> +{
> +	struct tsn_hw_cap *cap = &dw_tsn_hwcap;
> +	unsigned int ti_wid = cap->ti_wid;
> +	unsigned int gates_mask;
> +	unsigned int ti_mask;
> +	unsigned int value;
> +	int ret;
> +
> +	gates_mask = (1 << cap->txqcnt) - 1;
> +	ti_mask = (1 << ti_wid) - 1;
> +
> +	ret = est_read_gcl_config(ioaddr, &value, row, 0, dbgb, dbgm);
> +	if (ret) {
> +		TSN_ERR("Read GCE failed! row=%u\n", row);

It is generally not a good idea to put wrappers around the kernel
print functions. It would be better if all these functions took struct
stmmac_priv *priv rather than ioaddr, so you could then do

	netdev_err(priv->dev, "Read GCE failed! row=%u\n", row);

> +	/* Ensure that HW is not in the midst of GCL transition */
> +	value = TSN_RD32(ioaddr + MTL_EST_CTRL);

Also, don't put wrapper around readl()/writel().

> +	value &= ~MTL_EST_CTRL_SSWL;
> +
> +	/* MTL_EST_CTRL value has been read earlier, if TILS value
> +	 * differs, we update here.
> +	 */
> +	if (tils != dw_tsn_hwtunable[TSN_HWTUNA_TX_EST_TILS]) {
> +		value &= ~MTL_EST_CTRL_TILS;
> +		value |= (tils << MTL_EST_CTRL_TILS_SHIFT);
> +
> +		TSN_WR32(value, ioaddr + MTL_EST_CTRL);
> +		dw_tsn_hwtunable[TSN_HWTUNA_TX_EST_TILS] = tils;
> +	}
> +
> +	return 0;
> +}
> +
> +static int est_set_ov(void *ioaddr,
> +		      const unsigned int *ptov,
> +		      const unsigned int *ctov)
> +{
> +	unsigned int value;
> +
> +	if (!dw_tsn_feat_en[TSN_FEAT_ID_EST])
> +		return -ENOTSUPP;
> +
> +	value = TSN_RD32(ioaddr + MTL_EST_CTRL);
> +	value &= ~MTL_EST_CTRL_SSWL;
> +
> +	if (ptov) {
> +		if (*ptov > EST_PTOV_MAX) {
> +			TSN_WARN("EST: invalid PTOV(%u), max=%u\n",
> +				 *ptov, EST_PTOV_MAX);

It looks like most o the TSN_WARN should actually be netdev_dbg().

   Andrew
