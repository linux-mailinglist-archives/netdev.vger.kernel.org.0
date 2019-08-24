Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A959BDB1
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 14:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfHXMdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 08:33:50 -0400
Received: from mx.0dd.nl ([5.2.79.48]:36012 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727921AbfHXMdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 08:33:50 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 9A8A25FBFB;
        Sat, 24 Aug 2019 14:33:48 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="DWANO3d4";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 5CC561D8B1CD;
        Sat, 24 Aug 2019 14:33:48 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 5CC561D8B1CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1566650028;
        bh=X8ATtyrMqmT/YMnCKVOUrBUJelm2/xxbILBBHnS4TAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DWANO3d4H8SO0dBLhQVfGgrUrMVK9Bf2ZmJQuUp69OmXDj+MJPhmCue+ENpt7H61c
         hwNAfZsrtHbOy53zH5uwmKK8HlR3quIGKtZGWK9oFlTENX0M6iQeko207s/kde+vZ7
         ZObJFzrTF4e4+OqlcX10rFjKqR5ZscMIU8ghiIcWBKnVgsuN5H8bQrCx/vJWyR9wUz
         ZszR7+W8v9bR5TGDdDxkQm9dKYilq6OZuxdd5tTRgcGag86HP90TP8ivUwNh0lFEZD
         bWnnz6QQC54UJ5HgyGhQGps9QqXQGnJsdZ77wDYgKgGuansdQwHik5gId/K6ZCHgho
         h2RdoB4njlRHQ==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sat, 24 Aug 2019 12:33:48 +0000
Date:   Sat, 24 Aug 2019 12:33:48 +0000
Message-ID: <20190824123348.Horde.LdDLM3_wpuexnof5e7L-q-2@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH net-next v3 1/3] net: ethernet: mediatek: Add basic
 PHYLINK support
References: <20190823134516.27559-1-opensource@vdorst.com>
 <20190823134516.27559-2-opensource@vdorst.com>
 <20190824091106.GC13294@shell.armlinux.org.uk>
In-Reply-To: <20190824091106.GC13294@shell.armlinux.org.uk>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:

> On Fri, Aug 23, 2019 at 03:45:14PM +0200, René van Dorst wrote:
>> This convert the basics to PHYLINK API.
>> SGMII support is not in this patch.
>>
>> Signed-off-by: René van Dorst <opensource@vdorst.com>
>> --
>> v2->v3:
>> * Make link_down() similar as link_up() suggested by Russell King
>
> Yep, almost there, but...
>
>> +static void mtk_mac_link_down(struct phylink_config *config,  
>> unsigned int mode,
>> +			      phy_interface_t interface)
>> +{
>> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
>> +					   phylink_config);
>> +	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
>>
>> +	mcr &= (MAC_MCR_TX_EN | MAC_MCR_RX_EN);
>
> ... this clears all bits _except_ for the tx and rx enable (which will
> remain set) - you probably wanted a ~ before the (.

Yes that is what it should be.
I only want to clear the TX_EN en RX_EN bits.

Greats,

René

>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up



