Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F0C15F922
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 22:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbgBNV5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 16:57:22 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:38741 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728911AbgBNV5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 16:57:22 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 8ee74c64
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 21:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=J+Ls9HJ5sGgoO177Ptgt5NCMNyM=; b=101GgY
        Fx1aAV5+MgtmHlMzNsZNBuuYj+qMO0V10TPO9dS7Jk8spksNGr5CbOECoUnjbW3/
        XcqaoGXa+cBba3gQnw2M/U+hxYSXUeGgL+fzgk373jdkggAaBtJYu5S4I+LyN1H7
        0SyJC+WS0EMA6+qBBf+81VsJNnRJ4IxsGYONuZnpVc7pzJsk2AfVCS3rJjsZ/+QO
        H0qq1OZ+2lLcPj9Qge9IOzhlIUtNgpECJA10h5DxDDD1iWTqAIYXBNsJpTJyKTWK
        z78feS7e4eocyMinNk24Fb4+ghewakdmj5qVWIF6fs26M1jBW+60DfVM7gd3RKu0
        hQQ6koeGLbnUA1sg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4bc25166 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 21:55:11 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id l9so10872752oii.5
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 13:57:20 -0800 (PST)
X-Gm-Message-State: APjAAAW0j7GsbOMlokuO6LZr7m8NMJ7WFGBYUf94rzZ8vBhwbFxI+UgT
        kuGrQh2dZT4pag4Nq6WzvqEqgUF23ZfwfSCAu3g=
X-Google-Smtp-Source: APXvYqy0ky+ume7WbBHQeebq34IWHE2qKiKiSCfSVlnTBh9RIyZYWHGo6NmWOTo0Rft0qYK+ha9gkoMLq5eqSqBOwNk=
X-Received: by 2002:aca:c383:: with SMTP id t125mr3135044oif.122.1581717440264;
 Fri, 14 Feb 2020 13:57:20 -0800 (PST)
MIME-Version: 1.0
References: <20200214173407.52521-1-Jason@zx2c4.com> <20200214173407.52521-4-Jason@zx2c4.com>
 <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com> <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
 <e20d0c52-cb83-224d-7507-b53c5c4a5b69@gmail.com> <CAHmME9oXfDCGmsCJJEuaPmgj7_U4yfrBoqi0wRZrOD9SdWny_w@mail.gmail.com>
 <ec52e8cb-5649-9167-bb14-7e9775c6a8be@gmail.com>
In-Reply-To: <ec52e8cb-5649-9167-bb14-7e9775c6a8be@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Feb 2020 22:57:09 +0100
X-Gmail-Original-Message-ID: <CAHmME9r6gTCV8cpPgyjOVMWCbRJtswzqXMYBqTQmo001AZz05Q@mail.gmail.com>
Message-ID: <CAHmME9r6gTCV8cpPgyjOVMWCbRJtswzqXMYBqTQmo001AZz05Q@mail.gmail.com>
Subject: Re: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Eric,

On Fri, Feb 14, 2020 at 7:53 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > The before passings off to the udp tunnel api, we indicate that we
> > support ip segmentation, and then it gets handled and fragmented
> > deeper down. Check out socket.c.
>
> Okay. Speaking of socket.c, I found this wg_socket_reinit() snippet :
>
> synchronize_rcu();
> synchronize_net();
>
> Which makes little sense. Please add a comment explaining why these two
> calls are needed.

Thanks, I appreciate your scrutiny here. Right again, you are. It
looks like that was added in 2017 after observing the pattern in other
drivers and seeing the documentation comment, "Wait for packets
currently being received to be done." That sounds like an important
thing to do before tearing down a socket. But here it makes no sense
at all, since synchronize_net() is just a wrapper around
synchronize_rcu() (and sometimes _expedited). And here, the
synchronize_rcu() usage makes sense to have, since this is as boring
of an rcu pattern as can be:

mutex_lock()
old = rcu_dereference_protected(x->y)
rcu_assign(x->y, new)
mutex_unlock()
synchronize_rcu()
free_it(old)

Straight out of the documentation. Having the extra synchronize_net()
in there adds nothing at all. I'll send a v3 of this 5.6-rc2 cleanup
series containing that removal.

Jason
