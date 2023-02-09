Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01E9690518
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBIKkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjBIKjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:39:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30435DC07
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675939132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=voOV6pOaXeJ1pDFZWrzhuUP7RIBZavneDMKg+1pXRew=;
        b=UaHliroIaXDLtOmKDCH8UQqzkLhpoIM52eVSzeC7T2RmPnARVum4B4BwHo9nf6jjMj8JY2
        oTcdWR6Spe7RrxRNy7c6WMBxd5anayytRYc1hubcXEaAeI2yDCD9rMwn7O3ujKhPLZL8W0
        twGDanS0L1qGHuwAOEkZbv5YoBpG0oM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-lGbmYhUzO1qukFRLXS6aQQ-1; Thu, 09 Feb 2023 05:38:51 -0500
X-MC-Unique: lGbmYhUzO1qukFRLXS6aQQ-1
Received: by mail-qv1-f69.google.com with SMTP id j19-20020a056214033300b0056c11dfb0ddso975526qvu.19
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 02:38:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=voOV6pOaXeJ1pDFZWrzhuUP7RIBZavneDMKg+1pXRew=;
        b=rLEwqSKgkPsjbKIK41DBYtpAmzfg7Wc89GpUqBhfPXOt20trrxzBSiciUZ3fPe7wrg
         /M0u7DctKYW0tqhbtKHGQ9JYS+POZPISLSfirDnKuPfzLafQlSgs2K40dtW2j9LrCeAx
         ZDK9QLQ+hnW6gvkAUrLgI/2J/jZWdQym1s22UECUb/Oxiaguvl6bWDrqTPgT1nUBHhY3
         HcDjL1Umd+g9MQRE9rArJptnFi9NhvjxEW9ZLW5l9S/iEYHhxoVdLcIDmVxjJQheWtR2
         PE6y3n+LKPEvYnHEpdrrxJV8ap9OWM2SgXczX1aXGDCXn10d88LePRrtZ+bZuUU/BMGc
         4Ssw==
X-Gm-Message-State: AO0yUKWeQhcaR0KniUc/Do3jIwfHOfNEp/JlYk2eDy4H1yR28REzA9l0
        PNcWZUYAZp40OQQkvq8e4yqM2qJ/La5Rhp5FpfrfsDPa2NkOREa5oea/VsYR9W/OfyfR9ftR78y
        zk1Suq/BaIFV7icy8
X-Received: by 2002:a05:622a:1981:b0:3b8:695b:aad1 with SMTP id u1-20020a05622a198100b003b8695baad1mr20832761qtc.1.1675939130980;
        Thu, 09 Feb 2023 02:38:50 -0800 (PST)
X-Google-Smtp-Source: AK7set8zLqwwjEj0sHNVxYloT/qlbK76J1k5c6L6GZvpHtrN5piuAw6hlZXVZYABUOiK03/oqXxCPA==
X-Received: by 2002:a05:622a:1981:b0:3b8:695b:aad1 with SMTP id u1-20020a05622a198100b003b8695baad1mr20832741qtc.1.1675939130676;
        Thu, 09 Feb 2023 02:38:50 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id x21-20020ac87a95000000b003b869f71eedsm971020qtr.66.2023.02.09.02.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 02:38:50 -0800 (PST)
Message-ID: <b36e496792de3d1811ea38f19588e5a5b32a9d2c.camel@redhat.com>
Subject: Re: [PATCH v2 net 1/1] tipc: fix kernel warning when sending SYN
 message
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        jmaloy@redhat.com, ying.xue@windriver.com, viro@zeniv.linux.org.uk,
        syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Date:   Thu, 09 Feb 2023 11:38:46 +0100
In-Reply-To: <20230208070759.462019-1-tung.q.nguyen@dektech.com.au>
References: <20230208070759.462019-1-tung.q.nguyen@dektech.com.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-02-08 at 07:07 +0000, Tung Nguyen wrote:
> When sending a SYN message, this kernel stack trace is observed:
>=20
> ...
> [   13.396352] RIP: 0010:_copy_from_iter+0xb4/0x550
> ...
> [   13.398494] Call Trace:
> [   13.398630]  <TASK>
> [   13.398630]  ? __alloc_skb+0xed/0x1a0
> [   13.398630]  tipc_msg_build+0x12c/0x670 [tipc]
> [   13.398630]  ? shmem_add_to_page_cache.isra.71+0x151/0x290
> [   13.398630]  __tipc_sendmsg+0x2d1/0x710 [tipc]
> [   13.398630]  ? tipc_connect+0x1d9/0x230 [tipc]
> [   13.398630]  ? __local_bh_enable_ip+0x37/0x80
> [   13.398630]  tipc_connect+0x1d9/0x230 [tipc]
> [   13.398630]  ? __sys_connect+0x9f/0xd0
> [   13.398630]  __sys_connect+0x9f/0xd0
> [   13.398630]  ? preempt_count_add+0x4d/0xa0
> [   13.398630]  ? fpregs_assert_state_consistent+0x22/0x50
> [   13.398630]  __x64_sys_connect+0x16/0x20
> [   13.398630]  do_syscall_64+0x42/0x90
> [   13.398630]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>=20
> It is because commit a41dad905e5a ("iov_iter: saner checks for attempt
> to copy to/from iterator") has introduced sanity check for copying
> from/to iov iterator. Lacking of copy direction from the iterator
> viewpoint would lead to kernel stack trace like above.
>=20
> This commit fixes this issue by initializing the iov iterator with
> the correct copy direction.
>=20
> Fixes: f25dcc7687d4 ("tipc: tipc ->sendmsg() conversion")
> Reported-by: syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
> ---
> v2: add Fixes tag
>=20
>  net/tipc/msg.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/net/tipc/msg.c b/net/tipc/msg.c
> index 5c9fd4791c4b..cce118fea07a 100644
> --- a/net/tipc/msg.c
> +++ b/net/tipc/msg.c
> @@ -381,6 +381,9 @@ int tipc_msg_build(struct tipc_msg *mhdr, struct msgh=
dr *m, int offset,
> =20
>  	msg_set_size(mhdr, msz);
> =20
> +	if (!dsz)
> +		iov_iter_init(&m->msg_iter, ITER_SOURCE, NULL, 0, 0);

It looks like the root cause of the problem is that not all (indirect)
callers of tipc_msg_build() properly initialize the iter.

tipc_connect() is one of such caller, but AFAICS even tipc_accept() can
reach tipc_msg_build() without proper iter initialization - via
__tipc_sendstream -> __tipc_sendmsg.

I think it's better if you address the issue in relevant callers,
avoiding unneeded and confusing code in tipc_msg_build().

Thanks,

Paolo

