Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF7B9FA0D
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfH1F4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:56:13 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:47020 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfH1F4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:56:13 -0400
Received: by mail-wr1-f42.google.com with SMTP id z1so1092661wru.13
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nNKvTIfy3+Twkv0Xla2GgAu4Wlf2AW39OKM9KJwTd+E=;
        b=s2g25bgau4c2orc6lVzFvRN9pxrsaYsocYR2SAMXk/RelYAI7YbU/c8uRbR46KW7hA
         Wr+Gwt3buhtyAy7VLCmoLmpfT54pzsmJjOsQEAhgnoQdykiuOg8Sjfbqo6qB3SVycRzm
         G2oeTzS4gZd06tToq1C30mq296I/sGhnIQs0iiqlPnue0IrM5ngn7MHC4LNQmFhugqAk
         NeKDb1/p1+2HOs2wdYJTPQgkkjm2/p/Aa4WaiRSSSVCsSlkoSIDge0F3k2V035jA4CEx
         /wWYDe41+6mSOlnvOrS59ZhUSXdNdsk8zz8YOIV3sOjnXqjieHhuNi0otPTy8pQqElyi
         x1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nNKvTIfy3+Twkv0Xla2GgAu4Wlf2AW39OKM9KJwTd+E=;
        b=kyytUuwWe176TXBbysDx0qJnMmhE0utKWEMjXe72wOMpbrhnuwL+HQ87ccPOUfnf5h
         CNXcCHNQM4i5VZ+qUgD25PpHFq/BSzti7pSYtWH8uLyZ3ybUJpB3M27FC0pKr2EV12UM
         X9zGz82ymGzTKeHwiXqkVljttu5gCtzLomGNJUnE9yilKxilIjMiyRBnJOSrSifpR5pP
         yqrnWuGjZU0leTPN1HP73d+jgjMifQlOP0tVhe7fWV+bGaMyDWTULPEiSNvPQCTU7mYm
         RR9w2dYIkVaTUKEIHb2yaDrG6Z1aLan5uGpAgauh/psbqmqr/6AWUkfRPCiFjpdZdK+f
         iYfw==
X-Gm-Message-State: APjAAAXbK585qDgrRyYhDrs8663x+AfMjqpN46TPNXZkeiA+ZQ9MkwFP
        yyJ9AmzvRiqOb9FWgeYfEyv+i6/f2qo=
X-Google-Smtp-Source: APXvYqycdjex5EOj/rjXGLDbfmZrYWk+f3hMylBtZSrtmy111qebdif9pm/nWrSzireJ+IwEpBd18A==
X-Received: by 2002:a5d:42c1:: with SMTP id t1mr2181980wrr.344.1566971770837;
        Tue, 27 Aug 2019 22:56:10 -0700 (PDT)
Received: from pixies ([5.102.239.190])
        by smtp.gmail.com with ESMTPSA id j9sm1693532wrx.66.2019.08.27.22.56.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Aug 2019 22:56:10 -0700 (PDT)
Date:   Wed, 28 Aug 2019 08:56:08 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        shmulik@metanetworks.com, eyal@metanetworks.com
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
Message-ID: <20190828085608.12053dac@pixies>
In-Reply-To: <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
References: <20190826170724.25ff616f@pixies>
        <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
        <20190827144218.5b098eac@pixies>
        <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 14:10:35 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> Given first point above wrt hitting rarely, it would be good to first get a
> better understanding for writing a reproducer. Back then Yonghong added one
> to the BPF kernel test suite [0], so it would be desirable to extend it for
> the case you're hitting. Given NAT64 use-case is needed and used by multiple
> parties, we should try to (fully) fix it generically.

Thanks Daniel for the advice.

I'm working on a reproducer that resembles the input skb which triggers
this BUG_ON.
