Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA05FF0BA
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfD3GyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:54:25 -0400
Received: from first.geanix.com ([116.203.34.67]:43048 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfD3GyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:54:24 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id F012D308E81;
        Tue, 30 Apr 2019 06:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556607257; bh=yq+1xy4tgXBdDFfNyxW4u0ZPJoYM/tD91IUKxtMYn9s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To;
        b=g9nHFwAaYsvYJAqAa/Xr5fAJkVcliOZU9wP2Yw+cn/qD4t9AQEe/QXmhqJYZwuxLv
         /s9WXHSLrG49VpNVAvMiSC70IprzsyNDRg+301+6I+/fcgr64Dr043aMreGY4SgBDE
         UQQSvCH2EKA4LAkpbmHTZkXy9lJNOAh+6dFge0vlNlL8ql7HfASHRmepNB5Ms/tnda
         Kbw56l9jxteps5hqg0DkVSvUiPj+JCAS+AH5BmsWIJ1C5SJ6rhjKinMzQ9jmWJhfDC
         w/YPV2ekrBfny3UBfRVCIu/KjfxdNLFwbaYsdfPTYfGZSmxy3BKxivNZihGUwZlXJJ
         P4Jt8c5ck0KZg==
From:   Esben Haabendal <esben@geanix.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] net: ll_temac: Support indirect_mutex share within TEMAC IP
References: <20190426073231.4008-1-esben@geanix.com>
        <20190429083422.4356-1-esben@geanix.com>
        <20190429083422.4356-8-esben@geanix.com>
        <20190429221204.GN12333@lunn.ch>
Date:   Tue, 30 Apr 2019 08:54:21 +0200
In-Reply-To: <20190429221204.GN12333@lunn.ch> (Andrew Lunn's message of "Tue,
        30 Apr 2019 00:12:04 +0200")
Message-ID: <87pnp4ouea.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

>> For OF devices, the xlnx,compound parent of the temac node should be
>> used to find siblings, and setup a shared indirect_mutex between them.
>> I will leave this work to somebody else, as I don't have hardware to
>> test that.  No regression is introduced by that, as before this commit
>> using two Ethernet interfaces in same TEMAC block is simply broken.
>
> Is that true?

Ouch, it was in v1.  But I messed up here in v2.  I will fix for v3.

>> @@ -1092,7 +1092,16 @@ static int temac_probe(struct platform_device *pdev)
>>  	lp->dev = &pdev->dev;
>>  	lp->options = XTE_OPTION_DEFAULTS;
>>  	spin_lock_init(&lp->rx_lock);
>> -	mutex_init(&lp->indirect_mutex);
>> +
>> +	/* Setup mutex for synchronization of indirect register access */
>> +	if (pdata) {
>> +		if (!pdata->indirect_mutex) {
>> +			dev_err(&pdev->dev,
>> +				"indirect_mutex missing in platform_data\n");
>> +			return -EINVAL;
>> +		}
>> +		lp->indirect_mutex = pdata->indirect_mutex;
>> +	}
>
> In the OF case, isn't lp->indirect_mutex now a NULL pointer, where as
> before it was a valid mutex?
>
> Or did i miss something somewhere?

No, you did not miss something.  But I did messed up the OF case in v2
of this series.  Sorry.

/Esben
