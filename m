Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A67E485994
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 20:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243767AbiAET41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 14:56:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243775AbiAET4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 14:56:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641412581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=AxMpV5DMkdix/JlVcASA2FVvSU0EUcNX5BnwQ2LOhOw=;
        b=Er3EeCrYV7vSUbbkdjOkJy/SKuv6f08+iHpduTPhym3n/VX+Nr1ynLnZQWqCapHiH7890B
        e0IpD5wWJXrNpW8GpH7q1x9084h0v90ENI25oaWiCG1MGWv2Dvj8nE4p7uCSMtGSs2tLJp
        7HIdRtqsdsr2e5vj7Ls2I6vM3T4NBEk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-t5OFiNWYPUW34ipNWibRrQ-1; Wed, 05 Jan 2022 14:56:20 -0500
X-MC-Unique: t5OFiNWYPUW34ipNWibRrQ-1
Received: by mail-wm1-f72.google.com with SMTP id c5-20020a1c3505000000b00345c92c27c6so2308140wma.2
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 11:56:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=AxMpV5DMkdix/JlVcASA2FVvSU0EUcNX5BnwQ2LOhOw=;
        b=RanlNJ0Ej9npWH0gdfFSLMC6ZM17CDaaATHjXb0mTD5IeSEiOBUGPHfjchEoiqKnc1
         45ZLiOvNTCZicGwQvhdo7KQHwITKB1cKQ8Mw1OS4alAQAUWwS5nsvPIGuUwgMQY0mujT
         r5I0gXDTgPF4EV4aGqaM0IkoVVKFTYNsK02lI/kNOeKd8UsDs8zBQW8OdOrfz39xixXd
         fxvD3H++px/6ycPffShXwvOjKY8QmQXpQ1t+ZICnrizob6D9seBxgLu+LKgoRTN3AcFh
         0F4BGCJkIN+f37mrM0fBIuO/u2UFp+U2z9+YKwFriIRD9c8wN1nhG0XM69jEd+wjjA9a
         JXgQ==
X-Gm-Message-State: AOAM532WlfZUIn5rWI8+aNSdhmjiHdiMfLEnIAvh/kPIojHG6ComEjbQ
        Vs6kBcndRDDPYxLK3iIZ6pLeEd/W0vq9fCpHg4D49qWL9NT7uE63rrKziWPlaZ0pMvPJgd4dM60
        ZHIBeBs6U5Z8rUlrq
X-Received: by 2002:a7b:c853:: with SMTP id c19mr3098678wml.2.1641412579149;
        Wed, 05 Jan 2022 11:56:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwO4DKSqq8oUk0o1bDdh9XSrnQXIHCmSOufW1ptcRSrlNGhz+9eYkRLEZzB7ovVc3+FraHs+A==
X-Received: by 2002:a7b:c853:: with SMTP id c19mr3098662wml.2.1641412578945;
        Wed, 05 Jan 2022 11:56:18 -0800 (PST)
Received: from pc-1.home (2a01cb058d24940001d1c23ad2b4ba61.ipv6.abo.wanadoo.fr. [2a01:cb05:8d24:9400:1d1:c23a:d2b4:ba61])
        by smtp.gmail.com with ESMTPSA id l6sm55834219wry.18.2022.01.05.11.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 11:56:18 -0800 (PST)
Date:   Wed, 5 Jan 2022 20:56:16 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Varun Prakash <varun@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH net 0/4] ipv4: Fix accidental RTO_ONLINK flags passed to
 ip_route_output_key_hash()
Message-ID: <cover.1641407336.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPv4 stack generally uses the last bit of ->flowi4_tos as a flag
indicating link scope for route lookups (RTO_ONLINK). Therefore, we
have to be careful when copying a TOS value to ->flowi4_tos. In
particular, the ->tos field of IPv4 packets may have this bit set
because of ECN. Also tunnel keys generally accept any user value for
the tos.

This series fixes several places where ->flowi4_tos was set from
non-sanitised values and the flowi4 structure was later used by
ip_route_output_key_hash().

Note that the IPv4 stack usually clears the RTO_ONLINK bit using
RT_TOS(). However this macro is based on an obsolete interpretation of
the old IPv4 TOS field (RFC 1349) and clears the three high order bits.
Since we don't need to clear these bits and since it doesn't make sense
to clear only one of the ECN bits, this patch series uses INET_ECN_MASK
instead.

All patches were compile tested only.


Guillaume Nault (4):
  xfrm: Don't accidentally set RTO_ONLINK in decode_session4()
  gre: Don't accidentally set RTO_ONLINK in gre_fill_metadata_dst()
  libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()
  mlx5: Don't accidentally set RTO_ONLINK before
    mlx5e_route_lookup_ipv4_get()

 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c   | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 5 +++--
 net/ipv4/ip_gre.c                                   | 5 +++--
 net/xfrm/xfrm_policy.c                              | 3 ++-
 4 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.21.3

