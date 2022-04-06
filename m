Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E744F6BCF
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbiDFU4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbiDFU4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:56:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2143C3375
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 12:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 695E1B82547
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 19:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CE2C385A3;
        Wed,  6 Apr 2022 19:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649272573;
        bh=qXgCC/RuAQKmL5gKlzhzXO/Y6MhOjA0LtN0KMo1IQSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d7mIIuBoGl+8GoHI+sUDDdle0jex7dsxEqx9nsRP/sJM1wlqYQw8lLcFw8LrjFSp5
         QDURL0OBrOD663Jsah7TPWQ5nEP/4ye3JzW5CmpFLsA/jZKYaJk8lMYjwf8JrcFYEP
         502o/ZGMl4M0N4lMWY/oY+776xkNA8ViX2AXA3eVjqFlLVw56ChqkgSLOoYxLiAseQ
         liIAkATqYL31KryedcX8BDdsDCL8rwfv86I5/sTInNM5+BnP8e0/Vu7MN5RtJT6op2
         lHfVXtTVdytSwMqZyyBVjalTUj7Wo2lazfafrCyhX0H/bmYOQ0llXQR/YyPFfDshXr
         lCPyLmHCfFbeQ==
Date:   Wed, 6 Apr 2022 12:16:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next RESEND v2] net: core: use shared sysctl macro
Message-ID: <20220406121611.1791499d@kernel.org>
In-Reply-To: <Yk29yO53lSigIbml@bombadil.infradead.org>
References: <20220406124208.3485-1-xiangxia.m.yue@gmail.com>
        <Yk29yO53lSigIbml@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Apr 2022 09:20:24 -0700 Luis Chamberlain wrote:
> On Wed, Apr 06, 2022 at 08:42:08PM +0800, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > 
> > This patch introdues the SYSCTL_THREE, and replace the
> > two, three and long_one to SYSCTL_XXX accordingly.
> > 
> >  KUnit:
> >  [23:03:58] ================ sysctl_test (10 subtests) =================
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_null_tbl_data
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_maxlen_unset
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_len_is_zero
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_table_read_but_position_set
> >  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_positive
> >  [23:03:58] [PASSED] sysctl_test_dointvec_read_happy_single_negative
> >  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_positive
> >  [23:03:58] [PASSED] sysctl_test_dointvec_write_happy_single_negative
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_less_int_min
> >  [23:03:58] [PASSED] sysctl_test_api_dointvec_write_single_greater_int_max
> >  [23:03:58] =================== [PASSED] sysctl_test ===================
> > 
> >  ./run_kselftest.sh -c sysctl
> >  ...
> >  # Running test: sysctl_test_0006 - run #49
> >  # Checking bitmap handler... ok
> >  # Wed Mar 16 14:58:41 UTC 2022
> >  # Running test: sysctl_test_0007 - run #0
> >  # Boot param test only possible sysctl_test is built-in, not module:
> >  # CONFIG_TEST_SYSCTL=m
> >  ok 1 selftests: sysctl: sysctl.sh
>
> I can take this through sysctl-next [0] if folks are OK with that. There are
> quite a bit of changes already queued there for sysctl.
> 
> Jakub?
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=sysctl-next

sysctl-next makes a lot of sense, but I'm worried about conflicts.
Would you be able to spin up a stable branch based on -rc1 so we
can pull it into net-next as well?

Let me take a look at the patch as well...
