Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10798514118
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 05:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235818AbiD2DVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 23:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiD2DVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 23:21:22 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057F358383
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 20:18:03 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id m62so5791056vsc.2
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 20:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zappem-net.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=hP5zDKwX4YrMuIykWqdscTonYIj8M09Ub7CmGfBbQHI=;
        b=vND5ZG87WxEZH0u5PXmZX4oJvykE3MuYGIS3UG0fd1oN6Z+s/TlGMHrov3ANrMUzwQ
         78P+4flgFV7sBROZ69E9/7hAtkuX4AQnlQL1hTWxHn7nYRPMWJ15M3A0iBUdD7tz7fRN
         lATti1e+Tm/B34qmATAIpgNMx76YTsLtPfzmDeiaBJqOQYnH3u0apnnARl/OkFJvu3Lr
         z4Fn57tpUw2wpMtC9xCKa/Ln+eYJ0UT/Ph1P8yfl0UcKkx8Teispg1WTqTWPYt4EAhU3
         oErPrTVvmeHnVpyXFVVp6lo1PpACKng0bb9iehCrLzlKvXTI2gDsOHJsRc7bu+F7ejHC
         ZzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=hP5zDKwX4YrMuIykWqdscTonYIj8M09Ub7CmGfBbQHI=;
        b=UaAWCS6aIBYIFaklyIp7N5QUFuo5haMV29xhpL9jbNeBPgC+mq4EKNYJH0mFedayMR
         nJsf6ZC5vYxJZMKah8v8FlYyyqhJ9j3H0Dm7ZBHv1lARggdBmzCq/vDzkIwXaAOckp9M
         bNwDiuqG8TS6bjUwNf8PjAfkJk8f0it4SiJW/SVdoj0MKqRwjtH8sXf6pLkgpL55PpcD
         /lKMyf1xAkktAQJfGcfE1OkkEJYMTlbDJOgWl2oNHlZiRajIj/cukHLIJM0IE7B94W5O
         W0FBFEecqf2F+Fyzn3FZ1vIw+MrWKHrRNZw3j1ag7NDRfD8WMk/e0KlEW2+49KICkX2g
         w2NA==
X-Gm-Message-State: AOAM531nY4o8oojBViuSWJo6riXzA5isiIgljRcpY+JMiLuHfybHI39t
        hC1PVVCXSiLgdg8c3pbyAFO8V5TJSlK2nFIPgo0PHA9wOOqkBA==
X-Google-Smtp-Source: ABdhPJyoEFIuM+yTi35sShbgaR7I0sD3yA7RUWej8bTPcPKS/dKS6yQ25a9G1++hFPfVH2qxHQs3VemRIoRF9wvh8Po=
X-Received: by 2002:a67:fd76:0:b0:32c:c03f:284 with SMTP id
 h22-20020a67fd76000000b0032cc03f0284mr8211907vsa.9.1651202282434; Thu, 28 Apr
 2022 20:18:02 -0700 (PDT)
MIME-Version: 1.0
From:   Tinkerer One <tinkerer@zappem.net>
Date:   Thu, 28 Apr 2022 20:17:51 -0700
Message-ID: <CABCx3R0QbN2anNX5mO1iPGZNgS=wdWr+Rb=bYGwf24o6jxjnaQ@mail.gmail.com>
Subject: Simplify ambient capability dropping in iproute2:ip tool.
To:     netdev@vger.kernel.org
Cc:     bluca@debian.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is expanded from https://github.com/shemminger/iproute2/issues/62
which I'm told is not the way to report issues and offer fixes to
iproute2 etc.

[I'm not subscribed to the netdev list, so please cc: me if you need more info.]

The original change that added the drop_cap() code was:

https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=ba2fc55b99f8363c80ce36681bc1ec97690b66f5

In an attempt to address some user feedback, the code was further
complicated by:

https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=9b13cc98f5952f62b825461727c8170d37a4037d

Another user issue was asked about here (a couple days ago):

https://stackoverflow.com/questions/72015197/allow-non-root-user-of-container-to-execute-binaries-that-need-capabilities

I looked into what was going on and found that lib/utils.c contains
some complicated code that seems to be trying to prevent Ambient
capabilities from being inherited except in specific cases
(ip/ip.c:main() calls drop_cap() except in the ip vrf exec case.). The
code clears all capabilities in order to prevent Ambient capabilities
from being available. The following change achieves suppression of
Ambient capabilities much more precisely. It also permits ip to not
need to be setuid-root or executed under sudo since it can now be
optionally empowered by file capabilities:

diff --git a/lib/utils.c b/lib/utils.c
index 53d31006..681e4aee 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -1555,25 +1555,10 @@ void drop_cap(void)
 #ifdef HAVE_LIBCAP
        /* don't harmstring root/sudo */
        if (getuid() != 0 && geteuid() != 0) {
-               cap_t capabilities;
-               cap_value_t net_admin = CAP_NET_ADMIN;
-               cap_flag_t inheritable = CAP_INHERITABLE;
-               cap_flag_value_t is_set;
-
-               capabilities = cap_get_proc();
-               if (!capabilities)
-                       exit(EXIT_FAILURE);
-               if (cap_get_flag(capabilities, net_admin, inheritable,
-                   &is_set) != 0)
+               /* prevent any ambient capabilities from being inheritable */
+               if (cap_reset_ambient() != 0) {
                        exit(EXIT_FAILURE);
-               /* apps with ambient caps can fork and call ip */
-               if (is_set == CAP_CLEAR) {
-                       if (cap_clear(capabilities) != 0)
-                               exit(EXIT_FAILURE);
-                       if (cap_set_proc(capabilities) != 0)
-                               exit(EXIT_FAILURE);
                }
-               cap_free(capabilities);
        }
 #endif
 }
