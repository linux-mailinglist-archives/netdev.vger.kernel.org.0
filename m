Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358153A37A2
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhFJXHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:07:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60929 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhFJXHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:07:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623366343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zaN/4xw50VkDE65M8AibghHcVWhVfVwq3dgmOVKPedk=;
        b=dCuaQQVasHTjyQgcaOP5NAwMWK7NSFgNeXpymxuvl67gtRkd9Fu/gExdbtueQP/sb037kg
        HTp7YUe2F85yz6/cfNkJXnppVIeRa1M2OnoeMg4WlA64o9aOCNAZb9MQkjTrPdN97kyvT7
        pQyqe5aA6TtrzdCQoN3khuTRWHJmeSg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-Tgr34VjsMoOMIc-MA8kntQ-1; Thu, 10 Jun 2021 19:05:41 -0400
X-MC-Unique: Tgr34VjsMoOMIc-MA8kntQ-1
Received: by mail-ed1-f71.google.com with SMTP id s25-20020aa7c5590000b0290392e051b029so10025868edr.11
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:05:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zaN/4xw50VkDE65M8AibghHcVWhVfVwq3dgmOVKPedk=;
        b=Z7gZK0KNkinLPtowAethznv55+aoD06ff8xF3mtd62OhyFwhzD2TDE8DnFW9Htd+x+
         jSdn9qOvH2jOhe/VjVF8FbEYJC0qtV/uY+yOj+N7IoWaD+IjlLEN255MIvb+TTPB8Unn
         76zM0CuRjqu060fin2URNrRK+0WLIMyPaAxVWfIBlk9WkfTEVu4VlYab6W9E0McfDr3J
         qcuooJxGHoNb2CabtMo+7UfzcKn2knDdIoRzl0ItoKPxqroQrE/dcI9GRDDKZxjXN2wf
         BLhsIGNHlPjXHiIydcIliDdxjbB9ib1e3ZJupPCVHbousEjA+8mLteQHbHOsSyjoH6s3
         lKoQ==
X-Gm-Message-State: AOAM530BoGFMW6PZCC7BL0SAo1xcSBf8L/i6HfZzUVyv3zuskCm+/LG3
        0Gvg8yBy/tdYSjqlkBKT8kkvXRuTsZPbOEn+Z6NT0gpbitXadUpyfenHDhLQfyDNP7qwaT84/4a
        uyUq6YsLjFqmROD7t
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr788023edt.118.1623366340323;
        Thu, 10 Jun 2021 16:05:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7UrdC3NbigfdW/whZC2A9NUxkEVZp/6LZemrS5UvqVh5wxoS0Eay52k4MdJevVhm+NwJX1Q==
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr788003edt.118.1623366339966;
        Thu, 10 Jun 2021 16:05:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id de19sm2016257edb.70.2021.06.10.16.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:05:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A3A1818071E; Fri, 11 Jun 2021 01:05:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH bpf-next 03/17] dev: add rcu_read_lock_bh_held() as a
 valid check when getting a RCU dev ref
In-Reply-To: <20210610193722.753tqgrovwyg2v6v@kafai-mbp>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-4-toke@redhat.com>
 <20210610193722.753tqgrovwyg2v6v@kafai-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Jun 2021 01:05:38 +0200
Message-ID: <87lf7huxq5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Wed, Jun 09, 2021 at 12:33:12PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Some of the XDP helpers (in particular, xdp_do_redirect()) will get a
>> struct net_device reference using dev_get_by_index_rcu(). These are call=
ed
>> from a NAPI poll context, which means the RCU reference liveness is ensu=
red
>> by local_bh_disable(). Add rcu_read_lock_bh_held() as a condition to the
>> RCU list traversal in dev_get_by_index_rcu() so lockdep understands that
>> the dereferences are safe from *both* an rcu_read_lock() *and* with
>> local_bh_disable().
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  net/core/dev.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index febb23708184..a499c5ffe4a5 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -1002,7 +1002,7 @@ struct net_device *dev_get_by_index_rcu(struct net=
 *net, int ifindex)
>>  	struct net_device *dev;
>>  	struct hlist_head *head =3D dev_index_hash(net, ifindex);
>>=20=20
>> -	hlist_for_each_entry_rcu(dev, head, index_hlist)
>> +	hlist_for_each_entry_rcu(dev, head, index_hlist, rcu_read_lock_bh_held=
())
> Is it needed?  hlist_for_each_entry_rcu() checks for
> rcu_read_lock_any_held().  Did lockdep complain?

Ah, yes, I think you're right. I totally missed that
rcu_read_lock_any_held() includes a '!preemptible()' check at the end.
I'll drop this patch, then!

-Toke

