Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B155B52B7FC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiERKoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 06:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbiERKoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 06:44:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7A14EDD9;
        Wed, 18 May 2022 03:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC0E461840;
        Wed, 18 May 2022 10:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B28EC34100;
        Wed, 18 May 2022 10:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652870650;
        bh=PLLiBbLga9wd+holCXxY7eLtpF52hoa0jep3rUn4tDc=;
        h=From:To:Cc:Subject:Date:From;
        b=f5/PBRxd3e+FPRdhvmsOAQ1ROfeY5af4bMGzyDL7UpVjQk5zDAgF28P9Wgt2hbnEq
         jYTarpJL9oPuEV2360XpSrUpw/yHORQPlOcHuasMNCw6J2bcrzj+8e+cg7KXQWb5HU
         fhavpl3fBfFRVhHXEQyGSrda7eTwY9phUnS4JM7yXKJnO3i8Pupprxk0rXcW1/T893
         oM/SvKPRIlf5E6E2iAfNb2+hQRzkIFOhmEFPEWyS3OvuLmA4VQZKa5yEhP9wXE7mjm
         +yfa86GlEedOKyihJnMlp1nSxLpdzZ6gVVcQvftdxypGf9maq3ibLVqeMQTYLiWSA2
         ZOuZ/LDjosqyw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
Subject: [PATCH v3 bpf-next 0/5] net: netfilter: add kfunc helper to update ct timeout
Date:   Wed, 18 May 2022 12:43:33 +0200
Message-Id: <cover.1652870182.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v2:
- add bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc helpers
- remove conntrack dependency from selftests
- add support for forcing kfunc args to be referenced and related selftests

Changes since v1:
- add bpf_ct_refresh_timeout kfunc selftest

Kumar Kartikeya Dwivedi (2):
  bpf: Add support for forcing kfunc args to be referenced
  selftests/bpf: Add verifier selftests for forced kfunc ref args

Lorenzo Bianconi (3):
  net: netfilter: add kfunc helper to update ct timeout
  net: netfilter: add kfunc helper to add a new ct entry
  selftests/bpf: add selftest for bpf_xdp_ct_add and
    bpf_ct_refresh_timeout kfunc

 include/net/netfilter/nf_conntrack.h          |   1 +
 kernel/bpf/btf.c                              |  40 ++-
 net/bpf/test_run.c                            |   5 +
 net/netfilter/nf_conntrack_bpf.c              | 232 ++++++++++++++++--
 net/netfilter/nf_conntrack_core.c             |  21 +-
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |   4 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  72 +++++-
 tools/testing/selftests/bpf/verifier/calls.c  |  53 ++++
 8 files changed, 375 insertions(+), 53 deletions(-)

-- 
2.35.3

