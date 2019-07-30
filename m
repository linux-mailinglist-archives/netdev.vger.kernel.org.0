Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06A879F48
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 05:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732696AbfG3DBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 23:01:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48912 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732655AbfG3DBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 23:01:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D20FC60735; Tue, 30 Jul 2019 03:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564455710;
        bh=qLG+AFgt1Bq+Rn7q/etUGp22vUaInsxCjOCbPJYjxL0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M14lkNFzta+HWw2YkgBHRWVbQo6pOrWiYY/dDXQvkJXWZy6exdhIAzyCU7+yhA64/
         Aq6V+Y3shcPt7CISnPBX5gZ6eUoT+/aqkmhnzZilLQq0tFE5wb6zTTaWumDBaSydYC
         pY0MKnRFxyb+FpQKcOauLYwZp3nmPgzlyAI8S338=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id D8748605A5;
        Tue, 30 Jul 2019 03:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564455706;
        bh=qLG+AFgt1Bq+Rn7q/etUGp22vUaInsxCjOCbPJYjxL0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M58wPsZttmvZFc3bbgUvZ/vAqT6AFW8ah8W8D4p2at+v+lHpvUDqAKy4yujOMTf6Q
         PPCcIcj/AJedDqcaTGtuCxQUHAUVjPtG04klaEkpZ686MYoJbPlYfU0n003B5kbEz0
         ROwkcOdm++yYUn+fQjtnxkciJp7Hc28UDHjHr5GU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 30 Jul 2019 11:01:45 +0800
From:   xiaofeis@codeaurora.org
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, vkoul@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH v3] net: dsa: qca8k: enable port flow control
In-Reply-To: <20190729132342.GA4110@lunn.ch>
References: <1564275470-52666-1-git-send-email-xiaofeis@codeaurora.org>
 <20190728223114.GD23125@lunn.ch>
 <fa444b03b42a2cb72037bc73a62f1976@codeaurora.org>
 <20190729132342.GA4110@lunn.ch>
Message-ID: <621f51b6e918b4926b04006aa115f7b4@codeaurora.org>
X-Sender: xiaofeis@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-29 21:23, Andrew Lunn wrote:
>> But our qca8k HW can auto sync the pause status to MAC from phy with 
>> the
>> auto-negotiated result.
>> So no need to set in qca8k_adjust_link, since there is one setting in
>> qca8k_port_set_status: mask |= QCA8K_PORT_STATUS_LINK_AUTO;
> 
> How does the auto-sync actually work? Does the MAC make MDIO reads to
> the PHY? That is generally unsafe, since some PHYs support pages, and
> the PHY driver might be using a different page while the MAC tries to
> access the auto-neg results.
> 
> Do any of the ports support an external PHY? The auto-sync might not
> work in that condition as well. Different register layout, c45 not
> c22, etc.
> 
> The safest option is to explicitly set the MAC flow configuration
> based on the values in phydev.
> 
Hi Andrew

To explicitly set the configuration is one option, but then we need 
disable QCA8K_PORT_STATUS_LINK_AUTO, and not only flow control,
speed/duplex all need to be set explicitly.

Here the qca8k driver is only support qca,qca8337/qca8334 switch family. 
The phy is internal phy. There is signals internaly
to sync the status from phy to mac directly which is HW specific 
implementation, it doesn't support to connect external phy.

Thanks
Xiaofeis
