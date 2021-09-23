Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6144416178
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241707AbhIWOzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241662AbhIWOzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 10:55:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 052C661164;
        Thu, 23 Sep 2021 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632408859;
        bh=cDYIHzx+A+P/v15KMNuG+QBQAKo26pEebxqT0B2AfIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P6StIFET5ov50rR6GFyncy906qk/8LqRLyiJhdsSxC4NJFJQSwhWR6PQXgnJe/oSY
         Iu2dk12R38lcghr8RmPwzwerNnAYeMLiLfEvvk3aMhXyG2x2ouyuPg84kieRFuvB7/
         Ig392oXjtKhQW9HnFIGKgJXcvUagSpxWZzZIWI1SRnErm8u7NdaRlK8si5i/cPQfnC
         9Cy7KslkPMlEwdKyjpYlFqNduuJ7CRlUmO+MNS1jv8pRun9Zr8cjDpkaLD3mvZT+ej
         5P1PgmxPp1n45qdfA0C/72EpNrJX3MVBsiaQDvm5mBZRospu13dSqcm4uglv4n7uGe
         KhUaJcbcYAJpg==
Date:   Thu, 23 Sep 2021 07:54:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, linyunsheng@huawei.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        Wei Wang <weiwan@google.com>
Subject: Re: [PATCH net v2] napi: fix race inside napi_enable
Message-ID: <20210923075418.6f120bac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1632404456.506512-1-xuanzhuo@linux.alibaba.com>
References: <20210923061417.049df44d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1632404456.506512-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Sep 2021 21:40:56 +0800 Xuan Zhuo wrote:
> On Thu, 23 Sep 2021 06:14:17 -0700, Jakub Kicinski <kuba@kernel.org> wrot=
e:
> > > I think it should be an atomic operation. The original two-step clear=
 itself is
> > > problematic. So from this perspective, it is not just a solution to t=
his
> > > problem. =20
> >
> > [resending, my MUA seems to have corrupted the CC list previously]
> >
> > Can you show what breaks by it being non-atomic? =20
>=20
> Isn't the problem this time caused by non-atoms?
>=20
> Of course, in response to this problem, adjusting the order seems to be a=
ble to
> solve this problem. Compared to changing to atomic operations, we have to=
 test
> other problems that may be caused by modifying this order.
>=20
> Relatively speaking, the use of atoms is a relatively simple way of proce=
ssing.

Whether atomics are simple or not is not the question.

What I'm saying is that having asymmetric enable and disable paths
is fragile.

> > Because, again, the disable part is not atomic. Either it's needed on
> > both sides or it's not needed on either. =20
>=20
> For the disable part, I think it=E2=80=99s okay not to use atoms. Have yo=
u considered
> any special scenarios?

The point is both sides should do the same thing.
