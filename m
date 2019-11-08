Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09354F51D6
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfKHRAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:00:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38866 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbfKHRAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:00:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573232421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0dGGP/jq4+jZd2CYlHQK6joP1pahSeeMvAdQNCnol8=;
        b=hLdxh7EYphE/Qly7k8fIF6tfDQlF8aDMXYPAemoHd2BG+Blny4wxjFeuKgdylVYA16Lfx5
        uk8Ahoox7mwbt84MgW2AALBt81yiAtf0W8EkPwfSO7At7jUgGUQEetaLHk3q0OflQOLi9e
        uKbQMaNia+G+H0PRsoIBruDTqbf4kHg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-dU8LbazPOWGmLIi3JJ3byA-1; Fri, 08 Nov 2019 12:00:19 -0500
Received: by mail-wm1-f70.google.com with SMTP id f191so3379397wme.1
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:00:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qx9QgksFzv4g7MD2jq+44cPaEq5JUEUJpjatntA94ws=;
        b=iyhZxTTa+RtdhnwAij8Qc72hGhHB/apxA2S7l52TSz+AABzSO+69PHwq2fQGedr0Uj
         CFeDJtX5uGYdPtYECtj1EvZP/8r3Hckj5JYZvVOXEzeWIF8cld0824t47xy+DWppS7Nf
         RtoJ8/p7KkHMLeoTDMimWS9cvq3zVSe/6O5+iFlWiOJ6IddZtp00cvbLhH7PEXohy589
         vZZ6NslmlqXg9ONEpQAYahgRu1OQ5BAtwk0ajLIBFV5B9PpXiPKaB9iSlETiSzdANHX6
         1QDh+GzlZQSDvzaY5/PQJhYLuyfnGj2sOz4IRCva/lhV3XvtppRc6sOOj9M/CaPpHg+0
         7J7A==
X-Gm-Message-State: APjAAAUSojCfxQcjgsj35vxPsFVdXHrjY7cCOnjNtP0UWIGkze/hzWRH
        jryK2UkB7PE6f3UmyJZspyDuJM8h5k8PLFcgY1N6H5ALbjN/VgSxEbLaTcgoMTuCYuf/0oLKxLE
        2rF9JT3HO4aIvw3pT
X-Received: by 2002:adf:f985:: with SMTP id f5mr483884wrr.364.1573232418160;
        Fri, 08 Nov 2019 09:00:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwuk404DVnPoBQAteKPagA2s8wYTb6VxTK/72/FrjH2gPR45kx5osHmInktugjECkFlWuz6w==
X-Received: by 2002:adf:f985:: with SMTP id f5mr483876wrr.364.1573232418021;
        Fri, 08 Nov 2019 09:00:18 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id f14sm5497606wrv.17.2019.11.08.09.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 09:00:17 -0800 (PST)
Date:   Fri, 8 Nov 2019 18:00:15 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2-next 3/5] ipnetns: harden helper functions wrt.
 negative netns ids
Message-ID: <ff24093b24903ce59a9c0ccc1333660bce1fcfac.1573231189.git.gnault@redhat.com>
References: <cover.1573231189.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1573231189.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: dU8LbazPOWGmLIi3JJ3byA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Negative values are invalid netns ids. Ensure that helper functions
don't accidentally try to process them.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 ip/ipnetns.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index b02e0a8a..77531d6c 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -161,9 +161,13 @@ static struct hlist_head=09name_head[NSIDMAP_SIZE];
=20
 static struct nsid_cache *netns_map_get_by_nsid(int nsid)
 {
-=09uint32_t h =3D NSID_HASH_NSID(nsid);
 =09struct hlist_node *n;
+=09uint32_t h;
+
+=09if (nsid < 0)
+=09=09return NULL;
=20
+=09h =3D NSID_HASH_NSID(nsid);
 =09hlist_for_each(n, &nsid_head[h]) {
 =09=09struct nsid_cache *c =3D container_of(n, struct nsid_cache,
 =09=09=09=09=09=09    nsid_hash);
@@ -178,6 +182,9 @@ char *get_name_from_nsid(int nsid)
 {
 =09struct nsid_cache *c;
=20
+=09if (nsid < 0)
+=09=09return NULL;
+
 =09netns_nsid_socket_init();
 =09netns_map_init();
=20
@@ -266,6 +273,9 @@ static int netns_get_name(int nsid, char *name)
 =09DIR *dir;
 =09int id;
=20
+=09if (nsid < 0)
+=09=09return -EINVAL;
+
 =09dir =3D opendir(NETNS_RUN_DIR);
 =09if (!dir)
 =09=09return -ENOENT;
@@ -277,7 +287,7 @@ static int netns_get_name(int nsid, char *name)
 =09=09=09continue;
 =09=09id =3D get_netnsid_from_name(entry->d_name);
=20
-=09=09if (nsid =3D=3D id) {
+=09=09if (id >=3D 0 && nsid =3D=3D id) {
 =09=09=09strcpy(name, entry->d_name);
 =09=09=09closedir(dir);
 =09=09=09return 0;
--=20
2.21.0

