Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBEEC10025D
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfKRK26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 05:28:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34859 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726460AbfKRK25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:28:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574072937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LhamZzA3LrJarrlmUQ5S/IufYc17IFNifGdXBuJ8LR8=;
        b=HCV6Y1y/WhCCIlJ1geBISQEHjdRraypGsQpeYJEUvznmOp9O26PCyP9MLT3yTLxQHAldVH
        a0NUpySZIRMwbhxNLZIDAPBb92GV84V+Tq+mUI3/7mwQl//03nfhEZyJHEzHc6OdSY/m5R
        Pmj1K862wwMds5nbzpnXJ1Ux4iTV5bc=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-IjYHKnnGNUGRuqLJYC3iYg-1; Mon, 18 Nov 2019 05:28:54 -0500
Received: by mail-lj1-f198.google.com with SMTP id x17so3148012ljd.15
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 02:28:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LhamZzA3LrJarrlmUQ5S/IufYc17IFNifGdXBuJ8LR8=;
        b=LaNdzEAU1XBzoPQYS1jpG0iVmha2UYldxd6kV3rbxyJQ2A787CgNFOx9tmyff9TCOr
         RU81p/KXIcPRfOF4S2chhaqvgHfBkZB4xnPvqHCthkBg0WbnR10eLpVCH1E05UdksYPq
         ZzKoH2A+2aieREfk8x6LCeZcwI/e7MMgwabtv2oxIISyq2HYqmBpo443umfOSW9RD+qv
         ajb6pded7T9vkmgIuNJO9a27uAJejS/SgoGb3sBTr+1D8SH15i/++OkvBUgz7vBjy8rT
         /KMqIVyCXUdKOu2HpRJyE/BN4AlauegqQb30qdMTAU8/3YVs1ES/tihLN+eRoNRn2y36
         EFEQ==
X-Gm-Message-State: APjAAAV6RmxS4zMn2buzzh8IRbd+bKxYTvglz2Bd1rLWWpo/a+jIa6oa
        0ES4fyeZPF+ZgH9lBVcILvfHSi0UvfcKKRkAQbeC+HiJwq0GRPEcuH6snnbl9VkpM8e6bFL7tX3
        ttIgh2/3RshlV+cZr
X-Received: by 2002:ac2:5bc2:: with SMTP id u2mr19909864lfn.173.1574072933485;
        Mon, 18 Nov 2019 02:28:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBbjGNrjhe70rm0arQAFXWn4tteulEHcxxFQ/04nE/k0GJuObBO43W/HGIy2OQ908Kugc0yg==
X-Received: by 2002:ac2:5bc2:: with SMTP id u2mr19909856lfn.173.1574072933318;
        Mon, 18 Nov 2019 02:28:53 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p193sm10732896lfa.18.2019.11.18.02.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 02:28:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BD64218190D; Mon, 18 Nov 2019 11:28:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
In-Reply-To: <6e08f714-6284-6d0d-9cbe-711c64bf97aa@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com> <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch> <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch> <87h840oese.fsf@toke.dk> <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch> <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com> <87zhhmrz7w.fsf@toke.dk> <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com> <87zhhhnmg8.fsf@toke.dk> <640418c3-54ba-cd62-304f-fd9f73f25a42@gmail.com> <87blthox30.fsf@toke.dk> <c1b7ff64-6574-74c7-cd6b-5aa353ec80ce@gmail.com> <87lfsiocj5.fsf@toke.dk> <6e08f714-6284-6d0d-9cbe-711c64bf97aa@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Nov 2019 11:28:51 +0100
Message-ID: <87h831cwbg.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: IjYHKnnGNUGRuqLJYC3iYg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forgot to answer this part...

>> It would probably require a bit of refactoring in the kernel data
>> structures so they can be used without being tied to an skb. David Ahern
>> did something similar for the fib. For the routing table case, that
>> resulted in a significant speedup: About 2.5x-3x the performance when
>> using it via XDP (depending on the number of routes in the table).
>
> I'm curious about how much the helper function can improve the
> performance compared to XDP programs which emulates kernel feature
> without using such helpers. 2.5x-3x sounds a bit slow as XDP to me,
> but it can be routing specific problem.

That's specific to routing; the numbers we got were roughly consistent
with the routing table lookup performance reported here:
https://vincent.bernat.ch/en/blog/2017-ipv4-route-lookup-linux

I.e., a fib lookup takes something on the order of 30-50 ns, which
eats up quite a bit of the time budget for forwarding...

-Toke

