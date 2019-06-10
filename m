Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7557B3BFB6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390443AbfFJXEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:04:35 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36157 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390340AbfFJXEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 19:04:35 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so9605046ljj.3
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 16:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NJfBl/BqCi14SRrsoXPiVVAK5m66gj3ScBUDnzJZZis=;
        b=Ug3W5FT6zGYWZYbfJvJ3lDdGlmhc4hMrs5F01xtuParEkhxmopHXPcdvQuHe0i9XQE
         0RhkwcqDPtvLT2rJSfO0vITV8HKCTNwtjczWOUksMt+4qVeRaFK581VGy2JtNevd+pBQ
         glzXZgBR3/yAtexuFi1jrXufgtoAn9VbUdAoqEmXe+PiMAPBx7P2WKgzYHUj3APo5nNe
         p4yFjRkuV7Sns1vfFX1EMfhuzuEwFNo+YwH2XrY5XvSTb8CGC/A7rjryctpui9ldRhyN
         MqaXFg9uZXS/5l/jiX3jNJYrXH7c3ww/WMrPDDKguBkaT2tJKsP3VakG+ByayRzMy3us
         DHWQ==
X-Gm-Message-State: APjAAAVhAEzB731f2ydHYLScPixb4NVCfYOhuyWqflZ92ILKS3jVI8jN
        aXVrzAC9P1YPuSt4hhPVN4l9CsQv9el2pslKL+TxKw==
X-Google-Smtp-Source: APXvYqyh+GUShaIYMepDXIgsa/FeLF1XjiROBNHHSuuCAUXnC4BAnYCM31Ylie+aDLfa+upiijpP+rpBD+v8WyhjB74=
X-Received: by 2002:a2e:9b81:: with SMTP id z1mr4929164lji.101.1560207873230;
 Mon, 10 Jun 2019 16:04:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190610221613.7554-1-mcroce@redhat.com> <20190610221613.7554-2-mcroce@redhat.com>
 <20190610154552.4dfa54af@hermes.lan> <CAGnkfhyJeN853gmNX+Op88b4OTkuQdQt==FttFdb4WVPNmQ7zA@mail.gmail.com>
In-Reply-To: <CAGnkfhyJeN853gmNX+Op88b4OTkuQdQt==FttFdb4WVPNmQ7zA@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 11 Jun 2019 01:03:57 +0200
Message-ID: <CAGnkfhz==DcWNkqmqGXhxCx7B4wQuBF9F1rRhnvoA-v+vBCoRw@mail.gmail.com>
Subject: Re: [PATCH iproute2 1/2] netns: switch netns in the child when
 executing commands
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 12:52 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Tue, Jun 11, 2019 at 12:46 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Tue, 11 Jun 2019 00:16:12 +0200
> > Matteo Croce <mcroce@redhat.com> wrote:
> >
> > > +     printf("\nnetns: %s\n", nsname);
> > > +     cmd_exec(argv[0], argv, true, nsname);
> > >       return 0;
> >
> > simple printf breaks JSON output.
>
> It was just moved from on_netns_label(). I will check how the json
> output works when running doall and provide a similar behaviour.
>
> Anyway, I noticed that the VRF env should be reset but only in the
> child. I'm adding a function pointer to cmd_exec which will
> point to an hook which changes the netns when doing 'ip netns exec'
> and reset the VRF on vrf exec.
>
> Regards,
> --
> Matteo Croce
> per aspera ad upstream

Hi Stephen,

just checked, but it seems that netns exec in batch mode produces an
invalid output anyway:

# ip netns add n1
# ip netns add n2
# ip -all -json netns exec date

netns: n2
Tue 11 Jun 2019 12:55:11 AM CEST

netns: n1
Tue 11 Jun 2019 12:55:11 AM CEST

Probably there is very little sense in using -all netns exec and json
together, but worth noting it.

Bye,
-- 
Matteo Croce
per aspera ad upstream
