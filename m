Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DE36E4FA6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjDQRwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDQRwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:52:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAE540FC;
        Mon, 17 Apr 2023 10:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6871628D8;
        Mon, 17 Apr 2023 17:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590E0C433EF;
        Mon, 17 Apr 2023 17:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681753951;
        bh=KUWjXDPTi3zx4/aPtq9cu6CjLL1a2cS0RTwS+jLqeXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GyKhjju38oDxcu+ziCWD7KV7feK0ctul+XMO8fJzxDUPamU6KI/8qqWMTfJSKwthb
         hr9iLhJjTljD4TtxRqdFcdx324GVZhFTMB7TaqJZw9337rFvLuH7vrYSw57/5n+Dak
         mzKJMgLShjqSOLVv8A3Q6nkAdR2wwrtLyDXxR0p3Q/OATOQFyFV4Hish0JvuG5xo4d
         KZed9yxKQqRJULKioPAfD33fkRaFbWcz3WM2gaG2q78xCvyMwQYIxbAgjOB+54UnQT
         g+qXhT5jMrCB1PCnB+KYjEpEbjWUmdIY68h8XhNjyuIhNnlnZircAw0TBbF2cngkt9
         p5BKB06tH6vIw==
Date:   Mon, 17 Apr 2023 10:52:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3,net-next, 3/4] net: mana: Enable RX path to handle
 various MTU sizes
Message-ID: <20230417105229.7d1eb988@kernel.org>
In-Reply-To: <PH7PR21MB3116023068CFA8D600FA5B18CA9E9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
        <1681334163-31084-4-git-send-email-haiyangz@microsoft.com>
        <20230414190608.3c21f44f@kernel.org>
        <PH7PR21MB3116023068CFA8D600FA5B18CA9E9@PH7PR21MB3116.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Apr 2023 14:25:29 +0000 Haiyang Zhang wrote:
> > Allocating frag larger than a page is not safe. =20
>=20
>  I saw other drivers doing this - use napi_alloc_frag for size bigger tha=
n a page.
> And it returns compound page. Why it's not safe? Should we use other allo=
cator
> when need compound pages?

I believe so. There was a thread about this within the last year.
Someone was trying to fix the page frag allocator to not fall back
to order 0 pages in case of failure if requested size is > PAGE_SIZE.
But there was push back and folks were saying that it's simply not=20
a case supported by the frag allocator. =F0=9F=A4=B7=EF=B8=8F

> > Frag allocator falls back to allocating single pages, doesn't it? =20
>=20
> Actually I checked it. Compound page is still returned for size smaller t=
han PAGE_SIZE,
> so I used single page allocation for that.

https://elixir.bootlin.com/linux/v6.3-rc6/source/mm/page_alloc.c#L5723

Jumbo frames should really be supported as scatter transfers,=20
if possible.
