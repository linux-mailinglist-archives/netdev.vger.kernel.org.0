Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C066C4F9A
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCVPmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCVPms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:42:48 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC23618A8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:42:46 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id s8so23703430lfr.8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1679499765;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A7lhRwEK6KQgDNYBCDkzFXD6PlhQcpLQw6XoSdq4eMc=;
        b=n4FLScvDb5zjv0MIxOLGQ7/5VZCeTvpRl8k45VTLp9GM4tr0aHa22RZU5oyBQXbDFL
         CJh7n8jJRpJ7cdbr5wdA6TsuncX+SRdwIgSBcY4fK5KHxGA8YO9X/nDOZKwvD0dAHiCo
         mCB1bw2KCgYI5c/44zeOrv3+idPQm59HhMF6m/NuAcKgCGj7qBQZ2oqvxWe67o7AwY7E
         02nvVlholNUNaHw+Qgp9GdXQdDdOeadxCIYr1gBcwepqS6jSojuxJajBqDnmb7LMKpET
         lPzEgPUCcbS2ETvXoQPfl1HZieTmo62tPsjPGiHxFJjVzDPDGK/5V7aZqY2/fmviliTP
         ny8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679499765;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A7lhRwEK6KQgDNYBCDkzFXD6PlhQcpLQw6XoSdq4eMc=;
        b=MMpLOk6f4V6oU6GV/JUGeEQVimJHv59WX8f8nSoWnMlZe7XfZP0erfIWC++RJgK5nz
         bqnM6xO6k5JcRDZJUv5gF/C/LGf20/8RX3v9s0mHZncCZVLSNWZ0mUVtNW3JXMucy8+2
         Obwh8nuS5HlUT8uvAuR2YzLrSzFwN+7wiMfAR8oE7eF7R2vb8JxurCF4B0SAhaRPP7xt
         i//stf8Kbi2OJdTmJ1iAyzOzb9w09MlE13l4w8ZId/zg4M6JcI9DUalNxxYOIXWgdkCK
         x3PFeYCbH0k4hLRYleOr7wxYViTkaKF+kCU7HywJ9We+uQPdQ6Cpqi3oSWelg2UAY4gP
         gODg==
X-Gm-Message-State: AAQBX9d6xeY3mTwxi6pulJiubO6DeHKPQU0MS/Jqn26GSsemHZGSPrKO
        GEWmcAYlN8HRoh+BnLoeQCTsBcmG+9mXTbkFJPA=
X-Google-Smtp-Source: AKy350ajQIeMsRKM8FXcd2HWJ9xJFte/9q84I9yZhStXg2rdko0/aWvGbM5vtmm2G4c+CNvBAfSu2A==
X-Received: by 2002:ac2:5327:0:b0:4ea:f8f0:5461 with SMTP id f7-20020ac25327000000b004eaf8f05461mr651546lfh.55.1679499764650;
        Wed, 22 Mar 2023 08:42:44 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r14-20020ac252ae000000b004db2b54714bsm2611283lfm.67.2023.03.22.08.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 08:42:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, sdf@google.com
Subject: [patch net-next] ynl: allow to encode u8 attr
Date:   Wed, 22 Mar 2023 16:42:42 +0100
Message-Id: <20230322154242.1739136-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Playing with dpll netlink, I came across following issue:
$ sudo ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/dpll.yaml --do pin-set --json '{"id": 0, "pin-idx": 1, "pin-state": 1}'
Traceback (most recent call last):
  File "tools/net/ynl/cli.py", line 52, in <module>
    main()
  File "tools/net/ynl/cli.py", line 40, in main
    reply = ynl.do(args.do, attrs)
  File "tools/net/ynl/lib/ynl.py", line 520, in do
    return self._op(method, vals)
  File "tools/net/ynl/lib/ynl.py", line 476, in _op
    msg += self._add_attr(op.attr_set.name, name, value)
  File "tools/net/ynl/lib/ynl.py", line 344, in _add_attr
    raise Exception(f'Unknown type at {space} {name} {value} {attr["type"]}')
Exception: Unknown type at dpll pin-state 1 u8

I'm not that familiar with ynl code, but from a quick peek, I suspect
that couple other types are missing for both encoding and decoding.
Ignoring those here as I'm scratching my local itch only.

Fix the issue by adding u8 attr packing.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 tools/net/ynl/lib/ynl.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index 90764a83c646..bcb798c7734d 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -334,6 +334,8 @@ class YnlFamily(SpecFamily):
                 attr_payload += self._add_attr(attr['nested-attributes'], subname, subvalue)
         elif attr["type"] == 'flag':
             attr_payload = b''
+        elif attr["type"] == 'u8':
+            attr_payload = struct.pack("B", int(value))
         elif attr["type"] == 'u32':
             attr_payload = struct.pack("I", int(value))
         elif attr["type"] == 'string':
-- 
2.39.0

