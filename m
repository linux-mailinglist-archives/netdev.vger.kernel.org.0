Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35054D1936
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245301AbiCHNdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCHNdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:33:33 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641B9DF53
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 05:32:35 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id q10so12328457ljc.7
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 05:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=k8yxLA7LareC0TmYFSD6UqZuitbsoFI/UEhne5Mx0sM=;
        b=L9E813x8Hh14OoFMPPFVyo9IZHi2hVyvS/ej/Jl3KSjRwgdT40455UJ7/1FYzednE1
         d9F/Yc5ortg1swi1mfeeJ21I2JTakQ6ulnYg0c+1GToOQHsVLpp0IWYsANFGJCd0b+js
         GcjkikFbfJq7ctsarnvsXTUzGo1QvzMx6iv4OPhZN9H4ZNnbajhCXEkYEXlhWP/rFPBe
         1HHSMyMdwmXZnjF7YVgbgmgg6eoJUf+8Zi6Il9snJmiPJuRxXZN1zuBadMqTurPw9YYZ
         D6ra8CgUk7efLvlpFpsWnG6slvMNS86Ah4AY1GKAFhr483pMhDa00SDH+mFYb7jgZeX4
         ZLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=k8yxLA7LareC0TmYFSD6UqZuitbsoFI/UEhne5Mx0sM=;
        b=GbE6mER5iEjG0Z9Ui8y31quQgV8gCbFIDYtwgOFuIcwnWW/uD3Mg4CeLWnLRNnccn/
         xGYqRVPooM842dUbZywyjgI0GV8Ic0Lo5G4VrvNiPURqRQpBOscLu4AIEye8L5lupSoH
         pcdIDi6dY+4BMU2lsOSA84YklbYJUocnKh9otQ8VlupnI/UddfyC9X4wH3p+giedjiT2
         MJOpKCa12ksGWyH90JuQvus5SVhKg60S9l6fJZkJ4gZINSeFefsUP3udzFup0P+xjJne
         P7TyNZQMCsx1stabeWqHLpkfGij5Kw3J/kh0AkbZF0Y4gYU7S/oAFMI7wCCp76JB85iR
         eZfA==
X-Gm-Message-State: AOAM533t17YN8tn3yywufi+06GMeIbT9KT2TVCg7NnFS/MKCiIyockbX
        HpJmZXUX6thSBaidAkNaaqWN5g==
X-Google-Smtp-Source: ABdhPJyeQp5Y4jSAKIv3GuyIQmKr9IifBO3AmG3UpUOVV1BYoz+Yf9qOcFonOkdF1e0NjJRj+D5kQA==
X-Received: by 2002:a05:651c:516:b0:247:a27c:60fd with SMTP id o22-20020a05651c051600b00247a27c60fdmr10829139ljp.73.1646746353656;
        Tue, 08 Mar 2022 05:32:33 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id k3-20020a05651239c300b00443c5f9175bsm3478818lfu.46.2022.03.08.05.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:32:33 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_dsa: Fix tx from VLAN uppers on
 non-filtering bridges
In-Reply-To: <20220308093653.c2enspat5mvah4n3@skbuf>
References: <20220307110548.812455-1-tobias@waldekranz.com>
 <20220308093653.c2enspat5mvah4n3@skbuf>
Date:   Tue, 08 Mar 2022 14:32:32 +0100
Message-ID: <87v8womuxb.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 11:36, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 07, 2022 at 12:05:48PM +0100, Tobias Waldekranz wrote:
>> In this situation (VLAN filtering disabled on br0):
>> 
>>     br0.10
>>      /
>>    br0
>>    / \
>> swp0 swp1
>> 
>> When a frame is transmitted from the VLAN upper, the bridge will send
>> it down to one of the switch ports with forward offloading
>> enabled. This will cause tag_dsa to generate a FORWARD tag. Before
>> this change, that tag would have it's VID set to 10, even though VID
>> 10 is not loaded in the VTU.
>> 
>> Before the blamed commit, the frame would trigger a VTU miss and be
>> forwarded according to the PVT configuration. Now that all fabric
>> ports are in 802.1Q secure mode, the frame is dropped instead.
>> 
>> Therefore, restrict the condition under which we rewrite an 802.1Q tag
>> to a DSA tag. On standalone port's, reuse is always safe since we will
>> always generate FROM_CPU tags in that case. For bridged ports though,
>> we must ensure that VLAN filtering is enabled, which in turn
>> guarantees that the VID in question is loaded into the VTU.
>> 
>> Fixes: d352b20f4174 ("net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports")
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  net/dsa/tag_dsa.c | 15 ++++++++++++---
>>  1 file changed, 12 insertions(+), 3 deletions(-)
>> 
>> diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
>> index c8b4bbd46191..e4b6e3f2a3db 100644
>> --- a/net/dsa/tag_dsa.c
>> +++ b/net/dsa/tag_dsa.c
>> @@ -127,6 +127,7 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>>  				   u8 extra)
>>  {
>>  	struct dsa_port *dp = dsa_slave_to_port(dev);
>> +	struct net_device *br_dev;
>>  	u8 tag_dev, tag_port;
>>  	enum dsa_cmd cmd;
>>  	u8 *dsa_header;
>> @@ -149,7 +150,16 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
>>  		tag_port = dp->index;
>>  	}
>>  
>> -	if (skb->protocol == htons(ETH_P_8021Q)) {
>> +	br_dev = dsa_port_bridge_dev_get(dp);
>> +
>> +	/* If frame is already 802.1Q tagged, we can convert it to a DSA
>> +	 * tag (avoiding a memmove), but only if the port is standalone
>> +	 * (in which case we always send FROM_CPU) or if the port's
>> +	 * bridge has VLAN filtering enabled (in which case the CPU port
>> +	 * will be a member of the VLAN).
>> +	 */
>> +	if (skb->protocol == htons(ETH_P_8021Q) &&
>> +	    (!br_dev || br_vlan_enabled(br_dev))) {
>
> Conservative patch. If !br_dev, we could/should inject using
> MV88E6XXX_VID_STANDALONE. But since we use FROM_CPU, the classified VLAN
> probably does not make a difference that I can see, so there is no
> reason to change this now (and certainly not in the same patch).

We could also do that. My reasoning was:
1. There is no functional difference with a FROM_CPU frame - the CPU's
   word is law.
2. Performance should be better since you can avoid a per-packet memmove
   to make room for the tag, if the non-ethertyped version of DSA is
   used.
