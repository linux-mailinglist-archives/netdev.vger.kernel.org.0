Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4306058A6
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiJTHcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiJTHcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:32:36 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B4516EA1D
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=0XL+Bo6JL7tOrlyi5GwtltZ3Y4ZTvUdfQo54VVIV8Jc=;
        t=1666251145; x=1667460745; b=wM1cKdY4LzskCb5236QPdeIxkXOUh3gIxikSu80Lgc10sjQ
        /BDD49AGM3fcU+bu/B4e1/0zXOu+OrZR8yyudACZl5Z9OejEz68//rlKyhOnIdP/An9U8g5do4Pjc
        mOZhWLdRKpGRSewIUVLDqpm8lZCKa3gr+/I5uU28P4vr7gyHWCMF5JdnbdYHIlKiLbd9q2utr4ksc
        qnWkJnIjJVUrTeyP6qS43/odv5EOty4KIdyec4ve+vpQt3ogzkq9jF8wbj3/QWcjKHGADPolDd5r1
        wuVR74wHA8WfZGKkaEOA3jIksvirpz/cuJTobwL9Qbus/vZk7eukUdIzjknH9tMQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1olQ2M-00Btfp-2O;
        Thu, 20 Oct 2022 09:32:18 +0200
Message-ID: <683f4c655dd09a2af718956e8c8d56e6451e11ac.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 12/13] genetlink: allow families to use split
 ops directly
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        jacob.e.keller@intel.com, fw@strlen.de
Date:   Thu, 20 Oct 2022 09:32:17 +0200
In-Reply-To: <20221019125745.3f2e7659@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-13-kuba@kernel.org>
         <a23c47631957c3ba3aaa87bc325553da04f99a0c.camel@sipsolutions.net>
         <20221019122504.0cb9d326@kernel.org>
         <dfac0b6e09e9739c7f613cb8ed77c81f9db0bb44.camel@sipsolutions.net>
         <20221019125745.3f2e7659@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-10-19 at 12:57 -0700, Jakub Kicinski wrote:
> > Oh, I see now, you were basically saying "it's only 9% bigger for all
> > that extra flexibility" ... didn't read that right before.
>=20
> Yup, BTW one annoying bit is that we treat maxattr =3D=3D 0 as=20
> "no validation" rather than "reject everything".
>=20
> Right now I add a reject-all policy in the family itself (with two
> entries, argh), and hook it up to parameter-less dumps. But we could=20
> do something else - like modify the behavior in case the op was declared
> as split at the family level.
>=20
> I opted for having family add the reject-all policy because I code gen
> the policies based on YAML spec, anyway, so not much extra effort, and
> the uniformity between different type of ops seems worth maintaining.
>=20
> WDYT?

Hmm. The codegen/YAML part likely won't really happen for all of the
families so perhaps some simplification would be good?

I feel like I probably should've changed this when adding
GENL_DONT_VALIDATE_DUMP_STRICT / GENL_DONT_VALIDATE_STRICT, but I guess
that's too late now :(

I guess we could add another set of flags, but that'd be annoying.

OTOH, it's nicer if future things are better, and we don't need to add a
"reject all" policy to all of them?

johannes
