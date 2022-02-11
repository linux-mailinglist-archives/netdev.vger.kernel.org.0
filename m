Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68AD44B1F35
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347662AbiBKHRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:17:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347638AbiBKHRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:17:42 -0500
Received: from asav21.altibox.net (asav21.altibox.net [109.247.116.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D31BB3C;
        Thu, 10 Feb 2022 23:17:41 -0800 (PST)
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav21.altibox.net (Postfix) with ESMTPSA id CCCC8800A6;
        Fri, 11 Feb 2022 08:17:38 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:c9f:8602:8cd5:a7b0:d07:d516])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 21B7HcJN995634
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 11 Feb 2022 08:17:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1644563858; bh=sERaHlF0oiT8ePD8hg3r3AyJ7ahAaofuyyRE8h6v6jA=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=oc4sL4yuY0lRBBU1MhbJARJce72mZ03Dapyso4yMwVw5TWSh5H7uCsjx4a/3LgBgp
         +9oAD4xsbL07MR6xXQTMkvO1efCTfRyisI4emNoOCwgMFMra7aYzFtdFowYEtt/dMA
         oSDFaDjlscqBLqLdWK0V+jgubPUyMBbyS+ZUaccs=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1nIQBV-002dG4-K3; Fri, 11 Feb 2022 08:17:37 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Hans Petter Selasky <hps@selasky.org>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC] CDC-NCM: avoid overflow in sanity checking
Organization: m
References: <20220210155455.4601-1-oneukum@suse.com>
        <a9143724-51ca-08ea-588c-b849a4ba7011@selasky.org>
        <87v8xmocng.fsf@miraculix.mork.no>
        <3624a7e7-3568-bee1-77e5-67d5b7d48aa6@selasky.org>
        <YgXByzVayvl3KJTS@rowland.harvard.edu>
Date:   Fri, 11 Feb 2022 08:17:37 +0100
In-Reply-To: <YgXByzVayvl3KJTS@rowland.harvard.edu> (Alan Stern's message of
        "Thu, 10 Feb 2022 20:54:19 -0500")
Message-ID: <87k0e1oory.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=Adef4UfG c=1 sm=1 tr=0
        a=XJwvrae2Z7BQDql8RrqA4w==:117 a=XJwvrae2Z7BQDql8RrqA4w==:17
        a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=M51BFTxLslgA:10
        a=nzXU3O-yQOKauYRoIKUA:9 a=QEXdDO2ut3YA:10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> First, since offset and len are initialized by converting 16- or 32-bit=20
> unsigned values from little-endian to cpu-endian, they should be=20
> unsigned themselves.
>
> Second, once they are unsigned there is obviously no point in testing=20
> whether they are < 0.
>
> Third, if you want to make sure that skb_in's buffer contains the entire=
=20
> interval from offset to offset + len, the proper tests are:
>
> 	if (offset <=3D skb_in->len && len <=3D skb_in->len - offset) ...
>
> The first test demonstrates that the start of the interval is in range=20
> and the second test demonstrates that the end of the interval is in=20
> range.  Furthermore, success of the first test proves that the=20
> computation in the second test can't overflow to a negative value.

Thanks.  That detailed explanation makes perfect sense even to me.
Adding the additional offset <=3D skb_in->len test to Oliver's patch
is sufficient and the best solution.

Only  is that the existing code wants the inverted result:

 	if (offset > skb_in->len || len > skb_in->len - offset) ...

with all values unsigned.

> IMO, working with unsigned values is simpler than working with=20
> signed values.  But it does require some discipline to ensure that=20
> intermediate computations don't overflow or yield negative values.

And there you point out my problem:  discipline :-)


Bj=C3=B8rn
