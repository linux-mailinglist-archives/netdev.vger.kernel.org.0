Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0020634A58A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCZK3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:29:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:52568 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhCZK2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 06:28:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5F37A20185;
        Fri, 26 Mar 2021 11:28:41 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nlpR4qj043xz; Fri, 26 Mar 2021 11:28:36 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 190E720569;
        Fri, 26 Mar 2021 11:28:36 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 26 Mar 2021 11:28:35 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 26 Mar
 2021 11:28:35 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 156863180307; Fri, 26 Mar 2021 11:28:35 +0100 (CET)
Date:   Fri, 26 Mar 2021 11:28:35 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Zhang Changzhong" <zhangchangzhong@huawei.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Willem de Bruijn <willemb@google.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH net-next] ipv6: fix clang Wformat warning
Message-ID: <20210326102835.GB62598@gauss3.secunet.de>
References: <20210322115701.4035289-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210322115701.4035289-1-arnd@kernel.org>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 12:56:49PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When building with 'make W=1', clang warns about a mismatched
> format string:
> 
> net/ipv6/ah6.c:710:4: error: format specifies type 'unsigned short' but the argument has type 'int' [-Werror,-Wformat]
>                         aalg_desc->uinfo.auth.icv_fullbits/8);
>                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/printk.h:375:34: note: expanded from macro 'pr_info'
>         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>                                 ~~~     ^~~~~~~~~~~
> net/ipv6/esp6.c:1153:5: error: format specifies type 'unsigned short' but the argument has type 'int' [-Werror,-Wformat]
>                                 aalg_desc->uinfo.auth.icv_fullbits / 8);
>                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> include/linux/printk.h:375:34: note: expanded from macro 'pr_info'
>         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>                                 ~~~     ^~~~~~~~~~~
> 
> Here, the result of dividing a 16-bit number by a 32-bit number
> produces a 32-bit result, which is printed as a 16-bit integer.
> 
> Change the %hu format to the normal %u, which has the same effect
> but avoids the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied to ipsec-next, thanks!
