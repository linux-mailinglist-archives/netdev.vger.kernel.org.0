Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB25E2EB3
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409010AbfJXKVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:21:01 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53394 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407714AbfJXKVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:21:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id n7so1336600wmc.3
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 03:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A5MiYgkjZPej28fH139T69/RaP97JB8wKubd/L6fA6Q=;
        b=XZN0dKCqtE+gJktNO/gYh3fvbv2QJ+rlQaGLO+DAj1P/ml8/K+378bLtC3k+dY9p0Z
         arxbVs23IqDtmgHgKsZ97nZrTiP8XFQIvqKBmAXEE6w/sOCdj/54cs830Le1hOd5OL76
         /WCh4ylJJ8IWLVZFyMJ/jRBLmqLasEmaNM71silMzm1bUl4lOa8zTkbvAXLnW6GoRG4I
         cY2YipM1zEY6+iFoZ+QwLsZUegdIMjD2Uxe2we2RedTZx1ursZqEQffO0lEXOqFHRzHx
         EM2ZOpEYmAndzCkVgx6KvDgCpyBZdekvFYxYFd8M+EZfdWPesqe3guPaLOV9YmywR3Q9
         RJGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A5MiYgkjZPej28fH139T69/RaP97JB8wKubd/L6fA6Q=;
        b=ok2n5qqfR0eHkxlmAbv7FdDHNjRKguFcpYYenoSzUQY1X7rfbGL15WAKrbaL6gzpuU
         +xolUbqbWK8bITLNn2jXtA+cX3mmHtx/iJW+xMQ9xpNKyRYsMVrW5vyy4WUR7wRlO2oO
         djZirx53OgE8iboZAb2LxjnQcpLVmv7V6sHA91XFCkWG2KOiDhnusS/fLxa6sFNYJqK6
         MqwfRQEpTQ+q3cw2Pid5oeKbbTkD278zAHRd/fGVS1Yqasy14ajB1hWen/Mmq8RHZrjh
         m/RNDUJfz8lSVylxM/LH0naoWQZouDLVkdkxMnylCzXDVQiV3hHLu5DZFAyVy06MEMLX
         mrZQ==
X-Gm-Message-State: APjAAAWe7bGwkzRgTuipmNKAkBb+RQoYgvdqPxpPJaHLCgZzr5IN5pGS
        NuM5pmOZxCbt7U7MZykcTox38BX/onw=
X-Google-Smtp-Source: APXvYqzv2o7NdTtzSLL5vJiN1mLtU4wRjEwIOuTY2PJQj4bDyg88RioPC6h81BpVCikC1/ovHAk2Jw==
X-Received: by 2002:a1c:9847:: with SMTP id a68mr4109259wme.18.1571912455293;
        Thu, 24 Oct 2019 03:20:55 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id p18sm2086159wmi.42.2019.10.24.03.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 03:20:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v5 1/3] lib/ll_map: cache alternative names
Date:   Thu, 24 Oct 2019 12:20:50 +0200
Message-Id: <20191024102052.4118-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191024102052.4118-1-jiri@resnulli.us>
References: <20191024102052.4118-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Alternative names are related to the "parent name". That means,
whenever ll_remember_index() is called to add/delete/update and it founds
the "parent name" im object by ifindex, processes related
alternative name im objects too. Put them in a list which holds the
relationship with the parent.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v4->v5:
- use safe variant of list traversal in ll_altname_entries_destroy()
v3->v4:
- new patch
---
 lib/ll_map.c | 190 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 152 insertions(+), 38 deletions(-)

diff --git a/lib/ll_map.c b/lib/ll_map.c
index e0ed54bf77c9..9ec73d166790 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -22,6 +22,7 @@
 #include "libnetlink.h"
 #include "ll_map.h"
 #include "list.h"
