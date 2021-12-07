Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E088C46BE30
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbhLGO4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:56:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237510AbhLGO4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 09:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638888774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tF1JpgNZ/kCs822lRUao4yCPouYho6b/UxZ2TAfYzz4=;
        b=HTwodjbsyOn6YWYRpLvG56s6LvjRQP49WtePB1omiDb7h3/0gCcIR74TGthq3nhKOIb1f2
        DwAbnfF7Y0Nx5MZKbSy3sFosjAl0SjbQHcbWVhEQ5LfJlO5FJ4vZIcYLYwor7PVZ2wmW+j
        iBDXUHZ3zcC3ka9NA81jg9eg10J6qBQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-z0hF7gkQPs6IQ7dPNu-qEA-1; Tue, 07 Dec 2021 09:52:53 -0500
X-MC-Unique: z0hF7gkQPs6IQ7dPNu-qEA-1
Received: by mail-ed1-f72.google.com with SMTP id m17-20020aa7d351000000b003e7c0bc8523so11670670edr.1
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 06:52:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tF1JpgNZ/kCs822lRUao4yCPouYho6b/UxZ2TAfYzz4=;
        b=yMNUXLEo7wHENMlLz149HCC/sI5H3SL64VJEY2RynNde4Ld8N/U05t8pV1tn46jRmb
         utJVEwlXN8+eXSOFJwOWegOdZNEVLtE6pWGdVYboyXjrrhCyQohKFwD4GmV5EuwMyMRQ
         787BfCl9bXqJepSe9yAIQblEOz5+R4BAgaR6I20Ba8nw+C/8J5adFeaMWaxNQcAVq5BP
         lxZWQbdQ1LuwDOtwyZILbhtiQG2vIYACWfNhlVjSnh3OMK5qsnZ2LLMEHAKb2JPPigD3
         hojlbDJlt9vho/F4O8+dSOXn4FrhrfT4sy+XS4rX5uMKIobfr61Oj7NEAVNb30Qbo4rH
         9vUQ==
X-Gm-Message-State: AOAM533BEw69/WZzDnn6wf9OcBX/mrKN6IZrSx49i+z2vc93MoBJPeM9
        eenrhkEbVtvXsvyCzT4MAkX3XEPWg8wHH+M+bDQGph7rHidRWhocR/cT8VZa5B+GuFs/Fc3DiZe
        qzc6TzOJZ0OxUJrSl
X-Received: by 2002:a17:906:9750:: with SMTP id o16mr53749351ejy.263.1638888772069;
        Tue, 07 Dec 2021 06:52:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRm1YF+ycDWOG9O4A8IjTFgHFA6s5UT2e1KOyi8s7tittQxoBA1XONoWir8iqs2hhS11qAZQ==
X-Received: by 2002:a17:906:9750:: with SMTP id o16mr53749332ejy.263.1638888771878;
        Tue, 07 Dec 2021 06:52:51 -0800 (PST)
Received: from [10.39.193.47] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id y22sm10363455edi.8.2021.12.07.06.52.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 06:52:51 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v19 bpf-next 12/23] bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
Date:   Tue, 07 Dec 2021 15:52:50 +0100
X-Mailer: MailMate (1.14r5852)
Message-ID: <4100A0D0-2169-4B51-A7A3-1511E879D365@redhat.com>
In-Reply-To: <Ya4nI6DKPmGOpfMf@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <81319e52462c07361dbf99b9ec1748b41cdcf9fa.1638272238.git.lorenzo@kernel.org>
 <61ad94bde1ea6_50c22081e@john.notmuch> <Ya4nI6DKPmGOpfMf@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6 Dec 2021, at 16:07, Lorenzo Bianconi wrote:

>> Lorenzo Bianconi wrote:
>>> From: Eelco Chaudron <echaudro@redhat.com>
>>>
>>> This change adds support for tail growing and shrinking for XDP multi=
-buff.
>>>
>>> When called on a multi-buffer packet with a grow request, it will wor=
k
>>> on the last fragment of the packet. So the maximum grow size is the
>>> last fragments tailroom, i.e. no new buffer will be allocated.
>>> A XDP mb capable driver is expected to set frag_size in xdp_rxq_info =
data
>>> structure to notify the XDP core the fragment size. frag_size set to =
0 is
>>> interpreted by the XDP core as tail growing is not allowed.
>>> Introduce __xdp_rxq_info_reg utility routine to initialize frag_size =
field.
>>>
>>> When shrinking, it will work from the last fragment, all the way down=
 to
>>> the base buffer depending on the shrinking size. It's important to me=
ntion
>>> that once you shrink down the fragment(s) are freed, so you can not g=
row
>>> again to the original size.
>>>
>>> Acked-by: Jakub Kicinski <kuba@kernel.org>
>>> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>> ---

<SNIP>

>>> +static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
>>> +{
>>> +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp=
);
>>> +	int i, n_frags_free =3D 0, len_free =3D 0;
>>> +
>>> +	if (unlikely(offset > (int)xdp_get_buff_len(xdp) - ETH_HLEN))
>>> +		return -EINVAL;
>>> +
>>> +	for (i =3D sinfo->nr_frags - 1; i >=3D 0 && offset > 0; i--) {
>>> +		skb_frag_t *frag =3D &sinfo->frags[i];
>>> +		int size =3D skb_frag_size(frag);
>>> +		int shrink =3D min_t(int, offset, size);
>>> +
>>> +		len_free +=3D shrink;
>>> +		offset -=3D shrink;
>>> +
>>> +		if (unlikely(size =3D=3D shrink)) {
>>
>> not so sure about the unlikely.
>
> I will let Eelco comment on it since he is the author of the patch.

My reasoning for adding the unlikely was as follows (assuming 4K pages, 2=
56 headroom):

  When jumbo frames are enabled, most frames are either below 4k or at th=
e max size of around 9100.
  Assuming the latter this is roughly 3 pages, (4096-256) (4069) (652). M=
eaning we can shrink 652 bytes before hitting this case, which I think mi=
ght not be hit often.

But maybe you think of another use case, which might warrant the unlikely=
 to be removed. I do not have a strong opinion to keep it.

>>> +			struct page *page =3D skb_frag_page(frag);
>>> +
>>> +			__xdp_return(page_address(page), &xdp->rxq->mem,
>>> +				     false, NULL);
>>> +			n_frags_free++;
>>> +		} else {
>>> +			skb_frag_size_set(frag, size - shrink);
>>

<SNIP>

