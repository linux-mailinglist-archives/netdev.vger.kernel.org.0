Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FC7249B5F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 13:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgHSLFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 07:05:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22871 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727996AbgHSLFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 07:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597835141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BlIxxc2NP5YsxPio5n+cKYLRJVTpBsLfxKRpA+yVyjk=;
        b=IIGpNMIe7mTMQId78TybSJnl7xu7UIaZ4oVYTCZe9wmvVQey9u8iDUBVtjGYy7DDGfPunD
        zV663GdDfAO6b3zylbqxVYgyhMkkE7yq3XhcsftATBexUi3kB605WpMEVu/1pSsZlXDSnX
        LbVFF+x3rRdPhmieA+lytIqV5t1vM38=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-28s6clYFO0aqm3t9QGVkww-1; Wed, 19 Aug 2020 07:05:39 -0400
X-MC-Unique: 28s6clYFO0aqm3t9QGVkww-1
Received: by mail-wr1-f71.google.com with SMTP id s23so9228065wrb.12
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 04:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BlIxxc2NP5YsxPio5n+cKYLRJVTpBsLfxKRpA+yVyjk=;
        b=EPX+UmFzXh4kgZPVGCgCAD8Viw/dXF7sfHaBEOtseoUd/XzwEChiPFRjx74eWNbFxp
         jh+P3kWPb+AIXjvYAyjbwv8YruJixKdUeHWSP2eueJzSr5AUDSv9ueKfFnIFP3I3uPQ1
         +7khFjdimQrNjqduVzCwKwGrIAzLVGMN/JpyvXPNtLOyDg5wPF6craikrtJw61Hff+CV
         veF5y+Zs7w37TbnlXadzKS1GS2oJY+9zWOWC1fpLpYWBNsWlOlekSNrdmeDIpEHzX77f
         J4zKOXsFnfiYxou7v7ceY3kifCOSYKeAxf1Ni9P97vCpbZ2cxNm8iWx6BEC1M/8D1pcL
         4YZA==
X-Gm-Message-State: AOAM531NrhLesqirNdEvCue0qnQ9w0OAF0rI+q6Z7OE2cWRuar2spC6s
        mXZr6cSr2bdiCT6O+hJUcJKBURwt72k4hurHOFi7rqun9EK6p/yscU40sxfqlLaJfDfVEA8v+A4
        NSlPh0MgNyMx3hR6n
X-Received: by 2002:a1c:41c5:: with SMTP id o188mr4467216wma.187.1597835138158;
        Wed, 19 Aug 2020 04:05:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw++CRYKKVRjU61mp4sDlrM7r+oWH1k7qLIf/Zd+Cohsxxqj9be2dzy5fKmY9DjytQnLNYtyQ==
X-Received: by 2002:a1c:41c5:: with SMTP id o188mr4467191wma.187.1597835137971;
        Wed, 19 Aug 2020 04:05:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b123sm4931449wme.20.2020.08.19.04.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 04:05:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BD27D182B54; Wed, 19 Aug 2020 13:05:36 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf] libbpf: fix map index used in error message
Date:   Wed, 19 Aug 2020 13:05:34 +0200
Message-Id: <20200819110534.9058-1-toke@redhat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error message emitted by bpf_object__init_user_btf_maps() was using the
wrong section ID.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5d20b2da4427..0ad0b0491e1f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2264,7 +2264,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
 		data = elf_getdata(scn, NULL);
 	if (!scn || !data) {
 		pr_warn("failed to get Elf_Data from map section %d (%s)\n",
-			obj->efile.maps_shndx, MAPS_ELF_SEC);
+			obj->efile.btf_maps_shndx, MAPS_ELF_SEC);
 		return -EINVAL;
 	}
 
-- 
2.28.0

