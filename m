Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC64616B068
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbgBXTnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:43:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36321 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726687AbgBXTnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:43:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582573388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UPEDBw2q2/zVnpRqbyDC0y/dD98/YWWp9w4/MyvOaPI=;
        b=TBqDzJhRGzKsQK/5pTqN6I9wWxKAhn5UrjRFMCkMthDCzfd+M+/L+c65SVNrobdlWlNi2l
        5h+xm9J2flI4/iCIYxSdolgLv8lJ5nLs9sZ+F26evNEB2UfNu0BrOitB5AO46JbOW6rU1Q
        kFQ9Wd6+jeBwUs5K/xVE7tEjwpkqXUU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-qhoOCxvHOAa2SbOBS45z8A-1; Mon, 24 Feb 2020 14:43:06 -0500
X-MC-Unique: qhoOCxvHOAa2SbOBS45z8A-1
Received: by mail-ed1-f70.google.com with SMTP id dd24so7442266edb.1
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 11:43:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UPEDBw2q2/zVnpRqbyDC0y/dD98/YWWp9w4/MyvOaPI=;
        b=PVk9bL4IljnL+YodAH4ct1Zqcy4s0rWtazk6TLeR8XLhvr1XRzi7HdcQLBCUpTab2q
         waC7bzNA5r7N7+EBNefTbQsZQJmq6N7x3lNYmuB/hpjTTaw1yr+ngT2P49tgifkJNAw9
         +MP8zL1rtRRIZSLLJxglcVpE29aXPZ1TxWlCtdwDpzw/ZZscIli2+Fns7Zr+vpHciGky
         Kd+0H+Q+pp+yyLN7IVKgDg2G/Mmzs5FrJ3lA2XJ/X3k3hbZffqQF/LPdiYLDH0fU8axf
         h4ZG5G+ckm5l2XA2kY8Gsl97NjHEmskHUgE39a3BehfCON7vhmdavQoxMUgspuhXArp2
         s2/w==
X-Gm-Message-State: APjAAAUbnANsP3v7z77HXIpwegi/EgL94Jm4LmaeTJyv7AiSdVSorywJ
        9733UZwoULW5O0O6IWhey/4A2FI2AAB2ywPUBrrPhv3MqBr9KvxLbPvpQb4hicYqZnYH43K2ET3
        gfba90U5qITirNybqXLLj1Y8DOj32OFNy
X-Received: by 2002:aa7:c707:: with SMTP id i7mr47033910edq.287.1582573385296;
        Mon, 24 Feb 2020 11:43:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqx7hGQH+EDqFTrWey8Z79uUeupBz1Q0g4hvPLJr6VyJj0z08Kj/PZCQBR3230yo3IpOEuhkhq5q2+dh4qw2gN8=
X-Received: by 2002:aa7:c707:: with SMTP id i7mr47033902edq.287.1582573385142;
 Mon, 24 Feb 2020 11:43:05 -0800 (PST)
MIME-Version: 1.0
References: <20200224185529.50530-1-mcroce@redhat.com> <20200224191154.GH19559@breakpoint.cc>
In-Reply-To: <20200224191154.GH19559@breakpoint.cc>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 24 Feb 2020 20:42:29 +0100
Message-ID: <CAGnkfhyUOyd1XWdSSxL844RG-_z32qGasV7a+2m7XNrS8qvtCw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ensure rcu_read_lock() in ipv4_find_option()
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 8:12 PM Florian Westphal <fw@strlen.de> wrote:
>
> Matteo Croce <mcroce@redhat.com> wrote:
> > As in commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in ipv4_link_failure()")
> > and commit 3e72dfdf8227 ("ipv4: ensure rcu_read_lock() in cipso_v4_error()"),
> > __ip_options_compile() must be called under rcu protection.
>
> This is not needed, all netfilter hooks run with rcu_read_lock held.
>

Ok, so let's drop it, thanks.

-- 
Matteo Croce
per aspera ad upstream

