Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2744C3A5F23
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 11:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbhFNJdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 05:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbhFNJdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 05:33:36 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DC8C061574;
        Mon, 14 Jun 2021 02:31:33 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s6so45566320edu.10;
        Mon, 14 Jun 2021 02:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=RHIbBFwcBTvXcTVBDQuMruq6w4u/494nOVlSoFDcJQE=;
        b=FhTQYlhvjMYPEnaRMsU2dtL1r23iZB75KJ8RO7dBLJBpiRV8z0fcqTPDQ53cnwXCMY
         FXwGdAkWLAP149jwR257oHtUT9zYPNZvWw/PgCym8/u3Ar0aY6Kl9B+/YwExw/5rZxdm
         uKS2eTyHhtnoWweETenjiQMrJojVfndcoAtFK3ngB2zvJdKqqN8ONjUuq8zsN5LEKCyB
         4cRel8UlbgfcdxRCqfOM+TXsP8DHvKQpCox+o9DxhtW8m1kVVKvgJBHefgzRgzcsrvpm
         L4tk+pf3UZNNkCwB3p5RmKQI8IgBCyVbGwNB1NaFfXGEDEyCXbFXkHyJQH5fKOLpxMlc
         HZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=RHIbBFwcBTvXcTVBDQuMruq6w4u/494nOVlSoFDcJQE=;
        b=VaQnT1qYO909uivXppnsPXd0tzSOzYSorVsivJz3cxeFm8CimYHTr7F537Fn0Oz7sz
         +E0kPlPSfJ+AKBIB1DAlfnqIXzurP4IaW2irM8hUpFl/47ElVwLUth8sBwwYoKniKJkk
         9SSTG5JRQU8tmhOi1xkl6mwoJJVj2NNiJqUnJpNeAs+1eAA/LknsH0X91PuWgzBDGgT8
         XKnB4jNXL0xmPIiSlyLkUsNT6y7YjABdgchWIlnAV5V1OI1Qj34dcEVPEUtG95vgjJuq
         OknD9O4mLlJ+lFspR/lmuvs9uAZ2KlZ4Exl9albv4N/+YFapto4vq/vUi/fvgREnCaSd
         HWLw==
X-Gm-Message-State: AOAM532DapXn79BdOyj+EqVIyyN3wz8bLjkVXi6MH9i700rCO4+LW8nw
        XYCSRrRb++gh6n84nucZllXQVV2Ofdtgxpubc5Q=
X-Google-Smtp-Source: ABdhPJzD9mBruPTHgKTDgN6DxTN8Wm1w9WPUoO8Z8zHhUZiXrFcia2w8hsEMKLHFKCBF8SyirrJTADC1Q54eEr5GgN0=
X-Received: by 2002:a50:fe18:: with SMTP id f24mr16309152edt.271.1623663091826;
 Mon, 14 Jun 2021 02:31:31 -0700 (PDT)
MIME-Version: 1.0
From:   Yaniv Agman <yanivagman@gmail.com>
Date:   Mon, 14 Jun 2021 12:32:07 +0300
Message-ID: <CAMy7=ZUXRJni3uUVWkWFu8Dkc5XCVsM54i_iLDwHQ5Y0Z3inJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Fixes for TC-BPF series
To:     memxor@gmail.com
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kartikeya,

I recently started experimenting with the new tc-bpf API (which is
great, many thanks!) and I wanted to share a potential problem I
found.
I'm using this "Fixes for TC-BPF series" thread to write about it, but
it is not directly related to this patch set.

According to the API summary given in
https://lore.kernel.org/bpf/20210512103451.989420-3-memxor@gmail.com/,
"It is advised that if the qdisc is operated on by many programs,
then the program at least check that there are no other existing
filters before deleting the clsact qdisc."
In the example given, one should:

/* set opts as NULL, as we're not really interested in
* getting any info for a particular filter, but just
* detecting its presence.
*/
r = bpf_tc_query(&hook, NULL);

However, following in this summary, where bpf_tc_query is described,
it is written that the opts argument cannot be NULL.
And indeed, when I tried to use the example above, an error (EINVAL)
was returned (as expected?)

Am I missing something?

Yaniv
