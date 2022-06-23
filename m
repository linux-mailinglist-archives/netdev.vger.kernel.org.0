Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4F3557F41
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiFWQEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbiFWQED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:04:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAD73DDC6
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60F3261E63
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:04:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706E2C3411B;
        Thu, 23 Jun 2022 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656000241;
        bh=GRbVMlsyAxflirQmRT8Z1amiafYP1YMxtIVFLV4M4Nc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pIK8BwR5x6FeQv4TO0ln30eQqDiXNTMM7iiz90nIjPdNf1FlpEaqamu36UQfBSgAN
         gJAZXYE+IVd/pDPCa8Q8kZXybHzaMtyhFAIBQrrsSEevN2CmwNRPGl4+tFpBXVJgpc
         R8qGVQCMxuxL9/y9U+lGVFc/sNnDguifmnpqeSb04hqCBnYaCScczV5HFGqr1YueZk
         D+5EN4fvgOhbn/a7RMPZiQa4lTLJuDkghgUfsImFMkQQOEf4ezp/ZxjSfJMAdC3TeR
         Oe00ZSLw519nB7Af5bRbHlsQcI7Va5bvpEbfgiKWXgXLi6rIHRb85/dUd13f4XmBVP
         lPfT+YhM+4U+A==
Date:   Thu, 23 Jun 2022 09:03:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ismael Luceno <iluceno@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220623090352.69bf416c@kernel.org>
In-Reply-To: <fef8b8d5-e07d-6d8f-841a-ead4ebee8d29@gmail.com>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
        <20220616171612.66638e54@kernel.org>
        <20220617150110.6366d5bf@pirotess>
        <20220622131218.1ed6f531@pirotess>
        <20220622165547.71846773@kernel.org>
        <fef8b8d5-e07d-6d8f-841a-ead4ebee8d29@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 22:01:37 -0600 David Ahern wrote:
> > Right, the question is what message can we introduce here which would
> > not break old user space? =20
>=20
> I would hope a "normal"

"normal" =3D=3D with no attributes?

> message with just the flags set is processed by
> userspace. iproute2 does - lib/libnetlink.c, rtnl_dump_filter_l(). It
> checks the nlmsg_flags first.

=F0=9F=A4=9E

> > The alternative of not wiping the _DUMP_INTR flag as we move thru
> > protocols seems more and more appealing, even tho I was initially
> > dismissive.
> >=20
> > We should make sure we do one last consistency check before we return 0
> > from the handlers. Or even at the end of the loop in rtnl_dump_all(). =
=20
>=20
> Seems like netlink_dump_done should handle that for the last dump?

Yeah, the problem is:
 - it gets lost between families when dumping all, and
 - if the dump get truncated _DUMP_INTR never gets set because many
   places only check consistency when outputting an object.

> That said, in rtnl_dump_all how about a flags check after dumpit() and
> send the message if INTR is set? would need to adjust the return code of
> rtnl_dump_all so netlink_dump knows the dump is not done yet.

Yup, the question for me is what's the risk / benefit of sending=20
the empty message vs putting the _DUMP_INTR on the next family.
I'm leaning towards putting it on the next family and treating=20
the entire dump as interrupted, do you reckon that's suboptimal?
User space can always dump family by family if it cares about
breaking the entire dump.

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ac45328607f7..c36874d192ef 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3879,6 +3879,7 @@ static int rtnl_dump_all(struct sk_buff *skb, struct =
netlink_callback *cb)
 			continue;
=20
 		if (idx > s_idx) {
+			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 			memset(&cb->args[0], 0, sizeof(cb->args));
 			cb->prev_seq =3D 0;
 			cb->seq =3D 0;

