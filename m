Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E7E603B0B
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiJSIBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJSIBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:01:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0990326F5
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 01:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=M4APoZrw/9JHurzx/YamG8j5s0W48VvWekEDngOvsis=;
        t=1666166472; x=1667376072; b=ewIfVSSdt0Am20sMgiN73dYsy4nMxgXRLJYIfsiSi3xImC9
        e/e62UQrmT0FmCWDHSVnJVAFaC0CB6rzD5i67WOVbvGIjbYfafUBt6t7vdHLLHfwT+kDuxCTyju4H
        yrSvkxcBUCgZWZuUniJ7gSDVIJ+LVqTqWHqt6shGOGpuDgChG9/LPE8XCm+dbzsrJjK6iBRORKdAu
        BHssylLDLbudmVLo5nXr3IqdoxiFpDaAzriO2k/XwtVByXhJVspL8Fn4QKB4LGVWkJDodRtpvg57M
        +A+Vd6nvBvP9N5Zy37JNza3VCwTEo+a4RgDh29DM9KfwiHlYyyePyhz13ZpI8RMw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ol40f-00B1KE-10;
        Wed, 19 Oct 2022 10:01:05 +0200
Message-ID: <4c0f8e0aa1ed0b84bf7074bd963fcaec96eff515.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 04/13] genetlink: load policy based on
 validation flags
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de
Date:   Wed, 19 Oct 2022 10:01:04 +0200
In-Reply-To: <20221018230728.1039524-5-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-5-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-18 at 16:07 -0700, Jakub Kicinski wrote:
> Set the policy and maxattr pointers based on validation flags.


I feel like you could have more commit message here

>  	ops =3D ctx->ops;
> -	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
> -		goto no_attrs;
> -
> -	if (ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
> +	if (!(ops->validate & GENL_DONT_VALIDATE_DUMP) &&
> +	    ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
>  		return -EINVAL;
> =20
>  	attrs =3D genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ctx->e=
xtack,

especially since this actually changes things to *have* the attrs, but
not have *validated* them, which feels a bit strange and error-prone in
the future maybe?

johannes
