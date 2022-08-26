Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51415A2DD6
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242827AbiHZRuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 13:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiHZRux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 13:50:53 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2548432EFE;
        Fri, 26 Aug 2022 10:50:51 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bq11so2619005wrb.12;
        Fri, 26 Aug 2022 10:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :from:to:cc;
        bh=gQun+fnr4OwC+dFcthHSjBIjchxCJQqsAb8pYE77TqM=;
        b=a+SuKsGdQHS3fN/+euhRCovKTIf9FEkwXUZbFhp4Vys/m+nY2ov01WPbwoCWqJYjEj
         TMj7L8waI3wDCxFZ67MsuzHrUT1RdyJKsFqGF470XX9HopnfdQthfQSakQ3fm9tZzQh2
         ySco+/H/lszf/KN4G+sbBBYld4uikcAnchPPCp41YxBxdZlhXG5fcBqIBQV3aSB4RkBh
         Oiu5dFmx+8I3W8OwyRdcwd5hNGkpCEvK5A7Aagv18/YxY1usOsZsnZDM3N9s47G4+uJd
         n2F+/Qe/Wn+32uIPCAiG4bW8ttSYOcH3LqJa/Dz0C+jiNgelgZM/GUiZA22pSz/ZRQ30
         F0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc;
        bh=gQun+fnr4OwC+dFcthHSjBIjchxCJQqsAb8pYE77TqM=;
        b=RSINKfffL82BAIRBstmgM5oqe10Nl0lWaz7NQQ998ppRt5tFtWLXnvBeRFmm41sdT7
         qvUvtl6ZcfGKi3sb6/jrWWIW+nZwM5D0RCBdaJ6Y6Hdtedt6rF38/rCozndINBpVHXW3
         w04e42FBOp27L5VZc/neen835IzYkqQT6CyQnCr0bWfdYBX0m4ADb25R0qMP86KDKiKV
         9dxcrBLRKXbdr7dsRn8eESNY1+oVQ/PCn2MBHbn5noxz0jDrxUpKXwWjgMS32oPkz5TJ
         zoZDw0XZLx7438xZWQs34hwW4XoB4VO1xLXmKcF9ZtYRSPsTxY/henD8L/yItPGhknCq
         zL8g==
X-Gm-Message-State: ACgBeo1aQfk1ObyprA0NvtXddHQmH1WWcmkuUwAP+m6P7NO7/8WJiOB3
        zXubGEPrVrAVi1dwb7OnTP9ZM3b3Ijg=
X-Google-Smtp-Source: AA6agR5qhpJewfDK+WyTB4JEv6GWK1Sfvq6AYjyk/o80Lz1PS7zXO0tGDM2wQ/dK97SVAOtP2a0dpg==
X-Received: by 2002:a05:6000:2c5:b0:225:618e:1708 with SMTP id o5-20020a05600002c500b00225618e1708mr458289wry.510.1661536249663;
        Fri, 26 Aug 2022 10:50:49 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id n6-20020a05600c500600b003a603f96db7sm260691wmr.36.2022.08.26.10.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 10:50:49 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Fri, 26 Aug 2022 19:50:47 +0200
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: memory leaks after running bpf selftests
Message-ID: <YwkH9zTmLRvDHHbP@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
I'm getting memory leaks report after running test_progs,
on latest bpf-next/master, looks networking related

jirka


