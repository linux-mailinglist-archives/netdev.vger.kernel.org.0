Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B421803F9
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCJQwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:52:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46974 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgCJQwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:52:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id c19so4460141pfo.13
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 09:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=lIYWe6Meu57Jc5mkuDU/WG8muUo8wMU16PGYuh01aso=;
        b=XVlqOUaL7v7z4nmC738kGCrygCIKT9GdMe8ATqHVSU1172zcfULzLAw9xeTaRQNHCI
         gKYe6yDCOtOj549g+MUUDcVaqnClWC807X+kBBRilho6CjB9aVH8UhZtB+f5UW1NY4Lo
         OJIBeaXpUfBL1WxDYeWBoyIu7zrXg8Dy8uY0coQRIU71VN+stRUWexYjySQ0vn5ksfZz
         h9L8rsir1fA+ArrxqmxfEVxh+WkTj0LfesuhAZjHGNXpY2sIE/g+URkOhq2JReVdqF3j
         QXotXCVuDnX0w970xt8LCuDyf3ol8bX99jX/vaHdQStrZtyu/nN1pHdD5otZlBk549ua
         oC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=lIYWe6Meu57Jc5mkuDU/WG8muUo8wMU16PGYuh01aso=;
        b=tdRVKTcfjPb8LuZgLBKQqKe7Jo0D2sGknc6U7RWNFhv2jpJSxC8GSjTiyifG3c9yV3
         TSiezRHTsMMb+UkeBltm+er1Yh7HyT7HcOjdhvc9WxpiPm9EiU9oj1InQIc4felzjTO9
         XXG1qHauDJbZffhkpwk+2P8WPZwMJupY6wE0LJwkINp1HGM4iQBRooUJbs4xm5AbjHNa
         e3srxOQzZ5xmFarMASgFBytbrQf8wvfvgPJ5rAhQ9BeFXnFygN1hPHVgisdFBNW2APWv
         aqEDNjMHHTXyxsz7a9ehbmWaNVS4pCZichEJU0FLcFBoODKAwS5CLlcqSzEOaXQbaIaz
         wtJg==
X-Gm-Message-State: ANhLgQ2fc5vtrr4GOFnNxCqm4lhG7fsOsILgTR3Fiee5R6rXTdmA0i4w
        KxQzYTGvdoJVOri0ctfbqD4=
X-Google-Smtp-Source: ADFU+vuaEfdaUnC4onXLFKV/trAhq/MUPJ1OQ1MsOYAkwJO/+YuATLOxzxQiTWocXP+BvTJs+jpi4Q==
X-Received: by 2002:a63:4453:: with SMTP id t19mr20780940pgk.381.1583859153727;
        Tue, 10 Mar 2020 09:52:33 -0700 (PDT)
Received: from [100.108.80.166] ([2620:10d:c090:400::5:e428])
        by smtp.gmail.com with ESMTPSA id 10sm26541675pfh.13.2020.03.10.09.52.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 09:52:33 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "David Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, kernel-team@fb.com
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring access.
Date:   Tue, 10 Mar 2020 09:52:31 -0700
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <5F886589-4EE7-43D7-8292-4D8CCDCDEF9E@gmail.com>
In-Reply-To: <20200309.175534.1029399234531592179.davem@davemloft.net>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
 <20200309.175534.1029399234531592179.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9 Mar 2020, at 17:55, David Miller wrote:

> From: Jonathan Lemon <jonathan.lemon@gmail.com>
> Date: Mon, 9 Mar 2020 12:49:29 -0700
>
>> netpoll may be called from IRQ context, which may access the
>> page pool ring.  The current _bh variants do not provide sufficient
>> protection, so use irqsave/restore instead.
>>
>> Error observed on a modified mlx4 driver, but the code path exists
>> for any driver which calls page_pool_recycle from napi poll.
>>
>> WARNING: CPU: 34 PID: 550248 at /ro/source/kernel/softirq.c:161 
>> __local_bh_enable_ip+0x35/0x50
>  ...
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> The netpoll stuff always makes the locking more complicated than it 
> needs
> to be.  I wonder if there is another way around this issue?
>
> Because IRQ save/restore is a high cost to pay in this critical path.

I agree with this - the proposed patch is more of a bandaid than
anything else.  Why is the entire network poll path being called
with IRQs off?  That seems wrong - while netcons is expected to
work in all cases, it does seem like it should be smarter and for
the normal case, just queue and raise NET_TX_SOFTIRQ would be a
more logical path.
-- 
Jonathan
