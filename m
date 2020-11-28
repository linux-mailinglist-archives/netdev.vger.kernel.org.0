Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976AB2C7303
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389346AbgK1Vt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387567AbgK1Thg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 14:37:36 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E23021527;
        Sat, 28 Nov 2020 19:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606592215;
        bh=c1x2VcILF4zR3MrshwEk2bDeOnWYpbs+y6qDeQ6KUus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GRfGr7Rsp5EHCuDMUjcuQXQrQzvJqpRDGPnYhTHYbAOwRTCvNbJzBPXJu5bIEY6hK
         7O2kalbqiakzUmGjJE1vGxR5DkAUykD8ZOHG/s6+soZOg/4dEPffwYFvjInnOmbRbQ
         J0Rk5Q6Dxsw+KJ9No3/jUm7AD25/v7CDQ9bxAVv4=
Date:   Sat, 28 Nov 2020 11:36:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        PowerPC <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Daniel Axtens <dja@axtens.net>, Joel Stanley <joel@jms.id.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-renesas-soc@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: Re: [PATCH] powerpc: fix the allyesconfig build
Message-ID: <20201128113654.4f2dcabe@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201128162054.575aea29@canb.auug.org.au>
References: <20201128122819.32187696@canb.auug.org.au>
        <20201127175642.45502b20@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201128162054.575aea29@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 16:20:54 +1100 Stephen Rothwell wrote:
> On Fri, 27 Nov 2020 17:56:42 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > What's the offending structure in hisilicon? I'd rather have a look
> > packing structs with pointers in 'em sounds questionable.
> > 
> > I only see these two:
> > 
> > $ git grep packed drivers/net/ethernet/hisilicon/
> > drivers/net/ethernet/hisilicon/hns/hnae.h:struct __packed hnae_desc {
> > drivers/net/ethernet/hisilicon/hns3/hns3_enet.h:struct __packed hns3_desc {  
> 
> struct hclge_dbg_reg_type_info which is 28 bytes long due to the
> included struct struct hclge_dbg_reg_common_msg (which is 12 bytes
> long).  They are surrounded by #pragma pack(1)/pack().
> 
> This forces the 2 pointers in each second array element of
> hclge_dbg_reg_info[] to be 4 byte aligned (where pointers are 8 bytes
> long on PPC64).

Ah! Thanks, I don't see a reason for these to be packed. 
Looks  like an accident, there is no reason to pack anything 
past struct hclge_dbg_reg_common_msg AFAICT.

Huawei folks, would you mind sending a fix if the analysis is correct?
