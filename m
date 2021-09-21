Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B3E4136F4
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhIUQIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:08:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233587AbhIUQIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632240403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=e6HK/BwJ2W5unsWLoV5gYLpF0WRIoMgAw8WXLr0AbN4=;
        b=A0c+yeiADW6vltvBUpyZDbZ+CKg77cF9f+JG9bKXTbEk+98paZ9mHt4l4itpkh4DNQ64hm
        NaDUaerMrJCpncedcI7cnfU79dxcXpWPGcYZTBiiol400qEQKcVdzytY3ARRwiUrD79Id/
        uQBZPNzm7AH5zUW/Vge577DDYsph2N8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-Ng1A41o2NZWl8ai70dYQfQ-1; Tue, 21 Sep 2021 12:06:42 -0400
X-MC-Unique: Ng1A41o2NZWl8ai70dYQfQ-1
Received: by mail-ed1-f69.google.com with SMTP id b7-20020a50e787000000b003d59cb1a923so18603877edn.5
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 09:06:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=e6HK/BwJ2W5unsWLoV5gYLpF0WRIoMgAw8WXLr0AbN4=;
        b=dOWqtT3l3ovF2wZ7kNw6DocCzhjSMimWQmPtLT5uU+2+VCLeHT1x0fnQuy1AVHVBqZ
         I4z/mV41Fuqwe754ZV34eMOxgxoTSE0C1y7xvSF3paFjpoXIS8HfSYNCLZ4shYxUQRTg
         S9mL7YVFNY6gtvmKtnZ9zZbal4KjOZ1z9ni52o8qUh3WBe5u0XPXGXcJ6D//VycTk/PQ
         HL89IhHbeISoJu8f9/sklsauXMPvwIZcoNc3mhbcpqdWpBgvf3SW0MfFOk2v2cSyb2FU
         FnhlRrNC2uIN8eOUrOEsXaXsthEN2e3Csl8kIUe+JOe5wkmIUHUE0HWb4s8lAwriUKxI
         Rbog==
X-Gm-Message-State: AOAM530QkTsDthG9JFv4ybQ+L+TEManOrMSK87DQijATOzRc3/8bDUDF
        LMTess54wIXsM9xfcPVJ8aACBnXzqEXcsCZAnLbe/y0TvZgXjkDFAZcZoPRLZ+CFhHX6mHlfkwl
        usIQLhJyDgXoeM07d
X-Received: by 2002:a17:906:c252:: with SMTP id bl18mr35058510ejb.519.1632240399565;
        Tue, 21 Sep 2021 09:06:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKP5JCN4i445M+rwwYicc3/SOuXpCZJ0UAvZ30Yoj+JRFzogTvICCiMUFiFaJcF1lReqTxqA==
X-Received: by 2002:a17:906:c252:: with SMTP id bl18mr35058327ejb.519.1632240397230;
        Tue, 21 Sep 2021 09:06:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l7sm9045577edb.26.2021.09.21.09.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 09:06:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 67B2918034A; Tue, 21 Sep 2021 18:06:35 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Redux: Backwards compatibility for XDP multi-buff
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Sep 2021 18:06:35 +0200
Message-ID: <87o88l3oc4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenz (Cc. the other people who participated in today's discussion)

Following our discussion at the LPC session today, I dug up my previous
summary of the issue and some possible solutions[0]. Seems no on
actually replied last time, which is why we went with the "do nothing"
approach, I suppose. I'm including the full text of the original email
below; please take a look, and let's see if we can converge on a
consensus here.

First off, a problem description: If an existing XDP program is exposed
to an xdp_buff that is really a multi-buffer, while it will continue to
run, it may end up with subtle and hard-to-debug bugs: If it's parsing
the packet it'll only see part of the payload and not be aware of that
fact, and if it's calculating the packet length, that will also only be
wrong (only counting the first fragment).

So what to do about this? First of all, to do anything about it, XDP
programs need to be able to declare themselves "multi-buffer aware" (but
see point 1 below). We could try to auto-detect it in the verifier by
which helpers the program is using, but since existing programs could be
perfectly happy to just keep running, it probably needs to be something
the program communicates explicitly. One option is to use the
expected_attach_type to encode this; programs can then declare it in the
source by section name, or the userspace loader can set the type for
existing programs if needed.

With this, the kernel will know if a given XDP program is multi-buff
aware and can decide what to do with that information. For this we came
up with basically three options:

1. Do nothing. This would make it up to users / sysadmins to avoid
   anything breaking by manually making sure to not enable multi-buffer
   support while loading any XDP programs that will malfunction if
   presented with an mb frame. This will probably break in interesting
   ways, but it's nice and simple from an implementation PoV. With this
   we don't need the declaration discussed above either.

2. Add a check at runtime and drop the frames if they are mb-enabled and
   the program doesn't understand it. This is relatively simple to
   implement, but it also makes for difficult-to-understand issues (why
   are my packets suddenly being dropped?), and it will incur runtime
   overhead.

3. Reject loading of programs that are not MB-aware when running in an
   MB-enabled mode. This would make things break in more obvious ways,
   and still allow a userspace loader to declare a program "MB-aware" to
   force it to run if necessary. The problem then becomes at what level
   to block this?

   Doing this at the driver level is not enough: while a particular
   driver knows if it's running in multi-buff mode, we can't know for
   sure if a particular XDP program is multi-buff aware at attach time:
   it could be tail-calling other programs, or redirecting packets to
   another interface where it will be processed by a non-MB aware
   program.

   So another option is to make it a global toggle: e.g., create a new
   sysctl to enable multi-buffer. If this is set, reject loading any XDP
   program that doesn't support multi-buffer mode, and if it's unset,
   disable multi-buffer mode in all drivers. This will make it explicit
   when the multi-buffer mode is used, and prevent any accidental subtle
   malfunction of existing XDP programs. The drawback is that it's a
   mode switch, so more configuration complexity.

None of these options are ideal, of course, but I hope the above
explanation at least makes sense. If anyone has any better ideas (or can
spot any flaws in the reasoning above) please don't hesitate to let us
know!

-Toke

[0] https://lore.kernel.org/r/8735srxglb.fsf@toke.dk

