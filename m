Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8143B2BCD
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhFXJvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:51:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231970AbhFXJvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624528175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AaxuCc7MF6STQtMRDUC9uPp9QcsP+FHFpIHOZFmA4Ew=;
        b=Zo40O3d8JKyfyGQS0Psjm8XsJCCdYtee6kvOpHCK/QUlQVtBT7S609gcPm0i9aWl78/DZB
        cY9VWTADUWqw0cCmC6POl8OKupe+hq/UaMp79QyXySQNuNG1XEH/rwX+mVlD0Ai9AD2T7t
        yx0UWCpnLmXe1HIZGUN3rc3dPF2CjUg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-3Ks6YttqPIax5KzWOQECOQ-1; Thu, 24 Jun 2021 05:49:33 -0400
X-MC-Unique: 3Ks6YttqPIax5KzWOQECOQ-1
Received: by mail-wm1-f72.google.com with SMTP id s80-20020a1ca9530000b02901cff732fde5so1425666wme.6
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 02:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AaxuCc7MF6STQtMRDUC9uPp9QcsP+FHFpIHOZFmA4Ew=;
        b=Cz6oPXKGyrgsRBWjPuabBraUCz/gLuPw1/2Jz7/qut8/Q3jaBMrZBOPlzPk4plzE+7
         ho/LnCqQVBzVAu8EpXONuTJhQqvfdhySZGT7+mxR2KlafFiWd4njh4SpU19+i7A/iycM
         qZTCSYuVWa+iIRPZtulDKZuYmnfDCanIlVJcdrDhLG7Eltnv57awwAC/7aaQYk6aMQFC
         JBAmcAs/qPYFir/+8U9V46GyYjMSd9sQBGeto6wzKBfuj1s0njo0/I3n/PaUj/4nOv3D
         11GwP6l6TJH2QXiryIGRGKZqaGdnQ+K9H0rZMDmSKkTKCL7Kcl/t8jEXoV5/qvZG+dqF
         S+DQ==
X-Gm-Message-State: AOAM532Od7kfOzuNEw5PLxtIMSMgGIqcEncCHlt21zVcgczZAq0OVTOI
        nuIrEeywMwiPlx6vvppfPfUTyiuDkSFPW4AXAjv1kg42Us8TBtRrnWEQdzCLUzMSwx0X5E4/l9Q
        TAVtWYuESb4fL8aEc
X-Received: by 2002:a5d:6646:: with SMTP id f6mr3339979wrw.399.1624528172514;
        Thu, 24 Jun 2021 02:49:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlbMr8ygwlV2D6r8tmAibtIQsfA1Q+1UmXSQBSdAxsidGcU1vvLJ2eZY2m+mAf1Gy3cIxeQg==
X-Received: by 2002:a5d:6646:: with SMTP id f6mr3339961wrw.399.1624528172314;
        Thu, 24 Jun 2021 02:49:32 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-109-224.dyn.eolo.it. [146.241.109.224])
        by smtp.gmail.com with ESMTPSA id z8sm761660wrw.18.2021.06.24.02.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 02:49:31 -0700 (PDT)
Message-ID: <e0e59d780e1c979c2666e8bc77ce00249ac3e6e1.camel@redhat.com>
Subject: Re: [PATCH net] ipv6: fix out-of-bound access in ip6_parse_tlv()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@herbertland.com>
Date:   Thu, 24 Jun 2021 11:49:30 +0200
In-Reply-To: <20210623194353.2021745-1-eric.dumazet@gmail.com>
References: <20210623194353.2021745-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-23 at 12:43 -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> First problem is that optlen is fetched without checking
> there is more than one byte to parse.
> 
> Fix this by taking care of IPV6_TLV_PAD1 before
> fetching optlen (under appropriate sanity checks against len)
> 
> Second problem is that IPV6_TLV_PADN checks of zero
> padding are performed before the check of remaining length.
> 
> Fixes: c1412fce7ecc ("net/ipv6/exthdrs.c: Strict PadN option checking")

Perhaps even:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

for the first issue?

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Tom Herbert <tom@herbertland.com>
> ---
> 
> Only compiled, I would appreciate a solid review of this patch before merging it, thanks !
> 
>  net/ipv6/exthdrs.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index 6f7da8f3e2e5849f917853984c69bf02a0f1e27c..007959d4d3748f1e21f83946024a9967d08b25b6 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
> @@ -135,18 +135,24 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>  	len -= 2;
>  
>  	while (len > 0) {
> -		int optlen = nh[off + 1] + 2;
> -		int i;
> +		int optlen, i;
>  
> -		switch (nh[off]) {
> -		case IPV6_TLV_PAD1:
> +		if (nh[off] == IPV6_TLV_PAD1) {
>  			optlen = 1;

It looks like the above assignment is not needed anymore.

Other than that LGTM,

Thanks!

Paolo

