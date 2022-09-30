Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7ECA5F0D96
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiI3Obx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbiI3Obu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:31:50 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3328C16510C;
        Fri, 30 Sep 2022 07:31:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d10so4392737pfh.6;
        Fri, 30 Sep 2022 07:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=P/mfulPnToD5m3VhopO0JJf5HkHXOGbekrrPNUqUIfs=;
        b=P2LrHizLC0JOdFxy4s4hGsTWgwWSku430QDkH9BRLpvfb+BSOgHyMgcFyFHJokLl3K
         gsXHroqLUivcxo+sIq1rqC701MQq1PJm47zquRyhgXjOV4paTbE4MD3aPY939KD2gFjS
         CB2W/iZCk80PmaXNlAZC9zxc7OqOn4zqoRl0XQFVwFxQ1MwV57LiXvF1xG/cKFfOZEa1
         7pLneBOC+kneZTRLdnaN6Z3AnON1EU3PBeeIJ9EcgkC6HcHgFuCuaT/jtHyS+8m/OU9o
         KAus4GKm4K2OX1uKayD3W0l9h2D0C6MB54VfZXkrnL+/hyG6Z1uzrkdz3MR8SRoEsDFq
         lPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=P/mfulPnToD5m3VhopO0JJf5HkHXOGbekrrPNUqUIfs=;
        b=XVtMYPqixR0mkOmPA6IkWeDS7hkv1L4ZU9Mx62LfTtZgtKBYrSVu4s5QdDPzpzHhZo
         qDlZ01a/vB1ptwf98tI79E9Noryc/mVt87bjO3pHlGNfvoqtf9I/VUXOYE0g2Nlu2N+r
         ctqxyV+q/GrWpGAqy6J+5P2yAgb4ymj532tWqoMvGu2kn3Nt71vY2PiWF9ApWkKlJwV8
         CHRmbLsHqJhAKsE3E84TTgqzgJcaLL7wGKlKWCZfSaYhHQPXZgN+ERL3vnf/TyMM/zFt
         5UDmwHZ+La2JhLilaKlMA07gUc0CocQrnbvFt70RhpOGLC9MJFyAi8W6RNDIjejs/Xd3
         YmTg==
X-Gm-Message-State: ACrzQf3CKnVhH4MZu8JO/PAdQ+ecHOf+qHIIMoQprT9dK/8lm4qxTiAy
        UCeAnhBR2GAJyFgKYYkwzaTuHHL/eL7oelzfCc8=
X-Google-Smtp-Source: AMsMyM4L/fl0gfg7Gw+77bK4QC9t/VXKvqOmQDdygqstfx4d3VC458VJ2g+1gtQPzn08bc3bN2UXcZPSUuv6HaVdsiE=
X-Received: by 2002:a63:8ac2:0:b0:441:358c:f68c with SMTP id
 y185-20020a638ac2000000b00441358cf68cmr3504828pgd.69.1664548308645; Fri, 30
 Sep 2022 07:31:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220929090133.7869-1-magnus.karlsson@gmail.com>
 <YzV28OlK+pwlm/B/@boxer> <9d828483-21d0-18da-0870-babcb50d5c03@linux.dev> <CAJ8uoz2Z1amorsKx3Fm7Hy+mfK9+e-KYffT-N9CauYxkapQ29Q@mail.gmail.com>
In-Reply-To: <CAJ8uoz2Z1amorsKx3Fm7Hy+mfK9+e-KYffT-N9CauYxkapQ29Q@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 30 Sep 2022 16:31:37 +0200
Message-ID: <CAJ8uoz3ncobw=kWGoqdw0f++jgWzVAz_qTCy65OSMH+2ZqeBYQ@mail.gmail.com>
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

On Fri, Sep 30, 2022 at 9:52 AM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Fri, Sep 30, 2022 at 2:52 AM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >
> > On 9/29/22 3:44 AM, Maciej Fijalkowski wrote:
> > > On Thu, Sep 29, 2022 at 11:01:33AM +0200, Magnus Karlsson wrote:
> > >> From: Magnus Karlsson <magnus.karlsson@intel.com>
> > >>
> > >> Fix a double free at exit of the test suite.
> > >>
> > >> Fixes: a693ff3ed561 ("selftests/xsk: Add support for executing tests on physical device")
> > >> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > >> ---
> > >>   tools/testing/selftests/bpf/xskxceiver.c | 3 ---
> > >>   1 file changed, 3 deletions(-)
> > >>
> > >> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> > >> index ef33309bbe49..d1a5f3218c34 100644
> > >> --- a/tools/testing/selftests/bpf/xskxceiver.c
> > >> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > >> @@ -1953,9 +1953,6 @@ int main(int argc, char **argv)
> > >>
> > >>      pkt_stream_delete(tx_pkt_stream_default);
> > >>      pkt_stream_delete(rx_pkt_stream_default);
> > >> -    free(ifobj_rx->umem);
> > >> -    if (!ifobj_tx->shared_umem)
> > shared_umem means ifobj_rx->umem and ifobj_tx->umem are the same?  No special
> > handling is needed and ifobject_delete() will handle it?
>
> You are correct, we will still have a double free in that case. Thanks
> for spotting. Will send a v2.

Sorry, but I have to take my statement back. The v1 is actually
correct. The umem structure is unconditionally allocated in
ifobject_create(). Later when setting up the shared_umem, the
information from one of them is copied over to the other, except for
some information that is changed for the second umem structure. So the
v1 still stands.

> > >> -            free(ifobj_tx->umem);
> > >>      ifobject_delete(ifobj_tx);
> > >>      ifobject_delete(ifobj_rx);
> > >
> > > So basically we free this inside ifobject_delete().
> >
