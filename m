Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FEA924F0
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 15:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfHSN1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 09:27:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfHSN1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 09:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UyJXh5G4lCxvf58D0NEKhzaJuQrSIL3MtD7HQ1EPJX8=; b=zyzsLyF90TE2rKMmt9lxn5jqDK
        DOFTgMMkek8YBO0CRR/+2+DzHpUyu6E1G1Wqr1JeMzOraCl3JsxZQD0vuCGoL1u8AsZvq+x58UGMZ
        DWPCqJSF7jTFJWVF+sGluX7dqSOnKDQB8q8v1wWHUawe/0zgg/tzY76PpXePhT+9+7OQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hzhh7-00060z-7Y; Mon, 19 Aug 2019 15:27:33 +0200
Date:   Mon, 19 Aug 2019 15:27:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/3] net: dsa: mv88e6xxx: extend PTP gettime
 function to read system clock
Message-ID: <20190819132733.GE8981@lunn.ch>
References: <20190816163157.25314-1-h.feurstein@gmail.com>
 <20190816163157.25314-3-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816163157.25314-3-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -45,7 +45,8 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
>  {
>  	int ret;
>  
> -	ret = mdiobus_write_nested(chip->bus, dev, reg, data);
> +	ret = mdiobus_write_sts_nested(chip->bus, dev, reg, data,
> +				       chip->ptp_sts);
>  	if (ret < 0)
>  		return ret;
>  

Please also make a similar change to mv88e6xxx_smi_indirect_write().
The last write in that function should be timestamped.

Vivien, please could you think about these changes with respect to
RMU. We probably want to skip the RMU in this case, so we get slow but
uniform jitter, vs fast and unpredictable jitter from using the RMU.

Thanks
	Andrew
