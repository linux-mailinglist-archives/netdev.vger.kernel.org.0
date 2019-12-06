Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85404114B80
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 04:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLFDul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 22:50:41 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38710 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLFDul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 22:50:41 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so2629247pfc.5
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 19:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uV+1XBD6BJSPspyjSaABwF1kONPP1IZSCF+Qrd/s9Ig=;
        b=nLyAtT5uG3U1yciG3ITt2Ptl15ulMiAL9IZo6uBq7pnU7OJRAK8m0r3ar/YDtqPI4a
         Yj+RrV3T+/6kWx8QJsXkCe8ERKazQnpoaGuM4+5Gy7nfTELUTPmk8zCTW/Eww6PVr8JI
         y7Bkn8axi6T60jLeB4yf8igJ/abEGYMxVvEhIe7QYsrl//spkkmMGVYsdDhEgEb7q28m
         NTk6R3UBJm41h/1FYG12JR59BF7r8Ke47K9VAcDm08W6gx6GdCt26mxdRGeO6/oSsa7E
         FkjWoCaw50IkCLWua+ClkIePaQsIcAacg57cKvAIM0gL1fzQIyEQAJJnQtJFTFTwP82Y
         Tshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uV+1XBD6BJSPspyjSaABwF1kONPP1IZSCF+Qrd/s9Ig=;
        b=r4FqUgcm3tPI1GO57YxeZE7wrCdGNa9X9vUAMHdg7mxSHCCQexuw57jmj61QnQFHVX
         qTDlofbX0ieaQRnFvnM9Ir8ll/3l0EAUayiFn4x8v4oLl9B88Ts/o2g3Sk/DbCNk2df+
         7fgZMqhboQrIkU3DWyjucDkTb9r5RyzwvcEIWk7ReSUUQA33rO/Thtoxv6oohDRtVRgC
         bv04pQ1tixIWrK4GfT8LEcoI12DFDElMI0pVwgp8M0cTL+jXE/LYdhLd7SVqd7Zo6RY7
         Jp5zu1xyAX0e4hcmTxX1QtrAWE0NPaJI0MztY/p3Pqe+1dmjagNKj2mtSS5+NfhseACQ
         pVkg==
X-Gm-Message-State: APjAAAWdtiiyy3MhtFWa3UWig4RzOxcJ75nGOBnOx5+5spYVNgCgQWzs
        0ZklKFLxULKNBjO8lho9dqY=
X-Google-Smtp-Source: APXvYqyMbE4qAhsKixh4pGFGj26OrtM7rWUjkcEY9+QKPw59xHmNFWghEBcTgyXzAoUnkb9S7reFhQ==
X-Received: by 2002:a65:6842:: with SMTP id q2mr1216815pgt.345.1575604240967;
        Thu, 05 Dec 2019 19:50:40 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n12sm12459908pgb.32.2019.12.05.19.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 19:50:40 -0800 (PST)
Subject: Re: [PATCH net v3 3/3] tcp: Protect accesses to .ts_recent_stamp with
 {READ,WRITE}_ONCE()
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
References: <cover.1575595670.git.gnault@redhat.com>
 <6473f122f953f6b0bf350ace584a721d0ae02ef6.1575595670.git.gnault@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <27c9579d-634d-99c9-689c-65e3f4a2b296@gmail.com>
Date:   Thu, 5 Dec 2019 19:50:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <6473f122f953f6b0bf350ace584a721d0ae02ef6.1575595670.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/19 5:50 PM, Guillaume Nault wrote:
> Syncookies borrow the ->rx_opt.ts_recent_stamp field to store the
> timestamp of the last synflood. Protect them with READ_ONCE() and
> WRITE_ONCE() since reads and writes aren't serialised.
> 
> Fixes: 264ea103a747 ("tcp: syncookies: extend validity range")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>

To be fair, bug was there before the patch mentioned in the Fixes: tag,
but we probably do not care enough to backport this to very old kernels.
