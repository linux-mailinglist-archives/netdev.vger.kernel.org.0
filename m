Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662A45A2709
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245568AbiHZLrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiHZLrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:47:16 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D567AB275F;
        Fri, 26 Aug 2022 04:47:15 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b5so1506026wrr.5;
        Fri, 26 Aug 2022 04:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=lNNbXqiX/eP8B7nRmq3nETA/T477NpHd1pIANJizolk=;
        b=lUaI4WPCoIncUAfXAnsr7iWBBaiCSu4FETX4SWsDQugDZ5rmtW3KhLPgAUp3sV4jwj
         ug1hhBn/UO2Bhft9A/bmGUX/Vr3FiCynMT9A0NZeRthxIckO4+u4l9yLpP3qEewjhEJe
         wRvo2IVtWwgD8QNgaaFbiBdA+8tXfNm3tYVwApe1gCJ/rF9kzcD5JVkPgGb+fPlriIV7
         bKPSZZTG2ZCNIDK44S95TwWLAPmVFA1BOks7kYsDPuOdOh8HVGNtSh7uSmqqtRP3Dgwh
         QmD4XFE/dHRLAw9jxv6JvtQcf/jkiorWHacnYY0NsVvrIMkoq3qCZOy3B652lcz6LkZR
         prEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=lNNbXqiX/eP8B7nRmq3nETA/T477NpHd1pIANJizolk=;
        b=IAszwWvqYri/cEVbBwYCiW95ST3dCyxERF+N/xqLkqxUfiTPjb0409aXsXVemzm0kw
         916MaGEGMe89PY7C8on2Ba8zLPc4E/2mNU5r2tAR6li6VF49bo44r2Ao4vlFbt5kJCTA
         ntakFGsChqXnWPtY+PouFXWMCi3ITnj9MCPck1MuA0iIUokLyMtTkc1lnsp2mZtdVIx4
         UXjuJvHyAOrwwdLucjMnneD9zugMYF4BOzg7pXcY2/K788/TkblAg7uurB8BavALvUph
         j7bPaPnXOOp/Y1ArMPrsD9uxp1oBtP2gOIBLgC4yU8WPqfbkUaizHb1sVbMDinZnlfnu
         SI3w==
X-Gm-Message-State: ACgBeo1lwNjoLhWb0c3cboWrQgUOv4KrZDzTwrdn8WGNF/CBvVNq50YL
        ZocpksgUfRD0fnWNcfmpqJU=
X-Google-Smtp-Source: AA6agR4UWdKwgEpxRDli3ORb1iZOZM1obKrY2nFxwu6Qe2b7M3friiT9Gs20Wt7OtKGiq8ap6/7JkA==
X-Received: by 2002:adf:f081:0:b0:225:7209:4bd7 with SMTP id n1-20020adff081000000b0022572094bd7mr5026112wro.36.1661514434223;
        Fri, 26 Aug 2022 04:47:14 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id w11-20020adfee4b000000b002254880c049sm1811322wro.31.2022.08.26.04.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 04:47:13 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next,v4 0/3] xfrm: support collect metadata mode for xfrm interfaces
Date:   Fri, 26 Aug 2022 14:46:57 +0300
Message-Id: <20220826114700.2272645-1-eyal.birger@gmail.com>
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

v4: coding change as suggested by Nicolas Dichtel
v3: coding changes as suggested by Nikolay Aleksandrov and
    Nicolas Dichtel
v2: add "link" property as suggested by Nicolas Dichtel

-- 
2.34.1

