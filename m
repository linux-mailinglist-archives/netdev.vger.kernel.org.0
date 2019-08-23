Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8F8E9B1D8
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 16:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395203AbfHWOYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 10:24:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35281 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732212AbfHWOYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 10:24:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so5676996plb.2
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 07:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=Dx4OxjkwIl1OkvlS3GG0aUCR5vpj/3I3WD3unWVJozI=;
        b=QE2pl+nQhBqrVeM8gAu7UeSEDnTI1NwB9swwrM3nSJHFgiUGpritQ2NCXSHU97Vbvf
         grbZ1kpEHw+WeFf+O1FuAaCtgR/mmm/lhMHvrai5+eQTuh1KgZQReqTg2goHUncXGaiE
         7gh+nZ3GGB08/szj3oWascc1gC+dLx21yaTmrWLmLFS8m/uA4i9ILKb5+y41vE35fRZb
         dklPPj015dIdp1mO02vUD8VaeHL8NZYTDAVnUmi1AgDmqB8rLhOBrE6UH0wfEf3zwWHf
         DYDu5UTh7X1PzpJECyWIbRqkZQlQNoYO8RQNufKByXjpPUXwvmksKhsgYDBKwJM9iZgt
         N86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=Dx4OxjkwIl1OkvlS3GG0aUCR5vpj/3I3WD3unWVJozI=;
        b=VOPYNn8EruV9u8IUh1iVxoLNdv2js5oEYoEH8/sbADcjAcMz5SVpgudEUmfiTjFPmd
         xPGydGqxOppbfubZI0mAcx2qRrSdNfH1O8KlYxAP+zFS469KDJJ+MojXITXmDa0QUGQF
         8ERhtDDJkCzmi46k8zHDmEYesgzw/hdUPIx0K+d5NOKlRMxfO8mAG5kA9gZplSi/tz51
         IpNRWbcHYVCfWmP18jJGJBTIlE3kBOXUCuWIqWZ+B9ix4gr3+WmWxrLk8fJe+pdaMVvd
         84kUAQMJHWmdFCL+gituNA8nUKUEbreNRYXa2AzaDVg/z/CN9pOvF5gzgDFO4iTgh6ia
         spWQ==
X-Gm-Message-State: APjAAAUP41W2hG/dSTwJfmnkO03jrvrQPMMdLoqkoZ2cQPlBuCdChG/O
        EYSMAJqRpZawOz7fnvWAqx12UN0V
X-Google-Smtp-Source: APXvYqwVRGfIYj2QMndJPNGqUKhMvQvLKeld3KsFnY8LZZ91bk++q9HRaY6qe9L+1do9OHRUIcjVmg==
X-Received: by 2002:a17:902:a981:: with SMTP id bh1mr4197269plb.236.1566570276310;
        Fri, 23 Aug 2019 07:24:36 -0700 (PDT)
Received: from [172.26.99.184] ([2620:10d:c090:180::b6f7])
        by smtp.gmail.com with ESMTPSA id ev3sm17073026pjb.3.2019.08.23.07.24.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 07:24:35 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Michael Chan" <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        kernel-team <kernel-team@fb.com>
Subject: Re: [PATCH net-next] bnxt_en: Fix allocation of zero statistics block
 size regression.
Date:   Fri, 23 Aug 2019 07:24:34 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <DDE3237E-CABF-4417-AB26-3623A7CEF9DE@gmail.com>
In-Reply-To: <1566539501-5884-1-git-send-email-michael.chan@broadcom.com>
References: <1566539501-5884-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Aug 2019, at 22:51, Michael Chan wrote:

> Recent commit added logic to determine the appropriate statistics 
> block
> size to allocate and the size is stored in bp->hw_ring_stats_size.  
> But
> if the firmware spec is older than 1.6.0, it is 0 and not initialized.
> This causes the allocation to fail with size 0 and bnxt_open() to
> abort.  Fix it by always initializing bp->hw_ring_stats_size to the
> legacy default size value.
>
> Fixes: 4e7485066373 ("bnxt_en: Allocate the larger per-ring statistics 
> block for 57500 chips.")
> Reported-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Tested-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Thanks, Michael!
-- 
Jonathan
