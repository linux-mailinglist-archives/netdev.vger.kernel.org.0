Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97313FED11
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 13:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhIBLkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 07:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhIBLj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 07:39:58 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B9EC061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 04:39:00 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id m9so2416602wrb.1
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 04:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AfzGsjNhCTc6+kVbJpHYpPyiFOcEp5mM/5LdqAde+oc=;
        b=lVUS4PhlfKyBsLhecKs9rWXbJRf0dnWTkkJ134QkNlXOEdq8jxf5iFLEbuzrsxZ8kF
         OuoU7Ovkhbvrq9HWPiEqEbcK94WyeztWpG6R4UNDUwzLNY6t0/yAQKoU2XUIGWS+nKVB
         1+Jou/eLIzmP5TwQAJ5zYJBcKItwG56NjGvMcnAIMbUpCg5qMd0FufkM8Au6y7fML4lH
         QoX4vZ8aAbEjQyh/A1hs9yKbzS6G9ZtBq2+jLDaXQO/sXU9mK6Qh17CHMk2NA9AXz9bI
         8nSe7AWgV9OgN+1Pk3COFT5dGcLlaPC2uMcIbR75X8sWl02XegJsGkxxlHdT6KMMv7nP
         /Nmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AfzGsjNhCTc6+kVbJpHYpPyiFOcEp5mM/5LdqAde+oc=;
        b=tQOAxdjct7rG+GlllCwNpM473AadSbr2+jEtNC77UKoDSIzX/q3ykjFZTNwkAuG0zH
         7lUIls6e1rCHMbJeZWKceEptqC/zn7HDI8+UVeOHA94uFJD2IE7o9PKvyUgcnAXcRdN7
         TcUwjv98bGLUsIlE7NW63hsHMJyWTj3Q1mp/EyW3buTJyPtdwMP2DgFK16/T+Pv6ITAY
         p37xMYpnmZ2mAwdEtIfle4qNO9AAKpudcZuTgHz0kSMgtI5/FPzzX2Ef4zmB5v/kIgig
         5opuFIPo3wMRGSwBV3dn5thDGS4ccGxfxbTOPQ+mlNR6x3wXhNBOG1jo/Tzfn3Lj/4Lz
         rxnA==
X-Gm-Message-State: AOAM533W4JjPZlGU+N+iB187w7GdhPMbjt4sNwjM0NMWl+L894VKHRIG
        vaedqiBxViYX/TBEmL/cAbXmbo63QKkgJQ==
X-Google-Smtp-Source: ABdhPJwGvb2qUWO2aq8q6JeiOz9jgsBiSwrrGnpMNIqxz5vkquiElRf5ilTNJH6tAsX4PbZ3qh+TsQ==
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr3120548wrm.173.1630582738754;
        Thu, 02 Sep 2021 04:38:58 -0700 (PDT)
Received: from localhost ([2a01:4b00:f41a:3600:df86:cebc:8870:2184])
        by smtp.gmail.com with ESMTPSA id z1sm1464176wmi.34.2021.09.02.04.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 04:38:58 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2] configure: restore backward compatibility
Date:   Thu,  2 Sep 2021 12:38:54 +0100
Message-Id: <20210902113854.35513-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Boccassi <bluca@debian.org>

Commit a9c3d70d902a0473ee5c13336317006a52ce8242 broke backward compatibility
by making 'configure' error out if parameters are passed, instead of
ignoring them.
Sometimes packaging systems detect 'configure' and assume it's from
autotools, and pass a bunch of options. Eg:

 dh_auto_configure
	./configure --build=x86_64-linux-gnu --prefix=/usr --includedir=${prefix}/include --mandir=${prefix}/share/man --infodir=${prefix}/share/info --sysconfdir=/etc --localstatedir=/var --disable-option-checking --disable-silent-rules --libdir=${prefix}/lib/x86_64-linux-gnu --runstatedir=/run --disable-maintainer-mode --disable-dependency-tracking

Ignore unknown options again instead of erroring out.

Fixes: a9c3d70d902a ("configure: add options ability")

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 0a4a0fc9..7f4f3bd9 100755
--- a/configure
+++ b/configure
@@ -518,7 +518,7 @@ else
 			"")
 				break ;;
 			*)
-				usage 1 ;;
+				shift 1 ;;
 		esac
 	done
 fi
-- 
2.33.0

