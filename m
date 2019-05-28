Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19152CE3A
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfE1SIq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 28 May 2019 14:08:46 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44770 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfE1SIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:08:46 -0400
Received: by mail-lf1-f66.google.com with SMTP id r15so5868816lfm.11
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:08:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=eykg+eL9MZeOQOg0Rir0js4FuKnx9+9PyiZNdyF9AN0=;
        b=qyC4otRT22+4+lcekD32c541gnUXTjhvskrH4+yLbfaaf+CJSirvv33r1C4LHlSeBW
         V0hRkvecgnmwI7Vcdb2D0RM8GWWElzBvPNiComTLIfSkgqgoojkTNCCOAWlf6jqx+huw
         y/rj0ONAoKPo0nWEbxokW0qUFSIUKZaF/rsn/jXaL+top3aW5NrCC9XTHgaJqgwrwYG/
         pa6c9d5OuXkmM6Zy0xRiw+GuxLJP98Ks1XznwcF2PDQJIc2d9H2KVgDokE1ntMI6z0lD
         ecn99tLeJyFQ8Hj1DHjRSNHUqaCqwNZ99JuY6zrp/Nluzx71CUg45hPa+cMzf9azOamw
         mScA==
X-Gm-Message-State: APjAAAUY3Nn5bbkx1+0J75l6TzWwVUvVd9oWDoXvA2Mk8+5w82WkcqRu
        BoBy0WS306H9D492RM8SsADuPGQVRK0=
X-Google-Smtp-Source: APXvYqxAvnSJNT5X40DsjA6+QFNDyDOhtxXvEXgqMuYyNV21LheciU9tiogr4To9NtIl9wA/Rne6SA==
X-Received: by 2002:ac2:4a6e:: with SMTP id q14mr26830223lfp.46.1559066919514;
        Tue, 28 May 2019 11:08:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id h25sm3083471lja.41.2019.05.28.11.08.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 11:08:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DB89718031E; Tue, 28 May 2019 20:08:37 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
In-Reply-To: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 May 2019 20:08:37 +0200
Message-ID: <87ef4itpsq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

> ctinfo is a new tc filter action module.  It is designed to restore
> information contained in firewall conntrack marks to other packet fields
> and is typically used on packet ingress paths.  At present it has two
> independent sub-functions or operating modes, DSCP restoration mode &
> skb mark restoration mode.
>
> The DSCP restore mode:
>
> This mode copies DSCP values that have been placed in the firewall
> conntrack mark back into the IPv4/v6 diffserv fields of relevant
> packets.
>
> The DSCP restoration is intended for use and has been found useful for
> restoring ingress classifications based on egress classifications across
> links that bleach or otherwise change DSCP, typically home ISP Internet
> links.  Restoring DSCP on ingress on the WAN link allows qdiscs such as
> but by no means limited to CAKE to shape inbound packets according to
> policies that are easier to set & mark on egress.
>
> Ingress classification is traditionally a challenging task since
> iptables rules haven't yet run and tc filter/eBPF programs are pre-NAT
> lookups, hence are unable to see internal IPv4 addresses as used on the
> typical home masquerading gateway.  Thus marking the connection in some
> manner on egress for later restoration of classification on ingress is
> easier to implement.
>
> Parameters related to DSCP restore mode:
>
> dscpmask - a 32 bit mask of 6 contiguous bits and indicate bits of the
> conntrack mark field contain the DSCP value to be restored.
>
> statemask - a 32 bit mask of (usually) 1 bit length, outside the area
> specified by dscpmask.  This represents a conditional operation flag
> whereby the DSCP is only restored if the flag is set.  This is useful to
> implement a 'one shot' iptables based classification where the
> 'complicated' iptables rules are only run once to classify the
> connection on initial (egress) packet and subsequent packets are all
> marked/restored with the same DSCP.  A mask of zero disables the
> conditional behaviour ie. the conntrack mark DSCP bits are always
> restored to the ip diffserv field (assuming the conntrack entry is found
> & the skb is an ipv4/ipv6 type)
>
> e.g. dscpmask 0xfc000000 statemask 0x01000000
>
> |----0xFC----conntrack mark----000000---|
> | Bits 31-26 | bit 25 | bit24 |~~~ Bit 0|
> | DSCP       | unused | flag  |unused   |
> |-----------------------0x01---000000---|
>       |                   |
>       |                   |
>       ---|             Conditional flag
>          v             only restore if set
> |-ip diffserv-|
> | 6 bits      |
> |-------------|
>
> The skb mark restore mode (cpmark):
>
> This mode copies the firewall conntrack mark to the skb's mark field.
> It is completely the functional equivalent of the existing act_connmark
> action with the additional feature of being able to apply a mask to the
> restored value.
>
> Parameters related to skb mark restore mode:
>
> mask - a 32 bit mask applied to the firewall conntrack mark to mask out
> bits unwanted for restoration.  This can be useful where the conntrack
> mark is being used for different purposes by different applications.  If
> not specified and by default the whole mark field is copied (i.e.
> default mask of 0xffffffff)
>
> e.g. mask 0x00ffffff to mask out the top 8 bits being used by the
> aforementioned DSCP restore mode.
>
> |----0x00----conntrack mark----ffffff---|
> | Bits 31-24 |                          |
> | DSCP & flag|      some value here     |
> |---------------------------------------|
> 			|
> 			|
> 			v
> |------------skb mark-------------------|
> |            |                          |
> |  zeroed    |                          |
> |---------------------------------------|
>
> Overall parameters:
>
> zone - conntrack zone
>
> control - action related control (reclassify | pipe | drop | continue |
> ok | goto chain <CHAIN_INDEX>)
>
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Thank you for doing another iteration!

No further comments on the actual code, but I still get the whitespace
issue with the patch... And now it results in stray ^M characters in the
Kconfig file, which makes the build blow up :/

Not sure why that happens, but there are quite a few settings in git
related to line endings, so I guess something is going wrong with how
those interact with your editor settings? This indicates that you may
just have to set core.autocrlf to true:
https://stackoverflow.com/a/16144559

Anyway, apart from the whitespace issue:

Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
