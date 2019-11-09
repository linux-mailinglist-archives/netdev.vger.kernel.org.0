Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C26DF6186
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfKIUhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:37:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30329 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726569AbfKIUhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:37:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573331860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c8P5cspoLjdkoTt3mImX/vTX08JWPljE4WM+IvmtptQ=;
        b=ZedowrOYFCTq0aL3ywAnGtPWrK+muC6VI9KaayulaT847nNH/KgyrBIzoRqZq9R9HFaHWY
        Ul6Y8dTmPZMNHM74X9TZG22Yzmx8BSUeFlxHRqwRpvuBpAitUt5bOowxK+P21UKvCCbeII
        ogXSGAUzEzLr6AcDrKHwxV2CE4oPToc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104--VA6Pg9MOIO4C0yJR-l-4g-1; Sat, 09 Nov 2019 15:37:34 -0500
Received: by mail-ed1-f72.google.com with SMTP id l6so7329163edc.18
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 12:37:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Li5s6JX5WIT+IXbJU0kzy8ie+h5GQ+8nNrCKMbvFIXc=;
        b=KjAPeBoODS8BlTY+pQhwrWHFNbAjxk+iPBfJfLBe5hARV7AnMIXNur/GFB/3YPam6B
         Jy5b9uGay7RUR/L3vyqduLqADDE0Z+Hzh1TYwPpGwFaeW+OoUrY2NPcgD7jiErL6v2dv
         39UhRb3JmHk7dzvMQdeE7tjGB7u/lQBFu1wKs0Dx7ilOeHxhJRASmC38cspkIEArV07r
         jLfRpQ2nFc9rFw/ZgVtNGy7JvXN6nqnd5jasDbHWqeZIT3YjhLfH4k8/eAeFxvwuFzo3
         96GZyu+GBXK0pWEAqPTx+DiLN9EKX8URkb30sKnlWXXYKmj9uXvZ8Nx3RUOK7mY0FsO9
         28uw==
X-Gm-Message-State: APjAAAWRbqv6nVehl8Xq9ehLPK/opTNA0EHLdLaswHUKCT5dZWEVfkld
        DYK/H4K4GsdxdThCs2rJZIQGqD0MFCBqP/Rux1eapJ7PJfRkLBKvW9T/U7A8n5VvEvfMNg++fd2
        bsuYLdsuPsfBkug9b
X-Received: by 2002:a17:906:1a47:: with SMTP id j7mr14980455ejf.232.1573331852865;
        Sat, 09 Nov 2019 12:37:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqyqa418TnQLtbyWYeIYefkaRFBibZHLT0pTsJjy6E9onlLrnd6tcVg587As92QWTvPkck0Wtw==
X-Received: by 2002:a17:906:1a47:: with SMTP id j7mr14980441ejf.232.1573331852604;
        Sat, 09 Nov 2019 12:37:32 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id o59sm335801eda.80.2019.11.09.12.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 12:37:32 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B002A1800CE; Sat,  9 Nov 2019 21:37:31 +0100 (CET)
Subject: [PATCH bpf-next v4 5/6] libbpf: Add bpf_get_link_xdp_info() function
 to get more XDP information
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sat, 09 Nov 2019 21:37:31 +0100
Message-ID: <157333185164.88376.7520653040667637246.stgit@toke.dk>
In-Reply-To: <157333184619.88376.13377736576285554047.stgit@toke.dk>
References: <157333184619.88376.13377736576285554047.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-MC-Unique: -VA6Pg9MOIO4C0yJR-l-4g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Currently, libbpf only provides a function to get a single ID for the XDP
program attached to the interface. However, it can be useful to get the
full set of program IDs attached, along with the attachment mode, in one
go. Add a new getter function to support this, using an extendible
structure to carry the information. Express the old bpf_get_link_id()
function in terms of the new function.

Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h   |   10 +++++
 tools/lib/bpf/libbpf.map |    1 +
 tools/lib/bpf/netlink.c  |   84 +++++++++++++++++++++++++++++++-----------=
