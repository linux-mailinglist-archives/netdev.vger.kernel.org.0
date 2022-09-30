Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5CF5F060F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiI3HxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiI3HxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:53:15 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2878200B1D;
        Fri, 30 Sep 2022 00:52:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso8247989pjf.5;
        Fri, 30 Sep 2022 00:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=1dicDZVs2og9wpZnuGmUeWA3OMn81u41jmvb1DDrbQM=;
        b=R+sNVGhGaPXOZ6ve1YguEPh22Z1CMARWJioSSXv8nPNlKFPwWRN7QvYcedTJ+Rr6ly
         jZVKroNrTSGKPpeMq6O77rw8P9vBhKZx6qjbOaQ/RlxLbZmLpG/pNnF+9EOwWQVzEqVP
         XkvDTlpiKK/x5E//vX9fZvn4BTT/iEHCDnlMKaBjBxb5VCFmJxFjN0/E9SHdnZOamL2I
         cci6MA+qhfUAJsMqD+Iuuhiu9JBUagCC/AEk4mcF3JuMlJ86X5bDklDSEf5mrpAhgPNu
         eCWRGl2K6kyGUyKnD2Qt1MBhPzTL7aMsM+23H6kAD8h2Ut5h+1q9jnFonK7Z+KITGAT+
         rf8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=1dicDZVs2og9wpZnuGmUeWA3OMn81u41jmvb1DDrbQM=;
        b=IJL+Ix+wie5vjOTOl+2Mdr7aTxSNXU7LKxLGZ0v3N02NrkJK1EkZgtQwzRiAxSFfU5
         jNy8SO/4y9y4ey0ED1otZiYZp/WPuV9Tql59np5DfrC4lrAgVUeuBjJs1wQVWfJzxjQj
         NX0O6qQ3zzTjPode28+nA0JvaNVec3EahgUtYOUU0Li1b6hvFPujMoOeZBnyo8B18w2M
         /LTy9OyIVxas39zWiGMeJIWjvhYjSBtT7M7avvTMuxw/nbVNYnUtAm1OKYCgIHuenpHH
         3KjEku2GF+QyV3bFiT7BraTC5HeV0C90lqGx2Ky9PEHhPJqarwKbWeQpUYk+D7l1HPUp
         TqnA==
X-Gm-Message-State: ACrzQf2ClmEYthIfCOWon5o3LIhur0+lleSaXno1F8arCEGuq7Z/ACHd
        R9/wamA0z3dBEkmedRGiEgIWIS6ltQcQWfUiW3g=
X-Google-Smtp-Source: AMsMyM5gHXhwJO1WyitXvGrffDWPS1UK3EXbyG/fGBewUyAihG481qavH5QU0YdvJyOzFwEO9OUTam9AJg+VUmL4+2E=
X-Received: by 2002:a17:90b:19ce:b0:203:182d:2c77 with SMTP id
 nm14-20020a17090b19ce00b00203182d2c77mr21035644pjb.45.1664524363164; Fri, 30
 Sep 2022 00:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220929090133.7869-1-magnus.karlsson@gmail.com>
 <YzV28OlK+pwlm/B/@boxer> <9d828483-21d0-18da-0870-babcb50d5c03@linux.dev>
In-Reply-To: <9d828483-21d0-18da-0870-babcb50d5c03@linux.dev>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 30 Sep 2022 09:52:32 +0200
Message-ID: <CAJ8uoz2Z1amorsKx3Fm7Hy+mfK9+e-KYffT-N9CauYxkapQ29Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/xsk: fix double free
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
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

On Fri, Sep 30, 2022 at 2:52 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 9/29/22 3:44 AM, Maciej Fijalkowski wrote:
> > On Thu, Sep 29, 2022 at 11:01:33AM +0200, Magnus Karlsson wrote:
> >> From: Magnus Karlsson <magnus.karlsson@intel.com>
> >>
> >> Fix a double free at exit of the test suite.
> >>
> >> Fixes: a693ff3ed561 ("selftests/xsk: Add support for executing tests on physical device")
> >> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >> ---
> >>   tools/testing/selftests/bpf/xskxceiver.c | 3 ---
> >>   1 file changed, 3 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> >> index ef33309bbe49..d1a5f3218c34 100644
> >> --- a/tools/testing/selftests/bpf/xskxceiver.c
> >> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> >> @@ -1953,9 +1953,6 @@ int main(int argc, char **argv)
> >>
> >>      pkt_stream_delete(tx_pkt_stream_default);
> >>      pkt_stream_delete(rx_pkt_stream_default);
> >> -    free(ifobj_rx->umem);
> >> -    if (!ifobj_tx->shared_umem)
> shared_umem means ifobj_rx->umem and ifobj_tx->umem are the same?  No special
> handling is needed and ifobject_delete() will handle it?

You are correct, we will still have a double free in that case. Thanks
for spotting. Will send a v2.

> >> -            free(ifobj_tx->umem);
> >>      ifobject_delete(ifobj_tx);
> >>      ifobject_delete(ifobj_rx);
> >
> > So basically we free this inside ifobject_delete().
>
