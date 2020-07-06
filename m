Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6C8215174
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 06:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgGFEYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 00:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgGFEYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 00:24:51 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF0BC061794;
        Sun,  5 Jul 2020 21:24:51 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f2so14829016plr.8;
        Sun, 05 Jul 2020 21:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NhQuh/M+EWr/H+2AN4zsqP1K1gI1NFzEkYpBnUNzwu8=;
        b=tzabOV92NsrmrViHXK0nWYnzKyxMnXybz1c5LHrpbDZvsULkOEjoUwyg0SEJZWfv2j
         ke044ICDxjqm31S6SUtqUtsSNgikx9OupmoDwcqP4bmuxNg3IK1qbyy3SvLCR2/I2pur
         VxoNfSeScLptOrJjsstSIQo9lvVctL3xwjCOl0BpXU1wfF3hp3IWqZsRLp8zzqIqGJAK
         BzdKyAYWRXGcwRVo6Xb5F9dbkqkuQunR5ZZ/I/wk4eNu8OWhQ+ROPxtuaCJbZuj0Ga6i
         C3CW4lXhSdwsxT8A5EMFgsQGQs/5JFpeTr7wKEz4Wbdhzew5aHKRXnYJMH00J12AbpKe
         nIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NhQuh/M+EWr/H+2AN4zsqP1K1gI1NFzEkYpBnUNzwu8=;
        b=dgPFk/51CzJw8R9ZVRxcDygIgYefCG+chT1YaRoI9qCI/hERgKF8AK51jFryTSRyd9
         g3yez9UZcooGb/5AoF/5fLO1b7dr+JZVfssJ3856i0aK9QmnxMxhA/XqP3Z1a0HBF+EP
         K2XD7mbV62BaDVvVCDaFzQy0hXtsywDJbmy5VAmcBirqKjcp87fOygSxr4rE8kky0v8Y
         u45ohCddemDqlOiJyDgl+1hpH8yzl2TbRO4ctPmOJhxBctXnkitg1CS2wTVTii2A/jkd
         99oiy9TB4xo4nIDa0UmIpR/nQN090K/FdDQC5tysXYgr/SB8dKUxwAmUNvNBa/8e9lng
         zqOQ==
X-Gm-Message-State: AOAM532EYscvjbIBMpkcgMbTnWT9wgilWno87E+Bm1eyejEdBhbJsRpq
        K/VSn6ES8CJrpytPxK6zukM=
X-Google-Smtp-Source: ABdhPJyHCUXMwb1alkHT6aU83lgl85yKQ4N8yg8Bm1A7RfvY/tx7kGh5nrkaA6qdA1Cf5r2jzEe7Sw==
X-Received: by 2002:a17:902:684e:: with SMTP id f14mr11268525pln.166.1594009490929;
        Sun, 05 Jul 2020 21:24:50 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id d14sm298902pjc.20.2020.07.05.21.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 21:24:50 -0700 (PDT)
Subject: Re: [PATCH net v3] sched: consistently handle layer3 header accesses
 in the presence of VLANs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        cake@lists.bufferbloat.net, Davide Caratti <dcaratti@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Ilya Ponetayev <i.ponetaev@ndmsystems.com>
References: <20200703202643.12919-1-toke@redhat.com>
 <ada37763-16cd-7b51-f9ce-41e8d313bf96@gmail.com> <878sfzms4p.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <b62fcd67-1b0a-ab7f-850d-22e62faf3a23@gmail.com>
Date:   Mon, 6 Jul 2020 13:24:42 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <878sfzms4p.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/07/04 20:33, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>> On 2020/07/04 5:26, Toke Høiland-Jørgensen wrote:
>> ...
>>> +/* A getter for the SKB protocol field which will handle VLAN tags consistently
>>> + * whether VLAN acceleration is enabled or not.
>>> + */
>>> +static inline __be16 skb_protocol(const struct sk_buff *skb, bool skip_vlan)
>>> +{
>>> +	unsigned int offset = skb_mac_offset(skb) + sizeof(struct ethhdr);
>>> +	__be16 proto = skb->protocol;
>>> +
>>> +	if (!skip_vlan)
>>> +		/* VLAN acceleration strips the VLAN header from the skb and
>>> +		 * moves it to skb->vlan_proto
>>> +		 */
>>> +		return skb_vlan_tag_present(skb) ? skb->vlan_proto : proto;
>>> +
>>> +	while (eth_type_vlan(proto)) {
>>> +		struct vlan_hdr vhdr, *vh;
>>> +
>>> +		vh = skb_header_pointer(skb, offset, sizeof(vhdr), &vhdr);
>>> +		if (!vh)
>>> +			break;
>>> +
>>> +		proto = vh->h_vlan_encapsulated_proto;
>>> +		offset += sizeof(vhdr);
>>> +	}
>>
>> Why don't you use __vlan_get_protocol() here? It looks quite similar.
>> Is there any problem with using that?
> 
> TBH, I completely missed that helper. It seems to have side effects,
> though (pskb_may_pull()), which is one of the things the original patch
> to sch_cake that initiated all of this was trying to avoid.

Sorry for not completely following the discussion...
Pulling data is wrong for cake or other schedulers?

> I guess I could just fix that, though, and switch __vlan_get_protocol()
> over to using skb_header_pointer(). Will send a follow-up to do that.
> 
> Any opinion on whether it's a good idea to limit the max parse depth
> while I'm at it (see Daniel's reply)?

The logic was originally introduced by skb_network_protocol() back in v3.10,
and I have never heard of security report about that. But yes, I guess it
potentially can be used for DoS attack.

Toshiaki Makita
