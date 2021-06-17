Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687113ABD1D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFQTxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhFQTxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 15:53:14 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C06C061574;
        Thu, 17 Jun 2021 12:51:05 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id he7so11896587ejc.13;
        Thu, 17 Jun 2021 12:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K/2cLHHtY/R1Pi5mGLI4iU87e/5TgWVFJ+Ivk23EuxE=;
        b=MSql+6Rg8gMvT5etyTjxdclYd0n7mib6dUZA8ZqAPi14hAc/EnE8BDrmNau1nulfSm
         yc6kxGx2IWrnGeGItZLET/NRNQJqtz9cCboKcRQmPMibFnydGdBG0Uu4ptt9Ay9UIaLc
         Q94ZjW9hkBDdYzQMx77tqyAbWLV0niDBRlphnH3e3J+OKq2hvJP5ggXBtD/oB4qSbF/x
         u47qyJ6w2uuMVFlWZUd33OxOoG4ck6njbO9PtFTCv6WkvXwken+9dl5m5NhKb+j0x9mU
         Hfp5l4a/3AxfR1lTNHyGrikuO7i7IDyCz1UJXmHC/3+yJ6B+McD0UXHe8oCV2BQ051qD
         3Pzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K/2cLHHtY/R1Pi5mGLI4iU87e/5TgWVFJ+Ivk23EuxE=;
        b=WDfdyGhTPVvBVPM9Q13kOPvLoWc2OuVFDM2ilQHM2wjVOdzJl591V8VCVKeC325l6T
         k4lpf1f7P7+ufwt0LRcE43MoHMGSGk1Gqybq1sqdo/6VS4NhVnCO/8nb4TAxWaibN90R
         jWUqUgHc5oYrAbuBF9YcWAIl8gGVhSTLBcVy8p+6mhos8j1WOJiojIyFLJ44D60pWaJa
         H6osfY1iNLoxup+ucFQmiz23GqID0woo32ETOomBRPXeIwlnIDp7UQgfDicVaNE0a53g
         xXSO10vpkN1/fQRWpWKZ09g16680c/vT4zmwEZDLGpKw15xzgaw7BYWPYrJpQmJZeY7N
         HPxQ==
X-Gm-Message-State: AOAM533MfmmiKJrd18SS8+RPC/x+IPikfbbYkMJSqNwIwxLdIaWiUbGO
        I1ZN5lEugGI1vxEqREpB6ew=
X-Google-Smtp-Source: ABdhPJykeig0ygfwghsku+xlVnk6pgm/afn/czMDUWwVJB75gYYLZcRsBKut/F+wgrKNCzIjq6xKjQ==
X-Received: by 2002:a17:906:f744:: with SMTP id jp4mr7072953ejb.210.1623959464276;
        Thu, 17 Jun 2021 12:51:04 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id aq21sm4904522ejc.83.2021.06.17.12.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 12:51:03 -0700 (PDT)
Date:   Thu, 17 Jun 2021 22:51:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        jiri@resnulli.us, idosch@idosch.org
Subject: Re: [PATCH net-next] net/sched: cls_flower: fix resetting of ether
 proto mask
Message-ID: <20210617195102.h3bg6khvaogc2vwh@skbuf>
References: <20210617161435.8853-1-vadym.kochan@plvision.eu>
 <20210617164155.li3fct6ad45a6j7h@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617164155.li3fct6ad45a6j7h@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 07:41:55PM +0300, Vladimir Oltean wrote:
> On Thu, Jun 17, 2021 at 07:14:35PM +0300, Vadym Kochan wrote:
> > In case of matching 'protocol' the rule does not work:
> >
> >     tc filter add dev $DEV ingress prio 1 protocol $PROTO flower skip_sw action drop
> >
> > so clear the ether proto mask only for CVLAN case.
> >
> > The issue was observed by testing on Marvell Prestera Switchdev driver
> > with recent 'flower' offloading feature.
> >
> > Fixes: 0dca2c7404a9 ("net/sched: cls_flower: Remove match on n_proto")
> > CC: Boris Sukholitko <boris.sukholitko@broadcom.com>
> > Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
> > ---
>
> You resent the patch very quickly, did you find out why Boris' patch was
> working in the first place?

I guess not.

The question day is, really, "what is skb->protocol?"

Boris said that the main classification routine - __tcf_classify -
already selects the adequate classifier (a struct tcf_proto) from the
classifier chain on the ingress qdisc of the interface. The selected
struct tcf_proto has a protocol field equal to the skb->protocol of the
packet.

So given three filters:

tc qdisc add dev sw1p0 clsact
tc filter add dev sw1p0 ingress handle 10 protocol ipv4 flower src_ip 192.168.1.1 skip_hw action drop
tc filter add dev sw1p0 ingress handle 10 protocol ipv4 flower src_ip 192.168.1.2 skip_hw action drop
tc filter add dev sw1p0 ingress handle 10 protocol ipv4 flower src_ip 192.168.1.3 skip_hw action drop
tc filter add dev sw1p0 ingress handle 10 protocol ipv4 flower src_ip 192.168.1.4 skip_hw action drop
tc filter add dev sw1p0 ingress handle 11 protocol 0x8864 flower skip_hw action drop
tc filter add dev sw1p0 ingress handle 12 protocol 0x8862 flower skip_hw action drop

