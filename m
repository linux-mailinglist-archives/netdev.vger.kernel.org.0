Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18CA44486F
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393320AbfFMRG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:06:57 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:45715 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393316AbfFMRGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:06:55 -0400
Received: by mail-ed1-f65.google.com with SMTP id a14so30357658edv.12
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:06:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4qGmeV3x69yuLe0Tgd0ptE/Ne+7fNuOjO6KsPPNkVJk=;
        b=FGo8wqLqaNODUW7pSsr8T8qxkpWFJszTo9xVaP8/j63MYJqUr9PN4SdBD37epkf6e5
         BjjspeVE0+mAaId31ddFTmFm9yEVSmBwMP4zCtjTk82ueBtvdlt7I4s0icGuv3O8lKy2
         IWsJuEZvydrj0D9C6MRqXJgGjkA+IfZiWOSQxP8XYN6HhwmhEFIiBNfI0RC3BjL3lRos
         emo6sx8OxDmQpfM4LEnqA8tv2g6bL4tpG5Nr0bU06Lm57ZIyC8rJwSHfw+KcqeDwnxeu
         QxwiM9s4fwduFGwTvA93cu4TWq7x7Q8oeMlIh1PraVVAm/FGzQToyh42JV6MTf6Ltl+U
         PuUQ==
X-Gm-Message-State: APjAAAX3G5t32Tg+2UtBrqgDV1jGwx2DI+/wXz8IbZ2m447RBL5exmY5
        on7xXCGYvM23SqcFrIBLNHvGc5AKZ4Ll1J7j50QvMw==
X-Google-Smtp-Source: APXvYqzPslmnv+ruwTU1kTQ26hkm3+iNaMJ3g8cToQx4BfFooy4XornCbIQ0QzxHDHAMpU3RhSOQbzI/FKkm+eg/b6g=
X-Received: by 2002:a50:ac07:: with SMTP id v7mr49556490edc.205.1560445613273;
 Thu, 13 Jun 2019 10:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190611161031.12898-1-mcroce@redhat.com>
In-Reply-To: <20190611161031.12898-1-mcroce@redhat.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Thu, 13 Jun 2019 19:07:20 +0200
Message-ID: <CAPpH65yOS8OKX1cUDtvjVHwXSTEifbCGXQhMUKg9R-aEbMNnWQ@mail.gmail.com>
Subject: Re: [PATCH iproute2 v2 0/3] refactor the cmd_exec()
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 6:11 PM Matteo Croce <mcroce@redhat.com> wrote:
>
> Refactor the netns and ipvrf code so less steps are needed to exec commands
> in a netns or a VRF context.
> Also remove some code which became dead. bloat-o-meter output:
>
> $ bloat-o-meter ip.old ip
> add/remove: 1/4 grow/shrink: 3/4 up/down: 174/-312 (-138)
> Function                                     old     new   delta
> netns_add                                    971    1058     +87
> cmd_exec                                     207     256     +49
> on_netns_exec                                 32      60     +28
> do_switch                                      -      10     +10
> netns_restore                                 69      67      -2
> do_ipvrf                                     811     802      -9
> netns_switch                                 838     822     -16
> on_netns_label                                45       -     -45
> do_netns                                    1226    1180     -46
> do_each_netns                                 57       -     -57
> on_netns                                      60       -     -60
> netns_save                                    77       -     -77
> Total: Before=668234, After=668096, chg -0.02%
>
> Matteo Croce (3):
>   netns: switch netns in the child when executing commands
>   ip vrf: use hook to change VRF in the child
>   netns: make netns_{save,restore} static
>
>  include/namespace.h |  2 --
>  include/utils.h     |  6 ++---
>  ip/ip.c             |  1 -
>  ip/ipnetns.c        | 56 +++++++++++++++++++++++++++++++++------------
>  ip/ipvrf.c          | 12 ++++++----
>  lib/exec.c          |  7 +++++-
>  lib/namespace.c     | 31 -------------------------
>  lib/utils.c         | 27 ----------------------
>  8 files changed, 58 insertions(+), 84 deletions(-)
>
> --
> 2.21.0
>

For patch series:
Reviewed-and-tested-by: Andrea Claudi <aclaudi@redhat.com>
