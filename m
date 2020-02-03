Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D021510E1
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgBCUTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:19:19 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34114 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgBCUTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 15:19:19 -0500
Received: by mail-qk1-f195.google.com with SMTP id g3so6998078qka.1
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 12:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=L+boqKbKcGQHWhU/kLnxNJ+iqCrMGC4AneBP/4KWpSY=;
        b=pDQjF+l7/yF9Qv9JBfBZGEywuFBC1ZID02VaidULXZr6lWYTmOcAIBckQwqKEnT153
         ud2Y3JuxGOGx1g6gPPpZzuymTWilHIF+kupZmvq4/OlzUMsnRDH+/+sMKAJxgXw9mjPQ
         8nDWxSxVAVNBPQC9eJJ39BILLDQ9FwGXOKUUP/jUKsIQ+1s4y1rHv+nfDfh3RgXZ3tc0
         Kt53QXbmh+dTzftme1dqa+HyQ6h6QufgkhZhJqNFVDVKLdqHZNA7iV1lpa29FfQMTUGa
         vrypjuyCMSRp0kzkLKddqeT4sStflPC0VODiVUYG594L0dZCxkSXpBoOj4MXKco3y398
         Evzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=L+boqKbKcGQHWhU/kLnxNJ+iqCrMGC4AneBP/4KWpSY=;
        b=MGIe6u1U/zMf06FrO4ZfcNkwOlXCRKjBcfYcn1FqtfUN7la8f4K5qtuED+S9X67F+5
         vuqZng6tyv1bTDETS4w7SYM3GAoAuGVCPiLBclYYchn8zHTzSDt3z+EUob/8iOi8ekHS
         BEOrl3Y7riXqrwYH0LnUsSOEUkaErhn3Df1jBOCywCMx7Oe+NhId9OxtbjB9wrdTQedH
         L2nEnSOdhFiVvqhqOu0QF0906GZUWgFivs7YbMMWp7K5+6ZQCekcMPsd2SAq5+saGazI
         veawMHd14RW9wBmEyWoRSm523povwvqMUZ9WTBFlx8Y4xB+m2ZzFRFs8v+HwPkQA5Jgn
         FpSQ==
X-Gm-Message-State: APjAAAUmRKfc66NTx5YLa55+Rt/xUy9bH+Tw7lMBr9yiBQYJuCniCE2b
        nstgvfUMghfglFvIdWt/vx7jIw==
X-Google-Smtp-Source: APXvYqwB3ZakEmQZz7++1OVnTHvJFGDXuohnR4zbkdM+Ni2iSGAvk7FpO3UASgkuy4CYZsYeNxMAlw==
X-Received: by 2002:a05:620a:6b6:: with SMTP id i22mr24157881qkh.301.1580761157010;
        Mon, 03 Feb 2020 12:19:17 -0800 (PST)
Received: from ?IPv6:2600:1000:b048:97ac:a93a:b890:262:8b7b? ([2600:1000:b048:97ac:a93a:b890:262:8b7b])
        by smtp.gmail.com with ESMTPSA id 199sm10041756qkj.47.2020.02.03.12.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 12:19:15 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] skbuff: fix a data race in skb_queue_len()
Date:   Mon, 3 Feb 2020 15:19:13 -0500
Message-Id: <D743FB35-3736-45E9-9DE1-8E81929D67C1@lca.pw>
References: <648d6673-bbd8-6634-0174-f9b77194ecfd@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, elver@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <648d6673-bbd8-6634-0174-f9b77194ecfd@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: iPhone Mail (17C54)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 3, 2020, at 2:42 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>=20
> We do not want to add READ_ONCE() for all uses of skb_queue_len()
>=20
> This could hide some real bugs, and could generate slightly less
> efficient code in the cases we have the lock held.

Good point. I should have thought about that. How about introducing 2 new he=
lpers.

skb_queue_len_once()
unix_recvq_full_once()

which will have a READ_ONCE() there, and then unix_dgram_sendmsg() could use=
 that instead?=
