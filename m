Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9E38EE41
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732962AbfHOOcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:32:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42326 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732939AbfHOOcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:32:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id b16so2394160wrq.9
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 07:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+M5QZmIoEDjFoyJBHLElsXh3utBUpsKEGE+Jc7c8+z4=;
        b=14Lz+QG3aKErrirXSdHf9sfwowcVMZ+QzmhdAcvspB14S7fqQ2tdA3bUAt/ynFNDND
         GvN9sUKqN6NflQl+U8npeZDjxRvxL9Rl6sDjF6kH/RFDkFVyAZv4IWiNHQhPAtRJS1+Y
         waaNF9x9XQ9vKNq/LPk1HzbNmwVETp+QOEmcwbmwnib5Ev6LI3t4bibUFBQDGpwb/7Hq
         QEP66Fg9yFHZsxw0HrxnGieMcD8RO2xZGVOPgm7rHupGY2EXfF34j3pf3kxXyjd1rV0P
         PWbCh4pFLitqbm/oi1HYV8aoFF8XxYjS0LPntrVkxl/UIYVaJYoiTjry5040rKbpic4w
         9ogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+M5QZmIoEDjFoyJBHLElsXh3utBUpsKEGE+Jc7c8+z4=;
        b=THLNUWs5fJDQ+R7J4nCIuNkG+C2LzWAl4NyeTjCV7kDJkcGyeuAWb6ICdYhODwxzn3
         84KI7nFCEN/TnZaQtQvn9rPbUJYcKXVSeeaVeXYGMX8Akp2ZND85OMX2+2I6l435/Qnh
         kAMbdqXxhPvPYw4jaSiW6zf0jvSpFG3ptheyzuE3qhDpjU34MWGn83LiBoWMqKgoEKen
         5OdBqXf11C6LMXoEfDNbke24u4Rl6bVR86Zv0Zf6bWG+IMli/DXhUuAtf9uNDHop1Zk4
         5Zm7RLBDbZ511z874gflyM/RYWdfJ99Vxd+NB+sOpQpEIOKXhBAmHk6fBGxPokkqU1WL
         aDNA==
X-Gm-Message-State: APjAAAXYbN8RePcQ+owFfS8HMGasyQzZDTeNh1Sxbt8uTyKQ1bjg2bUA
        L/p8gPofj5BXlVDpAg19JbltzQ==
X-Google-Smtp-Source: APXvYqxEiYETrrbQa3ic3kkobppYtfhZlBW+hw4D3+wsUpJUdI+0fj2L1q9agB3rNRCTY7aibCOjtQ==
X-Received: by 2002:adf:f5c5:: with SMTP id k5mr6175339wrp.42.1565879553547;
        Thu, 15 Aug 2019 07:32:33 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a19sm8857463wra.2.2019.08.15.07.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 07:32:32 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf 3/6] tools: bpftool: fix argument for p_err() in BTF do_dump()
Date:   Thu, 15 Aug 2019 15:32:17 +0100
Message-Id: <20190815143220.4199-4-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815143220.4199-1-quentin.monnet@netronome.com>
References: <20190815143220.4199-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last argument passed to one call to the p_err() function is not
correct, it should be "*argv" instead of "**argv". This may lead to a
segmentation fault error if BTF id cannot be parsed correctly. Let's fix
this.

Fixes: c93cc69004dt ("bpftool: add ability to dump BTF types")
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 1b8ec91899e6..8805637f1a7e 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -449,7 +449,7 @@ static int do_dump(int argc, char **argv)
 
 		btf_id = strtoul(*argv, &endptr, 0);
 		if (*endptr) {
-			p_err("can't parse %s as ID", **argv);
+			p_err("can't parse %s as ID", *argv);
 			return -1;
 		}
 		NEXT_ARG();
-- 
2.17.1

