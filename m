Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD25E594BA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfF1HXJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 03:23:09 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43256 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfF1HXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:23:08 -0400
Received: by mail-ed1-f68.google.com with SMTP id e3so9652880edr.10
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 00:23:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=24MgVOrd746ARBwtfwUcYnnOHTEROFCKSmQP0M0/9Ls=;
        b=IPApLhGogys4RzpLh2ggM98Vr+W4chJBqvBJVRl4qIbXXiBa9S4z51QelDeHoSTq05
         7o0u/Umws4alHHKpG4e7tZsh9NShbU3MzWzcI0/zBjTkkYItTOegCCTh9mDUbrCiH0rb
         XA67YG2qmLyIRfqZ9id4Eu3ZpMGC6UWxDv6ZNdhQiEvG/ePbnHApUSLNIFFUJZiwiMQD
         G6gPW/hzapUrxOn5AcBxaA0uI878Ueh8sHYwZvFq1IetF38CD9JSFkS87tc0tmH5MuMJ
         li/U7snAJk0ENeynAt6LQlyqWu/EVUDUNy5SuJUIOwjLZ8olj13+qOVrD/FHmKlwuulp
         Y9Ag==
X-Gm-Message-State: APjAAAU4pvQVslFHrjYOAsnbgBYxwWhNCnj9nrPwtidJ7F6nNOgDAJ4G
        jeZ0gglXcySyVV80+ow9YlM86lR0XCI=
X-Google-Smtp-Source: APXvYqwcMG0V4siYb6Ay07RN65XDwJNn3knB3ORnys76KbUINIm9WL04yJLY2LyTDk7fKbpsX3EKJA==
X-Received: by 2002:a17:906:264a:: with SMTP id i10mr7223420ejc.10.1561706587230;
        Fri, 28 Jun 2019 00:23:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y20sm287980ejj.75.2019.06.28.00.23.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 00:23:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1E63B181CA7; Fri, 28 Jun 2019 09:23:06 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v5 2/3] bpf_xdp_redirect_map: Perform map lookup in eBPF helper
In-Reply-To: <d0d5dbe3-d2bf-2284-b2a3-667c77487125@iogearbox.net>
References: <156125626076.5209.13424524054109901554.stgit@alrua-x1> <156125626136.5209.14349225282974871197.stgit@alrua-x1> <d0d5dbe3-d2bf-2284-b2a3-667c77487125@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 28 Jun 2019 09:23:06 +0200
Message-ID: <871rze9ns5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 06/23/2019 04:17 AM, Toke Høiland-Jørgensen wrote:
>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>> 
>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>> indication of whether it can successfully redirect to the map index it was
>> given. Instead, BPF programs have to track this themselves, leading to
>> programs using duplicate maps to track which entries are populated in the
>> devmap.
>> 
>> This patch fixes this by moving the map lookup into the bpf_redirect_map()
>> helper, which makes it possible to return failure to the eBPF program. The
>> lower bits of the flags argument is used as the return code, which means
>> that existing users who pass a '0' flag argument will get XDP_ABORTED.
>> 
>> With this, a BPF program can check the return code from the helper call and
>> react by, for instance, substituting a different redirect. This works for
>> any type of map used for redirect.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> [...]
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 183bf4d8e301..a6779e1cc1b8 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -3605,17 +3605,13 @@ static int xdp_do_redirect_map(struct net_device *dev, struct xdp_buff *xdp,
>>  			       struct bpf_redirect_info *ri)
>>  {
>>  	u32 index = ri->ifindex;
>> -	void *fwd = NULL;
>> +	void *fwd = ri->item;
>>  	int err;
>>  
>>  	ri->ifindex = 0;
>> +	ri->item = NULL;
>>  	WRITE_ONCE(ri->map, NULL);
>>  
>> -	fwd = __xdp_map_lookup_elem(map, index);
>> -	if (unlikely(!fwd)) {
>> -		err = -EINVAL;
>> -		goto err;
>> -	}
>
> If you look at the _trace_xdp_redirect{,_err}(), we should also get rid of the
> extra NULL test in devmap_ifindex() which is not under tracepoint static key.

ACK, will add.

-Toke
