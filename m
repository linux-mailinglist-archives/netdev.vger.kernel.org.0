Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F89859EA31
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbiHWRt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiHWRsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:48:37 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2619320A;
        Tue, 23 Aug 2022 08:46:12 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n4so17477748wrp.10;
        Tue, 23 Aug 2022 08:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=hBiwcGRXqln11QfGYufINfQOBiIgammsSohjeL36NEU=;
        b=ZampnIWR6UsLnqmKLNv6oL6VqYmr0XhutGzoCJW/t3yvjTmUGiKJRjc4pcnCbtsqX0
         GHcJy5w0jQzKQtwuRdumGg8xF1zqT5V7SOALlBRsV4zG2ofbaP2rtPwIPYHg1AcNcTcT
         lqFx7+Io69H/cXgM8KIEc9Y4K2VJSUtuhxB2tmhAOJmlMBOxjJ3ZBg6z5BL6Ilnpl5nC
         p2GcUdAmLuHYrTIfRKBcJVNHZvQ88LQyeRwjn93ZPGgQKcQzsvCQZKIMqn6Xch8c33Ll
         dwmCzgLWfRI6s0Hn4S1Jr7RbB1r3c1RhnJbx2U7UPuPpxXme2IXAENf3ZI4bW/+/yR+i
         yDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=hBiwcGRXqln11QfGYufINfQOBiIgammsSohjeL36NEU=;
        b=xlA6LM5w9B4mWs74nkSnHPs7nlxZQovBUSfW0ejxV9qjICyroB7Vy4JrwwJSvoZx86
         dbQPvx7BUQEWkkO2Ni1fu15tZGXFn5VQm6Nba7SZUl3F7wSR99T5+Ay/D/+hQ1doy7mZ
         6jzz3obwKRtpcCZFKCc0r9XMVlZi4U2Rr53Eq/DmZhIK8pK/36000eAJCjj/5M5grDSq
         jYe12d3flIELBrVJbfhGiJDjs5uH6vfRF3uhE7PU2Hi4p224il5/4WJm9HwOWjMQwgQn
         V/GdYBs7ujELxJ3j3HTz6/se2fvaASQe95zJOk+rGk9AfHaXn9AWa5BLNz81coKuoA6Y
         gfHw==
X-Gm-Message-State: ACgBeo2b7OqEJj3giNiNONEYGG/2XzX4LNRKblTPkmWqobO2TWnCHRLR
        SBAydhc93ZP0GYvZDVzF9FM=
X-Google-Smtp-Source: AA6agR44AP4T1U4iJOhWyJidryBXtv9L85NKXM3yA66Za2irIBdlYaYXg54tHr5/b99tGbN1wp9jCw==
X-Received: by 2002:a5d:4752:0:b0:225:1fb1:862f with SMTP id o18-20020a5d4752000000b002251fb1862fmr13866653wrs.458.1661269571154;
        Tue, 23 Aug 2022 08:46:11 -0700 (PDT)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id i26-20020a1c541a000000b003a64f684704sm11341211wmb.40.2022.08.23.08.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 08:46:10 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, pablo@netfilter.org,
        contact@proelbtn.com, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, devel@linux-ipsec.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec-next 0/3] xfrm: support collect metadata mode for xfrm interfaces
Date:   Tue, 23 Aug 2022 18:45:54 +0300
Message-Id: <20220823154557.1400380-1-eyal.birger@gmail.com>
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
the ability to selectively steer traffic to each one.

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

 include/net/dst_metadata.h    |  25 +++++
 include/net/xfrm.h            |  11 +-
 include/uapi/linux/if_link.h  |   1 +
 include/uapi/linux/lwtunnel.h |   9 ++
 net/core/lwtunnel.c           |   1 +
 net/xfrm/xfrm_input.c         |   7 +-
 net/xfrm/xfrm_interface.c     | 203 ++++++++++++++++++++++++++++++----
 net/xfrm/xfrm_policy.c        |  10 +-
 8 files changed, 239 insertions(+), 28 deletions(-)

-- 
2.34.1

