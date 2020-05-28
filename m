Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387291E624C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390397AbgE1NbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390326AbgE1NbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:31:00 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03763C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:31:00 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x1so32050728ejd.8
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 06:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Qq6LtiJc7oZZsG5dSDojr2AJoXCd+/57zdD2ct7qvTE=;
        b=KBxzecz93E2ctvuaeYcE+QlG+SIix17xPC3sUFo58EXRZC5C3iIFzps0Er3DIG75z9
         F8LBwZ1iBiVeQlxh2Pi2DXkyXS7JB74KnBXBFWoMn74+cBOugvD8LPxClI1uLmqNoF08
         giTsYQgl9iowQGfEtmg7gLcfSRqDz5PRlkgzA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Qq6LtiJc7oZZsG5dSDojr2AJoXCd+/57zdD2ct7qvTE=;
        b=LL/IxUP6zuR21fEG6JThXS9PHv7m5x52OguR/1lth8wNBsiGw84xI7qrnfJ33LXzH1
         VtKWHhc7SxUDjDwmv70WLkXRKk0BD3xVh5XKQSlZZEUnvwYcjD6gJOGQYo9wVOnap+3A
         ndg/FJij7JRDMt5VV9BLmvlGFxOI9I1OMgTNa9uB4vAP1xgax6/Qy/IpxAlTmjoM/0fI
         OZNfDmX41hiuYhUZbLc8JvoBnaxzo56luflPRTn9EfxxS+vJ33ph4vLqF4yjNhwyJi2m
         pgMCrlu/3rbN1kaei9vJyjAmME1+yipVbu4m6k7/zyPlK5IKmvenEEOSdVorvcrZel2/
         Lg1g==
X-Gm-Message-State: AOAM531422zDxxzZMe25ChCrM8GKDYrol6gh6LRt3K5q6jUwo7kZscF4
        SHbBSLY8E9saYfsUnCTyafsPvQ==
X-Google-Smtp-Source: ABdhPJzUuhvEzfbaS7DhgOZKhIKc7EMeqxhZWaru2STFBXP+ifTXAJc/cvAeOb9qG1uhhBp8wXVmrA==
X-Received: by 2002:a17:907:1103:: with SMTP id qu3mr2865013ejb.453.1590672658570;
        Thu, 28 May 2020 06:30:58 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m8sm5216384ejk.100.2020.05.28.06.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 06:30:58 -0700 (PDT)
References: <20200527170840.1768178-1-jakub@cloudflare.com> <20200527170840.1768178-6-jakub@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 5/8] bpf: Add link-based BPF program attachment to network namespace
In-reply-to: <20200527170840.1768178-6-jakub@cloudflare.com>
Date:   Thu, 28 May 2020 15:30:57 +0200
Message-ID: <87k10w2nla.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 07:08 PM CEST, Jakub Sitnicki wrote:
> Add support for bpf() syscall subcommands that operate on
> bpf_link (LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO) for attach points tied to
> network namespaces (that is flow dissector at the moment).
>
> Link-based and prog-based attachment can be used interchangeably, but only
> one can be in use at a time. Attempts to attach a link when a prog is
> already attached directly, and the other way around, will be met with
> -EBUSY.
>
> Attachment of multiple links of same attach type to one netns is not
> supported, with the intention to lift it when a use-case presents
> itself. Because of that attempts to create a netns link, when one already
> exists result in -E2BIG error, signifying that there is no space left for
> another attachment.
>
> Link-based attachments to netns don't keep a netns alive by holding a ref
> to it. Instead links get auto-detached from netns when the latter is being
> destroyed by a pernet pre_exit callback.
>
> When auto-detached, link lives in defunct state as long there are open FDs
> for it. -ENOLINK is returned if a user tries to update a defunct link.
>
> Because bpf_link to netns doesn't hold a ref to struct net, special care is
> taken when releasing the link. The netns might be getting torn down when
> the release function tries to access it to detach the link.
>
> To ensure the struct net object is alive when release function accesses it
> we rely on the fact that cleanup_net(), struct net destructor, calls
> synchronize_rcu() after invoking pre_exit callbacks. If auto-detach from
> pre_exit happens first, link release will not attempt to access struct net.
>
> Same applies the other way around, network namespace doesn't keep an
> attached link alive because by not holding a ref to it. Instead bpf_links
> to netns are RCU-freed, so that pernet pre_exit callback can safely access
> and auto-detach the link when racing with link release/free.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

[...]

> +static int bpf_netns_link_update_prog(struct bpf_link *link,
> +				      struct bpf_prog *new_prog,
> +				      struct bpf_prog *old_prog)
> +{
> +	struct bpf_netns_link *net_link = to_bpf_netns_link(link);
> +	struct net *net;
> +	int ret = 0;
> +
> +	if (old_prog && old_prog != link->prog)
> +		return -EPERM;
> +	if (new_prog->type != link->prog->type)
> +		return -EINVAL;
> +
> +	mutex_lock(&netns_bpf_mutex);
> +	rcu_read_lock();
> +
> +	net = rcu_dereference(net_link->net);
> +	if (!net || !check_net(net)) {
> +		/* Link auto-detached or netns dying */
> +		ret = -ENOLINK;
> +		goto out_unlock;
> +	}
> +
> +	old_prog = xchg(&link->prog, new_prog);
> +	bpf_prog_put(old_prog);

I've noticed a bug here. I should be updating net->bpf.progs[type] here
as well. Will fix in v2.

> +
> +out_unlock:
> +	rcu_read_unlock();
> +	mutex_unlock(&netns_bpf_mutex);
> +
> +	return ret;
> +}

[...]
