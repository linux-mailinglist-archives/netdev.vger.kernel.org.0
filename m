Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6A25C0482
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 18:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiIUQqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 12:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiIUQps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 12:45:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D012A6C15;
        Wed, 21 Sep 2022 09:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=7kE5JdBiW9yulAgHix06z8Dq9UFAx7J6x1i9LFdWSw4=;
        t=1663778203; x=1664987803; b=lxdxDMfqO903d3uRan+2DNXLcDdnFsAQzU0UpWPPEzW+rRr
        +JSzoBf6ClUQ/g8InH2pzVpYrBdydVg48AGZ9Exgstg9LOiGHGPHhm1IIcPt/4ovLjL9i4ULunN32
        0ni2TOyLdCWDGulljcaabAfvs/AM0LQaZ29tv6PhVy+0ABAjroNiERx3+VYY+fnbW7UzkWK7aHJTF
        8ciuAXwub2iOz+7UW2yeXvjZhZEWMh9r78wZwWg5cd+YeK8yrhhSt42OeR22cSPWQS9Nf9rnXdiTF
        uUn8psPvGOWqcibQnCoSGhQkoAE2PksXkQEuIoYzLl91U+537f/k13K+fm8Xwitg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ob2hy-004vvK-29;
        Wed, 21 Sep 2022 18:36:23 +0200
Message-ID: <3e819d22808f7f1f232bc1242f2260106f37f875.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] cfg80211: fix dead lock for nl80211_new_interface()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aran Dalton <arda@allwinnertech.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 21 Sep 2022 18:36:18 +0200
In-Reply-To: <20220921091913.110749-1-arda@allwinnertech.com>
References: <20220921091913.110749-1-arda@allwinnertech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-09-21 at 17:19 +0800, Aran Dalton wrote:
> Both nl80211_new_interface and cfg80211_netdev_notifier_call hold the
> same wiphy_lock, then cause deadlock.
>=20
> The main call stack as bellow:
>=20
> nl80211_new_interface() takes wiphy_lock
>  -> _nl80211_new_interface:
>   -> rdev_add_virtual_intf
>    -> rdev->ops->add_virtual_intf
>     -> register_netdevice

The bug is yours, here, you're no longer allowed to call
register_netdevice() here.

If you have an out-of-tree driver that we couldn't update when doing
tree-wide changes, you probably shouldn't assume that the bug is
upstream and send random locking patches ... :)

johannes
