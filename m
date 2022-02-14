Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05E64B5CF0
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiBNVgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 16:36:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiBNVgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 16:36:22 -0500
Received: from asav22.altibox.net (asav22.altibox.net [109.247.116.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A300264E;
        Mon, 14 Feb 2022 13:36:12 -0800 (PST)
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav22.altibox.net (Postfix) with ESMTPSA id C911720ABA;
        Mon, 14 Feb 2022 20:41:30 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:8b0a:1e21:3a05:ad2e:f4a6])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 21EJfTgO1593270
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 14 Feb 2022 20:41:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1644867690; bh=f1bJ8BpayZ0fg7tiRGb7wnhGZdnUpYC6JOyEs5BI+cI=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=P5Icis/ry5VGUZ4tjBPpybxe7wmyG8GNPw+6iBz/98iM6ABt0camkNmIQa1jqqLoS
         bVyDOxOCDr3bb/xEIldqaCPsJPfQK1/vsWxTNZK/xlChUNjkIRs3RXKBqkH8bzISr9
         pNiO1JuxwD8HcldFXN7jk/tZZhOwY+Dkn5x3CyFw=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1nJhDw-002zfI-AY; Mon, 14 Feb 2022 20:41:24 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Hans Petter Selasky <hps@selasky.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] CDC-NCM: avoid overflow in sanity checking
Organization: m
References: <20220210155455.4601-1-oneukum@suse.com>
        <a9143724-51ca-08ea-588c-b849a4ba7011@selasky.org>
        <87v8xmocng.fsf@miraculix.mork.no>
        <3624a7e7-3568-bee1-77e5-67d5b7d48aa6@selasky.org>
        <YgXByzVayvl3KJTS@rowland.harvard.edu>
        <87k0e1oory.fsf@miraculix.mork.no>
        <393ec81c-52b4-842b-1ecd-4ffc29743665@suse.com>
Date:   Mon, 14 Feb 2022 20:41:24 +0100
In-Reply-To: <393ec81c-52b4-842b-1ecd-4ffc29743665@suse.com> (Oliver Neukum's
        message of "Mon, 14 Feb 2022 20:30:02 +0100")
Message-ID: <87ilthgrrv.fsf@miraculix.mork.no>
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
        a=iox4zFpeAAAA:8 a=vnZxo784lF8ceAtbtwQA:9 a=QEXdDO2ut3YA:10
        a=NUbFQnZVmvsA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> writes:

> Do we still agree that unsigned integers are the better option?

Yes.  What Alan said made perfect sense.  As always.


Bj=C3=B8rn
