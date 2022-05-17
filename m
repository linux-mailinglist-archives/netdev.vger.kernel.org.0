Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298BD52AA68
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240899AbiEQSQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiEQSQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:16:21 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A24712ACC;
        Tue, 17 May 2022 11:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=XmFrttRHC7A2sfjVP/M8VOMUAvKSPoICYVyZyP2NXPg=;
        t=1652811380; x=1654020980; b=XdPE/WjuGOxcI+nO4e4/02XdAt6QHFJUcoEFIeBMoCJJB6x
        4T/4xXUtgqFO9rMVawexpxv5p88kzDwU13FkoD8rRmduVttI8Mz4sNcsFS7Et6Zg2ghBxV9afHt1G
        L95wdVK/WyGn6QWGRpKUVRSF5dWnBZJ/ZNsz4Y39609py40f6fWThJS7svkLzDLB7XPufb1JYlIMC
        ct36EMbHXIkgFlo+RKjzbW+8eqq2Gd2lO53EaulTF8x6QRVFtWqtMlNE0uYIVMeLaP6LgROAs4iAi
        xDwl5umG5gDw2YHCwGjAuwvVhGcD4d15oOV3v1YbwDz6PzqvpbpzG7mZSozJvZrQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nr1jr-00EVfZ-9s;
        Tue, 17 May 2022 20:16:07 +0200
Message-ID: <e1bf7cc3d42481e8e073ac278bab499f31236f97.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] net: ifdefy the wireless pointers in struct
 net_device
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, linux-wireless@vger.kernel.org,
        linux-wpan@vger.kernel.org
Date:   Tue, 17 May 2022 20:16:06 +0200
In-Reply-To: <20220517103758.353c2476@kernel.org>
References: <20220516215638.1787257-1-kuba@kernel.org>
         <8e9f1b04-d17b-2812-22bb-e62b5560aa6e@gmail.com>
         <74bdbec0580ed05d0f18533eae9af50bc0a4a0ef.camel@sipsolutions.net>
         <20220517103758.353c2476@kernel.org>
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

