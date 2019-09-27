Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC0CC066C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbfI0NhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:37:04 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39971 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfI0NhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 09:37:03 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so1614637pfb.7;
        Fri, 27 Sep 2019 06:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1T4A7cJVny4HjoF6OxbZSvzZ4Y1UkSovrypWVv8gRbg=;
        b=SWHoTDkzvBeJqcKPvZyrZkqOXVuUR6EBz5Su5woWjy5/rlfjYqhJ2wrRV6QL49nhm/
         bmfVbWGQ80YsKhDtpdgxr2JPTeVvzmLjzo11RPLSYELKno6cG5gS39en6vGS9Ws2tI7y
         Q3teZwh7rTRO7526AepG31Ox+EfGaE91R319M/5yyI6oLyKjFsqd3567mzORAQMh2czy
         spYWVD18HN6drbWfdRn4j66y1sn1JYs4bSb8ScSeHaw2j+X7xERn4eSJHxbWA4Rikw/d
         X00ScOTt2TAIH1I3zTPkCQ039dg8kk5sOkG9lPv74ltkOD0B53ydCSqlQO1JNKKkRMS1
         Ppyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1T4A7cJVny4HjoF6OxbZSvzZ4Y1UkSovrypWVv8gRbg=;
        b=KdspHLc/kDlezNU/C1Uu/pccUT5+Bwr63GXRbQbxFJHLC2nqEP5VvBv3muB3by0Qh0
         BsBdlIlY0MWRwZ7uz+NaYpeTUFev0SvehQOGMytYVIt8QJVwNOHAC/fGd7zNkzc6ZSrw
         bCbpVPZ4C9a9yhTfctXkCDb8QFxC34waeBjJXhOh8bGs46B2cuZCUiLi9dmxpR7OSZya
         FW8XAu+oMRY7ngnAQHql5owTUKGvXLUhobcFGxxVmCc/Q0bZpZ9oHnFF2F9Qph614ypz
         X7izKYlfDA3h26WwFbtxAoCz3KI2/k6FJ3p3Jhwmg1O2BMKxYxNx+8TnKg72DWkN2/y0
         hANg==
X-Gm-Message-State: APjAAAXZ9eFQg67hBc/BxwCvDn4UGOsn7U4tc55POhUI7caj8BkNkIy4
        QlhdXg01Z+DEiUak8LqVRszm39oL
X-Google-Smtp-Source: APXvYqxUe7IKGHke3pkjd7PB0Ez46t+eLGYbvjqmLd4GYHlniOt1U8vXke2M0+FVndZs0g3h/TAyRw==
X-Received: by 2002:a65:5043:: with SMTP id k3mr9570894pgo.406.1569591422724;
        Fri, 27 Sep 2019 06:37:02 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id v9sm2605962pfe.1.2019.09.27.06.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 06:37:01 -0700 (PDT)
Subject: Re: [PATCH] vsock/virtio: add support for MSG_PEEK
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Matias Ezequiel Vara Larsen <matiasevara@gmail.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1569522214-28223-1-git-send-email-matiasevara@gmail.com>
 <f069a65d-33b9-1fa8-d26e-b76cc51fc7cb@gmail.com>
 <20190927085513.tdiofiisrpyehfe5@steredhat.homenet.telecomitalia.it>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a7a77f0b-a658-6e46-3381-3dfea55b14d1@gmail.com>
Date:   Fri, 27 Sep 2019 06:37:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927085513.tdiofiisrpyehfe5@steredhat.homenet.telecomitalia.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/19 1:55 AM, Stefano Garzarella wrote:

> Good catch!
> 
> Maybe we can solve in this way:
> 
> 	list_for_each_entry(pkt, &vvs->rx_queue, list) {
> 		size_t off = pkt->off;
> 
> 		if (total == len)
> 			break;
> 
> 		while (total < len && off < pkt->len) {
> 			/* using 'off' instead of 'pkt->off' */
> 			...
> 
> 			total += bytes;
> 			off += bytes;
> 		}
> 	}
> 
> What do you think?
>

Maybe, but I need to see a complete patch, evil is in the details :)

