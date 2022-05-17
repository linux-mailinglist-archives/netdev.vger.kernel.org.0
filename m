Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9807F529B66
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239678AbiEQHtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241923AbiEQHss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:48:48 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617F447395;
        Tue, 17 May 2022 00:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=4SmYl2RiNkyBTO0IZCn4bqjgH7FQHbYOmBz1wzQ8Kb8=;
        t=1652773725; x=1653983325; b=qTSHjAypA8UgsIHAbwfUcX3HQsNZpvXLLCXfzOM2bhWIgJH
        nQmFBBjSHxN+c2UXTaREVkAmRZvbiEntkXsbMe5pV+t/KEW6wpIBDXeC4CEseAdPbjGet13OrhOUm
        C6k6xq7PzwnApBsjhud0oE8Yg1DoWHC5yHTQ2yly1Wow9YUPloM1QvHtuNHTPJ8UjxVWnQUuqewC9
        aGZkqHPY3ysUQS5F9g26Gi1idXluB8zJ3+Dfa8IyY2vUNgA69VhTuXi+Tr30NNRZMKepJgSox0xkX
        vDkGx+tRSzYkgSCIIJfBHuO7vBaa4z1qPw1+mk7J3Au2NbtQ3K4SBAqaUbb74zaA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nqrwP-00EGby-In;
        Tue, 17 May 2022 09:48:25 +0200
Message-ID: <74bdbec0580ed05d0f18533eae9af50bc0a4a0ef.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
Date:   Tue, 17 May 2022 09:48:24 +0200
In-Reply-To: <8e9f1b04-d17b-2812-22bb-e62b5560aa6e@gmail.com>
References: <20220516215638.1787257-1-kuba@kernel.org>
         <8e9f1b04-d17b-2812-22bb-e62b5560aa6e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-16 at 19:12 -0700, Florian Fainelli wrote:
>=20
> On 5/16/2022 2:56 PM, Jakub Kicinski wrote:
> > Most protocol-specific pointers in struct net_device are under
> > a respective ifdef. Wireless is the notable exception. Since
> > there's a sizable number of custom-built kernels for datacenter
> > workloads which don't build wireless it seems reasonable to
> > ifdefy those pointers as well.
> >=20
> > While at it move IPv4 and IPv6 pointers up, those are special
> > for obvious reasons.
> >=20
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>=20
> Could not we move to an union of pointers in the future since in many=20
> cases a network device can only have one of those pointers at any given=
=20
> time?

Then at the very least we'd need some kind of type that we can assign to
disambiguate, because today e.g. we have a netdev notifier (and other
code) that could get a non-wireless netdev and check like this:

static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
                                         unsigned long state, void *ptr)
{
        struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
        struct wireless_dev *wdev =3D dev->ieee80211_ptr;
[...]
        if (!wdev)
                return NOTIFY_DONE;



We could probably use the netdev->dev.type for this though, that's just
a pointer we can compare to. We'd have to set it differently (today
cfg80211 sets it based on whether or not you have ieee80211_ptr, we'd
have to turn that around), but that's not terribly hard, especially
since wireless drivers now have to call cfg80211_register_netdevice()
anyway, rather than register_netdevice() directly.


Something like the patch below might do that, but I haven't carefully
checked it yet, nor checked if there are any paths in mac80211/drivers
that might be doing this check - and it looks from Jakub's patch that
batman code would like to check this too.

johannes

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3e5d12040726..6ea2a597f4ca 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1192,7 +1192,7 @@ void cfg80211_unregister_wdev(struct wireless_dev *wd=
ev)
 }
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
=20
-static const struct device_type wiphy_type =3D {
+const struct device_type wiphy_type =3D {
 	.name	=3D "wlan",
 };
=20
@@ -1369,6 +1369,9 @@ int cfg80211_register_netdevice(struct net_device *de=
v)
=20
 	lockdep_assert_held(&rdev->wiphy.mtx);
=20
+	/* this lets us identify our netdevs in the future */
+	SET_NETDEV_DEVTYPE(dev, &wiphy_type);
+
 	/* we'll take care of this */
 	wdev->registered =3D true;
 	wdev->registering =3D true;
@@ -1394,7 +1397,7 @@ static int cfg80211_netdev_notifier_call(struct notif=
ier_block *nb,
 	struct cfg80211_registered_device *rdev;
 	struct cfg80211_sched_scan_request *pos, *tmp;
=20
-	if (!wdev)
+	if (!netdev_is_wireless(dev))
 		return NOTIFY_DONE;
=20
 	rdev =3D wiphy_to_rdev(wdev->wiphy);
@@ -1403,7 +1406,6 @@ static int cfg80211_netdev_notifier_call(struct notif=
ier_block *nb,
=20
 	switch (state) {
 	case NETDEV_POST_INIT:
-		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
 		wdev->netdev =3D dev;
 		/* can only change netns with wiphy */
 		dev->features |=3D NETIF_F_NETNS_LOCAL;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 2c195067ddff..e256ea5caf49 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -219,6 +219,13 @@ void cfg80211_init_wdev(struct wireless_dev *wdev);
 void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev);
=20
+extern const struct device_type wiphy_type;
+
+static inline bool netdev_is_wireless(struct net_device *dev)
+{
+	return dev && dev->dev.type =3D=3D &wiphy_type && dev->ieee80211_ptr;
+}
+
 static inline void wdev_lock(struct wireless_dev *wdev)
 	__acquires(wdev)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 342dfefb6eca..58bc3750c380 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -182,7 +182,7 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nl=
attr **attrs)
=20
 		netdev =3D __dev_get_by_index(netns, ifindex);
 		if (netdev) {
-			if (netdev->ieee80211_ptr)
+			if (netdev_is_wireless(netdev))
 				tmp =3D wiphy_to_rdev(
 					netdev->ieee80211_ptr->wiphy);
 			else
@@ -2978,7 +2978,7 @@ static int nl80211_dump_wiphy_parse(struct sk_buff *s=
kb,
 			ret =3D -ENODEV;
 			goto out;
 		}
-		if (netdev->ieee80211_ptr) {
+		if (netdev_is_wireless(netdev)) {
 			rdev =3D wiphy_to_rdev(
 				netdev->ieee80211_ptr->wiphy);
 			state->filter_wiphy =3D rdev->wiphy_idx;
@@ -3364,7 +3364,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, str=
uct genl_info *info)
 		int ifindex =3D nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
=20
 		netdev =3D __dev_get_by_index(genl_info_net(info), ifindex);
-		if (netdev && netdev->ieee80211_ptr)
+		if (netdev_is_wireless(netdev))
 			rdev =3D wiphy_to_rdev(netdev->ieee80211_ptr->wiphy);
 		else
 			netdev =3D NULL;

