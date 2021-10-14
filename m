Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E5242DB08
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhJNOEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:04:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhJNOEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 10:04:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFB7060D07;
        Thu, 14 Oct 2021 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634220130;
        bh=TiEabhn5ARhjlEpC9/usidwzgzF5FoyqmA9TadcjUyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k/CgIJL0rNLhgXb1xRDQw48sdoPHvUJtjKf2NcVp9AiUMPnDSscnRbUAo1NnqP6PF
         a8GFovmm+HCmd4K+w7mZ0JwpenLrw75Y4EF9MNeSMR7y1ONXn0xvdI17XpjBzkDyzI
         ORC+3t7QcXeAW4icovTETGsNhoeZsrsKgvusVIHpx29MXHxo3wWLplwclurvk640Em
         rrIK4ypPhkY2kimZ85hUL4N5GfnelwDzjqNYpQMbuGHhmmPO11rzq2s/CGN9xfoey/
         0xJRLCHo4Ltlph7jUwjtll44mBVUpsLGsv3uGYXBdHqWIpLft9g/u+TEs98DZts5A5
         7Kk3fOi0XQVrQ==
Date:   Thu, 14 Oct 2021 07:02:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net, neigh: Use NLA_POLICY_MASK helper for
 NDA_FLAGS_EXT attribute
Message-ID: <20211014070208.3cd7e679@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <687e2be1-4d16-1f71-bb25-1f27a04d06f0@iogearbox.net>
References: <20211013132140.11143-1-daniel@iogearbox.net>
        <20211013132140.11143-3-daniel@iogearbox.net>
        <8be43259-1fc1-2c62-3cd1-100bde6ff702@gmail.com>
        <687e2be1-4d16-1f71-bb25-1f27a04d06f0@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Oct 2021 10:10:18 +0200 Daniel Borkmann wrote:
> On 10/14/21 5:13 AM, David Ahern wrote:
> > On 10/13/21 7:21 AM, Daniel Borkmann wrote:  
> >> Instead of open-coding a check for invalid bits in NTF_EXT_MASK, we can just
> >> use the NLA_POLICY_MASK() helper instead, and simplify NDA_FLAGS_EXT sanity
> >> check this way.
> >>
> >> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> >> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> >> ---
> >>   net/core/neighbour.c | 6 +-----
> >>   1 file changed, 1 insertion(+), 5 deletions(-)
> >>
> >> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> >> index 4fc601f9cd06..922b9ed0fe76 100644
> >> --- a/net/core/neighbour.c
> >> +++ b/net/core/neighbour.c
> >> @@ -1834,7 +1834,7 @@ const struct nla_policy nda_policy[NDA_MAX+1] = {
> >>   	[NDA_MASTER]		= { .type = NLA_U32 },
> >>   	[NDA_PROTOCOL]		= { .type = NLA_U8 },
> >>   	[NDA_NH_ID]		= { .type = NLA_U32 },
> >> -	[NDA_FLAGS_EXT]		= { .type = NLA_U32 },
> >> +	[NDA_FLAGS_EXT]		= NLA_POLICY_MASK(NLA_U32, NTF_EXT_MASK),
> >>   	[NDA_FDB_EXT_ATTRS]	= { .type = NLA_NESTED },
> >>   };
> >>   
> >> @@ -1936,10 +1936,6 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
> >>   	if (tb[NDA_FLAGS_EXT]) {
> >>   		u32 ext = nla_get_u32(tb[NDA_FLAGS_EXT]);
> >>   
> >> -		if (ext & ~NTF_EXT_MASK) {
> >> -			NL_SET_ERR_MSG(extack, "Invalid extended flags");
> >> -			goto out;
> >> -		}
> >>   		BUILD_BUG_ON(sizeof(neigh->flags) * BITS_PER_BYTE <
> >>   			     (sizeof(ndm->ndm_flags) * BITS_PER_BYTE +
> >>   			      hweight32(NTF_EXT_MASK)));
> >>  
> > 
> > I get that NLA_POLICY_MASK wants to standardize the logic, but the
> > generic extack message "reserved bit set" is less useful than the one here.  
> 
> If the expectation/recommendation is that NLA_POLICY_MASK() should be used, then
> it would probably make sense for NLA_POLICY_MASK() itself to improve. For example,
> NLA_POLICY_MASK() could perhaps take an optional error string which it should
> return via extack rather than the standard "reserved bit set" one or such.. on
> the other hand, I see that NL_SET_ERR_MSG_ATTR() already points out the affected
> attribute via setting extack->bad_attr, so it be sufficient to figure out that it's
> about reserved bits inside NDA_FLAGS_EXT given this is propagated back to user
> space via NLMSGERR_ATTR_OFFS.

My larger point is that the ability to dump policy and inspect it in
user space is an important part of the modern netlink paradigm. When
RTNL is extended appropriately it'll be good if the policies are
expressed the right way.

Fingers-on-the-keyboard-eyes-on-the-screen user friendliness is
important but IMHO code that can be built on top of these interfaces 
is more important.

I think the patch is good as is.
