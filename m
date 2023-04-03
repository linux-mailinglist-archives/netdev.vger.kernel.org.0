Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F506D44BF
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 14:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjDCMqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 08:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjDCMp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 08:45:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5893F6EB2
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 05:45:56 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eg48so116734372edb.13
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 05:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680525954;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=riaahXQBertKmx+xq8cDyjwCTBDh/mDGE8BYFdxvDOM=;
        b=AeSvW6k+w78JQQFr9P84dSFQCVc5yWUTGPRgEnDHdFwlVw9CYaiBmcDl62NmVB2m+P
         q+wT/xqMJAOOqGvy4SL9Dnl6o8rkx79ToJ8CGJwSjyLEDHJwnID7BQmCiq3QOUFdDqu2
         dO8LrYKTbRXrjZiyz6EIV2UCzBJDpu3oCb9pA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680525954;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=riaahXQBertKmx+xq8cDyjwCTBDh/mDGE8BYFdxvDOM=;
        b=5ry8qzApWASGTMB+GRDslYMbL2R7q24jjznsbAIAjJSWgvnqB6gY3VcN0OF9QeMlCw
         bBY/o0TEY7pe6LFeMSnS5wn04ZwcfWsNY0QcSCO5skNHb48GFMzCyR/4Xgb7o/O+hd6g
         vXlUPim1UgfW45sCVZowTDYit9NlJC5O1zlYDlxoi2d+8JpgEToWoCyw99wYKyyvAn4W
         QJtLEcgdaI0AfQHqjRuO/7wiIUFZJEPSoyD+R/yx7lyyu8mrzlDwwlwj3ybkQBDWSENu
         ZCaSz+stpAh/J0RfkpvMEQzKMu1+wl+6saPDF7ABH43e8quaeIUtWWulKiRPrh8srq/f
         OBsw==
X-Gm-Message-State: AAQBX9f1WVa4LDahwWWlJ/ovMT2iiP/x5FevIsn7mivkEA3FuTRdmcWq
        aIitEkBn6UcLuYYv2QBFxqRubo6DaCC/cTmbPwQjhQ==
X-Google-Smtp-Source: AKy350aP1ukG9/ndrpQD+GGShI9OQ5v16FM6kUzhb3kdhVgjodsHmgZPsLsStm33czUEzkZ7t/sTNPgmYme8DnWkACI=
X-Received: by 2002:a50:cd47:0:b0:4fc:532e:215d with SMTP id
 d7-20020a50cd47000000b004fc532e215dmr18039003edj.6.1680525954661; Mon, 03 Apr
 2023 05:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com>
 <20230329180502.1884307-7-kal.conley@dectris.com> <CAJ8uoz0a3gJgWDxP0zPLsiWzUZHmGqRbrumdRq2Gv1HdVm4ObQ@mail.gmail.com>
In-Reply-To: <CAJ8uoz0a3gJgWDxP0zPLsiWzUZHmGqRbrumdRq2Gv1HdVm4ObQ@mail.gmail.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Mon, 3 Apr 2023 14:50:34 +0200
Message-ID: <CAHApi-mCm1hWyc1jfB3isPqWqaJUuqn7vN1hfSgPb741ngJK9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 06/10] xsk: Add check for unaligned
 descriptors that overrun UMEM
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Let me just check that I understand the conditions under which this
> occurs. When selecting unaligned mode, there is no check that the size
> is divisible by the chunk_size as is the case in aligned mode. So we
> can register a umem that is for example 15 4K pages plus 100 bytes and
> in this case the second to last page will be marked as contiguous
> (with the CONTIG_MASK) and a packet of length 300 starting at 15*4K -
> 100 will be marked as valid even though it extends 100 bytes outside
> the umem which ends at 15*4K + 100. Did I get this correctly? If so,
> some more color in the commit message would be highly appreciated.

Yes. You don't even need to cross the page. For example, if you have a
packet length of 300 _within_ the final page then it could go past the
end of the umem. In this case, the CONTIG_MASK would not even be
looked at. The explanation is in the next commit message with the
test. I will improve the commit message here though.
