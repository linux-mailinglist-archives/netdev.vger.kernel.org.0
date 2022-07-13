Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3AB574019
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 01:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiGMXkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 19:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiGMXkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 19:40:46 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7680C509C1;
        Wed, 13 Jul 2022 16:40:45 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id bh13so8283pgb.4;
        Wed, 13 Jul 2022 16:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hIeO3opyZf6HnkUX87feyv18m3Q65HBILavBjNxjfqs=;
        b=IC/WcfcEC1Cz9/45QmOtWZTVoia7SSaR15G2ZJnNjlWwDU8Q89WiDCJbIykAmQzT4s
         kOWbIUY61FfQSZwgffJ0V8PSB3DHtw7gDYkSwFxMGlju2W1v6jQjAaeKNCZBeEaI27Nj
         BUdRKm5yjCGPuoBCd+W0v4ITlxlYzbkp8FZP9F4IZ/mgjRftqLgTSwD78NRN5BkSMYe6
         bobLo/grzjSwHsbs5IOD8+hse9czjalVrC1xJMrmUalkBqthYA7HqMbCje0Ff8Zr56Jx
         kzacYQ+0Gr1WpKxvETWwX4wI+OuF2dDxck7Rn+f83mwBmR0lHtMGBZjsoQNHCzYgKD+u
         zEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hIeO3opyZf6HnkUX87feyv18m3Q65HBILavBjNxjfqs=;
        b=F7TWnzvXKYrJ0hzOmo9Ep5gu4I6UzflyFnjAPMC1U43WiuSUlYu5+CeAp6+FX0xGSD
         LBj1IFv43cLLd26edzqbZfWJ71mbuk1aGSyfjdRrLaioaF2qLCTQrW+LkrKN/qD8a/+0
         SffQNPBSRhsoj81/wjCG/y9KxDxmNq3Qr3ujm2ETcjdAwRMl2Yqjb4foyMX9HOP5tljK
         nUPdrRtMGfeDzq4qIZ8IPHC33yEj+0hKNIVde1bgAbpgJAlwI7e+UNb+430jg4H+ZoeC
         qme7ltHveAOTTngqaR+BOEZOmnV1QCDcRKaahMfPrfK0xVocEuncqeGyxhV8hgYAU1es
         XbLw==
X-Gm-Message-State: AJIora+a3N9AnRR8xxaiInivD+hbnxJb9WgWlAeERSLBRMsVniGgR2ns
        X5YPgMUkG/I8HYGujjPTUlbC8DVSiYq2tAvmD5I=
X-Google-Smtp-Source: AGRyM1v7uROft4wCwLyJCPDHmeFKv+XMUokThxGa62zybBfVaamm8jZCUGQPM6/LtWz/xz/7GoCnFg==
X-Received: by 2002:a63:84c8:0:b0:415:b761:efa1 with SMTP id k191-20020a6384c8000000b00415b761efa1mr4895898pgd.89.1657755644732;
        Wed, 13 Jul 2022 16:40:44 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id 188-20020a6216c5000000b005286a4ca9c8sm87653pfw.211.2022.07.13.16.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 16:40:43 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        dsahern@gmail.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, linux-kernel@vger.kernel.org,
        aajith@arista.com, roopa@nvidia.com, roopa.prabhu@gmail.com,
        aroulin@nvidia.com, sbrivio@redhat.com, jhpark1013@gmail.com
Subject: [PATCH v3 net-next 0/3] net: ipv4/ipv6: new option to accept garp/untracked na only if in-network
Date:   Wed, 13 Jul 2022 16:40:46 -0700
Message-Id: <cover.1657755188.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds an option to learn a neighbor from garp only if
the source ip is in the same subnet as an address configured on the
interface that received the garp message. The option has been added
to arp_accept in ipv4.

The same feature has been added to ndisc (patch 2). For ipv6, the
subnet filtering knob is an extension of the accept_untracked_na
option introduced in these patches:
https://lore.kernel.org/all/642672cb-8b11-c78f-8975-f287ece9e89e@gmail.com/t/
https://lore.kernel.org/netdev/20220530101414.65439-1-aajith@arista.com/T/

The third patch contains selftests for testing the different options
for accepting arp and neighbor advertisements. 

v3
- fixed tabs in the selftest

v2
- reworded documentation and commit messages
- cleanup selftest

Jaehee Park (3):
  net: ipv4: new arp_accept option to accept garp only if in-network
  net: ipv6: new accept_untracked_na option to accept na only if
    in-network
  selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and
    accept_untracked_na

 Documentation/networking/ip-sysctl.rst        |  52 +--
 include/linux/inetdevice.h                    |   2 +-
 net/ipv4/arp.c                                |  24 +-
 net/ipv6/addrconf.c                           |   2 +-
 net/ipv6/ndisc.c                              |  29 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../net/arp_ndisc_untracked_subnets.sh        | 308 ++++++++++++++++++
 7 files changed, 389 insertions(+), 29 deletions(-)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh

-- 
2.30.2

