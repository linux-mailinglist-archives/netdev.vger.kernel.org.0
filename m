Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532975DFE0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 10:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGCId5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 04:33:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33424 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfGCId5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 04:33:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so1757717wru.0
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 01:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7sk5MEKCDu5AoSt+8829lBLS1GFx9AcOW+mlQ3p4Bh0=;
        b=ir7e0TB0JEwMq6Lf2NjIKdXQJ6ZFxNW4Jv6YaVUH6yGi9u9ocgjQ/EyKdqHO6XHj5O
         bDXJ6VEMM8UzdlVxwkhhL3qmvbwywC0SzahYSLeGd4mO5Grf0E4JInVSkQEvHY4Z5CWm
         r7REMgYg8svGvrVCn6fsxkdVBqT6Oiar9N78RP4t/X22UJk6EaJOLks6EPAKFOM2E9fP
         9wcFwB57+SRh1B0Vl9jQwZg09Zc3Y/LCHajVBjIsJzHyYVDszTI/tQMjaBLocsQIE0En
         +R4ab62eH51NY168jfs2HhTjfZbH2KgMhpnndOZqlH33E6yfpz649X+pvVa/WpV3j8HN
         eW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7sk5MEKCDu5AoSt+8829lBLS1GFx9AcOW+mlQ3p4Bh0=;
        b=XDoaFSTqb8sfmWuBUO4wLTEZiowPO1yRAnsXGGsDPPSgiMHw0p+1PY90k/a4/ksDIl
         7NDZevQz54Ch1YDolM9t4WfwmhP9CxxBl3l2JlyPTy2n3hrUneDU0esR19LxwvbnV2Vu
         fvWXl9iDJhHlghwwI1psDITwWrQLnNE9Ef4XRuxg1a0EWJmZLjEdmPVixK7nVToY+lbf
         z0RygDDx2to1qj9Z136ROK0Y80yCnzIe0Q9YDk3yFRjpOZEmRyiNFin2TFNsaqkdpbU8
         /j7QCkCw+ttOXwaUqubraFEzxUPxiZ2fMD8kIH06lT4dVrBFHnmG84Fvx46AVebbD0Ex
         pXWA==
X-Gm-Message-State: APjAAAU7234bnOvSZBiJIcPEN4ICsg5R3HKf5AQeKEePURbC9+d4uroM
        28biyndxBJhW3R0NICf7dBTXQ4SdaESi1QHdum0=
X-Google-Smtp-Source: APXvYqwSfvaeJXLhF4nnrBJ/J9TgMzNKmbwlQ8boNMhEyQqDtTFe719b18DKbBRyubW7/OW6KA8IBL7Xqm5zfobVMug=
X-Received: by 2002:adf:aacf:: with SMTP id i15mr17591872wrc.124.1562142835727;
 Wed, 03 Jul 2019 01:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <07e0518ac689f5919890a38634df38edf95d34a1.1562000095.git.lucien.xin@gmail.com>
 <20190702.150811.1940085234903099096.davem@davemloft.net>
In-Reply-To: <20190702.150811.1940085234903099096.davem@davemloft.net>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 3 Jul 2019 16:33:44 +0800
Message-ID: <CADvbK_emyKTg8=ye8n2ZTBx0QFK9gPL02aVDfn44DuyUTP-ofw@mail.gmail.com>
Subject: Re: [PATCH net-next] tipc: use rcu dereference functions properly
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 6:08 AM David Miller <davem@davemloft.net> wrote:
>
> From: Xin Long <lucien.xin@gmail.com>
> Date: Tue,  2 Jul 2019 00:54:55 +0800
>
> > For these places are protected by rcu_read_lock, we change from
> > rcu_dereference_rtnl to rcu_dereference, as there is no need to
> > check if rtnl lock is held.
> >
> > For these places are protected by rtnl_lock, we change from
> > rcu_dereference_rtnl to rtnl_dereference/rcu_dereference_protected,
> > as no extra memory barriers are needed under rtnl_lock() which also
> > protects tn->bearer_list[] and dev->tipc_ptr/b->media_ptr updating.
> >
> > rcu_dereference_rtnl will be only used in the places where it could
> > be under rcu_read_lock or rtnl_lock.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> In the cases where RTNL is held, even if rcu_read_lock() is also taken,
> we should use rtnl_dereference() because that avoids the READ_ONCE().
Right, that's what I did in this patch.

But for the places where it's sometimes called under rtnl_lock() only and
sometimes called under rcu_read_lock() only, like tipc_udp_is_known_peer()
and tipc_udp_rcast_add(), I kept rcu_dereference_rtnl(). makes sense?
