Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDF8CDFC3E
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 05:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387508AbfJVDfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 23:35:17 -0400
Received: from f0-dek.dektech.com.au ([210.10.221.142]:32774 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387437AbfJVDfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 23:35:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 29ACD4969F;
        Tue, 22 Oct 2019 14:35:13 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-language:x-mailer:content-transfer-encoding
        :content-type:content-type:mime-version:message-id:date:date
        :subject:subject:in-reply-to:references:from:from:received
        :received:received; s=mail_dkim; t=1571715313; bh=nIYkkU5MLtaDCy
        NKKvznch9lUcyVDVunNRYLY/3sYnY=; b=MnN5zyQYcOnCcshrs9reAorfRTRoK4
        Ng0Ac+QHt9krcr6Tl2K9Ot+bzkGolDeD8nQy/mMt5ByijlEH9+wsg9DauzXWd7kw
        cCmImjImdPvlXz32KJSF0Y7gBlEJLJj1vnIKl7IOhytHmzg94UPfKluM1R0fziWJ
        Vk1udZtJ+lkfA=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 769LCdGsZrx9; Tue, 22 Oct 2019 14:35:13 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 0A17249D89;
        Tue, 22 Oct 2019 14:35:12 +1100 (AEDT)
Received: from VNLAP298VNPC (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id A49124969F;
        Tue, 22 Oct 2019 14:35:11 +1100 (AEDT)
From:   "Hoang Le" <hoang.h.le@dektech.com.au>
To:     "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        <jon.maloy@ericsson.com>, <maloy@donjonn.com>,
        <tipc-discussion@lists.sourceforge.net>, <netdev@vger.kernel.org>
References: <20191022022036.19961-1-hoang.h.le@dektech.com.au> <88e00511-ae7f-cbd3-46b1-df0f0509c04e@gmail.com>
In-Reply-To: <88e00511-ae7f-cbd3-46b1-df0f0509c04e@gmail.com>
Subject: RE: [net-next] tipc: improve throughput between nodes in netns
Date:   Tue, 22 Oct 2019 10:33:56 +0700
Message-ID: <004401d58889$8a3ba740$9eb2f5c0$@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIBGTi9TYT/dH44O8HREmWnQKht0AJdjXoypvvwHSA=
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

Thanks for quick feedback.
See my inline answer.

Regards,
Hoang
-----Original Message-----
From: Eric Dumazet <eric.dumazet@gmail.com>=20
Sent: Tuesday, October 22, 2019 9:41 AM
To: Hoang Le <hoang.h.le@dektech.com.au>; jon.maloy@ericsson.com; =
maloy@donjonn.com; tipc-discussion@lists.sourceforge.net; =
netdev@vger.kernel.org
Subject: Re: [net-next] tipc: improve throughput between nodes in netns


On 10/21/19 7:20 PM, Hoang Le wrote:
>  	n->net =3D net;
>  	n->capabilities =3D capabilities;
> +	n->pnet =3D NULL;
> +	for_each_net_rcu(tmp) {

This does not scale well, if say you have a thousand netns ?
[Hoang] This check execs only once at setup step. So we get no problem =
with huge namespaces.

> +		tn_peer =3D net_generic(tmp, tipc_net_id);
> +		if (!tn_peer)
> +			continue;
> +		/* Integrity checking whether node exists in namespace or not */
> +		if (tn_peer->net_id !=3D tn->net_id)
> +			continue;
> +		if (memcmp(peer_id, tn_peer->node_id, NODE_ID_LEN))
> +			continue;
> +
> +		hash_chk =3D tn_peer->random;
> +		hash_chk ^=3D net_hash_mix(&init_net);

Why the xor with net_hash_mix(&init_net) is needed ?
[Hoang] We're trying to eliminate a sniff at injectable discovery =
message.=20
Building hash-mixes as much as possible is to prevent fake discovery =
messages.

> +		hash_chk ^=3D net_hash_mix(tmp);
> +		if (hash_chk ^ hash_mixes)
> +			continue;
> +		n->pnet =3D tmp;
> +		break;
> +	}


How can we set n->pnet without increasing netns ->count ?
Using check_net() later might trigger an use-after-free.

[Hoang] In this case, peer node is down. I assume the tipc xmit function =
already bypassed these lines.