+#include "utils.h"
 
 struct ll_cache {
 	struct hlist_node idx_hash;
@@ -29,6 +30,7 @@ struct ll_cache {
 	unsigned	flags;
 	unsigned 	index;
 	unsigned short	type;
+	struct list_head altnames_list;
 	char		name[];
 };
 
@@ -77,10 +79,150 @@ static struct ll_cache *ll_get_by_name(const char *name)
 	return NULL;
 }
 
-int ll_remember_index(struct nlmsghdr *n, void *arg)
+static struct ll_cache *ll_entry_create(struct ifinfomsg *ifi,
+					const char *ifname,
+					struct ll_cache *parent_im)
+{
+	struct ll_cache *im;
+	unsigned int h;
+
+	im = malloc(sizeof(*im) + strlen(ifname) + 1);
+	if (!im)
+		return NULL;
+	im->index = ifi->ifi_index;
+	strcpy(im->name, ifname);
+	im->type = ifi->ifi_type;
+	im->flags = ifi->ifi_flags;
+
+	if (parent_im) {
+		list_add_tail(&im->altnames_list, &parent_im->altnames_list);
+	} else {
+		/* This is parent, insert to index hash. */
+		h = ifi->ifi_index & (IDXMAP_SIZE - 1);
+		hlist_add_head(&im->idx_hash, &idx_head[h]);
+		INIT_LIST_HEAD(&im->altnames_list);
+	}
+
+	h = namehash(ifname) & (IDXMAP_SIZE - 1);
+	hlist_add_head(&im->name_hash, &name_head[h]);
+	return im;
+}
+
+static void ll_entry_destroy(struct ll_cache *im, bool im_is_parent)
+{
+	hlist_del(&im->name_hash);
+	if (im_is_parent)
+		hlist_del(&im->idx_hash);
+	else
+		list_del(&im->altnames_list);
+	free(im);
+}
+
+static void ll_entry_update(struct ll_cache *im, struct ifinfomsg *ifi,
+			    const char *ifname)
 {
 	unsigned int h;
-	const char *ifname;
+
+	im->flags = ifi->ifi_flags;
+	if (!strcmp(im->name, ifname))
+		return;
+	hlist_del(&im->name_hash);
+	h = namehash(ifname) & (IDXMAP_SIZE - 1);
+	hlist_add_head(&im->name_hash, &name_head[h]);
+}
+
+static void ll_altname_entries_create(struct ll_cache *parent_im,
+				      struct ifinfomsg *ifi, struct rtattr **tb)
+{
+	struct rtattr *i, *proplist = tb[IFLA_PROP_LIST];
+	int rem;
+
+	if (!proplist)
+		return;
+	rem = RTA_PAYLOAD(proplist);
+	for (i = RTA_DATA(proplist); RTA_OK(i, rem);
+	     i = RTA_NEXT(i, rem)) {
+		if (i->rta_type != IFLA_ALT_IFNAME)
+			continue;
+		ll_entry_create(ifi, rta_getattr_str(i), parent_im);
+	}
+}
+
+static void ll_altname_entries_destroy(struct ll_cache *parent_im)
+{
+	struct ll_cache *im, *tmp;
+
+	list_for_each_entry_safe(im, tmp, &parent_im->altnames_list,
+				 altnames_list)
+		ll_entry_destroy(im, false);
+}
+
+static void ll_altname_entries_update(struct ll_cache *parent_im,
+				      struct ifinfomsg *ifi, struct rtattr **tb)
+{
+	struct rtattr *i, *proplist = tb[IFLA_PROP_LIST];
+	struct ll_cache *im;
+	int rem;
+
+	if (!proplist) {
+		ll_altname_entries_destroy(parent_im);
+		return;
+	}
+
+	/* Simply compare the altname list with the cached one
+	 * and if it does not fit 1:1, recreate the cached list
+	 * from scratch.
+	 */
+	im = list_first_entry(&parent_im->altnames_list, typeof(*im),
+			      altnames_list);
+	rem = RTA_PAYLOAD(proplist);
+	for (i = RTA_DATA(proplist); RTA_OK(i, rem);
+	     i = RTA_NEXT(i, rem)) {
+		if (i->rta_type != IFLA_ALT_IFNAME)
+			continue;
+		if (!im || strcmp(rta_getattr_str(i), im->name))
+			goto recreate_altname_entries;
+		im = list_next_entry(im, altnames_list);
+	}
+	if (list_next_entry(im, altnames_list))
+		goto recreate_altname_entries;
+	return;
+
+recreate_altname_entries:
+	ll_altname_entries_destroy(parent_im);
+	ll_altname_entries_create(parent_im, ifi, tb);
+}
+
+static void ll_entries_create(struct ifinfomsg *ifi, struct rtattr **tb)
+{
+	struct ll_cache *parent_im;
+
+	if (!tb[IFLA_IFNAME])
+		return;
+	parent_im = ll_entry_create(ifi, rta_getattr_str(tb[IFLA_IFNAME]),
+				    NULL);
+	if (!parent_im)
+		return;
+	ll_altname_entries_create(parent_im, ifi, tb);
+}
+
+static void ll_entries_destroy(struct ll_cache *parent_im)
+{
+	ll_altname_entries_destroy(parent_im);
+	ll_entry_destroy(parent_im, true);
+}
+
+static void ll_entries_update(struct ll_cache *parent_im,
+			      struct ifinfomsg *ifi, struct rtattr **tb)
+{
+	if (tb[IFLA_IFNAME])
+		ll_entry_update(parent_im, ifi,
+				rta_getattr_str(tb[IFLA_IFNAME]));
+	ll_altname_entries_update(parent_im, ifi, tb);
+}
+
+int ll_remember_index(struct nlmsghdr *n, void *arg)
+{
 	struct ifinfomsg *ifi = NLMSG_DATA(n);
 	struct ll_cache *im;
 	struct rtattr *tb[IFLA_MAX+1];
@@ -93,45 +235,17 @@ int ll_remember_index(struct nlmsghdr *n, void *arg)
 
 	im = ll_get_by_index(ifi->ifi_index);
 	if (n->nlmsg_type == RTM_DELLINK) {
-		if (im) {
-			hlist_del(&im->name_hash);
-			hlist_del(&im->idx_hash);
-			free(im);
-		}
-		return 0;
-	}
-
-	parse_rtattr(tb, IFLA_MAX, IFLA_RTA(ifi), IFLA_PAYLOAD(n));
-	ifname = rta_getattr_str(tb[IFLA_IFNAME]);
-	if (ifname == NULL)
-		return 0;
-
-	if (im) {
-		/* change to existing entry */
-		if (strcmp(im->name, ifname) != 0) {
-			hlist_del(&im->name_hash);
-			h = namehash(ifname) & (IDXMAP_SIZE - 1);
-			hlist_add_head(&im->name_hash, &name_head[h]);
-		}
-
-		im->flags = ifi->ifi_flags;
+		if (im)
+			ll_entries_destroy(im);
 		return 0;
 	}
 
-	im = malloc(sizeof(*im) + strlen(ifname) + 1);
-	if (im == NULL)
-		return 0;
-	im->index = ifi->ifi_index;
-	strcpy(im->name, ifname);
-	im->type = ifi->ifi_type;
-	im->flags = ifi->ifi_flags;
-
-	h = ifi->ifi_index & (IDXMAP_SIZE - 1);
-	hlist_add_head(&im->idx_hash, &idx_head[h]);
-
-	h = namehash(ifname) & (IDXMAP_SIZE - 1);
-	hlist_add_head(&im->name_hash, &name_head[h]);
-
+	parse_rtattr_flags(tb, IFLA_MAX, IFLA_RTA(ifi),
+			   IFLA_PAYLOAD(n), NLA_F_NESTED);
+	if (im)
+		ll_entries_update(im, ifi, tb);
+	else
+		ll_entries_create(ifi, tb);
 	return 0;
 }
 
-- 
2.21.0

