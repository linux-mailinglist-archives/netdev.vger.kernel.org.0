Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7FF0B7
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfD3Gvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:51:51 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52464 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfD3Gvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 02:51:51 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hLMcC-0003vR-Rd; Tue, 30 Apr 2019 08:51:44 +0200
Message-ID: <c64504ca3ec2946f4d1575b7a28279f606fbd3d9.camel@sipsolutions.net>
Subject: Re: [PATCH 2/6] netlink: extend policy range validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, dsa@cumulusnetworks.com,
        pablo@netfilter.org
Date:   Tue, 30 Apr 2019 08:51:43 +0200
In-Reply-To: <20190429.224951.1389806535373048089.davem@davemloft.net>
References: <20190426121306.10871-1-johannes@sipsolutions.net>
         <20190426121306.10871-3-johannes@sipsolutions.net>
         <20190429.224951.1389806535373048089.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-04-29 at 22:49 -0400, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Fri, 26 Apr 2019 14:13:02 +0200
> 
> >   *                         NLA_POLICY_RANGE() macros.
> > + *    NLA_U8,
> > + *    NLA_U16,
> > + *    NLA_U32,
> > + *    NLA_U64              If the validation_type field instead is set to
> > + *                         NLA_VALIDATE_RANGE_PTR, `range' must be a pointer
> > + *                         to a struct netlink_range_validation that indicates
> > + *                         the min/max values.
> > + *                         Use NLA_POLICY_FULL_RANGE().
> > + *    NLA_S8,
> > + *    NLA_S16,
> > + *    NLA_S32,
> > + *    NLA_S64              If the validation_type field instead is set to
> > + *                         NLA_VALIDATE_RANGE_PTR, `range_signed' must be a
> > + *                         pointer to a struct netlink_range_validation_signed
> > + *                         that indicates the min/max values.
> > + *                         Use NLA_POLICY_FULL_RANGE_SIGNED().
> 
> Documentation and datastructure says that "range_signed" member should be set
> for signed ranges, however:
> 
> > +#define NLA_POLICY_FULL_RANGE(tp, _range) {          \
> > +     .type = NLA_ENSURE_UINT_TYPE(tp),               \
> > +     .validation_type = NLA_VALIDATE_RANGE_PTR,      \
> > +     .range = _range,                                \
> > +}
> > +
> > +#define NLA_POLICY_FULL_RANGE_SIGNED(tp, _range) {   \
> > +     .type = NLA_ENSURE_SINT_TYPE(tp),               \
> > +     .validation_type = NLA_VALIDATE_RANGE_PTR,      \
> > +     .range = _range,                                \
> > +}
> 
> The NLA_POLICY_FULL_RANGE_SIGNED macros sets 'range' not 'range_signed'.

D'oh. Copy/paste error, and I must've missed the compiler warning that
should appear here on usage then. At least I'm pretty sure I tested that
with the policy exposition patch.

Will fix.

> Also, since range and range_signed are in a union however there is only one
> NLA_VALIDATE_RANGE_PTR type, how does one differentiate between signed and
> unsigned ranges exactly?

Based on the type - NLA_S* or NLA_U*. See the NLA_ENSURE_SINT_TYPE() and
NLA_ENSURE_UINT_TYPE() in the macros - that ensures you can only use
NLA_POLICY_FULL_RANGE_SIGNED() with NLA_S*, and NLA_POLICY_FULL_RANGE()
with NLA_U*.

johannes

