Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7B4EC9B0
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfKAUfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:35:16 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60230 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfKAUfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 16:35:16 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA1KZ74i032411;
        Fri, 1 Nov 2019 15:35:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572640507;
        bh=p+dfw3N+D1l1+xg4adawidJ2KJs+uoZqMzJER8QjWMw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=syh5xEUH/Q+eMM74SOHx9Spca5PozuY0lLj2Ec25f6OIfNp9ZrEbOizjjA+3pjL15
         6tWF1rgOf63z0Bl/3E++z+QNiPsj0Zc5HxuGpKQDolfdUeJYHEPZpzafZB3RRV7jHl
         7Rg+PRbQiFqeVtiQmkPTH/iMjo7WCMAW5GLCT+zE=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA1KZ6Zs124477
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Nov 2019 15:35:07 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 1 Nov
 2019 15:34:53 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 1 Nov 2019 15:35:06 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA1KZ3jC119024;
        Fri, 1 Nov 2019 15:35:04 -0500
Subject: Re: [PATCH v5 net-next 06/12] net: ethernet: ti: introduce cpsw
 switchdev based driver part 1 - dual-emac
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-7-grygorii.strashko@ti.com>
 <20191029123230.GM15259@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <24b1623d-48df-328a-eda7-4195e9df2b22@ti.com>
Date:   Fri, 1 Nov 2019 22:34:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029123230.GM15259@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/10/2019 14:32, Andrew Lunn wrote:
>> +static int cpsw_probe(struct platform_device *pdev)
>> +{
>> +	const struct soc_device_attribute *soc;
>> +	struct device *dev = &pdev->dev;
>> +	struct resource *ss_res;
>> +	struct cpsw_common *cpsw;
>> +	struct gpio_descs *mode;
>> +	void __iomem *ss_regs;
>> +	int ret = 0, ch;
>> +	struct clk *clk;
>> +	int irq;
>> +
> 
> ...
> 
>> +
>> +	/* setup netdevs */
>> +	ret = cpsw_create_ports(cpsw);
>> +	if (ret)
>> +		goto clean_unregister_netdev;
> 
> At this point, the slave ports go live. If the kernel is configured
> with NFS root etc, it will start using the interfaces.
> 
> +
>> +	/* Grab RX and TX IRQs. Note that we also have RX_THRESHOLD and
>> +	 * MISC IRQs which are always kept disabled with this driver so
>> +	 * we will not request them.
>> +	 *
>> +	 * If anyone wants to implement support for those, make sure to
>> +	 * first request and append them to irqs_table array.
>> +	 */
>> +
>> +	ret = devm_request_irq(dev, cpsw->irqs_table[0], cpsw_rx_interrupt,
>> +			       0, dev_name(dev), cpsw);
>> +	if (ret < 0) {
>> +		dev_err(dev, "error attaching irq (%d)\n", ret);
>> +		goto clean_unregister_netdev;
>> +	}
>> +
>> +	ret = devm_request_irq(dev, cpsw->irqs_table[1], cpsw_tx_interrupt,
>> +			       0, dev_name(dev), cpsw);
>> +	if (ret < 0) {
>> +		dev_err(dev, "error attaching irq (%d)\n", ret);
>> +		goto clean_unregister_netdev;
>> +	}
> 
> Are there any race conditions if the network starts using the devices
> before interrupts are requested? To be safe, maybe this should be done
> before the slaves are created?

Usually during boot - there is no parallel probing (as opposite to modules loading by
udev, for example). Also, there is barrier init call deferred_probe_initcall() to ensure all
drivers probed before going to mount rootfs.

So, i do not think this could cause any issue - max few packets will be delayed
until kernel will switch back here, but the chances that ndo_open will be finished before probe ->0.

-- 
Best regards,
grygorii
