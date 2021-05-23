Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850BC38DB15
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 13:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhEWLuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 07:50:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231731AbhEWLuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 07:50:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621770521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FaFe9uffRdwTnS7acJYPwsy2NoFG/av6QEuiajyWo2M=;
        b=iv6RIEvII9zh4ptA1nXPVDgFygniRKB5y5DUBnAaifqiBCWtjD++ZphNs6EjYm9seVwYZ1
        iakwMnqvBQyBnlx0FZEVYSD/jmw7zoTrX7qzIiiZ2AwWZ11ZHc9X3w0Kb6Orx3sYDri0Fa
        mOBrfk1OD67MmEXVwnDwnku72vRQnZA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-lbIAAsWjPqu9bxaxSkoD7g-1; Sun, 23 May 2021 07:48:38 -0400
X-MC-Unique: lbIAAsWjPqu9bxaxSkoD7g-1
Received: by mail-ed1-f71.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so13976697edd.2
        for <netdev@vger.kernel.org>; Sun, 23 May 2021 04:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FaFe9uffRdwTnS7acJYPwsy2NoFG/av6QEuiajyWo2M=;
        b=LJNZJucvCCGzysrR+cNKpY3ReVlRNRfgRHiluCRQQk1nBwIU1JLyZE82cSd2nPkeNA
         xH4+ZtHbyppAetQgWvHF1qVjFADZW0JQfWivhQJcHfDJDV3SVoYwMvWaz7/DUx9WhnNv
         GcpOa8+DQaC4EFpw3LxsdboMV5iHRuBxls6Ig94//Wd6NB3yp7d2bn6UzDxh6Rdd5fHO
         n2mcTd+5o1wQQaBUvoUh2iD6RGDP9ETQgr3f3fc+Sn9sk9Rl8E+11aQGM2pjCx0bVgBg
         nTo7nIXkC6cIwSraTWFtOUUOgOvcLO/jOrMKYhyPgQ1wrfY+ESB3bN9LHh2HdmXmA+0B
         GvkA==
X-Gm-Message-State: AOAM530znOB0fDZU3DG7PjwQMx0Kzx0/JtSJA3I6sZJc/TFPTewBnT+z
        1xYjZCiVqgnO1EyQxVecAjp1KQCQvsS8q4aYzsT0Lv5UF0WF03Qdx53+NUt7KY2qfa0m1PNmTs/
        zxXW36Vn4L94Yyglk
X-Received: by 2002:a17:906:f84:: with SMTP id q4mr18838563ejj.442.1621770516847;
        Sun, 23 May 2021 04:48:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1/dLWixp+pH0CUbLqCyt87/WqriedDInYAMUQ+9CeFHoh5eVGl0EyhfWEXWUo9Z/n2E0skA==
X-Received: by 2002:a17:906:f84:: with SMTP id q4mr18838541ejj.442.1621770516434;
        Sun, 23 May 2021 04:48:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id p8sm2792130eds.95.2021.05.23.04.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 04:48:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 76EB51801D6; Sun, 23 May 2021 13:48:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, john.fastabend@gmail.com,
        lmb@cloudflare.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
In-Reply-To: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 23 May 2021 13:48:34 +0200
Message-ID: <87o8d1zn59.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Still wrapping my head around this, but one thing immediately sprang to
mind:

> + * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
> + *	Description
> + *		Set the timer expiration N msecs from the current time.
> + *	Return
> + *		zero

Could we make this use nanoseconds (and wire it up to hrtimers) instead?
I would like to eventually be able to use this for pacing out network
packets, and msec precision is way too coarse for that...

-Toke

