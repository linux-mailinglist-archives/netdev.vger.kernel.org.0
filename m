Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6BD2C13D0
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388053AbgKWSnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbgKWSnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 13:43:45 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7040C0613CF;
        Mon, 23 Nov 2020 10:43:44 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a186so176644wme.1;
        Mon, 23 Nov 2020 10:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JSJ4Bmt8TgArHN7URL0MJIhGLyKv+yFMNwC10tsqJE0=;
        b=L9VLu9ERSvzEcDkaQCZQNPeL4KOS/8yz1HuC3+Id6cad8yv1Ggq8A57wGfeHsv0zWC
         dDfHJ+lY9iSc5FjqSHiEYot4Llke7tCge6J5B6cJhgHqOGmH5ZubTCJqpIR6Gr66kIb8
         DaFUrj65tzhrvMP9BEUUH1xRSNH18vYi9Rp9K8OsxDastX7Xyx+C0HmpMbYKbpHWOdji
         imtcPIBzs2dDy2b8c5KTI1O7rwXf7r/A0CBq0NlRjYPlPHdIMM1xRB8NDGvvV4Lv86EF
         fGZaWL5lLKpQg/ul/QNUhxll188redZ5n8lj5Kcxg4ULCpjRH4ZktZQU7Hkcgo5CJYTu
         FjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JSJ4Bmt8TgArHN7URL0MJIhGLyKv+yFMNwC10tsqJE0=;
        b=iRkT68MVoSGNXiPMPekfWN6xDdh8p6R54Z4rI9eR+oED/CzG6g7G9DCwfd5N5XiWTW
         2cSkyYGPeEQGaNQdTm8JgO13nPtRvALQN9fIwtrtOButUJzqwzLWb3eu2X40bKwrZsaT
         niTOb1Bk3G6jS1AjGKFOJd9mmv1sIin0aayILxr6IIZoeZahBWsCn7UZ+D2VHc+x9Qs4
         PdWxFrSdqyeDL0sABt+Sjcg5VyYQTYeg5HaUadQRt4gOJ7N4SBFWNy/2JvwdQ2LWbSIq
         QH3NSs0Ro8m+7UATq/lYrr41CrVJL+mF/WX12hKF9tLpWncsfMyCHC0wAZLtMbGAw8sO
         ezvQ==
X-Gm-Message-State: AOAM533Rl+o1D10W+f1Mp3v4vHpN9laNY63dKcov8F6PQhPr/x16U0/S
        jyQVOghYZ+N/YLhZb7bEjFSeX6qpsuA=
X-Google-Smtp-Source: ABdhPJwYntDq6XM1iixkuMsKc9NUdSPNoR2jX0jDaHuEUC+PrFvxZ21fKFq+gtjhY1zwLsTTDpSFnQ==
X-Received: by 2002:a1c:55ca:: with SMTP id j193mr245493wmb.87.1606157023020;
        Mon, 23 Nov 2020 10:43:43 -0800 (PST)
Received: from [192.168.8.114] ([37.173.143.196])
        by smtp.gmail.com with ESMTPSA id d8sm314725wmb.11.2020.11.23.10.43.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 10:43:42 -0800 (PST)
Subject: Re: [PATCH v8] tcp: fix race condition when creating child sockets
 from syncookies
To:     Ricardo Dias <rdias@singlestore.com>, davem@davemloft.net,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201120111133.GA67501@rdias-suse-pc.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7eedbc3b-e041-0eec-f015-1583ef4ae2f7@gmail.com>
Date:   Mon, 23 Nov 2020 19:43:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201120111133.GA67501@rdias-suse-pc.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/20 12:11 PM, Ricardo Dias wrote:
> When the TCP stack is in SYN flood mode, the server child socket is
> created from the SYN cookie received in a TCP packet with the ACK flag
> set.
> 
> The child socket is created when the server receives the first TCP
> packet with a valid SYN cookie from the client. Usually, this packet
> corresponds to the final step of the TCP 3-way handshake, the ACK
> packet. But is also possible to receive a valid SYN cookie from the
> first TCP data packet sent by the client, and thus create a child socket
> from that SYN cookie.
> 
> Since a client socket is ready to send data as soon as it receives the
> SYN+ACK packet from the server, the client can send the ACK packet (sent
> by the TCP stack code), and the first data packet (sent by the userspace
> program) almost at the same time, and thus the server will equally
> receive the two TCP packets with valid SYN cookies almost at the same
> instant.
> 
> When such event happens, the TCP stack code has a race condition that
> occurs between the momement a lookup is done to the established
> connections hashtable to check for the existence of a connection for the
> same client, and the moment that the child socket is added to the
> established connections hashtable. As a consequence, this race condition
> can lead to a situation where we add two child sockets to the
> established connections hashtable and deliver two sockets to the
> userspace program to the same client.
> 
> This patch fixes the race condition by checking if an existing child
> socket exists for the same client when we are adding the second child
> socket to the established connections socket. If an existing child
> socket exists, we drop the packet and discard the second child socket
> to the same client.
> 
> Signed-off-by: Ricardo Dias <rdias@singlestore.com>

Ok, lets keep this version, thanks !

Signed-off-by: Eric Dumazet <edumazet@google.com>

