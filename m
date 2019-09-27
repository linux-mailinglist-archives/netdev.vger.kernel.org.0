Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3653BC0518
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 14:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfI0MZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 08:25:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfI0MZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 08:25:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2A637Ahb7qsdDwnyq8c53qGLerD/lC6vZKHQyGPDsL0=; b=q2Vwahk68ubauaodCKHiiqHyeQ
        0ssEzYEvHW4NU+kyLDdS+sn4TEFHVlWLxa0Td6qFXJ8Nl41qkUw8WPjYPQOEXlEMd0X9UZS1Q1E9d
        rcWAEVyl6Z/qiDhC4D3KyHhtARTLKsONPJ95Yuzz/A6JJB2wN2D71+PAsczB7MuRT/rs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iDpJG-0001eM-BA; Fri, 27 Sep 2019 14:25:18 +0200
Date:   Fri, 27 Sep 2019 14:25:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     vincent.cheng.xh@renesas.com
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, richardcochran@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ptp: Add a ptp clock driver for IDT ClockMatrix.
Message-ID: <20190927122518.GA25474@lunn.ch>
References: <1569556128-22212-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1569556128-22212-2-git-send-email-vincent.cheng.xh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1569556128-22212-2-git-send-email-vincent.cheng.xh@renesas.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static s32 idtcm_xfer(struct idtcm *idtcm,
> +		      u8 regaddr,
> +		      u8 *buf,
> +		      u16 count,
> +		      bool write)
> +{
> +	struct i2c_client *client = idtcm->client;
> +	struct i2c_msg msg[2];
> +	s32 cnt;
> +
> +	msg[0].addr = client->addr;
> +	msg[0].flags = 0;
> +	msg[0].len = 1;
> +	msg[0].buf = &regaddr;
> +
> +	msg[1].addr = client->addr;
> +	msg[1].flags = write ? 0 : I2C_M_RD;
> +	msg[1].len = count;
> +	msg[1].buf = buf;
> +
> +	cnt = i2c_transfer(client->adapter, msg, 2);
> +
> +	if (cnt < 0) {
> +		dev_err(&client->dev, "i2c_transfer returned %d\n", cnt);
> +		return cnt;
> +	} else if (cnt != 2) {
> +		dev_err(&client->dev,
> +			"i2c_transfer sent only %d of %d messages\n", cnt, 2);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static s32 idtcm_page_offset(struct idtcm *idtcm, u8 val)
> +{
> +	u8 buf[4];
> +	s32 err;

Hi Vincent

All your functions return s32, rather than the usual int. err is an
s32.  i2c_transfer() will return an int, which you then assign to an
s32.  I've no idea, but maybe the static code checkers like smatch
will complain about this, especially on 64 bit systems? I suspect on
64 bit machines, the compiler will be generating worse code, masking
registers? Maybe use int, not s32?

> +static s32 set_pll_output_mask(struct idtcm *idtcm, u16 addr, u8 val)
> +{
> +	s32 err = 0;
> +
> +	switch (addr) {
> +	case OUTPUT_MASK_PLL0_ADDR:
> +		SET_U16_LSB(idtcm->channel[0].output_mask, val);
> +		break;
> +	case OUTPUT_MASK_PLL0_ADDR + 1:
> +		SET_U16_MSB(idtcm->channel[0].output_mask, val);
> +		break;
> +	case OUTPUT_MASK_PLL1_ADDR:
> +		SET_U16_LSB(idtcm->channel[1].output_mask, val);
> +		break;
> +	case OUTPUT_MASK_PLL1_ADDR + 1:
> +		SET_U16_MSB(idtcm->channel[1].output_mask, val);
> +		break;
> +	case OUTPUT_MASK_PLL2_ADDR:
> +		SET_U16_LSB(idtcm->channel[2].output_mask, val);
> +		break;
> +	case OUTPUT_MASK_PLL2_ADDR + 1:
> +		SET_U16_MSB(idtcm->channel[2].output_mask, val);
> +		break;
> +	case OUTPUT_MASK_PLL3_ADDR:
> +		SET_U16_LSB(idtcm->channel[3].output_mask, val);
> +		break;
> +	case OUTPUT_MASK_PLL3_ADDR + 1:
> +		SET_U16_MSB(idtcm->channel[3].output_mask, val);
> +		break;
> +	default:
> +		err = -1;

EINVAL?

> +		break;
> +	}
> +
> +	return err;
> +}

> +static void set_default_function_pointers(struct idtcm *idtcm)
> +{
> +	idtcm->_idtcm_gettime = _idtcm_gettime;
> +	idtcm->_idtcm_settime = _idtcm_settime;
> +	idtcm->_idtcm_rdwr = idtcm_rdwr;
> +	idtcm->_sync_pll_output = sync_pll_output;
> +}

Why does this indirection? Are the SPI versions of the silicon?

    Andrew
