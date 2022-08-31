Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC435A7D03
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiHaMOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiHaMN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7188D2EBC;
        Wed, 31 Aug 2022 05:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE1A618DC;
        Wed, 31 Aug 2022 12:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E296C433D6;
        Wed, 31 Aug 2022 12:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661948035;
        bh=mCsUJD5LOfeuiHvACicA+nO9wvGQ9ZtmcAbbma6MWno=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=M48LuQOAc92LkpXkEtP6VCZrJZo6LCvB8UACTB/P6ipjYGlosID4fBmzPGr5O1Pd7
         QSKmYklKtlZQzLjKmNVtiz/8p35FIy1xWgiJA6a7wNQ8ValGjhfe82yed5r4vogQYT
         JYNsXtdWt/ImpjWgwA1iPOzUC38S3AcLiLkBbSR2bI12oufz89Cfz5Bd0BOylhQN4A
         aydHX3kdJm2vYrCfNrc4h70z073rnjidOePquVCrn7wIG7iF/gGXvzedmw2WlvhyQt
         Mr/uhFh5ev2bHyw+I1Ka/QpjG/tLxSgQDBmQAuYwHDhnEOuZ3kH/Iw7YSVtsQQNLga
         6I76LiP2fFvRw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3DAB9588AEC; Wed, 31 Aug 2022 14:13:53 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
In-Reply-To: <20220831101617.22329-1-fw@strlen.de>
References: <20220831101617.22329-1-fw@strlen.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 31 Aug 2022 14:13:53 +0200
Message-ID: <87v8q84nlq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> This expression is a native replacement for xtables 'bpf' match "pinned" mode.
> Userspace needs to pass a file descriptor referencing the program (of socket
> filter type).
> Userspace should also pass the original pathname for that fd so userspace can
> print the original filename again.
>
> Tag and program id are dumped to userspace on 'list' to allow to see which
> program is in use in case the filename isn't available/present.

It seems a bit odd to include the file path in the kernel as well. For
one thing, the same object can be pinned multiple times in different
paths (even in different mount namespaces), and there's also nothing
preventing a different program to have been substituted by the pinned
one by the time the value is echoed back.

Also, there's nothing checking that the path attribute actually contains
a path, so it's really just an arbitrary label that the kernel promises
to echo back. But doesn't NFT already have a per-rule comment feature,
so why add another specifically for BPF? Instead we could just teach the
userspace utility to extract metadata from the BPF program (based on the
ID) like bpftool does. This would include the program name, BTW, so it
does have a semantic identifier.

> cbpf bytecode isn't supported.
>
> No new Kconfig option is added: Its included if BPF_SYSCALL is enabled.
>
> Proposed nft userspace syntax is:
>
> add rule ... ebpf pinned "/sys/fs/bpf/myprog"

Any plan to also teach the nft binary to load a BPF program from an ELF
file (instead of relying on pinning)?

-Toke
