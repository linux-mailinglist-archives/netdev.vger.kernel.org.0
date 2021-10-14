Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC0142E242
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 21:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhJNT4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 15:56:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231671AbhJNT4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 15:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634241270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0QzFmC4EFNZ7oC3Ivj5XNWIVU79hBI0kweBZlpnj2iQ=;
        b=D+sMJINwecZrISmGxhrwSRmTBM0ga+VUCTuxLjKCdwlSmL1WkEjqdtmUtEgkzNFFEkxy87
        Stghl84RHID8Mu5PgD8yDW4JAyzN0WpKgitvoPCJzy6gT5gBMf5o/Fl6ixSAFDQNgok52i
        2js86Xhj1Lhn9ALhtlBhg6OkopZdrk8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-yh_VchWQPyKDkAnX3TvR_w-1; Thu, 14 Oct 2021 15:54:28 -0400
X-MC-Unique: yh_VchWQPyKDkAnX3TvR_w-1
Received: by mail-ed1-f69.google.com with SMTP id l10-20020a056402230a00b003db6977b694so6118972eda.23
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 12:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0QzFmC4EFNZ7oC3Ivj5XNWIVU79hBI0kweBZlpnj2iQ=;
        b=2CvpM7sxHbV56aOuKbIBQkdgf+XK76X31g18ELsdT59AD7kDEb8JudiyaRMoH+UiQ/
         9UlViHEwo5l6AHASAreHBnkIUKv7fV2rhuQ3CYY4yQ3YZ/8px7yHPUaGTNFOC5jly1EH
         s0dnlBjqp6P5PxWqgRK69AQ0rOQ9JB/8IZOhpljMBNFEEAUYzUtZP9Fg0c7276JfPpes
         qzl4sbEFWMdlmzlijNrVPpCZpr4ZVjbevhLnZufRG+bZc/ZHbUq8NUKQ+44iK0UAEFPg
         box4FWUgMRJfGnj+VTBnIj4D0Zsb4zB23MW3KCbadkBdadp0mPNMM9pnmA1rjexOEZiB
         +KqA==
X-Gm-Message-State: AOAM531uG+JEDXZxdsCy4VgVZQwPKJnqTRf+OwogPsQ+urBnEq1fG7F2
        VgJYcjZbNwYbBLdVLOzTvVFxSvj1VgQn9/Md8ALO0e1vcIY3KZ1XUDQGIB5djTex1uhrGIePdlq
        gVGz0xqTjHzugIZJi
X-Received: by 2002:a17:906:a0d7:: with SMTP id bh23mr1323176ejb.82.1634241266981;
        Thu, 14 Oct 2021 12:54:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzP65kMVk9PIOLiIf6uMbqanKSeCwmLpn+5VzfJytwrVAOEPRWWGQ54g+lHWlba5Ldf44th0Q==
X-Received: by 2002:a17:906:a0d7:: with SMTP id bh23mr1322970ejb.82.1634241264884;
        Thu, 14 Oct 2021 12:54:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w2sm3098911edj.44.2021.10.14.12.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 12:54:24 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3349C18025F; Thu, 14 Oct 2021 21:54:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>, Bob Briscoe <in@bobbriscoe.net>
Subject: Re: [PATCH net-next 2/2] fq_codel: implement L4S style
 ce_threshold_ect1 marking
In-Reply-To: <20211014175918.60188-3-eric.dumazet@gmail.com>
References: <20211014175918.60188-1-eric.dumazet@gmail.com>
 <20211014175918.60188-3-eric.dumazet@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Oct 2021 21:54:23 +0200
Message-ID: <87wnmf1ixc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> From: Eric Dumazet <edumazet@google.com>
>
> Add TCA_FQ_CODEL_CE_THRESHOLD_ECT1 boolean option to select Low Latency,
> Low Loss, Scalable Throughput (L4S) style marking, along with ce_threshold.
>
> If enabled, only packets with ECT(1) can be transformed to CE
> if their sojourn time is above the ce_threshold.
>
> Note that this new option does not change rules for codel law.
> In particular, if TCA_FQ_CODEL_ECN is left enabled (this is
> the default when fq_codel qdisc is created), ECT(0) packets can
> still get CE if codel law (as governed by limit/target) decides so.

The ability to have certain packets receive a shallow marking threshold
and others regular ECN semantics is no doubt useful. However, given that
it is by no means certain how the L4S experiment will pan out (and I for
one remain sceptical that the real-world benefits will turn out to match
the tech demos), I think it's premature to bake the ECT(1) semantics
into UAPI.

So how about tying this behaviour to a configurable skb->mark instead?
That way users can get the shallow marking behaviour for any subset of
packets they want, simply by installing a suitable filter on the
qdisc...

-Toke

