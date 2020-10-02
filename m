Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AEA281567
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388091AbgJBOkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBOkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:40:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ECEC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 07:40:09 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOMEA-00FHy7-47; Fri, 02 Oct 2020 16:40:06 +0200
Message-ID: <58172ec0f7e74c63206121bf6d8f02481f47ee5a.camel@sipsolutions.net>
Subject: Re: [PATCH] genl: ctrl: print op -> policy idx mapping
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 02 Oct 2020 16:39:50 +0200
In-Reply-To: <248a5646-9dc8-c640-e334-31e9d50495e8@gmail.com> (sfid-20201002_162939_079515_7577AFA3)
References: <20201002102609.224150-1-johannes@sipsolutions.net>
         <248a5646-9dc8-c640-e334-31e9d50495e8@gmail.com>
         (sfid-20201002_162939_079515_7577AFA3)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-02 at 07:29 -0700, David Ahern wrote:
> On 10/2/20 3:26 AM, Johannes Berg wrote:
> > diff --git a/genl/ctrl.c b/genl/ctrl.c
> > index 68099fe97f1a..c62212b40fa3 100644
> > --- a/genl/ctrl.c
> > +++ b/genl/ctrl.c
> > @@ -162,6 +162,16 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
> >  		__u32 *ma = RTA_DATA(tb[CTRL_ATTR_MAXATTR]);
> >  		fprintf(fp, " max attribs: %d ",*ma);
> >  	}
> > +	if (tb[CTRL_ATTR_OP_POLICY]) {
> > +		const struct rtattr *pos;
> > +
> > +		rtattr_for_each_nested(pos, tb[CTRL_ATTR_OP_POLICY]) {
> > +			__u32 *v = RTA_DATA(pos);
> > +
> > +			fprintf(fp, " op %d has policy %d",
> > +				pos->rta_type, *v);
> 
> did you look at pretty printing the op and type? I suspect only numbers
> are going to cause a lot of staring at header files while counting to
> decipher number to text.

I didn't really, but it's also rather tricky?

The policy index can't be pretty printed anyway, it's literally an
ephemeral index that's valid only within that dump operation. Not that a
next one might be different, but if you change the kernel it may well
be.

Pretty-printing the op would mean maintaining all those strings in the
policy (or so) in the kernel? That seems like a _lot_ of memory usage
(as well as new code), just for this?

And otherwise it can't really be done generically in 'genl' because it
doesn't know anything about the families...

For a specific family you can, I guess. E.g. for nl80211 I might add
policy dump support with op and attribute type pretty-printing, based on
generating string tables from nl80211.h at build time.

But in general, I don't see how that could be doable.


Oh, and completely unrelated, but I forgot to mention it before: this
patch of course depends on the corresponding kernel patches I had posted
a bit earlier.

johannes

