Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1421223D052
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgHETre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:47:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23207 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728441AbgHERDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:03:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596646995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqjcjFj0cLfrtaKdyRnzSHGUtnIcD/6QjX80vbdnnDs=;
        b=i3EmGrMkaEYumeiOORyoM/7Lfr9A6oDgsIgn9K5bX5/Nd2DOk307e9T25itqaKeW8O+5DF
        /ZzRBidD1ejtMKVItSfx7tzrPIiCCMsSzM3WauEASCfcjlgmmOczrQQljMZSqj7HbMBY1R
        SIuy4dJiFyAVx7AA2U/l5VDXmgMZyy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-v1Ut0-vMMlKQmdlxYzNI4g-1; Wed, 05 Aug 2020 13:03:04 -0400
X-MC-Unique: v1Ut0-vMMlKQmdlxYzNI4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AA368F53CF;
        Wed,  5 Aug 2020 17:02:48 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 488217B910;
        Wed,  5 Aug 2020 17:02:41 +0000 (UTC)
Date:   Wed, 5 Aug 2020 19:02:34 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-riscv@lists.infradead.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>,
        Netdev <netdev@vger.kernel.org>, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu,
        lkft-triage@lists.linaro.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH net-next v2 2/6] tunnels: PMTU discovery support for
 directly bridged IP packets
Message-ID: <20200805190234.1d95dccd@elisabeth>
In-Reply-To: <CA+G9fYsJdoQieVr6=e09nYAvpAjnay5XSmJ3WkZHgMdzJRUYEw@mail.gmail.com>
References: <cover.1596520062.git.sbrivio@redhat.com>
        <83e5876f589b0071638630dd93fbe0fa6b1b257c.1596520062.git.sbrivio@redhat.com>
        <CA+G9fYsJdoQieVr6=e09nYAvpAjnay5XSmJ3WkZHgMdzJRUYEw@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Naresh,

On Wed, 5 Aug 2020 22:24:03 +0530
Naresh Kamboju <naresh.kamboju@linaro.org> wrote:

> On Tue, 4 Aug 2020 at 11:24, Stefano Brivio <sbrivio@redhat.com> wrote:
> >
> > +       icmp6h->icmp6_cksum = csum_ipv6_magic(&nip6h->saddr, &nip6h->daddr, len,
> > +                                             IPPROTO_ICMPV6, csum);
> 
> Linux next build breaks for riscv architecture defconfig build.

Yes, sorry for that. Stephen Rothwell already reported this for s390
defconfig and I sent a patch some hours ago:

	https://patchwork.ozlabs.org/project/netdev/patch/a85e9878716c2904488d56335320b7131613e94c.1596633316.git.sbrivio@redhat.com/

Thanks for reporting this though!

-- 
Stefano

