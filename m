Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF001E4EA7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 21:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387659AbgE0Ty2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 15:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387464AbgE0Ty1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 15:54:27 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A610C03E96E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:54:26 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id k19so21315989edv.9
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 12:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=hMHA9o8N/oLP6gKdOd6KFilP6DjKJyX2ReZ7fR+OqUs=;
        b=MmR9oOojBLRudT9whRmp/Ezb2/Xf+s85g+1861AQrXOWMZdcNQfBSS624d4yVJeSMR
         gyxWQYmO+BNiIWFazgEuaRFJTsWU1kYwMOHYdAZ+sgFyxZ2mtDWIYiRoUiGF0GyB/siw
         PeIQfWsUUsEAlE1UmP6cdWsBwcvfQfnwBbyAI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=hMHA9o8N/oLP6gKdOd6KFilP6DjKJyX2ReZ7fR+OqUs=;
        b=j4oWBVaJGxDdT9ERF5y6N8uH7OW7YkluaiguDCRGN4rnlNzDFKQcoYEFNeBSlOuF5D
         gsCLnnNiDEiQkEg5y9TL8LP5Ll/t7JArZ5lmBHzwd39WtK6Ycgel8fq9mPhOD2JCxHAH
         v4kCe/0Ce0mev/7Z6ECcd2jOyRQZoJUF/Y0I6tNddH7q2t687rk+HHCob/0HokmO2vKU
         2GaWj99su60sLkpL2qbii8c2w//KkELSRQJFYjqeuy/s2/VfCgGempGxXkvCCaa2PJqQ
         r9MPkPHPTYfo0Wu82R6bz7dsrb74Z0y23w//9jOqvvMN3CjJnGwPvDZtiYtudpRKfFJy
         dq3Q==
X-Gm-Message-State: AOAM533EhGaDoTKW8j++ybew+wIuU8441jh+rpWX1LnAYBt95JGV0fY5
        JG+iH1MqhldbbNsUpbz/5IUV5g==
X-Google-Smtp-Source: ABdhPJy2iOgwesh1MgLPg2N5Uh8ITPWR640mk6ppMfZ/MXBXmT5TQePxpqePDF0oTnCuX37feYw+ZQ==
X-Received: by 2002:a05:6402:1ca6:: with SMTP id cz6mr15855411edb.381.1590609264928;
        Wed, 27 May 2020 12:54:24 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id bd10sm2884605edb.10.2020.05.27.12.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 12:54:24 -0700 (PDT)
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-6-jakub@cloudflare.com> <20200527174805.GG49942@google.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     sdf@google.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 5/8] bpf: Add link-based BPF program attachment to network namespace
In-reply-to: <20200527174805.GG49942@google.com>
Date:   Wed, 27 May 2020 21:54:23 +0200
Message-ID: <87tv012lxs.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 07:48 PM CEST, sdf@google.com wrote:
> On 05/27, Jakub Sitnicki wrote:
>> Add support for bpf() syscall subcommands that operate on
>> bpf_link (LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO) for attach points tied to
>> network namespaces (that is flow dissector at the moment).
>
>> Link-based and prog-based attachment can be used interchangeably, but only
>> one can be in use at a time. Attempts to attach a link when a prog is
>> already attached directly, and the other way around, will be met with
>> -EBUSY.
>
>> Attachment of multiple links of same attach type to one netns is not
>> supported, with the intention to lift it when a use-case presents
>> itself. Because of that attempts to create a netns link, when one already
>> exists result in -E2BIG error, signifying that there is no space left for
>> another attachment.
>
>> Link-based attachments to netns don't keep a netns alive by holding a ref
>> to it. Instead links get auto-detached from netns when the latter is being
>> destroyed by a pernet pre_exit callback.
>
>> When auto-detached, link lives in defunct state as long there are open FDs
>> for it. -ENOLINK is returned if a user tries to update a defunct link.
>
>> Because bpf_link to netns doesn't hold a ref to struct net, special care is
>> taken when releasing the link. The netns might be getting torn down when
>> the release function tries to access it to detach the link.
>
>> To ensure the struct net object is alive when release function accesses it
>> we rely on the fact that cleanup_net(), struct net destructor, calls
>> synchronize_rcu() after invoking pre_exit callbacks. If auto-detach from
>> pre_exit happens first, link release will not attempt to access struct net.
>
>> Same applies the other way around, network namespace doesn't keep an
>> attached link alive because by not holding a ref to it. Instead bpf_links
>> to netns are RCU-freed, so that pernet pre_exit callback can safely access
>> and auto-detach the link when racing with link release/free.
>
> [..]
>> +	rcu_read_lock();
>>   	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
>> -		if (rcu_access_pointer(net->bpf.progs[type]))
>> +		if (rcu_access_pointer(net->bpf.links[type]))
>> +			bpf_netns_link_auto_detach(net, type);
>> +		else if (rcu_access_pointer(net->bpf.progs[type]))
>>   			__netns_bpf_prog_detach(net, type);
>>   	}
>> +	rcu_read_unlock();
> Aren't you doing RCU_INIT_POINTER in __netns_bpf_prog_detach?
> Is it allowed under rcu_read_load?

Yes, that's true. __netns_bpf_prog_detach does

	RCU_INIT_POINTER(net->bpf.progs[type], NULL);

RCU read lock is here for the rcu_dereference() that happens in
bpf_netns_link_auto_detach (netns doesn't hold a ref to bpf_link):

/* Called with RCU read lock. */
static void __net_exit
bpf_netns_link_auto_detach(struct net *net, enum netns_bpf_attach_type type)
{
	struct bpf_netns_link *net_link;
	struct bpf_link *link;

	link = rcu_dereference(net->bpf.links[type]);
	if (!link)
		return;
	net_link = to_bpf_netns_link(link);
	RCU_INIT_POINTER(net_link->net, NULL);
}

I've pulled it up, out of the loop, perhaps too eagerly and just made it
confusing, considering we're iterating over a 1-item array :-)

Now, I'm also doing RCU_INIT_POINTER on the *contents of bpf_link* in
bpf_netns_link_auto_detach. Is that allowed? I'm not sure, that bit is
hazy to me.

There are no concurrent writers to net_link->net, just readers, i.e.
bpf_netns_link_release(). And I know bpf_link won't be freed until the
grace period elapses.

sparse and CONFIG_PROVE_RCU are not shouting at me, but please do if it
doesn't hold up or make sense.

I certainly can push the rcu_read_lock() down into
bpf_netns_link_auto_detach().

-jkbs
