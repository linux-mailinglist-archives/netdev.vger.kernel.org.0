Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578EB5A12A2
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 15:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242524AbiHYNrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 09:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242680AbiHYNq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 09:46:59 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA686CD2F;
        Thu, 25 Aug 2022 06:46:57 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id a4so24740391wrq.1;
        Thu, 25 Aug 2022 06:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Ke6soKFOZAGfHbnKxQALmRdaxCr6F9lXYSl5rdylzg8=;
        b=DVhVXHk8sOQ5uOtKp/5CPgdAviMT69V7pomRDHn5fTZ3vXVfwpJIb55Jd5aA+A0rFn
         aktH2UzRp/pmT6fK0wh2n4Zil1VVSE0DJtAaz8Bg1k7y73ANQbRIOPlvz25SCmipXQPT
         A8zU/8dpaZBSGGCWDQknq2uNUR4krgSPynXD1NxzD+Ywl97PES6Ygej8pkN6T49bHM7O
         /it8kUEn+uvQSV6cMHOuRy4d8nQlHnPW1OXA1mQd74hpNiItBXw7jrT/dU2TEGcJgLDA
         r6XHJsItK7QPnic4pWtCPRL7H1EuIOg4jqUSOmHpVlY7jz/xFMqTw+eumAwfZ1qVfqDE
         q30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Ke6soKFOZAGfHbnKxQALmRdaxCr6F9lXYSl5rdylzg8=;
        b=DDoTJmIH1xiYpPXkqUgNbYPyaCVyclIkNYRvgsu3FlS+AI1bZO3N6Am/VPfxpg3Sq9
         wKDhL1QYcE2su+p0xIc1KCRFJMP70buxv2dAy+8L1RWimqxAxSi0sJm4RqmubHR+eZqs
         whLPy4DD1eq4mVsiVRXHuPJXWRCL4kbp5sFwWsbXyPoTE4zezBBM85WWwMzJUzT8Nj/O
         YclIEjcnaaPdf46Vc37SXYF4PMMLSLTGF422LqXkMF+5Nk64L9mo2VuSz1swhpL90VbZ
         3TFS1Bh7t3fgMFme7/b5n72vWNn1JWPv1lg8Sd7TAG2WMKzj46Gqe9uJaqa5t2yTG0rC
         sauQ==
X-Gm-Message-State: ACgBeo1yOpPfJoxzynZr591qzWMsFp5T4Vbrvh1bUcWGJ2uMNklTzNvn
        EiOWKSo9YYge25yf/0pl2rs=
X-Google-Smtp-Source: AA6agR4H/pchOCkEQMosSkiWr6kvpwx2RumBpHHwiIWGcZ82dIil80Qg7/5KoQTOx1zpf/wCsC/U5g==
X-Received: by 2002:a5d:5252:0:b0:225:4b9c:5625 with SMTP id k18-20020a5d5252000000b002254b9c5625mr2416607wrc.272.1661435216177;
        Thu, 25 Aug 2022 06:46:56 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id i26-20020a1c541a000000b003a5de95b105sm5356049wmb.41.2022.08.25.06.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 06:46:55 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal@nsof.io>
Subject: [PATCH ipsec-next,v2 0/3]  xfrm: support collect metadata mode for xfrm interfaces
Date:   Thu, 25 Aug 2022 16:46:33 +0300
Message-Id: <20220825134636.2101222-1-eyal.birger@gmail.com>
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
 net/xfrm/xfrm_interface.c     | 220 +++++++++++++++++++++++++++++++---
 net/xfrm/xfrm_policy.c        |  10 +-
 8 files changed, 263 insertions(+), 28 deletions(-)

----

v2: add "link" property as suggested by Nicolas Dichtel

-- 
2.34.1

