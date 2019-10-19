Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802DFDD9CF
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 19:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfJSRh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 13:37:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41293 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfJSRh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 13:37:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id p4so9414713wrm.8
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 10:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qs8MIotGT0o0Q/DKm0bKZQYn9DA5+fQ98R+Ol4CQWmA=;
        b=MXdOfLl6DFitLGjUIXq2KR3GObl4alqx4f31zJ6qpZBcs1OjwBL8qEHrVzocZ+5Mry
         C7rw6Lizr+zlp0r88GCoTpBTKj0iZNPjzN/CIR4tFQqFEJaa0msGCl6+bIBguNGMbUNJ
         w9f0rkB1SPqtaEWwoKCZH+jvXnUkSDqn4GNVUEuTGPJZpAPxybHueA2WHfJ07dtffUx7
         KqSNCjeQ8v+C3VGY30U6/78VAXCQpONQMQHcYpW8pDd8vOdVukIKKgfFU5P/n5k2/e8m
         kbadyvgcXd9l6CLceE4BYuoo8eN98wSVSTtZUEso8TTKmXWApQ+guKD46XfICwbIt+GE
         LUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qs8MIotGT0o0Q/DKm0bKZQYn9DA5+fQ98R+Ol4CQWmA=;
        b=O6jXe9mhBwCee0O+U/6GYVhqbOoAx7/Dp5nVPV0WPjYVdAgrm07lp/7MY/z35STApU
         lBJnlVe3TIpCDKsGXT2NN7LHnWOpCGGhfM7O0eWMj7lArACswspz5ukiX7nDhhRKQX8J
         9ZCYqREdxvWeAC1dkMiZ7cVT90C1M/rmktDAw0rmB1hInupdkoY6vtd+lSqTahXGbpmi
         cLhsx+oCpuY5KBFZfXEXrIFQ8mFDbsv950uKPsc4AujinQWZgZAG/dWMawtWdYMaEXFa
         JZA0Hz7L4+IR/oK16qjGmA0iqCr5xjcisbI+EssQcUr5ZrH6/gMvXlWC80xeDGGjrhLg
         vd7Q==
X-Gm-Message-State: APjAAAX0hz1xAB3pjEsYGU4jsysKYfrFuAS0inGSQZlxniMTMXVnLcV/
        fnB2LUJR1gh9wJWNhulVA+8qSSzZlvw=
X-Google-Smtp-Source: APXvYqwJqCd7r6acy5WL+vRNZxBbFgNHavE2fdshl5KBPQNcVrP/eH1uesj0vY9k/92lmbVlhs4cuw==
X-Received: by 2002:adf:ffc5:: with SMTP id x5mr2213821wrs.93.1571506671976;
        Sat, 19 Oct 2019 10:37:51 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id z189sm11472433wmc.25.2019.10.19.10.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 10:37:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v4 1/3] lib/ll_map: cache alternative names
Date:   Sat, 19 Oct 2019 19:37:47 +0200
Message-Id: <20191019173749.19068-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191019173749.19068-1-jiri@resnulli.us>
References: <20191019173749.19068-1-jiri@resnulli.us>
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
v3->v4:
- new patch
---
 lib/ll_map.c | 189 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 151 insertions(+), 38 deletions(-)

diff --git a/lib/ll_map.c b/lib/ll_map.c
index e0ed54bf77c9..1b382b5cec94 100644
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
 
@@ -77,10 +79,149 @@ static struct ll_cache *ll_get_by_name(const char *name)
 	return NULL;
 }
 
-int ll_remember_index(struct nlmsghdr *n, void *arg)
+static struct ll_cache *ll_entry_create(struct ifinfomsg *ifi,
+					const char *ifname,
+					struct ll_cache *parent_im)
 {
+	struct ll_cache *im;
 	unsigned int h;
-	const char *ifname;
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
+{
+	unsigned int h;
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
+	struct ll_cache *im;
+
+	list_for_each_entry(im, &parent_im->altnames_list, altnames_list)
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
@@ -93,45 +234,17 @@ int ll_remember_index(struct nlmsghdr *n, void *arg)
 
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

