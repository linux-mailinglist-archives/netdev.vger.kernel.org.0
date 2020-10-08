Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460C8287148
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgJHJOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgJHJOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:14:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F15C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 02:14:02 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kQRzi-001VV8-0p; Thu, 08 Oct 2020 11:13:50 +0200
Message-ID: <11e6b06a5d58fd1a9d108bc9c40b348311b024ba.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v2 3/7] ethtool: trim policy tables
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, mkubecek@suse.cz
Date:   Thu, 08 Oct 2020 11:13:49 +0200
In-Reply-To: <7d89d3a5-884c-5aba-1248-55f9cbecbd89@gmail.com> (sfid-20201008_111205_538911_A87CA2B2)
References: <20201005220739.2581920-1-kuba@kernel.org>
         <20201005220739.2581920-4-kuba@kernel.org>
         <7d89d3a5-884c-5aba-1248-55f9cbecbd89@gmail.com>
         (sfid-20201008_111205_538911_A87CA2B2)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-08 at 11:12 +0200, Eric Dumazet wrote:
> 
> On 10/6/20 12:07 AM, Jakub Kicinski wrote:
> > Since ethtool uses strict attribute validation there's no need
> > to initialize all attributes in policy tables. 0 is NLA_UNSPEC
> > which is going to be rejected. Remove the NLA_REJECTs.
> > 
> > Similarly attributes above maxattrs are rejected, so there's
> > no need to always size the policy tables to ETHTOOL_A_..._MAX.
> > 
> 
> This implies that all policy tables must be 'complete'.
> 
> strset_stringsets_policy[] for example is :
> 
> static const struct nla_policy strset_stringsets_policy[] = {
>     [ETHTOOL_A_STRINGSETS_STRINGSET]    = { .type = NLA_NESTED },
> };
> 
> So when later strset_parse_request() does :
> 
> req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
> 
> We have an out-of-bound access since ETHTOOL_A_STRSET_COUNTS_ONLY > ETHTOOL_A_STRINGSETS_STRINGSET

Yeah, Leon Romanovsky reported actually running into this yesterday, and
I sent a fix :-)

> Not sure what was the expected type for this attribute, the kernel
> only looks at its presence, not its value.

It was NLA_FLAG, but never actually in the policy, so you could never
even successfully use it ...

Here was the fix
https://lore.kernel.org/netdev/20201007125348.a74389e18168.Ieab7a871e27b9698826e75dc9e825e4ddbc852b1@changeid/

johannes

