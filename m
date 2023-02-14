Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A01696009
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjBNJ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbjBNJ7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:59:13 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9611925E3E;
        Tue, 14 Feb 2023 01:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=NOqWUbd3hBCUbl8Br4PcUyGjf4CP6a5A0AVj4nvrMiI=;
        t=1676368700; x=1677578300; b=gwCZlqDV9/ZN29gjT9M07F5Lmil4UmX0nRJQ5P9qI8/2ITX
        5Xf2xkZ3+AU4TeZgex/y1yngbMrTUFemJjH0O5CNdHNaakdzWM7G3imgnnIT2m9H8AQ/HffK6gJeA
        3SPJsqwmPEi+22aAiO95Hn+qRlLDF9+o+YGUp9URS5EVnDvGH6a4YdquTbc5wtgzgZw/R0OFUQP9b
        0oz0TghkR6qSHfOTBGnSjZwxLjtQa3iLxWqfxgrDIcRl3ayw2sUz3Wl1jt7HO+Vt7a7ptQreR154L
        zzGVOkqi5KMM/00u5JTTfzaUnW6lgmYEi7+hhaHL2FJ/x3tjFoD9i5XIZzot7wcg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pRs4i-00C4oX-1N;
        Tue, 14 Feb 2023 10:58:12 +0100
Message-ID: <abd207fc649aa92bcac49f0d207ff2289e8d73ff.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: mac80211: fix memory leak in
 ieee80211_register_hw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     shaozhengchao <shaozhengchao@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     sara.sharon@intel.com, luciano.coelho@intel.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Date:   Tue, 14 Feb 2023 10:58:11 +0100
In-Reply-To: <bcb33716-5c14-38d4-8721-1585e9fb8461@huawei.com>
References: <20221202043838.2324539-1-shaozhengchao@huawei.com>
         <e33356c3b654db03030d371e38f02c6019e9c1a7.camel@sipsolutions.net>
         <bcb33716-5c14-38d4-8721-1585e9fb8461@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

On Sun, 2023-01-29 at 14:28 +0800, shaozhengchao wrote:
>=20
> On 2023/1/18 17:45, Johannes Berg wrote:
> > On Fri, 2022-12-02 at 12:38 +0800, Zhengchao Shao wrote:
> > >=20
> > > --- a/net/mac80211/main.c
> > > +++ b/net/mac80211/main.c
> > > @@ -1326,6 +1326,7 @@ int ieee80211_register_hw(struct ieee80211_hw *=
hw)
> > >   					      hw->rate_control_algorithm);
> > >   	rtnl_unlock();
> > >   	if (result < 0) {
> > > +		ieee80211_txq_teardown_flows(local);
> > >   		wiphy_debug(local->hw.wiphy,
> > >   			    "Failed to initialize rate control algorithm\n");
> > >   		goto fail_rate;
> > > @@ -1364,6 +1365,7 @@ int ieee80211_register_hw(struct ieee80211_hw *=
hw)
> > >  =20
> > >   		sband =3D kmemdup(sband, sizeof(*sband), GFP_KERNEL);
> > >   		if (!sband) {
> > > +			ieee80211_txq_teardown_flows(local);
> > >   			result =3D -ENOMEM;
> > >   			goto fail_rate;
> > >   		}
> >=20
> > I don't understand - we have a fail_rate label here where we free
> > everything.
> >=20
> > What if we get to fail_wiphy_register, don't we leak it in the same way=
?
> >=20
> > johannes


> 	Thank you for your review. Sorry it took so long to reply. The
> fail_rate label does not release the resources applied for in the
> ieee80211_txq_setup_flows().  Or maybe I missed something?

That's my point though - if we "goto fail_ifa" or "goto
fail_wiphy_register", we have the same bug, no?

So shouldn't the patch simply be this:

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 846528850612..a42d1f0ef7a5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1442,6 +1442,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	ieee80211_remove_interfaces(local);
 	rtnl_unlock();
  fail_rate:
+	ieee80211_txq_teardown_flows(local);
  fail_flows:
 	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);


johannes
