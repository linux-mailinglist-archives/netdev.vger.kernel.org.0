Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C07F40A381
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 04:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbhINCWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 22:22:39 -0400
Received: from out1.migadu.com ([91.121.223.63]:62342 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236565AbhINCWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 22:22:37 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1631586079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QoLIOI/r8M2fowTTekfDxFkvj7NLl9iwu+uZKG1Y57M=;
        b=EO/va6LXViFeaWJSXt7yLDpgRcXFpmXCBuB22n7/SLVd4pSgdfDwUi+LcGBsEBnK7kWewd
        kWmpLe/ZGdjY2Pd/N1wqMKQodXIMAX6msmhybg/9+J1ABCpGqyUDExozM8pJSWuRYHyHP3
        H5CgBCnzKtjtCGGr7L0Xdr5CiO79MR4=
Date:   Tue, 14 Sep 2021 02:21:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <2a95994f251db7d1c5d3318f4468b324@linux.dev>
Subject: Re: [PATCH] Revert "ipv4: fix memory leaks in ip_cmsg_send()
 callers"
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     "David Miller" <davem@davemloft.net>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "netdev" <netdev@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
In-Reply-To: <CANn89iKsbdMV1JmjzzGNu-2janfudb-t-Le-JempLrroJcNH-Q@mail.gmail.com>
References: <CANn89iKsbdMV1JmjzzGNu-2janfudb-t-Le-JempLrroJcNH-Q@mail.gmail.com>
 <20210913040442.2627-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

September 14, 2021 12:15 AM, "Eric Dumazet" <edumazet@google.com> wrote:=
=0A=0A> On Sun, Sep 12, 2021 at 9:04 PM Yajun Deng <yajun.deng@linux.dev>=
 wrote:=0A> =0A>> This reverts commit 919483096bfe75dda338e98d56da91a2637=
46a0a.=0A>> =0A>> There is only when ip_options_get() return zero need to=
 free.=0A>> It already called kfree() when return error.=0A>> =0A>> Fixes=
: 919483096bfe ("ipv4: fix memory leaks in ip_cmsg_send() callers")=0A>> =
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>=0A>> ---=0A> =0A> I do n=
ot think this is a valid patch, not sure why David has merged so=0A> soon=
 before us reviewing it ?=0A> =0A> You are bringing back the memory leaks=
.=0A> =0A> ip_cmsg_send() can loop over multiple cmsghdr()=0A> =0A=0AYes,=
 I forgot the loop, it was my mistake.=0A=0A> If IP_RETOPTS has been succ=
essful, but following cmsghdr generates an error,=0A> we do not free ipc.=
ok=0A> =0A> If IP_RETOPTS is not successful, we have freed the allocated =
temporary space,=0A> not the one currently in ipc.opt.=0A> =0A> Can you s=
hare what your exact finding was, perhaps a syzbot repro ???=0A> =0A> Tha=
nks.
