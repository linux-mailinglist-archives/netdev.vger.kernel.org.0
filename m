Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB24275A41
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgIWOgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWOgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:36:53 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2110FC0613CE
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 07:36:53 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id u25so19179247otq.6
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 07:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qAnQ7INjdEc26304V05U/cX4MW85UayWuqBGgYign/c=;
        b=L9+XfPur1DpTXlCM5JhCVSSfxYRxQaUqSSbwcOuepYtxzryUfpbPCj7qlsqJTwtQwO
         c49nBlH8hfRGQVUo+AtbryTp/np0agbaDU5+hm5L7AVZEa3DDtu38zs1HE/Nl7aaPfMK
         PiKoJTw62lR/Jm8kprgAJP4Akcy+ZttvEWSRNHu7Bd7vFXk5iqLuGOs4ihrZzfId2y43
         Phb8J+Cz4CgWl35kPYt1N0LVigIBIdViPrLl6YfLijlYIwfEeH5NbTGqtGkpul/nB75S
         4B8mgErCNj7H6kE2YeRy3cwC4EKrxoZCB4oROoeN1IyOZ4MZQQ/Xe6L33YV+8I4lMARJ
         HTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qAnQ7INjdEc26304V05U/cX4MW85UayWuqBGgYign/c=;
        b=cHoioSoknJfaaquiOb2FZoXBQzp19e+D9GwaL/wAd9Bgq7PSEquDkg8q99CqwZu8o4
         AHxgt20ESB8tVf8gE+yl5X1y70Y2CGy0fJ+8szZE9Wv7Iyea83QtEmJGXNl24M9V7+IE
         O9Dtgkh3eZoy8bEXVIrGDmra3AdahNyDLGF6gdzWCc+/74UhlHmzwdDbaHkVSSw4cShq
         AQAOO4KS32Mprd61A5deOwmWu5RbBfeSOrDgwpimsnK8EQO54bTomZrvvtHJXKDBvIC2
         HwBNASA/D0Zb92eJi8qNImZ3PBa4RLxAqwZUnAiMnLH5PYwTek5BoxazDZK2RsMyDUnQ
         mVbA==
X-Gm-Message-State: AOAM5339yhqxTyJH/BRywYIjW+jVhxdkzlmQgj7UjtxMjG/Bd38iMKau
        WtxXh1uUsZ5svhht6C2VRa4=
X-Google-Smtp-Source: ABdhPJx1dKK3AahPadHjfW60Mu+PdPFAWkaHVqnCIm5YUIVE2zCtswVVdYT7ayl8cO3DfPOpnBdm9A==
X-Received: by 2002:a05:6830:10d5:: with SMTP id z21mr6631786oto.292.1600871812586;
        Wed, 23 Sep 2020 07:36:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:c57c:d249:9ad:da9f])
        by smtp.googlemail.com with ESMTPSA id w7sm9422766oon.2.2020.09.23.07.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 07:36:51 -0700 (PDT)
Subject: Re: [PATCH v2] net/ipv4: always honour route mtu during forwarding
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
References: <CANP3RGcTy5MyAyChUh7pTma60aLcBmOV4kKjh_OnGtBZag-gbg@mail.gmail.com>
 <20200923045143.3755128-1-zenczykowski@gmail.com>
 <10fbde1b-f852-2cc1-2e23-4c014931fed8@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e5c28c89-0022-69d2-8538-74c2c842a2fc@gmail.com>
Date:   Wed, 23 Sep 2020 08:36:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <10fbde1b-f852-2cc1-2e23-4c014931fed8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 2:46 AM, Eric Dumazet wrote:
>> diff --git a/include/net/ip.h b/include/net/ip.h
>> index b09c48d862cc..c2188bebbc54 100644
>> --- a/include/net/ip.h
>> +++ b/include/net/ip.h
>> @@ -436,12 +436,17 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
>>  						    bool forwarding)
>>  {
>>  	struct net *net = dev_net(dst->dev);
>> +	unsigned int mtu;
>>  
>>  	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
>>  	    ip_mtu_locked(dst) ||
>>  	    !forwarding)
>>  		return dst_mtu(dst);
>>  
>> +	/* 'forwarding = true' case should always honour route mtu */
>> +	mtu = dst_metric_raw(dst, RTAX_MTU);
>> +	if (mtu) return mtu;
> 
> 
>         if (mtu)
>                 return mtu;
> 
> Apparently route mtu are capped to 65520, not sure where it is done exactly IP_MAX_MTU being 65535)

ip_metrics_convert seems to be the place"
                if (type == RTAX_MTU && val > 65535 - 15)
                        val = 65535 - 15;

going back through the code moves, and it was added by Dave with
710ab6c03122c

> 
> # ip ro add 1.1.1.4 dev wlp2s0 mtu 100000
> # ip ro get 1.1.1.4
> 1.1.1.4 dev wlp2s0 src 192.168.8.147 uid 0 
>     cache mtu 65520 
> 
> 
> 
> 
>> +
>>  	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
>>  }
>>  
>>

