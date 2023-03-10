Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7336B5028
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 19:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjCJSeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 13:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjCJSeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 13:34:01 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD66710FB82;
        Fri, 10 Mar 2023 10:33:52 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id j11so24257667edq.4;
        Fri, 10 Mar 2023 10:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678473230;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v4YWhzr4d8PRw4EcrGRY8V0kzXZI12ifbj8aF4H3gsQ=;
        b=VnqmohHkGXPbUQisFklEEjoB9KGNj9O7cjQREgBjq/OcIL0RWzI1Te2vmVGfyQeiID
         3q5orlLbV5dzWnq1JohtGbfs9jvRBDt++DyCuRAVPU4rWqbJvDDCtYh2+D3CLsRs2kqk
         tyyTXm671InJMekOE26K16P32GeCnEaV/OfFZON0R/IoHZ3kJBpg3LPS4Cb/x9SWkdnb
         GDFHpppHTfIiaPEPWE+370E5pYc3RgqoZZlPKa/2OsAWhW6ys3DbgR3Kae5y1/Jp/auu
         Q7y87Uqvl2zZTZPUAmFtvDYz5OI0v0A3t/3MYDd7bQSZUNmw4ClV2WnFjHAE3lwALLJf
         wQbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678473230;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v4YWhzr4d8PRw4EcrGRY8V0kzXZI12ifbj8aF4H3gsQ=;
        b=ATQjCoNk7/M04L05lcDsr0nCZDi60U3NiRTq5Xi0GuTYqkSumiqj+IjzPjsN/eGL2q
         pqAk9zLQ/ISf9rPV7jif2gpLMCPSwa+Hs8KalhoG6mi+ReuxBx3TVB+odbyk/85hQtYC
         jdX+HFHuxNZNgpsNtmurfZYgll5RwyJTSM2SRNxnBuKB/bHzc2B0OhZJ4nIHxDGV75M+
         GBuGAX29ojiHmi/06kiYaypWtMfOdjdoSnLPQ9hX28a3ldOMf9LAWDdvrh/PfEOcoNzY
         y2DLJoviTwWlauR8uID2UfFReSfbdfOiLlEhcUkXKgqguT+MQCA1Dxz0OHDsmdCRDjcl
         9QVA==
X-Gm-Message-State: AO0yUKXBxDH9nuH80bDFwrarTktWjjh05NdwQoWhAbYR/uxALSgOzao+
        TGiR7dJ7ElJprLxTsapDR8/97+8yCsprLgJ/zMk=
X-Google-Smtp-Source: AK7set8JE39O9HpVmES+lYGle4OYevtgR5FDrJylt6uIHC28vEoghjvMGc+wDKLLjMiED4F6z2bAqoGbhTMvJmsvoug=
X-Received: by 2002:a50:d602:0:b0:4bf:a788:1d68 with SMTP id
 x2-20020a50d602000000b004bfa7881d68mr14826347edi.6.1678473230441; Fri, 10 Mar
 2023 10:33:50 -0800 (PST)
MIME-Version: 1.0
References: <20230303133232.2546004-1-aleksander.lobakin@intel.com> <73b5076c-335b-c746-b227-0edd40435ef5@redhat.com>
In-Reply-To: <73b5076c-335b-c746-b227-0edd40435ef5@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 10 Mar 2023 10:33:39 -0800
Message-ID: <CAADnVQJ-kWG0eL8n5r3zBeXYaXihaqMcNrOP9++QuqsnhYzL_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/3] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI

test_xdp_do_redirect:FAIL:pkt_count_zero unexpected pkt_count_zero:
actual 9936 != expected 2

see CI results.
It's a submitter job to monitor test results.
