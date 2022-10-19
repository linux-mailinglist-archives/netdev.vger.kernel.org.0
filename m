Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C64603AF0
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 09:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiJSHu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 03:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJSHu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 03:50:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1765E5FF54
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 00:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=F305I/bNYEbc33wVsrAaRYeF9Dt6ZHLxN9cuBqvxAKg=;
        t=1666165826; x=1667375426; b=J3yRn7gun6b25szKWnhRhEC3l5qUpG2IA9ZO49CsbzPpYDb
        qMBUjgvo7OFxOfay2cfKnoLR+AnSidV+QNoB/qlkBqtkplTzyKAq4yBhPPohsGASx/laydhAeUt8K
        OBWgOfU/c5WK3+268ODoEnnDNdrUCLAWwkIhRaZpMZDjgrE++DQEdDAu0CQtH4Jt09dgy4gKoK9mA
        NBFacizXPMPpaGF8cTB7MxZYrtUABeAvLEQBp8IYvkuhivK4T2WxLNUZY3uZ7RqTc15ygWHtQsGfX
        gExqPUx1t8GHQHbhEdWfvmInFEE/0BTVS4SuesSB2Qy+HdzzvvFffB6YaSS3aF6A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ol3qD-00B14Y-2t;
        Wed, 19 Oct 2022 09:50:18 +0200
Message-ID: <68eaa8749d8ad971b34cce82f4306e77ccccbf3a.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 01/13] genetlink: refactor the cmd <> policy
 mapping dump
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de
Date:   Wed, 19 Oct 2022 09:50:16 +0200
In-Reply-To: <20221018230728.1039524-2-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-2-kuba@kernel.org>
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
> The code at the top of ctrl_dumppolicy() dumps mappings between
> ops and policies. It supports dumping both the entire family and
> single op if dump is filtered. But both of those cases are handled
> inside a loop, which makes the logic harder to follow and change.
> Refactor to split the two cases more clearly.

Hmm. Yeah, fair, it's nicer now :)

However,

>  	if (!ctx->policies) {
> -		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
> -			struct genl_ops op;
> +		struct genl_ops op;
> =20
> -			if (ctx->single_op) {
> -				int err;
> +		if (ctx->single_op) {
> +			int err;
> =20
> -				err =3D genl_get_cmd(ctx->op, ctx->rt, &op);
> -				if (WARN_ON(err))
> -					return skb->len;
> +			err =3D genl_get_cmd(ctx->op, ctx->rt, &op);
> +			if (WARN_ON(err))
> +				return err;
> =20
> -				/* break out of the loop after this one */
> -				ctx->opidx =3D genl_get_cmd_cnt(ctx->rt);
> -			} else {
> -				genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
> -			}
> +			if (ctrl_dumppolicy_put_op(skb, cb, &op))
> +				return skb->len;
> +
> +			ctx->opidx =3D genl_get_cmd_cnt(ctx->rt);

This (now without a comment that you removed rather than changed), still
strikes me as odd.

I guess if we add a comment /* don't enter the loop below */ that'd be
nicer, but I feel maybe putting the loop into the else instead would be
nicer?


johannes
