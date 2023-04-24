Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632CB6ECC28
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 14:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjDXMjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 08:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjDXMiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 08:38:54 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 286242D48;
        Mon, 24 Apr 2023 05:38:52 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-2f87c5b4635so4000373f8f.1;
        Mon, 24 Apr 2023 05:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682339930; x=1684931930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lx7DmyFlRlvWUed6TjzQKWfcWFQg770oVH4KZSEDJpQ=;
        b=ctcFbIKD3/sGh/iRlKPOiUUf9u0p65PjOOh7L5IKugl3B7DMfLYLvPD05JAT4UfIRU
         owA8xENxL0+tiOFgLY36MuWtu4e9t6FSMc4QOG4U3IyE2FEfx0trObDGyfie+q47qXCI
         prKTVusoC1ooNsxJ+bJHAxX8dWA5mNJ0K4SQvsZty9PgmHEPOg1IUSZK9GkkKSFQ+y9s
         Lm0dCdsW+glzrX7WYQIS1MKuL/WSAaLen7zJzXkIxHf2Y+KPcNo+765UmjHhr4ra7Ocb
         Fh6Ut9GErO6ltAqq6EOmcyMPBenOQDLrEeXCwP3jyzP4JIKlkPnXC2V171/wrctulpFI
         qVzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682339930; x=1684931930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lx7DmyFlRlvWUed6TjzQKWfcWFQg770oVH4KZSEDJpQ=;
        b=lvMyAR9B+t80pmLrOtixz84rZqtX1HKFmo+6BtXrs7sekP44W1qD0+f19f/aDXmoV+
         xafZKKBYXMGNHBrz9KytMOVS26gWuzAEvcx9ZPTF1yYadhKHsgWq69n8GjNzF/lA+PH6
         BONlzJHFF7y52kMILePR557OMF5ihYTNt2VoBhHGnAzMxOClGjT/K8s7R8ZoSHLZsZOe
         OsPzDxwJILHjnX7BScSFsCZ32gS//1rjIUXuC4v49GmzBumZhvFFLBn4+/8jsS5KOdBp
         c1xhvbhS6Q+y4+rWGT/b8iYWEBHftUsAtTmCleFLD0fOKDF6374KwqC5+FcGWAu63Avr
         HQaQ==
X-Gm-Message-State: AAQBX9frAa2EHIbH2uJcFQZnSYbNbcVKOsNJhi417oiwN0cVpWbvCPfz
        JIHmYmtW08lMhgp+sEdipkM=
X-Google-Smtp-Source: AKy350bDDaww1oPOEwHvoL6ufxQ6NB1xIwzcfg9BIoIp8pQcVilhbJJtyq1J1gNXn/x7K284jT2KmA==
X-Received: by 2002:a5d:690e:0:b0:2f8:f3da:72cf with SMTP id t14-20020a5d690e000000b002f8f3da72cfmr8518834wru.18.1682339930413;
        Mon, 24 Apr 2023 05:38:50 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id i1-20020a05600011c100b002cff06039d7sm10651491wrx.39.2023.04.24.05.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 05:38:49 -0700 (PDT)
Date:   Mon, 24 Apr 2023 13:38:49 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEZ117OMCi0dFXqY@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 09:28:07AM -0300, Jason Gunthorpe wrote:
> On Mon, Apr 24, 2023 at 11:17:55AM +0100, Lorenzo Stoakes wrote:
> > On Mon, Apr 24, 2023 at 02:43:56AM -0700, Christoph Hellwig wrote:
> > > I'm pretty sure DIRECT I/O reads that write into file backed mappings
> > > are out there in the wild.
>
> I wonder if that is really the case? I know people tried this with
> RDMA and it didn't get very far before testing uncovered data
> corruption and kernel crashes.. Maybe O_DIRECT has a much smaller race
> window so people can get away with it?
>
> > I know Jason is keen on fixing this at a fundamental level and this flag is
> > ultimately his suggestion, so it certainly doesn't stand in the way of this
> > work moving forward.
>
> Yeah, the point is to close it off, because while we wish it was
> fixed properly, it isn't. We are still who knows how far away from it.
>
> In the mean time this is a fairly simple way to oops the kernel,
> especially with cases like io_uring and RDMA. So, I view it as a
> security problem.
>
> My general dislike was that io_uring protected itself from the
> security problem and we left all the rest of the GUP users out to dry.
>
> So, my suggestion was to mark the places where we want to allow this,
> eg O_DIRECT, and block everwhere else. Lorenzo, I would significantly
> par back the list you have.

I was being fairly conservative in that list, though we certainly need to
set the flag for /proc/$pid/mem and ptrace to avoid breaking this
functionality (I observed breakpoints breaking without it which obviously
is a no go :). I'm not sure if there's a more general way we could check
for this though?

A perhaps slightly unpleasant solution might be to not enforce this when
FOLL_FORCE is specified which is mostly a ptrace + friends thing then we
could drop all those exceptions.

I wouldn't be totally opposed to dropping it for RDMA too, because I
suspect accessing file-backed mappings for that is pretty iffy.

Do you have a sense of which in the list you feel could be pared back?

>
> I also suggest we force block it at some kernel lockdown level..
>
> Alternatively, perhaps we abuse FOLL_LONGTERM and prevent it from
> working with filebacked pages since, I think, the ease of triggering a
> bug goes up the longer the pages are pinned.
>

This would solve the io_uring case and it is certainly more of a concern
when the pin is intended to be kept around, though it feels a bit icky as a
non-FOLL_LONGTERM pin could surely be problematic too?

> Jason
