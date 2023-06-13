Return-Path: <netdev+bounces-10441-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A8A72E834
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 18:19:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F367028106A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7789F3C0AB;
	Tue, 13 Jun 2023 16:19:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B26723DB
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:19:18 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6842E92;
	Tue, 13 Jun 2023 09:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=kSo7oxYAqeqzQOt2hOKeJJzZZSXVTeK57hiOvOHIciQ=; b=axPXUCBs4qxP5Eq6uAZ6LSiMiv
	ZM1H4K0fxuyqvb6mQmMwTYoYn2MC8ajhvI5l9CbSq2Us51zYo7BSziWZj0hZW66h5N/36k2/5z3Bt
	RsNPNlSK4HFvXz/ICq3lXjelSCDOJmVT1nMQevaVL3GcgaoR5fYaYVyiQB+Sr8OQcVcU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q96jT-00Fk4W-0P; Tue, 13 Jun 2023 18:18:59 +0200
Date: Tue, 13 Jun 2023 18:18:58 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jianhui Zhao <zhaojh329@gmail.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: phy: Add sysfs attribute for PHY c45 identifiers.
Message-ID: <612d5964-6034-4188-8da5-53f3f38a25e4@lunn.ch>
References: <20230613143025.111844-1-zhaojh329@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613143025.111844-1-zhaojh329@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +#define DEVICE_ATTR_C45_ID(i) \
> +static ssize_t \
> +phy_c45_id##i##_show(struct device *dev, \
> +	struct device_attribute *attr, char *buf) \
> +{ \
> +	struct phy_device *phydev = to_phy_device(dev); \
> +\
> +	if (!phydev->is_c45) \
> +		return 0; \
> +\
> +	return sprintf(buf, "0x%.8lx\n", \
> +		(unsigned long)phydev->c45_ids.device_ids[i]); \
> +} \

That is not the most efficient implementation.

You can have one generic

static ssize_t phy_c45_id_show(struct device *dev, char *buf, int i)
{
	struct phy_device *phydev = to_phy_device(dev);

	if (!phydev->is_c45)
		return 0;

	return sprintf(buf, "0x%.8lx\n",
		      (unsigned long)phydev->c45_ids.device_ids[i]);
}

And then your macros becomes

#define DEVICE_ATTR_C45_ID(i)			  \
static ssize_t					  \
phy_c45_id##i##_show(struct device *dev,	  \
	struct device_attribute *attr, char *buf) \
{						  \
	return phy_c45_id_show(dev, buf, i);	  \
}

	Andrew

---
pw-bot: cr