there will be 3 tcf_proto structures: one for protocol ipv4 (0x0800),
one for 0x8864 and one for 0x8862.

Boris points out that skb_flow_dissect() does not always set the
key->basic.n_proto value to the EtherType, but rather to the innermost
protocol, if the EtherType is for a 'tunneling' protocol like PPPoE.
That's just how the flow dissector works.

But Boris goes on to argue that he wants to match packets with EtherType
0x8864, and the flow dissector is stopping him from doing that, since it
is coded up to look inside the PPPoE session header, and return either
ETH_P_IP or ETH_P_IPV6.

How does Boris solve the problem?
He removes the key->basic.n_proto from the set of keys used by the flow dissector
instantiated by the flower classifier associated with this struct tcf_proto.
Because the protocol is already taken into account by virtue of __tcf_classify()
looking at skb_protocol(skb), it appears to be redundant to give the
flow dissector a chance to have its own shot at what the skb protocol is.

Why does classification by protocol still work?
Because, for example, this filter:

tc filter add dev sw1p0 ingress handle 11 protocol 0x8864 flower skip_hw action drop

will be the only filter of the tcf_proto classifier for protocol 0x8864
which is found by __tcf_classify(). By the time the flower's fl_classify()
is called, the tp_proto for 0x8864 will have only one mask, and despite
the lack of any valid flow dissector keys, fl_mask_lookup() will always
find that one filter.

If there are multiple filters for the same tcf_proto classifier, I guess
it's random which one will match.

What does Boris break?
Offloading, of course. fl_hw_replace_filter() and fl_reoffload() create
a struct flow_cls_offload with a rule->match.mask member derived from
the mask of the software classifier: &f->mask->key - that same mask that
is used for initializing the flow dissector keys, and the one from which
Boris removed the basic.n_proto member because it was bothering him.


Now, having understood the problem, it is clear that Boris's patch needs
more work to not break offloading. If we decide that Boris's approach is
good and the classifier protocol does mean something close to the
EtherType (although again, still not always the EtherType, see below),
then we probably need to keep a different fl_flow_mask/fl_flow_key
structure for passing to the flow dissector compared to the
fl_flow_mask/fl_flow_key we pass to the offloading driver.

However, I think we need to take a step back and see how the situation
should be dealt with.

I tried to see what does "man tc.8" say about the "protocol" field, and
of course, it says nothing - I guess it's just too obvious to mention.
But the tc classifiers use skb->protocol, not the EtherType, and
skb->protocol is derived from eth_type_trans(), which in itself does
some really magik tricks. For example, packets received on a DSA master
will have a skb->protocol of 0x00F8, regardless of the EtherType of the
actual packet. DSA then registers a ptype_handler for this magik value,
and that's how it sniffs and processes those packets.  But no one really
expected this information to leak to user space in this way, I mean if
you add a software filter on a DSA master it will need to be for
protocol 0xf8, but that isn't documented anywhere unless you read the
code (and of course, offloaded filters behave totally differently
because they have no idea of eth_type_trans and its tricks).
Then, DSA has adjustment code in the flow dissector again such that the
DSA header, if present, is transparent and just skipped over - revealing
the basic.n_proto value behind that (ETH_P_IP or whatever) and other
headers. So.. you can match on IP headers using tc on a DSA master?
Well, no, because the protocol is 0xf8, not ipv4, so the tc user space
parser won't allow you to set IPv4 keys for the flower classifier :)

But maybe we decide that no, we really need an unadulterated EtherType
to match in tc-flower. Jamal considered that the generic tc filter protocol
is good enough for that, but it clearly isn't. The trouble is - even
if we make the tc program continue to pass the TCA_FLOWER_KEY_ETH_TYPE
netlink attribute as a potentially different value compared to the
filter protocol (right now they are kept in sync by user space) - the
flow dissector will not give us the EtherType in basic.n_proto, but
rather the innermost protocol in the case of tunnelling protocols.
So maybe it is the flow dissector we need to fix, to make it give us an
additional pure EtherType if asked for, make tc-flower use that
dissector key instead, and then revert Jamal's user space patch, and we
should all install our tc filters as:

tc filter add dev sw1p0 ingress handle 11 protocol all flower eth_type 0x8864 skip_hw action drop

?

Or maybe just be like you, say I don't care about any of that, I just
want it to behave as before, and simply revert Boris's patch. Ok, maybe
for various reasons we decide to go that route, for example if we can't
decide on anything better, and there is an obvious regression being
introduced - broken offloading. But at the very least, your revert needs
work too. Please use straight "git revert -s 0dca2c7404a9" and don't
just do partial reverts. I don't know whether intentionally or not, but
you left the C-VLAN case broken - the mask->key.basic.n_proto is still
being set to zero, despite there being information in the netlink
attribute.

In any case, please do a better job of describing the change you are
making and why you are making it this way.
