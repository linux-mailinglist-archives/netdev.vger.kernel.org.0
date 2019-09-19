Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4774B7ABF
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 15:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390506AbfISNqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 09:46:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46524 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390501AbfISNqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 09:46:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so1923234pgm.13
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 06:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xT/Ac22RP7xQJF3vYZ5r8xP7sJ8V+g3GXS0E2MweKOw=;
        b=ruUqoj6tXfnU8R9nTgl76wsmwKCll2un9hl3caw20hNI/0Gy/S9wl6REFe2RhzF3Sh
         13d8HWsrivHa5y9YP0XEHYpyvbIdCRz9EiDEa+eb3egnjL1+gy5olYV5mrZ+WNKHi6VG
         JlbaUAg5yB/kIOrxBpktf9RKi2Wer7e5InqSGg9PYz1UEI8KoX532oAUrcQIJoIo4w3W
         MPYuqGpKcYuO+mx6+rDMzXpBTTSw0+7JmrTHqNCuvJqtySzuOw7iETTVGNTwEw/NhyFR
         Vt3YU4Co8tyKuy1A85dLP4TAxKuo1ppPyCKlRQtjllabK5bzGjXW0fLdznD+2tGzzSGw
         tu8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xT/Ac22RP7xQJF3vYZ5r8xP7sJ8V+g3GXS0E2MweKOw=;
        b=YjSkcEGju6Y/yQ92rUmZ1NzMFx8QJ77CLjUHPPcQwrfcaaW5f+wr+8EfWgOeyIO3W9
         wCT7kECeB1Tjcq/ONJoNExO/fm7qvBVD2blDmUCx0jYS5TBMUxiBc7DTYs2cEWAmBLsu
         Ar3m8A6/14H3KAc+iooeyodG89t9zMeloyiGalQHUkO5QCW8agvXgvu0AGOOC9VZBlsA
         qhT2hwX1B+Ivjt6Z1mWo5PTLaXhap5XT4TJi2bhKshRTaHSOq87aOWWvvJNZc9CZ/PFb
         Lmmsn3O0ooWWYzRBMks1AX55xWH3DV/+mtPlTxDm21n5Vd/zTPFXsEKPKQCPm/y8Oo3l
         mTXg==
X-Gm-Message-State: APjAAAVyRGto4wGTr4ggqOJdOV60GCqSzWb++SQJN0V/CuObF3pbxoUz
        mfn791Ur/3MvxUoRYex7xuhQqK0A
X-Google-Smtp-Source: APXvYqz8B1IZwrUm/PJmEHupUDk2t4S6wRQLOa6u099jjpM8Ne4a83gye+tnOHWrqWLINNl/xn3VqA==
X-Received: by 2002:aa7:910c:: with SMTP id 12mr7659515pfh.166.1568900764411;
        Thu, 19 Sep 2019 06:46:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id h15sm9424652pgn.76.2019.09.19.06.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2019 06:46:02 -0700 (PDT)
Subject: Re: [PATCH net-next] tcp: force a PSH flag on TSO packets
To:     Or Gerlitz <gerlitz.or@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@mellanox.com>
References: <20190910214928.220727-1-edumazet@google.com>
 <CAJ3xEMhh=Ow-fZqnPtxUyZsCN89dRmy=NcaO+iK+iZZYBdZbqA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cd1cce3d-faf5-d35b-7fd4-a831561eea14@gmail.com>
Date:   Thu, 19 Sep 2019 06:46:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMhh=Ow-fZqnPtxUyZsCN89dRmy=NcaO+iK+iZZYBdZbqA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/19/19 5:17 AM, Or Gerlitz wrote:
> On Wed, Sep 11, 2019 at 12:54 AM Eric Dumazet <edumazet@google.com> wrote:
>> When tcp sends a TSO packet, adding a PSH flag on it
>> reduces the sojourn time of GRO packet in GRO receivers.
>>
>> This is particularly the case under pressure, since RX queues
>> receive packets for many concurrent flows.
>>
>> A sender can give a hint to GRO engines when it is
>> appropriate to flush a super-packet, especially when pacing
> 
> Hi Eric,
> 
> Is this correct that we add here the push flag for the tcp header template
> from which all the tcp headers for SW GSO packets will be generated?
> 
> Wouldn't that cause a too early flush on GRO engines at the receiver side?


If a TSO engine is buggy enough to add the PSH on all the segments, it needs
to be fixed urgently :)

