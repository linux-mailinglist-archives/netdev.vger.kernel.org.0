Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2636C3DB0
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 23:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCUWVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 18:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCUWVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 18:21:44 -0400
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39CF303EB;
        Tue, 21 Mar 2023 15:21:43 -0700 (PDT)
Received: by mail-qv1-f52.google.com with SMTP id cu4so10840572qvb.3;
        Tue, 21 Mar 2023 15:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679437303;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+kJCy4U1uknKtEGQeAd8JdsA0nzw/u7GM5Mbv4jKXYw=;
        b=5UuWk3IqQUOq+u9dOgrN1fdVf9np2x4dqw2iBpEW2MLF8RWwvo0uvCWcw/yldoNLoT
         HFVTSEGOWyAYD5f89RzxU2aGJscm6X1tkpUmNoKOik8nTLmxOeodZKpvljzyPIhLVlIN
         t1nAwm3HUP/tvHBhYfaq1DF5grlxbBWLvwbHtMf46yNNSp+b2z0F/Y92Tjs9XUMaoOeV
         tWS9anz+SwQXOE3zRbcOiayuhNLhwMh7s+bkF74NLJjENWI6zg0B2EzExAIlcOlyIsoN
         HJwv9GURPRHB/db6IZXWKK1NpjxC1g45ykDBjU4JgrUDPuVf61mnjh1H41DGhcIgC7WI
         gFjA==
X-Gm-Message-State: AO0yUKU/5W/38VbfrMhMWUbVIkuKwri8E73itdDpiU4Hnlcm0Y2cuhAR
        7gif+323+pjvSk6zsc+HXdQ=
X-Google-Smtp-Source: AK7set8KctXxGCHenWpkn1YTSJ9ge7v8PxjdL+WvW1Jgig9jOy0w6P6tFsPzMfMJZmIGGqsj9H/cXw==
X-Received: by 2002:a05:6214:27c7:b0:5cc:277c:b4e with SMTP id ge7-20020a05621427c700b005cc277c0b4emr2009365qvb.39.1679437302656;
        Tue, 21 Mar 2023 15:21:42 -0700 (PDT)
Received: from maniforge ([2620:10d:c091:400::5:be69])
        by smtp.gmail.com with ESMTPSA id t2-20020a374602000000b00746ac14e29asm86927qka.5.2023.03.21.15.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 15:21:42 -0700 (PDT)
Date:   Tue, 21 Mar 2023 17:21:39 -0500
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 2/4] bpf: Teach the verifier to recognize
 rdonly_mem as not null.
Message-ID: <20230321222139.GB239208@maniforge>
References: <20230321203854.3035-1-alexei.starovoitov@gmail.com>
 <20230321203854.3035-3-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321203854.3035-3-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=0.5 required=5.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 01:38:52PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Teach the verifier to recognize PTR_TO_MEM | MEM_RDONLY as not NULL
> otherwise if (!bpf_ksym_exists(known_kfunc)) doesn't go through
> dead code elimination.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: David Vernet <void@manifault.com>
