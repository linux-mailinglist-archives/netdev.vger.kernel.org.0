Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A321E4B7C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgE0RI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731154AbgE0RIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:08:54 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC289C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:53 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x1so28949809ejd.8
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q+2bwX22EsAe1QSviW85LaE3gusRIu6tmCK3DJYgP0A=;
        b=pJb9l1y42ndLHge2lnFbaiY0JdrTHacaAUore46NzLEsmS5kyVGmJm4KcrXr/zOSn4
         XVVlG75EF8INWAdz0oYeRKfmtqPxZizcZXON0UaAbyUbfWfQBTWr6FuCAaDtP2li/gK9
         2yoYbHR1CxdxTFhSgR8ES9IHl5bGziaJbKitI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q+2bwX22EsAe1QSviW85LaE3gusRIu6tmCK3DJYgP0A=;
        b=qnxkLk6HxKjPbQCiiemVtaOhqs8eA1qw2wkoePDmo4LNjvsygBE0zNSDOBzsdvr+XN
         Dgsb3XwDpIQCCM+HIekIzCRxukqd96Xok1rGjlmeo+WTrj2tZiwH1xZU4MBUqZvEUs3D
         3nGcq1V3XC2soUepEzwt5KuEplhHY/USOd8H8P1FlFvOIWaOUMUH0JeM6BHAfK0lxqi4
         dOFm88p+QGynsQ5anb5e4hjxoAB5EXBze0ot9zU9SgfiM7bLyEA4KuDZSO1bH0sMHwfu
         jM13xJt1idD2nAx9vD5YmTqcC7V5EBTBDH0cc5Mpkt5W+btZuA+m0HIfWRbaqUdEcbkC
         sjxQ==
X-Gm-Message-State: AOAM5320qsFdeOLaUO1aCB5AvFgOr6Jtc0sulBkcCIi0t+rSSdw8Hz6W
        nqssHIdNJc3cR98sdQJzucOZmQ==
X-Google-Smtp-Source: ABdhPJwKwyXVikczHmirkQfA12LUtINfPEsR3pHynCmpmypONRRw/La2SksS0Yw0oHPT43fqJFgzQg==
X-Received: by 2002:a17:906:b24f:: with SMTP id ce15mr6948749ejb.59.1590599332399;
        Wed, 27 May 2020 10:08:52 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id da17sm2604927edb.11.2020.05.27.10.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 10:08:51 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 7/8] bpftool: Support link show for netns-attached links
Date:   Wed, 27 May 2020 19:08:39 +0200
Message-Id: <20200527170840.1768178-8-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200527170840.1768178-1-jakub@cloudflare.com>
References: <20200527170840.1768178-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make `bpf link show` aware of new link type, that is links attached to
netns. When listing netns-attached links, display netns inode number as its
identifier and link attach type.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/bpf/bpftool/link.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 670a561dc31b..83a17d62c4c3 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -17,6 +17,7 @@ static const char * const link_type_name[] = {
 	[BPF_LINK_TYPE_TRACING]			= "tracing",
 	[BPF_LINK_TYPE_CGROUP]			= "cgroup",
 	[BPF_LINK_TYPE_ITER]			= "iter",
+	[BPF_LINK_TYPE_NETNS]			= "netns",
 };
 
 static int link_parse_fd(int *argc, char ***argv)
@@ -122,6 +123,16 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
 			jsonw_uint_field(json_wtr, "attach_type",
 					 info->cgroup.attach_type);
 		break;
+	case BPF_LINK_TYPE_NETNS:
+		jsonw_uint_field(json_wtr, "netns_ino",
+				 info->netns.netns_ino);
+		if (info->netns.attach_type < ARRAY_SIZE(attach_type_name))
+			jsonw_string_field(json_wtr, "attach_type",
+				attach_type_name[info->netns.attach_type]);
+		else
+			jsonw_uint_field(json_wtr, "attach_type",
+					 info->netns.attach_type);
+		break;
 	default:
 		break;
 	}
@@ -190,6 +201,14 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
 		else
 			printf("attach_type %u  ", info->cgroup.attach_type);
 		break;
+	case BPF_LINK_TYPE_NETNS:
+		printf("\n\tnetns_ino %u  ", info->netns.netns_ino);
+		if (info->netns.attach_type < ARRAY_SIZE(attach_type_name))
+			printf("attach_type %s  ",
+			       attach_type_name[info->netns.attach_type]);
+		else
+			printf("attach_type %u  ", info->netns.attach_type);
+		break;
 	default:
 		break;
 	}
-- 
2.25.4

