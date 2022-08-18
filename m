Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2FA59897E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345189AbiHRQ72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345181AbiHRQ7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:59:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108983AB24
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660841961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZlTKI8rs1NnVLrkDzcJ8S1M2o6u4KNDE+orUNleUFbY=;
        b=SQ314mT7dVQsPQ3IyQVcs9kzhBeupYqapBR/dCq7RLW4pRIse3XZvchost/fxusomqOX6+
        a0tnM7Mky6HCktpZNk7bP2PP4nzgr7exnxlRU95MVZskTPqePMkjQDn4BhKhkcUkBOvoxt
        LmvNRcHDrXI/agJtqiRVeI3ufDHynK0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-316-evpCiP_KPCiii8PLyRoV9g-1; Thu, 18 Aug 2022 12:59:17 -0400
X-MC-Unique: evpCiP_KPCiii8PLyRoV9g-1
Received: by mail-ed1-f71.google.com with SMTP id g8-20020a056402424800b0043e81c582a4so1273735edb.17
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 09:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ZlTKI8rs1NnVLrkDzcJ8S1M2o6u4KNDE+orUNleUFbY=;
        b=VuR+Nq2Kl9fxQMmOOXXmG6lhhT3w3+pHaQ116rht7x/KDkRuryiHGSRWQNFjuVguDV
         J1rcrJAa4VWityq7mXPA4ZhyCoXONtxqbvDTw8NVoC5FgCcxjZEjjRiivIHiAF0EYBXy
         H6gjnkbICaHfst19HAE+4yv+7SYV36xELQ91g2qdjp7alhCyspLSfidMqNMl+sq8q4um
         uTiB01AkyaLu2Obgf1qmqyR9+VCeX0Qgy/t00dAn+vmb46ih/nOs+BjesQR52LCV+Wci
         OpfpFEsLOhw2k2hWNiwHxLv+c8g5cwdTLMwKFvoznX4AN5th3XG1L2UzWQyqBJfSiPfT
         4Q0w==
X-Gm-Message-State: ACgBeo1wTU81HHohxgUzZCsca55NUk0ztXJRcYRlmhuN+zty/SG0DPB/
        xxDz6NuRAfqh0rbogXY0Wfh4MEyE3W45fQqPA1rl1oGLR3B07iLFqwdnqMaFFmclkOh7HWAfqBh
        PiWuMOyC59TDtVV1b
X-Received: by 2002:a17:907:7ea8:b0:731:4fa1:d034 with SMTP id qb40-20020a1709077ea800b007314fa1d034mr2421957ejc.758.1660841952606;
        Thu, 18 Aug 2022 09:59:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7amDBe+GaQgxSIh9KPRUEy0hkGeT3hH11PgkDlFhoM2Pt4/yq/b+5z5dxnfP/+Nxuh1ldxlQ==
X-Received: by 2002:a17:907:7ea8:b0:731:4fa1:d034 with SMTP id qb40-20020a1709077ea800b007314fa1d034mr2421863ejc.758.1660841950337;
        Thu, 18 Aug 2022 09:59:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d23-20020a056402145700b00445e930e20esm1431180edx.64.2022.08.18.09.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:59:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E108755FA95; Thu, 18 Aug 2022 18:59:08 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next 0/3] A couple of small refactorings of BPF program call sites
Date:   Thu, 18 Aug 2022 18:59:02 +0200
Message-Id: <20220818165906.64450-1-toke@redhat.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav suggested[0] that these small refactorings could be split out from the
XDP queueing RFC series and merged separately. The first change is a small
repacking of struct softnet_data, the others change the BPF call sites to
support full 64-bit values as arguments to bpf_redirect_map() and as the return
value of a BPF program, relying on the fact that BPF registers are always 64-bit
wide to maintain backwards compatibility.

Please see the individual patches for details.

[0] https://lore.kernel.org/r/CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com

Kumar Kartikeya Dwivedi (1):
  bpf: Use 64-bit return value for bpf_prog_run

Toke Høiland-Jørgensen (2):
  dev: Move received_rps counter next to RPS members in softnet data
  bpf: Expand map key argument of bpf_redirect_map to u64

 include/linux/bpf-cgroup.h | 12 +++++-----
 include/linux/bpf.h        | 16 ++++++-------
 include/linux/filter.h     | 46 +++++++++++++++++++-------------------
 include/linux/netdevice.h  |  2 +-
 include/uapi/linux/bpf.h   |  2 +-
 kernel/bpf/cgroup.c        | 12 +++++-----
 kernel/bpf/core.c          | 14 ++++++------
 kernel/bpf/cpumap.c        |  4 ++--
 kernel/bpf/devmap.c        |  4 ++--
 kernel/bpf/offload.c       |  4 ++--
 kernel/bpf/verifier.c      |  2 +-
 net/bpf/test_run.c         | 21 +++++++++--------
 net/core/filter.c          |  4 ++--
 net/packet/af_packet.c     |  7 ++++--
 net/xdp/xskmap.c           |  4 ++--
 15 files changed, 80 insertions(+), 74 deletions(-)

-- 
2.37.2

