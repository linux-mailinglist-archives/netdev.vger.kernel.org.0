Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE564B1431
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241928AbiBJR1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:27:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242694AbiBJR1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:27:19 -0500
Received: from asav22.altibox.net (asav22.altibox.net [109.247.116.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545B3FF5;
        Thu, 10 Feb 2022 09:27:19 -0800 (PST)
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav22.altibox.net (Postfix) with ESMTPSA id 230DA21862;
        Thu, 10 Feb 2022 18:27:17 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 21AHRGoq683491
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 10 Feb 2022 18:27:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1644514036; bh=2BFFQH0UGjNwNvhN3YI5m6dajY0VCUYXP0sBZB8Qljo=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=i6M0Tg7tKPNkw5KCjUIs6YRBJoOr89n9QFHyXA+S+kwJHX4TreCvQ1Ezsqe1iwznL
         gT87NcGrIOTEjmKTzFHwGwr1PVaE/J3G6UHh+jQnbkbcrap9VEpjBGwwKDJ7rQXI2R
         zH1PkaFK65d611zQjQn8/aIeyskth+ucTLDJWfEA=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1nIDDw-002a1M-2z; Thu, 10 Feb 2022 18:27:16 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Hans Petter Selasky <hps@selasky.org>
Cc:     Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC] CDC-NCM: avoid overflow in sanity checking
Organization: m
References: <20220210155455.4601-1-oneukum@suse.com>
        <a9143724-51ca-08ea-588c-b849a4ba7011@selasky.org>
Date:   Thu, 10 Feb 2022 18:27:15 +0100
In-Reply-To: <a9143724-51ca-08ea-588c-b849a4ba7011@selasky.org> (Hans Petter
        Selasky's message of "Thu, 10 Feb 2022 17:38:44 +0100")
Message-ID: <87v8xmocng.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=KbX8TzQD c=1 sm=1 tr=0
        a=XJwvrae2Z7BQDql8RrqA4w==:117 a=XJwvrae2Z7BQDql8RrqA4w==:17
        a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=M51BFTxLslgA:10
        a=ndaoGXS1AAAA:8 a=EB4aiUh2AAAA:8 a=Q3wgNDVXShihFMjrYq0A:9
        a=QEXdDO2ut3YA:10 a=mFeOnlTyF09QQMGr2mMI:22 a=WnYytn2jUyfh9X9XNAJi:22
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hans Petter Selasky <hps@selasky.org> writes:

> "int" variables are 32-bit, so 0xFFF0 won't overflow.
>
> The initial driver code written by me did only support 16-bit lengths
> and offset. Then integer overflow is not possible.
>
> It looks like somebody else introduced this integer overflow :-(
>
> commit 0fa81b304a7973a499f844176ca031109487dd31
> Author: Alexander Bersenev <bay@hackerdom.ru>
> Date:   Fri Mar 6 01:33:16 2020 +0500
>
>     cdc_ncm: Implement the 32-bit version of NCM Transfer Block
>
>     The NCM specification defines two formats of transfer blocks: with
>     16-bit
>     fields (NTB-16) and with 32-bit fields (NTB-32). Currently only
>     NTB-16 is
>     implemented.
>
> ....
>
> With NCM 32, both "len" and "offset" must be checked, because these
> are now 32-bit and stored into regular "int".
>
> The fix you propose is not fully correct!

Yes, there is still an issue if len > skb_in->len since
(skb_in->len - len) then ends up as a very large unsigned int.

I must admit that I have some problems tweaking my mind around these
subtle unsigned overflow thingies.  Which is why I suggest just
simplifying the whole thing with an additional test for the 32bit case
(which never will be used for any sane device):

		} else {
			offset =3D le32_to_cpu(dpe.dpe32->dwDatagramIndex);
			len =3D le32_to_cpu(dpe.dpe32->dwDatagramLength);
                        if (offset < 0 || len < 0)
                                goto err_ndp;
		}

And just keep the signed integers as-is.  You cannot possible use all
bits of these anyway.

Yes, OK, that won't prevent offset +  len from becoming negative, but
if will still work when compared to the unsigned skb_in->len.



Bj=C3=B8rn