----
 3 files changed, 67 insertions(+), 28 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6ddc0419337b..f0947cc949d2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -427,8 +427,18 @@ LIBBPF_API int bpf_prog_load_xattr(const struct bpf_pr=
og_load_attr *attr,
 LIBBPF_API int bpf_prog_load(const char *file, enum bpf_prog_type type,
 =09=09=09     struct bpf_object **pobj, int *prog_fd);
=20
+struct xdp_link_info {
+=09__u32 prog_id;
+=09__u32 drv_prog_id;
+=09__u32 hw_prog_id;
+=09__u32 skb_prog_id;
+=09__u8 attach_mode;
+};
+
 LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
 LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flag=
s);
+LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *in=
fo,
+=09=09=09=09     size_t info_size, __u32 flags);
=20
 struct perf_buffer;
=20
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 86173cbb159d..d1a782a3a58d 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -193,6 +193,7 @@ LIBBPF_0.0.5 {
=20
 LIBBPF_0.0.6 {
 =09global:
+=09=09bpf_get_link_xdp_info;
 =09=09bpf_map__get_pin_path;
 =09=09bpf_map__is_pinned;
 =09=09bpf_map__set_pin_path;
diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index a261df9cb488..5065c1aa1061 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -25,7 +25,7 @@ typedef int (*__dump_nlmsg_t)(struct nlmsghdr *nlmsg, lib=
bpf_dump_nlmsg_t,
 struct xdp_id_md {
 =09int ifindex;
 =09__u32 flags;
-=09__u32 id;
+=09struct xdp_link_info info;
 };
=20
 int libbpf_netlink_open(__u32 *nl_pid)
@@ -203,26 +203,11 @@ static int __dump_link_nlmsg(struct nlmsghdr *nlh,
 =09return dump_link_nlmsg(cookie, ifi, tb);
 }
=20
-static unsigned char get_xdp_id_attr(unsigned char mode, __u32 flags)
-{
-=09if (mode !=3D XDP_ATTACHED_MULTI)
-=09=09return IFLA_XDP_PROG_ID;
-=09if (flags & XDP_FLAGS_DRV_MODE)
-=09=09return IFLA_XDP_DRV_PROG_ID;
-=09if (flags & XDP_FLAGS_HW_MODE)
-=09=09return IFLA_XDP_HW_PROG_ID;
-=09if (flags & XDP_FLAGS_SKB_MODE)
-=09=09return IFLA_XDP_SKB_PROG_ID;
-
-=09return IFLA_XDP_UNSPEC;
-}
-
-static int get_xdp_id(void *cookie, void *msg, struct nlattr **tb)
+static int get_xdp_info(void *cookie, void *msg, struct nlattr **tb)
 {
 =09struct nlattr *xdp_tb[IFLA_XDP_MAX + 1];
 =09struct xdp_id_md *xdp_id =3D cookie;
 =09struct ifinfomsg *ifinfo =3D msg;
-=09unsigned char mode, xdp_attr;
 =09int ret;
=20
 =09if (xdp_id->ifindex && xdp_id->ifindex !=3D ifinfo->ifi_index)
@@ -238,27 +223,40 @@ static int get_xdp_id(void *cookie, void *msg, struct=
 nlattr **tb)
 =09if (!xdp_tb[IFLA_XDP_ATTACHED])
 =09=09return 0;
=20
-=09mode =3D libbpf_nla_getattr_u8(xdp_tb[IFLA_XDP_ATTACHED]);
-=09if (mode =3D=3D XDP_ATTACHED_NONE)
-=09=09return 0;
+=09xdp_id->info.attach_mode =3D libbpf_nla_getattr_u8(
+=09=09xdp_tb[IFLA_XDP_ATTACHED]);
=20
-=09xdp_attr =3D get_xdp_id_attr(mode, xdp_id->flags);
-=09if (!xdp_attr || !xdp_tb[xdp_attr])
+=09if (xdp_id->info.attach_mode =3D=3D XDP_ATTACHED_NONE)
 =09=09return 0;
=20
-=09xdp_id->id =3D libbpf_nla_getattr_u32(xdp_tb[xdp_attr]);
+=09if (xdp_tb[IFLA_XDP_PROG_ID])
+=09=09xdp_id->info.prog_id =3D libbpf_nla_getattr_u32(
+=09=09=09xdp_tb[IFLA_XDP_PROG_ID]);
+
+=09if (xdp_tb[IFLA_XDP_SKB_PROG_ID])
+=09=09xdp_id->info.skb_prog_id =3D libbpf_nla_getattr_u32(
+=09=09=09xdp_tb[IFLA_XDP_SKB_PROG_ID]);
+
+=09if (xdp_tb[IFLA_XDP_DRV_PROG_ID])
+=09=09xdp_id->info.drv_prog_id =3D libbpf_nla_getattr_u32(
+=09=09=09xdp_tb[IFLA_XDP_DRV_PROG_ID]);
+
+=09if (xdp_tb[IFLA_XDP_HW_PROG_ID])
+=09=09xdp_id->info.hw_prog_id =3D libbpf_nla_getattr_u32(
+=09=09=09xdp_tb[IFLA_XDP_HW_PROG_ID]);
=20
 =09return 0;
 }
=20
-int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
+int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
+=09=09=09  size_t info_size, __u32 flags)
 {
 =09struct xdp_id_md xdp_id =3D {};
 =09int sock, ret;
 =09__u32 nl_pid;
 =09__u32 mask;
=20
-=09if (flags & ~XDP_FLAGS_MASK)
+=09if (flags & ~XDP_FLAGS_MASK || !info_size)
 =09=09return -EINVAL;
=20
 =09/* Check whether the single {HW,DRV,SKB} mode is set */
@@ -274,14 +272,44 @@ int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, =
__u32 flags)
 =09xdp_id.ifindex =3D ifindex;
 =09xdp_id.flags =3D flags;
=20
-=09ret =3D libbpf_nl_get_link(sock, nl_pid, get_xdp_id, &xdp_id);
-=09if (!ret)
-=09=09*prog_id =3D xdp_id.id;
+=09ret =3D libbpf_nl_get_link(sock, nl_pid, get_xdp_info, &xdp_id);
+=09if (!ret) {
+=09=09size_t sz =3D min(info_size, sizeof(xdp_id.info));
+
+=09=09memcpy(info, &xdp_id.info, sz);
+=09=09memset((void *) info + sz, 0, info_size - sz);
+=09}
=20
 =09close(sock);
 =09return ret;
 }
=20
+static __u32 get_xdp_id(struct xdp_link_info *info, __u32 flags)
+{
+=09if (info->attach_mode !=3D XDP_ATTACHED_MULTI)
+=09=09return info->prog_id;
+=09if (flags & XDP_FLAGS_DRV_MODE)
+=09=09return info->drv_prog_id;
+=09if (flags & XDP_FLAGS_HW_MODE)
+=09=09return info->hw_prog_id;
+=09if (flags & XDP_FLAGS_SKB_MODE)
+=09=09return info->skb_prog_id;
+
+=09return 0;
+}
+
+int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags)
+{
+=09struct xdp_link_info info;
+=09int ret;
+
+=09ret =3D bpf_get_link_xdp_info(ifindex, &info, sizeof(info), flags);
+=09if (!ret)
+=09=09*prog_id =3D get_xdp_id(&info, flags);
+
+=09return ret;
+}
+
 int libbpf_nl_get_link(int sock, unsigned int nl_pid,
 =09=09       libbpf_dump_nlmsg_t dump_link_nlmsg, void *cookie)
 {

