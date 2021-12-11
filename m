Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6DC471336
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 10:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhLKJu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 04:50:57 -0500
Received: from mout.gmx.net ([212.227.15.18]:56327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230243AbhLKJu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 04:50:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1639216232;
        bh=3RKzO9hWDYU9MudoYZeXX5RtPE5R5CVGnBOGjx6Z1Hw=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=NzoyyXd9SljeHxyoJiI5SEPoJm5nsTnAqBEzpQciHe2YtYawAAMSy1QVomCUjD9gs
         e2porgYrYb9EJYl+gLPS02HE05Lb9cMr1kw61Opy354SHhVaFuajjmrWZFJLvDR+JT
         Bt1Ci7KDjd/lG3T/4oT31VZySwThSbOw92lQzfRM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from machineone.fritz.box ([84.190.132.169]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1Mi2Nv-1mImak3dGj-00e1vZ; Sat, 11 Dec 2021 10:50:31 +0100
Message-ID: <6bcce8e66fde064fd2879e802970bb4a8f382743.camel@gmx.de>
Subject: Re: [PATCH] igc: Avoid possible deadlock during suspend/resume
From:   Stefan Dietrich <roots@gmx.de>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     kuba@kernel.org, greg@kroah.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, regressions@lists.linux.dev
Date:   Sat, 11 Dec 2021 10:50:30 +0100
In-Reply-To: <87h7bgrn0j.fsf@intel.com>
References: <87r1awtdx3.fsf@intel.com>
         <20211201185731.236130-1-vinicius.gomes@intel.com>
         <5a4b31d43d9bf32e518188f3ef84c433df3a18b1.camel@gmx.de>
         <87o85yljpu.fsf@intel.com>
         <063995d8-acf3-9f33-5667-f284233c94b4@leemhuis.info>
         <8e59b7d6b5d4674d5843bb45dde89e9881d0c741.camel@gmx.de>
         <5c5b606a-4694-be1b-0d4b-80aad1999bd9@leemhuis.info>
         <d4c9bb101aa79c5acaaa6dd7b42159fb0c91a341.camel@gmx.de>
         <87h7bgrn0j.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8LI/fKBfWWexm++YwmECNEaNPSHmv2Xe7HCv7xOa+COdilqTiKU
 M1HpihgfPOmO/dUPfvco2PYdZuRORuHEfqJw1vFKADtDVI0Uh5N7IhJ86eKKO4tVI6Fxpe/
 foJAvYzEpSmhNo3Bn5MlX7tdv45r63WecX2ByNVhyjfSNOQeos+Qsc/f2OaxXm3P+H09Sb0
 8INdOUq10Spo3g9LPcoKw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:y7OCSOtXiHU=:asm3GPDocLw8YTkJJ/9OAX
 uxR8gkHhvJ8trD6tC80Njsl3XYNie/X6fp+2V9xFNeLk8m/w0iYkbeWiZ8hNxdXKvJRkOyTfh
 xhQQWWjUpJCVPvb6Gt1J12RDpGxyvqxARcJUlqN1LkK7xT4mzpTGbj2kZvETi2cXQvx43NIBz
 Nwi/Fofn9S3G9RtRtiys6ILRXRPFYva2mCLj68z+QnkJc9EtMQbrQjWVXt3jsXkWYdTAtMV/M
 yaPCoGpGmmNdW71Uf5OCJWzGI07Fx+M82hlKy1/IpDg4hMFj4fyRJgsczP4Og+b8tmzJj+Bgk
 ER0ZxjHdCFxZ+sTwAgGO+xf9Xa0tTLk9JxpCjXJ79019Uc6n48OU4+TQ+i3Z3vcpjf3LVYHLt
 ZnyK4atXoZmtBBRzQiKJmnFEtvKH4bDBKCGGbqx8LvFcxFexIXDLjkE38jpcq+8MNLvd420Yy
 PWksk9sPR/C0gkOs+W3Vm8npWtsg53vRuVs3FW1AEd8ANYUjPjBdwBKxgpIb8KBedbrSQnrf6
 UCWHaZI+XZFmDGfFiiSli4Cw7ZpawUsPs76zXlT4hPTrByTJWMiXc5zTMZaVvOk9YEoJHiSBK
 Ox1OaexRQRCtuifXGyfR8i1Ue3x7IyjonISICNSEFH5kr/xM09D4Au9pPcgDPEn6UI/79cbwx
 2aQvxud/fYxR9fLmSlbtCl1aSiddI1VYKS9x8e6IcimnBVx7XHA6Yp7H5b9fhnButI4eacQ9I
 xuCEKgvKBoCzw/OkhwlGSB5o6Q6V2QffoWAe2rKXNbdYz7FxtRHCJo0FzpwoTYny6cD+7oI3f
 W5YKVtHHF4HBEsHFi6xc/XXEmYNQJMz1xLCV6tUjBVJpkP2o8XaxizAkU2qlBbcPl6o67T8PB
 o0gzdX3sNZTMs3hJN/gHu7lFmfJw61xM58z36Bl8NXUSBfpDSa4sUc+5RALUr6z0dJcFeWEme
 fHnJW7ptIDOfDkIbIi10sO82qAbegDK38p0DGKx2V9S5nHuZhmF62uK2ywNKNRcpgqBP4ovjo
 +32a7hvjB9VE4QFvX3PknpWFApNZlLfSPRaRgXw/D5gT5jLbZybhb8/s5gvvp3kaEQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

thanks a lot - that patch fixed it! Both "normal" shutdown as well as
ifdown/ifup are working without issues now if CONFIG_PCIE_PTM is
enabled in the kernel config.

I've done a DSL download/upload speed comparison against my current
5.14.0-19.2 and did not see any performance differences outside margin
of error. I currently have no other Linux machine I could use for iperf
but I will report if I encounter any issues.

As I am not familiar with the kernel development procedure: can you
give a rough estimate when we may expect this patch in the stable
branch?


Thanks again,
Stefan



On Fri, 2021-12-10 at 16:41 -0800, Vinicius Costa Gomes wrote:
> Hi Stefan,
>
> Stefan Dietrich <roots@gmx.de> writes:
>
> > Agreed and thanks for the pointers; please see the log files and
> > .config attached as requested.
> >
>
> Thanks for the logs.
>
> Very interesting that the initialization of the device is fine, so
> it's
> something that happens later.
>
> Can you test the attached patch?
>
> If the patch works, I would also be interested if you notice any loss
> of
> functionality with your NIC. (I wouldn't think so, as far as I know,
> i225-V models have PTM support but don't have any PTP support).
>
> > Cheers,
> > Stefan
> >
> >
> > On Fri, 2021-12-10 at 15:01 +0100, Thorsten Leemhuis wrote:
> > > On 10.12.21 14:45, Stefan Dietrich wrote:
> > > > thanks for keeping an eye on the issue. I've sent the files in
> > > > private
> > > > because I did not want to spam the mailing lists with them.
> > > > Please
> > > > let
> > > > me know if this is the correct procedure.
>
> Cheers,

