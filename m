Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4D5A160C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbiHYPqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiHYPqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:46:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B93666A63;
        Thu, 25 Aug 2022 08:46:48 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d16so19857900wrr.3;
        Thu, 25 Aug 2022 08:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=57xxbL1i7eokf4R/PelYGOTPIVWeepz+b6OSXdfxDFA=;
        b=WaodnY9YBsmYzV8fSt09Pycuux4V5c8GNAkiGycbEwVnXDD+JAI7PpGjk4vnHp/G+e
         NQXU150fmtweSjoAJA7at6LhXoFBN9o/4g1GpIsGUxaAlcl9QC5FkP3ruvzVIhzsb/Vv
         94ZBS8Jpp6aLHrg1qmmdknpBH56rGJmH7zddjie5OIlz3vBCQhL/vL1dh6yizAXAG9Ex
         mcFe21ivB8f5UENk6MJjebhQ/Ta6LjLQP4rGCsO7uzCxTqbKHcsM8XouQRKbKbBUIOP9
         2f+jE4eJlMatTz/olPvUoGr4OGUjI4g6oyt20tN/KKbggQG3EPvMyp2F72NAxsqFPbDZ
         L4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=57xxbL1i7eokf4R/PelYGOTPIVWeepz+b6OSXdfxDFA=;
        b=jzfiVOfHSfQGTTAhH9crFvW0cKzOaamlmNSCMBEPvilhcw54SvXyQJNeX1koj0QIr7
         H2BzZaAjOuAMtQUJffAnRaCd6qqQ8zc8LqNna0PWQEAmTlA1LNsk7Ne45MZVoSimslsj
         pjC3eICac7ApReGZ6+HoJIMDUAVCxG54iT2Em1KxPFPRzKmhbUH4Ucubvdn+AzPdkU28
         R0QLLH8cS9gTq+me97dFJI1LlTkhBiMHdTV/SDDf5ewyE8tuC4+iOJypC5ri4piqEYex
         IOu/dqMTIjNkqH/l41qr+PwR6/A+7D/0Hgp/vI9aRyLCMMQrIEbnUJbXslsd3ty68rrE
         bnng==
X-Gm-Message-State: ACgBeo3a9eR4JzmqzJrKO5BVm5LC0Z+0ynsIah+mnLUMbnIfO0lyt0kF
        +mLl388Zu44jU4aCANXWiBI=
X-Google-Smtp-Source: AA6agR5fVNF4kbItUbi8IOPI2nSpwpxc80ox4HfND1MffyiBwUUjvXlZW+ZHtgBZ1ZdEWysA5cF+gA==
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id g8-20020a056000118800b002206c20fbf6mr2786378wrx.372.1661442406904;
        Thu, 25 Aug 2022 08:46:46 -0700 (PDT)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id ay17-20020a05600c1e1100b003a541d893desm5661496wmb.38.2022.08.25.08.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:46:46 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal@nsof.io>
Subject: [PATCH ipsec-next,v3 0/3] xfrm: support collect metadata mode for xfrm interfaces
Date:   Thu, 25 Aug 2022 18:46:27 +0300
Message-Id: <20220825154630.2174742-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal@nsof.io>

This series adds support for "collect_md" mode in XFRM interfaces.

This feature is useful for maintaining a large number of IPsec connections
with the benefits of using a network interface while reducing the overhead
of maintaining a large number of devices.

Currently this is possible by having multiple connections share a common
interface by sharing the if_id identifier and using some other criteria
to distinguish between them - such as different subnets or skb marks.
This becomes complex in multi-tenant environments where subnets collide
and the mark space is used for other purposes.

Since the xfrm interface uses the if_id as the differentiator when
looking for policies, setting the if_id in the dst_metadata framework
allows using a single interface for different connections while having
the ability to selectively steer traffic to each one. In addition the
xfrm interface "link" property can also be specified to affect underlying
routing in the context of VRFs.

The series is composed of the following steps:

- Introduce a new METADATA_XFRM metadata type to be used for this purpose.
  Reuse of the existing "METADATA_IP_TUNNEL" type was rejected in [0] as
  XFRM does not necessarily represent an IP tunnel.

- Add support for collect metadata mode in xfrm interfaces

- Allow setting the XFRM metadata from the LWT infrastructure

Future additions could allow setting/getting the XFRM metadata from eBPF
programs, TC, OVS, NF, etc.

[0] https://patchwork.kernel.org/project/netdevbpf/patch/20201121142823.3629805-1-eyal.birger@gmail.com/#23824575

Eyal Birger (3):
  net: allow storing xfrm interface metadata in metadata_dst
  xfrm: interface: support collect metadata mode
  xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md
    mode

 include/net/dst_metadata.h    |  31 +++++
 include/net/xfrm.h            |  11 +-
 include/uapi/linux/if_link.h  |   1 +
 include/uapi/linux/lwtunnel.h |  10 ++
 net/core/lwtunnel.c           |   1 +
 net/xfrm/xfrm_input.c         |   7 +-
 net/xfrm/xfrm_interface.c     | 206 ++++++++++++++++++++++++++++++----
 net/xfrm/xfrm_policy.c        |  10 +-
 8 files changed, 248 insertions(+), 29 deletions(-)

----

v3: coding changes as suggested by Nikolay Aleksandrov and
    Nicolas Dichtel
v2: add "link" property as suggested by Nicolas Dichtel

-- 
2.34.1

