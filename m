Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69C451F80A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 11:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbiEIJ1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 05:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237916AbiEIJS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 05:18:28 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C79C20793B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 02:14:35 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 129so7996084wmz.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 02:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zuhjKSdN+LknLeBLaF/0FJtpQWrxnv+xaPb8o+aLSrU=;
        b=t0FipPqbxlT7DLBmCEPfIIrOLQt1e8GPh90uFkOtH0vTgrdU/qVOZnHLLzNbIkPwj3
         kY/cLV9Ol9tDVpA6eaedL0sFXLCCl4dIlgvinE5HOMJ+uzDPKmPRlhUMy1w5QLoTs29R
         r5OzGtTVCN/z1bOzxEP6+lIBmBAl9GkkO1fO5XyuqZRc2NNvHIwKaTI2g8pM8TJ7E2ms
         63Qva3AMS6C04DbiejlYE3+QxGsJHFTL6NDuhcyfYVfooYET/NiPCf8xftIHoFkmuQrl
         N4SOk/GG1cX8cDGTQQcx4mHTyQdixjIuH5Stlaz92Fr5YYyUXuwVrJpGbHo5BcEK+gv4
         dj9A==
X-Gm-Message-State: AOAM532MHWLfBSNdvVFf2pP9xqboH94rFjGVOjFpHdrTWU2tx65rOm7Q
        xndAkCvQxrZXMW8s5+rgzuRyedPOeNERSZTjqhAbxdFvsgjL6R/g
X-Google-Smtp-Source: ABdhPJzivWaIFvjAdelQmqNl3uwr9Oy59wdLOHYApeJEFAaYhRMfca1KvYDOjkLtfgpHM94GV28mTLPtzGZBezmUXIc=
X-Received: by 2002:a7b:c202:0:b0:394:1e7d:af44 with SMTP id
 x2-20020a7bc202000000b003941e7daf44mr15023758wmi.139.1652087674078; Mon, 09
 May 2022 02:14:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220429223122.3642255-1-robert.hancock@calian.com>
 <20220429223122.3642255-3-robert.hancock@calian.com> <555eee6a7f6661b12de7bd5373e7835a0dc43b65.camel@calian.com>
 <7b84cace-778b-2a73-a718-94af1147698a@vaisala.com> <96fbf2e7f08912b1f80426aca981f52a4a7e7b97.camel@calian.com>
In-Reply-To: <96fbf2e7f08912b1f80426aca981f52a4a7e7b97.camel@calian.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Mon, 9 May 2022 14:44:22 +0530
Message-ID: <CAFcVECJL0PSTUxCh3LERxT1465vzdL7vAb+GxGHqL+FtmyQJgA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: macb: use NAPI for TX completion path
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tomas.melin@vaisala.com" <tomas.melin@vaisala.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

Thanks for the patch.

<snip>
>
> Originally I thought there might be a correctness issue with calling it
> unconditionally, but looking at it further I don't think there really is. The
> FreeBSD driver for this hardware also seems to always do the TX restart in the
> interrupt handler if there are packets in the TX queue.
>
> I think the only real issue is whether it's better performance wise to do it
> all the time rather than only after the hardware asserts a TXUBR interrupt. I
> expect it would be worse to do it all the time, as that would mean an extra
> MMIO read, spinlock, MMIO read and MMIO write, versus just a read barrier and
> checking a flag in memory.
>

I agree that doing TX restart only on UBR is better.

> >
> > But should there anyways be some condition for the tx side handling, as
> > I suppose macb_poll() runs when there is rx interrupt even if tx side
> > has nothing to process?
>
> I opted not to do that for this case, as it should be pretty harmless and cheap
> to just check the TX ring to see if any packets have been completed yet, rather
> than actually tracking if a TX completion was pending. That seems to be the
> standard practice in some other drivers (r8169, etc.)

In this implementation the TX interrupt bit is being cleared and TX
processing is
scheduled when there is an RX interrupt as well as vice versa. Could you please
consider using the check "status & MACB_BIT(TCOMP)" for TX interrupt and NAPI?
If I understand your reply above right, you mention that the above check is more
expensive than parsing the TX ring for new data. In unbalanced traffic
scenarios i.e.
server only or client only, will this be efficient?

Regards,
Harini
