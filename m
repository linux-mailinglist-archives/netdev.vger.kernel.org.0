Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39825E0A95
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732215AbfJVR23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:28:29 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43932 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731893AbfJVR23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:28:29 -0400
Received: by mail-pl1-f193.google.com with SMTP id v5so3939846ply.10;
        Tue, 22 Oct 2019 10:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cuy7rm01bS2uzKpuJkB6ZeWcPvBBR+3UcGaSjYaEpcU=;
        b=ec0zUAItUL6RJ2RVYfJvwoEYOfMW0BhKGxEksvTfGQOfKzVufjUm0yCHY6K1A5lz/f
         9k1D5XfWvjvvfU6Ex237n0yfmbvyeXD+jwHKajOMXrpywTG2v4W7l5vrTQdrOlU13uDo
         hzTe+fhaGD/M2dlCVv7qHcUH72eNBL1UKF3XQta/AZUyZmt7opJ+9fmIDpZaneswO/Jn
         KdLHCUMqwmdWcKQTww4rGB4ACqVe6WzJroJFheMWeUWVRgVit95Ao611pLbumD3Ogd+H
         8rY2IenfZwffNmLm19SyqejPCx45vH8NKTPQIXlpoN3b+Yf+Z8CLwjVHqho2Wa5ezo0j
         mklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cuy7rm01bS2uzKpuJkB6ZeWcPvBBR+3UcGaSjYaEpcU=;
        b=IqxtCjt2ZlWPtesJ3p1ooJumy5493aoo/Pcux5J+xrrZuqpsILAyo9hR8nRcX1wU8x
         QrDf/W9xNdl/s8PWYxBlByMztleA1x9UkVx4ZFEvZIexRR/wh17kcw+3wBi2LIy1iRd1
         KvWGMTdxCBrXlT4ZXZqcChiQ6wVp5loque/mPJ+g6zK2PEcDDmRSOtcZpWV64NvfDOy5
         N1xKxGp9oayy0Rx64zfGK/4tjniqK87l3W1VtX79YOeVIauFcaDdJEBCwcUY6q6RK/vZ
         euhSMDPtxwq47KHpuoHExx1nxe1jMLTfkFv42up7mtAxdBQ3NKxJ3mMXgYQ+dZTHlkDL
         IBnA==
X-Gm-Message-State: APjAAAWuClfuOmjdR/NtfUMIEYHycqXYobpo4T4W2wJxhLehnd1uMIr7
        1gpOY4O+w7zQtjX70n/8bfH2Ue2S
X-Google-Smtp-Source: APXvYqyslXSZO3TgmoOzqcBlon/yueY8YrAeZokRMwywOrqncUQmnFAguKWe1O6Wgvga361fBSgS7w==
X-Received: by 2002:a17:902:b196:: with SMTP id s22mr5157905plr.10.1571765308381;
        Tue, 22 Oct 2019 10:28:28 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id o9sm24848204pfp.67.2019.10.22.10.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 10:28:27 -0700 (PDT)
Subject: Re: [PATCH v2] net: sch_generic: Use pfifo_fast as fallback scheduler
 for CAN hardware
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Vincent Prince <vincent.prince.fr@gmail.com>, jiri@resnulli.us,
        jhs@mojatatu.com, netdev@vger.kernel.org, dave.taht@gmail.com,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        xiyou.wangcong@gmail.com, davem@davemloft.net
References: <20190327165632.10711-1-mkl@pengutronix.de>
 <1571750597-14030-1-git-send-email-vincent.prince.fr@gmail.com>
 <84b8ce24-fe5d-ead0-0d1d-03ea24b36f71@pengutronix.de>
 <20191022094254.489fd6a4@hermes.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b810b1b7-de82-a6ac-f063-5ee8a6460962@gmail.com>
Date:   Tue, 22 Oct 2019 10:28:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022094254.489fd6a4@hermes.lan>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/22/19 9:42 AM, Stephen Hemminger wrote:

> Why not fix fq_codel to return the same errors as other qdisc?
> 

I believe the same problem would happen with any qdisc not doing tail drops.

Do we really want to enforce all qdisc to have a common drop strategy ?

For example, FQ could implement a strategy dropping the oldest packet in the queue,
which is absolutely not related to the enqueue order.


