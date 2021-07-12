Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D6D3C5AC2
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhGLKV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 06:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhGLKVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 06:21:23 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E75C0613DD;
        Mon, 12 Jul 2021 03:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Lh1rljUNYbSH9uKLOmZ6nltPUrZDF5cP6bgaWb+JYl0=; b=tM3pEyh9XfYwXE8hPqqu7i4OFm
        yU0O24XVPSa9z9lpNvziOR5qHyH13B8yJ9SAXRBKCN6mYWnvLoleRRP7KTda3Jg+P/y3MgHNiOugT
        QdDY8BWZiyi/h109SQHTqcmNnAZFS/cVtUy06dXI2cvhEmOnuDHkT9IqGXsY9ScAvR8c=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m2t1A-0004Fq-9D; Mon, 12 Jul 2021 12:18:28 +0200
Subject: Re: [PATCH nf] Revert "netfilter: flowtable: Remove redundant hw
 refresh bit"
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, olek2@wp.pl, roid@nvidia.com
References: <20210614215351.GA734@salvia>
 <20210711010244.1709329-1-martin.blumenstingl@googlemail.com>
 <20210712094652.GA6320@salvia>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <f9f01b3b-f6ab-ef82-6604-5dd8e925abea@nbd.name>
Date:   Mon, 12 Jul 2021 12:18:26 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210712094652.GA6320@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-07-12 11:46, Pablo Neira Ayuso wrote:
> Maybe the user reporting this issue is enabling the --hw option?
> As I said, the patch that is being proposed to be revert is just
> amplifying.
> 
> The only way to trigger this bug that I can find is:
> 
> - NF_FLOWTABLE_HW_OFFLOAD is enabled.
> - packets are following the software path.
> 
> I don't see yet how this can happen with upstream codebase, nftables
> enables NF_FLOWTABLE_HW_OFFLOAD at configuration time, if the driver
> does not support for hardware offload, then NF_FLOWTABLE_HW_OFFLOAD is
> not set.
> 
> Is xt_flowoffload rejecting the rule load if user specifies --hw and
> the hardware does not support for hardware offload?
> 
> By reading Felix's discussion on the IRC, it seems to me he does not
> like that the packet path retries to offload flows. If so, it should
> be possible to add a driver flag to disable this behaviour, so driver
> developers select what they prefer that flowtable core retries to
> offload entries. I can have a look into adding such flag and use it
> from the mtk driver.
I'd prefer making the retry behavior depend on the error code during
setup. For example, if we get -ENOMEM, -EAGAIN or something like that,
we should definitely retry.
If we get -EOPNOTSUPP or -EINVAL, I don't think a retry makes any sense
on any driver.

- Felix
