Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E762927AACF
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgI1Jd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:33:56 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:54204 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbgI1Jd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 05:33:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 00CBD200AA;
        Mon, 28 Sep 2020 11:33:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WBC-QPeQ3xKS; Mon, 28 Sep 2020 11:33:50 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2D10E20504;
        Mon, 28 Sep 2020 11:33:50 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Sep 2020 11:33:49 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 28 Sep
 2020 11:33:49 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3EE86318470F; Mon, 28 Sep 2020 11:33:49 +0200 (CEST)
Date:   Mon, 28 Sep 2020 11:33:49 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dmitry Safonov <dima@arista.com>
CC:     <linux-kernel@vger.kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v3 0/7] xfrm: Add compat layer
Message-ID: <20200928093349.GJ20687@gauss3.secunet.de>
References: <20200921143657.604020-1-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200921143657.604020-1-dima@arista.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 03:36:50PM +0100, Dmitry Safonov wrote:
> Changes since v2:
> - added struct xfrm_translator as API to register xfrm_compat.ko with
>   xfrm_state.ko. This allows compilation of translator as a loadable
>   module
> - fixed indention and collected reviewed-by (Johannes Berg)
> - moved boilerplate from commit messages into cover-letter (Steffen
>   Klassert)
> - found on KASAN build and fixed non-initialised stack variable usage
>   in the translator
> 
> The resulting v2/v3 diff can be found here:
> https://gist.github.com/0x7f454c46/8f68311dfa1f240959fdbe7c77ed2259
> 
> Patches as a .git branch:
> https://github.com/0x7f454c46/linux/tree/xfrm-compat-v3
> 
> Changes since v1:
> - reworked patches set to use translator
> - separated the compat layer into xfrm_compat.c,
>   compiled under XFRM_USER_COMPAT config
> - 32-bit messages now being sent in frag_list (like wext-core does)
> - instead of __packed add compat_u64 members in compat structures
> - selftest reworked to kselftest lib API
> - added netlink dump testing to the selftest
> 
> XFRM is disabled for compatible users because of the UABI difference.
> The difference is in structures paddings and in the result the size
> of netlink messages differ.
> 
> Possibility for compatible application to manage xfrm tunnels was
> disabled by: the commmit 19d7df69fdb2 ("xfrm: Refuse to insert 32 bit
> userspace socket policies on 64 bit systems") and the commit 74005991b78a
> ("xfrm: Do not parse 32bits compiled xfrm netlink msg on 64bits host").
> 
> This is my second attempt to resolve the xfrm/compat problem by adding
> the 64=>32 and 32=>64 bit translators those non-visibly to a user
> provide translation between compatible user and kernel.
> Previous attempt was to interrupt the message ABI according to a syscall
> by xfrm_user, which resulted in over-complicated code [1].
> 
> Florian Westphal provided the idea of translator and some draft patches
> in the discussion. In these patches, his idea is reused and some of his
> initial code is also present.
> 
> There were a couple of attempts to solve xfrm compat problem:
> https://lkml.org/lkml/2017/1/20/733
> https://patchwork.ozlabs.org/patch/44600/
> http://netdev.vger.kernel.narkive.com/2Gesykj6/patch-net-next-xfrm-correctly-parse-netlink-msg-from-32bits-ip-command-on-64bits-host
> 
> All the discussions end in the conclusion that xfrm should have a full
> compatible layer to correctly work with 32-bit applications on 64-bit
> kernels:
> https://lkml.org/lkml/2017/1/23/413
> https://patchwork.ozlabs.org/patch/433279/
> 
> In some recent lkml discussion, Linus said that it's worth to fix this
> problem and not giving people an excuse to stay on 32-bit kernel:
> https://lkml.org/lkml/2018/2/13/752
> 
> There is also an selftest for ipsec tunnels.
> It doesn't depend on any library and compat version can be easy
> build with: make CFLAGS=-m32 net/ipsec
> 
> [1]: https://lkml.kernel.org/r/20180726023144.31066-1-dima@arista.com
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
> Cc: Dmitry Safonov <0x7f454c46@gmail.com>
> Cc: netdev@vger.kernel.org
> 
> Dmitry Safonov (7):
>   xfrm: Provide API to register translator module
>   xfrm/compat: Add 64=>32-bit messages translator
>   xfrm/compat: Attach xfrm dumps to 64=>32 bit translator
>   netlink/compat: Append NLMSG_DONE/extack to frag_list
>   xfrm/compat: Add 32=>64-bit messages translator
>   xfrm/compat: Translate 32-bit user_policy from sockptr
>   selftest/net/xfrm: Add test for ipsec tunnel

Series applied to ipsec-next. Thanks a lot for your work Dmitry!
