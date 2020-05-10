Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052C31CC704
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 07:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgEJFbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 01:31:21 -0400
Received: from mout.web.de ([212.227.17.12]:57663 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgEJFbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 01:31:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589088661;
        bh=96GY/UNx9ngCinyDKUn9oPFbRbBN/SEtilAox3on5Q8=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=M4jS4J3Bqpnldz42avDZNvbEvjnoYEgEvx8zCPJihXAmfOcn+wGNwoO4Pd9A+jXrb
         IsWOGYmlsd3CjfLBGqhLfc0PgvZkonLDH4vJFaVOWTp44oA28v92I+pxtiNsNzdoVh
         qh1X2I8fM9rVfw3Jnrk8Xlj8qAWy3DOc9V28omlk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.31.72]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Ls8xf-1j7VdK2SMx-013ygD; Sun, 10
 May 2020 07:31:01 +0200
Subject: Re: [PATCH] net/sonic: Fix some resource leaks in error handling
 paths
To:     Finn Thain <fthain@telegraphics.com.au>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de>
 <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <9d279f21-6172-5318-4e29-061277e82157@web.de>
Date:   Sun, 10 May 2020 07:30:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MPKjH7w8P/U0VKpu8aODQF7SvIuL/VjgaA6h/uZv0RjvAXO90Kw
 kg7DJ7cO1IAaopvm0Msc63mBrTPxEmfKzSUHrGe4ROkIFiG46eDa39SqEHjeHGHpkF7Sx6+
 ftJObLMCzoWzEU+ukuYNQQ8HiKp70x99L/o+rVMaMO4b1jxt9au9SAeQkiCNUXGU5vpQyXd
 mCJakdh7PLIlVrIdlY9/w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jBoywigv4Nw=:d0izsBG5TbiOco44VZz1yt
 C6PvU45bkpe9UqckFRsSz5eU4lOXHKcPWtEMQlJ8J7VzxOWEHHnfRXW0Xkv4IB5Kkxjefd94y
 e6BJvDyzZ4w/xOFqkSD9wJbMwUdCF9ZaN2Nu7T1B1lt1zAJzYxn/bZ3B0IIYotcKjVWYKguTx
 hIrws8zrrwb055uKkssXRIG7ldH+A3T+mvOKgbNv0cmwnXRcIqvO6rliUK1bdUqsPIaDMilzH
 FdPlWtbxBBvvZVV3jJRCcvWpt1v4e2G5R/ecN+zOpPbG/flyGcTPwFqBpR0BaeSXltYFGkdFA
 bKov0cNTvJm3NYT59nsZhyLqb2WI+3/VshSYQHNPlYkns7mRVGY1RxQOBVt/9gDAam+KNYdv/
 G7vGLd69tumjUVU4WFQViWWtBDiyjXNkeIqz5ptMk4rAk1F9sg9ihevwkx0xbAiHqAnSp5fjA
 tp2N8zoIxtxgnH0u/JS3840fj+uY/ggzHdSK+GKmeUEZhlyyDVciDoRP8zWvGw/PxFitGEyyK
 4llz8mncQtQbDC5oujem+KywSdvZ3FKmtvNPTjeu8PE87ZCg/wiFmhTfFv07el8pfchM51pGA
 gazCip0oYbAmb3DvGuDYMPo+oT2vkl9o9J2AQL8GRNrCseMMgAViGpwdhRKQ1xGMel26hOjBZ
 71+xXorCl+YWKeGWe+swRp95uJR4VE85iahrKivYMG/egGD9C6XNWW1nD+yFkdPlbAY0cSWtN
 y7QrtQazOHE39xnFd0MtFGK5fpY/+TLHe8dCPj0CP0dquaHQeOf2GwiTbUj7IGRnLzvsw1h8Q
 y0ZV3vgl4q7oX2TQ+1PIX1Fj021i+w3Ft6hUCQjgWFXbcOyn9a70T+E5Yckvk0EnSjPn4qDgS
 WIphA4fBmW+jkt12cs61YPCuOv8pC6i1Mz4AsWp6YSCO0qh9wUK56UzFRTE0nQUOZJnnVU4xK
 weYXK6EuSCE9ugEYN2BFS01anq825jbZlsl0u0XflCC9C+Rwd+e3uPM1y9XEOPIYN5GZEUjiq
 Zt5wymohvlgvxdsi7IT5Rlyd03iyoTpSDxJFfmEgoZOXiO6LLLbO/t8AVVudu7PLDPR6h04fi
 5WTX1J9z8Z83wE5QJFf3IaOK9wfwWVRd3NsiJU0RuE/0ildPL+ql5TE1iwaRep4a8bssFu8/e
 k4mqMeDo41hdHZPlWe08MC5HjFPbeTWjPdC/PGvVHYi8dzi3kxQjcszoLNjv18CUmWC8VwAyG
 hVsoW+5rXdShKxe9D
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is there a way to add a Fixes tag that would not invoke the -stable
> process? And was that what you had in mind?

Christophe Jaillet proposed to complete the exception handling also for th=
is
function implementation.
I find that such a software correction is qualified for this tag.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3De99332e7b4cda6e60f5b5916cf=
9943a79dbef902#n183

Corresponding consequences can vary then according to the change managemen=
t
of involved developers.


> I think 'undo_probe1' is both descriptive and consistent with commit
> 10e3cc180e64 ("net/sonic: Fix a resource leak in an error handling path =
in
> 'jazz_sonic_probe()'").

I can agree to this view (in principle).

By the way:
The referenced commit contains the tag =E2=80=9CFixes=E2=80=9D.
https://lore.kernel.org/patchwork/patch/1231354/
https://lore.kernel.org/lkml/20200427061803.53857-1-christophe.jaillet@wan=
adoo.fr/


> Your suggestion, 'free_dma' is also good.

Thanks for your positive feedback.


> But coming up with good alternatives is easy.

But the change acceptance can occasionally become harder.


> If every good alternative would be considered there would be no obvious =
way
> to get a patch merged.

I imagine that some alternatives can result in preferable solutions, can't=
 they?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?id=3De99332e7b4cda6e60f5b5916cf9943a7=
9dbef902#n460

Regards,
Markus
