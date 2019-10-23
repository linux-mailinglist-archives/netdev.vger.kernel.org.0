Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED2D5E186E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404599AbfJWK60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:58:26 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:45309 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390486AbfJWK60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:58:26 -0400
Received: by mail-oi1-f179.google.com with SMTP id o205so16948059oib.12;
        Wed, 23 Oct 2019 03:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4QKVMWKww9bh8zq7aiFacPLTuA4fXvLqjvmsu9wlCIk=;
        b=Nnoyooe6OLVrEnC19O8r3yszC/ohpvOiG+PcjMeGblbw3i9YzXBNAFIBublI6Yv52z
         orkTYPlxMAuinqYK4DP18KO+4QPoJFS8VAGpxIvpQA6zX9itrGy/C77+yfTbGzOlFLuT
         n27+ALrqzpSURZMNAjhBkYDckFJ3lEy4vfn82Q+T/4akZlYEGMyUGo2zrVuw1yHJpZeZ
         EoEXbVdLjAQL+lu7kXcefILxi2rAXCtEBp4jxfZmhXQ4bnrUmlA+NXs4+PvVAWX/1MIW
         Wi56vejqskWrbUiUfxX0a59Jj0Dva/SHGiSaHW/FHSj3FfDYgiBgkj98ifIFr2iIU45+
         4fig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4QKVMWKww9bh8zq7aiFacPLTuA4fXvLqjvmsu9wlCIk=;
        b=HMQnI1x04RmbJJ/7CqJpYpexYIVVSTb8zRFxvaBI57qtBmcfwEMsOG3SWdkJhKCEZI
         s+3t81sv3CTp0INnGg0j/QtspoVBaAHMu5J2BJ4B5NjW415cxGk8J8kqx4DSBubxo+y5
         PPVJMBJrJ4qBVp4fnzbwvteExidxDrAq23OTaq5bWuGzpZUm7KCUOBiBlwgRpa+fq03q
         c7A49OMCS7c4Un9qRq7jqasdhYvqXkf9FXhhVyWylrBha7d4YPFRFHSoeGOMmHDhh80r
         AaTOVbs0TJonSjk6UgQllaYs+aqgyhJvrY86VDA4Br77JpNtbX/PnJ/pN04rmJ3dk2Ob
         9uCQ==
X-Gm-Message-State: APjAAAUJcJlntz8OksPyqqpbOff1sNEiGzYvZ6T3TsdB/bKNff/3qzmE
        LABJ/THPhcrHefTOJqFUbTWP95WdTuS6qlxw/JZ1Qfe8
X-Google-Smtp-Source: APXvYqzW7WmkuqswFZfcC6C3mWgIrTgAGeuq9rxs8XVz95T9rtLb8VpnovwVoaxrAg7XMJ1GRYyVfZqHQzRVLq5KXhk=
X-Received: by 2002:aca:4557:: with SMTP id s84mr7061874oia.101.1571828305156;
 Wed, 23 Oct 2019 03:58:25 -0700 (PDT)
MIME-Version: 1.0
References: <1571288584-46449-1-git-send-email-xiangxia.m.yue@gmail.com> <20191023103117.GL25052@breakpoint.cc>
In-Reply-To: <20191023103117.GL25052@breakpoint.cc>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 23 Oct 2019 18:57:49 +0800
Message-ID: <CAMDZJNXqJk=gDSCRv98EuCyvmCHNarC7Tcu-BuBwo8b+sTOiBQ@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: nf_conntrack: introduce conntrack
 limit per-zone
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 6:31 PM Florian Westphal <fw@strlen.de> wrote:
>
> xiangxia.m.yue@gmail.com <xiangxia.m.yue@gmail.com> wrote:
> > nf_conntrack_max is used to limit the maximum number of
> > conntrack entries in the conntrack table for every network
> > namespace. For the containers that reside in the same namespace,
> > they share the same conntrack table, and the total # of conntrack
> > entries for all containers are limited by nf_conntrack_max.
> > In this case, if one of the container abuses the usage the
> > conntrack entries, it blocks the others from committing valid
> > conntrack entries into the conntrack table.
> >
> > To address the issue, this patch adds conntrack counter for zones
> > and max count which zone wanted, So that any zone can't consume
> > all conntrack entries in the conntrack table.
> >
> > This feature can be used for openvswitch or iptables.
>
> Your approach adds cost for everyone, plus a 256kbyte 'struct net'
> increase.
>
> openvswitch supports per zone limits already, using nf_conncount
> infrastructure.
This path limits the UNREPLIED conntrack entries. If we SYN flood one
zone, the zone will consume all entries in table, which state
SYN_SENT.
The openvswitch limits only the +est conntrack.

> nftables supports it using ruleset (via 'ct count').
>
> If you need support for iptables, consider extending xt_connlimit.c
> instead -- looking at the code it might already do all that is needed
> if userspace passes a 0-length mask for the ip address, i.e.
>
> iptables -t mangle -A PREROUTING -m conntrack --ctstate NEW -m connlimit \
>    --connlimit-above 1000 --connlimit-mask 0 -j REJECT
