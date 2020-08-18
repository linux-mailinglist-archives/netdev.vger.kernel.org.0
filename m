Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08EC248048
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgHRIQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgHRIQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:16:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7095C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 01:16:01 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k7wmm-0067be-0m
        for netdev@vger.kernel.org; Tue, 18 Aug 2020 10:16:00 +0200
Message-ID: <0bd2e67bfaa0a4a88bdd790388bbae3b46299e74.camel@sipsolutions.net>
Subject: Re: [PATCH 3/3] netlink: make NLA_BINARY validation more flexible
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 18 Aug 2020 10:15:58 +0200
In-Reply-To: <20200818100639.fa7ed2ad4fb9.Ieb6502e26920e731a04d414245a28254519a26d8@changeid>
References: <20200818080819.10012-1-johannes@sipsolutions.net>
         <20200818100639.fa7ed2ad4fb9.Ieb6502e26920e731a04d414245a28254519a26d8@changeid>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +       if (pt->validation_type == NLA_VALIDATE_RANGE_WARN_TOO_LONG &&
> +           pt->type == NLA_BINARY && value > range.max) {
> +               pr_warn_ratelimited("netlink: '%s': attribute type %d has an invalid length.\n",
> +                                   current->comm, pt->type);
> +               if (validate & NL_VALIDATE_STRICT_ATTRS) {
> +                       NL_SET_ERR_MSG_ATTR(extack, nla,
> +                                           "invalid attribute length");
> +                       return -EINVAL;
> +               }
> +
> +               /* this assumes min < max (don't validate against min) */
> +               return 0;

This (return 0) is the only change since the RFC - otherwise we hit the
error return a few lines later, obviously.

I decided that min > max was nonsense and we don't really need to
validate that the attribute is >=min when it was >max already.

Though in theory, of course, somebody could specify such nonsense, I
just don't think it's reasonable. It's also very difficult to use
because we only have the NLA_POLICY_EXACT_LEN_WARN() macro using this,
so specifying min/max *and* NLA_VALIDATE_RANGE_WARN_TOO_LONG would take
some special dedication ...

Now that I read this again though of course I see that the comment is
wrong, it needs to of course say "min <= max". I'll send v2...

johannes

