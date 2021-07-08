Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620353BF437
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 05:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhGHDMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 23:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbhGHDMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 23:12:30 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EDDC061574;
        Wed,  7 Jul 2021 20:09:48 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id p21so10436286lfj.13;
        Wed, 07 Jul 2021 20:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zOuVEKmSTO8HNKXM2OyBQMBqTxDYg4hfRl7sR8OpN38=;
        b=DDMazZBAtPE2hBBF9mKL/ywFhnPN/012PNsBxLBxKjZXzUwQeXj3gWreF1Ia8IxEj8
         CvZY2z+3Uw5dVh42M5Ra9t9MV+DbZmWOl3VD7mdrxEMqnOgvl9ydjpSF0PoKrawk8Ovo
         MkzCOTkSt3xQnx6RtA2+WPWoNV0LLghCr6lZqM0nGndUtzBkem/SRFfwbf4st7xLMp+l
         dOdUnjYPJn2UOckbc89ryN6Uc/0lhaXDTAZklRpfNXyci2JoYUv6Ln4Q6wF8YanroDqy
         hWD590w0+EhNHOAQWbsoookxP9dbEo0DXnthjaifpd3wqP1vVLTduxFTPyQww2nFal/I
         3Y6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOuVEKmSTO8HNKXM2OyBQMBqTxDYg4hfRl7sR8OpN38=;
        b=teH+AU3m77yLZS0Q1G9PUrzMsxSNLV0SYWkPUDeKRE0wvw0MNXzaTxXQZGPVGCKEjB
         7ohA8EVVBuczJpsuQ/4q9GXJ2Clo0vbeUeQAYwAOqghWzMRDpsCGRRRM7q03bGeoX0Wo
         Nd5BHXay8r5kZCmwm7kEeFesXmiL3FNDPpbo7wiTJzad9hycTXoH8OQ9E6wYPIzBX+7U
         r6qSadtPbivNITi3VyIo7acLBbSt7q6BmhxUJp/s0XCo2XGJZbZEvjQfKvplO8rwOj/0
         TmGFg0XL9U0+2vmvewpDfDs2dBUehW5K59YXylQNZYRsOnbDGbysbGvZu/3EsrASy+Jr
         KQrA==
X-Gm-Message-State: AOAM532VPa6GKPn/J6jafPTDRvgussjOFAgTfdpta9HMSJ6NrVyLim1K
        TCNvSQJ0plfgEbMzneG9CEUf0yCYmg6ahSEZBPU=
X-Google-Smtp-Source: ABdhPJwKZdq15qpbv7h2OOlVXAf5ZGqkMjxXVrItgJi8vE0+oyYi7iePM1Uho4dCgqiu0sSqJod2tpDgv91ZtSU2dh0=
X-Received: by 2002:a05:6512:3f1a:: with SMTP id y26mr22261665lfa.540.1625713787314;
 Wed, 07 Jul 2021 20:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210707043811.5349-1-hefengqing@huawei.com> <20210707043811.5349-4-hefengqing@huawei.com>
 <CAPhsuW7ssFzvS5-kdZa3tY-2EJk8QUdVpQCJYVBr+vD11JzrsQ@mail.gmail.com> <1c5b393d-6848-3d10-30cf-7063a331f76c@huawei.com>
In-Reply-To: <1c5b393d-6848-3d10-30cf-7063a331f76c@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Jul 2021 20:09:36 -0700
Message-ID: <CAADnVQJ0Q0dLVs5UM-CyJe90N+KHomccAy-S_LOOARa9nXkXsA@mail.gmail.com>
Subject: Re: [bpf-next 3/3] bpf: Fix a use after free in bpf_check()
To:     He Fengqing <hefengqing@huawei.com>
Cc:     Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 8:00 PM He Fengqing <hefengqing@huawei.com> wrote:
>
> Ok, I will change this in next version.

before you spam the list with the next version
please explain why any of these changes are needed?
I don't see an explanation in the patches and I don't see a bug in the code.
Did you check what is the prog clone ?
When is it constructed? Why verifier has anything to do with it?
