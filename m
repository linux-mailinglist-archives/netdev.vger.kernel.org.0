Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099BD283FD3
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 21:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbgJETqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 15:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgJETqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 15:46:08 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09064C0613CE
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 12:46:08 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kPWQt-00HP4E-FU; Mon, 05 Oct 2020 21:46:03 +0200
Message-ID: <d896585af214e015963a9989375246242bc1bb65.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
Date:   Mon, 05 Oct 2020 21:46:02 +0200
In-Reply-To: <20201005124147.1d4111e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201005155753.2333882-1-kuba@kernel.org>
         <20201005155753.2333882-2-kuba@kernel.org>
         <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
         <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <de5a03325d397fe559ce6c6182dfedc0cdad2c3b.camel@sipsolutions.net>
         <20201005123120.7e8caa84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3e793f3b5c99bb4a5584d621b1dd5b30e62d81f2.camel@sipsolutions.net>
         <20201005124147.1d4111e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-05 at 12:41 -0700, Jakub Kicinski wrote:

> > Now you can freely add any attributes, and, due to strict validation,
> > anything not specified in the policy will be rejected, whether by being
> > out of range (> maxattr) or not specified (NLA_UNSPEC).
> 
> 100%, but in ethtool policy is defined in a different compilation unit
> than the op array.

Ah. OK, then that won't work, of course, never mind.

I'd probably go with your preference then, but perhaps drop the actual
size definition:

const struct nla_policy policy[] = {
...
};

extern const struct nla_policy policy[OTHER_ATTR + 1];

op = {
        .policy = policy,
        .max_attr = ARRAY_SIZE(policy) - 1,
}


But that'd really just be to save typing copying it if it ever changes,
since it's compiler checked for consistency.

johannes

