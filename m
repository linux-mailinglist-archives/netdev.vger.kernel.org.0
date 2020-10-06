Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7091284EA3
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgJFPKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJFPKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 11:10:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DD9C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 08:10:48 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPoc1-000JIX-BY; Tue, 06 Oct 2020 17:10:45 +0200
Message-ID: <0f534e06a9b2248cc4a5ae941caf7772a864a68f.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] netlink: export policy in extended ACK
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 06 Oct 2020 17:10:44 +0200
In-Reply-To: <20201006142714.3c8b8db03517.I6dae2c514a6abc924ee8b3e2befb0d51b086cf70@changeid>
References: <20201006123202.57898-1-johannes@sipsolutions.net>
         <20201006142714.3c8b8db03517.I6dae2c514a6abc924ee8b3e2befb0d51b086cf70@changeid>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, hat to run out earlier and forgot to comment here.

On Tue, 2020-10-06 at 14:32 +0200, Johannes Berg wrote:
> 
> +	/* the max policy content is currently ~44 bytes for range min/max */
> +	if (err && nlk_has_extack && extack && extack->policy)
> +		tlvlen += 64;

So I'm not really happy with this. I counted 44 bytes content (so 48
bytes for the nested attribute) for the biggest that we have now, but if
we ever implement e.g. dumping out the reject string for NLA_REJECT
(though not sure anyone even uses that?) then it'd be more variable.

I couldn't really come up with any better idea, but I believe we do need
to size the skb fairly well to return the original one ...

The only solution I _could_ think of was to allocate another skb, put
the attribute into it, check the length, and then later append it to the
message ... but that seemed kinda ugly.

Any preferences?

johannes

