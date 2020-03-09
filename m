Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52E2A17EB4C
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 22:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgCIVgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 17:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgCIVgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 17:36:33 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC77624649;
        Mon,  9 Mar 2020 21:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583789792;
        bh=SdWtHnMAwBNnf4keZ7lmm+B5l2JSIfY6JcxS+mLFFco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZP+D641yB/RbUbAEV/InmiMOGnk/uQrptpkg44eNb4CkVI2/EO7IaKMYbvdYrfASp
         A+bAP+oZebkMoG+bTxdVKNj5fW7BeiPkDIetytB23GJQn8k9H/J1iPJQ2QBBy6cWCo
         5KvfI0c2g+t8uUabvj6g1y9JuXPE7c6071JeAsso=
Date:   Mon, 9 Mar 2020 14:36:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <pablo@netfilter.org>,
        <mlxsw@mellanox.com>
Subject: Re: [patch net-next v4 01/10] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200309143630.2f83476f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
References: <20200307114020.8664-1-jiri@resnulli.us>
        <20200307114020.8664-2-jiri@resnulli.us>
        <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Mar 2020 16:52:16 +0000 Edward Cree wrote:
> On 07/03/2020 11:40, Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@mellanox.com>
> >
> > Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
> > current implicit value coming down to flow_offload. Add a bool
> > indicating that entries have mixed HW stats type.
> >
> > Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> > ---
> > v3->v4:
> > - fixed member alignment
> > v2->v3:
> > - moved to bitfield
> > - removed "mixed" bool
> > v1->v2:
> > - moved to actions
> > - add mixed bool
> > ---
> >  include/net/flow_offload.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > index cd3510ac66b0..93d17f37e980 100644
> > --- a/include/net/flow_offload.h
> > +++ b/include/net/flow_offload.h
> > @@ -154,6 +154,8 @@ enum flow_action_mangle_base {
> >  	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
> >  };
> > =20
> > +#define FLOW_ACTION_HW_STATS_TYPE_ANY 0 =20
> I'm not quite sure why switching to a bit fieldapproach means these
> =C2=A0haveto become #defines rather than enums...

Perhaps having enum defining the values could be argued...

> > +
> >  typedef void (*action_destr)(void *priv);
> > =20
> >  struct flow_action_cookie {
> > @@ -168,6 +170,7 @@ void flow_action_cookie_destroy(struct flow_action_=
cookie *cookie);
> > =20
> >  struct flow_action_entry {
> >  	enum flow_action_id		id;
> > +	u8				hw_stats_type; =20
> ... causing this to become a u8with nothing obviously preventing
> =C2=A0a HW_STATS_TYPE bigger than 255 getting defined.
> An enum type seems safer.

...but using the type for fields which are very likely to contain
values from outside of the enumeration seems confusing, IMHO.

Driver author can understandably try to simply handle all the values=20
in a switch statement and be unpleasantly surprised.