---
unreferenced object 0xffff888102b816c0 (size 232):
  comm "(ostnamed)", pid 534, jiffies 4294672162 (age 704.879s)
  hex dump (first 32 bytes):
    18 17 3c 19 81 88 ff ff c0 0a b8 02 81 88 ff ff  ..<.............
    00 c0 a6 1c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81c2c45e>] napi_skb_cache_get+0x4e/0x60
    [<ffffffff81c2c532>] __alloc_skb+0x52/0x1c0
    [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
    [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
    [<ffffffff81c4e3e5>] netif_napi_add_weight+0x135/0x280
    [<ffffffff81cbc22a>] gro_cells_init+0x8a/0xe0
    [<ffffffff81ed8960>] ip6_tnl_dev_init+0xe0/0x1b0
    [<ffffffff81c567ea>] register_netdevice+0x19a/0x6b0
    [<ffffffff81c56d1a>] register_netdev+0x1a/0x30
    [<ffffffff81eda4b2>] ip6_tnl_init_net+0x1c2/0x440
    [<ffffffff81c3b678>] ops_init+0x38/0x160
    [<ffffffff81c3c1cf>] setup_net+0x17f/0x340
    [<ffffffff81c3dd7c>] copy_net_ns+0x10c/0x270
    [<ffffffff81181a67>] create_new_namespaces+0x117/0x300
    [<ffffffff811820a5>] unshare_nsproxy_namespaces+0x55/0xb0
    [<ffffffff8114e1bc>] ksys_unshare+0x19c/0x3b0
unreferenced object 0xffff888102b80ac0 (size 232):
  comm "(ostnamed)", pid 534, jiffies 4294672162 (age 704.879s)
  hex dump (first 32 bytes):
    c0 16 b8 02 81 88 ff ff 40 00 b8 02 81 88 ff ff  ........@.......
    00 c0 a6 1c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81c2c45e>] napi_skb_cache_get+0x4e/0x60
    [<ffffffff81c2c532>] __alloc_skb+0x52/0x1c0
    [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
    [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
    [<ffffffff81c4e3e5>] netif_napi_add_weight+0x135/0x280
    [<ffffffff81cbc22a>] gro_cells_init+0x8a/0xe0
    [<ffffffff81ed8960>] ip6_tnl_dev_init+0xe0/0x1b0
    [<ffffffff81c567ea>] register_netdevice+0x19a/0x6b0
    [<ffffffff81c56d1a>] register_netdev+0x1a/0x30
    [<ffffffff81eda4b2>] ip6_tnl_init_net+0x1c2/0x440
    [<ffffffff81c3b678>] ops_init+0x38/0x160
    [<ffffffff81c3c1cf>] setup_net+0x17f/0x340
    [<ffffffff81c3dd7c>] copy_net_ns+0x10c/0x270
    [<ffffffff81181a67>] create_new_namespaces+0x117/0x300
    [<ffffffff811820a5>] unshare_nsproxy_namespaces+0x55/0xb0
    [<ffffffff8114e1bc>] ksys_unshare+0x19c/0x3b0
unreferenced object 0xffff888102b80040 (size 232):
  comm "(ostnamed)", pid 534, jiffies 4294672162 (age 704.879s)
  hex dump (first 32 bytes):
    c0 0a b8 02 81 88 ff ff c0 0d b8 02 81 88 ff ff  ................
    00 c0 a6 1c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81c2c45e>] napi_skb_cache_get+0x4e/0x60
    [<ffffffff81c2c532>] __alloc_skb+0x52/0x1c0
    [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
    [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
    [<ffffffff81c4e3e5>] netif_napi_add_weight+0x135/0x280
    [<ffffffff81cbc22a>] gro_cells_init+0x8a/0xe0
    [<ffffffff81ed8960>] ip6_tnl_dev_init+0xe0/0x1b0
    [<ffffffff81c567ea>] register_netdevice+0x19a/0x6b0
    [<ffffffff81c56d1a>] register_netdev+0x1a/0x30
    [<ffffffff81eda4b2>] ip6_tnl_init_net+0x1c2/0x440
    [<ffffffff81c3b678>] ops_init+0x38/0x160
    [<ffffffff81c3c1cf>] setup_net+0x17f/0x340
    [<ffffffff81c3dd7c>] copy_net_ns+0x10c/0x270
    [<ffffffff81181a67>] create_new_namespaces+0x117/0x300
    [<ffffffff811820a5>] unshare_nsproxy_namespaces+0x55/0xb0
    [<ffffffff8114e1bc>] ksys_unshare+0x19c/0x3b0
unreferenced object 0xffff888102b80dc0 (size 232):
  comm "(ostnamed)", pid 534, jiffies 4294672162 (age 704.893s)
  hex dump (first 32 bytes):
    40 00 b8 02 81 88 ff ff 18 17 3c 19 81 88 ff ff  @.........<.....
    00 c0 a6 1c 81 88 ff ff 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81c2c45e>] napi_skb_cache_get+0x4e/0x60
    [<ffffffff81c2c532>] __alloc_skb+0x52/0x1c0
    [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
    [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
    [<ffffffff81c4e3e5>] netif_napi_add_weight+0x135/0x280
    [<ffffffff81cbc22a>] gro_cells_init+0x8a/0xe0
    [<ffffffff81ed8960>] ip6_tnl_dev_init+0xe0/0x1b0
    [<ffffffff81c567ea>] register_netdevice+0x19a/0x6b0
    [<ffffffff81c56d1a>] register_netdev+0x1a/0x30
    [<ffffffff81eda4b2>] ip6_tnl_init_net+0x1c2/0x440
    [<ffffffff81c3b678>] ops_init+0x38/0x160
    [<ffffffff81c3c1cf>] setup_net+0x17f/0x340
    [<ffffffff81c3dd7c>] copy_net_ns+0x10c/0x270
    [<ffffffff81181a67>] create_new_namespaces+0x117/0x300
    [<ffffffff811820a5>] unshare_nsproxy_namespaces+0x55/0xb0
    [<ffffffff8114e1bc>] ksys_unshare+0x19c/0x3b0
unreferenced object 0xffff88812c3a3400 (size 1024):
  comm "test_progs", pid 686, jiffies 4294713342 (age 663.722s)
  hex dump (first 32 bytes):
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<ffffffff81c2c566>] __alloc_skb+0x86/0x1c0
    [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
    [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
    [<ffffffff81a0a952>] tun_get_user+0x242/0x1250
    [<ffffffff81a0c2c0>] tun_chr_write_iter+0x50/0x90
    [<ffffffff81436faf>] do_iter_readv_writev+0xdf/0x140
    [<ffffffff81438fc4>] do_iter_write+0x84/0x1d0
    [<ffffffff81439205>] vfs_writev+0xc5/0x290
    [<ffffffff8143944f>] do_writev+0x7f/0x160
    [<ffffffff81fbd157>] do_syscall_64+0x37/0x90
    [<ffffffff8200009b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
unreferenced object 0xffff88812c3a4000 (size 1024):
  comm "test_progs", pid 686, jiffies 4294713342 (age 663.722s)
  hex dump (first 32 bytes):
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<ffffffff81c2c566>] __alloc_skb+0x86/0x1c0
    [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
    [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
    [<ffffffff81a0a952>] tun_get_user+0x242/0x1250
    [<ffffffff81a0c2c0>] tun_chr_write_iter+0x50/0x90
    [<ffffffff81436faf>] do_iter_readv_writev+0xdf/0x140
    [<ffffffff81438fc4>] do_iter_write+0x84/0x1d0
    [<ffffffff81439205>] vfs_writev+0xc5/0x290
    [<ffffffff8143944f>] do_writev+0x7f/0x160
    [<ffffffff81fbd157>] do_syscall_64+0x37/0x90
    [<ffffffff8200009b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
unreferenced object 0xffff88812c3a1000 (size 1024):
  comm "test_progs", pid 686, jiffies 4294713342 (age 663.722s)
  hex dump (first 32 bytes):
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<ffffffff81c2c566>] __alloc_skb+0x86/0x1c0
    [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
    [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
    [<ffffffff81a0a952>] tun_get_user+0x242/0x1250
    [<ffffffff81a0c2c0>] tun_chr_write_iter+0x50/0x90
    [<ffffffff81436faf>] do_iter_readv_writev+0xdf/0x140
    [<ffffffff81438fc4>] do_iter_write+0x84/0x1d0
    [<ffffffff81439205>] vfs_writev+0xc5/0x290
    [<ffffffff8143944f>] do_writev+0x7f/0x160
    [<ffffffff81fbd157>] do_syscall_64+0x37/0x90
    [<ffffffff8200009b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
unreferenced object 0xffff88812c3a1c00 (size 1024):
  comm "test_progs", pid 686, jiffies 4294713342 (age 663.741s)
  hex dump (first 32 bytes):
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<ffffffff81c2c566>] __alloc_skb+0x86/0x1c0
    [<ffffffff81c2c6db>] __napi_alloc_skb+0x3b/0xe0
    [<ffffffff81c8af09>] napi_get_frags+0x29/0x50
    [<ffffffff81a0a952>] tun_get_user+0x242/0x1250
    [<ffffffff81a0c2c0>] tun_chr_write_iter+0x50/0x90
    [<ffffffff81436faf>] do_iter_readv_writev+0xdf/0x140
    [<ffffffff81438fc4>] do_iter_write+0x84/0x1d0
    [<ffffffff81439205>] vfs_writev+0xc5/0x290
    [<ffffffff8143944f>] do_writev+0x7f/0x160
    [<ffffffff81fbd157>] do_syscall_64+0x37/0x90
    [<ffffffff8200009b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
