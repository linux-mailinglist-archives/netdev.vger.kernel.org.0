Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA296975B0
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 06:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjBOFIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 00:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjBOFIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 00:08:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8A91F925;
        Tue, 14 Feb 2023 21:08:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A13B619E9;
        Wed, 15 Feb 2023 05:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DDFC433D2;
        Wed, 15 Feb 2023 05:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676437693;
        bh=txQFU+mkGFEDL/QxegrZDVvPijAlVVXT0neyiOBDIEQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pVL/4E/HYpsDCAnkcuYEO4UyDWxgMDlTMaLnfZ2m7+F8yegDt6s6E+tQyu3KC9vNq
         r09iFVa0cMVkTXhRrQUzpcVmiOriXOYqPr3FXMIFW96BasAMlfzsLJDjHXUi8uoWOS
         AwT1X2Cbjv8sLMVn06Lx943lInRHRG136Ix+mXdZ95/5TEGvg0lxFYzoHKLycX6XGq
         39xlRVyr74OjAXtpEYZISo9Jxu4nek2L4OYB/LT99Ccykmvrt5dPq3OsVA634Sx3j0
         xlbtmscj7D1bEHh2mFOZBowrk5dadgA16O7bUATKtj5z36u4aYinHn6jZj6dYhr6pw
         3jOaSdCA4suiA==
Date:   Tue, 14 Feb 2023 21:08:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vfedorenko@novek.ru>,
        Frantisek Krenzelok <fkrenzel@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Apoorv Kothari <apoorvko@amazon.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH net-next v2 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230214210811.448b5ec4@kernel.org>
In-Reply-To: <cover.1676052788.git.sd@queasysnail.net>
References: <cover.1676052788.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 12:17:37 +0100 Sabrina Dubroca wrote:
> Changes in v2
> use reverse xmas tree ordering in tls_set_sw_offload and
> do_tls_setsockopt_conf
> turn the alt_crypto_info into an else if
> selftests: add rekey_fail test
> 
> Vadim suggested simplifying tls_set_sw_offload by copying the new
> crypto_info in the context in do_tls_setsockopt_conf, and then
> detecting the rekey in tls_set_sw_offload based on whether the iv was
> already set, but I don't think we can have a common error path
> (otherwise we'd free the aead etc on rekey failure). I decided instead
> to reorganize tls_set_sw_offload so that the context is unmodified
> until we know the rekey cannot fail. Some fields will be touched
> during the rekey, but they will be set to the same value they had
> before the rekey (prot->rec_seq_size, etc).
> 
> Apoorv suggested to name the struct tls_crypto_info_keys "tls13"
> rather than "tls12". Since we're using the same crypto_info data for
> TLS1.3 as for 1.2, even if the tests only run for TLS1.3, I'd rather
> keep the "tls12" name, in case we end up adding a
> "tls13_crypto_info_aes_gcm_128" type in the future.
> 
> Kuniyuki and Apoorv also suggested preventing rekeys on RX when we
> haven't received a matching KeyUpdate message, but I'd rather let
> userspace handle this and have a symmetric API between TX and RX on
> the kernel side. It's a bit of a foot-gun, but we can't really stop a
> broken userspace from rolling back the rec_seq on an existing
> crypto_info either, and that seems like a worse possible breakage.

And how will we handle re-keying in offload?

>  include/net/tls.h                 |   4 +
>  net/tls/tls.h                     |   3 +-
>  net/tls/tls_device.c              |   2 +-
>  net/tls/tls_main.c                |  37 +++-
>  net/tls/tls_sw.c                  | 189 +++++++++++++----
>  tools/testing/selftests/net/tls.c | 336 +++++++++++++++++++++++++++++-

Documentation please.
