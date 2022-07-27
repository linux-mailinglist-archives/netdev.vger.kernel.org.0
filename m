Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0987D582FCA
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 19:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242012AbiG0RaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242224AbiG0R25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:28:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B831F7F53B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:47:33 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 196-20020a6301cd000000b0041b0f053fd1so3416925pgb.6
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 09:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OnWRNaHrGqPJJEV9KnSzhKrkN7MNE4sHya6nsNPvuHM=;
        b=U9gMVUiTWQ++4VoX0PfT/VwR2wcR1niVUjVsWMqRWcRGvGSkV34had4xJKOGcA4EoD
         bX28+fNFMAy9EkbBhZfV4y/HDp/bLYEJj8pfEZdSsZ9yNP/dOoxx1M8kCQ3iZjV/6FAJ
         Evu2TOMJKIbLkuesq+YQC+WGD6XrauCqC8g/tHyIAdTB1/AK0UhQQ1cFG94JtF8Q2v5C
         tWWhqZsg/EW0Yg3Hbquk3bnL8KJ7gtbo5B1/pdlrqKKn3DWR3mO2CkiyNylQwtVW+NZ9
         U6qo9H8j/1Lq4KHcrF35vvTngdEIB2XE8ZlQB+eYWIRlzvm2hkGXxh0oRne7e6zGp/Gs
         QfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OnWRNaHrGqPJJEV9KnSzhKrkN7MNE4sHya6nsNPvuHM=;
        b=qslkdLB+s7qxzi6XgdyIvTzDfKBR9kIajw1nRtJWrSHJPS/XsvZYvf9omE9lwMVy0r
         8dqfNZqf8L9SU0DXopFWBdVeDkCNGNq///QRh/Cp76C54lQ+mBydFVmR3GbG4NYl1vMs
         qJOXvdTu/TQJDkMcuuV0bESJYytbHIq5Xf4B6a+d5y6+k82r+FcNxNLyk+RSm7wwRgYp
         SQeRKQ7L41fnq2ztZ+TMM6eIvFwdlHxUPPXFRrH4wFYT6LKtJlXvmHerfg3hm7iL2RRy
         KxNCuwa+44GXIiMk/YvC5Qkdd2bpC4GNXWfJHUrCkLLqkJ4XE0hNlqkDLjHKMsaEc3qt
         qNeg==
X-Gm-Message-State: AJIora95VNEzgzapp2wZ2rTKJ9kRZ15F8XAHqV7kHB62o8gPvQ+u59Lq
        SQ1xomlzKFqyTJMnKnnRqwzPguo=
X-Google-Smtp-Source: AGRyM1uytZyQgfv5KYDPrPMdtfmiRVb7kacPaIe8VF8v8YRN7gY2kBaXjIY8loAT6ufaEZY5oTELROg=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:d642:b0:16b:d5b7:1117 with SMTP id
 y2-20020a170902d64200b0016bd5b71117mr21096618plh.167.1658940446949; Wed, 27
 Jul 2022 09:47:26 -0700 (PDT)
Date:   Wed, 27 Jul 2022 09:47:25 -0700
In-Reply-To: <20220727060909.2371812-1-kafai@fb.com>
Message-Id: <YuFsHaTIu7dTzotG@google.com>
Mime-Version: 1.0
References: <20220727060856.2370358-1-kafai@fb.com> <20220727060909.2371812-1-kafai@fb.com>
Subject: Re: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/26, Martin KaFai Lau wrote:
> Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
> the sock_setsockopt().  The number of supported options are
> increasing ever and so as the duplicated codes.

> One issue in reusing sock_setsockopt() is that the bpf prog
> has already acquired the sk lock.  sockptr_t is useful to handle this.
> sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
> memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
> has already been ensured by the bpf prog.

Why not explicitly call it is_locked/is_unlocked? I'm assuming, at some  
point,
we can have code paths in bpf where the socket has been already locked by
the stack?
