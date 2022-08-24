Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDFC59F4C7
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 10:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235460AbiHXIKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 04:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235080AbiHXIKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 04:10:05 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E82682F9D
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 01:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=8vXbDz9bm+AWDq7hWMBmIJDhOrNce69DUwVpbsoF83c=;
        t=1661328603; x=1662538203; b=TV6DTdjjT6PHhTL2aatUojHfrI5oSmrKI74ML0cTWc2Eysm
        J0WBJqYOd4tDSv92Jr5JHBJCE7fjsgCULNqRnKHbM9J0S6csBIWmll2XRVElnUSKGe/AUHh/t2HPt
        kaNQ+gufWXC6mLY2Ft5StnzZrskCt//G070aTu5XkC6PU/oR3Kn0c+aRMUG95/ZT0xHfpB9sqH3Vb
        Ot04+iFGAcS7OzsGgrt5JvgN8xQg7KLcCryJfRh/5KEd/SJ0Mzz0b+3qpAx05+tX/Cg8AXF6BNIcB
        MY2PD3NKj0QgZmN4S4b2jzTeX1JHpUPreQmkoKCCcBOy4puj5XiHqlu49UDkiLpg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oQlSV-00G7ZJ-2v;
        Wed, 24 Aug 2022 10:09:56 +0200
Message-ID: <a3dabe052337a85e1f54d6119bda0c6414325edc.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] netlink: add support for ext_ack missing
 attributes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz
Date:   Wed, 24 Aug 2022 10:09:55 +0200
In-Reply-To: <20220824045024.1107161-2-kuba@kernel.org>
References: <20220824045024.1107161-1-kuba@kernel.org>
         <20220824045024.1107161-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-08-23 at 21:50 -0700, Jakub Kicinski wrote:
> The @offset points to the
> nest which should have contained the attribute

I find this a bit tedious, tbh. You already kernel-side have patch 2 and
patch 3 that pass different things here.

Maybe it would be better to have this point to the _end_ of the {nest,
message} header, which - if there are any - would be equivalent to the
first sibling attribute?

Though I guess one way or the other userspace has to have an if that
asks whether or not it's in a nest or the top-level namespace.

Hmm.

How about we just _remove_ the NLMSGERR_ATTR_MISS_NEST attribute if it's
not missing in a nested attribute? That would make sense from the naming
too:
 * NLMSGERR_ATTR_MISS_TYPE - which attribute type you missed
 * NLMSGERR_ATTR_MISS_NEST - which nesting you missed it in, _if any_


And that way the if simplifies down to something like

	if (tb[NLMSGERR_ATTR_MISS_NEST])

in the consumer too, and you don't need GENL_REQ_ATTR_CHECK() at all,
you just pass NULL to the second argument of NL_REQ_ATTR_CHECK().


Sounds better to me, but YMMV.

johannes
