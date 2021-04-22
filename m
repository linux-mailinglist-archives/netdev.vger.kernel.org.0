Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E51A3681D8
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbhDVNvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:51:10 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:39981 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236236AbhDVNvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 09:51:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619099435; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=XwhPh738afT0XtUTkLSfNf4BglrM20PtCnb4uR8+91s=; b=TNTYCDNFK1auCLwATeiCje66Il7OUZoOCRKqjoH2MyJETayeF7rK+BnN9aJyjhBDF4+My7v+
 MzkMhPlH9hNe9NvQxF+9a+bltOkMbezA7JcHGmFZL0e+VsqxpanKC3km3cWLLWqtRhxQY6XG
 wcAOVsV3nEstbget7+2jAayK5Zg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60817f1887ce1fbb565adb1e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 22 Apr 2021 13:50:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E35E7C4323A; Thu, 22 Apr 2021 13:50:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4A259C433D3;
        Thu, 22 Apr 2021 13:50:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4A259C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()
References: <20210402122653.24014-1-pali@kernel.org>
Date:   Thu, 22 Apr 2021 16:50:11 +0300
In-Reply-To: <20210402122653.24014-1-pali@kernel.org> ("Pali \=\?utf-8\?Q\?Roh\?\=
 \=\?utf-8\?Q\?\=C3\=A1r\=22's\?\= message
        of "Fri, 2 Apr 2021 14:26:53 +0200")
Message-ID: <87eef2jung.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Function ath9k_hw_reset() is dereferencing chan structure pointer, so it
> needs to be non-NULL pointer.
>
> Function ath9k_stop() already contains code which sets ah->curchan to val=
id
> non-NULL pointer prior calling ath9k_hw_reset() function.
>
> Add same code pattern also into ath_reset_internal() function to prevent
> kernel NULL pointer dereference in ath9k_hw_reset() function.
>
> This change fixes kernel NULL pointer dereference in ath9k_hw_reset() whi=
ch
> is caused by calling ath9k_hw_reset() from ath_reset_internal() with NULL
> chan structure.
>
>     [   45.334305] Unable to handle kernel NULL pointer dereference at vi=
rtual address 0000000000000008
>     [   45.344417] Mem abort info:
>     [   45.347301]   ESR =3D 0x96000005
>     [   45.350448]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
>     [   45.356166]   SET =3D 0, FnV =3D 0
>     [   45.359350]   EA =3D 0, S1PTW =3D 0
>     [   45.362596] Data abort info:
>     [   45.365756]   ISV =3D 0, ISS =3D 0x00000005
>     [   45.369735]   CM =3D 0, WnR =3D 0
>     [   45.372814] user pgtable: 4k pages, 39-bit VAs, pgdp=3D00000000068=
5d000
>     [   45.379663] [0000000000000008] pgd=3D0000000000000000, p4d=3D00000=
00000000000, pud=3D0000000000000000
>     [   45.388856] Internal error: Oops: 96000005 [#1] SMP
>     [   45.393897] Modules linked in: ath9k ath9k_common ath9k_hw
>     [   45.399574] CPU: 1 PID: 309 Comm: kworker/u4:2 Not tainted 5.12.0-=
rc2-dirty #785
>     [   45.414746] Workqueue: phy0 ath_reset_work [ath9k]
>     [   45.419713] pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=3D--)
>     [   45.425910] pc : ath9k_hw_reset+0xc4/0x1c48 [ath9k_hw]
>     [   45.431234] lr : ath9k_hw_reset+0xc0/0x1c48 [ath9k_hw]
>     [   45.436548] sp : ffffffc0118dbca0
>     [   45.439961] x29: ffffffc0118dbca0 x28: 0000000000000000
>     [   45.445442] x27: ffffff800dee4080 x26: 0000000000000000
>     [   45.450923] x25: ffffff800df9b9d8 x24: 0000000000000000
>     [   45.456404] x23: ffffffc0115f6000 x22: ffffffc008d0d408
>     [   45.461885] x21: ffffff800dee5080 x20: ffffff800df9b9d8
>     [   45.467366] x19: 0000000000000000 x18: 0000000000000000
>     [   45.472846] x17: 0000000000000000 x16: 0000000000000000
>     [   45.478326] x15: 0000000000000010 x14: ffffffffffffffff
>     [   45.483807] x13: ffffffc0918db94f x12: ffffffc011498720
>     [   45.489289] x11: 0000000000000003 x10: ffffffc0114806e0
>     [   45.494770] x9 : ffffffc01014b2ec x8 : 0000000000017fe8
>     [   45.500251] x7 : c0000000ffffefff x6 : 0000000000000001
>     [   45.505733] x5 : 0000000000000000 x4 : 0000000000000000
>     [   45.511213] x3 : 0000000000000000 x2 : ffffff801fece870
>     [   45.516693] x1 : ffffffc00eded000 x0 : 000000000000003f
>     [   45.522174] Call trace:
>     [   45.524695]  ath9k_hw_reset+0xc4/0x1c48 [ath9k_hw]
>     [   45.529653]  ath_reset_internal+0x1a8/0x2b8 [ath9k]
>     [   45.534696]  ath_reset_work+0x2c/0x40 [ath9k]
>     [   45.539198]  process_one_work+0x210/0x480
>     [   45.543339]  worker_thread+0x5c/0x510
>     [   45.547115]  kthread+0x12c/0x130
>     [   45.550445]  ret_from_fork+0x10/0x1c
>     [   45.554138] Code: 910922c2 9117e021 95ff0398 b4000294 (b9400a61)
>     [   45.560430] ---[ end trace 566410ba90b50e8b ]---
>     [   45.565193] Kernel panic - not syncing: Oops: Fatal exception in i=
nterrupt
>     [   45.572282] SMP: stopping secondary CPUs
>     [   45.576331] Kernel Offset: disabled
>     [   45.579924] CPU features: 0x00040002,0000200c
>     [   45.584416] Memory Limit: none
>     [   45.587564] Rebooting in 3 seconds..
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> Cc: stable@vger.kernel.org

In what scenarios do you see this bug? Please describe the use case to bett=
er
understand when and how this happens. I guess this is a rare problem as nob=
ody
else has reported it?

I can add that info to the commit log.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
