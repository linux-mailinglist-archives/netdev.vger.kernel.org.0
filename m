Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291FB1C5C8A
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgEEPun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729791AbgEEPum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:50:42 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73923C061A0F;
        Tue,  5 May 2020 08:50:41 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q24so561357pjd.1;
        Tue, 05 May 2020 08:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=JCrj+xSNWBgnwkluYH5yEj5tGeDPbhNC0cOOAJmWsIw=;
        b=dLgjlrJiG1l7gqN/69aiOdShJzV9KUD6CqPH5jgg6I9Glx8GrbLD+r+oJBiqXNL2ri
         qKbLgBhx50Srw1bqJO4PVtSpX/AUueLxCR3/qlUjMpQTXHwy+yzQsEoTOs0Y31SsiCM3
         kt3OUD4zkRiD27wXNRjXSRGro7/wekhe5W16MW9d3nB0oJCR5i6u5IpHRhS7AhVwh+cQ
         A4xLE7LbgDpcsKzt9WxS2z0+E9/fQy4p3QyXVJOrjqrsgerRFQn+gxwDKp7nob6Fvv4s
         ag8zuUDd8N8eV6bB9GFKFaAyom3ExodeY2u373oIyKLB4y6ZephmlYR4m49Z/eSi5mEB
         G7jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=JCrj+xSNWBgnwkluYH5yEj5tGeDPbhNC0cOOAJmWsIw=;
        b=QsNzIfq0tb0VQRCTwqW8WYP4KvFqLfhu/qcRHyj54q1DsWHaGig5c4kiynakC+NKJF
         lRNyqllgwJRFf9M+fMTCG3kU4EYDgGlo9Umrfo8ijs7DB254p9Li8Tz3o1yHe9LftJHd
         qdD4+Lp1ItiPtxgJRyYH6asKbVBgWw/azJ5HRx6y+GIOFGsMtttHaYFgNGSCoybr8xbl
         gL0XlZ/h3th+bvyWj+ueS3/O+hRfLQXc5yEnnq+9f6g/TYunQEVdFZvyBCD1mjjj1vj8
         vE3o88TBzhHDcar3oxOWj0NvY6HXG0tjWkIIlnZbtLieKnp5yPcjz+njzBPOFjCztk7g
         Y/vA==
X-Gm-Message-State: AGi0PuYw2tbclJjXCe7N9HJMktbihNosLZ92mQK0L6gi727S8NGP+8e9
        okXr/CfhUQxLYQJWTCCvt/d48SqyidIaOA==
X-Google-Smtp-Source: APiQypJ454qWi/idspGEYJX34417WWKUgWzgyWzx8xGegXqIyJ8D2Mi0dVFhUi8YvDBu5nBrYloHkg==
X-Received: by 2002:a17:90a:68c1:: with SMTP id q1mr3834462pjj.35.1588693840419;
        Tue, 05 May 2020 08:50:40 -0700 (PDT)
Received: from [192.168.1.7] ([120.244.110.63])
        by smtp.gmail.com with ESMTPSA id p64sm2498102pjp.7.2020.05.05.08.50.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 08:50:39 -0700 (PDT)
To:     davem@davemloft.net, gregkh@linuxfoundation.org, kuba@kernel.org,
        christophe.jaillet@wanadoo.fr, leon@kernel.org, tglx@linutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] net: chelsio: Possible buffer overflow caused by DMA
 failures/attacks
Message-ID: <95e19362-b9c9-faf9-3f9e-f6f4c65a6aff@gmail.com>
Date:   Tue, 5 May 2020 23:50:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In alloc_rx_resources():
     sge->respQ.entries =
         pci_alloc_consistent(pdev, size, &sge->respQ.dma_addr);

Thus, "sge->respQ.entries" is a DMA value, and it is assigned to
"e" in process_pure_responses():
     struct sge *sge = adapter->sge;
     struct respQ *q = &sge->respQ;
     struct respQ_e *e = &q->entries[q->cidx];

When DMA failures or attacks occur, the data stored in "e" can be
changed at any time. In this case, the value of "e->FreelistQid"
can be a large number to cause buffer overflow when the
following code is executed:
     const struct freelQ *fl = &sge->freelQ[e->FreelistQid];

Similarly, "sge->respQ.entries" is also assigned to "e" in
process_responses():
     struct sge *sge = adapter->sge;
     struct respQ *q = &sge->respQ;
     struct respQ_e *e = &q->entries[q->cidx];

When DMA failures or attacks occur, the data stored in "e" can be
changed at any time. In this case, the value of "e->FreelistQid"
can be a large number to cause buffer overflow when the
following code is executed:
     struct freelQ *fl = &sge->freelQ[e->FreelistQid];

Considering that DMA can fail or be attacked, I think that it is 
dangerous to
use a DMA value (or any value tainted by it) as an array index or a 
control-flow
condition. However, I have found many such dangerous cases in Linux 
device drivers
through my static-analysis tool and code review.
I am not sure whether my opinion is correct, so I want to listen to your 
points of view.
Thanks in advance :)


Best wishes,
Jia-Ju Bai