On Tue, 2022-05-17 at 10:37 -0700, Jakub Kicinski wrote:
> >=20
> > Then at the very least we'd need some kind of type that we can assign t=
o
> > disambiguate, because today e.g. we have a netdev notifier (and other
> > code) that could get a non-wireless netdev and check like this:
> >=20
> > static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
> >                                          unsigned long state, void *ptr=
)
> > {
> >         struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
> >         struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> > [...]
> >         if (!wdev)
> >                 return NOTIFY_DONE;
>=20
> Can we use enum netdev_ml_priv_type netdev::ml_priv and
> netdev::ml_priv_type for this?
>=20
Hm, yeah, I guess we can. I think I'd prefer something along the lines
of the below, then we don't even need the ifdef.

johannes

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf66e57d891..4bd81767c058 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1702,6 +1702,7 @@ enum netdev_priv_flags {
 enum netdev_ml_priv_type {
 	ML_PRIV_NONE,
 	ML_PRIV_CAN,
+	ML_PRIV_WIFI,
 };
=20
 /**
@@ -2127,7 +2128,6 @@ struct net_device {
 #if IS_ENABLED(CONFIG_AX25)
 	void			*ax25_ptr;
 #endif
-	struct wireless_dev	*ieee80211_ptr;
 	struct wpan_dev		*ieee802154_ptr;
 #if IS_ENABLED(CONFIG_MPLS_ROUTING)
 	struct mpls_dev __rcu	*mpls_ptr;
@@ -2235,7 +2235,10 @@ struct net_device {
 	possible_net_t			nd_net;
=20
 	/* mid-layer private */
-	void				*ml_priv;
+	union {
+		void			*ml_priv;
+		struct wireless_dev	*ieee80211_ptr;
+	};
 	enum netdev_ml_priv_type	ml_priv_type;
=20
 	union {
diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interfac=
e.c
index 83fb51b6e299..7b063adacaa6 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -307,11 +307,7 @@ static bool batadv_is_cfg80211_netdev(struct net_devic=
e *net_device)
 	if (!net_device)
 		return false;
=20
-	/* cfg80211 drivers have to set ieee80211_ptr */
-	if (net_device->ieee80211_ptr)
-		return true;
-
-	return false;
+	return netdev_get_ml_priv(net_device, ML_PRIV_WIFI);
 }
=20
 /**
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4980c3a50475..50154f7879b6 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1997,7 +1997,7 @@ int netdev_register_kobject(struct net_device *ndev)
 	*groups++ =3D &netstat_group;
=20
 #if IS_ENABLED(CONFIG_WIRELESS_EXT) || IS_ENABLED(CONFIG_CFG80211)
-	if (ndev->ieee80211_ptr)
+	if (netdev_get_ml_priv(ndev, ML_PRIV_WIFI))
 		*groups++ =3D &wireless_group;
 #if IS_ENABLED(CONFIG_WIRELESS_EXT)
 	else if (ndev->wireless_handlers)
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 3e5d12040726..9024bd9f7d46 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1369,6 +1369,12 @@ int cfg80211_register_netdevice(struct net_device *d=
ev)
=20
 	lockdep_assert_held(&rdev->wiphy.mtx);
=20
+	/*
+	 * This lets us identify our netdevs in the future,
+	 * the driver already set dev->ieee80211_ptr.
+	 */
+	netdev_set_ml_priv(dev, wdev, ML_PRIV_WIFI);
+
 	/* we'll take care of this */
 	wdev->registered =3D true;
 	wdev->registering =3D true;
@@ -1390,7 +1396,7 @@ static int cfg80211_netdev_notifier_call(struct notif=
ier_block *nb,
 					 unsigned long state, void *ptr)
 {
 	struct net_device *dev =3D netdev_notifier_info_to_dev(ptr);
-	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
+	struct wireless_dev *wdev =3D netdev_get_ml_priv(dev, ML_PRIV_WIFI);
 	struct cfg80211_registered_device *rdev;
 	struct cfg80211_sched_scan_request *pos, *tmp;
=20
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8d528b5945d0..3a5a7183b959 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -182,9 +182,12 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct n=
lattr **attrs)
=20
 		netdev =3D __dev_get_by_index(netns, ifindex);
 		if (netdev) {
-			if (netdev->ieee80211_ptr)
-				tmp =3D wiphy_to_rdev(
-					netdev->ieee80211_ptr->wiphy);
+			struct wireless_dev *wdev;
+
+			wdev =3D netdev_get_ml_priv(netdev, ML_PRIV_WIFI);
+
+			if (wdev)
+				tmp =3D wiphy_to_rdev(wdev->wiphy);
 			else
 				tmp =3D NULL;
=20
@@ -2972,15 +2975,17 @@ static int nl80211_dump_wiphy_parse(struct sk_buff =
*skb,
 		struct net_device *netdev;
 		struct cfg80211_registered_device *rdev;
 		int ifidx =3D nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
+		struct wireless_dev *wdev;
=20
 		netdev =3D __dev_get_by_index(sock_net(skb->sk), ifidx);
 		if (!netdev) {
 			ret =3D -ENODEV;
 			goto out;
 		}
-		if (netdev->ieee80211_ptr) {
-			rdev =3D wiphy_to_rdev(
-				netdev->ieee80211_ptr->wiphy);
+
+		wdev =3D netdev_is_wireless(netdev, ML_PRIV_WIFI);
+		if (wdev) {
+			rdev =3D wiphy_to_rdev(wdev->wiphy);
 			state->filter_wiphy =3D rdev->wiphy_idx;
 		}
 	}
@@ -3364,8 +3369,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, str=
uct genl_info *info)
 		int ifindex =3D nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
=20
 		netdev =3D __dev_get_by_index(genl_info_net(info), ifindex);
-		if (netdev && netdev->ieee80211_ptr)
-			rdev =3D wiphy_to_rdev(netdev->ieee80211_ptr->wiphy);
+		wdev =3D netdev_is_wireless(netdev);
+		if (wdev)
+			rdev =3D wiphy_to_rdev(wdev->wiphy);
 		else
 			netdev =3D NULL;
 	}
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b9678801d848..e1bd3f624e1b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2715,6 +2715,7 @@ static struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(struct net *net, int ifindex)
 {
 	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
 	struct net_device *dev;
=20
 	ASSERT_RTNL();
@@ -2722,8 +2723,9 @@ cfg80211_get_dev_from_ifindex(struct net *net, int if=
index)
 	dev =3D dev_get_by_index(net, ifindex);
 	if (!dev)
 		return ERR_PTR(-ENODEV);
-	if (dev->ieee80211_ptr)
-		rdev =3D wiphy_to_rdev(dev->ieee80211_ptr->wiphy);
+	wdev =3D netdev_get_ml_priv(dev, ML_PRIV_WIFI);
+	if (wdev)
+		rdev =3D wiphy_to_rdev(wdev->wiphy);
 	else
 		rdev =3D ERR_PTR(-ENODEV);
 	dev_put(dev);
diff --git a/net/wireless/wext-proc.c b/net/wireless/wext-proc.c
index cadcf8613af2..a7d903729d2e 100644
--- a/net/wireless/wext-proc.c
+++ b/net/wireless/wext-proc.c
@@ -40,7 +40,7 @@ static void wireless_seq_printf_stats(struct seq_file *se=
q,
 			stats =3D &nullstats;
 #endif
 #ifdef CONFIG_CFG80211
-		if (dev->ieee80211_ptr)
+		if (netdev_get_ml_priv(dev, ML_PRIV_WIFI))
 			stats =3D &nullstats;
 #endif
 	}

