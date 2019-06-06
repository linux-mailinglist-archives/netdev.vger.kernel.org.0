Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5CC1381E3
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfFFXob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:44:31 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:54385 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfFFXob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:44:31 -0400
Received: by mail-ot1-f73.google.com with SMTP id a22so104018otr.21
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 16:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yIAOiUR5MXSs0CiyCgU+9aJYiOAQkEG92QODcW/Lbo8=;
        b=MZWxDlUS5nb0aejTNEDw1DHXjSlflonulcaLgnuNTKsd7Oc3VE1NgJn6COFlqRIIai
         8p8ygQXE8QGsQP4wWSAbtx5QVCkSteTGFd3ra23YRp7eY9mb8pVYa0zAy1sHf3cR/elo
         sKNehU4YcrVLqtwAqoKNH+XFz3TVWTb4VyWxVAG9y7hAXNvihvmAyWrOnj2bVtLZzQ9V
         RWdC4bK6SfTQCJa+CJDFiefxw02vTPye15aXFJFB5A0q50UlImTBnfQGL6QRWAYh/5Q8
         xdCuWB+2VhPd6Y4/7iVgdE0W4lO8pjLwlWFd/J8PN929gEZRfT3949lPSLGRZoofsbEs
         7weQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yIAOiUR5MXSs0CiyCgU+9aJYiOAQkEG92QODcW/Lbo8=;
        b=gpbDWdqupWGLq/hw6fXICi6LJjGVBMWOMH3xZUSRd8pPUGic+nn4doFiKhfpufnvVz
         +tT5QEjA2WM8aRZNn+r6Q+AiGwZCbcxv4mjM7F15RYZCVidKSQ5hy+lifcj6ggi6xlWK
         FPksTsO1vyyTISMishoyuaOQyCqCIHXxaSAwbZN0q2oifqpNblllxpg7bK50FN+XlT32
         QTCwBhxP0rNXMKl2sS1ex61uWmd45Dt4tLnOhBD+STzH4BXI7k/5qeKpqq4uiUi8Ckgy
         CCXPru1onc6UDIBhDrLSxfxoL1xXsCI5AtUt6ORTfnYW6JDY8sJ8MzZLHnCDW55wVWwg
         sWMg==
X-Gm-Message-State: APjAAAUl4NFYa8dZwVzWD82bCvfpUb/IjrEQcTEAUUHs+zXE/DlnChU6
        DgOgCD7dFHytEZYHlkam63OWQZmKd5SO
X-Google-Smtp-Source: APXvYqyqW/5pbA2UhojYyTQW/xyYArmkxslKmxNMQ2eLOvgSUV9g4CdM+pWR9P5NpXQA2y2ZndPCGkrlos0p
X-Received: by 2002:aca:805:: with SMTP id 5mr1829052oii.99.1559864670813;
 Thu, 06 Jun 2019 16:44:30 -0700 (PDT)
Date:   Thu,  6 Jun 2019 16:44:26 -0700
Message-Id: <20190606234426.208019-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH iproute2] ip6tunnel: fix 'ip -6 {show|change} dev <name>' cmds
From:   Mahesh Bandewar <maheshb@google.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Mahesh Bandewar <mahesh@bandewar.net>,
        Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inclusion of 'dev' is allowed by the syntax but not handled
correctly by the command. It produces no output for show
command and falsely successful for change command but does
not make any changes.

can be verified with the following steps
  # ip -6 tunnel add ip6tnl1 mode ip6gre local fd::1 remote fd::2 tos inherit ttl 127 encaplimit none
  # ip -6 tunnel show ip6tnl1
  <correct output>
  # ip -6 tunnel show dev ip6tnl1
  <no output but correct output after this change>
  # ip -6 tunnel change dev ip6tnl1 local 2001:1234::1 remote 2001:1234::2 encaplimit none ttl 127 tos inherit allow-localremote
  # echo $?
  0
  # ip -6 tunnel show ip6tnl1
  <no changes applied, but changes are correctly applied after this change>

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 ip/ip6tunnel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
index 999408ed801b..56fd3466ed06 100644
--- a/ip/ip6tunnel.c
+++ b/ip/ip6tunnel.c
@@ -298,6 +298,8 @@ static int parse_args(int argc, char **argv, int cmd, struct ip6_tnl_parm2 *p)
 		p->link = ll_name_to_index(medium);
 		if (!p->link)
 			return nodev(medium);
+		else
+			strlcpy(p->name, medium, sizeof(p->name));
 	}
 	return 0;
 }
-- 
2.22.0.rc1.311.g5d7573a151-goog

