Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624CC51FE3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbfFYAYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:24:21 -0400
Received: from pb-smtp1.pobox.com ([64.147.108.70]:60933 "EHLO
        pb-smtp1.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728707AbfFYAYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:24:21 -0400
Received: from pb-smtp1.pobox.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id B144B166BE8;
        Mon, 24 Jun 2019 20:24:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=r+2vjC+8qYvx
        HZ84MVBNXT/hDG4=; b=O0VuT9wZ72iFZZ/b9C//DMGpe6ZZgdGq4fv62raKskLq
        Oo61S+/rij+Ewbuwf71XAsqYx5aB1czewvr9dmc5IUOmC5G2ryumNn8fhXtG9U26
        YNnuZfaBA9NF0FGPqyuF6B65+UaBXqYqQA5x4crYkh87iIzIbJuhFCFgw6yTuzM=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=UpzZkQ
        LII21HIs/ulvwXSG/G8X3Wt1TzO5MVKalnQk9wRKUWHPnISAh9wZTzRileMlo3k/
        msaqxR663keGrMwmpMGUTMzHIBNk5H9tmWHT0BhHG6EYiuAPV8DxfXOVLFRk3Yut
        aZlnmBGw3ggPHfpwloB7jYHUc9HcxT20cCF+c=
Received: from pb-smtp1.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id A7848166BE7;
        Mon, 24 Jun 2019 20:24:20 -0400 (EDT)
Received: from [192.168.1.134] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp1.pobox.com (Postfix) with ESMTPSA id 88C3B166BE6;
        Mon, 24 Jun 2019 20:24:16 -0400 (EDT)
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: mt7530: Add
 mediatek,ephy-handle to isolate external phy
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc:     sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        vivien.didelot@gmail.com, frank-w@public-files.de,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-6-opensource@vdorst.com>
 <20190624215248.GC31306@lunn.ch>
From:   Daniel Santos <daniel.santos@pobox.com>
Message-ID: <2a421ed9-94ed-a454-29c2-f52f6a070a70@pobox.com>
Date:   Mon, 24 Jun 2019 19:22:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624215248.GC31306@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 914C6F74-96DF-11E9-9D5E-46F8B7964D18-06139138!pb-smtp1.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 4:52 PM, Andrew Lunn wrote:
>> +static int mt7530_isolate_ephy(struct dsa_switch *ds,
>> +			       struct device_node *ephy_node)
>> +{
>> +	struct phy_device *phydev =3D of_phy_find_device(ephy_node);
>> +	int ret;
>> +
>> +	if (!phydev)
>> +		return 0;
>> +
>> +	ret =3D phy_modify(phydev, MII_BMCR, 0, (BMCR_ISOLATE | BMCR_PDOWN))=
;
> genphy_suspend() does what you want.
>
>> +	if (ret)
>> +		dev_err(ds->dev, "Failed to put phy %s in isolation mode!\n",
>> +			ephy_node->full_name);
>> +	else
>> +		dev_info(ds->dev, "Phy %s in isolation mode!\n",
>> +			 ephy_node->full_name);
> No need to clog up the system with yet more kernel messages.
>
>    Andrew
>
Yes, keep in mind that many mt7530-based devices have a 56k serial
console that gets ring buffer spew.=C2=A0 This created a real problem on =
the
mt7620 wifi drivers when they spewed every time a packet needed to be
dropped.=C2=A0 So at the very least, for any message that can be spammed,
rate limit it please.

Daniel
