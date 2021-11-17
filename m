Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0315E454061
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 06:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhKQFtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 00:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbhKQFtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 00:49:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABF8C061746;
        Tue, 16 Nov 2021 21:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=FfkD+q87eHWGTXiAr2sBn0a4XKYgLxkUZ91bqq+Qj7I=; b=f0IaqUKiZEGLG0LZzJADOdJIdw
        0pJknKD7fnMGb6un+ujetf2mhKSonM9EAiBWj2v75CglUCSD7yox0oIQ1U4ntRT/V/cIXH/fSURs5
        jneLPWyTj9kQGoUnlckLP/WAqNN2v1NES0jCoAK0WfoURgcVHBjBKDP5A3zd6GSYxf2iORlZFnkDE
        NMKJsA5vJYuUsXprmJWBXDlLzjVujZfp3FeQKyAZfOplAZGdZw5EjOm0uiT1/N0rndWTgNF+Ln1hc
        CXFx+dArgN1ArnG4ckBCpMTfyLGESQz2JNkg3Mum4Hp8o+03QaO9n8+owAfNNncGFr8ol27fA/l56
        NFJynLXQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mnDmF-003MgV-V5; Wed, 17 Nov 2021 05:46:36 +0000
Subject: Re: linux-next: Tree for Nov 17 (uml, no IPV6)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211117135800.0b7072cd@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <268ae204-efae-3081-a5dd-44fc07d048ba@infradead.org>
Date:   Tue, 16 Nov 2021 21:46:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211117135800.0b7072cd@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/21 6:58 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20211116:
> 

ARCH=um SUBARCH=x86_64:
# CONFIG_IPV6 is not set


In file included from ../net/ethernet/eth.c:62:0:
../include/net/gro.h: In function ‘ip6_gro_compute_pseudo’:
../include/net/gro.h:413:22: error: implicit declaration of function ‘csum_ipv6_magic’; did you mean ‘csum_tcpudp_magic’? [-Werror=implicit-function-declaration]
   return ~csum_unfold(csum_ipv6_magic(&iph->saddr, &iph->daddr,
                       ^~~~~~~~~~~~~~~
                       csum_tcpudp_magic


After I made ip6_gro_compute_pseudo() conditional on CONFIG_IPV6,
I got this build error:

In file included from ../net/ipv6/tcpv6_offload.c:10:0:
../net/ipv6/tcpv6_offload.c: In function ‘tcp6_gro_receive’:
../net/ipv6/tcpv6_offload.c:22:11: error: implicit declaration of function ‘ip6_gro_compute_pseudo’; did you mean ‘inet_gro_compute_pseudo’? [-Werror=implicit-function-declaration]
            ip6_gro_compute_pseudo)) {
            ^
../include/net/gro.h:235:5: note: in definition of macro ‘__skb_gro_checksum_validate’
      compute_pseudo(skb, proto));  \
      ^~~~~~~~~~~~~~
../net/ipv6/tcpv6_offload.c:21:6: note: in expansion of macro ‘skb_gro_checksum_validate’
       skb_gro_checksum_validate(skb, IPPROTO_TCP,
       ^~~~~~~~~~~~~~~~~~~~~~~~~



This is UML x86_64 defconfig:

$ make ARCH=um SUBARCH=x86_64 defconfig all


-- 
~Randy
