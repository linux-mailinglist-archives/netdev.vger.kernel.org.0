Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E053FDF6E
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244608AbhIAQKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241626AbhIAQKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 12:10:52 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02C1C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 09:09:55 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g22so4516337edy.12
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 09:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GuGPMy9wyhIVf9/M3dZMDi6jnPBAi1kugfgCYTmCxqg=;
        b=CM78f/PTgP4ZKbukFuCjEabvuwnBjQo3GpzWFfkOCWh3w238Bon2mVby4eBHC/bF/I
         PrU1fDWukyKuvHP0JSXSRvKvg+JQdfjyJSxKfVebJcyUHZidtBlKvNn6sycI8TgmSHqO
         mGCz/MNB5krwHNWiw0Gruaxc2AOLnWFk9VhNOgf8RfHbEiHY4URNq4GNwZpECpGC3Rk6
         ZpunKGPbGhyJFy7x3G2Z2K1XxqPGyppOTG8bGSZ4hbx6zRQPppBUtK78Y7v6Nk72Knpn
         mos5W/0rprb9tW1cIbo3udFzXi+A+/5ooohB25AfN7fx0JI7EQfLRXchroKTIAdexKJA
         9n6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GuGPMy9wyhIVf9/M3dZMDi6jnPBAi1kugfgCYTmCxqg=;
        b=D0dLd5+r84oEAP5/wXKeyhpN0FJK9On55mXN+Pfz947HEpDUR5FlkXpNzZW1Vo9X6S
         bRrQLfXADasgfNQ+hlLMDe16qjDlEKdcoF6VEpZmUqRLdh9mOR8Q6O6LTQkZlPqdKik/
         WRQLn/wktXoxqV48BBah6cgBiDIk+eee0GRsWmRF2J+FfB66v1+4mSw2pfub5BhL9qZt
         zcmf4oCp3IRAwKVTKW5yU3COUJN5++hRPy99s8XlrbrMXyox0jKhy1KocjSQLQOng7NQ
         oyalUt9L1NhjYt/2UGOcN91ZiCvuBaok9GecVqClcmSaeRl8e3DdxZov8B+buysBxmu9
         sr8Q==
X-Gm-Message-State: AOAM531/hic+qPyiqeq4i5B2fmUzuYAvkEr9TGgLrBIo86ihtS2CwOke
        sZ1Rq1dnjgZlurEJUZu+PGY7BQ==
X-Google-Smtp-Source: ABdhPJxKnOr7FugQb1UAr/dFaVLX7+A8XwY/3oSf5fgZqFfHxFEaEs8IGHYSuM+A0vSqBtHjEY50+w==
X-Received: by 2002:aa7:d710:: with SMTP id t16mr392766edq.42.1630512594199;
        Wed, 01 Sep 2021 09:09:54 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (94.105.103.227.dyn.edpnet.net. [94.105.103.227])
        by smtp.gmail.com with ESMTPSA id n10sm77706ejk.86.2021.09.01.09.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:09:53 -0700 (PDT)
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
References: <20210831171926.80920-1-mathew.j.martineau@linux.intel.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net v2 0/2] mptcp: Prevent tcp_push() crash and selftest
 temp file buildup
Message-ID: <b9fa6f74-e0b6-0f61-fc5a-954137db1314@tessares.net>
Date:   Wed, 1 Sep 2021 18:09:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210831171926.80920-1-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

On 31/08/2021 19:19, Mat Martineau wrote:
> These are two fixes for the net tree, addressing separate issues.
> 
> Patch 1 addresses a divide-by-zero crash seen in syzkaller and also
> reported by a user on the netdev list. This changes MPTCP code so
> tcp_push() cannot be called with an invalid (0) mss_now value.
> 
> Patch 2 fixes a selftest temp file cleanup issue that consumes excessive
> disk space when running repeated tests.
> 
> 
> v2: Make suggested changes to lockdep check and indentation in patch 1

We recently noticed this series has been marked as "Not Applicable" on
Patchwork.

It looks like we can apply these patches:

  $ git checkout netdev-net/master # 780aa1209f88
  $ git-pw series apply 539963
  Applying: mptcp: fix possible divide by zero
  Using index info to reconstruct a base tree...
  M       net/mptcp/protocol.c

  Falling back to patching base and 3-way merge...
  Auto-merging net/mptcp/protocol.c

  Applying: selftests: mptcp: clean tmp files in simult_flows

Git auto-resolves conflicts. Is it why it is considered as "Not
Applicable" or did we miss something else?

Do we just need to resend these patches after a rebase?

Thank you for maintaining net!

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
